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


-- INSERT COMMANDS 

USE movemind_db;

-- ========================================
-- Users Table
-- ========================================
INSERT INTO Users (first_name, last_name, email, password) VALUES
('John', 'Doe', 'john@example.com', '$2b$10$dummyhash123'),
('Jane', 'Smith', 'jane@example.com', '$2b$10$dummyhash456'),
('Mike', 'Johnson', 'mike@example.com', '$2b$10$dummyhash789'),
('Sarah', 'Williams', 'sarah@example.com', '$2b$10$dummyhash012'),
('Tom', 'Brown', 'tom@example.com', '$2b$10$dummyhash345');

-- ========================================
-- Addresses Table
-- ========================================
INSERT INTO addresses (line1, line2, city, state, postal_code, country) VALUES
('123 Main St', NULL, 'Boston', 'MA', '02115', 'USA'),
('456 Oak Ave', NULL, 'Cambridge', 'MA', '02139', 'USA'),
('789 Pine Rd', NULL, 'Brookline', 'MA', '02445', 'USA'),
('321 Elm Street', NULL, 'Somerville', 'MA', '02143', 'USA'),
('654 Maple Dr', NULL, 'Newton', 'MA', '02458', 'USA'),
('987 Cedar Ln', NULL, 'Watertown', 'MA', '02472', 'USA'),
('147 Birch Ave', NULL, 'Arlington', 'MA', '02474', 'USA'),
('258 Willow St', NULL, 'Medford', 'MA', '02155', 'USA'),
('369 Spruce Ct', NULL, 'Quincy', 'MA', '02169', 'USA'),
('741 Ash Blvd', NULL, 'Waltham', 'MA', '02451', 'USA'),
('852 Poplar Way', NULL, 'Malden', 'MA', '02148', 'USA'),
('963 Cherry Ln', NULL, 'Revere', 'MA', '02151', 'USA'),
('159 Magnolia Dr', NULL, 'Belmont', 'MA', '02478', 'USA'),
('357 Sycamore St', NULL, 'Lexington', 'MA', '02420', 'USA'),
('486 Redwood Pl', NULL, 'Needham', 'MA', '02492', 'USA');

-- ========================================
-- User_Addresses Junction Table
-- ========================================
INSERT INTO user_addresses (user_id, address_id, label) VALUES
-- John's addresses
(1, 1, 'Home'), (1, 2, 'Apartment'),
-- Jane's addresses
(2, 4, 'House'), (2, 5, 'Apartment'), (2, 6, 'Home'),
-- Mike's addresses
(3, 7, 'Apartment'), (3, 9, 'House'),
-- Sarah's addresses
(4, 10, 'Apartment'), (4, 11, 'Home'),
-- Tom's addresses
(5, 12, 'Apartment'), (5, 14, 'Home');

-- ========================================
-- Categories
-- ========================================
INSERT INTO Categories (name) VALUES
('Kitchen'),
('Electronics'),
('Books'),
('Clothing'),
('Furniture'),
('Fragile'),
('Bathroom'),
('Office'),
('Toys'),
('Sports'),
('Decorations'),
('Tools'),
('Linens'),
('Outdoor'),
('Miscellaneous');

-- ========================================
-- Utilities
-- ========================================
INSERT INTO Utilities (provider_name, type) VALUES
-- Electricity providers
('Eversource', 'electricity'),
('National Grid Electric', 'electricity'),
-- Gas providers
('National Grid Gas', 'gas'),
('Unitil Gas', 'gas'),
-- Water providers
('Boston Water and Sewer', 'water'),
('Cambridge Water', 'water'),
('Massachusetts Water Resources Authority', 'water'),
-- Internet providers
('Comcast Xfinity', 'internet'),
('Verizon Fios', 'internet'),
('RCN', 'internet'),
('Starry Internet', 'internet'),
-- Trash providers
('Waste Management', 'trash'),
('Republic Services', 'trash'),
('Casella Waste Systems', 'trash'),
-- Other services
('Propane Delivery Service', 'other'),
('Solar Energy Provider', 'other');

-- ========================================
-- Moves
-- ========================================
INSERT INTO Moves (user_id, title, move_date, status, from_address_id, to_address_id) VALUES
-- USER 1: John Doe 
(1, 'Moving to Cambridge', '2025-12-01', 'packing', 1, 2),
-- USER 2: Jane Smith (2 moves)
(2, 'Upgrading to Bigger Place', '2025-11-25', 'in_transit', 4, 5),
(2, 'First Move to Boston', '2023-08-01', 'done', 6, 4),
-- USER 3: Mike Johnson 
(3, 'Downtown to Suburbs', '2024-03-10', 'done', 9, 7),
-- USER 4: Sarah Williams 
(4, 'First Home Purchase', '2025-10-01', 'done', 10, 11),
-- USER 5: Tom Brown
(5, 'Student Housing to Apartment', '2023-12-15', 'done', 14, 12);

-- ========================================
-- Rooms - IMPORTANT: Manual ID assignment for weak entity
-- ========================================
-- MOVE 1: John - Moving to Cambridge (packing)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Living Room', 1, 1),
('Kitchen', 1, 1),
('Dining Room', 1, 1),
('Master Bedroom', 2, 1),
('Guest Bedroom', 2, 1),
('Home Office', 2, 1),
('Bathroom 1', 1, 1),
('Bathroom 2', 2, 1);

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Living Room', 1, 2),
('Kitchen', 1, 2),
('Dining Room', 1, 2),
('Master Bedroom', 2, 2),
('Bedroom 2', 2, 2),
('Home Office', 2, 2),
('Bathroom', 1, 2);

-- MOVE 3: Jane - First Move to Boston (done)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Living Room', 1, 3),
('Bedroom', 1, 3),
('Kitchen', 1, 3);

-- MOVE 4: Mike - Downtown to Suburbs (done)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Living Room', 1, 4),
('Kitchen', 1, 4),
('Bedroom', 2, 4),
('Office', 2, 4);

-- MOVE 5: Sarah - First Home Purchase (done)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Living Room', 1, 5),
('Kitchen', 1, 5),
('Dining Room', 1, 5),
('Master Bedroom', 2, 5),
('Office', 2, 5),
('Bathroom', 1, 5);

