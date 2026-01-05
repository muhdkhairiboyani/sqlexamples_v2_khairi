-- ==========================================
-- 1. DDL: Create database
-- ==========================================


-- ==========================================
-- 2. Use database
-- ========================================== 


-- =============================================================
-- 3. Create tables (patient, medicine, prescription, purchase)
-- ============================================================= 


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


-- ==========================================
-- 5. Scenario 1: Pharmacist Only Medicine
-- ==========================================
-- Step A: Create Prescription for Alice (id: 1)

-- Step B: Alice (id: 1) purchases the medicine using Prescription ID 1



-- ============================================
-- 5.1. Scenario 2:  Over-the-Counter Medicine
-- ============================================
-- Step A: Bob (id: 2) purchases Vitamin C Cream (prescription_id is NULL)


-- ==================================================
-- 6. DML: View ALL purchases
-- ==================================================
-- Step A: To see all purchases, including those without prescriptions, use a LEFT JOIN for the prescription table.