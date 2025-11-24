USE movemind_db;

-- Utilities : Procedures
-- ============================================
-- PROCEDURES FOR UTILITIES
-- ============================================
DROP PROCEDURE IF EXISTS list_utilities;
DROP PROCEDURE IF EXISTS create_utility;
DROP PROCEDURE IF EXISTS update_utility;
DROP PROCEDURE IF EXISTS delete_utility;

DELIMITER //

-- 1. Listing all utilities
CREATE PROCEDURE list_utilities()
BEGIN
    SELECT id, provider_name, type
    FROM Utilities
    ORDER BY provider_name ASC;
END //

-- 2. Create a new utility
DELIMITER //
CREATE PROCEDURE create_utility(
    IN p_provider_name VARCHAR(100),
    IN p_type ENUM('electricity','gas','water','internet','trash','other')
)
BEGIN
    INSERT INTO Utilities (provider_name, type)
    VALUES (p_provider_name, p_type);
    
    SELECT LAST_INSERT_ID() as id;
END //

-- 3. Update a utility
DELIMITER //
CREATE PROCEDURE update_utility(
    IN p_utility_id INT,
    IN p_provider_name VARCHAR(100),
    IN p_type ENUM('electricity','gas','water','internet','trash','other')
)
BEGIN
    DECLARE v_affected_rows INT DEFAULT 0;
    
    -- Update only non-null fields
    UPDATE Utilities
    SET 
        provider_name = COALESCE(p_provider_name, provider_name),
        type = COALESCE(p_type, type)
    WHERE id = p_utility_id
    LIMIT 1;
    
    SET v_affected_rows = ROW_COUNT();
    
    -- Return affected rows count
    SELECT v_affected_rows as affected_rows;
END //

-- 4. Delete a utility
DELIMITER //
CREATE PROCEDURE delete_utility(
    IN p_utility_id INT
)
BEGIN
    DECLARE v_affected_rows INT DEFAULT 0;
    
    DELETE FROM Utilities 
    WHERE id = p_utility_id;
    
    SET v_affected_rows = ROW_COUNT();
    
    -- Return affected rows count
    SELECT v_affected_rows as affected_rows;
END //

DELIMITER ;

-- Utilities : Triggers

-- ============================================
-- TRIGGERS FOR UTILITIES
-- ============================================

DROP TRIGGER IF EXISTS trg_before_utility_insert;
DROP TRIGGER IF EXISTS trg_before_utility_update;
DROP TRIGGER IF EXISTS trg_before_utility_delete;

DELIMITER //

-- TRIGGER 1: Validating and cleaning data BEFORE INSERT

CREATE TRIGGER trg_before_utility_insert
BEFORE INSERT ON Utilities
FOR EACH ROW
BEGIN
    -- Automatically trim whitespace from provider name
    SET NEW.provider_name = TRIM(NEW.provider_name);
    
    -- Prevent empty or whitespace-only provider names
    IF LENGTH(NEW.provider_name) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Provider name cannot be empty';
    END IF;
    
    
END //


-- TRIGGER 2: Validate and clean data BEFORE UPDATE
DELIMITER //
CREATE TRIGGER trg_before_utility_update
BEFORE UPDATE ON Utilities
FOR EACH ROW
BEGIN
    -- Automatically trims the whitespace from provider name
    SET NEW.provider_name = TRIM(NEW.provider_name);
    
    -- Prevents empty or whitespace-only provider names
    IF LENGTH(NEW.provider_name) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Provider name cannot be empty';
    END IF;
END //


-- TRIGGER 3: Preventing the delete utilities in use

DELIMITER //
CREATE TRIGGER trg_before_utility_delete
BEFORE DELETE ON Utilities
FOR EACH ROW
BEGIN
    DECLARE usage_count INT;
    
    -- Check if this utility is referenced in move_utilities table
    SELECT COUNT(*) INTO usage_count
    FROM move_utilities
    WHERE utility_id = OLD.id;
    
    -- If utility is being used, prevent deletion
    IF usage_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete utility: it is currently assigned to one or more moves';
    END IF;
END //






