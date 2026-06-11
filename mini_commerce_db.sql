CREATE DATABASE mini_commerce_db;
USE mini_commerce_db;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

INSERT INTO Users (first_name, last_name, email)
VALUES
('Amanda', 'McIntire', 'amanda@email.com'),
('Wanda', 'Maximoff', 'wanda@email.com'),
('Peter', 'Parker', 'peter@email.com');

INSERT INTO Products (product_name, price, stock_quantity)
VALUES
('Laptop', 899.99, 10),
('Wireless Mouse', 24.99, 50),
('Keyboard', 49.99, 35),
('Monitor', 199.99, 20),
('USB-C Cable', 12.99, 100);

INSERT INTO Orders (user_id, order_date)
VALUES
(1, '2026-06-01 10:30:00'),
(1, '2026-06-02 11:15:00'),
(1, '2026-06-03 14:45:00'),
(1, '2026-06-04 09:20:00'),
(2, '2026-06-05 16:10:00'),
(3, '2026-06-06 13:00:00');

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase)
VALUES
(1, 1, 1, 899.99),
(1, 2, 2, 24.99),
(2, 3, 1, 49.99),
(2, 5, 3, 12.99),
(3, 4, 1, 199.99),
(4, 2, 1, 24.99),
(4, 5, 2, 12.99),
(5, 3, 2, 49.99),
(6, 1, 1, 899.99),
(6, 4, 2, 199.99);

-- Queries

SELECT 
    Orders.order_id,
    Users.first_name,
    Users.last_name,
    Orders.order_date
FROM Orders
JOIN Users
    ON Orders.user_id = Users.user_id
WHERE Users.user_id = 1;

SELECT 
    Orders.order_id,
    Products.product_name,
    Order_Items.quantity,
    Order_Items.price_at_purchase
FROM Order_Items
JOIN Orders
    ON Order_Items.order_id = Orders.order_id
JOIN Products
    ON Order_Items.product_id = Products.product_id
WHERE Orders.order_id = 1;

SELECT 
    Orders.order_id,
    SUM(Order_Items.quantity * Order_Items.price_at_purchase) AS total_order_value
FROM Orders
JOIN Order_Items
    ON Orders.order_id = Order_Items.order_id
WHERE Orders.order_id = 1
GROUP BY Orders.order_id;

SELECT 
    Products.product_name,
    SUM(Order_Items.quantity) AS total_units_sold,
    SUM(Order_Items.quantity * Order_Items.price_at_purchase) AS total_sales
FROM Products
JOIN Order_Items
    ON Products.product_id = Order_Items.product_id
GROUP BY Products.product_id, Products.product_name;

SELECT 
    Users.user_id,
    Users.first_name,
    Users.last_name,
    COUNT(Orders.order_id) AS total_orders
FROM Users
JOIN Orders
    ON Users.user_id = Orders.user_id
GROUP BY Users.user_id, Users.first_name, Users.last_name
HAVING COUNT(Orders.order_id) > 3;

-- Indexes

CREATE INDEX idx_orders_user_id
ON Orders(user_id);

CREATE INDEX idx_order_items_order_id
ON Order_Items(order_id);