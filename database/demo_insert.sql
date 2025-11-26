-- ======================================================================
-- DEMO USERS FOR TESTING (All use password: Demo123!)
-- Password hash: $2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy
--
-- demo1@gmail.com
-- demo2@gmail.com
-- demo3@gmail.com
-- demo4@gmail.com
-- demo5@gmail.com
-- ======================================================================

USE movemind_db;

-- ======================================================================
-- CATEGORIES
-- ======================================================================
INSERT INTO categories (name) VALUES
('Kitchen'),
('Electronics'),
('Clothing'),
('Fragile'),
('Essentials'),
('Misc');

-- ======================================================================
-- USERS
-- ======================================================================
INSERT INTO users (first_name,last_name,email,password) VALUES
('Demo','One','demo1@gmail.com','$2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy'),
('Demo','Two','demo2@gmail.com','$2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy'),
('Demo','Three','demo3@gmail.com','$2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy'),
('Demo','Four','demo4@gmail.com','$2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy'),
('Demo','Five','demo5@gmail.com','$2b$10$66vcMMLiXV1.vv9PTow2ZeFuDcxqOZPLy3YI2QmZw2sS31Cfv7vHy');

-- ======================================================================
-- ADDRESSES & USER ADDRESS LINKS
-- ======================================================================

-- USER 1 (IDs 1–3)
INSERT INTO addresses (line1,city,state,postal_code,country) VALUES
('10 Apple St','Boston','MA','02111','USA'),
('200 Cambridge Ave','Cambridge','MA','02139','USA'),
('52 Broadway','Somerville','MA','02145','USA');

INSERT INTO user_addresses (user_id,address_id,label) VALUES
(1,1,'Home'),
(1,2,'Old Home'),
(1,3,'Office');

-- USER 2 (IDs 4–6)
INSERT INTO addresses (line1,city,state,postal_code,country) VALUES
('44 Beacon St','Boston','MA','02108','USA'),
('91 Summer St','Cambridge','MA','02141','USA'),
('12 River Rd','Medford','MA','02155','USA');

INSERT INTO user_addresses (user_id,address_id,label) VALUES
(2,4,'Home'),
(2,5,'Parents'),
(2,6,'Office');

-- USER 3 (IDs 7–9)
INSERT INTO addresses (line1,city,state,postal_code,country) VALUES
('77 Park St','Boston','MA','02116','USA'),
('101 Main St','Cambridge','MA','02142','USA'),
('5 Maple Ave','Arlington','MA','02476','USA');

INSERT INTO user_addresses (user_id,address_id,label) VALUES
(3,7,'Home'),
(3,8,'Old Home'),
(3,9,'Office');

-- USER 4 (IDs 10–12)
INSERT INTO addresses (line1,city,state,postal_code,country) VALUES
('300 Oak St','Boston','MA','02124','USA'),
('22 Elm St','Cambridge','MA','02138','USA'),
('900 Mystic Ave','Medford','MA','02155','USA');

INSERT INTO user_addresses (user_id,address_id,label) VALUES
(4,10,'Home'),
(4,11,'Parents'),
(4,12,'Office');

-- USER 5 (IDs 13–15)
INSERT INTO addresses (line1,city,state,postal_code,country) VALUES
('81 Harrison Ave','Boston','MA','02118','USA'),
('120 Harvard St','Cambridge','MA','02139','USA'),
('14 Grove St','Watertown','MA','02472','USA');

INSERT INTO user_addresses (user_id,address_id,label) VALUES
(5,13,'Home'),
(5,14,'Parents'),
(5,15,'Office');

-- ======================================================================
-- UTILITIES
-- ======================================================================
INSERT INTO utilities (provider_name,type) VALUES
('Eversource','electricity'),
('National Grid','gas'),
('Cambridge Water','water'),
('Verizon','internet'),
('City Trash','trash'),
('Generic Utility','other');


-- ======================================================================
-- =============== USER 1 MOVES (IDs 1,2,3) ===============================
-- ======================================================================

