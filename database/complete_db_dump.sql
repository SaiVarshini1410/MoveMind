-- CREATE COMMANDS

CREATE DATABASE IF NOT EXISTS movemind_db;
USE movemind_db;


-- 1) Users
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_email (email)
);

-- 2) addresses
CREATE TABLE IF NOT EXISTS addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  line1 VARCHAR(255) NOT NULL,
  line2 VARCHAR(255) NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  postal_code VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  UNIQUE KEY uq_addresses_physical (
    line1(100),
    line2(100),
    city(50),
    state(50),
    postal_code(20),
    country(50)
  )
);


-- 3) User_address
CREATE TABLE IF NOT EXISTS user_addresses (
  user_id INT NOT NULL,
  address_id INT NOT NULL,
  label VARCHAR(100) NOT NULL,
  PRIMARY KEY (user_id, address_id),
  CONSTRAINT fk_user_addresses_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_user_addresses_address
    FOREIGN KEY (address_id) REFERENCES addresses(id)
    ON DELETE CASCADE
);

-- 4) Category
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- 5) Utility
CREATE TABLE IF NOT EXISTS utilities (
  id INT AUTO_INCREMENT PRIMARY KEY,
  provider_name VARCHAR(100) NOT NULL,
  type ENUM ('electricity','gas','water','internet','trash','other') NOT NULL
);

-- 6) Move  (FK references to Users/addresses)
CREATE TABLE IF NOT EXISTS moves (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  move_date DATE NOT NULL,
  status ENUM('planned','packing','in_transit','unpacking','done') DEFAULT 'planned',
  from_address_id INT NOT NULL,
  to_address_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (from_address_id) REFERENCES addresses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (to_address_id) REFERENCES addresses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_status (status),
  INDEX idx_move_date (move_date)
);


-- 6) Room (depends on Move)
CREATE TABLE IF NOT EXISTS rooms (
  name VARCHAR(100) NOT NULL,
  floor VARCHAR(50) NULL,
  move_id INT NOT NULL,
  FOREIGN KEY (move_id) REFERENCES moves(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_rooms_move (move_id),
  PRIMARY KEY (move_id, name)
);

-- 7) Box (depends on Room) 
CREATE TABLE IF NOT EXISTS boxes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  move_id INT NOT NULL,
  room_name VARCHAR(100) NOT NULL,
  label_code VARCHAR(50) UNIQUE NOT NULL,
  fragile TINYINT(1) DEFAULT 0,
  weight DECIMAL(10,2) NULL,
  status ENUM('empty','packed','loaded','delivered','unpacked') DEFAULT 'empty',
  CONSTRAINT fk_boxes_room
    FOREIGN KEY (move_id, room_name)
    REFERENCES rooms(move_id, name)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  INDEX idx_boxes_room (move_id, room_name),
  INDEX idx_boxes_status (status)
);

-- 8) Items (depends on Box)
CREATE TABLE IF NOT EXISTS items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  box_id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  quantity INT DEFAULT 1,
  value DECIMAL(10,2),
  FOREIGN KEY (box_id) REFERENCES boxes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_items_box (box_id)
);

-- 9) box_categories (depends on Box, Category)
CREATE TABLE IF NOT EXISTS box_categories (
  box_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (box_id, category_id),
  FOREIGN KEY (box_id) REFERENCES boxes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_category_id (category_id)
);

-- 10) move_utilities (depends on Move, Utility)
CREATE TABLE IF NOT EXISTS move_utilities (
  utility_id INT NOT NULL,
  move_id INT NOT NULL,
  account_number VARCHAR(100),
  stop_date DATE,
  start_date DATE,
  status ENUM('planned','requested','confirmed','active','cancelled') DEFAULT 'planned',
  CONSTRAINT mv_f1 FOREIGN KEY (utility_id) REFERENCES utilities(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT mv_f2 FOREIGN KEY (move_id) REFERENCES moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT mv_pk PRIMARY KEY (move_id, utility_id),
  INDEX idx_mu_move (move_id),
  INDEX idx_mu_utility (utility_id),
  INDEX idx_mu_status (status)
);

-- 11) Appointment (depends on Move)
CREATE TABLE IF NOT EXISTS appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  move_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  apt_date DATE NOT NULL,
  apt_time TIME NOT NULL,
  person VARCHAR(100),
  contact_person VARCHAR(100) NULL,
  contact_phone VARCHAR(20),
  status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
  FOREIGN KEY (move_id) REFERENCES moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_appt_move (move_id),
  INDEX idx_appt_status (status),
  INDEX idx_appt_date (apt_date)
);

