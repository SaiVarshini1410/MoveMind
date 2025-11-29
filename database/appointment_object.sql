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
