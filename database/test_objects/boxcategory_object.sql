-- ============================================
-- Box Category Procedures
-- ============================================

use movemind_db;


-- Check if a category exists
DELIMITER $$

CREATE PROCEDURE sp_check_category_exists(
  IN p_category_id INT,
  OUT p_exists BOOLEAN
)
BEGIN
  DECLARE cat_count INT;
  
  SELECT COUNT(*) INTO cat_count
  FROM categories
  WHERE id = p_category_id;
  
  SET p_exists = (cat_count > 0);
END$$

DELIMITER ;

-- List all categories for a specific box
DELIMITER $$

CREATE PROCEDURE sp_list_categories_for_box(
  IN p_box_id INT
)
BEGIN
  SELECT c.id, c.name
  FROM box_categories bc
  JOIN categories c ON c.id = bc.category_id
  WHERE bc.box_id = p_box_id
  ORDER BY c.name ASC;
END$$

DELIMITER ;

-- Attach a category to a box (idempotent - won't error if already exists)
DELIMITER $$

CREATE PROCEDURE sp_attach_category_to_box(
  IN p_box_id INT,
  IN p_category_id INT,
  OUT p_created BOOLEAN
)
BEGIN
  DECLARE existing_count INT;
  
  -- Check if link already exists
  SELECT COUNT(*) INTO existing_count
  FROM box_categories
  WHERE box_id = p_box_id AND category_id = p_category_id;
  
  IF existing_count > 0 THEN
    SET p_created = FALSE;
  ELSE
    INSERT INTO box_categories (box_id, category_id)
    VALUES (p_box_id, p_category_id);
    
    SET p_created = TRUE;
  END IF;
END$$

DELIMITER ;

-- Detach a category from a box
DELIMITER $$

CREATE PROCEDURE sp_detach_category_from_box(
  IN p_box_id INT,
  IN p_category_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE link_exists INT;
  
  -- Check if link exists
  SELECT COUNT(*) INTO link_exists
  FROM box_categories
  WHERE box_id = p_box_id AND category_id = p_category_id;
  
  IF link_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Link not found';
  ELSE
    DELETE FROM box_categories
    WHERE box_id = p_box_id AND category_id = p_category_id;
    
    SET p_success = TRUE;
    SET p_message = 'Category detached from box';
  END IF;
END$$

DELIMITER ;