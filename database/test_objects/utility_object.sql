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
