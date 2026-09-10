# Portfolio 1: Database Design and Modelling

## Objective

The objective of this activity was to design and implement a relational database for a multi-branch retail order and inventory management system.

## Business Requirements

The database must support:

- Multiple retail branches
- Registered customers
- Product categories and products
- Product inventory across different branches
- Customer orders
- Multiple products within an order
- Payment records
- Data integrity and validation

## Database Tables

| Table | Purpose |
|---|---|
| `branches` | Stores branch locations |
| `customers` | Stores customer information |
| `categories` | Classifies products |
| `products` | Stores products and current prices |
| `inventory` | Records product quantities for each branch |
| `orders` | Stores customer orders |
| `order_items` | Records the products included in each order |
| `payments` | Stores order payment information |

## Design Decisions

### Primary Keys

Identity-based primary keys were used for the main entities. The `inventory` table uses a composite primary key consisting of `branch_id` and `product_id`. The `order_items` table uses `order_id` and `product_id` as its composite primary key.

### Foreign Keys

Foreign-key constraints maintain relationships between the tables and prevent orphan records. Deleting an order automatically deletes its associated order items through `ON DELETE CASCADE`.

### Historical Pricing

The current product price is stored in `products.current_price`. The price charged during a transaction is separately stored in `order_items.unit_price`. This ensures that previous orders remain accurate when product prices change.

### Generated Values

The `line_total` column is generated automatically from:

```text
quantity × unit_price