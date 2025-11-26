-- Procedures

-- Listing all user addresses.
DELIMITER $$

CREATE PROCEDURE sp_list_user_addresses(
  IN p_user_id INT
)
BEGIN
  SELECT
    a.id,
    ua.label,
    a.line1,
    a.line2,
    a.city,
    a.state,
    a.postal_code,
    a.country
  FROM user_addresses ua
  JOIN addresses a ON a.id = ua.address_id
  WHERE ua.user_id = p_user_id
  ORDER BY a.id DESC;
END$$

DELIMITER ;

-- Finding existing addresses.
DELIMITER $$

CREATE PROCEDURE sp_find_address(
  IN p_line1 VARCHAR(255),
  IN p_line2 VARCHAR(255),
  IN p_city VARCHAR(100),
  IN p_state VARCHAR(100),
  IN p_postal_code VARCHAR(100),
  IN p_country VARCHAR(100),
  OUT p_address_id INT
)
BEGIN
  SET p_line2 = NULLIF(TRIM(p_line2), '');
  
 
  SELECT id INTO p_address_id
  FROM addresses
  WHERE line1 = p_line1
    AND city = p_city
    AND state = p_state
    AND postal_code = p_postal_code
    AND country = p_country
    AND (
      (line2 IS NULL AND p_line2 IS NULL) OR
      (line2 = p_line2)
    )
  LIMIT 1;
END$$

DELIMITER ;


-- Insert new address.
DELIMITER $$

CREATE PROCEDURE sp_insert_address(
  IN p_line1 VARCHAR(255),
  IN p_line2 VARCHAR(255),
  IN p_city VARCHAR(100),
  IN p_state VARCHAR(100),
  IN p_postal_code VARCHAR(100),
  IN p_country VARCHAR(100),
  OUT p_address_id INT
)
BEGIN

  SET p_line2 = NULLIF(TRIM(p_line2), '');

  INSERT INTO addresses (line1, line2, city, state, postal_code, country)
  VALUES (p_line1, p_line2, p_city, p_state, p_postal_code, p_country);
  
  SET p_address_id = LAST_INSERT_ID();
END$$

DELIMITER ;


-- Checking if the user already has an address.
DELIMITER $$

CREATE PROCEDURE sp_check_user_has_address(
  IN p_user_id INT,
  IN p_address_id INT,
  OUT p_exists BOOLEAN
)
BEGIN
  DECLARE link_count INT;
  
  SELECT COUNT(*) INTO link_count
  FROM user_addresses
  WHERE user_id = p_user_id AND address_id = p_address_id;
  
  SET p_exists = (link_count > 0);
END$$

DELIMITER ;


-- Linking the address to the user.
DELIMITER $$

CREATE PROCEDURE sp_link_user_address(
  IN p_user_id INT,
  IN p_address_id INT,
  IN p_label VARCHAR(255)
)
BEGIN
  INSERT INTO user_addresses (user_id, address_id, label)
  VALUES (p_user_id, p_address_id, p_label);
END$$

DELIMITER ;


-- TRIGGERS

-- Normalizing address on insert
DROP TRIGGER IF EXISTS trg_before_insert_address;

DELIMITER $$

CREATE TRIGGER trg_before_insert_address
BEFORE INSERT ON addresses
FOR EACH ROW
BEGIN
  -- Trim all fields
  SET NEW.line1 = TRIM(NEW.line1);
  SET NEW.line2 = NULLIF(TRIM(NEW.line2), '');
  SET NEW.city = TRIM(NEW.city);
  SET NEW.state = TRIM(NEW.state);
  SET NEW.postal_code = TRIM(NEW.postal_code);
  SET NEW.country = TRIM(NEW.country);
  
  -- Validate required fields are not empty
  IF NEW.line1 = '' OR NEW.city = '' OR NEW.state = '' 
     OR NEW.postal_code = '' OR NEW.country = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Address fields cannot be empty';
  END IF;
END$$

DELIMITER ;


-- Normalize address on update.
DROP TRIGGER IF EXISTS trg_before_update_address;

DELIMITER $$

CREATE TRIGGER trg_before_update_address
BEFORE UPDATE ON addresses
FOR EACH ROW
BEGIN
  -- Trim all fields
  SET NEW.line1 = TRIM(NEW.line1);
  SET NEW.line2 = NULLIF(TRIM(NEW.line2), '');
  SET NEW.city = TRIM(NEW.city);
  SET NEW.state = TRIM(NEW.state);
  SET NEW.postal_code = TRIM(NEW.postal_code);
  SET NEW.country = TRIM(NEW.country);
  
  -- Validate required fields are not empty
  IF NEW.line1 = '' OR NEW.city = '' OR NEW.state = '' 
     OR NEW.postal_code = '' OR NEW.country = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Address fields cannot be empty';
  END IF;
END$$

DELIMITER ;


-- Validating user address label on insert.

DROP TRIGGER IF EXISTS trg_before_insert_user_address;

DELIMITER $$

CREATE TRIGGER trg_before_insert_user_address
BEFORE INSERT ON user_addresses
FOR EACH ROW
BEGIN
  -- Trim label
  SET NEW.label = TRIM(NEW.label);
  
  -- Validate label is not empty
  IF NEW.label = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Address label cannot be empty';
  END IF;
END$$

DELIMITER ;


-- Validating user address label on update.
DROP TRIGGER IF EXISTS trg_before_update_user_address;

DELIMITER $$

CREATE TRIGGER trg_before_update_user_address
BEFORE UPDATE ON user_addresses
FOR EACH ROW
BEGIN
  -- Trim label
  SET NEW.label = TRIM(NEW.label);
  
  -- Validate label is not empty
  IF NEW.label = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Address label cannot be empty';
  END IF;
END$$

DELIMITER ;