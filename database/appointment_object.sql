-- ============================================
-- Appointment Procedures
-- ============================================

-- Check if user owns a move
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

-- List appointments for a move with optional filters
DELIMITER $$

CREATE PROCEDURE sp_list_appointments_by_move(
  IN p_move_id INT,
  IN p_status VARCHAR(20),
  IN p_date DATE
)
BEGIN
  IF p_status IS NULL AND p_date IS NULL THEN
    -- No filters
    SELECT id, move_id, title, description, person, apt_date, apt_time, 
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSEIF p_status IS NOT NULL AND p_date IS NULL THEN
    -- Status filter only
    SELECT id, move_id, title, description, person, apt_date, apt_time, 
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND status = p_status
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSEIF p_status IS NULL AND p_date IS NOT NULL THEN
    -- Date filter only
    SELECT id, move_id, title, description, person, apt_date, apt_time, 
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND apt_date = p_date
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  ELSE
    -- Both filters
    SELECT id, move_id, title, description, person, apt_date, apt_time, 
           contact_person, contact_phone, status
    FROM appointments
    WHERE move_id = p_move_id AND status = p_status AND apt_date = p_date
    ORDER BY apt_date ASC, apt_time ASC, id DESC;
  END IF;
END$$

DELIMITER ;

-- Create a new appointment
DELIMITER $$

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

DELIMITER ;

-- Check if user owns an appointment
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_appointment(
  IN p_appointment_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE appt_count INT;
  
  SELECT COUNT(*) INTO appt_count
  FROM appointments a
  JOIN moves m ON m.id = a.move_id
  WHERE a.id = p_appointment_id AND m.user_id = p_user_id;
  
  SET p_owns = (appt_count > 0);
END$$

DELIMITER ;

-- Get a single appointment
DELIMITER $$

CREATE PROCEDURE sp_get_appointment(
  IN p_appointment_id INT
)
BEGIN
  SELECT id, move_id, title, description, person, apt_date, apt_time,
         contact_person, contact_phone, status
  FROM appointments
  WHERE id = p_appointment_id;
END$$

DELIMITER ;

-- Update appointment with partial field support
DELIMITER $$

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

DELIMITER ;

-- Delete an appointment
DELIMITER $$

CREATE PROCEDURE sp_delete_appointment(
  IN p_appointment_id INT,
  IN p_user_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE appt_exists INT;
  
  -- Check if appointment exists and user owns it
  SELECT COUNT(*) INTO appt_exists
  FROM appointments a
  JOIN moves m ON m.id = a.move_id
  WHERE a.id = p_appointment_id AND m.user_id = p_user_id;
  
  IF appt_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Appointment not found';
  ELSE
    DELETE FROM appointments
    WHERE id = p_appointment_id;
    
    SET p_success = TRUE;
    SET p_message = 'Appointment deleted';
  END IF;
END$$

DELIMITER ;

-- ============================================
-- Appointment Triggers
-- ============================================

-- Validate and normalize appointment data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_appointment;

DELIMITER $$

CREATE TRIGGER trg_before_insert_appointment
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
  -- Trim title
  SET NEW.title = TRIM(NEW.title);
  
  -- Validate title is not empty
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment title cannot be empty';
  END IF;
  
  -- Trim text fields if provided
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
  
  -- Set default status if null
  IF NEW.status IS NULL THEN
    SET NEW.status = 'scheduled';
  END IF;
  
  -- Validate required fields
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

-- Validate and normalize appointment data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_appointment;

DELIMITER $$

CREATE TRIGGER trg_before_update_appointment
BEFORE UPDATE ON appointments
FOR EACH ROW
BEGIN
  -- Trim title
  SET NEW.title = TRIM(NEW.title);
  
  -- Validate title is not empty
  IF NEW.title = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Appointment title cannot be empty';
  END IF;
  
  -- Trim text fields if provided
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
  
  -- Validate required fields
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