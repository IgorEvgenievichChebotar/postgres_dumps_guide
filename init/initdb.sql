CREATE TABLE manufacturers
(
    manufacturer_id   SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);

CREATE TABLE categories
(
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products
(
    category_id     BIGINT CHECK (category_id >= 0) REFERENCES categories (category_id),
    manufacturer_id BIGINT CHECK (manufacturer_id >= 0) REFERENCES manufacturers (manufacturer_id),
    product_id      SERIAL PRIMARY KEY,
    product_name    VARCHAR(255) NOT NULL
);

CREATE TABLE stores
(
    store_id   SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL
);

CREATE TABLE customers
(
    customer_id    SERIAL PRIMARY KEY,
    customer_fname VARCHAR(100) NOT NULL,
    customer_lname VARCHAR(100) NOT NULL
);

CREATE TABLE price_change
(
    product_id      BIGINT        NOT NULL CHECK ( product_id >= 0 ) PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    price_change_ts TIMESTAMP     NOT NULL,
    new_price       NUMERIC(9, 2) NOT NULL
);

CREATE TABLE deliveries
(
    store_id      BIGINT CHECK ( store_id >= 0 ) REFERENCES stores (store_id),
    product_id    BIGINT  NOT NULL CHECK ( product_id >= 0 ) REFERENCES price_change (product_id),
    delivery_date DATE    NOT NULL,
    product_count INTEGER NOT NULL CHECK ( product_count >= 0 )
);

CREATE TABLE purchases
(
    store_id      BIGINT    NOT NULL CHECK ( store_id >= 0 ) REFERENCES stores (store_id),
    customer_id   BIGINT    NOT NULL CHECK ( customer_id >= 0 ) REFERENCES customers (customer_id),
    purchase_id   SERIAL PRIMARY KEY,
    purchase_date TIMESTAMP NOT NULL
);

CREATE TABLE purchase_items
(
    product_id    BIGINT        NOT NULL CHECK ( product_id >= 0 ) REFERENCES products (product_id),
    purchase_id   BIGINT        NOT NULL CHECK ( purchase_id >= 0 ) REFERENCES purchases (purchase_id),
    product_count BIGINT        NOT NULL CHECK ( product_count >= 0 ),
    product_price NUMERIC(9, 2) NOT NULL
);

COPY manufacturers (manufacturer_id,
                    manufacturer_name)
    FROM '/var/lib/postgresql/data/manufacturers.csv' DELIMITER ',' CSV HEADER;

COPY categories (category_id,
                 category_name)
    FROM '/var/lib/postgresql/data/categories.csv' DELIMITER ',' CSV HEADER;

COPY products (product_id, category_id, manufacturer_id, product_name)
    FROM '/var/lib/postgresql/data/products.csv' DELIMITER ',' CSV HEADER;

COPY stores (store_id, store_name)
    FROM '/var/lib/postgresql/data/stores.csv' DELIMITER ',' CSV HEADER;

COPY customers (customer_id, customer_fname, customer_lname)
    FROM '/var/lib/postgresql/data/customers.csv' DELIMITER ',' CSV HEADER;

COPY price_change (product_id, price_change_ts, new_price)
    FROM '/var/lib/postgresql/data/price_change.csv' DELIMITER ',' CSV HEADER;

COPY deliveries (store_id, product_id, delivery_date, product_count)
    FROM '/var/lib/postgresql/data/deliveries.csv' DELIMITER ',' CSV HEADER;

COPY purchases (purchase_id, store_id, customer_id, purchase_date)
    FROM '/var/lib/postgresql/data/purchases.csv' DELIMITER ',' CSV HEADER;

COPY purchase_items (product_id, purchase_id, product_count, product_price)
    FROM '/var/lib/postgresql/data/purchase_items.csv' DELIMITER ',' CSV HEADER;