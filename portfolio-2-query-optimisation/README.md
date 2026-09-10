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
## Repeated Benchmark Results

To reduce the effect of one-off execution timing and database caching, the reporting query was executed 10 times before indexing and 10 times after indexing.

| Configuration | Runs | Average | Minimum | Maximum |
|---|---:|---:|---:|---:|
| Before index | 10 | 9.932 ms | 5.720 ms | 37.410 ms |
| After index | 10 | 1.849 ms | 1.474 ms | 3.292 ms |

The repeated benchmark produced an average execution-time reduction of approximately 81.38%. This supports the original `EXPLAIN ANALYZE` result and demonstrates that the composite index provides a consistent improvement rather than relying on a single measurement.

The benchmark implementation and captured output are available in:

- `repeated-benchmark.sql`
- `repeated-benchmark-results.txt`