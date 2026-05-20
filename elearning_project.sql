-- Create Database
CREATE DATABASE elearning_platform;

-- Use Database
USE elearning_platform;

-- Create learners table
CREATE TABLE learners (
	learner_id INT PRIMARY KEY,
	full_name VARCHAR(100),
	Country VARCHAR(50)
    );

CREATE TABLE courses (
	course_id INT PRIMARY KEY,
	course_name VARCHAR(100),
	category VARCHAR(50),
	unit_price DECIMAL(10,2)
    ); 
    
CREATE TABLE purchases (
	purchase_id INT PRIMARY KEY,
	learner_id INT,
	course_id INT,
	Quantity INT,
	purchase_date DATE, 
	FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert into learners
INSERT INTO learners VALUES
	(1, 'Shalini Kumar', 'India'),
	(2, 'Rahul Sharma', 'India'),
	(3, 'John Smith', 'USA'),
	(4, 'Maria Garcia', 'Spain'),
	(5, 'Aisha Khan', 'UAE');

INSERT INTO learners VALUES
	(6, 'David Lee', 'Canada'),
	(7, 'Sophia Brown', 'UK'),
	(8, 'Arun Prakash', 'India'),
	(9, 'Emma Wilson', 'Australia'),
	(10, 'Mohamed Ali', 'Egypt');
    
-- Insert into courses
INSERT INTO courses VALUES 
	(101, 'Python for Beginners', 'Programming', 1200.00),
	(102, 'Advanced Excel', 'Analytics', 900.00),
	(103, 'Power BI Masterclass', 'Analytics', 1500.00),
	(104, 'Digital Marketing', 'Marketing', 1100.00),
	(105, 'SQL Complete Course', 'Database', 1300.00),
	(106, 'Tableau Essentials', 'Analytics', 1400.00),
	(107, 'Java Programming', 'Programming', 1600.00),
	(108, 'Machine Learning Basics', 'AI', 2000.00),
	(109, 'UI/UX Design', 'Design', 1250.00),
	(110, 'Cloud Computing', 'Technology', 1800.00);
    
INSERT INTO courses VALUES
	(111, 'Data Science with Python', 'AI', 2200.00),
	(112, 'Cyber Security Basics', 'Technology', 1700.00),
	(113, 'Excel Dashboarding', 'Analytics', 1000.00),
	(114, 'Content Marketing', 'Marketing', 1150.00),
	(115, 'Web Development Bootcamp', 'Programming', 2500.00);

-- Insert into purchases
INSERT INTO purchases VALUES
	(1, 1, 101, 1, '2026-01-10'),
	(2, 2, 102, 2, '2026-01-12'),
	(3, 3, 103, 1, '2026-01-15'),
	(4, 4, 104, 3, '2026-01-18'),
	(5, 5, 105, 1, '2026-01-20');

INSERT INTO purchases VALUES
	(6, 1, 102, 1, '2026-01-22'),
	(7, 2, 103, 2, '2026-01-24'),
	(8, 3, 104, 1, '2026-01-26'),
	(9, 4, 105, 2, '2026-01-28'),
	(10, 5, 101, 1, '2026-01-30');

SELECT * FROM courses;
SELECT * FROM learners;
SELECT * FROM purchases;

-- Inner join 

SELECT 
	l.learner_id AS learner_id,
    l.full_name AS learner_name,
    l.Country AS country,
    c.course_name AS course_name,
    c.category AS category,
    P.Quantity AS Quantity,
	FORMAT(c.unit_price, 2) AS unit_price,
    FORMAT((p.quantity * c.unit_price), 2) AS total_amount,
    p.purchase_date AS purchase_date
FROM purchases p

INNER JOIN learners l
ON p.learner_id = l.learner_id

INNER JOIN courses c
ON p.course_id = c.course_id
ORDER BY (p.quantity * c.unit_price) DESC;

-- Left join

SELECT 
	l.learner_id,
    l.full_name AS learner_name,
    c.course_name,
    p.quantity,
    p.purchase_date
FROM learners l
LEFT JOIN purchases p
ON l.learner_id = p.learner_id
LEFT JOIN courses c
ON p.course_id = c.course_id;    
    
-- right join

SELECT 
	c.course_name,
	l.full_name AS learner_name,
    p.quantity
FROM learners l
RIGHT JOIN  purchases p
ON l.learner_id = p.learner_id
RIGHT JOIN courses c
ON p.course_id = c.course_id;  

-- Total Spending by Each Learner

SELECT 
	l.learner_id,
    l.full_name AS learner_name,
    l.country AS country,
    FORMAT(IFNULL(SUM(p.quantity * c.unit_price),0), 2) AS total_spending
FROM learners l
LEFT JOIN purchases p
ON l.learner_id = p.learner_id

LEFT JOIN courses c
ON p.course_id = c.course_id

GROUP BY l.learner_id, l.full_name, l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Find the top 3 most purchased courses based on total quantity sold.
SELECT 
	c.course_name AS course_name,
    SUM(p.quantity) AS total_quantity_sold
FROM courses c
INNER JOIN purchases p ON
c.course_id = p.course_id
GROUP BY  c.course_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Show each course category’s total revenue and the number of unique learners who purchased from that category.
SELECT 
	c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,
	COUNT(DISTINCT p.learner_id) AS unique_learners
FROM courses c
INNER JOIN purchases p
ON c.course_id = p.course_id
GROUP BY c.category
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- List all learners who have purchased courses from more than one category.
SELECT 
	l.full_name AS learner_name,
    COUNT(DISTINCT(c.category)) AS categories_purchased
FROM learners l
INNER JOIN purchases p
ON l.learner_id = p.learner_id
INNER JOIN courses c
ON p.course_id = c.course_id
GROUP BY l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

--  Identify courses that have not been purchased at all.
SELECT 
	c.course_id,
    c.course_name,
    c.category 
FROM courses c
LEFT JOIN purchases p ON
	c.course_id = p.course_id
WHERE p.purchase_id IS NULL;

