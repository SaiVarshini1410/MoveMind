CREATE DATABASE IF NOT EXISTS movemind_db;
USE movemind_db;

-- 1) Users
CREATE TABLE IF NOT EXISTS Users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  creation_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_email (email)
);

-- 2) addresses
CREATE TABLE IF NOT EXISTS addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  label VARCHAR(100) NOT NULL,
  street VARCHAR(64) NOT NULL,
  city VARCHAR(64) NOT NULL,
  state VARCHAR(64) NOT NULL,
  postal_code VARCHAR(64) NOT NULL,
  country VARCHAR(64) NOT NULL
);

-- 3) User_address
CREATE TABLE IF NOT EXISTS user_addresses(
user_id INT NOT NULL,
address_id INT NOT NULL,
PRIMARY KEY(user_id,address_id),
FOREIGN KEY fk1 (user_id) REFERENCES Users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY fk2(address_id)REFERENCES addresses(id) ON UPDATE CASCADE ON DELETE RESTRICT);


-- 4) Category
CREATE TABLE IF NOT EXISTS Categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- 5) Utility
CREATE TABLE IF NOT EXISTS Utilities (
  id INT AUTO_INCREMENT PRIMARY KEY,
  provider_name VARCHAR(100) NOT NULL,
  type ENUM ('electricity','gas','water','internet','trash','other') NOT NULL
);

-- 6) Move  (FK references to Users/addresses)
CREATE TABLE IF NOT EXISTS Moves (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  move_date DATE NOT NULL,
  status ENUM('planned','packing','in_transit','unpacking','done') DEFAULT 'planned',
  from_address_id INT NOT NULL,
  to_address_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (from_address_id) REFERENCES addresses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (to_address_id) REFERENCES addresses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_status (status),
  INDEX idx_move_date (move_date)
);


-- 6) Room (depends on Move)
CREATE TABLE IF NOT EXISTS Rooms (
  id INT NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  floor INT,
  move_id INT NOT NULL,
  FOREIGN KEY (move_id) REFERENCES Moves(id) ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_move_id (move_id),
  UNIQUE KEY (name , move_id)
);

-- 7) Box (depends on Room) 
CREATE TABLE IF NOT EXISTS Boxes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  label_code VARCHAR(50) UNIQUE NOT NULL,
  room_id INT ,
  is_fragile BOOLEAN DEFAULT FALSE,
  weight DECIMAL(10,2) NOT NULL,
  status ENUM('empty','packed','loaded','delivered','unpacked') DEFAULT 'empty',
  FOREIGN KEY (room_id) REFERENCES Rooms(id) ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_room_id (room_id),
  INDEX idx_status (status)
);

-- 8) Items (depends on Box)
CREATE TABLE IF NOT EXISTS Items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  box_id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  quantity INT DEFAULT 1,
  est_value DECIMAL(10,2),
  FOREIGN KEY (box_id) REFERENCES Boxes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_box_id (box_id)
);

-- 9) box_categories (depends on Box, Category)
CREATE TABLE IF NOT EXISTS box_categories (
  box_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (box_id, category_id),
  FOREIGN KEY (box_id) REFERENCES Boxes(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (category_id) REFERENCES Categories(id) ON DELETE CASCADE ON UPDATE CASCADE,
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
  CONSTRAINT mv_f1 FOREIGN KEY (utility_id) REFERENCES Utilities(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT mv_f2 FOREIGN KEY (move_id) REFERENCES Moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT mv_pk PRIMARY KEY (move_id, utility_id),
  INDEX idx_status (status),
  INDEX idx_start_date (start_date),
  INDEX idx_utility_id (utility_id) 
);

-- 11) Appointment (depends on Move)
CREATE TABLE IF NOT EXISTS Appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  move_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  apt_date DATE NOT NULL,
  apt_time TIME NOT NULL,
  contact_person VARCHAR(100),
  contact_phone VARCHAR(20),
  status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
  FOREIGN KEY (move_id) REFERENCES Moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_move_id (move_id),
  INDEX idx_apt_date (apt_date),
  INDEX idx_status (status)
);

-- 12) Document (depends on Move)
CREATE TABLE IF NOT EXISTS Documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  move_id INT NOT NULL,
  doc_type VARCHAR(100) NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  uploaded_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (move_id) REFERENCES Moves(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_move_id (move_id),
  INDEX idx_doc_type (doc_type)
);




