-- ============================================
-- Item Procedures
-- ============================================

-- Check if user owns a box through ownership chain (boxes -> rooms -> moves -> users)
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

-- List all items for a specific box
DELIMITER $$

CREATE PROCEDURE sp_list_items_by_box(
  IN p_box_id INT
)
BEGIN
  SELECT id, box_id, name, quantity, value
  FROM items
  WHERE box_id = p_box_id
  ORDER BY id DESC;
END$$

DELIMITER ;

-- Create a new item in a box
DELIMITER $$

CREATE PROCEDURE sp_create_item(
  IN p_box_id INT,
  IN p_name VARCHAR(200),
  IN p_quantity INT,
  IN p_value DECIMAL(10,2)
)
BEGIN
  INSERT INTO items (box_id, name, quantity, value)
  VALUES (p_box_id, p_name, p_quantity, p_value);
  
  SELECT LAST_INSERT_ID() AS id;
END$$

DELIMITER ;

-- Check if user owns an item through ownership chain (items -> boxes -> rooms -> moves -> users)
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_item(
  IN p_item_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE item_count INT;
  
  SELECT COUNT(*) INTO item_count
  FROM items i
  JOIN boxes b ON b.id = i.box_id
  JOIN rooms r ON r.move_id = b.move_id AND r.name = b.room_name
  JOIN moves m ON m.id = r.move_id
  WHERE i.id = p_item_id AND m.user_id = p_user_id;
  
  SET p_owns = (item_count > 0);
END$$

DELIMITER ;

-- Get a single item by ID
DELIMITER $$

CREATE PROCEDURE sp_get_item(
  IN p_item_id INT
)
BEGIN
  SELECT id, box_id, name, quantity, value
  FROM items
  WHERE id = p_item_id
  LIMIT 1;
END$$

DELIMITER ;

-- Update item with partial field support (NULL = keep current value)
DELIMITER $$

CREATE PROCEDURE sp_update_item(
  IN p_item_id INT,
  IN p_name VARCHAR(200),
  IN p_quantity INT,
  IN p_value DECIMAL(10,2)
)
BEGIN
  UPDATE items
  SET 
    name = COALESCE(p_name, name),
    quantity = COALESCE(p_quantity, quantity),
    value = IF(p_value IS NULL, value, p_value)
  WHERE id = p_item_id
  LIMIT 1;
END$$

DELIMITER ;

-- Delete an item
DELIMITER $$

CREATE PROCEDURE sp_delete_item(
  IN p_item_id INT
)
BEGIN
  DELETE FROM items
  WHERE id = p_item_id
  LIMIT 1;
END$$

DELIMITER ;

-- ============================================
-- Item Triggers
-- ============================================

-- Validate and normalize item data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_item;

DELIMITER $$

CREATE TRIGGER trg_before_insert_item
BEFORE INSERT ON items
FOR EACH ROW
BEGIN
  -- Trim item name
  SET NEW.name = TRIM(NEW.name);
  
  -- Validate name is not empty
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Item name cannot be empty';
  END IF;
  
  -- Set default quantity if null or negative
  IF NEW.quantity IS NULL OR NEW.quantity < 1 THEN
    SET NEW.quantity = 1;
  END IF;
  
  -- Validate value is not negative if provided
  IF NEW.value IS NOT NULL AND NEW.value < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Item value cannot be negative';
  END IF;
END$$

DELIMITER ;

-- Validate and normalize item data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_item;

DELIMITER $$

CREATE TRIGGER trg_before_update_item
BEFORE UPDATE ON items
FOR EACH ROW
BEGIN
  -- Trim item name
  SET NEW.name = TRIM(NEW.name);
  
  -- Validate name is not empty
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Item name cannot be empty';
  END IF;
  
  -- Ensure quantity is at least 1
  IF NEW.quantity < 1 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Item quantity must be at least 1';
  END IF;
  
  -- Validate value is not negative if provided
  IF NEW.value IS NOT NULL AND NEW.value < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Item value cannot be negative';
  END IF;
END$$

DELIMITER ;