\timing off

DROP TABLE IF EXISTS benchmark_results;

CREATE TEMP TABLE benchmark_results (
    configuration VARCHAR(20),
    run_number INTEGER,
    execution_time_ms NUMERIC(12,3)
);

\echo 'REPEATED BENCHMARK BEFORE INDEX'

DROP INDEX IF EXISTS idx_orders_branch_ordered_at;

DO $$
DECLARE
    run_counter INTEGER;
    start_time TIMESTAMPTZ;
    finish_time TIMESTAMPTZ;
BEGIN
    FOR run_counter IN 1..10 LOOP
        start_time := clock_timestamp();

        PERFORM
            b.branch_name,
            o.ordered_at::DATE,
            COUNT(DISTINCT o.order_id),
            SUM(oi.line_total)
        FROM branches b
        JOIN orders o
            ON o.branch_id = b.branch_id
        JOIN order_items oi
            ON oi.order_id = o.order_id
        WHERE b.branch_id = 1
          AND o.ordered_at >= '2026-01-01'
          AND o.ordered_at < '2026-01-08'
        GROUP BY
            b.branch_name,
            o.ordered_at::DATE;

        finish_time := clock_timestamp();

        INSERT INTO benchmark_results
        VALUES (
            'Before index',
            run_counter,
            EXTRACT(EPOCH FROM (finish_time - start_time)) * 1000
        );
    END LOOP;
END
$$;

\echo 'REPEATED BENCHMARK AFTER INDEX'

CREATE INDEX idx_orders_branch_ordered_at
ON orders (branch_id, ordered_at);

ANALYZE orders;

DO $$
DECLARE
    run_counter INTEGER;
    start_time TIMESTAMPTZ;
    finish_time TIMESTAMPTZ;
BEGIN
    FOR run_counter IN 1..10 LOOP
        start_time := clock_timestamp();

        PERFORM
            b.branch_name,
            o.ordered_at::DATE,
            COUNT(DISTINCT o.order_id),
            SUM(oi.line_total)
        FROM branches b
        JOIN orders o
            ON o.branch_id = b.branch_id
        JOIN order_items oi
            ON oi.order_id = o.order_id
        WHERE b.branch_id = 1
          AND o.ordered_at >= '2026-01-01'
          AND o.ordered_at < '2026-01-08'
        GROUP BY
            b.branch_name,
            o.ordered_at::DATE;

        finish_time := clock_timestamp();

        INSERT INTO benchmark_results
        VALUES (
            'After index',
            run_counter,
            EXTRACT(EPOCH FROM (finish_time - start_time)) * 1000
        );
    END LOOP;
END
$$;

\echo 'INDIVIDUAL BENCHMARK RESULTS'

SELECT
    configuration,
    run_number,
    execution_time_ms
FROM benchmark_results
ORDER BY configuration DESC, run_number;

\echo 'BENCHMARK SUMMARY'

SELECT
    configuration,
    COUNT(*) AS runs,
    ROUND(AVG(execution_time_ms), 3) AS average_ms,
    ROUND(MIN(execution_time_ms), 3) AS minimum_ms,
    ROUND(MAX(execution_time_ms), 3) AS maximum_ms
FROM benchmark_results
GROUP BY configuration
ORDER BY configuration DESC;

\echo 'REPEATED BENCHMARK COMPLETED'