-- MOVE 6: Tom - Student Housing to Apartment (done)
INSERT INTO Rooms (name, floor, move_id) VALUES
('Bedroom', 1, 6),
('Living Area', 1, 6),
('Kitchen', 1, 6);

-- ========================================
-- Boxes
-- ========================================
-- MOVE 1: John - Moving to Cambridge (packing) - 20 boxes
-- Living Room (room_id = 1) - 5 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(1, 'Living Room', 'JD-LIV-001', FALSE, 25.50, 'packed'),
(1, 'Living Room', 'JD-LIV-002', TRUE, 8.75, 'packed'),
(1, 'Living Room', 'JD-LIV-003', FALSE, 30.00, 'empty'),
(1, 'Living Room', 'JD-LIV-004', FALSE, 20.25, 'packed'),
(1, 'Living Room', 'JD-LIV-005', TRUE, 10.50, 'packed');

-- Kitchen (room_id = 2) - 6 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(1, 'Kitchen', 'JD-KIT-001', TRUE, 15.50, 'packed'),
(1, 'Kitchen', 'JD-KIT-002', TRUE, 18.00, 'packed'),
(1, 'Kitchen', 'JD-KIT-003', FALSE, 22.00, 'packed'),
(1, 'Kitchen', 'JD-KIT-004', FALSE, 12.50, 'empty'),
(1, 'Kitchen', 'JD-KIT-005', TRUE, 14.75, 'packed'),
(1, 'Kitchen', 'JD-KIT-006', FALSE, 19.25, 'packed');

-- Dining Room (room_id = 3) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(1, 'Dining Room', 'JD-DIN-001', TRUE, 16.00, 'packed'),
(1, 'Dining Room', 'JD-DIN-002', FALSE, 18.50, 'empty');

-- Master Bedroom (room_id = 4) - 4 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(1, 'Master Bedroom', 'JD-MBR-001', FALSE, 18.00, 'packed'),
(1, 'Master Bedroom', 'JD-MBR-002', FALSE, 20.50, 'packed'),
(1, 'Master Bedroom', 'JD-MBR-003', TRUE, 5.50, 'packed'),
(1, 'Master Bedroom', 'JD-MBR-004', FALSE, 22.00, 'empty');

-- Home Office (room_id = 6) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(1, 'Home Office', 'JD-OFF-001', TRUE, 10.00, 'packed'),
(1, 'Home Office', 'JD-OFF-002', FALSE, 25.00, 'packed'),
(1, 'Home Office', 'JD-OFF-003', FALSE, 18.50, 'packed');

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit) - 15 boxes
-- Living Room (room_id = 9) - 5 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(2, 'Living Room', 'JS-LIV-001', FALSE, 20.00, 'loaded'),
(2, 'Living Room', 'JS-LIV-002', TRUE, 12.00, 'loaded'),
(2, 'Living Room', 'JS-LIV-003', FALSE, 22.50, 'loaded'),
(2, 'Living Room', 'JS-LIV-004', FALSE, 18.75, 'loaded'),
(2, 'Living Room', 'JS-LIV-005', TRUE, 9.50, 'loaded');

-- Kitchen (room_id = 10) - 5 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(2, 'Kitchen', 'JS-KIT-001', TRUE, 16.50, 'loaded'),
(2, 'Kitchen', 'JS-KIT-002', FALSE, 18.00, 'loaded'),
(2, 'Kitchen', 'JS-KIT-003', TRUE, 14.00, 'loaded'),
(2, 'Kitchen', 'JS-KIT-004', FALSE, 20.25, 'loaded'),
(2, 'Kitchen', 'JS-KIT-005', TRUE, 13.50, 'loaded');

-- Master Bedroom (room_id = 12) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(2, 'Master Bedroom', 'JS-MBR-001', FALSE, 22.00, 'loaded'),
(2, 'Master Bedroom', 'JS-MBR-002', FALSE, 19.50, 'loaded'),
(2, 'Master Bedroom', 'JS-MBR-003', TRUE, 7.00, 'loaded');

-- Home Office (room_id = 14) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(2, 'Home Office', 'JS-OFF-001', TRUE, 12.00, 'loaded'),
(2, 'Home Office', 'JS-OFF-002', FALSE, 20.00, 'loaded');

-- MOVE 3: Jane - First Move to Boston (done) - 5 boxes
-- Living Room (room_id = 16) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(3, 'Living Room', 'JS-OLD-LIV-001', FALSE, 20.00, 'unpacked'),
(3, 'Living Room', 'JS-OLD-LIV-002', TRUE, 10.00, 'unpacked');

-- Bedroom (room_id = 17) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(3, 'Bedroom', 'JS-OLD-BED-001', FALSE, 18.00, 'unpacked'),
(3, 'Bedroom', 'JS-OLD-BED-002', FALSE, 16.50, 'unpacked');

-- Kitchen (room_id = 18) - 1 box
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(3, 'Kitchen', 'JS-OLD-KIT-001', TRUE, 15.00, 'unpacked');

-- MOVE 4: Mike - Downtown to Suburbs (done) - 8 boxes
-- Living Room (room_id = 19) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(4, 'Living Room', 'MJ-LIV-001', FALSE, 22.00, 'unpacked'),
(4, 'Living Room', 'MJ-LIV-002', TRUE, 11.00, 'unpacked'),
(4, 'Living Room', 'MJ-LIV-003', FALSE, 25.00, 'unpacked');

-- Kitchen (room_id = 20) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(4, 'Kitchen', 'MJ-KIT-001', TRUE, 16.00, 'unpacked'),
(4, 'Kitchen', 'MJ-KIT-002', FALSE, 19.00, 'unpacked');

-- Bedroom (room_id = 21) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(4, 'Bedroom', 'MJ-BED-001', FALSE, 20.00, 'unpacked'),
(4, 'Bedroom', 'MJ-BED-002', FALSE, 18.50, 'unpacked');

-- Office (room_id = 22) - 1 box
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(4, 'Office', 'MJ-OFF-001', TRUE, 12.00, 'unpacked');

-- MOVE 5: Sarah - First Home Purchase (done) - 10 boxes
-- Living Room (room_id = 23) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(5, 'Living Room', 'SW-LIV-001', FALSE, 22.00, 'unpacked'),
(5, 'Living Room', 'SW-LIV-002', TRUE, 15.00, 'unpacked'),
(5, 'Living Room', 'SW-LIV-003', FALSE, 20.50, 'unpacked');

