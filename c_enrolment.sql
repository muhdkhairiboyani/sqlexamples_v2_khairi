-- ==========================================
-- 1. DDL: Create and Use Database
-- ==========================================
CREATE DATABASE IF NOT EXISTS enrollmentdb;
USE enrollmentdb;

-- ==========================================
-- 2. DDL: Create Tables (Schema)
-- ==========================================

-- a. Table 'student'
CREATE TABLE student (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- b. Table 'teacher'
-- This prevents repeating "Mr. Seetoh Aung" across different courses.
CREATE TABLE teacher (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
);

-- c. Table 'course'
-- Link the table 'course' to a teacher by id rather than storing a name string.
CREATE TABLE course (
    id VARCHAR(10) PRIMARY KEY NOT NULL,
    teacher_id INT,
    CONSTRAINT FK_CourseTeacher FOREIGN KEY (teacher_id) REFERENCES teacher(id)
);

-- d. Table 'enrolment' (The many-to-many relationship)
CREATE TABLE enrolment (
    student_id INT NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT FK_EnrolmentStudent FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT FK_EnrolmentCourse FOREIGN KEY (course_id) REFERENCES course(id)
);

-- What had been accomplished:

-- 1NF (First Normal Form): 
-- All columns contain atomic (indivisible) values. 
-- There are no repeating groups (e.g., no multiple course IDs in a single student row).

-- 2NF (Second Normal Form): 
-- Remove partial dependencies. Student's info. is dependent on student's id only.
-- Therefore, separating the student info. from course and teacher information into separate tables
-- In enrolment, the composite key (student_id, course_id) is necessary to identify the record.

-- 3NF (Third Normal Form): 
-- There are no transitive dependencies. 
-- The Teacher column is not dependent on student's id but rather on the course. 
-- To achieve 3NF, we split the Teacher information into a separate table that maps each course to its respective teacher.

-- ==========================================
-- 3. DML: Insert Records
-- ==========================================

-- Q: Who are the faculty members available for the upcoming semester?
INSERT INTO teacher (first_name, last_name) VALUES 
('Seetoh', 'Aung'),   -- ID 1
('Chan', 'Auying'),   -- ID 2
('Gretta', 'Lam'),    -- ID 3
('Teo', 'Hock See'),  -- ID 4
('Sim', 'Wong Hu');   -- ID 5

-- Q: What are the course codes and which teacher is assigned to each?
INSERT INTO course (id, teacher_id) VALUES 
('CS101', 1), 
('CS102', 2), 
('CS103', 3), 
('CS104', 4);

-- Q: Who are the students enrolled in the programme?
INSERT INTO student (first_name, last_name) VALUES 
('Alex', 'Lim'),     -- ID 1
('Belinda', 'Lam');  -- ID 2

-- Q: Which students have registered for which specific courses?
INSERT INTO enrolment (student_id, course_id) VALUES 
(1, 'CS101'), -- Alex
(1, 'CS102'), -- Alex
(1, 'CS104'), -- Alex
(2, 'CS101'), -- Belinda
(2, 'CS103'); -- Belinda


-- ==========================================
-- 4. SQL JOIN EXAMPLES
-- ==========================================

-- INNER JOIN: Complete Enrollment Overview
-- Q: Show student names, the courses they are taking, and their assigned teachers.
SELECT 
    s.first_name AS student_fn, 
    s.last_name AS student_ln, 
    e.course_id, 
    t.first_name AS teacher_fn, 
    t.last_name AS teacher_ln
FROM student s
JOIN enrolment e ON s.id = e.student_id
JOIN course c ON e.course_id = c.id
JOIN teacher t ON c.teacher_id = t.id
ORDER BY s.last_name;

-- LEFT JOIN: Teacher Workload
-- Q: Is there any teacher in the system who hasn't been assigned a course yet?
SELECT t.first_name, t.last_name, c.id AS course_id
FROM teacher t
LEFT JOIN course c ON t.id = c.teacher_id
WHERE c.id IS NULL;

-- AGGREGATION: Course Popularity
-- Q: How many students are enrolled in each course?
SELECT course_id, COUNT(student_id) AS enrollment_count
FROM enrolment
GROUP BY course_id;