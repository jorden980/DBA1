-- Drop and recreate the database
DROP DATABASE IF EXISTS MangaBookstore; -- Ensure a clean slate
CREATE DATABASE MangaBookstore; -- Create the main MangaBookstore database
USE MangaBookstore; -- Select it for use

-- Authors Table
-- Stores author information for manga books
CREATE TABLE Authors (
    Author_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for each author
    Name VARCHAR(255) NOT NULL, -- Full name of the author
    Nationality VARCHAR(100), -- Country of origin
    Birthdate DATE -- Author's date of birth
);

-- Illustrators Table
-- Stores illustrator information, in some cases same as authors
CREATE TABLE Illustrators (
    Illustrator_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each illustrator
    Name VARCHAR(255) NOT NULL, -- Full name of the illustrator
    Nationality VARCHAR(100), -- Country of origin
    Birthdate DATE -- Illustrator's date of birth
);

-- Publishers Table
-- Stores publishing company details
CREATE TABLE Publishers (
    Publisher_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each publisher
    Name VARCHAR(255) NOT NULL UNIQUE, -- Name must be unique
    Country VARCHAR(100), -- Country where the publisher operates
    Founded_Year YEAR, -- Year the publisher was established
    Website VARCHAR(255) -- Official website URL
);

-- Genres Table
-- Stores manga genres
CREATE TABLE Genres (
    Genre_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each genre
    Name VARCHAR(100) NOT NULL UNIQUE -- Unique genre name
);

-- Books Table
-- Central table holding manga book records
-- NOTE: Author_ID removed due to many-to-many relationship
CREATE TABLE Books (
    ISBN VARCHAR(20) PRIMARY KEY, -- Unique ISBN number
    Title VARCHAR(255) NOT NULL, -- Book title
    Volume INT NOT NULL, -- Volume number
    Illustrator_ID INT, -- References Illustrators table
    Publisher_ID INT, -- References Publishers table
    Genre_ID INT, -- References Genres table
    Release_Date DATE, -- Date when the book was released
    Price DECIMAL(10,2) CHECK (Price >= 0), -- Price of the book, must be positive
    Stock INT CHECK (Stock >= 0), -- Number of units in stock
    FOREIGN KEY (Illustrator_ID) REFERENCES Illustrators(Illustrator_ID) ON DELETE SET NULL,
    FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Publisher_ID) ON DELETE RESTRICT,
    FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID) ON DELETE SET NULL
);

-- Book_Authors Table
-- Junction table to support multiple authors per book (many-to-many)
CREATE TABLE Book_Authors (
    ISBN VARCHAR(20), -- Linked to Books table
    Author_ID INT, -- Linked to Authors table
    PRIMARY KEY (ISBN, Author_ID), -- Composite key to avoid duplicates
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN) ON DELETE CASCADE,
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID) ON DELETE CASCADE
);

-- Customers Table
-- Holds customer details for orders
CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique customer ID
    Name VARCHAR(255) NOT NULL, -- Full name of the customer
    Email VARCHAR(255) UNIQUE NOT NULL, -- Unique email address
    Phone VARCHAR(20) UNIQUE, -- Contact phone number
    Address TEXT, -- Shipping address
    Preferred_Genre INT, -- Link to the preferred genre
    FOREIGN KEY (Preferred_Genre) REFERENCES Genres(Genre_ID) ON DELETE SET NULL
);

-- Orders Table
-- Represents a customer's order transaction
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY, -- Unique order ID
    Customer_ID INT, -- Linked to the customer placing the order
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Timestamp of order creation
    Total_Price DECIMAL(10,2) CHECK (Total_Price >= 0), -- Total cost of the order
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE RESTRICT
);

-- Order_Details Table
-- Junction table representing ordered books in each order
-- NOTE: Subtotal column removed (calculated values should not be stored)
CREATE TABLE Order_Details (
    Order_ID INT, -- Linked to the Orders table
    ISBN VARCHAR(20), -- Linked to the Books table
    Quantity INT CHECK (Quantity > 0), -- Number of copies ordered
    PRIMARY KEY (Order_ID, ISBN), -- Composite key to prevent duplicate book entries
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID) ON DELETE RESTRICT,
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN) ON DELETE RESTRICT
);

-- Authors
INSERT INTO Authors (Name, Nationality, Birthdate) VALUES
('Akira Toriyama', 'Japan', '1955-04-05'),
('Naoko Takeuchi', 'Japan', '1967-03-15'),
('Masashi Kishimoto', 'Japan', '1974-11-08'),
('Tite Kubo', 'Japan', '1977-06-26'),
('Yoshihiro Togashi', 'Japan', '1966-04-27'),
('Kentaro Miura', 'Japan', '1966-07-11'),
('Clamp', 'Japan', '1989-01-01'),
('Takehiko Inoue', 'Japan', '1967-01-12');