-- Kitchen (room_id = 24) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(5, 'Kitchen', 'SW-KIT-001', TRUE, 15.00, 'unpacked'),
(5, 'Kitchen', 'SW-KIT-002', FALSE, 18.00, 'unpacked'),
(5, 'Kitchen', 'SW-KIT-003', TRUE, 14.50, 'unpacked');

-- Master Bedroom (room_id = 26) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(5, 'Master Bedroom', 'SW-BED-001', FALSE, 18.00, 'unpacked'),
(5, 'Master Bedroom', 'SW-BED-002', FALSE, 20.00, 'unpacked');

-- Office (room_id = 27) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(5, 'Office', 'SW-OFF-001', TRUE, 12.00, 'unpacked'),
(5, 'Office', 'SW-OFF-002', FALSE, 16.00, 'unpacked');

-- MOVE 6: Tom - Student Housing to Apartment (done) - 6 boxes
-- Bedroom (room_id = 29) - 3 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(6, 'Bedroom', 'TB-BED-001', FALSE, 18.00, 'unpacked'),
(6, 'Bedroom', 'TB-BED-002', FALSE, 16.00, 'unpacked'),
(6, 'Bedroom', 'TB-BED-003', TRUE, 8.00, 'unpacked');

-- Living Area (room_id = 30) - 2 boxes
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(6, 'Living Area', 'TB-LIV-001', FALSE, 20.00, 'unpacked'),
(6, 'Living Area', 'TB-LIV-002', TRUE, 10.00, 'unpacked');

-- Kitchen (room_id = 31) - 1 box
INSERT INTO Boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
(6, 'Kitchen', 'TB-KIT-001', TRUE, 15.00, 'unpacked');

-- ========================================
-- Items
-- ========================================
-- MOVE 1: John - Moving to Cambridge (boxes 1-20)
-- Living Room boxes (1-5)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 1: JD-LIV-001 (Furniture)
(1, 'Table Lamp', 2, 130.00),
(1, 'Floor Lamp', 1, 85.00),
(1, 'Throw Pillows', 6, 120.00),
-- Box 2: JD-LIV-002 (Fragile/Decorations)
(2, 'Picture Frames', 8, 160.00),
(2, 'Glass Vases', 3, 75.00),
(2, 'Decorative Bowls', 2, 50.00),
-- Box 3: JD-LIV-003 (Books) - EMPTY
-- Box 4: JD-LIV-004 (Furniture)
(4, 'Side Table Accessories', 1, 200.00),
(4, 'Cushions', 4, 80.00),
(4, 'Candle Holders', 6, 90.00),
-- Box 5: JD-LIV-005 (Fragile/Decorations)
(5, 'Glass Figurines', 5, 125.00),
(5, 'Crystal Decor', 3, 180.00),
(5, 'Ceramic Art', 2, 95.00);

-- Kitchen boxes (6-11)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 6: JD-KIT-001 (Kitchen/Fragile)
(6, 'Dinner Plates', 8, 120.00),
(6, 'Wine Glasses', 6, 80.00),
(6, 'Coffee Mugs', 4, 40.00),
-- Box 7: JD-KIT-002 (Kitchen/Fragile)
(7, 'Mixing Bowls', 5, 60.00),
(7, 'Serving Platters', 3, 90.00),
(7, 'Casserole Dishes', 2, 70.00),
-- Box 8: JD-KIT-003 (Kitchen)
(8, 'Pots and Pans Set', 1, 200.00),
(8, 'Kitchen Utensils', 15, 50.00),
(8, 'Cutting Boards', 3, 45.00),
(8, 'Colander', 1, 25.00),
-- Box 9: JD-KIT-004 (Kitchen) - EMPTY
-- Box 10: JD-KIT-005 (Kitchen/Fragile)
(10, 'Glassware Set', 12, 150.00),
(10, 'Champagne Flutes', 4, 60.00),
(10, 'Martini Glasses', 6, 75.00),
-- Box 11: JD-KIT-006 (Kitchen)
(11, 'Kitchen Towels', 10, 30.00),
(11, 'Pot Holders', 6, 20.00),
(11, 'Aprons', 3, 45.00),
(11, 'Oven Mitts', 4, 35.00);

-- Dining Room boxes (12-13)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 12: JD-DIN-001 (Kitchen/Fragile)
(12, 'Fine China', 12, 400.00),
(12, 'Crystal Wine Glasses', 8, 200.00),
(12, 'Silver Cutlery Set', 1, 350.00);
-- Box 13: JD-DIN-002 (Decorations) - EMPTY

-- Master Bedroom boxes (14-17)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 14: JD-MBR-001 (Clothing)
(14, 'T-Shirts', 20, 300.00),
(14, 'Jeans', 10, 500.00),
(14, 'Sweaters', 8, 400.00),
-- Box 15: JD-MBR-002 (Clothing)
(15, 'Dress Shirts', 12, 600.00),
(15, 'Pants', 8, 400.00),
(15, 'Jackets', 5, 750.00),
-- Box 16: JD-MBR-003 (Fragile/Decorations)
(16, 'Jewelry Box', 1, 200.00),
(16, 'Watches', 3, 900.00),
(16, 'Accessories', 10, 150.00);
-- Box 17: JD-MBR-004 (Clothing) - EMPTY

-- Home Office boxes (18-20)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 18: JD-OFF-001 (Electronics/Fragile)
(18, 'Laptop', 1, 1200.00),
(18, 'Monitor', 2, 800.00),
(18, 'Keyboard', 1, 150.00),
(18, 'Mouse', 2, 100.00),
(18, 'Webcam', 1, 120.00),
-- Box 19: JD-OFF-002 (Books)
(19, 'Reference Books', 25, 500.00),
(19, 'Textbooks', 15, 450.00),
(19, 'Notebooks', 10, 30.00),
-- Box 20: JD-OFF-003 (Office)
(20, 'Desk Supplies', 1, 75.00),
(20, 'File Folders', 20, 40.00),
(20, 'Binders', 15, 60.00),
(20, 'Pens and Pencils', 50, 25.00);

