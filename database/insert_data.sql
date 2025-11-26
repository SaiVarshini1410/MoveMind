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