-- Illustrators
INSERT INTO Illustrators (Name, Nationality, Birthdate) VALUES
('Akira Toriyama', 'Japan', '1955-04-05'),
('Naoko Takeuchi', 'Japan', '1967-03-15'),
('Masashi Kishimoto', 'Japan', '1974-11-08'),
('Tite Kubo', 'Japan', '1977-06-26'),
('Yoshihiro Togashi', 'Japan', '1966-04-27'),
('Kentaro Miura', 'Japan', '1966-07-11'),
('Clamp', 'Japan', '1989-01-01'),
('Takehiko Inoue', 'Japan', '1967-01-12');

-- Publishers
INSERT INTO Publishers (Name, Country, Founded_Year, Website) VALUES
('Shueisha', 'Japan', 1925, 'https://www.shueisha.co.jp'),
('Kodansha', 'Japan', 1938, 'https://www.kodansha.co.jp'),
('Shogakukan', 'Japan', 1922, 'https://www.shogakukan.co.jp'),
('Square Enix', 'Japan', 1986, 'https://www.jp.square-enix.com'),
('Kadokawa', 'Japan', 1945, 'https://www.kadokawa.co.jp');

-- Genres
INSERT INTO Genres (Name) VALUES
('Shonen'), ('Seinen'), ('Shojo'), ('Isekai'), ('Fantasy');

-- Books
INSERT INTO Books (ISBN, Title, Volume, Illustrator_ID, Publisher_ID, Genre_ID, Release_Date, Price, Stock) VALUES
('978-4088811782', 'One Piece', 100, 1, 1, 1, '1997-07-22', 9.99, 50),
('978-4063948903', 'Attack on Titan', 34, 2, 2, 2, '2009-09-09', 10.99, 30),
('978-4088736214', 'Naruto', 72, 3, 1, 1, '1999-09-21', 8.99, 40),
('978-4088704534', 'Bleach', 74, 4, 1, 2, '2001-08-07', 9.49, 35),
('978-4088727854', 'Hunter x Hunter', 36, 5, 1, 3, '1998-03-03', 10.49, 25),
('978-4592193664', 'Berserk', 41, 6, 3, 5, '1989-08-25', 12.99, 20),
('978-4061082270', 'Sailor Moon', 18, 2, 2, 3, '1991-12-28', 7.99, 45),
('978-4063714780', 'Slam Dunk', 31, 8, 2, 1, '1990-10-01', 11.49, 38);

-- Book_Authors
INSERT INTO Book_Authors (ISBN, Author_ID) VALUES
('978-4088811782', 1),
('978-4063948903', 2),
('978-4088736214', 3),
('978-4088704534', 4),
('978-4088727854', 5),
('978-4592193664', 6),
('978-4061082270', 2),
('978-4063714780', 8);

-- Customers
INSERT INTO Customers (Name, Email, Phone, Address, Preferred_Genre) VALUES
('Adrienne Marshall', 'andrew80@gmail.com', '0107887590', '611 Stephanie Crossing\nLake Stevenfurt, GA 45632', 5),
('Christine Long', 'kathleenwhite@hotmail.com', '150-360-9447x2154', 'Unit 5212 Box 2940\nDPO AP 32214', 5),
('Chelsea Stokes', 'hancockmelissa@holland-sandoval.com', '410.353.7489', '483 Rebecca Trail Apt. 501\nAliciaport, AL 70063', 4),
('Lee Taylor', 'todd67@fernandez-case.com', '(181)859-5442', '87089 Tara Light Suite 623\nWilliamsbury, DC 20407', 3),
('Hannah Strickland', 'jacksonmichele@gmail.com', '+1-466-695-0988', '243 Irwin Light Suite 468\nSouth Tracy, KY 04953', 4),
('Dean Maxwell', 'kelly41@gmail.com', '750-809-5345', '7616 Joseph Village\nDuranmouth, AR 10959', 5),
('Jeremy Nelson', 'dustinbaker@yahoo.com', '055-194-8837', '156 Michelle Mall Suite 038\nLake Lindamouth, HI 63141', 3),
('Wesley Rush', 'lsimon@yahoo.com', '5194614069', '2287 Grace Port\nPort Scottberg, GA 19229', 2),
('Matthew Guerrero', 'longkim@wilson-santiago.com', '347-490-1543x488', '236 Green Ridge Apt. 036\nNelsonhaven, AK 89062', 3),
('David Johnson', 'cory79@gmail.com', '981-944-6124x2928', '16653 Elaine Cliff\nEast Jordan, TX 47284', 1);

-- Orders
INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Total_Price) VALUES
(1, 5, '2025-02-27 21:13:42', 79.09),
(2, 5, '2025-01-12 13:17:28', 66.85),
(3, 4, '2025-02-07 10:55:39', 53.2),
(4, 4, '2025-01-23 22:59:45', 98.72),
(5, 1, '2025-02-12 05:28:35', 60.45),
(6, 2, '2025-03-05 19:57:11', 188.41),
(7, 3, '2025-02-21 06:12:56', 98.54),
(8, 4, '2025-01-07 05:23:36', 182.82),
(9, 8, '2025-02-01 01:41:15', 164.53),
(10, 7, '2025-02-14 08:48:40', 114.48);

