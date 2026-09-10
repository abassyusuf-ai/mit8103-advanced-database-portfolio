-- MIT 8103 Advanced Database Systems
-- Portfolio 1: Data Integrity Validation

\echo 'TEST 1: Record counts'

SELECT
    (SELECT COUNT(*) FROM branches) AS branches,
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM inventory) AS inventory_records,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM payments) AS payments;

\echo 'TEST 2: Orphan foreign-key records must be zero'

SELECT
    (SELECT COUNT(*)
     FROM products p
     LEFT JOIN categories c
        ON c.category_id = p.category_id
     WHERE c.category_id IS NULL) AS orphan_products,

    (SELECT COUNT(*)
     FROM orders o
     LEFT JOIN customers c
        ON c.customer_id = o.customer_id
     WHERE c.customer_id IS NULL) AS orphan_order_customers,

    (SELECT COUNT(*)
     FROM order_items oi
     LEFT JOIN orders o
        ON o.order_id = oi.order_id
     WHERE o.order_id IS NULL) AS orphan_order_items;

\echo 'TEST 3: Invalid numeric values must be zero'

SELECT
    (SELECT COUNT(*)
     FROM inventory
     WHERE quantity < 0) AS negative_inventory,

    (SELECT COUNT(*)
     FROM order_items
     WHERE quantity <= 0) AS invalid_order_quantities,

    (SELECT COUNT(*)
     FROM products
     WHERE current_price < 0) AS negative_prices;

\echo 'TEST 4: Duplicate unique values must be zero'

SELECT
    (SELECT COUNT(*)
     FROM (
        SELECT email
        FROM customers
        GROUP BY email
        HAVING COUNT(*) > 1
     ) duplicates) AS duplicate_emails,

    (SELECT COUNT(*)
     FROM (
        SELECT sku
        FROM products
        GROUP BY sku
        HAVING COUNT(*) > 1
     ) duplicates) AS duplicate_skus;

\echo 'TEST 5: Generated line totals'

SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    line_total
FROM order_items
ORDER BY order_id, product_id
LIMIT 5;

\echo 'TEST 6: CHECK constraint rejection'

CREATE TEMP TABLE validation_test_results (
    result TEXT NOT NULL
);

DO $$
BEGIN
    BEGIN
        INSERT INTO order_items
            (order_id, product_id, quantity, unit_price)
        VALUES
            (1, 3, 0, 550000.00);

        INSERT INTO validation_test_results
        VALUES ('TEST FAILED: Invalid quantity was accepted');

    EXCEPTION
        WHEN check_violation THEN
            INSERT INTO validation_test_results
            VALUES ('TEST PASSED: Quantity of zero was rejected');
    END;
END
$$;

SELECT result
FROM validation_test_results;

\echo 'ALL VALIDATION TESTS COMPLETED'