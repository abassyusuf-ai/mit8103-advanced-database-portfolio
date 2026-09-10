\echo 'CONFIGURING REMOTE BRANCH NODE'

DROP TABLE IF EXISTS branch_orders;
DROP ROLE IF EXISTS fdw_reader;

CREATE TABLE branch_orders (
    order_id BIGINT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    customer_name VARCHAR(120) NOT NULL,
    order_date DATE NOT NULL,
    order_total NUMERIC(12,2) NOT NULL CHECK (order_total >= 0)
);

INSERT INTO branch_orders
    (order_id, branch_name, customer_name, order_date, order_total)
VALUES
    (2001, 'Lagos Island Branch', 'Amina Bello', '2026-08-01', 485000.00),
    (2002, 'Lagos Island Branch', 'Chinedu Okafor', '2026-08-02', 720000.00),
    (2003, 'Lagos Island Branch', 'Fatima Musa', '2026-08-03', 315500.00),
    (2004, 'Lagos Island Branch', 'Tunde Adeyemi', '2026-08-04', 910000.00),
    (2005, 'Lagos Island Branch', 'Grace Eze', '2026-08-05', 240000.00);

CREATE ROLE fdw_reader
    LOGIN
    PASSWORD :'fdw_password';
    
GRANT CONNECT ON DATABASE distributed_retail TO fdw_reader;
GRANT USAGE ON SCHEMA public TO fdw_reader;
GRANT SELECT ON branch_orders TO fdw_reader;

\echo 'REMOTE BRANCH NODE CONFIGURED'

SELECT
    COUNT(*) AS remote_orders,
    SUM(order_total) AS remote_revenue
FROM branch_orders;