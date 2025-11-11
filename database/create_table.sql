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
    FOREIGN KEY (to_address_id) REFERENCES Address(id) ON DELETE RESTRICT ON UPDATE CASCADE
);









