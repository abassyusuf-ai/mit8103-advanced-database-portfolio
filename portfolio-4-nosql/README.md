# Portfolio 4: NoSQL and Advanced Data Models

## Student

Yusuf Abbas

## Objective

This portfolio demonstrates document database design, schema validation, flexible data modelling, querying and index optimisation using MongoDB 7.

## Database Design

The `retail_catalog` database contains a `products` collection. Each product is stored as a document containing:

- Unique SKU
- Product name
- Category
- Price
- Flexible product attributes
- Tags
- Creation date

The embedded `attributes` object allows products from different categories to store different characteristics without requiring identical columns.

## Schema Validation

MongoDB JSON Schema validation was configured to enforce:

- Required product fields
- Valid product categories
- Nonnegative prices
- Correct field data types
- Valid dates and arrays

A unique index on `sku` prevents duplicate product identifiers.

The validation tests confirmed that:

- Negative prices were rejected
- Duplicate SKUs were rejected
- Valid flexible attributes were accepted
- All NoSQL validation tests completed successfully

## Initial Dataset

The original catalogue contains 10 products covering:

- Computers
- Mobile Devices
- Accessories
- Networking

## Query Demonstrations

The queries demonstrate:

- Filtering by embedded attributes
- Filtering by tags
- Product aggregation by category
- Average and total price calculations
- Flexible product attributes
- Schema-validation rejection
- Unique-index enforcement

## Performance Dataset

An additional 5,000 documents were generated for performance testing.

| Dataset | Documents |
|---|---:|
| Original products | 10 |
| Performance products | 5,000 |
| Total products | 5,010 |

## Index Optimisation

The performance query searched for black products in the `Mobile Devices` category.

### Before optimisation

The query used a collection scan.

| Metric | Result |
|---|---:|
| Plan stage | COLLSCAN |
| Documents examined | 5,010 |
| Index keys examined | 0 |
| Documents returned | 251 |
| Execution time | 2 ms |

### Index created

```javascript
db.products.createIndex(
    {
        category: 1,
        "attributes.colour": 1
    },
    {
        name: "category_colour_index"
    }
);
## Repeated MongoDB Benchmark

The indexed query was executed 200 times before indexing and 200 times after indexing to provide more reliable performance evidence.

| Configuration | Runs | Total time | Average time |
|---|---:|---:|---:|
| Before index | 200 | 1,645 ms | 8.225 ms |
| After index | 200 | 1,061 ms | 5.305 ms |

The repeated test measured a 35.5% average execution-time improvement.

This supports the execution-plan analysis, which showed that the compound index changed the query from `COLLSCAN` to `IXSCAN` and reduced documents examined from 5,010 to 251, approximately a 95% reduction.

The benchmark evidence is available in:

- `repeated-index-benchmark.js`
- `repeated-index-benchmark-results.txt`