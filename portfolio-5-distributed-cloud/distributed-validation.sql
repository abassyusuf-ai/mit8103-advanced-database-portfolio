\timing on

\echo 'TEST 1: DATA DISTRIBUTION ACROSS NODES'

SELECT
    data_location,
    COUNT(*) AS order_count,
    SUM(order_total) AS revenue
FROM all_branch_orders
GROUP BY data_location
ORDER BY data_location;

\echo 'TEST 2: REMOTE FOREIGN TABLE ACCESS'

SELECT
    order_id,
    branch_name,
    order_total
FROM remote_branch_orders
ORDER BY order_id;

\echo 'TEST 3: DISTRIBUTED TOTAL CONSISTENCY'

SELECT
    CASE
        WHEN COUNT(*) = 10
         AND SUM(order_total) = 5480500.00
        THEN 'TEST PASSED'
        ELSE 'TEST FAILED'
    END AS distributed_total_test
FROM all_branch_orders;

\echo 'TEST 4: ORDER IDENTIFIERS ARE UNIQUE ACROSS BOTH NODES'

SELECT
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids
FROM all_branch_orders;

\echo 'TEST 5: FOREIGN QUERY EXECUTION PLAN'

EXPLAIN (ANALYZE, VERBOSE)
SELECT
    order_id,
    customer_name,
    order_total
FROM remote_branch_orders
WHERE order_total >= 500000.00;

\echo 'TEST 6: DISTRIBUTED REVENUE BY BRANCH'

SELECT
    branch_name,
    COUNT(*) AS total_orders,
    SUM(order_total) AS total_revenue
FROM all_branch_orders
GROUP BY branch_name
ORDER BY branch_name;

\echo 'ALL DISTRIBUTED DATABASE TESTS COMPLETED'