-- ==========================================
-- 1. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS volunteersdb;

-- ==========================================
-- 2. Use database
-- ==========================================
USE volunteersdb;

-- ==========================================
-- 3. Create table 'city'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.city (
    id INT NOT NULL AUTO_INCREMENT,
    city_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to city table
INSERT INTO
    volunteersdb.city (city_name)
VALUES ("London"),
    ("Bristol"),
    ("Hove");

-- ==========================================
-- 4. Create table 'language'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.language (
    id INT NOT NULL AUTO_INCREMENT,
    language_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- Insert values to language table
INSERT INTO
    volunteersdb.language (language_name)
VALUES ("German"),
    ("English"),
    ("Dutch");

ALTER TABLE volunteersdb.language
MODIFY language_name VARCHAR(255) NOT NULL UNIQUE;

-- ==========================================
-- 5. Create table 'volunteer'
-- ==========================================
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_city_id FOREIGN KEY (city_id) REFERENCES city (id)
);

-- Insert values to volunteers table
INSERT INTO
    volunteersdb.volunteer (surname, mobile, city_id)
VALUES ('Kroner', '020 1234 5678', 1), -- Kroner lives in London
    ('James', '020 5678 1234', 2), -- James lives in Bristol
    ('Dexter', '020 7654 4321', 3), -- Dexter lives in Hove
    ('Stephen', '020 4321 8765', 1);
-- Stephen lives in London

-- Q: Show all volunteers and the respective city one resides
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    JOIN city c ON v.city_id = c.id;

-- ==========================================
-- 6. Create table 'salutation'
-- ==========================================
CREATE TABLE volunteersdb.salutation (
    id INT NOT NULL AUTO_INCREMENT,
    salutation_name VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO
    volunteersdb.salutation (id, salutation_name)
VALUES (1, 'Mr.'),
    (2, 'Ms.'),
    (3, 'Mrs.');

-- ==========================================
-- 7. Alter table 'volunteer'
-- ==========================================

-- a. Alter table volunteer to include column 'salutation_id'
ALTER TABLE volunteersdb.volunteer
ADD salutation_id INT NOT NULL AFTER id;

-- b. Update the salutations for each volunteer
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 1;
-- Mr. Kroner
UPDATE volunteersdb.volunteer SET salutation_id = 2 WHERE id = 2;
-- Ms. James
UPDATE volunteersdb.volunteer SET salutation_id = 3 WHERE id = 3;
-- Mrs. Dexter
UPDATE volunteersdb.volunteer SET salutation_id = 1 WHERE id = 4;
-- Mr. Stephen

SELECT * FROM volunteersdb.volunteer;

SELECT s.salutation_name, v.surname
FROM volunteer v
    JOIN salutation s ON v.salutation_id = s.id;

-- c. Add constraint where volunteer table salutation_id references id from table salutation
ALTER TABLE volunteersdb.volunteer
ADD CONSTRAINT fk_salutation_id FOREIGN KEY (salutation_id) REFERENCES volunteersdb.salutation (id);

-- d. Create the referenential integrity between volunteer and language
-- Junction table
CREATE TABLE IF NOT EXISTS volunteersdb.volunteer_language (
    volunteer_id INT NOT NULL,
    language_id INT NOT NULL,
    PRIMARY KEY (volunteer_id, language_id),
    CONSTRAINT fk_volunteer_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer (id),
    CONSTRAINT fk_language_id FOREIGN KEY (language_id) REFERENCES volunteersdb.language (id)
);

-- e. Insert volunteers and languages associated
INSERT INTO
    volunteersdb.volunteer_language (volunteer_id, language_id)
VALUES (1, 1), -- Kroner, German
    (1, 2), -- Kroner, English
    (2, 2), -- James, English
    (3, 1), -- Dexter, German
    (3, 2), -- Dexter, English
    (3, 3), -- Dexter, Dutch
    (4, 1);
-- Stephen, German

-- =============================================================================
-- 8. Create table 'volunteer_hour' to manage the hours a volunteer contributes
-- =============================================================================
CREATE TABLE volunteersdb.volunteer_hour (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    hour INT NOT NULL,
    created_at DATETIME ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_volunteer_hour_id FOREIGN KEY (volunteer_id) REFERENCES volunteersdb.volunteer (id)
);

INSERT INTO
    volunteersdb.volunteer_hour (volunteer_id, hour)
VALUES (1, 15), -- Kroner, 15 hours
    (1, 12), -- Kroner, 15 hours;
    (2, 32), -- James,  32 hours
    (3, 11), -- Dexter, 11 hours
    (3, 7), -- Dexter, 7 hours
    (3, 5);
-- Dexter, 5 hours

-- ==========================================
-- 9. DQL: Query relational tables
-- ==========================================
-- NOTE: Examples here relate to the assessment

-- Q1. Select information from each table from the database
SELECT * FROM volunteersdb.salutation;

SELECT * FROM volunteersdb.language;

SELECT * FROM volunteersdb.city;

SELECT * FROM volunteersdb.volunteer;

SELECT * FROM volunteersdb.volunteer_language;

SELECT * FROM volunteersdb.volunteer_hour;

-- Q2. Show the surname, mobile, city name of each volunteer
-- SELECT v.surname, v.mobile, c.city_name
-- FROM volunteer v, city c
-- WHERE v.city_id = c.id;

-- Q2. Using INNER JOIN
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    INNER JOIN city c ON v.city_id = c.id;

-- Q3. Use a JOIN (INNER JOIN) to show a volunteer's details (mobile) and the city lived in
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    INNER JOIN city c ON v.city_id = c.id;

-- Q4. Show the surname, mobile and city name of each volunteer residing in "London" or "Bristol"
-- Note: Use a JOIN to relate tables volunteer - city
-- Note: Use a WHERE clause to set up a condition to displaying
SELECT v.surname, v.mobile, c.city_name
FROM volunteer v
    INNER JOIN city c ON v.city_id = c.id
WHERE
    c.city_name IN ('London', 'Bristol');

-- Q5. Display volunteers who speaks German
-- Note: relationship table is involved include: volunteer -< volunteer_langauge >- language

-- Without Salutation
SELECT v.surname, l.language_name
FROM
    volunteer v
    INNER JOIN volunteer_language vl ON vl.volunteer_id = v.id
    INNER JOIN language l ON l.id = vl.language_id
WHERE
    l.language_name = 'German';
-- WHERE LOWER(l.language_name) LIKE "g%"; This is a WILD CARD search

-- ********************************************************
-- TODO - Q5 - DONE - Added Salutation, Adding ORDER BY city name
-- ********************************************************
SELECT s.salutation_name, v.surname, l.language_name, c.city_name
FROM
    volunteer v
    JOIN salutation s ON s.id = v.salutation_id
    JOIN volunteer_language vl ON vl.volunteer_id = v.id
    JOIN language l ON l.id = vl.language_id
    JOIN city c ON c.id = v.city_id
WHERE
    LOWER(l.language_name) IN ('german')
    AND LOWER(c.city_name) IN ('london')
ORDER BY c.city_name ASC;

-- ********************************************************

-- Q6. Count the number of volunteers in each city
-- Note: Aggregate function COUNT() is applied
-- COUNT is an aggregate function that counts the number of rows that match a specified condition.

SELECT COUNT(v.city_id) AS "Number of Volunteers", c.city_name
FROM volunteer v
    JOIN city c ON v.city_id = c.id
GROUP BY
    c.city_name
ORDER BY c.city_name DESC;
-- DEFAULT IN ASCENDING ORDER

-- SIMPLE USE OF AGGRETATE FUNCTION
SELECT COUNT(volunteer.id) AS "Total Number of Volunteers"
FROM volunteer;

-- ********************************************************
-- TODO - Q6 - DONE
-- COUNT the number of volunteers and the city the reside in,
-- including cities with no volunteers
-- ********************************************************
SELECT c.city_name, COUNT(v.id) AS "Number of Volunteers"
FROM city c
    LEFT JOIN volunteer v ON v.city_id = c.id
GROUP BY
    c.city_name
ORDER BY c.city_name DESC;

-- ********************************************************

-- Q7. Which city do most volunteers come from? (Using JOIN and GROUP BY)
SELECT COUNT(v.city_id) AS `Number of volunteers`, c.city_name
FROM volunteer v
    JOIN City c ON v.city_id = c.id
GROUP BY
    c.city_name
ORDER BY `Number of volunteers` -- Using ALIAS as the SORT PARAMETER
LIMIT 10;
-- to limit the results returned

-- Q8. Display volunteers who speak MORE THAN ONE language
SELECT * FROM volunteer_language;

SELECT
    COUNT(v.id) AS `Number of languages spoken`,
    v.surname
FROM
    volunteer v
    JOIN volunteer_language vl ON v.id = vl.volunteer_id
GROUP BY
    v.surname
HAVING
    `Number of languages spoken` > 1
ORDER BY `Number of languages spoken` DESC;

-- Q9. Display the languages spoken by volunteers in the database (DISTINCT)
SELECT DISTINCT (l.language_name)
FROM
    language l
    JOIN volunteer_language vl ON l.id = vl.language_id;

-- 10. Display the number of distinct cities from volunteers (add DISTINCT in COUNT)
SELECT COUNT(DISTINCT c.city_name) AS `Number of Distinct Cities`
FROM volunteer v
    JOIN city c ON v.city_id = c.id;

-- 11. Display the LEAST number of hours clocked by a volunteer (MIN)
SELECT MIN(vh.hour) AS 'Minimum Hours Clocked'
FROM volunteer_hour vh;

SELECT v.surname, vh.hour
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
WHERE
    vh.hour <= (
        SELECT MIN(hour)
        FROM volunteer_hour -- SUB-QUERY
    );

-- 12. Display the most number of hours clocked by a volunteer (MAX)
SELECT v.surname, vh.hour
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
ORDER BY vh.hour DESC;

SELECT MAX(vh.hour) AS 'Maximum Hours Clocked'
FROM volunteer_hour vh;

SELECT v.surname, vh.hour
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
WHERE
    vh.hour = (
        SELECT MAX(hour)
        FROM volunteer_hour -- SUB-QUERY
    );

-- 13. display the total volunteered hours per volunteer (SUM)
SELECT * FROM volunteer_hour vh;

SELECT SUM(vh.hour), v.surname
FROM
    volunteer_hour vh
    JOIN volunteer v ON v.id = vh.volunteer_id
GROUP BY
    v.surname
ORDER BY SUM(vh.hour) DESC;

SELECT SUM(vh.hour) AS `Total Volunteer hours`
FROM volunteer_hour vh;

-- 14. Display the average volunteered hours per volunteer (AVG)
SELECT AVG(vh.hour), v.surname
FROM
    volunteer_hour vh
    JOIN volunteer v ON v.id = vh.volunteer_id
GROUP BY
    v.surname
ORDER BY AVG(vh.hour) DESC;

-- 15. Display the occasions each volunteer put up more than 1O hours per visit (case expression)
SELECT v.surname AS `Name`, SUM(
        CASE
            WHEN vh.hour > 10 THEN 1
            ELSE 0
        END
    ) AS `Per Visit >10hrs`
FROM
    volunteer v
    JOIN volunteer_hour vh ON v.id = vh.volunteer_id
GROUP BY
    v.surname;

-- Visualsing Q15:
-- Kroner: 1 x 15hr (Yes), 1 x 12hr (Yes)               = 2 times more than 10 hours
-- James : 1 x 32hr (Yes)                               = 1 time more than 10 hours
-- Dexter: 1 x 11hr (Yes), 1 x 7hr (No), 1 x 5 hr (No)  = 1 time more than 10 hours

-- 16. Display the cumulative volunteer hours from ALL VOLUNTEERS (use sub-query)
SELECT SUM(`Total Hours Volunteered`) AS `Cumulative Volunteer Hours`
FROM (
        SELECT SUM(vh.hour) AS `Total Hours Volunteered` -- Derived table must have an ALIAS/NAME
        FROM
            volunteer v
            JOIN volunteer_hour vh ON v.id = vh.volunteer_id
        GROUP BY
            vh.volunteer_id
    ) AS Cumulative;
-- MUST write in an ALIAS / NAME for the DERIVED TABLE

-- step 1: SUB-QUERY returns 27, 32, 23 from ALL volunteers hours
-- step 2: OUTER-QUERY SUMs up the total hours from ALL volunteers (27 + 32 + 23) = 82

-- 17. Display the LEAST number of Hours clocked cumulatively from the volunteers
SELECT SUM(vh.hour) AS `Least Hours Volunteered`, v.surname AS `Volunteer Surname`
FROM volunteer_hour vh
    JOIN volunteer v ON v.id = vh.volunteer_id
GROUP BY `Volunteer Surname`
HAVING `Least Hours Volunteered` = (
   SELECT MIN(`Total Hours Volunteered`) AS `Cumulative Volunteer Hours`
FROM (
        SELECT SUM(vh.hour) AS `Total Hours Volunteered` -- Derived table must have an ALIAS/NAME
        FROM volunteer v JOIN volunteer_hour vh 
        ON v.id = vh.volunteer_id
        GROUP BY vh.volunteer_id
        ) Cumulative -- MUST write in an ALIAS / NAME for the DERIVED TABLE
);




