# Note: the module name is psycopg, not psycopg3
import psycopg

# Connect to an existing database
with psycopg.connect("postgres://username:password@postgres:5432/warehouse?sslmode=disable") as conn:
    with conn.cursor() as cur:
        for number in range(0, 10000):
            cur.execute(
                """ INSERT INTO analytics.events (event_name, data) 
               VALUES('CUSTOMER_VIEW', '{"title": "%s", "Feeling": "Mixed feeling"}');""",
                (number))
            conn.commit()