INSERT INTO moves (user_id,title,move_date,status,from_address_id,to_address_id) VALUES
(1,'Moving to Cambridge','2025-12-15','packing',1,2),
(1,'Office Relocation','2026-02-01','planned',3,1),
(1,'Somerville Apartment Setup','2026-03-20','in_transit',2,3);

-- ROOMS FOR MOVE 1
INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',1),('Living Room','1',1),('Bedroom','2',1),
('Bathroom','2',1),('Office','3',1),('Storage','Basement',1);

-- ROOMS FOR MOVE 2
INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',2),('Bedroom','1',2),('Living Room','1',2),
('Office','2',2),('Garage','G',2);

-- ROOMS FOR MOVE 3
INSERT INTO rooms (name,floor,move_id) VALUES
('Bedroom','1',3),('Kitchen','1',3),('Living Room','1',3),
('Bathroom','2',3),('Storage','Basement',3);

-- BOXES FOR MOVE 1 (Kitchen)
INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(1,'Kitchen','BX1-KIT-1',0,12.5,'packed'),
(1,'Kitchen','BX1-KIT-2',1,5.2,'packed'),
(1,'Kitchen','BX1-KIT-3',0,9.1,'loaded');

-- BOXES FOR MOVE 1 (Bedroom)
INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(1,'Bedroom','BX1-BED-1',1,7.4,'packed'),
(1,'Bedroom','BX1-BED-2',0,10.0,'empty');

-- ITEMS for some boxes
INSERT INTO items (box_id,name,quantity,value) VALUES
(1,'Pots and Pans',4,80),(1,'Cutlery Set',20,40),(1,'Plates',12,30),
(2,'Glass Cups',6,25),(2,'Wine Glasses',4,60),
(4,'Bedsheets',3,45),(4,'Pillows',4,50);

-- CATEGORIES
INSERT INTO box_categories (box_id,category_id) VALUES
(1,1),(1,5),(2,4),(3,1),(4,3),(5,2);

-- DOCUMENTS for move 1
INSERT INTO documents (move_id,doc_type,file_url) VALUES
(1,'Lease','/files/lease1.pdf'),
(1,'Checklist','/files/checklist1.pdf'),
(1,'ID Proof','/files/id1.pdf');

-- APPOINTMENTS
INSERT INTO appointments (move_id,title,description,apt_date,apt_time,person,contact_phone,status) VALUES
(1,'Mover Arrival','Packers arrival','2025-12-10','09:00','Mover Co','5551112222','scheduled'),
(1,'Key Handover','Hand keys','2025-12-14','14:00','Landlord','5552223333','scheduled');

-- UTILITIES
INSERT INTO move_utilities (utility_id,move_id,account_number,start_date,status) VALUES
(1,1,'EV001','2025-12-16','active'),
(2,1,'GAS001','2025-12-16','requested'),
(3,1,'WAT001','2025-12-16','active'),
(4,1,'INT001','2025-12-17','planned'),
(5,1,'TR001','2025-12-18','active');


-- ======================================================================
-- =============== USER 2 MOVES (IDs 4,5,6) ===============================
-- ======================================================================

INSERT INTO moves (user_id,title,move_date,status,from_address_id,to_address_id) VALUES
(2,'Moving Near MIT','2025-11-10','planned',4,5),
(2,'Parents House Shift','2026-01-12','packing',5,6),
(2,'Medford Condo Move','2026-04-01','in_transit',6,4);

-- Rooms for move 4
INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',4),('Bedroom','1',4),('Living Room','1',4),
('Bathroom','2',4),('Office','2',4),('Storage','Basement',4);

-- Boxes for move 4
INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(4,'Kitchen','BX4-KIT-1',0,11,'packed'),
(4,'Kitchen','BX4-KIT-2',1,6,'packed'),
(4,'Bedroom','BX4-BED-1',0,8,'loaded'),
(4,'Living Room','BX4-LR-1',1,9,'packed');