-- MOVE 2: Jane - Upgrading to Bigger Place (boxes 21-35)
-- Living Room boxes (21-25)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 21: JS-LIV-001 (Furniture)
(21, 'Table Lamp', 1, 65.00),
(21, 'Throw Blankets', 3, 90.00),
(21, 'Cushions', 4, 80.00),
-- Box 22: JS-LIV-002 (Fragile/Decorations)
(22, 'Glass Vases', 3, 90.00),
(22, 'Ceramic Decor', 2, 70.00),
(22, 'Photo Frames', 6, 120.00),
-- Box 23: JS-LIV-003 (Books)
(23, 'Novel Collection', 30, 300.00),
(23, 'Coffee Table Books', 8, 200.00),
-- Box 24: JS-LIV-004 (Furniture)
(24, 'Decorative Pillows', 8, 160.00),
(24, 'Area Rug', 1, 250.00),
-- Box 25: JS-LIV-005 (Fragile/Decorations)
(25, 'Art Sculptures', 3, 450.00),
(25, 'Crystal Figurines', 4, 280.00);

-- Kitchen boxes (26-30)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 26: JS-KIT-001 (Kitchen/Fragile)
(26, 'Glassware Set', 12, 150.00),
(26, 'Crystal Bowls', 3, 120.00),
-- Box 27: JS-KIT-002 (Kitchen)
(27, 'Cookware', 8, 200.00),
(27, 'Baking Pans', 5, 75.00),
(27, 'Cooking Utensils', 12, 60.00),
-- Box 28: JS-KIT-003 (Kitchen/Fragile)
(28, 'Fine China', 8, 250.00),
(28, 'Teacup Set', 6, 90.00),
-- Box 29: JS-KIT-004 (Kitchen)
(29, 'Tupperware Set', 20, 80.00),
(29, 'Kitchen Gadgets', 15, 95.00),
-- Box 30: JS-KIT-005 (Kitchen/Fragile)
(30, 'Wine Glasses', 10, 150.00),
(30, 'Champagne Flutes', 6, 90.00);

-- Master Bedroom boxes (31-33)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 31: JS-MBR-001 (Clothing)
(31, 'Winter Coats', 5, 500.00),
(31, 'Boots', 4, 320.00),
(31, 'Scarves', 10, 200.00),
-- Box 32: JS-MBR-002 (Clothing)
(32, 'Summer Clothes', 20, 300.00),
(32, 'Dresses', 8, 400.00),
(32, 'Accessories', 15, 150.00),
-- Box 33: JS-MBR-003 (Fragile/Decorations)
(33, 'Jewelry', 1, 800.00),
(33, 'Perfume Collection', 8, 400.00);

-- Home Office boxes (34-35)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 34: JS-OFF-001 (Electronics/Fragile)
(34, 'iPad', 1, 600.00),
(34, 'Speakers', 2, 300.00),
(34, 'Headphones', 2, 200.00),
(34, 'Charging Cables', 10, 50.00),
-- Box 35: JS-OFF-002 (Office)
(35, 'Office Supplies', 1, 100.00),
(35, 'Desk Organizers', 3, 60.00),
(35, 'Staplers and Tape', 5, 40.00);

-- MOVE 3: Jane - First Move to Boston (boxes 36-40)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 36: JS-OLD-LIV-001 (Furniture)
(36, 'Sofa Pillows', 6, 120.00),
(36, 'Throw Blankets', 3, 90.00),
-- Box 37: JS-OLD-LIV-002 (Fragile/Decorations)
(37, 'Artwork', 4, 400.00),
(37, 'Glass Decor', 3, 150.00),
-- Box 38: JS-OLD-BED-001 (Clothing)
(38, 'Clothes', 25, 500.00),
(38, 'Shoes', 8, 400.00),
-- Box 39: JS-OLD-BED-002 (Linens)
(39, 'Bedding Set', 2, 200.00),
(39, 'Towels', 10, 100.00),
-- Box 40: JS-OLD-KIT-001 (Kitchen/Fragile)
(40, 'Dinnerware', 12, 180.00),
(40, 'Glassware', 8, 120.00);

-- MOVE 4: Mike - Downtown to Suburbs (boxes 41-48)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 41: MJ-LIV-001 (Furniture)
(41, 'Table Lamps', 2, 140.00),
(41, 'Decorative Items', 8, 200.00),
-- Box 42: MJ-LIV-002 (Fragile/Decorations)
(42, 'Picture Frames', 10, 250.00),
(42, 'Vases', 4, 160.00),
-- Box 43: MJ-LIV-003 (Books)
(43, 'Book Collection', 40, 400.00),
(43, 'Magazines', 20, 50.00),
-- Box 44: MJ-KIT-001 (Kitchen/Fragile)
(44, 'China Set', 12, 300.00),
(44, 'Wine Glasses', 8, 120.00),
-- Box 45: MJ-KIT-002 (Kitchen)
(45, 'Pots and Pans', 10, 250.00),
(45, 'Kitchen Tools', 15, 100.00),
-- Box 46: MJ-BED-001 (Clothing)
(46, 'Suits', 5, 1000.00),
(46, 'Dress Shirts', 12, 600.00),
-- Box 47: MJ-BED-002 (Linens)
(47, 'Bed Linens', 3, 150.00),
(47, 'Pillows', 6, 120.00),
-- Box 48: MJ-OFF-001 (Electronics/Fragile)
(48, 'Desktop Computer', 1, 1500.00),
(48, 'Printer', 1, 250.00),
(48, 'External Drives', 3, 300.00);

