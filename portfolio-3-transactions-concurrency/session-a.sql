-- Session A: Locks the inventory rows for 20 seconds

\timing on

\echo 'SESSION A STARTED'

BEGIN;

SELECT
    clock_timestamp() AS session_a_lock_time;

SELECT
    branch_id,
    product_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id
FOR UPDATE;

\echo 'SESSION A NOW HOLDS THE ROW LOCKS'

SELECT pg_sleep(60);

SELECT transfer_inventory(
    1,
    2,
    1,
    5
);

COMMIT;

SELECT
    clock_timestamp() AS session_a_commit_time;

SELECT
    branch_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

\echo 'SESSION A COMPLETED'
