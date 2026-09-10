-- MIT 8103 Advanced Database Systems
-- Portfolio 3: Transaction and Rollback Tests

\timing on

\echo 'RESETTING TEST INVENTORY'

UPDATE inventory
SET quantity =
    CASE
        WHEN branch_id = 1 THEN 100
        WHEN branch_id = 2 THEN 50
        ELSE quantity
    END
WHERE product_id = 1
  AND branch_id IN (1, 2);

\echo 'TEST 1: VALUES BEFORE SUCCESSFUL TRANSFER'

SELECT
    branch_id,
    product_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

\echo 'TEST 2: TRANSFER 10 UNITS INSIDE A TRANSACTION'

BEGIN;

SELECT transfer_inventory(
    1,
    2,
    1,
    10
);

COMMIT;

\echo 'VALUES AFTER SUCCESSFUL TRANSFER'

SELECT
    branch_id,
    product_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

\echo 'TEST 3: TOTAL INVENTORY MUST REMAIN 150'

SELECT
    SUM(quantity) AS total_inventory
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2);

\echo 'TEST 4: FAILED TRANSFER MUST ROLL BACK'

CREATE TEMP TABLE transaction_test_results (
    result TEXT NOT NULL
);

DO $$
BEGIN
    BEGIN
        PERFORM transfer_inventory(
            1,
            2,
            1,
            500
        );

        INSERT INTO transaction_test_results
        VALUES (
            'TEST FAILED: Excessive transfer was accepted'
        );

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO transaction_test_results
            VALUES (
                'TEST PASSED: Excessive transfer was rejected and rolled back'
            );
    END;
END
$$;

SELECT result
FROM transaction_test_results;

\echo 'VALUES AFTER FAILED TRANSFER'

SELECT
    branch_id,
    product_id,
    quantity
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2)
ORDER BY branch_id;

\echo 'FINAL INVENTORY TOTAL'

SELECT
    SUM(quantity) AS total_inventory
FROM inventory
WHERE product_id = 1
  AND branch_id IN (1, 2);

\echo 'ALL TRANSACTION TESTS COMPLETED'