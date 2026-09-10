-- MIT 8103 Advanced Database Systems
-- Portfolio 2: Performance Dataset Generation

\timing on

\echo 'Removing any previous performance-test data'

DELETE FROM orders
WHERE customer_id IN (
    SELECT customer_id
    FROM customers
    WHERE email LIKE 'perf.%@example.com'
);

DELETE FROM customers
WHERE email LIKE 'perf.%@example.com';

\echo 'Generating 20,000 performance-test customers'

INSERT INTO customers
(first_name, last_name, email, phone)
SELECT
    'Customer',
    'Performance' || series_number,
    'perf.' || series_number || '@example.com',
    '090' || LPAD(series_number::TEXT, 8, '0')
FROM generate_series(1, 20000) AS series_number;

\echo 'Generating 100,000 performance-test orders'

WITH performance_customers AS (
    SELECT
        customer_id,
        ROW_NUMBER() OVER (ORDER BY customer_id) AS row_number
    FROM customers
    WHERE email LIKE 'perf.%@example.com'
)
INSERT INTO orders
(customer_id, branch_id, order_status, ordered_at)
SELECT
    customer_id,
    1 + ((row_number + repetition) % 3),
    CASE ((row_number + repetition) % 4)
        WHEN 0 THEN 'COMPLETED'
        WHEN 1 THEN 'PAID'
        WHEN 2 THEN 'PROCESSING'
        ELSE 'PENDING'
    END,
    TIMESTAMPTZ '2025-01-01 08:00:00+01'
        + (((row_number * repetition) % 730) || ' days')::INTERVAL
        + ((repetition * 2) || ' hours')::INTERVAL
FROM performance_customers
CROSS JOIN generate_series(1, 5) AS repetition;

\echo 'Generating 300,000 performance-test order items'

INSERT INTO order_items
(order_id, product_id, quantity, unit_price)
SELECT
    selected_orders.order_id,
    products.product_id,
    1 + ((selected_orders.order_id + item_number) % 4),
    products.current_price
FROM (
    SELECT o.order_id
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
    WHERE c.email LIKE 'perf.%@example.com'
) AS selected_orders
CROSS JOIN generate_series(1, 3) AS item_number
JOIN products
    ON products.product_id =
       1 + ((selected_orders.order_id + (item_number * 3)) % 10);

ANALYZE customers;
ANALYZE orders;
ANALYZE order_items;

\echo 'Performance dataset summary'

SELECT
    (SELECT COUNT(*)
     FROM customers
     WHERE email LIKE 'perf.%@example.com')
        AS performance_customers,

    (SELECT COUNT(*)
     FROM orders o
     JOIN customers c
        ON c.customer_id = o.customer_id
     WHERE c.email LIKE 'perf.%@example.com')
        AS performance_orders,

    (SELECT COUNT(*)
     FROM order_items oi
     JOIN orders o
        ON o.order_id = oi.order_id
     JOIN customers c
        ON c.customer_id = o.customer_id
     WHERE c.email LIKE 'perf.%@example.com')
        AS performance_order_items;