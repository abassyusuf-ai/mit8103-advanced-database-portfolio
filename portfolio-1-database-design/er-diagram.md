# Entity Relationship Diagram

```mermaid
erDiagram
    BRANCHES {
        BIGINT branch_id PK
        VARCHAR branch_name UK
        VARCHAR city
        TEXT address
        TIMESTAMPTZ created_at
    }

    CUSTOMERS {
        BIGINT customer_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR email UK
        VARCHAR phone UK
        TIMESTAMPTZ created_at
    }

    CATEGORIES {
        BIGINT category_id PK
        VARCHAR category_name UK
        TEXT description
    }

    PRODUCTS {
        BIGINT product_id PK
        BIGINT category_id FK
        VARCHAR sku UK
        VARCHAR product_name
        NUMERIC current_price
        BOOLEAN is_active
        TIMESTAMPTZ created_at
    }

    INVENTORY {
        BIGINT branch_id PK,FK
        BIGINT product_id PK,FK
        INTEGER quantity
        INTEGER reorder_level
        TIMESTAMPTZ updated_at
    }

    ORDERS {
        BIGINT order_id PK
        BIGINT customer_id FK
        BIGINT branch_id FK
        VARCHAR order_status
        TIMESTAMPTZ ordered_at
    }

    ORDER_ITEMS {
        BIGINT order_id PK,FK
        BIGINT product_id PK,FK
        INTEGER quantity
        NUMERIC unit_price
        NUMERIC line_total
    }

    PAYMENTS {
        BIGINT payment_id PK
        BIGINT order_id FK
        NUMERIC amount
        VARCHAR payment_method
        VARCHAR payment_status
        VARCHAR transaction_reference UK
        TIMESTAMPTZ paid_at
    }

    CATEGORIES ||--o{ PRODUCTS : classifies
    BRANCHES ||--o{ INVENTORY : holds
    PRODUCTS ||--o{ INVENTORY : stocked_as
    CUSTOMERS ||--o{ ORDERS : places
    BRANCHES ||--o{ ORDERS : processes
    ORDERS ||--|{ ORDER_ITEMS : contains
    PRODUCTS ||--o{ ORDER_ITEMS : appears_in
    ORDERS ||--o{ PAYMENTS : receives
```

## Relationship Summary

- One category can classify many products.
- A branch can hold many products through the inventory table.
- A product can be stocked in many branches.
- One customer can place many orders.
- One branch can process many orders.
- An order contains one or more order items.
- A product can appear in many order items.
- An order can receive one or more payment records.