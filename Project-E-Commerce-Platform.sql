/*Database Schema*/

CREATE DATABASE ECommercePlatform;
USE ECommercePlatform;

CREATE TABLE users 
(user_id INT PRIMARY KEY NOT NULL,
username VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL,
password VARCHAR(50) NOT NULL,
role VARCHAR(50) NOT NULL);

CREATE TABLE products 
(product_id INT PRIMARY KEY NOT NULL,
product_name VARCHAR(100) NOT NULL,
category VARCHAR(50) NOT NULL,
price DECIMAL(10,0) NOT NULL,
stock_quantity INT NOT NULL);

CREATE TABLE orders 
(order_id INT PRIMARY KEY NOT NULL,
user_id INT NOT NULL,
order_date DATE NOT NULL,
total_amount DECIMAL(10,0) NOT NULL,
order_status VARCHAR(50) NOT NULL,
FOREIGN KEY (user_id) REFERENCES users (user_id));

CREATE TABLE orderdetails 
(order_detail_id INT PRIMARY KEY NOT NULL,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10,0) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders (order_id),
FOREIGN KEY (product_id) REFERENCES products (product_id));

CREATE TABLE payments 
(payment_id INT PRIMARY KEY NOT NULL,
order_id INT NOT NULL,
payment_date DATE NOT NULL,
payment_method VARCHAR(50) NOT NULL,
amount DECIMAL(10,0) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders (order_id));

CREATE TABLE reviews 
(review_id INT PRIMARY KEY NOT NULL,
product_id INT NOT NULL,
user_id INT NOT NULL,
review_text VARCHAR(500) NOT NULL,
rating INT NOT NULL,
review_date DATE NOT NULL,
FOREIGN KEY (product_id) REFERENCES products (product_id),
FOREIGN KEY (user_id) REFERENCES users (user_id));

/*Insert Sample Data*/

INSERT INTO users (user_id, username, email, password, role) VALUES
(1, 'futurama5000', 'johnsmith25@gmail.com', '12345', user),
(2, 'laura1995', 'laura1212@gmail.com', 'password', user),
(3, 'mzero20', 'moniquezero@gmail.com', 'barthomer', user),
(4, 'duderanch97', 'newmail2025@gmail.com', 'blink182', user),
(5, 'idkidk25', 'stephenmax@gmail.com', 'qwerty3', user);

INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
(1, 'Cellphone', 'Electronics', 800,25),
(2, 'Table', 'Furniture', 1500, 5),
(3, 'Laptop', 'Electronics', 1200, 10),
(4, 'Guitar', 'Musical Instruments', 600, 5),
(5, 'TV', 'Electronics', 1300, 10);

INSERT INTO orders (order_id, user_id, order_date, total_amount, order_status) VALUES
(1, 1, '2025-05-01', 2400, 'Paid'),
(2, 4, '2025-05-02', 600, 'Paid'),
(3, 2, '2025-05-03', 1300, 'Paid'),
(4, 3, '2025-05-03', 1600, 'Paid'),
(5, 5, '2025-05-04', 800, 'Paid');

INSERT INTO orderdetails (order_detail_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 3, 2, 1200),
(2, 2, 4, 1, 600),
(3, 3, 5, 1, 1300),
(4, 4, 1, 2, 1600),
(5, 5, 1, 1, 800);

INSERT INTO payments (payment_id, order_id, payment_date, payment_method, amount) VALUES
(1, 1, '2025-05-01', 'Credit Card', 2400),
(2, 2, '2025-05-02', 'Credit Card', 600),
(3, 3, '2025-05-03', 'Credit Card', 1300),
(4, 4, '2025-05-03', 'Credit Card', 1600),
(5, 5, '2025-05-04', 'Credit Card', 800);

INSERT INTO reviews (review_id, product_id, user_id, review_text, rating, review_date) VALUES
(1, 3, 1, 'Very good laptop, reliable', 9, '2025-04-03'),
(2, 4, 3, 'Great guitar for a great price', 10, '2025-04-04');

/*Queries*/

/*Retrieve the list of all products in a specific category*/
SELECT * FROM products WHERE category = 'Electronics';

/*Retrieve the details of a specific user by providing their user_id*/
SELECT * FROM users WHERE user_id = 2;

/*Retrieve the order history for a particular user*/
SELECT * FROM orders WHERE user_id = 2;

/*Retrieve the products in an order along with their quantities and prices*/
SELECT a.order_id, c.product_name, b.quantity, b.unit_price, a.total_amount, a.order_date FROM orders a
INNER JOIN orderdetails b 
ON a.order_id = b.order_id
INNER JOIN products c
ON b.product_id = c.product_id
WHERE a.order_id = 2;

/*Retrieve the average rating of a product*/
SELECT a.product_id, b.product_name, avg(rating) FROM reviews a
INNER JOIN products b
ON a.product_id = b.product_id
WHERE a.product_id = 3;

/*Retrieve the total revenue for a given month*/
SELECT SUM(amount) FROM payments
WHERE MONTH(payment_date) = MONTH(NOW())
AND YEAR(payment_date) = YEAR(NOW());

/*Data Modification*/

/*Add a new product to the inventory*/
INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
(6, 'Chair', 'Furniture', 500, 4);

/*Place a new order for a user*/
INSERT INTO orders (order_id, user_id, order_date, total_amount, order_status) VALUES
(6, 1, '2025-05-05', 500, 'Preparing for shipping');

/*Update the stock quantity of a product*/
UPDATE products SET stock_quantity = 10 WHERE product_id = 6;

/*Remove a user's review*/
DELETE FROM reviews WHERE review_id = 2;

/*Complex Queries*/

/*Identify the top-selling products*/
SELECT c.product_name, SUM(b.quantity) AS total_sales FROM orders a
INNER JOIN orderdetails b 
ON a.order_id = b.order_id
INNER JOIN products c
ON b.product_id = c.product_id
GROUP BY c.product_name
ORDER BY total_sales DESC;

/*Find users who have placed orders exceeding a certain amount*/
SELECT a.user_id, b.username, a.total_amount FROM orders a
INNER JOIN users b
ON a.user_id = b.user_id
WHERE total_amount > 1500;

/*Calculate the overall average rating for each product category*/
SELECT b.category, avg(rating) AS average_rating FROM reviews a
INNER JOIN products b
ON a.product_id = b.product_id
GROUP BY b.category;

/*Advanced Topics*/

/*Automatically update the order status based on order processing*/
CREATE DEFINER=`usuariocurso`@`localhost` PROCEDURE `UpdateOrderStatus`(IN recent_order_id INT)
BEGIN

IF (SELECT order_id FROM payments WHERE order_id = recent_order_id) THEN
	UPDATE orders SET order_status = 'Paid' WHERE order_id = recent_order_id;
END IF;

END

/*Generate a report on the most active users*/
CREATE DEFINER=`usuariocurso`@`localhost` PROCEDURE `GenerateMostActiveUsersReport`()
BEGIN
	
    SELECT b.username, COUNT(*) AS this_month_orders FROM orders a
	INNER JOIN users b
	ON a.user_id = b.user_id
	WHERE MONTH(order_date) >= MONTH(NOW()-INTERVAL 1 MONTH)
	GROUP BY b.username
	ORDER BY this_month_orders DESC;
    
END


