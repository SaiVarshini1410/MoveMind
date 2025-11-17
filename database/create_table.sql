CREATE DATABASE IF NOT EXISTS movemind_db;

USE movemind_db;

-- Tables with no foreign Key
CREATE TABLE User(
id INT AUTO_INCREMENT PRIMARY KEY,
firstname  VARCHAR(50) NOT NULL,
lastname   VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE ,
password_hash VARCHAR(255) NOT NULL,
creation_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
INDEX idx_email(email));


CREATE TABLE Address(
id INT AUTO_INCREMENT PRIMARY KEY,
street VARCHAR(64) NOT NULL,
city VARCHAR(64) NOT NULL,
state VARCHAR(64) NOT NULL,
zipcode VARCHAR(64) NOT NULL,
country VARCHAR(64) NOT NULL
);

CREATE TABLE Category(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100)UNIQUE NOT NULL);

CREATE TABLE Utility(
id INT AUTO_INCREMENT PRIMARY KEY,
provider_name VARCHAR(100) NOT NULL,
type ENUM ('electricity','gas','water','internet','trash','other') NOT NULL
);


-- Tables with 1 foreign Key

CREATE TABLE Move(
id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    move_date DATE NOT NULL,
    status ENUM('planned', 'packing', 'in_transit', 'unpacking', 'done') DEFAULT 'planned',
    from_address_id INT NOT NULL,
    to_address_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (from_address_id) REFERENCES Address(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (to_address_id) REFERENCES Address(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_user_id(user_id),      
    INDEX idx_status(status),        
    INDEX idx_move_date(move_date)   
    );
    
CREATE TABLE Room(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
floor INT ,
move_id INT NOT NULL,
FOREIGN KEY (move_id) REFERENCES Move(id) ON UPDATE CASCADE  ON DELETE CASCADE,
INDEX idx_move_id(move_id));

CREATE TABLE Box(
id INT PRIMARY KEY AUTO_INCREMENT,
label_code VARCHAR(50) UNIQUE NOT NULL,
room_id INT,
is_fragile BOOLEAN DEFAULT FALSE,
weight DECIMAL(10, 2) NOT NULL,
status ENUM('empty','packed','loaded','delivered','unpacked') DEFAULT 'empty',
    FOREIGN KEY (room_id) REFERENCES Room(id) ON UPDATE CASCADE ON DELETE SET NULL,
    INDEX idx_room_id(room_id),      
    INDEX idx_status(status)        
);


CREATE TABLE Box_Category(
    box_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (box_id, category_id),
    FOREIGN KEY (box_id) REFERENCES Box(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_category_id(category_id) 
);

CREATE TABLE Item(
    id INT AUTO_INCREMENT PRIMARY KEY,
    box_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    quantity INT DEFAULT 1,
    est_value DECIMAL(10, 2),
    FOREIGN KEY (box_id) REFERENCES Box(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_box_id(box_id)
);

CREATE TABLE move_utilities(
utility_id INT NOT NULL,
move_id INT NOT NULL,
account_number VARCHAR(100) ,
stop_date DATE ,
start_date DATE ,
status ENUM ('planned','requested','confirmed','active','cancelled') DEFAULT 'planned',
CONSTRAINT mv_f1 FOREIGN KEY (utility_id) REFERENCES Utility(id) ON DELETE RESTRICT ON UPDATE CASCADE ,
CONSTRAINT mv_f2 FOREIGN KEY (move_id) REFERENCES Move(id) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT mv_pk PRIMARY KEY(move_id, utility_id),
  INDEX idx_status (status),
  INDEX idx_start_date (start_date));

CREATE TABLE Appointment(
    id INT AUTO_INCREMENT PRIMARY KEY,
    move_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    apt_date DATE NOT NULL,
    apt_time TIME NOT NULL,
    contact_person VARCHAR(100),
    contact_phone VARCHAR(20),
    status ENUM('scheduled','completed','cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (move_id) REFERENCES Move(id) ON DELETE CASCADE ON UPDATE CASCADE ,
    INDEX idx_move_id(move_id),  
    INDEX idx_apt_date(apt_date),
    INDEX idx_status(status)  
);



CREATE TABLE Document(
 id INT AUTO_INCREMENT PRIMARY KEY,
 move_id INT NOT NULL,
 doc_type VARCHAR(100) NOT NULL,
 file_url VARCHAR(500) NOT NULL,
uploaded_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (move_id) REFERENCES Move(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_move_id(move_id),
    INDEX idx_doc_type(doc_type)
);







