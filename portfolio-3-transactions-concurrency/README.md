# Portfolio 3: Transactions and Concurrency

## Objective

This activity demonstrates atomic transactions, rollback behaviour, row-level locking and concurrent database access using PostgreSQL.

## Business Scenario

The system transfers product inventory between retail branches. A valid transfer must:

- Reduce inventory at the source branch
- Increase inventory at the destination branch
- Reject invalid or excessive quantities
- Roll back the entire operation if any step fails
- Prevent concurrent transactions from overwriting one another
- Preserve the total quantity of inventory

## Atomic Transfer Function

The `transfer_inventory()` function accepts:

- Source branch
- Destination branch
- Product
- Transfer quantity

The function validates the input, locks the relevant inventory records and performs both inventory updates as one atomic operation.

## Locking Strategy

The function uses:

```sql
SELECT ...
ORDER BY branch_id
FOR UPDATE;
## Isolation Level and Deadlock Prevention

PostgreSQL reported the transaction isolation level as `READ COMMITTED`. Under this isolation level, each statement reads committed data while row-level locks prevent concurrent transactions from modifying the same inventory records simultaneously.

The `transfer_inventory` function locks the source and destination records using:

```sql
ORDER BY branch_id
FOR UPDATE