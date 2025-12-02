-- Procedures

-- Listing all categories.
DELIMITER $$

CREATE PROCEDURE sp_list_categories()
BEGIN
  SELECT id, name 
  FROM categories 
  ORDER BY name ASC;
END$$

DELIMITER ;

-- Creating a category
DELIMITER $$

CREATE PROCEDURE sp_create_category(
  IN p_name VARCHAR(100),
  OUT p_category_id INT,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE existing_count INT;
  
  -- Check if category already exists
  SELECT COUNT(*) INTO existing_count
  FROM categories
  WHERE name = p_name;
  
  IF existing_count > 0 THEN
    SET p_category_id = NULL;
    SET p_message = 'Category already exists';
  ELSE
    INSERT INTO categories (name)
    VALUES (p_name);
    
    SET p_category_id = LAST_INSERT_ID();
    SET p_message = 'Category created';
  END IF;
END$$

DELIMITER ;

-- updating a category
DELIMITER $$

CREATE PROCEDURE sp_update_category(
  IN p_category_id INT,
  IN p_name VARCHAR(100),
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE category_exists INT;
  DECLARE name_taken INT;
  
  -- Check if category exists
  SELECT COUNT(*) INTO category_exists
  FROM categories
  WHERE id = p_category_id;
  
  IF category_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Category not found';
  ELSE
    -- Check if new name is already taken by another category
    SELECT COUNT(*) INTO name_taken
    FROM categories
    WHERE name = p_name AND id != p_category_id;
    
    IF name_taken > 0 THEN
      SET p_success = FALSE;
      SET p_message = 'Category already exists';
    ELSE
      UPDATE categories
      SET name = p_name
      WHERE id = p_category_id;
      
      SET p_success = TRUE;
      SET p_message = 'Category updated';
    END IF;
  END IF;
END$$

DELIMITER ;


-- Delete a categpry.
DELIMITER $$

CREATE PROCEDURE sp_delete_category(
  IN p_category_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE category_exists INT;
  
  -- Check if category exists
  SELECT COUNT(*) INTO category_exists
  FROM categories
  WHERE id = p_category_id;
  
  IF category_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Category not found';
  ELSE
    DELETE FROM categories
    WHERE id = p_category_id
    LIMIT 1;
    
    SET p_success = TRUE;
    SET p_message = 'Category deleted';
  END IF;
END$$

DELIMITER ;



-- Triggers


-- Normalizing category name on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_category;

DELIMITER $$

CREATE TRIGGER trg_before_insert_category
BEFORE INSERT ON categories
FOR EACH ROW
BEGIN
  SET NEW.name = TRIM(NEW.name);
  
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Category name cannot be empty';
  END IF;
END$$

DELIMITER ;

-- Normalizing category name on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_category;

DELIMITER $$

CREATE TRIGGER trg_before_update_category
BEFORE UPDATE ON categories
FOR EACH ROW
BEGIN
  SET NEW.name = TRIM(NEW.name);
  
  IF NEW.name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Category name cannot be empty';
  END IF;
END$$

DELIMITER ;

