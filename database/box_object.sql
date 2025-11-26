-- ============================================
-- Box Procedures 
-- ============================================

-- Check if user owns a room 
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_room(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100),
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE room_count INT;
  
  SELECT COUNT(*) INTO room_count
  FROM rooms r
  JOIN moves m ON m.id = r.move_id
  WHERE r.move_id = p_move_id 
    AND r.name = p_room_name 
    AND m.user_id = p_user_id;
  
  SET p_owns = (room_count > 0);
END$$

DELIMITER ;

-- List boxes by room with optional status filter
DELIMITER $$

CREATE PROCEDURE sp_list_boxes_by_room(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100),
  IN p_status VARCHAR(20)
)
BEGIN
  IF p_status IS NULL THEN
    SELECT id, move_id, room_name, label_code, fragile, weight, status
    FROM boxes
    WHERE move_id = p_move_id AND room_name = p_room_name
    ORDER BY id DESC;
  ELSE
    SELECT id, move_id, room_name, label_code, fragile, weight, status
    FROM boxes
    WHERE move_id = p_move_id AND room_name = p_room_name AND status = p_status
    ORDER BY id DESC;
  END IF;
END$$

DELIMITER ;

-- Create a new box
DELIMITER $$

CREATE PROCEDURE sp_create_box(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100),
  IN p_label_code VARCHAR(50),
  IN p_fragile TINYINT(1),
  IN p_weight DECIMAL(10,2),
  IN p_status VARCHAR(20)
)
BEGIN
  INSERT INTO boxes (move_id, room_name, label_code, fragile, weight, status)
  VALUES (p_move_id, p_room_name, p_label_code, p_fragile, p_weight, p_status);
  
  SELECT LAST_INSERT_ID() AS id;
END$$

DELIMITER ;

-- Check if user owns a box
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_box(
  IN p_box_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE box_count INT;
  
  SELECT COUNT(*) INTO box_count
  FROM boxes b
  JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
  JOIN moves m ON m.id = r.move_id
  WHERE b.id = p_box_id AND m.user_id = p_user_id;
  
  SET p_owns = (box_count > 0);
END$$

DELIMITER ;

-- Get a single box by ID
DELIMITER $$

CREATE PROCEDURE sp_get_box(
  IN p_box_id INT
)
BEGIN
  SELECT id, move_id, room_name, label_code, fragile, weight, status
  FROM boxes
  WHERE id = p_box_id
  LIMIT 1;
END$$

DELIMITER ;

-- Update box with partial field support (SINGLE PROCEDURE)
DELIMITER $$

CREATE PROCEDURE sp_update_box(
  IN p_box_id INT,
  IN p_label_code VARCHAR(50),
  IN p_fragile TINYINT(1),
  IN p_weight DECIMAL(10,2),
  IN p_status VARCHAR(20)
)
BEGIN
  -- Use COALESCE to only update provided fields (NULL = keep current value)
  UPDATE boxes
  SET 
    label_code = COALESCE(p_label_code, label_code),
    fragile = COALESCE(p_fragile, fragile),
    weight = IF(p_weight IS NULL, weight, p_weight),
    status = COALESCE(p_status, status)
  WHERE id = p_box_id
  LIMIT 1;
END$$

DELIMITER ;

-- Delete a box
DELIMITER $$

CREATE PROCEDURE sp_delete_box(
  IN p_box_id INT
)
BEGIN
  DELETE FROM boxes
  WHERE id = p_box_id
  LIMIT 1;
END$$

DELIMITER ;

-- Scan box by label code
DELIMITER $$

CREATE PROCEDURE sp_scan_box_by_label(
  IN p_label_code VARCHAR(50),
  IN p_user_id INT
)
BEGIN
  SELECT b.id, b.move_id, b.room_name, b.label_code, b.fragile, b.weight, b.status
  FROM boxes b
  JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
  JOIN moves m ON m.id = r.move_id
  WHERE b.label_code = p_label_code AND m.user_id = p_user_id
  LIMIT 1;
END$$

DELIMITER ;

-- ============================================
-- Box Triggers
-- ============================================

-- Validate and normalize box data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_box;

DELIMITER $$

CREATE TRIGGER trg_before_insert_box
BEFORE INSERT ON boxes
FOR EACH ROW
BEGIN
  -- Trim label_code
  SET NEW.label_code = TRIM(NEW.label_code);
  
  -- Validate label_code is not empty
  IF NEW.label_code = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Label code cannot be empty';
  END IF;
  
  -- Normalize fragile to 0 or 1
  IF NEW.fragile IS NULL THEN
    SET NEW.fragile = 0;
  ELSEIF NEW.fragile NOT IN (0, 1) THEN
    SET NEW.fragile = IF(NEW.fragile > 0, 1, 0);
  END IF;
  
  -- Validate weight is positive if provided
  IF NEW.weight IS NOT NULL AND NEW.weight < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Weight cannot be negative';
  END IF;
  
  -- Set default status if null
  IF NEW.status IS NULL THEN
    SET NEW.status = 'empty';
  END IF;
END$$

DELIMITER ;

-- Validate and normalize box data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_box;

DELIMITER $$

CREATE TRIGGER trg_before_update_box
BEFORE UPDATE ON boxes
FOR EACH ROW
BEGIN
  -- Trim label_code
  SET NEW.label_code = TRIM(NEW.label_code);
  
  -- Validate label_code is not empty
  IF NEW.label_code = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Label code cannot be empty';
  END IF;
  
  -- Normalize fragile to 0 or 1
  IF NEW.fragile NOT IN (0, 1) THEN
    SET NEW.fragile = IF(NEW.fragile > 0, 1, 0);
  END IF;
  
  -- Validate weight is positive if provided
  IF NEW.weight IS NOT NULL AND NEW.weight < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Weight cannot be negative';
  END IF;
END$$

DELIMITER ;