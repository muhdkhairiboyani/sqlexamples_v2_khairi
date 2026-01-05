-- ==========================================
-- 1. DDL: Create database
-- ==========================================
CREATE DATABASE IF NOT EXISTS pharmacydb;

-- ==========================================
-- 2. Use database
-- ========================================== 
USE pharmacydb;

-- =============================================================
-- 3. Create tables (patient, medicine, prescription, purchase)
-- ============================================================= 
CREATE TABLE patient (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL
);

CREATE TABLE medicine (
    id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2),
    medicine_type ENUM('POM', 'OTC') NOT NULL DEFAULT 'OTC'
);

CREATE TABLE prescription (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dosage_instructions TEXT,
    issue_date DATE,
    CONSTRAINT FK_PrescPatient FOREIGN KEY (patient_id) REFERENCES patient(id),
    CONSTRAINT FK_PrescMedicine FOREIGN KEY (medicine_id) REFERENCES medicine(id)
);

CREATE TABLE purchase (
    id INT PRIMARY KEY AUTO_INCREMENT,                                                                          
    patient_id INT NOT NULL,                                                                        -- Mandatory: Every purchase MUST be associated with the patient
    medicine_id INT NOT NULL,                                                                       -- Mandatory: Every purchase MUST be associated with the medicine
    prescription_id INT NULL,                                                                       -- Optional: A purchase can exist without a prescription (Non-Identifying)
    purchase_date DATETIME NOT NULL,                                                                -- TIMESTAMP: '2026-01-02 15:30:00'
    CONSTRAINT FK_PurchasePatient FOREIGN KEY (patient_id) REFERENCES patient(id),                  -- Foreign Key constraints from this point on
    CONSTRAINT FK_PurchaseMedicine FOREIGN KEY (medicine_id) REFERENCES medicine(id),                   
    CONSTRAINT FK_PurchasePrescription FOREIGN KEY (prescription_id) REFERENCES prescription(id)    -- The connection to prescription is "Non-Identifying" because prescription_id is NOT in the PRIMARY KEY above
);

/* 
    ADDITIONAL NOTE:

    -- 3.1. This is an IDENTIFYING relationship because the PK is composed of FKs.
    -- where we create the Purchase Associative Entity (The Junction Table)
    
    CREATE TABLE purchase (
        -- id INT PRIMARY KEY                                                               -- Remove 'id INT PRIMARY KEY'
        patient_id INT NOT NULL,
        medicine_id INT NOT NULL,
        prescription_id INT NOT NULL,                                                       -- Mandatory: Every purchase must be associated with a prescription (NOT NULL), thus an identifying relationship
        purchase_date DATETIME NOT NULL,
        PRIMARY KEY (patient_id, medicine_id, prescription_id),                             -- The Primary Key is now composed of the Foreign Keys, makes the relationship IDENTIFYING
        CONSTRAINT FK_PurchasePatient FOREIGN KEY (patient_id) REFERENCES patient(id),
        CONSTRAINT FK_PurchaseMedicine FOREIGN KEY (medicine_id) REFERENCES medicine(id),
        CONSTRAINT FK_PurchasePrescription FOREIGN KEY (prescription_id) REFERENCES prescription(id) ON DELETE CASCADE
    );
*/


-- ===============================================================
-- 4. Insert multiple records into table 'patient' and 'medicine'
-- ===============================================================
INSERT INTO patient (patient_name) 
VALUES 
('Alice Smith'), 
('Bob Jones');

INSERT INTO medicine (medicine_name, price, medicine_type) 
VALUES 
('Amoxicillin', 25.50, 'POM'),              -- Requires Prescription
('Vitamin C Cream', 12.00, 'OTC');          -- Over-the-counter


-- ==========================================
-- 5. Scenario 1: Pharmacist Only Medicine
-- ==========================================
-- Step A: Create Prescription for Alice (id: 1)
INSERT INTO prescription (patient_id, medicine_id, dosage_instructions, issue_date) 
VALUES (1, 1, 'Take 500mg twice daily for 7 days', CURDATE());

-- Step B: Alice (id: 1) purchases the medicine using Prescription ID 1
INSERT INTO purchase (patient_id, medicine_id, prescription_id, purchase_date)
VALUES (1, 1, 1, NOW());


-- ============================================
-- 5.1. Scenario 2:  Over-the-Counter Medicine
-- ============================================
-- Step A: Bob (id: 2) purchases Vitamin C Cream (prescription_id is NULL)
INSERT INTO purchase (patient_id, medicine_id, prescription_id, purchase_date)
VALUES (2, 2, NULL, NOW());

-- ==================================================
-- 6. DML: View ALL purchases
-- ==================================================
-- Step A: To see all purchases, including those without prescriptions, use a LEFT JOIN for the prescription table.
SELECT 
    pur.id AS `purchase id`,
    p.patient_name AS customer,
    m.medicine_name AS product,
    m.medicine_type AS category,
    m.price,
    pur.purchase_date,
    -- Displaying Prescription info or a custom label for OTC
    CASE 
        WHEN m.medicine_type = 'POM' THEN COALESCE(pr.dosage_instructions, 'MISSING PRESCRIPTION!')
        ELSE 'N/A (Over-the-Counter)'
    END AS medical_instructions,
    -- Showing the issue date of the prescription if it exists
    pr.issue_date AS prescribed_on
FROM purchase pur
JOIN patient p ON pur.patient_id = p.id
JOIN medicine m ON pur.medicine_id = m.id
LEFT JOIN prescription pr ON pur.prescription_id = pr.id
ORDER BY pur.purchase_date DESC;