-- 12) Document (depends on Move)
CREATE TABLE IF NOT EXISTS documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  move_id INT NOT NULL,
  doc_type VARCHAR(100) NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  uploaded_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (move_id) REFERENCES moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_doc_type (doc_type),
  INDEX idx_documents_move (move_id)
);



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

-- Appointment

USE movemind_db;

DROP PROCEDURE IF EXISTS sp_check_user_owns_move;
DROP PROCEDURE IF EXISTS sp_list_appointments_by_move;
DROP PROCEDURE IF EXISTS sp_create_appointment;
DROP PROCEDURE IF EXISTS sp_check_user_owns_appointment;
DROP PROCEDURE IF EXISTS sp_get_appointment;
DROP PROCEDURE IF EXISTS sp_update_appointment;
DROP PROCEDURE IF EXISTS sp_delete_appointment;

DROP TRIGGER IF EXISTS trg_before_insert_appointment;
DROP TRIGGER IF EXISTS trg_before_update_appointment;

DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_move(
  IN p_move_id INT,
  IN p_user_id INT
)
BEGIN
  DECLARE move_count INT;
  SELECT COUNT(*) INTO move_count
  FROM moves
  WHERE id = p_move_id AND user_id = p_user_id;
  SELECT (move_count > 0) AS owns;
END$$

CREATE PROCEDURE sp_list_appointments_by_move(
  IN p_move_id INT,
  IN p_status VARCHAR(20),
  IN p_date DATE
)
BEGIN
  IF p_status IS NULL AND p_date IS NULL THEN
    SELECT id, move_id, title, description, person, apt_date, apt_time,
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSEIF p_status IS NOT NULL AND p_date IS NULL THEN
    SELECT id, move_id, title, description, person, apt_date, apt_time,
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND status = p_status
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSEIF p_status IS NULL AND p_date IS NOT NULL THEN
    SELECT id, move_id, title, description, person, apt_date, apt_time,
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND apt_date = p_date
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSE
    SELECT id, move_id, title, description, person, apt_date, apt_time,
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND status = p_status AND apt_date = p_date
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  END IF;
END$$

CREATE PROCEDURE sp_create_appointment(
  IN p_move_id INT,
  IN p_title VARCHAR(200),
  IN p_description TEXT,
  IN p_person VARCHAR(100),
  IN p_apt_date DATE,
  IN p_apt_time TIME,
  IN p_contact_person VARCHAR(100),
  IN p_contact_phone VARCHAR(20),
  IN p_status VARCHAR(20)
)
BEGIN
  INSERT INTO appointments
    (move_id, title, description, person, apt_date, apt_time,
     contact_person, contact_phone, status)
  VALUES (p_move_id, p_title, p_description, p_person, p_apt_date, p_apt_time,
          p_contact_person, p_contact_phone, p_status);
  SELECT LAST_INSERT_ID() AS id;
END$$

CREATE PROCEDURE sp_check_user_owns_appointment(
  IN p_appointment_id INT,
  IN p_user_id INT
)
BEGIN
  DECLARE appt_count INT;
  SELECT COUNT(*) INTO appt_count
  FROM appointments a
  JOIN moves m ON m.id = a.move_id
  WHERE a.id = p_appointment_id AND m.user_id = p_user_id;
  SELECT (appt_count > 0) AS owns;
END$$

