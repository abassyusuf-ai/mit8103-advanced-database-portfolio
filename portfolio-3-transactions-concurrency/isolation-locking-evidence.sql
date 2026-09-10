\timing on

\echo 'TEST 1: TRANSACTION ISOLATION LEVEL'

SHOW transaction_isolation;

\echo 'TEST 2: TRANSFER FUNCTION DEFINITION'

SELECT pg_get_functiondef(oid)
FROM pg_proc
WHERE proname = 'transfer_inventory';

\echo 'TEST 3: CONSISTENT ROW-LOCK ORDER'

BEGIN;

SELECT
    branch_id,
    product_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id
FOR UPDATE;

\echo 'TEST 4: LOCKS HELD BY CURRENT TRANSACTION'

SELECT
    locktype,
    mode,
    granted
FROM pg_locks
WHERE pid = pg_backend_pid()
  AND granted = TRUE
ORDER BY locktype, mode;

ROLLBACK;

\echo 'TEST 5: INVENTORY REMAINS CONSISTENT AFTER ROLLBACK'

SELECT
    branch_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

SELECT
    SUM(quantity) AS total_inventory
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2);

\echo 'ISOLATION AND LOCKING TESTS COMPLETED'