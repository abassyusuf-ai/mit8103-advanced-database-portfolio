    -- Session B: Attempts to update the same inventory rows

\timing on

\echo 'SESSION B STARTED'

SELECT
    clock_timestamp() AS session_b_start_time;

BEGIN;

SELECT transfer_inventory(
    1,
    2,
    1,
    7
);

COMMIT;

SELECT
    clock_timestamp() AS session_b_finish_time;

SELECT
    branch_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

\echo 'SESSION B COMPLETED'