-- Order Details
INSERT INTO Order_Details (Order_ID, ISBN, Quantity) VALUES
(6, '978-4592193664', 3),
(1, '978-4063714780', 5),
(9, '978-4088704534', 5),
(2, '978-4088811782', 2),
(7, '978-4063948903', 3),
(10, '978-4061082270', 3),
(6, '978-4063948903', 5),
(8, '978-4088727854', 2),
(9, '978-4061082270', 1),
(6, '978-4061082270', 1),
(7, '978-4088727854', 2),
(3, '978-4088736214', 2);

-- Advanced MySQL Features
-- VIEW: Top 5 best-selling books
-- Shows the most popular books based on total quantity sold.
-- Useful for reports, dashboards, and decision-making.
CREATE VIEW top_selling_books AS
SELECT 
    b.ISBN,
    b.Title,
    b.Price,
    SUM(od.Quantity) AS total_sold
FROM Books b
JOIN Order_Details od ON b.ISBN = od.ISBN
GROUP BY b.ISBN, b.Title, b.Price
ORDER BY total_sold DESC
LIMIT 5;

-- STORED PROCEDURE: Add_New_Order
-- Automatically inserts a new order with order details.
-- Uses a transaction to ensure all-or-nothing logic.
DELIMITER $$
CREATE PROCEDURE Add_New_Order(
    IN p_customer_id INT,
    IN p_isbn VARCHAR(20),
    IN p_quantity INT
)
BEGIN
    DECLARE book_price DECIMAL(10,2); -- Price of the selected book
    DECLARE new_order_id INT;         -- ID of the newly created order
    DECLARE total DECIMAL(10,2);      -- Total price for the order

    START TRANSACTION; -- Begin transaction block

    -- Step 1: Get book price
    SELECT Price INTO book_price FROM Books WHERE ISBN = p_isbn;

    -- Step 2: Insert into Orders table
    INSERT INTO Orders (Customer_ID, Total_Price)
    VALUES (p_customer_id, p_quantity * book_price);

    -- Step 3: Retrieve the new order ID
    SET new_order_id = LAST_INSERT_ID();

    -- Step 4: Insert order details (no subtotal, quantity only)
    INSERT INTO Order_Details (Order_ID, ISBN, Quantity)
    VALUES (new_order_id, p_isbn, p_quantity);

    -- Step 5: Update inventory stock
    UPDATE Books
    SET Stock = Stock - p_quantity
    WHERE ISBN = p_isbn;

    COMMIT; -- Finalize the transaction
END$$
DELIMITER ;

-- TRANSACTIONS
-- Explanation: This procedure ensures that the entire ordering process is handled safely.
-- If any step fails (e.g., invalid book, not enough stock), all actions are rolled back.
-- This prevents orphaned or partial records and keeps the data consistent.

-- TRIGGER: Prevent overselling
-- Ensures you cannot order more books than are in stock.
-- Throws an error before insert if requested quantity exceeds stock.
DELIMITER $$
CREATE TRIGGER check_stock_before_insert
BEFORE INSERT ON Order_Details
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    SELECT Stock INTO current_stock FROM Books WHERE ISBN = NEW.ISBN;
    IF NEW.Quantity > current_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock to fulfill the order.';
    END IF;
END$$
DELIMITER ;

-- USER-DEFINED FUNCTION: Total_Inventory_Cost
-- Returns total value of a book's current inventory.
-- Helpful for financial reports and stock management.
DELIMITER $$
CREATE FUNCTION Total_Inventory_Cost(p_isbn VARCHAR(20))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE cost DECIMAL(10,2);
    SELECT Price * Stock INTO cost
    FROM Books
    WHERE ISBN = p_isbn;
    RETURN cost;
END$$
DELIMITER ;

-- EVENT: Monthly sales summary
-- This scheduled event generates monthly summaries of units sold per book.
-- Data is inserted into a dedicated reporting table for trend analysis.
CREATE TABLE Monthly_Sales_Report (
    Report_Month DATE, -- The first day of the month
    ISBN VARCHAR(20), -- Book ID
    Total_Sold INT, -- Units sold that month
    PRIMARY KEY (Report_Month, ISBN)
);

-- Automatically runs once a month starting April 1, 2025
CREATE EVENT IF NOT EXISTS generate_monthly_sales
ON SCHEDULE EVERY 1 MONTH
STARTS '2025-04-01 00:00:00'
DO
INSERT INTO Monthly_Sales_Report (Report_Month, ISBN, Total_Sold)
SELECT 
    DATE_FORMAT(NOW(), '%Y-%m-01') AS Report_Month,
    ISBN,
    SUM(Quantity)
FROM Order_Details
GROUP BY ISBN;
