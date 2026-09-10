-- MIT 8103 Advanced Database Systems
-- Portfolio 1: Database Design and Modelling
-- Case Study: Multi-Branch Retail Order and Inventory System

DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

CREATE TABLE branches (
    branch_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(80) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(30) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id BIGINT NOT NULL,
    sku VARCHAR(40) NOT NULL UNIQUE,
    product_name VARCHAR(150) NOT NULL,
    current_price NUMERIC(12,2) NOT NULL CHECK (current_price >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

CREATE TABLE inventory (
    branch_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    reorder_level INTEGER NOT NULL DEFAULT 10 CHECK (reorder_level >= 0),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (branch_id, product_id),

    CONSTRAINT fk_inventory_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id),

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    branch_id BIGINT NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    ordered_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_order_status
        CHECK (order_status IN (
            'PENDING',
            'PAID',
            'PROCESSING',
            'COMPLETED',
            'CANCELLED'
        )),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    line_total NUMERIC(14,2)
        GENERATED ALWAYS AS (quantity * unit_price) STORED,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    transaction_reference VARCHAR(100) NOT NULL UNIQUE,
    paid_at TIMESTAMPTZ,

    CONSTRAINT chk_payment_method
        CHECK (payment_method IN (
            'CARD',
            'TRANSFER',
            'CASH',
            'MOBILE_MONEY'
        )),

    CONSTRAINT chk_payment_status
        CHECK (payment_status IN (
            'PENDING',
            'SUCCESSFUL',
            'FAILED',
            'REFUNDED'
        )),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

COMMENT ON TABLE branches IS
'Physical branches where orders are processed and inventory is held';

COMMENT ON TABLE order_items IS
'Associative table resolving the many-to-many relationship between orders and products';

COMMENT ON COLUMN order_items.unit_price IS
'Product price recorded at the time of the transaction';