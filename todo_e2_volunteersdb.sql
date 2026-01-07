-- ==========================================
-- 1. DDL: Create database
-- ==========================================

-- ==========================================
-- 2. Use database
-- ==========================================

-- ==========================================
-- 3. Create table 'city'
-- ==========================================

-- Insert values to city table

-- ==========================================
-- 4. Create table 'language'
-- ==========================================

-- Insert values to language table

-- ==========================================
-- 5. Create table 'volunteer'
-- ==========================================

-- Insert values to volunteers table

-- Q: Show all volunteers and the respective city one resides

-- ==========================================
-- 6. Create table 'salutation'
-- ==========================================

-- ==========================================
-- 7. Alter table 'volunteer'
-- ==========================================

-- a. Alter table volunteer to include column 'salutation_id'

-- b. Update the salutations for each volunteer

-- c. Add constraint where volunteer table salutation_id references id from table salutation

-- d. Create the referenential integrity between volunteer and language

-- e. Insert volunteers and languages associated

-- =============================================================================
-- 8. Create table 'volunteer_hour' to manage the hours a volunteer contributes
-- =============================================================================

-- ==========================================
-- 9. DQL: Query relational tables
-- ==========================================
-- NOTE: Examples here relate to the assessment

-- Q1. Select information from each table from the database

-- Q2. Show the surname, mobile, city name of each volunteer

-- Q3. Use a JOIN (INNER JOIN) to show a volunteer's details (mobile) and the city lived in

-- Q4. Show the surname, mobile and city name of each volunteer residing in "London" or "Bristol"
-- Note: Use a JOIN to relate tables volunteer - city
-- Note: Use a WHERE clause to set up a condition to displaying 

-- Q5. Display volunteers who speaks German
-- Note: relationship table is involved include: volunteer -< volunteer_langauge >- language

-- Q6. Count the number of volunteers in each city
-- Note: Aggregate function COUNT() is applied


