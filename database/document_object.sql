-- ============================================
-- Document Procedures
-- ============================================

-- NOTE: sp_check_user_owns_move already exists in Move Procedures section

-- List all documents for a move
DELIMITER $$

CREATE PROCEDURE sp_list_documents_by_move(
  IN p_move_id INT
)
BEGIN
  SELECT id, doc_type, file_url, uploaded_on
  FROM documents
  WHERE move_id = p_move_id
  ORDER BY uploaded_on DESC;
END$$

DELIMITER ;

-- Create a new document
DELIMITER $$

CREATE PROCEDURE sp_create_document(
  IN p_move_id INT,
  IN p_doc_type VARCHAR(100),
  IN p_file_url VARCHAR(500)
)
BEGIN
  INSERT INTO documents (move_id, doc_type, file_url)
  VALUES (p_move_id, p_doc_type, p_file_url);
  
  SELECT LAST_INSERT_ID() AS id;
END$$

DELIMITER ;

-- Check if user owns a document
DELIMITER $$

CREATE PROCEDURE sp_check_user_owns_document(
  IN p_doc_id INT,
  IN p_user_id INT,
  OUT p_owns BOOLEAN
)
BEGIN
  DECLARE doc_count INT;
  
  SELECT COUNT(*) INTO doc_count
  FROM documents d
  JOIN moves m ON m.id = d.move_id
  WHERE d.id = p_doc_id AND m.user_id = p_user_id;
  
  SET p_owns = (doc_count > 0);
END$$

DELIMITER ;

-- Delete a document
DELIMITER $$

CREATE PROCEDURE sp_delete_document(
  IN p_doc_id INT,
  IN p_user_id INT,
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  DECLARE doc_exists INT;
  
  -- Check if document exists and user owns it
  SELECT COUNT(*) INTO doc_exists
  FROM documents d
  JOIN moves m ON m.id = d.move_id
  WHERE d.id = p_doc_id AND m.user_id = p_user_id;
  
  IF doc_exists = 0 THEN
    SET p_success = FALSE;
    SET p_message = 'Document not found';
  ELSE
    DELETE FROM documents
    WHERE id = p_doc_id;
    
    SET p_success = TRUE;
    SET p_message = 'Document deleted';
  END IF;
END$$

DELIMITER ;

-- ============================================
-- Document Triggers
-- ============================================

-- Validate and normalize document data on INSERT
DROP TRIGGER IF EXISTS trg_before_insert_document;

DELIMITER $$

CREATE TRIGGER trg_before_insert_document
BEFORE INSERT ON documents
FOR EACH ROW
BEGIN
  -- Trim doc_type
  SET NEW.doc_type = TRIM(NEW.doc_type);
  
  -- Validate doc_type is not empty
  IF NEW.doc_type = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Document type cannot be empty';
  END IF;
  
  -- Trim file_url
  SET NEW.file_url = TRIM(NEW.file_url);
  
  -- Validate file_url is not empty
  IF NEW.file_url = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'File URL cannot be empty';
  END IF;
END$$

DELIMITER ;

-- Validate and normalize document data on UPDATE
DROP TRIGGER IF EXISTS trg_before_update_document;

DELIMITER $$

CREATE TRIGGER trg_before_update_document
BEFORE UPDATE ON documents
FOR EACH ROW
BEGIN
  -- Trim doc_type
  SET NEW.doc_type = TRIM(NEW.doc_type);
  
  -- Validate doc_type is not empty
  IF NEW.doc_type = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Document type cannot be empty';
  END IF;
  
  -- Trim file_url
  SET NEW.file_url = TRIM(NEW.file_url);
  
  -- Validate file_url is not empty
  IF NEW.file_url = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'File URL cannot be empty';
  END IF;
END$$

DELIMITER ;