CREATE PROCEDURE sp_get_appointment(
  IN p_appointment_id INT
)
BEGIN
  SELECT id, move_id, title, description, person, apt_date, apt_time,
         contact_person, contact_phone, status
  FROM appointments
  WHERE id = p_appointment_id
  LIMIT 1;
END$$

CREATE PROCEDURE sp_update_appointment(
  IN p_appointment_id INT,
  IN p_title VARCHAR(200),
  IN p_description TEXT,
  IN p_person VARCHAR(100),
  IN p_apt_date DATE,
  IN p_apt_time TIME,
  IN p_contact_person VARCHAR(100),
  IN p_contact_phone VARCHAR(20),
  IN p_status VARCHAR(20)
)
BEGIN
  UPDATE appointments
  SET
    title = COALESCE(p_title, title),
    description = IF(p_description IS NULL, description, p_description),
    person = IF(p_person IS NULL, person, p_person),
    apt_date = COALESCE(p_apt_date, apt_date),
    apt_time = COALESCE(p_apt_time, apt_time),
    contact_person = IF(p_contact_person IS NULL, contact_person, p_contact_person),
    contact_phone = IF(p_contact_phone IS NULL, contact_phone, p_contact_phone),
    status = COALESCE(p_status, status)
  WHERE id = p_appointment_id;
END$$

CREATE PROCEDURE sp_delete_appointment(
  IN p_appointment_id INT,
  IN p_user_id INT
)
BEGIN
  DECLARE appt_exists INT;
  SELECT COUNT(*) INTO appt_exists
  FROM appointments a
  JOIN moves m ON m.id = a.move_id
  WHERE a.id = p_appointment_id AND m.user_id = p_user_id;
  IF appt_exists = 0 THEN
    SELECT 0 AS success, 'Appointment not found' AS message;
  ELSE
    DELETE FROM appointments
    WHERE id = p_appointment_id;
    SELECT 1 AS success, 'Appointment deleted' AS message;
  END IF;
END$$

CREATE TRIGGER trg_before_insert_appointment
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
  SET NEW.title = TRIM(NEW.title);
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment title cannot be empty';
  END IF;
  IF NEW.description IS NOT NULL THEN
    SET NEW.description = TRIM(NEW.description);
    IF NEW.description = '' THEN
      SET NEW.description = NULL;
    END IF;
  END IF;
  IF NEW.person IS NOT NULL THEN
    SET NEW.person = TRIM(NEW.person);
    IF NEW.person = '' THEN
      SET NEW.person = NULL;
    END IF;
  END IF;
  IF NEW.contact_person IS NOT NULL THEN
    SET NEW.contact_person = TRIM(NEW.contact_person);
    IF NEW.contact_person = '' THEN
      SET NEW.contact_person = NULL;
    END IF;
  END IF;
  IF NEW.contact_phone IS NOT NULL THEN
    SET NEW.contact_phone = TRIM(NEW.contact_phone);
    IF NEW.contact_phone = '' THEN
      SET NEW.contact_phone = NULL;
    END IF;
  END IF;
  IF NEW.status IS NULL THEN
    SET NEW.status = 'scheduled';
  END IF;
  IF NEW.apt_date IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment date is required';
  END IF;
  IF NEW.apt_time IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment time is required';
  END IF;
END$$

CREATE TRIGGER trg_before_update_appointment
BEFORE UPDATE ON appointments
FOR EACH ROW
BEGIN
  SET NEW.title = TRIM(NEW.title);
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment title cannot be empty';
  END IF;
  IF NEW.description IS NOT NULL THEN
    SET NEW.description = TRIM(NEW.description);
    IF NEW.description = '' THEN
      SET NEW.description = NULL;
    END IF;
  END IF;
  IF NEW.person IS NOT NULL THEN
    SET NEW.person = TRIM(NEW.person);
    IF NEW.person = '' THEN
      SET NEW.person = NULL;
    END IF;
  END IF;
  IF NEW.contact_person IS NOT NULL THEN
    SET NEW.contact_person = TRIM(NEW.contact_person);
    IF NEW.contact_person = '' THEN
      SET NEW.contact_person = NULL;
    END IF;
  END IF;
  IF NEW.contact_phone IS NOT NULL THEN
    SET NEW.contact_phone = TRIM(NEW.contact_phone);
    IF NEW.contact_phone = '' THEN
      SET NEW.contact_phone = NULL;
    END IF;
  END IF;
  IF NEW.apt_date IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment date is required';
  END IF;
  IF NEW.apt_time IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment time is required';
  END IF;
