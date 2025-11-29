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
