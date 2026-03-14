-- =====================================
-- LIBRARY MANAGEMENT SYSTEM DATABASE
-- =====================================


-- 1. CREATE DATABASE
CREATE DATABASE library_management;
USE library_management;


-- =====================================
-- 2. CREATE TABLES
-- =====================================


-- BOOKS TABLE
CREATE TABLE Books(
book_id INT PRIMARY KEY,
book_name VARCHAR(100),
author_name VARCHAR(100),
year_of_publication INT,
status VARCHAR(20)
);


-- MEMBERS TABLE
CREATE TABLE Members(
member_id INT PRIMARY KEY,
member_name VARCHAR(100),
phone VARCHAR(15)
);


-- BORROW RECORDS TABLE
CREATE TABLE BorrowRecords(
record_id INT PRIMARY KEY,
book_id INT,
member_id INT,
issued_date DATE,
return_date DATE,
FOREIGN KEY (book_id) REFERENCES Books(book_id),
FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


-- =====================================
-- 3. INSERT SAMPLE BOOK DATA
-- =====================================


INSERT INTO Books VALUES
(1,'Harry Potter','J.K. Rowling',1997,'available'),
(2,'Atomic Habits','James Clear',2018,'available'),
(3,'The Alchemist','Paulo Coelho',1988,'available'),
(4,'Rich Dad Poor Dad','Robert Kiyosaki',1997,'available'),
(5,'Think and Grow Rich','Napoleon Hill',1937,'available'),
(6,'Ikigai','Hector Garcia',2016,'available'),
(7,'The Power of Habit','Charles Duhigg',2012,'available'),
(8,'Deep Work','Cal Newport',2016,'available'),
(9,'The 7 Habits of Highly Effective People','Stephen Covey',1989,'available'),
(10,'Zero to One','Peter Thiel',2014,'available');


-- =====================================
-- 4. INSERT MEMBER DATA
-- =====================================


INSERT INTO Members VALUES
(101,'Rahul Sharma','9876543210'),
(102,'Anita Verma','9123456780'),
(103,'Amit Singh','9988776655'),
(104,'Priya Patel','9871234567'),
(105,'Rohan Das','9012345678');


-- =====================================
-- 5. BORROW RECORDS
-- =====================================


INSERT INTO BorrowRecords VALUES
(1,1,101,'2026-03-01',NULL),
(2,3,102,'2026-03-02',NULL),
(3,5,103,'2026-03-03',NULL);


-- UPDATE BOOK STATUS
UPDATE Books
SET status='borrowed'
WHERE book_id IN (1,3,5);


-- =====================================
-- 6. BASIC QUERIES
-- =====================================


-- SHOW ALL BOOKS
SELECT * FROM Books;


-- SHOW ALL MEMBERS
SELECT * FROM Members;


-- AVAILABLE BOOKS
SELECT * FROM Books
WHERE status='available';


-- BORROWED BOOKS
SELECT * FROM Books
WHERE status='borrowed';


-- SEARCH BOOK BY AUTHOR
SELECT * FROM Books
WHERE author_name='Dan Brown';


-- SEARCH BOOK BY NAME
SELECT * FROM Books
WHERE book_name LIKE '%Harry%';


-- =====================================
-- 7. JOIN QUERY (BORROW REPORT)
-- =====================================


SELECT 
Members.member_name,
Books.book_name,
BorrowRecords.issued_date
FROM BorrowRecords
JOIN Members ON BorrowRecords.member_id = Members.member_id
JOIN Books ON BorrowRecords.book_id = Books.book_id;


-- =====================================
-- 8. VIEWS
-- =====================================


-- AVAILABLE BOOK VIEW
CREATE VIEW AvailableBooks AS
SELECT book_id, book_name, author_name
FROM Books
WHERE status='available';


-- BORROWED BOOK VIEW
CREATE VIEW BorrowedBooks AS
SELECT 
Members.member_name,
Books.book_name,
BorrowRecords.issued_date
FROM BorrowRecords
JOIN Members ON BorrowRecords.member_id = Members.member_id
JOIN Books ON BorrowRecords.book_id = Books.book_id
WHERE BorrowRecords.return_date IS NULL;


-- =====================================
-- 9. INDEX
-- =====================================


CREATE INDEX idx_author
ON Books(author_name);


-- =====================================
-- 10. STORED PROCEDURE
-- =====================================


DELIMITER //


CREATE PROCEDURE ShowAllBooks()
BEGIN
SELECT * FROM Books;
END //


DELIMITER ;


-- CALL PROCEDURE
CALL ShowAllBooks();


-- =====================================
-- 11. ANALYTICS QUERIES
-- =====================================


-- TOTAL BOOKS
SELECT COUNT(*) AS total_books
FROM Books;


-- TOTAL MEMBERS
SELECT COUNT(*) AS total_members
FROM Members;


-- MOST BORROWED BOOKS
SELECT 
Books.book_name,
COUNT(BorrowRecords.book_id) AS times_borrowed
FROM BorrowRecords
JOIN Books ON BorrowRecords.book_id = Books.book_id
GROUP BY Books.book_name
ORDER BY times_borrowed DESC;


-- TOP MEMBERS
SELECT 
Members.member_name,
COUNT(BorrowRecords.member_id) AS books_taken
FROM BorrowRecords
JOIN Members ON BorrowRecords.member_id = Members.member_id
GROUP BY Members.member_name
ORDER BY books_taken DESC;


-- OVERDUE BOOKS (14 DAYS)
SELECT 
Members.member_name,
Books.book_name,
BorrowRecords.issued_date
FROM BorrowRecords
JOIN Members ON BorrowRecords.member_id = Members.member_id
JOIN Books ON BorrowRecords.book_id = Books.book_id
WHERE DATEDIFF(CURDATE(), issued_date) > 14
AND return_date IS NULL;