END$$

DELIMITER ;


-- Box Object

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


-- Box Category

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

-- Category

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

-- Document

USE movemind_db;

DROP PROCEDURE IF EXISTS sp_list_documents_for_user_move;
DROP PROCEDURE IF EXISTS sp_create_document_for_user;
DROP PROCEDURE IF EXISTS sp_delete_document;

DROP TRIGGER IF EXISTS trg_before_insert_document;
DROP TRIGGER IF EXISTS trg_before_update_document;

DELIMITER $$

CREATE PROCEDURE sp_list_documents_for_user_move(
  IN p_move_id INT,
  IN p_user_id INT
)
BEGIN
  SELECT COUNT(*) > 0 AS owns
  FROM moves
  WHERE id = p_move_id
    AND user_id = p_user_id;

  SELECT id, doc_type, file_url, uploaded_on
  FROM documents
  WHERE move_id = p_move_id
  ORDER BY uploaded_on DESC;
END$$

CREATE PROCEDURE sp_create_document_for_user(
  IN p_move_id INT,
  IN p_user_id INT,
  IN p_doc_type VARCHAR(100),
  IN p_file_url VARCHAR(500)
)
BEGIN
  DECLARE move_count INT;

  SELECT COUNT(*) INTO move_count
  FROM moves
  WHERE id = p_move_id
    AND user_id = p_user_id;

  IF move_count = 0 THEN
    SELECT FALSE AS success,
           'Move not found' AS message,
           NULL AS id;
  ELSE
    INSERT INTO documents (move_id, doc_type, file_url)
    VALUES (p_move_id, TRIM(p_doc_type), TRIM(p_file_url));

    SELECT TRUE AS success,
           'Document added' AS message,
           LAST_INSERT_ID() AS id;
  END IF;
END$$

CREATE PROCEDURE sp_delete_document(
  IN p_doc_id INT,
  IN p_user_id INT
)
BEGIN
  DECLARE doc_exists INT;

  SELECT COUNT(*) INTO doc_exists
  FROM documents d
  JOIN moves m ON m.id = d.move_id
  WHERE d.id = p_doc_id
    AND m.user_id = p_user_id;

  IF doc_exists = 0 THEN
    SELECT FALSE AS success,
           'Document not found' AS message;
  ELSE
    DELETE FROM documents
    WHERE id = p_doc_id;

    SELECT TRUE AS success,
           'Document deleted' AS message;
  END IF;
END$$

CREATE TRIGGER trg_before_insert_document
BEFORE INSERT ON documents
FOR EACH ROW
BEGIN
  SET NEW.doc_type = TRIM(NEW.doc_type);
  IF NEW.doc_type = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Document type cannot be empty';
  END IF;

  SET NEW.file_url = TRIM(NEW.file_url);
  IF NEW.file_url = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'File URL cannot be empty';
  END IF;
END$$

CREATE TRIGGER trg_before_update_document
BEFORE UPDATE ON documents
FOR EACH ROW
BEGIN
  SET NEW.doc_type = TRIM(NEW.doc_type);
  IF NEW.doc_type = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Document type cannot be empty';
  END IF;

  SET NEW.file_url = TRIM(NEW.file_url);
  IF NEW.file_url = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'File URL cannot be empty';
  END IF;
END$$

DELIMITER ;
 
-- Item

-- ============================================
-- Item Procedures
-- ============================================

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

-- Move

USE movemind_db;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_list_moves$$
CREATE PROCEDURE sp_list_moves(
  IN p_user_id INT
)
BEGIN
  SELECT
    id,
    title,
    move_date,
    status,
    created_at,
    from_address_id,
    to_address_id
  FROM moves
  WHERE user_id = p_user_id
  ORDER BY created_at DESC;