-- MOVE 5: Sarah - First Home Purchase (boxes 49-58)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 49: SW-LIV-001 (Furniture)
(49, 'Sofa Pillows', 6, 120.00),
(49, 'Throw Blankets', 3, 90.00),
(49, 'Floor Lamp', 1, 85.00),
-- Box 50: SW-LIV-002 (Fragile/Decorations)
(50, 'Artwork', 4, 400.00),
(50, 'Glass Sculptures', 2, 300.00),
-- Box 51: SW-LIV-003 (Books)
(51, 'Books', 35, 350.00),
(51, 'Photo Albums', 8, 120.00),
-- Box 52: SW-KIT-001 (Kitchen/Fragile)
(52, 'Dinnerware', 12, 180.00),
(52, 'Glassware', 10, 150.00),
-- Box 53: SW-KIT-002 (Kitchen)
(53, 'Pots and Pans', 8, 200.00),
(53, 'Kitchen Utensils', 20, 80.00),
-- Box 54: SW-KIT-003 (Kitchen/Fragile)
(54, 'Wine Glasses', 12, 180.00),
(54, 'Serving Dishes', 6, 150.00),
-- Box 55: SW-BED-001 (Clothing)
(55, 'Clothes', 30, 600.00),
(55, 'Shoes', 12, 480.00),
-- Box 56: SW-BED-002 (Linens)
(56, 'Bedding Set', 1, 150.00),
(56, 'Pillows', 4, 80.00),
(56, 'Blankets', 3, 120.00),
-- Box 57: SW-OFF-001 (Electronics/Fragile)
(57, 'Desktop Computer', 1, 1500.00),
(57, 'Monitor', 2, 600.00),
(57, 'Printer', 1, 250.00),
-- Box 58: SW-OFF-002 (Office)
(58, 'Office Supplies', 1, 100.00),
(58, 'File Cabinets Contents', 1, 200.00),
(58, 'Desk Accessories', 10, 150.00);

-- MOVE 6: Tom - Student Housing to Apartment (boxes 59-64)
INSERT INTO Items (box_id, name, quantity, value) VALUES
-- Box 59: TB-BED-001 (Clothing)
(59, 'T-Shirts', 15, 225.00),
(59, 'Jeans', 8, 400.00),
(59, 'Sweaters', 6, 300.00),
-- Box 60: TB-BED-002 (Linens)
(60, 'Bedding', 2, 100.00),
(60, 'Towels', 8, 80.00),
(60, 'Pillows', 3, 60.00),
-- Box 61: TB-BED-003 (Electronics/Fragile)
(61, 'Gaming Console', 1, 500.00),
(61, 'Controllers', 3, 180.00),
(61, 'Games', 15, 450.00),
-- Box 62: TB-LIV-001 (Books)
(62, 'Textbooks', 20, 600.00),
(62, 'Novels', 15, 150.00),
-- Box 63: TB-LIV-002 (Fragile/Decorations)
(63, 'Posters (Framed)', 8, 200.00),
(63, 'Decorative Items', 5, 100.00),
-- Box 64: TB-KIT-001 (Kitchen/Fragile)
(64, 'Plates and Bowls', 12, 120.00),
(64, 'Glasses', 8, 60.00),
(64, 'Mugs', 6, 50.00);

-- ========================================
-- Box_Categories
-- ========================================
-- MOVE 1: John - Moving to Cambridge
-- Living Room boxes (box_id 1-5)
INSERT INTO box_categories (box_id, category_id) VALUES
(1, 5),  -- JD-LIV-001: Furniture
(2, 6),  -- JD-LIV-002: Fragile
(2, 11), -- JD-LIV-002: Decorations
(3, 3),  -- JD-LIV-003: Books
(4, 5),  -- JD-LIV-004: Furniture
(5, 6),  -- JD-LIV-005: Fragile
(5, 11); -- JD-LIV-005: Decorations

-- Kitchen boxes (box_id 6-11)
INSERT INTO box_categories (box_id, category_id) VALUES
(6, 1),  -- JD-KIT-001: Kitchen
(6, 6),  -- JD-KIT-001: Fragile
(7, 1),  -- JD-KIT-002: Kitchen
(7, 6),  -- JD-KIT-002: Fragile
(8, 1),  -- JD-KIT-003: Kitchen
(9, 1),  -- JD-KIT-004: Kitchen
(10, 1), -- JD-KIT-005: Kitchen
(10, 6), -- JD-KIT-005: Fragile
(11, 1); -- JD-KIT-006: Kitchen

-- Dining Room boxes (box_id 12-13)
INSERT INTO box_categories (box_id, category_id) VALUES
(12, 1), -- JD-DIN-001: Kitchen
(12, 6), -- JD-DIN-001: Fragile
(13, 11);-- JD-DIN-002: Decorations

-- Master Bedroom boxes (box_id 14-17)
INSERT INTO box_categories (box_id, category_id) VALUES
(14, 4), -- JD-MBR-001: Clothing
(15, 4), -- JD-MBR-002: Clothing
(16, 6), -- JD-MBR-003: Fragile
(16, 11),-- JD-MBR-003: Decorations
(17, 4); -- JD-MBR-004: Clothing

-- Home Office boxes (box_id 18-20)
INSERT INTO box_categories (box_id, category_id) VALUES
(18, 2), -- JD-OFF-001: Electronics
(18, 6), -- JD-OFF-001: Fragile
(19, 3), -- JD-OFF-002: Books
(20, 8); -- JD-OFF-003: Office

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit)
-- Living Room boxes (box_id 21-25)
INSERT INTO box_categories (box_id, category_id) VALUES
(21, 5),  -- JS-LIV-001: Furniture
(22, 6),  -- JS-LIV-002: Fragile
(22, 11), -- JS-LIV-002: Decorations
(23, 3),  -- JS-LIV-003: Books
(24, 5),  -- JS-LIV-004: Furniture
(25, 6),  -- JS-LIV-005: Fragile
(25, 11); -- JS-LIV-005: Decorations

-- Kitchen boxes (box_id 26-30)
INSERT INTO box_categories (box_id, category_id) VALUES
(26, 1), -- JS-KIT-001: Kitchen
(26, 6), -- JS-KIT-001: Fragile
(27, 1), -- JS-KIT-002: Kitchen
(28, 1), -- JS-KIT-003: Kitchen
(28, 6), -- JS-KIT-003: Fragile
(29, 1), -- JS-KIT-004: Kitchen
(30, 1), -- JS-KIT-005: Kitchen
(30, 6); -- JS-KIT-005: Fragile

-- Master Bedroom boxes (box_id 31-33)
INSERT INTO box_categories (box_id, category_id) VALUES
(31, 4), -- JS-MBR-001: Clothing
(32, 4), -- JS-MBR-002: Clothing
(33, 6), -- JS-MBR-003: Fragile
(33, 11);-- JS-MBR-003: Decorations

-- Home Office boxes (box_id 34-35)
INSERT INTO box_categories (box_id, category_id) VALUES
(34, 2), -- JS-OFF-001: Electronics
(34, 6), -- JS-OFF-001: Fragile
(35, 8); -- JS-OFF-002: Office

