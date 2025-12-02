DELIMITER $$

CREATE PROCEDURE sp_register_user(
  IN p_first_name VARCHAR(50),
  IN p_last_name VARCHAR(50),
  IN p_email VARCHAR(100),
  IN p_password VARCHAR(255),
  OUT p_user_id INT,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE existing_count INT;
  
  -- Checking if email exists
  SELECT COUNT(*) INTO existing_count 
  FROM users 
  WHERE email = p_email;
  
  IF existing_count > 0 THEN
    SET p_user_id = NULL;
    SET p_message = 'User already exists';
  ELSE
    INSERT INTO users (first_name, last_name, email, password)
    VALUES (p_first_name, p_last_name, p_email, p_password);
    
    SET p_user_id = LAST_INSERT_ID();
    SET p_message = 'User registered successfully';
  END IF;
END$$

DELIMITER ;



-- Retrieves user credentials for authentication.

DELIMITER $$

CREATE PROCEDURE sp_get_user_by_email(
  IN p_email VARCHAR(100)
)
BEGIN
  SELECT id, first_name, last_name, email, password, created_at
  FROM users
  WHERE email = p_email;
END$$

DELIMITER ;


-- Getting the user by id

DELIMITER $$

CREATE PROCEDURE sp_get_user_by_id(
  IN p_user_id INT
)
BEGIN
  SELECT id, first_name, last_name, email, created_at
  FROM users 
  WHERE id = p_user_id;
END$$

DELIMITER ;


-- Checking if email exists

DELIMITER $$

CREATE FUNCTION fn_email_exists(
  p_email VARCHAR(100)
)
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE user_count INT;
  
  SELECT COUNT(*) INTO user_count
  FROM users
  WHERE email = p_email;
  
  RETURN user_count > 0;
END$$

DELIMITER ;




-- TRIGGERS

DROP TRIGGER IF EXISTS trg_before_insert_user;
DROP TRIGGER IF EXISTS trg_before_update_user;
DELIMITER $$

-- Combined INSERT trigger

CREATE TRIGGER trg_before_insert_user
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  -- Step 1: Normalize data
  SET NEW.email = LOWER(TRIM(NEW.email));
  SET NEW.first_name = TRIM(NEW.first_name);
  SET NEW.last_name = TRIM(NEW.last_name);
  
  -- Step 2: Validate (after trimming)
  IF NEW.first_name = '' OR NEW.last_name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'First name and last name cannot be empty';
  END IF;
  
  -- Step 3: Validate email format
  IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid email format';
  END IF;
END$$

-- Combined UPDATE trigger

CREATE TRIGGER trg_before_update_user
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
  -- Step 1: Normalize data
  SET NEW.email = LOWER(TRIM(NEW.email));
  SET NEW.first_name = TRIM(NEW.first_name);
  SET NEW.last_name = TRIM(NEW.last_name);
  
  -- Step 2: Validate (after trimming)
  IF NEW.first_name = '' OR NEW.last_name = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'First name and last name cannot be empty';
  END IF;
  
  -- Step 3: Validate email format
  IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Invalid email format';
  END IF;
END$$

DELIMITER ;