-- ==========================================
-- 1. DDL: Create database
-- ==========================================


-- ==========================================
-- 2. Use database
-- ==========================================


-- ==========================================
-- 3. Create tables (employee, department)
-- ==========================================
-- Create Employee Table


-- ==========================================
-- 2. DML: Insert 10 Records Total
-- ==========================================
-- Insert Departments

-- Insert Employees


-- ==========================================
-- 3. SQL JOIN EXAMPLES 
-- Diagram reference: https://i.sstatic.net/1UKp7.png
-- Additional reference: https://medium.com/@eshanpurekar/my-dbms-journey-part-3-types-of-joins-and-set-operations-in-mysql-c16f1badacac
-- ==========================================


-- FULL JOIN (Everything from both tables)
-- Q: Show all employees and all departments. 


-- FULL JOIN EXCLUDING INTERSECTION (Unique to A or B)
-- Q: Show employees who are NOT assigned to any department AND departments that have NO employees assigned to them.


-- LEFT JOIN (Everything from Table A)
-- Q: Show all employees, regardless of whether they belong to a department. 


-- LEFT JOIN EXCLUDING INTERSECTION (Only in Table A)
-- Q: Show only the employees who are NOT assigned to any department. 


-- RIGHT JOIN (Everything from Table B)
-- Q: Show all departments, regardless of whether they have employees.


-- INNER JOIN (Intersection of A and B)
-- Q: Show only employees assigned to departments AND only departments that have employees.