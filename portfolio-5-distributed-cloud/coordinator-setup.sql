\echo 'CONFIGURING DISTRIBUTED DATABASE COORDINATOR'

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP VIEW IF EXISTS all_branch_orders;
DROP FOREIGN TABLE IF EXISTS remote_branch_orders;
DROP SERVER IF EXISTS branch_server CASCADE;
DROP TABLE IF EXISTS local_orders;

CREATE TABLE local_orders (
    order_id BIGINT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    customer_name VARCHAR(120) NOT NULL,
    order_date DATE NOT NULL,
    order_total NUMERIC(12,2) NOT NULL CHECK (order_total >= 0)
);

INSERT INTO local_orders
    (order_id, branch_name, customer_name, order_date, order_total)
VALUES
    (1001, 'Abuja Central Branch', 'Ibrahim Ahmed', '2026-08-01', 350000.00),
    (1002, 'Abuja Central Branch', 'Ngozi Williams', '2026-08-02', 680000.00),
    (1003, 'Abuja Central Branch', 'Bola Yusuf', '2026-08-03', 425000.00),
    (1004, 'Abuja Central Branch', 'Mary James', '2026-08-04', 560000.00),
    (1005, 'Abuja Central Branch', 'David Obi', '2026-08-05', 795000.00);

CREATE SERVER branch_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (
        host 'branch_node',
        port '5432',
        dbname 'distributed_retail'
    );

CREATE USER MAPPING FOR mit8103
    SERVER branch_server
    OPTIONS (
        user 'fdw_reader',
        password :'fdw_password'
    );

CREATE FOREIGN TABLE remote_branch_orders (
    order_id BIGINT,
    branch_name VARCHAR(100),
    customer_name VARCHAR(120),
    order_date DATE,
    order_total NUMERIC(12,2)
)
SERVER branch_server
OPTIONS (
    schema_name 'public',
    table_name 'branch_orders'
);

CREATE VIEW all_branch_orders AS
SELECT
    order_id,
    branch_name,
    customer_name,
    order_date,
    order_total,
    'Coordinator node'::TEXT AS data_location
FROM local_orders

UNION ALL

SELECT
    order_id,
    branch_name,
    customer_name,
    order_date,
    order_total,
    'Remote branch node'::TEXT AS data_location
FROM remote_branch_orders;

\echo 'DISTRIBUTED QUERY RESULTS'

SELECT
    branch_name,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_revenue
FROM all_branch_orders
GROUP BY branch_name
ORDER BY branch_name;

\echo 'DISTRIBUTED DATABASE SUMMARY'

SELECT
    COUNT(*) AS distributed_orders,
    SUM(order_total) AS distributed_revenue
FROM all_branch_orders;