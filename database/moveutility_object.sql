-- ============================================
-- Move Utility Procedures
-- ============================================
-- Check if a utility exists
DELIMITER $$

CREATE PROCEDURE sp_check_utility_exists(
  IN p_utility_id INT,
  OUT p_exists BOOLEAN
)
BEGIN
  DECLARE util_count INT;
  
  SELECT COUNT(*) INTO util_count
  FROM utilities
  WHERE id = p_utility_id;
  
  SET p_exists = (util_count > 0);
END$$

DELIMITER ;

-- List all utilities for a move
DELIMITER $$

CREATE PROCEDURE sp_list_utilities_for_move(
  IN p_move_id INT,
  IN p_user_id INT
)
BEGIN
  SELECT
    mu.move_id,
    mu.utility_id,
    u.provider_name,
    u.type,
    mu.account_number,
    mu.start_date,
    mu.stop_date,
    mu.status
  FROM move_utilities mu
  JOIN moves m ON m.id = mu.move_id
  JOIN utilities u ON u.id = mu.utility_id
  WHERE mu.move_id = p_move_id AND m.user_id = p_user_id
  ORDER BY u.type, u.provider_name;
END$$

DELIMITER ;

-- Add a utility to a move
DELIMITER $$

CREATE PROCEDURE sp_add_utility_to_move(
  IN p_move_id INT,
  IN p_utility_id INT,
  IN p_account_number VARCHAR(100),
  IN p_start_date DATE,
  IN p_stop_date DATE,
  IN p_status VARCHAR(20),
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE existing_count INT;
  
  -- Check if utility already attached to this move
  SELECT COUNT(*) INTO existing_count
  FROM move_utilities
  WHERE move_id = p_move_id AND utility_id = p_utility_id;
  
  IF existing_count > 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Utility already attached to this move';
  ELSE
    INSERT INTO move_utilities
      (move_id, utility_id, account_number, start_date, stop_date, status)
    VALUES (p_move_id, p_utility_id, p_account_number, p_start_date, p_stop_date, p_status);
    
    SET p_success = TRUE;
    SET p_message = 'Move utility added';
  END IF;
END$$

DELIMITER ;

-- Check if move utility exists and user owns it
DELIMITER $$

CREATE PROCEDURE sp_check_move_utility_exists(
  IN p_move_id INT,
  IN p_utility_id INT,
  IN p_user_id INT,
  OUT p_exists BOOLEAN
)
BEGIN
  DECLARE link_count INT;
  
  SELECT COUNT(*) INTO link_count
  FROM move_utilities mu
  JOIN moves m ON m.id = mu.move_id
  WHERE mu.move_id = p_move_id 
    AND mu.utility_id = p_utility_id 
    AND m.user_id = p_user_id;
  
  SET p_exists = (link_count > 0);
END$$

DELIMITER ;

-- Update move utility with partial field support
DELIMITER $$

CREATE PROCEDURE sp_update_move_utility(
  IN p_move_id INT,
  IN p_utility_id INT,
  IN p_account_number VARCHAR(100),
  IN p_start_date DATE,
  IN p_stop_date DATE,
  IN p_status VARCHAR(20)
)
BEGIN
  UPDATE move_utilities
  SET 
    account_number = COALESCE(p_account_number, account_number),
    start_date = COALESCE(p_start_date, start_date),
    stop_date = COALESCE(p_stop_date, stop_date),
    status = COALESCE(p_status, status)
  WHERE move_id = p_move_id AND utility_id = p_utility_id
  LIMIT 1;
END$$

DELIMITER ;

-- Delete a move utility
DELIMITER $$

CREATE PROCEDURE sp_delete_move_utility(
  IN p_move_id INT,
  IN p_utility_id INT,
  IN p_user_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE link_exists INT;
  
  -- Check if link exists and user owns the move
  SELECT COUNT(*) INTO link_exists
  FROM move_utilities mu
  JOIN moves m ON m.id = mu.move_id
  WHERE mu.move_id = p_move_id 
    AND mu.utility_id = p_utility_id 
    AND m.user_id = p_user_id;
  
  IF link_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Move utility not found';
  ELSE
    DELETE FROM move_utilities
    WHERE move_id = p_move_id AND utility_id = p_utility_id;
    
    SET p_success = TRUE;
    SET p_message = 'Move utility deleted';
  END IF;
END$$

DELIMITER ;

-- ============================================
-- Move Utility Triggers
-- ============================================

-- Validate and normalize move utility data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_move_utility;

DELIMITER $$

CREATE TRIGGER trg_before_insert_move_utility
BEFORE INSERT ON move_utilities
FOR EACH ROW
BEGIN
  -- Trim account_number if provided
  IF NEW.account_number IS NOT NULL THEN
    SET NEW.account_number = TRIM(NEW.account_number);
    IF NEW.account_number = '' THEN
      SET NEW.account_number = NULL;
    END IF;
  END IF;
  
  -- Set default status if null
  IF NEW.status IS NULL THEN
    SET NEW.status = 'planned';
  END IF;
  
  -- Validate start_date is before stop_date if both provided
  IF NEW.start_date IS NOT NULL AND NEW.stop_date IS NOT NULL THEN
    IF NEW.start_date > NEW.stop_date THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Start date must be before stop date';
    END IF;
  END IF;
END$$

DELIMITER ;

-- Validate and normalize move utility data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_move_utility;

DELIMITER $$

CREATE TRIGGER trg_before_update_move_utility
BEFORE UPDATE ON move_utilities
FOR EACH ROW
BEGIN
  -- Trim account_number if provided
  IF NEW.account_number IS NOT NULL THEN
    SET NEW.account_number = TRIM(NEW.account_number);
    IF NEW.account_number = '' THEN
      SET NEW.account_number = NULL;
    END IF;
  END IF;
  
  -- Validate start_date is before stop_date if both provided
  IF NEW.start_date IS NOT NULL AND NEW.stop_date IS NOT NULL THEN
    IF NEW.start_date > NEW.stop_date THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Start date must be before stop date';
    END IF;
  END IF;
END$$

DELIMITER ;