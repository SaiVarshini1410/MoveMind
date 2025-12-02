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