END$$

DROP PROCEDURE IF EXISTS sp_get_move$$
CREATE PROCEDURE sp_get_move(
  IN p_move_id INT,
  IN p_user_id INT
)
BEGIN
  SELECT
    id,
    title,
    move_date,
    status,
    created_at,
    from_address_id,
    to_address_id
  FROM moves
  WHERE id = p_move_id
    AND user_id = p_user_id
  LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS sp_check_address_belongs_to_user$$
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
    WHERE address_id = p_address_id
      AND user_id = p_user_id;

    SET p_belongs = (link_count > 0);
  END IF;
END$$

DROP PROCEDURE IF EXISTS sp_create_move$$
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
    INSERT INTO moves (
      user_id,
      title,
      move_date,
      status,
      from_address_id,
      to_address_id
    )
    VALUES (
      p_user_id,
      p_title,
      p_move_date,
      p_status,
      p_from_address_id,
      p_to_address_id
    );

    SET p_move_id = LAST_INSERT_ID();
    SET p_message = 'Move created';
  END IF;
END$$

DROP PROCEDURE IF EXISTS sp_update_move$$
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
  WHERE id = p_move_id
    AND user_id = p_user_id;

  IF move_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Move not found';
  ELSE
    IF p_from_address_id IS NOT NULL THEN
      CALL sp_check_address_belongs_to_user(p_user_id, p_from_address_id, from_belongs);
      IF NOT from_belongs THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid from_address_id';
      END IF;
    END IF;

    IF p_to_address_id IS NOT NULL THEN
      CALL sp_check_address_belongs_to_user(p_user_id, p_to_address_id, to_belongs);
      IF NOT to_belongs THEN
        SET p_success = FALSE;
        SET p_message = 'Invalid to_address_id';
      END IF;
    END IF;

    IF from_belongs AND to_belongs THEN
      UPDATE moves
      SET
        title = COALESCE(p_title, title),
        move_date = COALESCE(p_move_date, move_date),
        status = COALESCE(p_status, status),
        from_address_id = COALESCE(p_from_address_id, from_address_id),
        to_address_id = COALESCE(p_to_address_id, to_address_id)
      WHERE id = p_move_id
        AND user_id = p_user_id;

      SET p_success = TRUE;
      SET p_message = 'Move updated';
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS sp_delete_move$$
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
  WHERE id = p_move_id
    AND user_id = p_user_id;

  IF move_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Move not found';
  ELSE
    DELETE FROM moves
    WHERE id = p_move_id
      AND user_id = p_user_id
    LIMIT 1;

    SET p_success = TRUE;
    SET p_message = 'Move deleted';
  END IF;
END$$

DROP TRIGGER IF EXISTS trg_before_insert_move$$
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

DROP TRIGGER IF EXISTS trg_before_update_move$$
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


-- Move utility

USE movemind_db;

DROP PROCEDURE IF EXISTS sp_check_utility_exists;
DROP PROCEDURE IF EXISTS sp_list_utilities_for_move;
DROP PROCEDURE IF EXISTS sp_add_utility_to_move;
DROP PROCEDURE IF EXISTS sp_check_move_utility_exists;
DROP PROCEDURE IF EXISTS sp_update_move_utility;
DROP PROCEDURE IF EXISTS sp_delete_move_utility;

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
  WHERE mu.move_id = p_move_id
    AND m.user_id = p_user_id
  ORDER BY u.type, u.provider_name;
END$$

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

  SELECT COUNT(*) INTO existing_count
  FROM move_utilities
  WHERE move_id = p_move_id
    AND utility_id = p_utility_id;

  IF existing_count > 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Utility already attached to this move';
  ELSE
    INSERT INTO move_utilities
      (move_id, utility_id, account_number, start_date, stop_date, status)
    VALUES
      (p_move_id,
       p_utility_id,
       p_account_number,
       p_start_date,
       p_stop_date,
       p_status);
    SET p_success = TRUE;
    SET p_message = 'Move utility added';
  END IF;
