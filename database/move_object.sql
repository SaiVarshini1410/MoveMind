-- ============================================
-- Move Procedures
-- ============================================

-- List all moves for a specific user
DELIMITER $$

CREATE PROCEDURE sp_list_moves(
  IN p_user_id INT
)
BEGIN
  SELECT id, title, move_date, status, created_at, from_address_id, to_address_id
  FROM moves
  WHERE user_id = p_user_id
  ORDER BY created_at DESC;
END$$

DELIMITER ;

-- Get a single move by ID for a specific user
DELIMITER $$

CREATE PROCEDURE sp_get_move(
  IN p_move_id INT,
  IN p_user_id INT
)
BEGIN
  SELECT id, title, move_date, status, created_at, from_address_id, to_address_id
  FROM moves
  WHERE id = p_move_id AND user_id = p_user_id
  LIMIT 1;
END$$

DELIMITER ;

-- Check if an address belongs to a user
DELIMITER $$

CREATE PROCEDURE sp_check_address_belongs_to_user(
  IN p_user_id INT,
  IN p_address_id INT,
  OUT p_belongs BOOLEAN
)
BEGIN
  DECLARE link_count INT;
  
  IF p_address_id IS NULL THEN
    SET p_belongs = FALSE;
  ELSE
    SELECT COUNT(*) INTO link_count
    FROM user_addresses
    WHERE address_id = p_address_id AND user_id = p_user_id;
    
    SET p_belongs = (link_count > 0);
  END IF;
END$$

DELIMITER ;

-- Create a new move with address validation
DELIMITER $$

CREATE PROCEDURE sp_create_move(
  IN p_user_id INT,
  IN p_title VARCHAR(200),
  IN p_move_date DATE,
  IN p_status VARCHAR(20),
  IN p_from_address_id INT,
  IN p_to_address_id INT,
  OUT p_move_id INT,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE from_belongs BOOLEAN;
  DECLARE to_belongs BOOLEAN;
  
  CALL sp_check_address_belongs_to_user(p_user_id, p_from_address_id, from_belongs);
  CALL sp_check_address_belongs_to_user(p_user_id, p_to_address_id, to_belongs);
  
  IF NOT from_belongs THEN
    SET p_move_id = NULL;
    SET p_message = 'Invalid from_address_id';
  ELSEIF NOT to_belongs THEN
    SET p_move_id = NULL;
    SET p_message = 'Invalid to_address_id';
  ELSE
    INSERT INTO moves (user_id, title, move_date, status, from_address_id, to_address_id)
    VALUES (p_user_id, p_title, p_move_date, p_status, p_from_address_id, p_to_address_id);
    
    SET p_move_id = LAST_INSERT_ID();
    SET p_message = 'Move created';
  END IF;
END$$

DELIMITER ;

-- Update a move with partial field support and address validation
DELIMITER $$

CREATE PROCEDURE sp_update_move(
  IN p_move_id INT,
  IN p_user_id INT,
  IN p_title VARCHAR(200),
  IN p_move_date DATE,
  IN p_status VARCHAR(20),
  IN p_from_address_id INT,
  IN p_to_address_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE move_exists INT;
  DECLARE from_belongs BOOLEAN DEFAULT TRUE;
  DECLARE to_belongs BOOLEAN DEFAULT TRUE;
  
  SELECT COUNT(*) INTO move_exists
  FROM moves
  WHERE id = p_move_id AND user_id = p_user_id;
  
  IF move_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Move not found';
  ELSE
    IF p_from_address_id IS NOT NULL THEN
      CALL sp_check_address_belongs_to_user(p_user_id, p_from_address_id, from_belongs);
      IF NOT from_belongs THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid from_address_id';
        LEAVE sp_update_move;
      END IF;
    END IF;
    
    IF p_to_address_id IS NOT NULL THEN
      CALL sp_check_address_belongs_to_user(p_user_id, p_to_address_id, to_belongs);
      IF NOT to_belongs THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid to_address_id';
        LEAVE sp_update_move;
      END IF;
    END IF;
    
    UPDATE moves
    SET 
      title = COALESCE(p_title, title),
      move_date = COALESCE(p_move_date, move_date),
      status = COALESCE(p_status, status),
      from_address_id = COALESCE(p_from_address_id, from_address_id),
      to_address_id = COALESCE(p_to_address_id, to_address_id)
    WHERE id = p_move_id AND user_id = p_user_id;
    
    SET p_success = TRUE;
    SET p_message = 'Move updated';
  END IF;
END$$

DELIMITER ;

-- Delete a move
DELIMITER $$

CREATE PROCEDURE sp_delete_move(
  IN p_move_id INT,
  IN p_user_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE move_exists INT;
  
  SELECT COUNT(*) INTO move_exists
  FROM moves
  WHERE id = p_move_id AND user_id = p_user_id;
  
  IF move_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Move not found';
  ELSE
    DELETE FROM moves
    WHERE id = p_move_id AND user_id = p_user_id
    LIMIT 1;
    
    SET p_success = TRUE;
    SET p_message = 'Move deleted';
  END IF;
END$$

DELIMITER ;

-- ============================================
-- Move Triggers
-- ============================================

-- Validate and normalize move data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_move;

DELIMITER $$

CREATE TRIGGER trg_before_insert_move
BEFORE INSERT ON moves
FOR EACH ROW
BEGIN
  SET NEW.title = TRIM(NEW.title);
  
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Move title cannot be empty';
  END IF;
  
  IF NEW.move_date IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Move date is required';
  END IF;
  
  IF NEW.from_address_id = NEW.to_address_id THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'From and to addresses must be different';
  END IF;
  
  IF NEW.status IS NULL THEN
    SET NEW.status = 'planned';
  END IF;
END$$

DELIMITER ;

-- Validate and normalize move data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_move;

DELIMITER $$

CREATE TRIGGER trg_before_update_move
BEFORE UPDATE ON moves
FOR EACH ROW
BEGIN
  SET NEW.title = TRIM(NEW.title);
  
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Move title cannot be empty';
  END IF;
  
  IF NEW.move_date IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Move date is required';
  END IF;
  
  IF NEW.from_address_id = NEW.to_address_id THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'From and to addresses must be different';
  END IF;
END$$

DELIMITER ;
