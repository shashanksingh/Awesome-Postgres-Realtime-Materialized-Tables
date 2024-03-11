CREATE SCHEMA IF NOT EXISTS analytics;
-- TIP : Passwords would be encrypted and stored in key management services like AWS KMS and not in code base
CREATE USER event_ingestion WITH encrypted password 'password';

GRANT ALL PRIVILEGES ON schema analytics TO event_ingestion;

CREATE TABLE IF NOT EXISTS analytics.events
(
    id uuid DEFAULT gen_random_uuid(),
    event_name varchar(512),
    data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT url_primary_key PRIMARY KEY (id)
) ;


CREATE EXTENSION pg_ivm;
select * from create_immv(
  'analytics.event_count',
  'select count(*) from analytics.events'
);
select * from create_immv(
  'analytics.event_type_count',
  'select count(*), event_name from analytics.events  group by event_name '
);
ALTER TABLE analytics.event_type_count REPLICA IDENTITY DEFAULT;


-- dummy data
insert into analytics.events (event_name, data) values('CUSTOMER_VIEW', '{"title": "My first day at work", "Feeling": "Mixed feeling"}');
insert into analytics.events (event_name, data) values('CUSTOMER_VIEW', '{"title": "My second day at work", "Feeling": "Mixed feeling"}');

-- Load test
Insert into analytics.events (event_name, data)
select 'CUSTOMER_VIEW'||id, '{"title":"My first day "}'
from generate_series(1,10000) as t(id);

SELECT CLOCK_TIMESTAMP();

