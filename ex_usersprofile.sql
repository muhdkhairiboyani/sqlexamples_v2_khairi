-- ****************************************
-- SCENARIO 1: CREATE NON-IDENTIFYING LINKS
-- ****************************************

-- CREATE DATABASE usersdb
-- USE usersdb;

-- Table 1: users
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL  -- the email must be unique
);

-- Table 2: profile

CREATE TABLE IF NOT EXISTS profile (
    id INT NOT NULL PRIMARY KEY,
    phone VARCHAR(50) NOT NULL,
    image_url VARCHAR(200),
    users_id INT NOT NULL,
    CONSTRAINT FK_ProfileUser FOREIGN KEY (users_id) 
    REFERENCES users(id)
);

-- Insert a user and a profile for the user
INSERT INTO users (id, first_name, last_name, email)
VALUES(1, "John", "Doe", "johndoe@gmail.com");

INSERT INTO profile (id, phone, image_url, users_id)
VALUES(1, "9876 5432", "https://.../user_photo1.jpg", 1);

INSERT INTO profile (id, phone, image_url, users_id)
VALUES(2, "1234 5678", "https://.../user_photo2.jpg", 1);

SELECT u.*, p.phone, p.image_url -- John Doe id can create One or More id 
FROM users u JOIN profile p
ON u.id = p.users_id;



-- ************************************
-- SCENARIO 2: CREATE IDENTIFYING LINKS
-- ************************************

DROP TABLE IF EXISTS users, profile;
-- CREATE DATABASE usersdb
-- USE usersdb;

-- Table 1: users
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL  -- the email must be unique
);

-- Table 2: profile

CREATE TABLE IF NOT EXISTS profile (
    users_id INT NOT NULL PRIMARY KEY,
    phone VARCHAR(50) NOT NULL,
    image_url VARCHAR(200),
    CONSTRAINT FK_ProfileUser FOREIGN KEY (users_id) 
    REFERENCES users(id)
);

-- Insert a user and a profile for the user
INSERT INTO users (id, first_name, last_name, email)
VALUES(1, "John", "Doe", "johndoe@gmail.com");

INSERT INTO profile (users_id, phone, image_url)
VALUES(1, "9876 5432", "https://.../user_photo1.jpg");   -- John Doe (id: 1) profile 1

INSERT INTO profile (users_id, phone, image_url)
VALUES(1, "1234 5678", "https://.../user_photo2.jpg");   -- John Doe (id: 1) profile 2 (DISALLOWED, profile for id: 1 exists)

INSERT INTO profile (users_id, phone, image_url)
VALUES(2, "1234 5678", "https://.../user_photo2.jpg");   -- user_id 2 does not exist in parent table

SELECT u.*, p.phone, p.image_url -- John Doe id can create One or More id 
FROM users u JOIN profile p
ON u.id = p.users_id;