INSERT INTO items (box_id,name,quantity,value) VALUES
(6,'Mugs',6,20),(6,'Bowls',4,15),
(7,'Tea Cups',8,40),(7,'Plates',10,25),
(8,'Blankets',2,60),(9,'TV Remote',1,10);

INSERT INTO box_categories (box_id,category_id) VALUES
(6,1),(7,4),(8,3),(9,2);

INSERT INTO documents (move_id,doc_type,file_url) VALUES
(4,'Lease','/files/m4_lease.pdf'),
(4,'Bill','/files/m4_bill.pdf'),
(4,'Checklist','/files/m4_check.pdf');

INSERT INTO appointments (move_id,title,description,apt_date,apt_time,person,contact_phone,status) VALUES
(4,'Inspection','Final inspection','2025-11-08','10:00','Inspector','5554443333','scheduled'),
(4,'Moving Truck','Truck arrival','2025-11-10','08:30','Truck Co','5551239999','scheduled');

INSERT INTO move_utilities 
(utility_id,move_id,account_number,start_date,status) VALUES
(1,4,'EV002','2025-11-12','active'),
(2,4,'GAS002','2025-11-12','requested'),
(3,4,'WAT002','2025-11-12','active'),
(4,4,'INT002','2025-11-13','planned'),
(5,4,'TR002','2025-11-14','active');


-- ======================================================================
-- =============== USER 3 MOVES (IDs 7,8,9) ===============================
-- ======================================================================

INSERT INTO moves (user_id,title,move_date,status,from_address_id,to_address_id) VALUES
(3,'Boston to Cambridge Move','2025-10-02','done',7,8),
(3,'Arlington Shift','2026-03-11','packing',8,9),
(3,'Apartment Upgrade','2026-07-19','planned',9,7);

INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',7),('Bedroom','2',7),('Living Room','1',7),
('Bathroom','2',7),('Garage','G',7);

-- Boxes
INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(7,'Kitchen','BX7-KIT-1',0,10,'packed'),
(7,'Kitchen','BX7-KIT-2',1,4,'packed'),
(7,'Bedroom','BX7-BED-1',0,8,'loaded'),
(7,'Living Room','BX7-LR-1',1,9,'unpacked');

INSERT INTO items (box_id,name,quantity,value) VALUES
(10,'Plates',10,20),(10,'Spices',5,15),
(11,'Glasses',6,25),(11,'Jars',4,18),
(12,'Pillow Covers',4,30),(13,'Books',10,40);

INSERT INTO box_categories (box_id,category_id) VALUES
(10,1),(11,4),(12,3),(13,6);

INSERT INTO documents (move_id,doc_type,file_url) VALUES
(7,'Lease','/files/lease7.pdf'),
(7,'ID','/files/id7.pdf'),
(7,'Invoice','/files/invoice7.pdf');

INSERT INTO appointments 
(move_id,title,description,apt_date,apt_time,person,contact_phone,status) VALUES
(7,'Final Cleaning','Cleaning service','2025-10-01','15:00','Cleaner','5558881111','completed'),
(7,'Truck Arrival','Truck coming','2025-10-02','08:00','MoveCo','5552227777','completed');

INSERT INTO move_utilities VALUES
(1,7,'EV003','2025-10-03','active'),
(2,7,'GAS003','2025-10-03','active'),
(3,7,'WAT003','2025-10-03','active'),
(4,7,'INT003','2025-10-04','active'),
(5,7,'TR003','2025-10-05','active');


-- ======================================================================
-- =============== USER 4 MOVES (IDs 10,11,12) =============================
-- ======================================================================

INSERT INTO moves (user_id,title,move_date,status,from_address_id,to_address_id) VALUES
(4,'Downtown Condo Move','2025-09-15','in_transit',10,11),
(4,'Medford Relocation','2026-01-05','planned',11,12),
(4,'Boston Upgrade','2026-04-21','packing',12,10);

INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',10),('Bedroom','1',10),('Living Room','1',10),
('Office','2',10),('Bathroom','2',10),('Storage','Basement',10);

INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(10,'Kitchen','BX10-KIT-1',0,9,'packed'),
(10,'Kitchen','BX10-KIT-2',1,6,'packed'),
(10,'Bedroom','BX10-BED-1',0,7,'loaded'),
(10,'Living Room','BX10-LR-1',1,12,'delivered');

INSERT INTO items (box_id,name,quantity,value) VALUES
(14,'Bowls',5,20),(14,'Cups',4,15),
(15,'Plates',10,30),(15,'Tea Set',1,50),
(16,'Bedsheets',2,40),(17,'Frame',1,25);

INSERT INTO box_categories (box_id,category_id) VALUES
(14,1),(15,4),(16,3),(17,6);

INSERT INTO documents (move_id,doc_type,file_url) VALUES
(10,'Lease','/files/m10_lease.pdf'),
(10,'Bill','/files/m10_bill.pdf'),
(10,'Checklist','/files/m10_check.pdf');

INSERT INTO appointments 
(move_id,title,description,apt_date,apt_time,person,contact_phone,status) VALUES
(10,'Inspection','See apartment','2025-09-14','11:00','Inspector','5554448888','scheduled'),
(10,'Truck Arrival','Moving truck','2025-09-15','07:30','Move Co','5559996666','scheduled');

INSERT INTO move_utilities VALUES
(1,10,'EV004','2025-09-16','active'),
(2,10,'GAS004','2025-09-16','active'),
(3,10,'WAT004','2025-09-16','active'),
(4,10,'INT004','2025-09-17','requested'),
(5,10,'TR004','2025-09-18','active');


-- ======================================================================
-- =============== USER 5 MOVES (IDs 13,14,15) =============================
-- ======================================================================

INSERT INTO moves (user_id,title,move_date,status,from_address_id,to_address_id) VALUES
(5,'Watertown Relocation','2025-08-10','done',13,14),
(5,'Back to Cambridge','2026-01-20','packing',14,15),
(5,'Boston Apartment Swap','2026-06-01','planned',15,13);

INSERT INTO rooms (name,floor,move_id) VALUES
('Kitchen','1',13),('Bedroom','1',13),('Living Room','1',13),
('Bathroom','2',13),('Office','2',13),('Garage','G',13);

INSERT INTO boxes (move_id,room_name,label_code,fragile,weight,status) VALUES
(13,'Kitchen','BX13-KIT-1',0,11,'packed'),
(13,'Kitchen','BX13-KIT-2',1,5,'packed'),
(13,'Bedroom','BX13-BED-1',0,8,'loaded'),
(13,'Living Room','BX13-LR-1',1,9,'delivered');

INSERT INTO items (box_id,name,quantity,value) VALUES
(18,'Pans',3,30),(18,'Cups',6,15),
(19,'Glasses',8,40),(19,'Jars',3,20),
(20,'Pillow Covers',4,25),(21,'Photo Frames',2,20);

INSERT INTO box_categories (box_id,category_id) VALUES
(18,1),(19,4),(20,3),(21,6);

INSERT INTO documents (move_id,doc_type,file_url) VALUES
(13,'Lease','/files/m13_lease.pdf'),
(13,'Bill','/files/m13_bill.pdf'),
(13,'Checklist','/files/m13_check.pdf');

INSERT INTO appointments 
(move_id,title,description,apt_date,apt_time,person,contact_phone,status) VALUES
(13,'Cleaner','Deep clean','2025-08-09','13:00','Cleaner','5554441212','completed'),
(13,'Truck','Truck arrival','2025-08-10','08:00','Truck Co','5557779999','completed');

INSERT INTO move_utilities VALUES
(1,13,'EV005','2025-08-11','active'),
(2,13,'GAS005','2025-08-11','active'),
(3,13,'WAT005','2025-08-11','active'),
(4,13,'INT005','2025-08-12','requested'),
(5,13,'TR005','2025-08-13','active');

