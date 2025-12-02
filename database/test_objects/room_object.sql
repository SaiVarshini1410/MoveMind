-- ============================================
-- Room Procedures
-- ============================================

-- Check if user owns a move (helper function)
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_move(
  IN p_move_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE move_count INT;
  
  SELECT COUNT(*) INTO move_count
  FROM moves
  WHERE id = p_move_id AND user_id = p_user_id;
  
  SET p_owns = (move_count > 0);
END$$

DELIMITER ;

-- List all rooms for a move
DELIMITER $$

CREATE PROCEDURE sp_list_rooms(
  IN p_move_id INT
)
BEGIN
  SELECT move_id, name, floor
  FROM rooms
  WHERE move_id = p_move_id
  ORDER BY name ASC;
END$$

DELIMITER ;

-- Check if room exists and user owns move
DELIMITER $$

CREATE PROCEDURE sp_check_room_and_ownership(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100),
  IN p_user_id INT,
  OUT p_exists BOOLEAN
)
BEGIN
  DECLARE room_count INT;
  
  SELECT COUNT(*) INTO room_count
  FROM rooms r
  JOIN moves m ON m.id = r.move_id
  WHERE r.move_id = p_move_id 
    AND r.name = p_room_name 
    AND m.user_id = p_user_id;
  
  SET p_exists = (room_count > 0);
END$$

DELIMITER ;

-- Create a new room
DELIMITER $$

CREATE PROCEDURE sp_create_room(
  IN p_move_id INT,
  IN p_name VARCHAR(100),
  IN p_floor VARCHAR(50)
)
BEGIN
  INSERT INTO rooms (move_id, name, floor)
  VALUES (p_move_id, p_name, p_floor);
END$$

DELIMITER ;

-- Update room name only
DELIMITER $$

CREATE PROCEDURE sp_update_room_name(
  IN p_move_id INT,
  IN p_old_name VARCHAR(100),
  IN p_new_name VARCHAR(100)
)
BEGIN
  UPDATE rooms
  SET name = p_new_name
  WHERE move_id = p_move_id AND name = p_old_name
  LIMIT 1;
END$$

DELIMITER ;

-- Update room floor only
DELIMITER $$

CREATE PROCEDURE sp_update_room_floor(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100),
  IN p_floor VARCHAR(50)
)
BEGIN
  UPDATE rooms
  SET floor = p_floor
  WHERE move_id = p_move_id AND name = p_room_name
  LIMIT 1;
END$$

DELIMITER ;

-- Update both room name and floor
DELIMITER $$

CREATE PROCEDURE sp_update_room_both(
  IN p_move_id INT,
  IN p_old_name VARCHAR(100),
  IN p_new_name VARCHAR(100),
  IN p_floor VARCHAR(50)
)
BEGIN
  UPDATE rooms
  SET name = p_new_name, floor = p_floor
  WHERE move_id = p_move_id AND name = p_old_name
  LIMIT 1;
END$$

DELIMITER ;

-- Delete a room
DELIMITER $$

CREATE PROCEDURE sp_delete_room(
  IN p_move_id INT,
  IN p_room_name VARCHAR(100)
)
BEGIN
  DELETE FROM rooms
  WHERE move_id = p_move_id AND name = p_room_name
  LIMIT 1;
END$$

DELIMITER ;

-- ============================================
-- Room Triggers
-- ============================================

-- Validate and normalize room data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_room;

DELIMITER $$

CREATE TRIGGER trg_before_insert_room
BEFORE INSERT ON rooms
FOR EACH ROW
BEGIN
  SET NEW.name = TRIM(NEW.name);
  
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Room name cannot be empty';
  END IF;
  
  IF NEW.floor IS NOT NULL THEN
    SET NEW.floor = TRIM(NEW.floor);
    IF NEW.floor = '' THEN
      SET NEW.floor = NULL;
    END IF;
  END IF;
END$$

DELIMITER ;

-- Validate and normalize room data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_room;

DELIMITER $$

CREATE TRIGGER trg_before_update_room
BEFORE UPDATE ON rooms
FOR EACH ROW
BEGIN
  SET NEW.name = TRIM(NEW.name);
  
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Room name cannot be empty';
  END IF;
  
  IF NEW.floor IS NOT NULL THEN
    SET NEW.floor = TRIM(NEW.floor);
    IF NEW.floor = '' THEN
      SET NEW.floor = NULL;
    END IF;
  END IF;
END$$

DELIMITER ;