-- MOVE 3: Jane - First Move to Boston (done)
-- Living Room boxes (box_id 36-37)
INSERT INTO box_categories (box_id, category_id) VALUES
(36, 5),  -- JS-OLD-LIV-001: Furniture
(37, 6),  -- JS-OLD-LIV-002: Fragile
(37, 11); -- JS-OLD-LIV-002: Decorations

-- Bedroom boxes (box_id 38-39)
INSERT INTO box_categories (box_id, category_id) VALUES
(38, 4),  -- JS-OLD-BED-001: Clothing
(39, 13); -- JS-OLD-BED-002: Linens

-- Kitchen boxes (box_id 40)
INSERT INTO box_categories (box_id, category_id) VALUES
(40, 1), -- JS-OLD-KIT-001: Kitchen
(40, 6); -- JS-OLD-KIT-001: Fragile

-- MOVE 4: Mike - Downtown to Suburbs (done)
-- Living Room boxes (box_id 41-43)
INSERT INTO box_categories (box_id, category_id) VALUES
(41, 5),  -- MJ-LIV-001: Furniture
(42, 6),  -- MJ-LIV-002: Fragile
(42, 11), -- MJ-LIV-002: Decorations
(43, 3);  -- MJ-LIV-003: Books

-- Kitchen boxes (box_id 44-45)
INSERT INTO box_categories (box_id, category_id) VALUES
(44, 1), -- MJ-KIT-001: Kitchen
(44, 6), -- MJ-KIT-001: Fragile
(45, 1); -- MJ-KIT-002: Kitchen

-- Bedroom boxes (box_id 46-47)
INSERT INTO box_categories (box_id, category_id) VALUES
(46, 4),  -- MJ-BED-001: Clothing
(47, 13); -- MJ-BED-002: Linens

-- Office boxes (box_id 48)
INSERT INTO box_categories (box_id, category_id) VALUES
(48, 2), -- MJ-OFF-001: Electronics
(48, 6); -- MJ-OFF-001: Fragile

-- MOVE 5: Sarah - First Home Purchase (done)
-- Living Room boxes (box_id 49-51)
INSERT INTO box_categories (box_id, category_id) VALUES
(49, 5),  -- SW-LIV-001: Furniture
(50, 6),  -- SW-LIV-002: Fragile
(50, 11), -- SW-LIV-002: Decorations
(51, 3);  -- SW-LIV-003: Books

-- Kitchen boxes (box_id 52-54)
INSERT INTO box_categories (box_id, category_id) VALUES
(52, 1), -- SW-KIT-001: Kitchen
(52, 6), -- SW-KIT-001: Fragile
(53, 1), -- SW-KIT-002: Kitchen
(54, 1), -- SW-KIT-003: Kitchen
(54, 6); -- SW-KIT-003: Fragile

-- Master Bedroom boxes (box_id 55-56)
INSERT INTO box_categories (box_id, category_id) VALUES
(55, 4),  -- SW-BED-001: Clothing
(56, 13); -- SW-BED-002: Linens

-- Office boxes (box_id 57-58)
INSERT INTO box_categories (box_id, category_id) VALUES
(57, 2), -- SW-OFF-001: Electronics
(57, 6), -- SW-OFF-001: Fragile
(58, 8); -- SW-OFF-002: Office

-- MOVE 6: Tom - Student Housing to Apartment (done)
-- Bedroom boxes (box_id 59-61)
INSERT INTO box_categories (box_id, category_id) VALUES
(59, 4),  -- TB-BED-001: Clothing
(60, 13), -- TB-BED-002: Linens
(61, 2),  -- TB-BED-003: Electronics
(61, 6);  -- TB-BED-003: Fragile

-- Living Area boxes (box_id 62-63)
INSERT INTO box_categories (box_id, category_id) VALUES
(62, 3),  -- TB-LIV-001: Books
(63, 6),  -- TB-LIV-002: Fragile
(63, 11); -- TB-LIV-002: Decorations

-- Kitchen boxes (box_id 64)
INSERT INTO box_categories (box_id, category_id) VALUES
(64, 1), -- TB-KIT-001: Kitchen
(64, 6); -- TB-KIT-001: Fragile

-- ========================================
-- Move_Utilities
-- ========================================
-- MOVE 1: John - Moving to Cambridge (packing) - Dec 1, 2025
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(1, 1, 'EV-123456-JD', '2025-11-30', '2025-12-01', 'confirmed'),
(3, 1, 'NG-789012-JD', '2025-11-30', '2025-12-01', 'requested'),
(8, 1, 'COM-345678-JD', '2025-11-30', '2025-12-01', 'confirmed'),
(5, 1, 'BW-901234-JD', '2025-11-30', '2025-12-01', 'active'),
(12, 1, 'WM-567890-JD', '2025-11-30', '2025-12-01', 'planned');

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit) - Nov 25, 2025
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(1, 2, 'EV-654321-JS', '2025-11-24', '2025-11-25', 'active'),
(4, 2, 'NG-321654-JS', '2025-11-24', '2025-11-25', 'active'),
(9, 2, 'VZ-147258-JS', '2025-11-24', '2025-11-25', 'confirmed'),
(6, 2, 'CW-258369-JS', '2025-11-24', '2025-11-25', 'active'),
(13, 2, 'RS-369147-JS', '2025-11-24', '2025-11-25', 'active');

-- MOVE 3: Jane - First Move to Boston (done) - Aug 1, 2023
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(2, 3, 'NG-OLD-111-JS', '2023-07-31', '2023-08-01', 'active'),
(10, 3, 'RCN-222-JS', '2023-07-31', '2023-08-01', 'active'),
(5, 3, 'BW-333-JS', '2023-07-31', '2023-08-01', 'active');

-- MOVE 4: Mike - Downtown to Suburbs (done) - Mar 10, 2024
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(1, 4, 'EV-MJ-444', '2024-03-09', '2024-03-10', 'active'),
(4, 4, 'NG-MJ-555', '2024-03-09', '2024-03-10', 'active'),
(8, 4, 'COM-MJ-666', '2024-03-09', '2024-03-10', 'active'),
(7, 4, 'MWRA-MJ-777', '2024-03-09', '2024-03-10', 'active');

