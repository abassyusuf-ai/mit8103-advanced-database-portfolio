# Portfolio 2: Query Processing and Optimisation

## Objective

The objective was to measure and improve the performance of a branch revenue-reporting query using PostgreSQL execution plans and indexing.

## Performance Dataset

A larger dataset was generated to make query-performance differences measurable.

| Record type | Generated records |
|---|---:|
| Customers | 20,000 |
| Orders | 100,000 |
| Order items | 300,000 |

The dataset was generated using PostgreSQL `generate_series()` and analysed using the `ANALYZE` command.

## Test Query

The test query calculates daily order counts and total revenue for the Abuja branch within a seven-day period.

The query joins:

- `branches`
- `orders`
- `order_items`

It also uses filtering, grouping, sorting, `COUNT(DISTINCT)` and `SUM`.

## Baseline Execution

The baseline query was executed without a composite index on the branch and order-date columns.

| Measurement | Baseline result |
|---|---:|
| Planning time | 1.866 ms |
| Execution time | 7.741 ms |
| Result rows | 7 |

## Optimisation Applied

The following composite B-tree index was created:

```sql
CREATE INDEX idx_orders_branch_ordered_at
ON orders (branch_id, ordered_at);