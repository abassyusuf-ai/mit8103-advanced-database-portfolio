-- MIT 8103 Advanced Database Systems
-- Portfolio 2: Query Performance Before Optimisation

\timing on

DROP INDEX IF EXISTS idx_orders_branch_ordered_at;

ANALYZE orders;
ANALYZE order_items;

\echo 'EXECUTION PLAN BEFORE OPTIMISATION'

EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT
    b.branch_name,
    o.ordered_at::DATE AS order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.line_total) AS total_revenue
FROM orders o
JOIN branches b
    ON b.branch_id = o.branch_id
JOIN order_items oi
    ON oi.order_id = o.order_id
WHERE o.branch_id = 1
  AND o.ordered_at >= TIMESTAMPTZ '2026-01-01 00:00:00+01'
  AND o.ordered_at < TIMESTAMPTZ '2026-01-08 00:00:00+01'
GROUP BY
    b.branch_name,
    o.ordered_at::DATE
ORDER BY
    order_date;

\echo 'QUERY RESULT BEFORE OPTIMISATION'

SELECT
    b.branch_name,
    o.ordered_at::DATE AS order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.line_total) AS total_revenue
FROM orders o
JOIN branches b
    ON b.branch_id = o.branch_id
JOIN order_items oi
    ON oi.order_id = o.order_id
WHERE o.branch_id = 1
  AND o.ordered_at >= TIMESTAMPTZ '2026-01-01 00:00:00+01'
  AND o.ordered_at < TIMESTAMPTZ '2026-01-08 00:00:00+01'
GROUP BY
    b.branch_name,
    o.ordered_at::DATE
ORDER BY
    order_date;