-- MOVE 5: Sarah - First Home Purchase (done) - Oct 1, 2025
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(1, 5, 'EV-SW-999', '2025-09-30', '2025-10-01', 'active'),
(3, 5, 'NG-SW-888', '2025-09-30', '2025-10-01', 'active'),
(9, 5, 'VZ-SW-777', '2025-09-30', '2025-10-01', 'active'),
(5, 5, 'BW-SW-666', '2025-09-30', '2025-10-01', 'active'),
(12, 5, 'WM-SW-555', '2025-09-30', '2025-10-01', 'active'),
(16, 5, 'SOL-SW-444', NULL, '2025-10-01', 'active');

-- MOVE 6: Tom - Student Housing to Apartment (done) - Dec 15, 2023
INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
(2, 6, 'NG-TB-111', '2023-12-14', '2023-12-15', 'active'),
(11, 6, 'STR-TB-222', '2023-12-14', '2023-12-15', 'active'),
(6, 6, 'CW-TB-333', '2023-12-14', '2023-12-15', 'active'),
(14, 6, 'CAS-TB-444', '2023-12-14', '2023-12-15', 'active');

-- ========================================
-- Appointments
-- ========================================
-- MOVE 1: John - Moving to Cambridge (packing) - Dec 1, 2025
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(1, 'Moving Truck Rental', 'Pick up 26ft truck from U-Haul Cambridge location', '2025-11-30', '09:00:00', 'U-Haul Cambridge', '617-555-0100', 'scheduled'),
(1, 'Professional Movers', 'Two movers for 4 hours - load and transport', '2025-12-01', '08:00:00', 'Boston Movers Inc', '617-555-0200', 'scheduled'),
(1, 'Final Walkthrough - Old Apartment', 'Final inspection with landlord before moving out', '2025-11-29', '15:00:00', 'Landlord John Smith', '617-555-0150', 'scheduled'),
(1, 'Cleaning Service', 'Deep clean old apartment after move', '2025-11-29', '10:00:00', 'Clean Pro Boston', '617-555-0500', 'scheduled'),
(1, 'Internet Installation', 'Comcast technician setup at new apartment', '2025-12-02', '14:00:00', 'Comcast Tech Support', '800-555-0300', 'scheduled'),
(1, 'Furniture Assembly', 'IKEA bed and desk assembly', '2025-12-03', '10:00:00', 'TaskRabbit Pro - Mike', '617-555-0400', 'scheduled'),
(1, 'Key Pickup', 'Pick up keys to new apartment', '2025-11-30', '16:00:00', 'Property Manager Lisa', '617-555-0250', 'scheduled');

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit) - Nov 25, 2025
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(2, 'Moving Company Arrival', 'Elite Movers pickup at old address', '2025-11-25', '07:00:00', 'Elite Movers - Dave', '617-555-0600', 'scheduled'),
(2, 'Keys Handover - New Place', 'Get keys and do walkthrough at new apartment', '2025-11-25', '12:00:00', 'Property Manager Sarah', '617-555-0700', 'scheduled'),
(2, 'Old Apartment Final Inspection', 'Landlord final inspection', '2025-11-24', '17:00:00', 'Landlord Mike Chen', '617-555-0650', 'completed'),
(2, 'Verizon Fios Installation', 'Internet and TV setup', '2025-11-26', '10:00:00', 'Verizon Tech', '800-555-0750', 'scheduled'),
(2, 'Furniture Delivery', 'New couch delivery from Bobs Furniture', '2025-11-27', '13:00:00', 'Bobs Delivery', '617-555-0800', 'scheduled');

-- MOVE 3: Jane - First Move to Boston (done) - Aug 1, 2023
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(3, 'Moving Day', 'Budget movers - studio apartment', '2023-08-01', '09:00:00', 'Budget Movers Boston', '617-555-0900', 'completed'),
(3, 'Lease Signing', 'Sign lease and get keys', '2023-07-28', '14:00:00', 'Landlord Office', '617-555-0950', 'completed'),
(3, 'RCN Internet Setup', 'Internet installation', '2023-08-02', '11:00:00', 'RCN Technician', '800-555-1000', 'completed');

-- MOVE 4: Mike - Downtown to Suburbs (done) - Mar 10, 2024
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(4, 'Moving Company Quote', 'In-home estimate for move', '2024-02-15', '10:00:00', 'Precision Movers', '617-555-1100', 'completed'),
(4, 'Moving Day - Load', 'Loading truck at old apartment', '2024-03-10', '08:00:00', 'Precision Movers - Tom', '617-555-1150', 'completed'),
(4, 'Moving Day - Unload', 'Unloading at new house', '2024-03-10', '14:00:00', 'Precision Movers - Tom', '617-555-1150', 'completed'),
(4, 'Comcast Installation', 'Internet and cable setup', '2024-03-11', '09:00:00', 'Comcast Tech', '800-555-1200', 'completed'),
(4, 'Home Inspection', 'Pre-move home inspection', '2024-03-05', '13:00:00', 'ABC Home Inspectors', '617-555-1250', 'completed'),
(4, 'Final Walkthrough - Old Apt', 'Return keys and inspection', '2024-03-09', '16:00:00', 'Old Landlord Jim', '617-555-1300', 'completed');

-- MOVE 5: Sarah - First Home Purchase (done) - Oct 1, 2025
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(5, 'Home Closing', 'Final closing and key handover', '2025-09-30', '10:00:00', 'Attorney Jane Roberts', '617-555-1400', 'completed'),
(5, 'Pre-Move Home Inspection', 'Professional home inspection', '2025-09-15', '14:00:00', 'Inspector Joe Martinez', '617-555-1450', 'completed'),
(5, 'Moving Day', 'Professional movers - full service', '2025-10-01', '08:00:00', 'Best Movers Boston', '617-555-1500', 'completed'),
(5, 'Appliance Delivery', 'New washer/dryer installation', '2025-10-02', '13:00:00', 'Home Depot Delivery', '800-555-1550', 'completed'),
(5, 'Verizon Fios Setup', 'Internet installation at new home', '2025-10-03', '10:00:00', 'Verizon Tech', '800-555-1600', 'completed'),
(5, 'Solar Panel Inspection', 'Inspect existing solar panel system', '2025-10-05', '09:00:00', 'Green Energy Solutions', '617-555-1650', 'completed'),
(5, 'Locksmith Service', 'Change locks on new home', '2025-10-01', '15:00:00', 'ABC Locksmiths', '617-555-1700', 'completed');