END$$

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
  WHERE move_id = p_move_id
    AND utility_id = p_utility_id
  LIMIT 1;
END$$

CREATE PROCEDURE sp_delete_move_utility(
  IN p_move_id INT,
  IN p_utility_id INT,
  IN p_user_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE link_exists INT;

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
    WHERE move_id = p_move_id
      AND utility_id = p_utility_id;
    SET p_success = TRUE;
    SET p_message = 'Move utility deleted';
  END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_before_insert_move_utility;
DROP TRIGGER IF EXISTS trg_before_update_move_utility;

DELIMITER $$

CREATE TRIGGER trg_before_insert_move_utility
BEFORE INSERT ON move_utilities
FOR EACH ROW
BEGIN
  IF NEW.account_number IS NOT NULL THEN
    SET NEW.account_number = TRIM(NEW.account_number);
    IF NEW.account_number = '' THEN
      SET NEW.account_number = NULL;
    END IF;
  END IF;

  IF NEW.status IS NULL THEN
    SET NEW.status = 'planned';
  END IF;

  IF NEW.start_date IS NOT NULL
     AND NEW.stop_date IS NOT NULL
     AND NEW.start_date > NEW.stop_date THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Start date must be before stop date';
  END IF;
END$$

CREATE TRIGGER trg_before_update_move_utility
BEFORE UPDATE ON move_utilities
FOR EACH ROW
BEGIN
  IF NEW.account_number IS NOT NULL THEN
    SET NEW.account_number = TRIM(NEW.account_number);
    IF NEW.account_number = '' THEN
      SET NEW.account_number = NULL;
    END IF;
  END IF;

  IF NEW.start_date IS NOT NULL
     AND NEW.stop_date IS NOT NULL
     AND NEW.start_date > NEW.stop_date THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Start date must be before stop date';
  END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_check_user_owns_move;

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
  WHERE id = p_move_id
    AND user_id = p_user_id;

  SET p_owns = (move_count > 0);
END$$

DELIMITER ;

-- Room

-- ============================================
-- Room Procedures
-- ============================================

-- Check if user owns a move (helper function)
DELIMITER $$

DROP PROCEDURE IF EXISTS sp_check_user_owns_move;

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

-- User

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

-- Utility

USE movemind_db;

DROP PROCEDURE IF EXISTS sp_list_utilities;
DROP PROCEDURE IF EXISTS sp_create_utility;
DROP PROCEDURE IF EXISTS sp_update_utility;
DROP PROCEDURE IF EXISTS sp_delete_utility;

DELIMITER $$

CREATE PROCEDURE sp_list_utilities()
BEGIN
  SELECT id, provider_name, type
  FROM utilities
  ORDER BY provider_name ASC;
END$$

CREATE PROCEDURE sp_create_utility(
  IN p_provider_name VARCHAR(100),
  IN p_type VARCHAR(20),
  OUT p_utility_id INT,
  OUT p_message VARCHAR(100)
)
BEGIN
  INSERT INTO utilities (provider_name, type)
  VALUES (TRIM(p_provider_name), p_type);
  SET p_utility_id = LAST_INSERT_ID();
  SET p_message = 'Utility created';
END$$

CREATE PROCEDURE sp_update_utility(
  IN p_utility_id INT,
  IN p_provider_name VARCHAR(100),
  IN p_type VARCHAR(20),
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE utility_exists INT;

  SELECT COUNT(*) INTO utility_exists
  FROM utilities
  WHERE id = p_utility_id;

  IF utility_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Utility not found';
  ELSE
    IF p_provider_name IS NOT NULL THEN
      UPDATE utilities
      SET provider_name = TRIM(p_provider_name)
      WHERE id = p_utility_id;
    END IF;

    IF p_type IS NOT NULL THEN
      UPDATE utilities
      SET type = p_type
      WHERE id = p_utility_id;
    END IF;

    SET p_success = TRUE;
    SET p_message = 'Utility updated';
  END IF;
END$$

CREATE PROCEDURE sp_delete_utility(
  IN p_utility_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE utility_exists INT;

  SELECT COUNT(*) INTO utility_exists
  FROM utilities
  WHERE id = p_utility_id;

  IF utility_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Utility not found';
  ELSE
    DELETE FROM utilities
    WHERE id = p_utility_id;
    SET p_success = TRUE;
    SET p_message = 'Utility deleted';
  END IF;
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS trg_before_insert_utility;
DROP TRIGGER IF EXISTS trg_before_update_utility;
DROP TRIGGER IF EXISTS trg_before_delete_utility;

DELIMITER $$

CREATE TRIGGER trg_before_insert_utility
BEFORE INSERT ON utilities
FOR EACH ROW
BEGIN
  SET NEW.provider_name = TRIM(NEW.provider_name);
  IF NEW.provider_name = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Provider name cannot be empty';
  END IF;
END$$

CREATE TRIGGER trg_before_update_utility
BEFORE UPDATE ON utilities
FOR EACH ROW
BEGIN
  SET NEW.provider_name = TRIM(NEW.provider_name);
  IF NEW.provider_name = '' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Provider name cannot be empty';
  END IF;
END$$

CREATE TRIGGER trg_before_delete_utility
BEFORE DELETE ON utilities
FOR EACH ROW
BEGIN
  DECLARE usage_count INT;

  SELECT COUNT(*) INTO usage_count
  FROM move_utilities
  WHERE utility_id = OLD.id;

  IF usage_count > 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot delete utility: it is currently assigned to one or more moves';
  END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_check_user_owns_move_ownsflag;

DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_move_ownsflag(
  IN p_move_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE move_count INT;

  SELECT COUNT(*) INTO move_count
  FROM moves
  WHERE id = p_move_id
    AND user_id = p_user_id;

  SET p_owns = (move_count > 0);
END$$

DELIMITER ;

-- Categories insert
INSERT INTO categories (name) VALUES
  ('Furniture'),
  ('Electronics'),
  ('Clothing'),
  ('Kitchen'),
  ('Appliances'),
  ('Books'),
  ('Toys'),
  ('Decor'),
  ('Bedding'),
  ('Office Supplies'),
  ('Sporting Goods'),
  ('Tools'),
  ('Cleaning Supplies'),
  ('Bath'),
  ('Outdoor'),
  ('Garden'),
  ('Pet Supplies'),
  ('Linens'),
  ('Artwork'),
  ('Documents'),
  ('Sentimental Items'),
  ('Seasonal'),
  ('Hobby & Crafts'),
  ('Baby Items'),
  ('Luggage'),
  ('Shoes'),
  ('Jewelry'),
  ('Miscellaneous');


-- Utilities insert
INSERT INTO utilities (provider_name, type) VALUES
  -- Electricity
  ('Duke Energy', 'electricity'),
  ('Pacific Gas & Electric', 'electricity'),
  ('Southern California Edison', 'electricity'),
  ('Georgia Power', 'electricity'),
  ('Austin Energy', 'electricity'),

  -- Gas
  ('National Grid', 'gas'),
  ('CenterPoint Energy', 'gas'),
  ('Peoples Gas', 'gas'),
  ('Southwest Gas', 'gas'),
  ('SoCal Gas', 'gas'),

  -- Water
  ('City Water Department', 'water'),
  ('American Water', 'water'),
  ('Aqua America', 'water'),
  ('Las Vegas Valley Water District', 'water'),
  ('Charlotte Water', 'water'),

  -- Internet
  ('Comcast Xfinity', 'internet'),
  ('Spectrum', 'internet'),
  ('AT&T Fiber', 'internet'),
  ('Verizon Fios', 'internet'),
  ('Google Fiber', 'internet'),

  -- Trash / Waste
  ('Waste Management', 'trash'),
  ('Republic Services', 'trash'),
  ('GFL Environmental', 'trash'),
  ('Allied Waste Services', 'trash'),
  ('Local City Trash Pickup', 'trash');



