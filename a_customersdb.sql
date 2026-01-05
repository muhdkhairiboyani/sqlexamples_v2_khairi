-- ==========================================
-- 1. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS customersdb;

-- ==========================================
-- 2. Use database
-- ========================================== 
USE customersdb;

-- ==========================================
-- 3. Create tables (customers, orders)
-- ========================================== 
CREATE TABLE customers(
	id INT NOT NULL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
    -- PRIMARY KEY (id)
);

CREATE TABLE orders(
	id INT NOT NULL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    -- PRIMARY KEY (id)
    FOREIGN KEY (customer_id) REFERENCES customers(id) 
);

-- ===============================================
-- 3.1. Create table 'orders' with named contraints 
-- =============================================== 
/* 
    CREATE TABLE orders(
        id INT NOT NULL,
        customer_id INT NOT NULL,
        product_name VARCHAR(50) NOT NULL,
        PRIMARY KEY (id),
        CONSTRAINT FK_CustomersOrders FOREIGN KEY (customer_id)
        REFERENCES customers(id)
    ); 
*/

-- ==========================================
-- 4. Show all tables in the database
-- ========================================== 
SHOW TABLES;
SELECT * FROM customers;

-- ============================================
-- 5. Insert one record into table 'customers'
-- ============================================
INSERT INTO customers
VALUES (111, 'Steve Ball', 'Derby');

-- ==================================================
-- 6. Insert multiple records into table 'customers'
-- ==================================================
INSERT INTO customers (id, customer_name, city) -- Explicitly name the attributes
VALUES 
(116, 'Andrew Hill', 'Luton'),                  -- Insert statement for Andrew Hill
(211, 'Mitchelle Pele', 'Carlisle'),            -- Insert statement for Mitchelle Pele
(212, 'Audrie Samah', 'Truro'),                 -- Insert statement for Audrie Samah
(105, 'Jamie Fisher', 'Cambridge');             -- Insert statement for Jamie Fisher

-- ==================================================
-- 7. Altering tables attributes and characteristics
-- ==================================================
ALTER TABLE orders
DROP FOREIGN KEY orders_ibfk_1;


ALTER TABLE orders                          -- Re-create the constraints btwn customers and orders
ADD CONSTRAINT FK_CustomersOrders
FOREIGN KEY (customer_id) REFERENCES customers(id);

ALTER TABLE customers
MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE orders
MODIFY COLUMN id INT AUTO_INCREMENT;

-- ==================================================
-- 8. Insert one record into table 'customers' 
-- ==================================================
INSERT INTO Customers(customer_name, city)  -- the id attribute is not required (auto-incremented)
VALUES("Mike Johnson", "Manchester");

-- ==================================================
-- 9. DML: View ALL records from table 'customers' 
-- ==================================================
SELECT * FROM Customers;

-- ================================================
-- 10.  Insert multiple records into table 'orders'
-- ================================================
INSERT INTO orders (customer_id, product_name) 
VALUES 
(105, 'InterTV'),                       -- Inserting record for InterTV
(211, 'Diakin AC'),                     -- Inserting record for Diakin AC
(212, 'Goodrej AC'),                    -- Inserting record for Goodrej AC
(212, 'Hitachi AC'),                    -- Inserting record for Hitachi AC
(211, 'Aircool AC');                    -- Inserting record for Aircool AC

SELECT * FROM Orders;

-- ====================================================================
-- 11.  Record insertion failed (customer with id:1000 does not exist)
-- ====================================================================
INSERT INTO Orders(customer_id, product_name)
VALUES(1000, "Midea AC");               -- customer's id must exist (referential integrity)