-- MOVE 6: Tom - Student Housing to Apartment (done) - Dec 15, 2023
INSERT INTO Appointments (move_id, title, description, apt_date, apt_time, contact_person, contact_phone, status) VALUES
(6, 'U-Haul Pickup', 'Pick up moving van', '2023-12-15', '08:00:00', 'U-Haul Arlington', '617-555-1800', 'completed'),
(6, 'Move with Friends', 'Friends helping with move', '2023-12-15', '10:00:00', 'Self (with friends)', NULL, 'completed'),
(6, 'Starry Internet Install', 'Wireless internet setup', '2023-12-16', '14:00:00', 'Starry Technician', '800-555-1850', 'completed'),
(6, 'Apartment Walkthrough', 'Initial apartment inspection', '2023-12-14', '16:00:00', 'Property Manager Alex', '617-555-1900', 'completed');

-- ========================================
-- Documents
-- ========================================
-- MOVE 1: John - Moving to Cambridge (packing) - Dec 1, 2025
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(1, 'Lease Agreement', 'https://storage.movemind.com/docs/john_doe/lease_cambridge_2025.pdf'),
(1, 'Moving Insurance', 'https://storage.movemind.com/docs/john_doe/insurance_policy_001.pdf'),
(1, 'Inventory List', 'https://storage.movemind.com/docs/john_doe/inventory_move1.xlsx'),
(1, 'Utility Transfer Confirmation', 'https://storage.movemind.com/docs/john_doe/utility_confirms.pdf'),
(1, 'Moving Company Contract', 'https://storage.movemind.com/docs/john_doe/boston_movers_contract.pdf'),
(1, 'Parking Permit', 'https://storage.movemind.com/docs/john_doe/cambridge_parking_permit.pdf'),
(1, 'Security Deposit Receipt', 'https://storage.movemind.com/docs/john_doe/security_deposit_old_apt.pdf');

-- MOVE 2: Jane - Upgrading to Bigger Place (in_transit) - Nov 25, 2025
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(2, 'Lease Agreement', 'https://storage.movemind.com/docs/jane_smith/lease_newton_2025.pdf'),
(2, 'Moving Insurance', 'https://storage.movemind.com/docs/jane_smith/insurance_002.pdf'),
(2, 'Moving Quote', 'https://storage.movemind.com/docs/jane_smith/elite_movers_quote.pdf'),
(2, 'Utility Setup Confirmation', 'https://storage.movemind.com/docs/jane_smith/verizon_setup.pdf'),
(2, 'Keys Handover Receipt', 'https://storage.movemind.com/docs/jane_smith/keys_receipt.pdf'),
(2, 'Moving Day Checklist', 'https://storage.movemind.com/docs/jane_smith/moving_checklist.pdf');

-- MOVE 3: Jane - First Move to Boston (done) - Aug 1, 2023
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(3, 'Lease Agreement', 'https://storage.movemind.com/docs/jane_smith/lease_somerville_2023.pdf'),
(3, 'Move Receipt', 'https://storage.movemind.com/docs/jane_smith/budget_movers_receipt.pdf'),
(3, 'RCN Internet Contract', 'https://storage.movemind.com/docs/jane_smith/rcn_contract.pdf');

-- MOVE 4: Mike - Downtown to Suburbs (done) - Mar 10, 2024
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(4, 'Lease Agreement', 'https://storage.movemind.com/docs/mike_johnson/lease_arlington_2024.pdf'),
(4, 'Home Inspection Report', 'https://storage.movemind.com/docs/mike_johnson/home_inspection_report.pdf'),
(4, 'Moving Contract', 'https://storage.movemind.com/docs/mike_johnson/precision_movers_contract.pdf'),
(4, 'Moving Receipt', 'https://storage.movemind.com/docs/mike_johnson/precision_movers_receipt.pdf'),
(4, 'Utility Bills', 'https://storage.movemind.com/docs/mike_johnson/final_utility_bills.pdf'),
(4, 'Security Deposit Return', 'https://storage.movemind.com/docs/mike_johnson/security_deposit_return.pdf');

-- MOVE 5: Sarah - First Home Purchase (done) - Oct 1, 2025
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(5, 'Home Purchase Agreement', 'https://storage.movemind.com/docs/sarah_williams/purchase_agreement.pdf'),
(5, 'Mortgage Documents', 'https://storage.movemind.com/docs/sarah_williams/mortgage_final.pdf'),
(5, 'Home Inspection Report', 'https://storage.movemind.com/docs/sarah_williams/inspection_report_malden.pdf'),
(5, 'Home Insurance Policy', 'https://storage.movemind.com/docs/sarah_williams/home_insurance.pdf'),
(5, 'Moving Receipt', 'https://storage.movemind.com/docs/sarah_williams/best_movers_receipt.pdf'),
(5, 'Title Insurance', 'https://storage.movemind.com/docs/sarah_williams/title_insurance.pdf'),
(5, 'Solar Panel Documentation', 'https://storage.movemind.com/docs/sarah_williams/solar_system_docs.pdf'),
(5, 'Closing Statement', 'https://storage.movemind.com/docs/sarah_williams/closing_statement.pdf'),
(5, 'Appliance Warranty', 'https://storage.movemind.com/docs/sarah_williams/washer_dryer_warranty.pdf');

-- MOVE 6: Tom - Student Housing to Apartment (done) - Dec 15, 2023
INSERT INTO Documents (move_id, doc_type, file_url) VALUES
(6, 'Lease Agreement', 'https://storage.movemind.com/docs/tom_brown/lease_belmont_2023.pdf'),
(6, 'Student Housing Checkout Form', 'https://storage.movemind.com/docs/tom_brown/dorm_checkout.pdf'),
(6, 'U-Haul Rental Receipt', 'https://storage.movemind.com/docs/tom_brown/uhaul_receipt.pdf'),
(6, 'Starry Internet Contract', 'https://storage.movemind.com/docs/tom_brown/starry_contract.pdf'),
(6, 'Security Deposit Receipt', 'https://storage.movemind.com/docs/tom_brown/security_deposit.pdf');


-- PROGRAMMING OBJECTS

-- ADDRESS

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






