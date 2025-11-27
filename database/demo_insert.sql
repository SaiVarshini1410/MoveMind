USE movemind_db;

-- DEMO LOGINS (all with password: Demo123!)
-- Demo One  -> email: demo1@gmail.com  password: Demo123!
-- Demo Two  -> email: demo2@gmail.com  password: Demo123!
-- Demo Three  -> email: demo3@gmail.com  password: Demo123!
-- Demo Four  -> email: demo4@gmail.com  password: Demo123!
-- Demo Five  -> email: demo5@gmail.com  password: Demo123!


-- ADDRESSES TABLE
-- Creating 50+ unique addresses for use across all users

INSERT INTO addresses (line1, line2, city, state, postal_code, country) VALUES
-- Demo 1 addresses (10+)
('123 Maple Street', 'Apt 4B', 'Boston', 'Massachusetts', '02101', 'USA'),
('456 Oak Avenue', NULL, 'Cambridge', 'Massachusetts', '02139', 'USA'),
('789 Pine Road', 'Unit 201', 'Somerville', 'Massachusetts', '02143', 'USA'),
('321 Elm Drive', NULL, 'Brookline', 'Massachusetts', '02446', 'USA'),
('654 Cedar Lane', 'Suite 5', 'Newton', 'Massachusetts', '02458', 'USA'),
('987 Birch Boulevard', NULL, 'Quincy', 'Massachusetts', '02169', 'USA'),
('147 Willow Way', 'Apt 12', 'Medford', 'Massachusetts', '02155', 'USA'),
('258 Spruce Court', NULL, 'Arlington', 'Massachusetts', '02474', 'USA'),
('369 Ash Street', 'Unit 3C', 'Watertown', 'Massachusetts', '02472', 'USA'),
('741 Cherry Place', NULL, 'Waltham', 'Massachusetts', '02451', 'USA'),
('852 Hickory Circle', 'Apt 7', 'Malden', 'Massachusetts', '02148', 'USA'),

-- Demo 2 addresses (10+)
('1010 Broadway', 'Floor 3', 'New York', 'New York', '10001', 'USA'),
('2020 Park Avenue', NULL, 'Brooklyn', 'New York', '11201', 'USA'),
('3030 Madison Street', 'Apt 15B', 'Queens', 'New York', '11354', 'USA'),
('4040 Lexington Road', NULL, 'Manhattan', 'New York', '10021', 'USA'),
('5050 Fifth Avenue', 'Penthouse', 'New York', 'New York', '10128', 'USA'),
('6060 Amsterdam Ave', 'Unit 8D', 'Bronx', 'New York', '10453', 'USA'),
('7070 Columbus Circle', NULL, 'New York', 'New York', '10019', 'USA'),
('8080 Central Park West', 'Apt 2A', 'New York', 'New York', '10023', 'USA'),
('9090 Wall Street', 'Suite 100', 'New York', 'New York', '10005', 'USA'),
('1111 Battery Place', NULL, 'New York', 'New York', '10004', 'USA'),
('1212 Houston Street', 'Apt 5F', 'New York', 'New York', '10012', 'USA'),

-- Demo 3 addresses (10+)
('500 Market Street', NULL, 'San Francisco', 'California', '94102', 'USA'),
('600 Mission Boulevard', 'Unit 9', 'San Francisco', 'California', '94103', 'USA'),
('700 Valencia Street', 'Apt 22', 'San Francisco', 'California', '94110', 'USA'),
('800 Folsom Street', NULL, 'San Francisco', 'California', '94107', 'USA'),
('900 Howard Street', 'Suite 400', 'San Francisco', 'California', '94103', 'USA'),
('1000 Van Ness Ave', 'Apt 14C', 'San Francisco', 'California', '94109', 'USA'),
('1100 Geary Boulevard', NULL, 'San Francisco', 'California', '94109', 'USA'),
('1200 Lombard Street', 'Unit 6', 'San Francisco', 'California', '94123', 'USA'),
('1300 Haight Street', NULL, 'San Francisco', 'California', '94117', 'USA'),
('1400 Divisadero Street', 'Apt 3B', 'San Francisco', 'California', '94115', 'USA'),
('1500 Castro Street', NULL, 'San Francisco', 'California', '94114', 'USA'),

-- Demo 4 addresses (10+)
('2000 Lake Shore Drive', 'Apt 301', 'Chicago', 'Illinois', '60601', 'USA'),
('2100 Michigan Avenue', NULL, 'Chicago', 'Illinois', '60616', 'USA'),
('2200 State Street', 'Unit 12D', 'Chicago', 'Illinois', '60605', 'USA'),
('2300 Wabash Avenue', NULL, 'Chicago', 'Illinois', '60616', 'USA'),
('2400 Clark Street', 'Apt 8B', 'Chicago', 'Illinois', '60614', 'USA'),
('2500 Halsted Street', NULL, 'Chicago', 'Illinois', '60614', 'USA'),
('2600 Broadway', 'Suite 200', 'Chicago', 'Illinois', '60613', 'USA'),
('2700 Sheridan Road', 'Apt 15A', 'Chicago', 'Illinois', '60657', 'USA'),
('2800 Lincoln Avenue', NULL, 'Chicago', 'Illinois', '60657', 'USA'),
('2900 Fullerton Avenue', 'Unit 4C', 'Chicago', 'Illinois', '60614', 'USA'),
('3000 Diversey Parkway', NULL, 'Chicago', 'Illinois', '60647', 'USA'),

-- Demo 5 addresses (10+)
('3100 Peachtree Street', 'Apt 501', 'Atlanta', 'Georgia', '30303', 'USA'),
('3200 Piedmont Avenue', NULL, 'Atlanta', 'Georgia', '30305', 'USA'),
('3300 Ponce de Leon Ave', 'Unit 7B', 'Atlanta', 'Georgia', '30308', 'USA'),
('3400 Spring Street', NULL, 'Atlanta', 'Georgia', '30309', 'USA'),
('3500 West Peachtree St', 'Suite 300', 'Atlanta', 'Georgia', '30308', 'USA'),
('3600 North Avenue', 'Apt 11D', 'Atlanta', 'Georgia', '30318', 'USA'),
('3700 Marietta Street', NULL, 'Atlanta', 'Georgia', '30318', 'USA'),
('3800 Howell Mill Road', 'Unit 2C', 'Atlanta', 'Georgia', '30318', 'USA'),
('3900 Northside Drive', NULL, 'Atlanta', 'Georgia', '30305', 'USA'),
('4000 Roswell Road', 'Apt 6A', 'Atlanta', 'Georgia', '30342', 'USA'),
('4100 Buford Highway', NULL, 'Atlanta', 'Georgia', '30345', 'USA');


-- USER_ADDRESSES TABLE
-- Linking users to addresses with labels (home, work, storage, etc.)

INSERT INTO user_addresses (user_id, address_id, label) VALUES
-- Demo User 1 (user_id = 1) - 10+ addresses
(1, 1, 'Current Home'),
(1, 2, 'New Home'),
(1, 3, 'Office'),
(1, 4, 'Storage Unit'),
(1, 5, 'Parents House'),
(1, 6, 'Vacation Home'),
(1, 7, 'Previous Apartment'),
(1, 8, 'Friend Storage'),
(1, 9, 'Temporary Stay'),
(1, 10, 'Old Office'),
(1, 11, 'Warehouse'),

-- Demo User 2 (user_id = 2) - 10+ addresses
(2, 12, 'Current Apartment'),
(2, 13, 'New Apartment'),
(2, 14, 'Work Office'),
(2, 15, 'Storage Facility'),
(2, 16, 'Family Home'),
(2, 17, 'Weekend House'),
(2, 18, 'Old Residence'),
(2, 19, 'Business Address'),
(2, 20, 'Temporary Housing'),
(2, 21, 'Gym Storage'),
(2, 22, 'Co-working Space'),

-- Demo User 3 (user_id = 3) - 10+ addresses
(3, 23, 'Current Place'),
(3, 24, 'Moving To'),
(3, 25, 'Office Location'),
(3, 26, 'Storage Space'),
(3, 27, 'Parents Place'),
(3, 28, 'Beach House'),
(3, 29, 'Former Home'),
(3, 30, 'Studio Space'),
(3, 31, 'Hotel Stay'),
(3, 32, 'Workshop'),
(3, 33, 'Shared Office'),

-- Demo User 4 (user_id = 4) - 10+ addresses
(4, 34, 'Home Address'),
(4, 35, 'Future Home'),
(4, 36, 'Work'),
(4, 37, 'Self Storage'),
(4, 38, 'Sister House'),
(4, 39, 'Cabin'),
(4, 40, 'Previous House'),
(4, 41, 'Business Suite'),
(4, 42, 'Airbnb'),
(4, 43, 'Garage Storage'),
(4, 44, 'Remote Office'),

-- Demo User 5 (user_id = 5) - 10+ addresses
(5, 45, 'Main Residence'),
(5, 46, 'New Condo'),
(5, 47, 'Office Building'),
(5, 48, 'Storage Unit A'),
(5, 49, 'Brother House'),
(5, 50, 'Lake House'),
(5, 51, 'Old Apartment'),
(5, 52, 'Coworking Hub'),
(5, 53, 'Extended Stay Hotel'),
(5, 54, 'Art Studio'),
(5, 55, 'Shared Warehouse');


-- CATEGORIES TABLE
-- Different categories for organizing boxes

INSERT INTO categories (name) VALUES
('Kitchen'),
('Bedroom'),
('Bathroom'),
('Living Room'),
('Office'),
('Electronics'),
('Books'),
('Clothing'),
('Toys'),
('Sports'),
('Tools'),
('Decorations'),
('Linens'),
('Fragile'),
('Heavy'),
('Outdoor'),
('Garden'),
('Pet Supplies'),
('Cleaning Supplies'),
('Art Supplies');



-- UTILITIES TABLE
-- Different utility providers and types

INSERT INTO utilities (provider_name, type) VALUES
-- Electricity providers
('Boston Edison Electric', 'electricity'),
('ConEd Power', 'electricity'),
('PG&E Electric', 'electricity'),
('ComEd Electric', 'electricity'),
('Georgia Power', 'electricity'),
('National Grid Electric', 'electricity'),
('Duke Energy', 'electricity'),
('Xcel Energy', 'electricity'),
('Southern California Edison', 'electricity'),
('Eversource Energy', 'electricity'),

-- Gas providers
('National Grid Gas', 'gas'),
('ConEd Gas', 'gas'),
('PG&E Gas', 'gas'),
('Peoples Gas', 'gas'),
('Atlanta Gas Light', 'gas'),
('SoCalGas', 'gas'),
('Nicor Gas', 'gas'),
('Eversource Gas', 'gas'),
('Columbia Gas', 'gas'),
('Amerigas', 'gas'),

-- Water providers
('Boston Water and Sewer', 'water'),
('NYC Water Board', 'water'),
('San Francisco Water', 'water'),
('Chicago Water Dept', 'water'),
('Atlanta Water Works', 'water'),
('East Bay Water', 'water'),
('Cambridge Water', 'water'),
('Brookline Water', 'water'),
('Queens Water', 'water'),
('Oakland Water', 'water'),

-- Internet providers
('Comcast Xfinity', 'internet'),
('Verizon Fios', 'internet'),
('AT&T Internet', 'internet'),
('Spectrum', 'internet'),
('RCN Internet', 'internet'),
('Google Fiber', 'internet'),
('Cox Communications', 'internet'),
('Optimum', 'internet'),
('Frontier', 'internet'),
('CenturyLink', 'internet'),

-- Trash providers
('Waste Management', 'trash'),
('Republic Services', 'trash'),
('Recology', 'trash'),
('City Waste Services', 'trash'),
('Advanced Disposal', 'trash'),
('Progressive Waste', 'trash'),
('Casella Waste', 'trash'),
('GFL Environmental', 'trash'),
('Waste Connections', 'trash'),
('Rumpke Waste', 'trash'),

-- Other utilities
('Home Security Plus', 'other'),
('Alarm Monitoring Services', 'other'),
('Propane Delivery Co', 'other'),
('Solar Panel Services', 'other'),
('Home Heating Oil', 'other');


-- MOVES TABLE
-- Each user gets 10+ moves with different statuses and dates

INSERT INTO moves (user_id, title, move_date, status, from_address_id, to_address_id) VALUES
-- Demo User 1 (user_id = 1) - 10+ moves
(1, 'Moving to Cambridge', '2024-03-15', 'done', 1, 2),
(1, 'Office Relocation', '2024-05-20', 'done', 3, 10),
(1, 'Summer Storage Move', '2024-06-10', 'done', 2, 4),
(1, 'New Apartment Move', '2024-08-01', 'unpacking', 7, 3),
(1, 'Parents House Items', '2024-09-12', 'in_transit', 5, 9),
(1, 'Storage to Home', '2024-10-05', 'packing', 4, 2),
(1, 'Vacation Home Setup', '2024-11-20', 'planned', 2, 6),
(1, 'Warehouse Move', '2024-12-15', 'planned', 11, 8),
(1, 'Temporary Relocation', '2025-01-10', 'planned', 2, 9),
(1, 'Brookline to Newton', '2025-02-14', 'planned', 1, 5),
(1, 'Storage Unit Consolidation', '2025-03-01', 'planned', 8, 4),

-- Demo User 2 (user_id = 2) - 10+ moves
(2, 'Brooklyn to Queens', '2024-02-28', 'done', 13, 15),
(2, 'Manhattan Office Move', '2024-04-18', 'done', 14, 21),
(2, 'Storage Facility Transfer', '2024-06-05', 'done', 16, 17),
(2, 'New Penthouse', '2024-07-22', 'unpacking', 12, 17),
(2, 'Family Items Move', '2024-08-30', 'in_transit', 18, 12),
(2, 'Business Relocation', '2024-10-12', 'packing', 21, 14),
(2, 'Weekend House Move', '2024-11-08', 'planned', 19, 18),
(2, 'Wall Street Office', '2024-12-20', 'planned', 21, 21),
(2, 'Bronx Storage Move', '2025-01-25', 'planned', 18, 16),
(2, 'Central Park Apartment', '2025-02-28', 'planned', 13, 20),
(2, 'Co-working Setup', '2025-03-15', 'planned', 22, 14),

-- Demo User 3 (user_id = 3) - 10+ moves
(3, 'Mission to Valencia', '2024-03-10', 'done', 24, 25),
(3, 'Office Setup SF', '2024-05-15', 'done', 33, 27),
(3, 'Storage Move', '2024-06-22', 'done', 26, 28),
(3, 'Howard Street Loft', '2024-08-08', 'unpacking', 23, 26),
(3, 'Studio Space Move', '2024-09-18', 'in_transit', 32, 24),
(3, 'Beach House Items', '2024-10-25', 'packing', 30, 30),
(3, 'Workshop Relocation', '2024-11-30', 'planned', 34, 32),
(3, 'Haight Street Apartment', '2024-12-10', 'planned', 25, 31),
(3, 'Castro District Move', '2025-01-20', 'planned', 33, 35),
(3, 'Van Ness Condo', '2025-02-18', 'planned', 24, 28),
(3, 'Shared Office Move', '2025-03-22', 'planned', 27, 33),

-- Demo User 4 (user_id = 4) - 10+ moves
(4, 'Lake Shore to Michigan', '2024-02-15', 'done', 34, 35),
(4, 'Chicago Office Move', '2024-04-25', 'done', 36, 44),
(4, 'Self Storage Transfer', '2024-06-12', 'done', 37, 43),
(4, 'Clark Street Apartment', '2024-07-30', 'unpacking', 40, 36),
(4, 'Sister House Items', '2024-09-05', 'in_transit', 40, 38),
(4, 'Cabin Furniture Move', '2024-10-18', 'packing', 34, 41),
(4, 'Business Suite Setup', '2024-11-22', 'planned', 44, 43),
(4, 'Sheridan Road Move', '2024-12-28', 'planned', 36, 40),
(4, 'Garage Consolidation', '2025-01-15', 'planned', 43, 37),
(4, 'Diversey Apartment', '2025-02-20', 'planned', 35, 42),
(4, 'Remote Office Setup', '2025-03-25', 'planned', 44, 36),

-- Demo User 5 (user_id = 5) - 10+ moves
(5, 'Piedmont to Ponce', '2024-03-05', 'done', 46, 47),
(5, 'Office Building Move', '2024-05-10', 'done', 47, 52),
(5, 'Storage Unit Setup', '2024-06-18', 'done', 48, 50),
(5, 'Spring Street Loft', '2024-08-15', 'unpacking', 45, 48),
(5, 'Brother House Transfer', '2024-09-22', 'in_transit', 51, 49),
(5, 'Lake House Furniture', '2024-10-28', 'packing', 46, 52),
(5, 'Art Studio Move', '2024-11-15', 'planned', 54, 47),
(5, 'Howell Mill Apartment', '2024-12-22', 'planned', 48, 50),
(5, 'Warehouse Transfer', '2025-01-18', 'planned', 55, 48),
(5, 'Buford Highway Move', '2025-02-25', 'planned', 47, 53),
(5, 'Coworking Hub Setup', '2025-03-30', 'planned', 52, 47);


-- ROOMS TABLE
-- Each move gets 10+ rooms with different floors

INSERT INTO rooms (name, floor, move_id) VALUES
-- Move 1 (user 1)
('Living Room', 'Ground Floor', 1),
('Master Bedroom', 'Second Floor', 1),
('Kitchen', 'Ground Floor', 1),
('Bathroom', 'Second Floor', 1),
('Guest Bedroom', 'Second Floor', 1),
('Home Office', 'Second Floor', 1),
('Dining Room', 'Ground Floor', 1),
('Garage', 'Ground Floor', 1),
('Basement', 'Basement', 1),
('Attic', 'Attic', 1),
('Laundry Room', 'Ground Floor', 1),

-- Move 2 (user 1)
('Reception Area', 'First Floor', 2),
('Conference Room', 'First Floor', 2),
('Manager Office', 'First Floor', 2),
('Break Room', 'First Floor', 2),
('Storage Room', 'First Floor', 2),
('Server Room', 'First Floor', 2),
('Cubicle Area', 'First Floor', 2),
('Copy Room', 'First Floor', 2),
('Executive Office', 'Second Floor', 2),
('Meeting Room A', 'Second Floor', 2),
('Meeting Room B', 'Second Floor', 2),

-- Move 3 (user 1)
('Storage Unit A', NULL, 3),
('Storage Unit B', NULL, 3),
('Seasonal Items', NULL, 3),
('Furniture Storage', NULL, 3),
('Box Storage', NULL, 3),
('Equipment Storage', NULL, 3),
('Archive Storage', NULL, 3),
('Clothes Storage', NULL, 3),
('Sports Storage', NULL, 3),
('Kitchen Storage', NULL, 3),
('Misc Storage', NULL, 3),

-- Move 4 (user 1)
('Living Room', '1st Floor', 4),
('Master Bedroom', '2nd Floor', 4),
('Kitchen', '1st Floor', 4),
('Bathroom 1', '1st Floor', 4),
('Bathroom 2', '2nd Floor', 4),
('Guest Room', '2nd Floor', 4),
('Study', '2nd Floor', 4),
('Dining Area', '1st Floor', 4),
('Balcony', '2nd Floor', 4),
('Storage Closet', '1st Floor', 4),
('Utility Room', '1st Floor', 4),

-- Move 5 (user 1)
('Entry Hall', 'Main', 5),
('Family Room', 'Main', 5),
('Kitchen', 'Main', 5),
('Master Suite', 'Upper', 5),
('Kids Room 1', 'Upper', 5),
('Kids Room 2', 'Upper', 5),
('Playroom', 'Upper', 5),
('Home Theater', 'Basement', 5),
('Wine Cellar', 'Basement', 5),
('Gym', 'Basement', 5),
('Mudroom', 'Main', 5),

-- Move 6 (user 1)
('Main Storage', 'Level 1', 6),
('Furniture Area', 'Level 1', 6),
('Boxes Section', 'Level 1', 6),
('Electronics Storage', 'Level 2', 6),
('Seasonal Storage', 'Level 2', 6),
('Documents Storage', 'Level 2', 6),
('Tool Storage', 'Level 1', 6),
('Outdoor Storage', 'Level 1', 6),
('Fragile Items', 'Level 2', 6),
('Archive Section', 'Level 2', 6),
('Temp Storage', 'Level 1', 6),

-- Move 7 (user 1)
('Great Room', 'Main Level', 7),
('Master Bedroom', 'Upper Level', 7),
('Kitchen', 'Main Level', 7),
('Den', 'Main Level', 7),
('Guest Suite', 'Upper Level', 7),
('Library', 'Main Level', 7),
('Sun Room', 'Main Level', 7),
('Patio Storage', 'Outside', 7),
('Loft', 'Upper Level', 7),
('Powder Room', 'Main Level', 7),
('Walk-in Closet', 'Upper Level', 7),

-- Move 8 (user 1)
('Warehouse Floor A', 'Ground', 8),
('Warehouse Floor B', 'Ground', 8),
('Warehouse Floor C', 'Ground', 8),
('Office Section', 'Mezzanine', 8),
('Loading Dock', 'Ground', 8),
('Storage Bay 1', 'Ground', 8),
('Storage Bay 2', 'Ground', 8),
('Storage Bay 3', 'Ground', 8),
('Equipment Area', 'Ground', 8),
('Shipping Area', 'Ground', 8),
('Receiving Area', 'Ground', 8),

-- Move 9 (user 1)
('Main Room', 'First', 9),
('Bedroom', 'First', 9),
('Kitchenette', 'First', 9),
('Bathroom', 'First', 9),
('Living Area', 'First', 9),
('Work Space', 'First', 9),
('Storage Area', 'First', 9),
('Closet', 'First', 9),
('Entryway', 'First', 9),
('Balcony Space', 'First', 9),
('Extra Room', 'First', 9),

-- Move 10 (user 1)
('Living Room', 'Ground', 10),
('Master Bedroom', 'Second', 10),
('Kitchen', 'Ground', 10),
('Dining Room', 'Ground', 10),
('Bedroom 2', 'Second', 10),
('Bedroom 3', 'Second', 10),
('Office', 'Ground', 10),
('Bathroom 1', 'Ground', 10),
('Bathroom 2', 'Second', 10),
('Garage', 'Ground', 10),
('Backyard Shed', 'Outside', 10),

-- Move 11 (user 1)
('Combined Storage A', 'Unit 1', 11),
('Combined Storage B', 'Unit 1', 11),
('Combined Storage C', 'Unit 2', 11),
('Combined Storage D', 'Unit 2', 11),
('Small Items', 'Unit 1', 11),
('Large Items', 'Unit 2', 11),
('Furniture Mix', 'Unit 1', 11),
('Boxes Area', 'Unit 2', 11),
('Overflow', 'Unit 1', 11),
('Archived Items', 'Unit 2', 11),
('Misc Area', 'Unit 1', 11),

-- Move 12 (user 2)
('Living Room', 'Floor 3', 12),
('Master Bedroom', 'Floor 3', 12),
('Kitchen', 'Floor 3', 12),
('Guest Bedroom', 'Floor 3', 12),
('Office Nook', 'Floor 3', 12),
('Bathroom', 'Floor 3', 12),
('Dining Area', 'Floor 3', 12),
('Storage Closet', 'Floor 3', 12),
('Laundry', 'Floor 3', 12),
('Hallway', 'Floor 3', 12),
('Terrace', 'Floor 3', 12),

-- Move 13 (user 2)
('Main Office', '5th Floor', 13),
('Conference Room', '5th Floor', 13),
('Break Area', '5th Floor', 13),
('Manager Office', '5th Floor', 13),
('Reception', '5th Floor', 13),
('Storage', '5th Floor', 13),
('Tech Room', '5th Floor', 13),
('Meeting Room', '5th Floor', 13),
('Copy Area', '5th Floor', 13),
('Kitchen', '5th Floor', 13),
('Server Room', '5th Floor', 13),

-- Move 14 (user 2)
('Storage A', 'Bay 1', 14),
('Storage B', 'Bay 1', 14),
('Storage C', 'Bay 2', 14),
('Storage D', 'Bay 2', 14),
('Furniture Bay', 'Bay 1', 14),
('Box Bay', 'Bay 2', 14),
('Equipment Bay', 'Bay 1', 14),
('Seasonal Bay', 'Bay 2', 14),
('Archive Bay', 'Bay 1', 14),
('Overflow Bay', 'Bay 2', 14),
('Misc Bay', 'Bay 1', 14),

-- Move 15 (user 2)
('Great Room', 'Penthouse', 15),
('Master Suite', 'Penthouse', 15),
('Gourmet Kitchen', 'Penthouse', 15),
('Library', 'Penthouse', 15),
('Guest Suite 1', 'Penthouse', 15),
('Guest Suite 2', 'Penthouse', 15),
('Home Office', 'Penthouse', 15),
('Media Room', 'Penthouse', 15),
('Wine Room', 'Penthouse', 15),
('Gym', 'Penthouse', 15),
('Rooftop Terrace', 'Rooftop', 15),

-- Move 16 (user 2)
('Main Living', '2nd', 16),
('Bedroom 1', '2nd', 16),
('Bedroom 2', '2nd', 16),
('Kitchen', '2nd', 16),
('Office Space', '2nd', 16),
('Bathroom 1', '2nd', 16),
('Bathroom 2', '2nd', 16),
('Storage Room', '2nd', 16),
('Dining Room', '2nd', 16),
('Utility', '2nd', 16),
('Entry', '2nd', 16),

-- Move 17 (user 2)
('Main Office Space', '8th Floor', 17),
('Executive Suite', '8th Floor', 17),
('Conference A', '8th Floor', 17),
('Conference B', '8th Floor', 17),
('Break Room', '8th Floor', 17),
('IT Department', '8th Floor', 17),
('Reception Area', '8th Floor', 17),
('Storage Room', '8th Floor', 17),
('Kitchen Area', '8th Floor', 17),
('Copy Center', '8th Floor', 17),
('Server Area', '8th Floor', 17),

-- Move 18 (user 2)
('Main House', 'Ground', 18),
('Bedroom', 'Second', 18),
('Kitchen', 'Ground', 18),
('Living Room', 'Ground', 18),
('Den', 'Ground', 18),
('Bathroom 1', 'Ground', 18),
('Bathroom 2', 'Second', 18),
('Garage', 'Ground', 18),
('Basement', 'Lower', 18),
('Deck Storage', 'Outside', 18),
('Shed', 'Outside', 18),

-- Move 19 (user 2)
('Trading Floor', '10th', 19),
('Private Office 1', '10th', 19),
('Private Office 2', '10th', 19),
('Meeting Room', '10th', 19),
('Break Area', '10th', 19),
('Reception', '10th', 19),
('Conference Suite', '10th', 19),
('Storage', '10th', 19),
('Tech Center', '10th', 19),
('Kitchen', '10th', 19),
('Executive Area', '10th', 19),

-- Move 20 (user 2)
('Temp Storage 1', 'Level A', 20),
('Temp Storage 2', 'Level A', 20),
('Temp Storage 3', 'Level B', 20),
('Temp Storage 4', 'Level B', 20),
('Box Area', 'Level A', 20),
('Furniture Area', 'Level B', 20),
('Equipment Area', 'Level A', 20),
('Archive Area', 'Level B', 20),
('Seasonal Area', 'Level A', 20),
('Overflow Area', 'Level B', 20),
('Misc Area', 'Level A', 20),

-- Move 21 (user 2)
('Apartment Living', '15th', 21),
('Master Bedroom', '15th', 21),
('Second Bedroom', '15th', 21),
('Kitchen', '15th', 21),
('Dining Area', '15th', 21),
('Office', '15th', 21),
('Bathroom 1', '15th', 21),
('Bathroom 2', '15th', 21),
('Storage', '15th', 21),
('Laundry', '15th', 21),
('Balcony', '15th', 21),

-- Move 22 (user 2)
('Open Workspace', '3rd Floor', 22),
('Private Office', '3rd Floor', 22),
('Meeting Pod 1', '3rd Floor', 22),
('Meeting Pod 2', '3rd Floor', 22),
('Lounge Area', '3rd Floor', 22),
('Kitchen', '3rd Floor', 22),
('Phone Booths', '3rd Floor', 22),
('Storage', '3rd Floor', 22),
('Reception', '3rd Floor', 22),
('Conference Room', '3rd Floor', 22),
('Tech Hub', '3rd Floor', 22),

-- Move 23 (user 3)
('Living Area', '2nd', 23),
('Bedroom', '2nd', 23),
('Kitchen', '2nd', 23),
('Bathroom', '2nd', 23),
('Office Corner', '2nd', 23),
('Dining Space', '2nd', 23),
('Storage', '2nd', 23),
('Closet', '2nd', 23),
('Laundry', '2nd', 23),
('Entry', '2nd', 23),
('Balcony', '2nd', 23),

-- Move 24 (user 3)
('Main Office', '4th Floor', 24),
('Conference Room', '4th Floor', 24),
('Break Room', '4th Floor', 24),
('Storage Room', '4th Floor', 24),
('Reception', '4th Floor', 24),
('Manager Office', '4th Floor', 24),
('Open Space', '4th Floor', 24),
('Kitchen', '4th Floor', 24),
('Meeting Room', '4th Floor', 24),
('Tech Room', '4th Floor', 24),
('Copy Area', '4th Floor', 24),

-- Move 25 (user 3)
('Storage Section A', 'Unit 5', 25),
('Storage Section B', 'Unit 5', 25),
('Storage Section C', 'Unit 6', 25),
('Storage Section D', 'Unit 6', 25),
('Boxes', 'Unit 5', 25),
('Furniture', 'Unit 6', 25),
('Equipment', 'Unit 5', 25),
('Seasonal', 'Unit 6', 25),
('Archive', 'Unit 5', 25),
('Overflow', 'Unit 6', 25),
('Misc', 'Unit 5', 25),

-- Move 26 (user 3)
('Loft Living', 'Main', 26),
('Bedroom Area', 'Main', 26),
('Kitchen', 'Main', 26),
('Bathroom', 'Main', 26),
('Office Space', 'Main', 26),
('Dining Area', 'Main', 26),
('Storage', 'Main', 26),
('Closet Space', 'Main', 26),
('Utility', 'Main', 26),
('Entry', 'Main', 26),
('Mezzanine', 'Upper', 26),

-- Move 27 (user 3)
('Studio Main', 'Ground', 27),
('Work Area', 'Ground', 27),
('Storage Area', 'Ground', 27),
('Equipment Corner', 'Ground', 27),
('Display Area', 'Ground', 27),
('Office Space', 'Ground', 27),
('Kitchen', 'Ground', 27),
('Bathroom', 'Ground', 27),
('Storage Closet', 'Ground', 27),
('Entrance', 'Ground', 27),
('Back Room', 'Ground', 27),

-- Move 28 (user 3)
('Beach Living', 'Main', 28),
('Master Bedroom', 'Main', 28),
('Guest Bedroom', 'Main', 28),
('Kitchen', 'Main', 28),
('Dining', 'Main', 28),
('Bathroom 1', 'Main', 28),
('Bathroom 2', 'Main', 28),
('Deck Storage', 'Outside', 28),
('Garage', 'Ground', 28),
('Laundry', 'Main', 28),
('Patio', 'Outside', 28),

-- Move 29 (user 3)
('Workshop Main', 'Floor 1', 29),
('Tool Area', 'Floor 1', 29),
('Work Benches', 'Floor 1', 29),
('Storage Bay', 'Floor 1', 29),
('Equipment Area', 'Floor 1', 29),
('Parts Storage', 'Floor 1', 29),
('Office', 'Floor 1', 29),
('Bathroom', 'Floor 1', 29),
('Supply Room', 'Floor 1', 29),
('Loading Area', 'Floor 1', 29),
('Back Storage', 'Floor 1', 29),

-- Move 30 (user 3)
('Apartment Main', '6th', 30),
('Bedroom', '6th', 30),
('Kitchen', '6th', 30),
('Living Room', '6th', 30),
('Bathroom', '6th', 30),
('Office', '6th', 30),
('Dining Area', '6th', 30),
('Storage', '6th', 30),
('Laundry', '6th', 30),
('Closet', '6th', 30),
('Balcony', '6th', 30),

-- Move 31 (user 3)
('Castro Living', '3rd', 31),
('Bedroom 1', '3rd', 31),
('Bedroom 2', '3rd', 31),
('Kitchen', '3rd', 31),
('Bathroom 1', '3rd', 31),
('Bathroom 2', '3rd', 31),
('Office', '3rd', 31),
('Dining Room', '3rd', 31),
('Storage', '3rd', 31),
('Laundry', '3rd', 31),
('Entry', '3rd', 31),

-- Move 32 (user 3)
('Condo Main', '12th', 32),
('Master Suite', '12th', 32),
('Guest Room', '12th', 32),
('Kitchen', '12th', 32),
('Living Room', '12th', 32),
('Dining Room', '12th', 32),
('Office', '12th', 32),
('Bathroom 1', '12th', 32),
('Bathroom 2', '12th', 32),
('Storage', '12th', 32),
('Balcony', '12th', 32),

-- Move 33 (user 3)
('Shared Office A', '7th', 33),
('Shared Office B', '7th', 33),
('Meeting Room', '7th', 33),
('Break Area', '7th', 33),
('Kitchen', '7th', 33),
('Reception', '7th', 33),
('Conference', '7th', 33),
('Storage', '7th', 33),
('Phone Rooms', '7th', 33),
('Lounge', '7th', 33),
('Tech Area', '7th', 33),

-- Move 34 (user 4)
('Living Room', '5th Floor', 34),
('Master Bedroom', '5th Floor', 34),
('Kitchen', '5th Floor', 34),
('Guest Bedroom', '5th Floor', 34),
('Office', '5th Floor', 34),
('Bathroom 1', '5th Floor', 34),
('Bathroom 2', '5th Floor', 34),
('Dining Area', '5th Floor', 34),
('Storage', '5th Floor', 34),
('Laundry', '5th Floor', 34),
('Balcony', '5th Floor', 34),

-- Move 35 (user 4)
('Main Office', '9th Floor', 35),
('Conference Room', '9th Floor', 35),
('Break Room', '9th Floor', 35),
('Manager Suite', '9th Floor', 35),
('Reception', '9th Floor', 35),
('Meeting Room A', '9th Floor', 35),
('Meeting Room B', '9th Floor', 35),
('Storage', '9th Floor', 35),
('Kitchen', '9th Floor', 35),
('Copy Room', '9th Floor', 35),
('Server Room', '9th Floor', 35),

-- Move 36 (user 4)
('Self Storage A', 'Unit 10', 36),
('Self Storage B', 'Unit 10', 36),
('Self Storage C', 'Unit 11', 36),
('Self Storage D', 'Unit 11', 36),
('Box Storage', 'Unit 10', 36),
('Furniture Storage', 'Unit 11', 36),
('Equipment Storage', 'Unit 10', 36),
('Seasonal Storage', 'Unit 11', 36),
('Archive Storage', 'Unit 10', 36),
('Overflow Storage', 'Unit 11', 36),
('Misc Storage', 'Unit 10', 36),

-- Move 37 (user 4)
('Apartment Living', '8th', 37),
('Master Bedroom', '8th', 37),
('Second Bedroom', '8th', 37),
('Kitchen', '8th', 37),
('Living Area', '8th', 37),
('Dining Area', '8th', 37),
('Office', '8th', 37),
('Bathroom 1', '8th', 37),
('Bathroom 2', '8th', 37),
('Storage', '8th', 37),
('Laundry', '8th', 37),

-- Move 38 (user 4)
('Sister House Living', 'Main', 38),
('Bedroom 1', 'Main', 38),
('Bedroom 2', 'Upper', 38),
('Kitchen', 'Main', 38),
('Dining Room', 'Main', 38),
('Bathroom 1', 'Main', 38),
('Bathroom 2', 'Upper', 38),
('Office', 'Main', 38),
('Storage', 'Main', 38),
('Garage', 'Ground', 38),
('Basement', 'Lower', 38),

-- Move 39 (user 4)
('Cabin Main', 'Main Level', 39),
('Bedroom 1', 'Main Level', 39),
('Bedroom 2', 'Loft', 39),
('Kitchen', 'Main Level', 39),
('Living Area', 'Main Level', 39),
('Bathroom', 'Main Level', 39),
('Storage Room', 'Main Level', 39),
('Porch Storage', 'Outside', 39),
('Shed', 'Outside', 39),
('Loft Area', 'Loft', 39),
('Utility', 'Main Level', 39),

-- Move 40 (user 4)
('Business Suite', '12th Floor', 40),
('Private Office 1', '12th Floor', 40),
('Private Office 2', '12th Floor', 40),
('Conference Room', '12th Floor', 40),
('Reception', '12th Floor', 40),
('Break Room', '12th Floor', 40),
('Storage', '12th Floor', 40),
('Kitchen', '12th Floor', 40),
('Meeting Room', '12th Floor', 40),
('Copy Area', '12th Floor', 40),
('Server Room', '12th Floor', 40),

-- Move 41 (user 4)
('Sheridan Living', '10th', 41),
('Master Bedroom', '10th', 41),
('Guest Bedroom', '10th', 41),
('Kitchen', '10th', 41),
('Dining Room', '10th', 41),
('Living Room', '10th', 41),
('Office', '10th', 41),
('Bathroom 1', '10th', 41),
('Bathroom 2', '10th', 41),
('Storage', '10th', 41),
('Balcony', '10th', 41),

-- Move 42 (user 4)
('Garage Main', 'Ground', 42),
('Garage Bay 1', 'Ground', 42),
('Garage Bay 2', 'Ground', 42),
('Tool Area', 'Ground', 42),
('Storage Shelves', 'Ground', 42),
('Equipment Corner', 'Ground', 42),
('Work Bench', 'Ground', 42),
('Parts Storage', 'Ground', 42),
('Overflow Area', 'Ground', 42),
('Bike Storage', 'Ground', 42),
('Garden Storage', 'Ground', 42),

-- Move 43 (user 4)
('Diversey Living', '4th', 43),
('Bedroom', '4th', 43),
('Kitchen', '4th', 43),
('Bathroom', '4th', 43),
('Living Area', '4th', 43),
('Dining Space', '4th', 43),
('Office', '4th', 43),
('Storage', '4th', 43),
('Laundry', '4th', 43),
('Closet', '4th', 43),
('Balcony', '4th', 43),

-- Move 44 (user 4)
('Remote Office Main', '6th Floor', 44),
('Meeting Room', '6th Floor', 44),
('Private Office', '6th Floor', 44),
('Open Workspace', '6th Floor', 44),
('Break Area', '6th Floor', 44),
('Kitchen', '6th Floor', 44),
('Phone Booths', '6th Floor', 44),
('Storage', '6th Floor', 44),
('Conference Room', '6th Floor', 44),
('Reception', '6th Floor', 44),
('Tech Hub', '6th Floor', 44),

-- Move 45 (user 5)
('Loft Living', '3rd Floor', 45),
('Master Bedroom', '3rd Floor', 45),
('Kitchen', '3rd Floor', 45),
('Guest Bedroom', '3rd Floor', 45),
('Office', '3rd Floor', 45),
('Bathroom 1', '3rd Floor', 45),
('Bathroom 2', '3rd Floor', 45),
('Dining Area', '3rd Floor', 45),
('Storage', '3rd Floor', 45),
('Laundry', '3rd Floor', 45),
('Balcony', '3rd Floor', 45),

-- Move 46 (user 5)
('Office Main', '7th Floor', 46),
('Conference A', '7th Floor', 46),
('Conference B', '7th Floor', 46),
('Break Room', '7th Floor', 46),
('Manager Office', '7th Floor', 46),
('Reception', '7th Floor', 46),
('Storage', '7th Floor', 46),
('Kitchen', '7th Floor', 46),
('Meeting Room', '7th Floor', 46),
('Copy Center', '7th Floor', 46),
('Server Room', '7th Floor', 46),

-- Move 47 (user 5)
('Storage Unit Main', 'Level 3', 47),
('Box Area', 'Level 3', 47),
('Furniture Area', 'Level 3', 47),
('Equipment Area', 'Level 4', 47),
('Seasonal Area', 'Level 4', 47),
('Archive Area', 'Level 3', 47),
('Overflow Area', 'Level 4', 47),
('Heavy Items', 'Level 3', 47),
('Fragile Items', 'Level 4', 47),
('Misc Area', 'Level 3', 47),
('Temp Area', 'Level 4', 47),

-- Move 48 (user 5)
('Spring Loft Main', '5th', 48),
('Master Suite', '5th', 48),
('Second Bedroom', '5th', 48),
('Kitchen', '5th', 48),
('Living Room', '5th', 48),
('Dining Area', '5th', 48),
('Office Space', '5th', 48),
('Bathroom 1', '5th', 48),
('Bathroom 2', '5th', 48),
('Storage', '5th', 48),
('Terrace', '5th', 48),

-- Move 49 (user 5)
('Brother House Main', 'Ground', 49),
('Bedroom 1', 'Second', 49),
('Bedroom 2', 'Second', 49),
('Kitchen', 'Ground', 49),
('Living Room', 'Ground', 49),
('Dining Room', 'Ground', 49),
('Office', 'Ground', 49),
('Bathroom 1', 'Ground', 49),
('Bathroom 2', 'Second', 49),
('Storage', 'Ground', 49),
('Garage', 'Ground', 49),

-- Move 50 (user 5)
('Lake House Main', 'Main Floor', 50),
('Master Bedroom', 'Main Floor', 50),
('Guest Room 1', 'Main Floor', 50),
('Guest Room 2', 'Loft', 50),
('Kitchen', 'Main Floor', 50),
('Living Area', 'Main Floor', 50),
('Dining Area', 'Main Floor', 50),
('Bathroom 1', 'Main Floor', 50),
('Bathroom 2', 'Loft', 50),
('Deck Storage', 'Outside', 50),
('Boat Storage', 'Outside', 50),

-- Move 51 (user 5)
('Art Studio Main', 'Ground', 51),
('Work Area 1', 'Ground', 51),
('Work Area 2', 'Ground', 51),
('Storage Area', 'Ground', 51),
('Supply Room', 'Ground', 51),
('Display Area', 'Ground', 51),
('Office', 'Ground', 51),
('Kitchen', 'Ground', 51),
('Bathroom', 'Ground', 51),
('Equipment Area', 'Ground', 51),
('Back Room', 'Ground', 51),

-- Move 52 (user 5)
('Howell Mill Living', '7th', 52),
('Master Bedroom', '7th', 52),
('Second Bedroom', '7th', 52),
('Kitchen', '7th', 52),
('Living Room', '7th', 52),
('Dining Area', '7th', 52),
('Office', '7th', 52),
('Bathroom 1', '7th', 52),
('Bathroom 2', '7th', 52),
('Storage', '7th', 52),
('Balcony', '7th', 52),

-- Move 53 (user 5)
('Warehouse Section A', 'Bay 1', 53),
('Warehouse Section B', 'Bay 1', 53),
('Warehouse Section C', 'Bay 2', 53),
('Warehouse Section D', 'Bay 2', 53),
('Office Area', 'Mezzanine', 53),
('Storage Bay 1', 'Bay 1', 53),
('Storage Bay 2', 'Bay 2', 53),
('Equipment Bay', 'Bay 1', 53),
('Loading Area', 'Bay 2', 53),
('Shipping Area', 'Bay 1', 53),
('Receiving Area', 'Bay 2', 53),

-- Move 54 (user 5)
('Buford Living', '2nd', 54),
('Bedroom 1', '2nd', 54),
('Bedroom 2', '2nd', 54),
('Kitchen', '2nd', 54),
('Living Area', '2nd', 54),
('Dining Area', '2nd', 54),
('Office', '2nd', 54),
('Bathroom 1', '2nd', 54),
('Bathroom 2', '2nd', 54),
('Storage', '2nd', 54),
('Patio', '2nd', 54),

-- Move 55 (user 5)
('Coworking Main', '4th Floor', 55),
('Private Office 1', '4th Floor', 55),
('Private Office 2', '4th Floor', 55),
('Open Workspace', '4th Floor', 55),
('Meeting Room A', '4th Floor', 55),
('Meeting Room B', '4th Floor', 55),
('Kitchen', '4th Floor', 55),
('Lounge Area', '4th Floor', 55),
('Phone Booths', '4th Floor', 55),
('Storage', '4th Floor', 55),
('Reception', '4th Floor', 55);


-- BOXES TABLE
-- More realistic: 10+ boxes per move, but distributed across rooms (some rooms have 0-2 boxes, others have 5-6)

INSERT INTO boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
-- Move 1 boxes (12 boxes across different rooms)
(1, 'Living Room', 'LR-001-M1', 0, 25.50, 'unpacked'),
(1, 'Living Room', 'LR-002-M1', 1, 15.00, 'unpacked'),
(1, 'Living Room', 'LR-003-M1', 0, 22.00, 'unpacked'),
(1, 'Master Bedroom', 'MB-001-M1', 0, 30.00, 'unpacked'),
(1, 'Master Bedroom', 'MB-002-M1', 1, 12.50, 'unpacked'),
(1, 'Kitchen', 'KIT-001-M1', 1, 28.00, 'unpacked'),
(1, 'Kitchen', 'KIT-002-M1', 1, 22.50, 'unpacked'),
(1, 'Kitchen', 'KIT-003-M1', 1, 26.00, 'unpacked'),
(1, 'Kitchen', 'KIT-004-M1', 1, 24.50, 'unpacked'),
(1, 'Guest Bedroom', 'GB-001-M1', 0, 27.00, 'unpacked'),
(1, 'Home Office', 'HO-001-M1', 0, 35.00, 'unpacked'),
(1, 'Garage', 'GAR-001-M1', 0, 45.00, 'unpacked'),

-- Move 2 boxes (13 boxes)
(2, 'Reception Area', 'REC-001-M2', 0, 20.00, 'unpacked'),
(2, 'Conference Room', 'CONF-001-M2', 0, 25.00, 'unpacked'),
(2, 'Conference Room', 'CONF-002-M2', 0, 23.00, 'unpacked'),
(2, 'Manager Office', 'MGR-001-M2', 0, 30.00, 'unpacked'),
(2, 'Manager Office', 'MGR-002-M2', 0, 28.00, 'unpacked'),
(2, 'Manager Office', 'MGR-003-M2', 1, 18.00, 'unpacked'),
(2, 'Storage Room', 'STOR-001-M2', 0, 40.00, 'unpacked'),
(2, 'Storage Room', 'STOR-002-M2', 0, 38.00, 'unpacked'),
(2, 'Server Room', 'SRV-001-M2', 1, 50.00, 'unpacked'),
(2, 'Cubicle Area', 'CUB-001-M2', 0, 35.00, 'unpacked'),
(2, 'Cubicle Area', 'CUB-002-M2', 0, 32.00, 'unpacked'),
(2, 'Cubicle Area', 'CUB-003-M2', 0, 31.00, 'unpacked'),
(2, 'Executive Office', 'EXEC-001-M2', 1, 32.00, 'unpacked'),

-- Move 3 boxes (11 boxes)
(3, 'Storage Unit A', 'SUA-001-M3', 0, 35.00, 'unpacked'),
(3, 'Storage Unit A', 'SUA-002-M3', 0, 33.00, 'unpacked'),
(3, 'Storage Unit B', 'SUB-001-M3', 0, 38.00, 'unpacked'),
(3, 'Storage Unit B', 'SUB-002-M3', 0, 36.00, 'unpacked'),
(3, 'Seasonal Items', 'SEAS-001-M3', 0, 25.00, 'unpacked'),
(3, 'Furniture Storage', 'FURN-001-M3', 0, 55.00, 'unpacked'),
(3, 'Box Storage', 'BOX-001-M3', 0, 30.00, 'unpacked'),
(3, 'Box Storage', 'BOX-002-M3', 0, 28.00, 'unpacked'),
(3, 'Box Storage', 'BOX-003-M3', 0, 29.00, 'unpacked'),
(3, 'Equipment Storage', 'EQUIP-001-M3', 1, 42.00, 'unpacked'),
(3, 'Archive Storage', 'ARCH-001-M3', 0, 48.00, 'unpacked'),

-- Move 4 boxes (14 boxes)
(4, 'Living Room', 'LR-001-M4', 0, 26.00, 'delivered'),
(4, 'Living Room', 'LR-002-M4', 1, 18.00, 'delivered'),
(4, 'Living Room', 'LR-003-M4', 0, 24.00, 'delivered'),
(4, 'Master Bedroom', 'MB-001-M4', 0, 29.00, 'loaded'),
(4, 'Master Bedroom', 'MB-002-M4', 0, 27.00, 'loaded'),
(4, 'Kitchen', 'KIT-001-M4', 1, 31.00, 'loaded'),
(4, 'Kitchen', 'KIT-002-M4', 1, 24.00, 'packed'),
(4, 'Kitchen', 'KIT-003-M4', 1, 26.00, 'packed'),
(4, 'Kitchen', 'KIT-004-M4', 1, 25.00, 'packed'),
(4, 'Bathroom 1', 'BA1-001-M4', 0, 17.00, 'packed'),
(4, 'Guest Room', 'GR-001-M4', 0, 28.00, 'packed'),
(4, 'Guest Room', 'GR-002-M4', 0, 26.00, 'packed'),
(4, 'Study', 'STU-001-M4', 0, 34.00, 'packed'),
(4, 'Study', 'STU-002-M4', 0, 32.00, 'packed'),

-- Move 5 boxes (12 boxes)
(5, 'Entry Hall', 'ENT-001-M5', 0, 19.00, 'loaded'),
(5, 'Family Room', 'FAM-001-M5', 0, 32.00, 'loaded'),
(5, 'Family Room', 'FAM-002-M5', 0, 30.00, 'loaded'),
(5, 'Kitchen', 'KIT-001-M5', 1, 29.00, 'loaded'),
(5, 'Kitchen', 'KIT-002-M5', 1, 27.00, 'loaded'),
(5, 'Master Suite', 'MS-001-M5', 0, 27.00, 'packed'),
(5, 'Master Suite', 'MS-002-M5', 0, 25.00, 'packed'),
(5, 'Kids Room 1', 'KR1-001-M5', 0, 22.00, 'packed'),
(5, 'Kids Room 2', 'KR2-001-M5', 0, 23.00, 'packed'),
(5, 'Playroom', 'PLAY-001-M5', 0, 26.00, 'packed'),
(5, 'Home Theater', 'HT-001-M5', 1, 45.00, 'packed'),
(5, 'Wine Cellar', 'WC-001-M5', 1, 38.00, 'packed'),

-- Move 6 boxes (11 boxes)
(6, 'Main Storage', 'MS-001-M6', 0, 36.00, 'packed'),
(6, 'Main Storage', 'MS-002-M6', 0, 34.00, 'packed'),
(6, 'Furniture Area', 'FA-001-M6', 0, 58.00, 'packed'),
(6, 'Boxes Section', 'BS-001-M6', 0, 25.00, 'packed'),
(6, 'Boxes Section', 'BS-002-M6', 0, 27.00, 'packed'),
(6, 'Boxes Section', 'BS-003-M6', 0, 26.00, 'packed'),
(6, 'Electronics Storage', 'ES-001-M6', 1, 33.00, 'packed'),
(6, 'Seasonal Storage', 'SS-001-M6', 0, 28.00, 'packed'),
(6, 'Tool Storage', 'TS-001-M6', 0, 41.00, 'packed'),
(6, 'Tool Storage', 'TS-002-M6', 0, 39.00, 'packed'),
(6, 'Fragile Items', 'FI-001-M6', 1, 19.00, 'packed'),

-- Move 7 boxes (10 boxes)
(7, 'Great Room', 'GR-001-M7', 0, 30.00, 'empty'),
(7, 'Great Room', 'GR-002-M7', 0, 28.00, 'empty'),
(7, 'Master Bedroom', 'MB-001-M7', 0, 25.00, 'empty'),
(7, 'Kitchen', 'KIT-001-M7', 1, 28.00, 'empty'),
(7, 'Kitchen', 'KIT-002-M7', 1, 26.00, 'empty'),
(7, 'Den', 'DEN-001-M7', 0, 32.00, 'empty'),
(7, 'Guest Suite', 'GS-001-M7', 0, 24.00, 'empty'),
(7, 'Library', 'LIB-001-M7', 0, 42.00, 'empty'),
(7, 'Library', 'LIB-002-M7', 0, 40.00, 'empty'),
(7, 'Sun Room', 'SR-001-M7', 1, 21.00, 'empty'),

-- Move 8 boxes (11 boxes)
(8, 'Warehouse Floor A', 'WFA-001-M8', 0, 65.00, 'empty'),
(8, 'Warehouse Floor A', 'WFA-002-M8', 0, 62.00, 'empty'),
(8, 'Warehouse Floor B', 'WFB-001-M8', 0, 68.00, 'empty'),
(8, 'Office Section', 'OFF-001-M8', 0, 28.00, 'empty'),
(8, 'Loading Dock', 'LD-001-M8', 0, 55.00, 'empty'),
(8, 'Storage Bay 1', 'SB1-001-M8', 0, 48.00, 'empty'),
(8, 'Storage Bay 2', 'SB2-001-M8', 0, 51.00, 'empty'),
(8, 'Storage Bay 3', 'SB3-001-M8', 0, 49.00, 'empty'),
(8, 'Equipment Area', 'EA-001-M8', 1, 72.00, 'empty'),
(8, 'Shipping Area', 'SHA-001-M8', 0, 44.00, 'empty'),
(8, 'Receiving Area', 'RA-001-M8', 0, 46.00, 'empty'),

-- Move 9 boxes (10 boxes)
(9, 'Main Room', 'MR-001-M9', 0, 27.00, 'empty'),
(9, 'Main Room', 'MR-002-M9', 0, 25.00, 'empty'),
(9, 'Bedroom', 'BED-001-M9', 0, 24.00, 'empty'),
(9, 'Kitchenette', 'KITC-001-M9', 1, 20.00, 'empty'),
(9, 'Living Area', 'LA-001-M9', 0, 26.00, 'empty'),
(9, 'Living Area', 'LA-002-M9', 0, 24.00, 'empty'),
(9, 'Work Space', 'WS-001-M9', 0, 31.00, 'empty'),
(9, 'Storage Area', 'SA-001-M9', 0, 33.00, 'empty'),
(9, 'Storage Area', 'SA-002-M9', 0, 31.00, 'empty'),
(9, 'Closet', 'CLO-001-M9', 0, 19.00, 'empty'),

-- Move 10 boxes (12 boxes)
(10, 'Living Room', 'LR-001-M10', 0, 28.00, 'empty'),
(10, 'Living Room', 'LR-002-M10', 0, 26.00, 'empty'),
(10, 'Master Bedroom', 'MB-001-M10', 0, 26.00, 'empty'),
(10, 'Kitchen', 'KIT-001-M10', 1, 30.00, 'empty'),
(10, 'Kitchen', 'KIT-002-M10', 1, 28.00, 'empty'),
(10, 'Dining Room', 'DR-001-M10', 1, 23.00, 'empty'),
(10, 'Bedroom 2', 'B2-001-M10', 0, 24.00, 'empty'),
(10, 'Bedroom 3', 'B3-001-M10', 0, 25.00, 'empty'),
(10, 'Office', 'OFF-001-M10', 0, 32.00, 'empty'),
(10, 'Office', 'OFF-002-M10', 0, 30.00, 'empty'),
(10, 'Garage', 'GAR-001-M10', 0, 46.00, 'empty'),
(10, 'Backyard Shed', 'BYS-001-M10', 0, 39.00, 'empty'),

-- Move 11 boxes (13 boxes)
(11, 'Combined Storage A', 'CSA-001-M11', 0, 34.00, 'empty'),
(11, 'Combined Storage A', 'CSA-002-M11', 0, 32.00, 'empty'),
(11, 'Combined Storage B', 'CSB-001-M11', 0, 36.00, 'empty'),
(11, 'Combined Storage C', 'CSC-001-M11', 0, 38.00, 'empty'),
(11, 'Combined Storage D', 'CSD-001-M11', 0, 35.00, 'empty'),
(11, 'Small Items', 'SI-001-M11', 0, 18.00, 'empty'),
(11, 'Large Items', 'LI-001-M11', 0, 54.00, 'empty'),
(11, 'Furniture Mix', 'FM-001-M11', 0, 61.00, 'empty'),
(11, 'Boxes Area', 'BA-001-M11', 0, 29.00, 'empty'),
(11, 'Boxes Area', 'BA-002-M11', 0, 27.00, 'empty'),
(11, 'Overflow', 'OVF-001-M11', 0, 41.00, 'empty'),
(11, 'Archived Items', 'AI-001-M11', 0, 47.00, 'empty'),
(11, 'Misc Area', 'MA-001-M11', 0, 32.00, 'empty'),

-- Move 12 boxes (10 boxes)
(12, 'Living Room', 'LR-001-M12', 0, 27.00, 'unpacked'),
(12, 'Living Room', 'LR-002-M12', 0, 25.00, 'unpacked'),
(12, 'Master Bedroom', 'MB-001-M12', 0, 25.00, 'unpacked'),
(12, 'Kitchen', 'KIT-001-M12', 1, 29.00, 'unpacked'),
(12, 'Kitchen', 'KIT-002-M12', 1, 27.00, 'unpacked'),
(12, 'Kitchen', 'KIT-003-M12', 1, 26.00, 'unpacked'),
(12, 'Guest Bedroom', 'GB-001-M12', 0, 24.00, 'unpacked'),
(12, 'Office Nook', 'ON-001-M12', 0, 31.00, 'unpacked'),
(12, 'Dining Area', 'DA-001-M12', 1, 22.00, 'unpacked'),
(12, 'Storage Closet', 'SC-001-M12', 0, 26.00, 'unpacked'),

-- Move 13 boxes (12 boxes)
(13, 'Main Office', 'MO-001-M13', 0, 33.00, 'unpacked'),
(13, 'Main Office', 'MO-002-M13', 0, 31.00, 'unpacked'),
(13, 'Conference Room', 'CR-001-M13', 0, 28.00, 'unpacked'),
(13, 'Manager Office', 'MGR-001-M13', 0, 30.00, 'unpacked'),
(13, 'Manager Office', 'MGR-002-M13', 0, 28.00, 'unpacked'),
(13, 'Storage', 'STOR-001-M13', 0, 38.00, 'unpacked'),
(13, 'Storage', 'STOR-002-M13', 0, 36.00, 'unpacked'),
(13, 'Tech Room', 'TECH-001-M13', 1, 42.00, 'unpacked'),
(13, 'Meeting Room', 'MR-001-M13', 0, 26.00, 'unpacked'),
(13, 'Copy Area', 'CA-001-M13', 0, 25.00, 'unpacked'),
(13, 'Kitchen', 'KIT-001-M13', 0, 22.00, 'unpacked'),
(13, 'Server Room', 'SRV-001-M13', 1, 56.00, 'unpacked'),

-- Move 14 boxes (11 boxes)
(14, 'Storage A', 'SA-001-M14', 0, 35.00, 'unpacked'),
(14, 'Storage B', 'SB-001-M14', 0, 37.00, 'unpacked'),
(14, 'Storage C', 'SC-001-M14', 0, 36.00, 'unpacked'),
(14, 'Storage D', 'SD-001-M14', 0, 38.00, 'unpacked'),
(14, 'Furniture Bay', 'FB-001-M14', 0, 59.00, 'unpacked'),
(14, 'Box Bay', 'BB-001-M14', 0, 31.00, 'unpacked'),
(14, 'Box Bay', 'BB-002-M14', 0, 29.00, 'unpacked'),
(14, 'Equipment Bay', 'EB-001-M14', 1, 47.00, 'unpacked'),
(14, 'Seasonal Bay', 'SB2-001-M14', 0, 29.00, 'unpacked'),
(14, 'Archive Bay', 'AB-001-M14', 0, 43.00, 'unpacked'),
(14, 'Overflow Bay', 'OB-001-M14', 0, 40.00, 'unpacked'),

-- Move 15 boxes (13 boxes)
(15, 'Great Room', 'GR-001-M15', 1, 32.00, 'delivered'),
(15, 'Great Room', 'GR-002-M15', 0, 30.00, 'delivered'),
(15, 'Master Suite', 'MS-001-M15', 0, 28.00, 'delivered'),
(15, 'Master Suite', 'MS-002-M15', 0, 26.00, 'delivered'),
(15, 'Gourmet Kitchen', 'GK-001-M15', 1, 34.00, 'loaded'),
(15, 'Gourmet Kitchen', 'GK-002-M15', 1, 32.00, 'loaded'),
(15, 'Library', 'LIB-001-M15', 0, 45.00, 'loaded'),
(15, 'Guest Suite 1', 'GS1-001-M15', 0, 26.00, 'packed'),
(15, 'Home Office', 'HO-001-M15', 0, 35.00, 'packed'),
(15, 'Home Office', 'HO-002-M15', 0, 33.00, 'packed'),
(15, 'Media Room', 'MR-001-M15', 1, 48.00, 'packed'),
(15, 'Wine Room', 'WR-001-M15', 1, 41.00, 'packed'),
(15, 'Gym', 'GYM-001-M15', 0, 53.00, 'packed'),

-- Move 16 boxes (11 boxes)
(16, 'Main Living', 'ML-001-M16', 0, 29.00, 'loaded'),
(16, 'Main Living', 'ML-002-M16', 0, 27.00, 'loaded'),
(16, 'Bedroom 1', 'B1-001-M16', 0, 25.00, 'loaded'),
(16, 'Bedroom 2', 'B2-001-M16', 0, 26.00, 'packed'),
(16, 'Kitchen', 'KIT-001-M16', 1, 30.00, 'packed'),
(16, 'Kitchen', 'KIT-002-M16', 1, 28.00, 'packed'),
(16, 'Office Space', 'OS-001-M16', 0, 33.00, 'packed'),
(16, 'Storage Room', 'SR-001-M16', 0, 39.00, 'packed'),
(16, 'Storage Room', 'SR-002-M16', 0, 37.00, 'packed'),
(16, 'Dining Room', 'DR-001-M16', 1, 24.00, 'packed'),
(16, 'Entry', 'ENT-001-M16', 0, 19.00, 'empty'),

-- Move 17 boxes (10 boxes)
(17, 'Main Office Space', 'MOS-001-M17', 0, 34.00, 'packed'),
(17, 'Main Office Space', 'MOS-002-M17', 0, 32.00, 'packed'),
(17, 'Executive Suite', 'ES-001-M17', 0, 31.00, 'packed'),
(17, 'Conference A', 'CA-001-M17', 0, 27.00, 'packed'),
(17, 'Conference B', 'CB-001-M17', 0, 28.00, 'packed'),
(17, 'Break Room', 'BR-001-M17', 0, 23.00, 'packed'),
(17, 'IT Department', 'IT-001-M17', 1, 44.00, 'packed'),
(17, 'IT Department', 'IT-002-M17', 1, 42.00, 'packed'),
(17, 'Reception Area', 'RA-001-M17', 0, 25.00, 'packed'),
(17, 'Server Area', 'SA2-001-M17', 1, 58.00, 'empty'),

-- Move 18 boxes (10 boxes)
(18, 'Main House', 'MH-001-M18', 0, 30.00, 'empty'),
(18, 'Main House', 'MH-002-M18', 0, 28.00, 'empty'),
(18, 'Bedroom', 'BED-001-M18', 0, 25.00, 'empty'),
(18, 'Kitchen', 'KIT-001-M18', 1, 28.00, 'empty'),
(18, 'Kitchen', 'KIT-002-M18', 1, 26.00, 'empty'),
(18, 'Living Room', 'LR-001-M18', 0, 32.00, 'empty'),
(18, 'Den', 'DEN-001-M18', 0, 27.00, 'empty'),
(18, 'Garage', 'GAR-001-M18', 0, 45.00, 'empty'),
(18, 'Basement', 'BASE-001-M18', 0, 42.00, 'empty'),
(18, 'Shed', 'SHED-001-M18', 0, 38.00, 'empty'),

-- Move 19 boxes (11 boxes)
(19, 'Trading Floor', 'TF-001-M19', 0, 36.00, 'empty'),
(19, 'Trading Floor', 'TF-002-M19', 0, 34.00, 'empty'),
(19, 'Private Office 1', 'PO1-001-M19', 0, 29.00, 'empty'),
(19, 'Private Office 2', 'PO2-001-M19', 0, 30.00, 'empty'),
(19, 'Meeting Room', 'MR-001-M19', 0, 26.00, 'empty'),
(19, 'Conference Suite', 'CS-001-M19', 0, 31.00, 'empty'),
(19, 'Storage', 'STOR-001-M19', 0, 37.00, 'empty'),
(19, 'Storage', 'STOR-002-M19', 0, 35.00, 'empty'),
(19, 'Tech Center', 'TC-001-M19', 1, 46.00, 'empty'),
(19, 'Kitchen', 'KIT-001-M19', 0, 23.00, 'empty'),
(19, 'Executive Area', 'EA-001-M19', 0, 33.00, 'empty'),

-- Move 20 boxes (12 boxes)
(20, 'Temp Storage 1', 'TS1-001-M20', 0, 34.00, 'empty'),
(20, 'Temp Storage 2', 'TS2-001-M20', 0, 35.00, 'empty'),
(20, 'Temp Storage 3', 'TS3-001-M20', 0, 36.00, 'empty'),
(20, 'Temp Storage 4', 'TS4-001-M20', 0, 37.00, 'empty'),
(20, 'Box Area', 'BA-001-M20', 0, 28.00, 'empty'),
(20, 'Box Area', 'BA-002-M20', 0, 26.00, 'empty'),
(20, 'Furniture Area', 'FA-001-M20', 0, 57.00, 'empty'),
(20, 'Equipment Area', 'EA-001-M20', 1, 44.00, 'empty'),
(20, 'Archive Area', 'AA-001-M20', 0, 41.00, 'empty'),
(20, 'Seasonal Area', 'SA-001-M20', 0, 30.00, 'empty'),
(20, 'Overflow Area', 'OA-001-M20', 0, 39.00, 'empty'),
(20, 'Misc Area', 'MA-001-M20', 0, 32.00, 'empty'),

-- Move 21 boxes (10 boxes)
(21, 'Apartment Living', 'AL-001-M21', 0, 28.00, 'empty'),
(21, 'Master Bedroom', 'MB-001-M21', 0, 26.00, 'empty'),
(21, 'Second Bedroom', 'SB-001-M21', 0, 24.00, 'empty'),
(21, 'Kitchen', 'KIT-001-M21', 1, 29.00, 'empty'),
(21, 'Kitchen', 'KIT-002-M21', 1, 27.00, 'empty'),
(21, 'Dining Area', 'DA-001-M21', 1, 23.00, 'empty'),
(21, 'Office', 'OFF-001-M21', 0, 32.00, 'empty'),
(21, 'Office', 'OFF-002-M21', 0, 30.00, 'empty'),
(21, 'Storage', 'STOR-001-M21', 0, 35.00, 'empty'),
(21, 'Laundry', 'LAU-001-M21', 0, 20.00, 'empty'),

-- Move 22 boxes (11 boxes)
(22, 'Open Workspace', 'OW-001-M22', 0, 33.00, 'empty'),
(22, 'Open Workspace', 'OW-002-M22', 0, 31.00, 'empty'),
(22, 'Private Office', 'PO-001-M22', 0, 30.00, 'empty'),
(22, 'Meeting Pod 1', 'MP1-001-M22', 0, 24.00, 'empty'),
(22, 'Meeting Pod 2', 'MP2-001-M22', 0, 25.00, 'empty'),
(22, 'Lounge Area', 'LA-001-M22', 0, 27.00, 'empty'),
(22, 'Storage', 'STOR-001-M22', 0, 36.00, 'empty'),
(22, 'Reception', 'REC-001-M22', 0, 23.00, 'empty'),
(22, 'Conference Room', 'CR-001-M22', 0, 28.00, 'empty'),
(22, 'Conference Room', 'CR-002-M22', 0, 26.00, 'empty'),
(22, 'Tech Hub', 'TH-001-M22', 1, 43.00, 'empty'),

-- Move 23 boxes (10 boxes)
(23, 'Living Area', 'LA-001-M23', 0, 27.00, 'unpacked'),
(23, 'Living Area', 'LA-002-M23', 0, 25.00, 'unpacked'),
(23, 'Bedroom', 'BED-001-M23', 0, 24.00, 'unpacked'),
(23, 'Kitchen', 'KIT-001-M23', 1, 28.00, 'unpacked'),
(23, 'Kitchen', 'KIT-002-M23', 1, 26.00, 'unpacked'),
(23, 'Office Corner', 'OC-001-M23', 0, 31.00, 'unpacked'),
(23, 'Dining Space', 'DS-001-M23', 1, 22.00, 'unpacked'),
(23, 'Storage', 'STOR-001-M23', 0, 33.00, 'unpacked'),
(23, 'Storage', 'STOR-002-M23', 0, 31.00, 'unpacked'),
(23, 'Closet', 'CLO-001-M23', 0, 19.00, 'unpacked'),

-- Move 24 boxes (11 boxes)
(24, 'Main Office', 'MO-001-M24', 0, 32.00, 'unpacked'),
(24, 'Main Office', 'MO-002-M24', 0, 30.00, 'unpacked'),
(24, 'Conference Room', 'CR-001-M24', 0, 27.00, 'unpacked'),
(24, 'Storage Room', 'SR-001-M24', 0, 38.00, 'unpacked'),
(24, 'Storage Room', 'SR-002-M24', 0, 36.00, 'unpacked'),
(24, 'Manager Office', 'MGR-001-M24', 0, 29.00, 'unpacked'),
(24, 'Open Space', 'OS-001-M24', 0, 34.00, 'unpacked'),
(24, 'Kitchen', 'KIT-001-M24', 0, 23.00, 'unpacked'),
(24, 'Meeting Room', 'MR-001-M24', 0, 26.00, 'unpacked'),
(24, 'Tech Room', 'TR-001-M24', 1, 41.00, 'unpacked'),
(24, 'Copy Area', 'CA-001-M24', 0, 25.00, 'unpacked'),

-- Move 25 boxes (12 boxes)
(25, 'Storage Section A', 'SSA-001-M25', 0, 35.00, 'unpacked'),
(25, 'Storage Section B', 'SSB-001-M25', 0, 36.00, 'unpacked'),
(25, 'Storage Section C', 'SSC-001-M25', 0, 37.00, 'unpacked'),
(25, 'Storage Section D', 'SSD-001-M25', 0, 38.00, 'unpacked'),
(25, 'Boxes', 'BOX-001-M25', 0, 29.00, 'unpacked'),
(25, 'Boxes', 'BOX-002-M25', 0, 27.00, 'unpacked'),
(25, 'Furniture', 'FURN-001-M25', 0, 58.00, 'unpacked'),
(25, 'Equipment', 'EQUIP-001-M25', 1, 45.00, 'unpacked'),
(25, 'Seasonal', 'SEAS-001-M25', 0, 31.00, 'unpacked'),
(25, 'Archive', 'ARCH-001-M25', 0, 42.00, 'unpacked'),
(25, 'Overflow', 'OVF-001-M25', 0, 40.00, 'unpacked'),
(25, 'Misc', 'MISC-001-M25', 0, 33.00, 'unpacked'),

-- Move 26 boxes (11 boxes)
(26, 'Loft Living', 'LL-001-M26', 0, 30.00, 'delivered'),
(26, 'Loft Living', 'LL-002-M26', 0, 28.00, 'delivered'),
(26, 'Bedroom Area', 'BA-001-M26', 0, 26.00, 'delivered'),
(26, 'Kitchen', 'KIT-001-M26', 1, 29.00, 'loaded'),
(26, 'Kitchen', 'KIT-002-M26', 1, 27.00, 'loaded'),
(26, 'Office Space', 'OS-001-M26', 0, 33.00, 'packed'),
(26, 'Dining Area', 'DA-001-M26', 1, 24.00, 'packed'),
(26, 'Storage', 'STOR-001-M26', 0, 37.00, 'packed'),
(26, 'Storage', 'STOR-002-M26', 0, 35.00, 'packed'),
(26, 'Closet Space', 'CS-001-M26', 0, 21.00, 'packed'),
(26, 'Utility', 'UTI-001-M26', 0, 20.00, 'packed'),

-- Move 27 boxes (10 boxes)
(27, 'Studio Main', 'SM-001-M27', 0, 32.00, 'loaded'),
(27, 'Work Area', 'WA-001-M27', 0, 34.00, 'loaded'),
(27, 'Work Area', 'WA-002-M27', 0, 32.00, 'loaded'),
(27, 'Storage Area', 'SA-001-M27', 0, 36.00, 'packed'),
(27, 'Equipment Corner', 'EC-001-M27', 1, 43.00, 'packed'),
(27, 'Display Area', 'DA2-001-M27', 1, 25.00, 'packed'),
(27, 'Office Space', 'OS2-001-M27', 0, 30.00, 'packed'),
(27, 'Kitchen', 'KIT-001-M27', 0, 22.00, 'packed'),
(27, 'Storage Closet', 'SC-001-M27', 0, 27.00, 'empty'),
(27, 'Back Room', 'BR2-001-M27', 0, 31.00, 'empty'),

-- Move 28 boxes (11 boxes)
(28, 'Beach Living', 'BL-001-M28', 0, 28.00, 'packed'),
(28, 'Beach Living', 'BL-002-M28', 0, 26.00, 'packed'),
(28, 'Master Bedroom', 'MB-001-M28', 0, 25.00, 'packed'),
(28, 'Guest Bedroom', 'GB-001-M28', 0, 24.00, 'packed'),
(28, 'Kitchen', 'KIT-001-M28', 1, 27.00, 'packed'),
(28, 'Kitchen', 'KIT-002-M28', 1, 25.00, 'packed'),
(28, 'Dining', 'DIN-001-M28', 1, 23.00, 'packed'),
(28, 'Deck Storage', 'DS2-001-M28', 0, 34.00, 'empty'),
(28, 'Garage', 'GAR-001-M28', 0, 44.00, 'empty'),
(28, 'Garage', 'GAR-002-M28', 0, 42.00, 'empty'),
(28, 'Laundry', 'LAU-001-M28', 0, 19.00, 'empty'),

-- Move 29 boxes (10 boxes)
(29, 'Workshop Main', 'WM-001-M29', 0, 38.00, 'empty'),
(29, 'Tool Area', 'TA-001-M29', 0, 42.00, 'empty'),
(29, 'Tool Area', 'TA-002-M29', 0, 40.00, 'empty'),
(29, 'Work Benches', 'WB-001-M29', 0, 51.00, 'empty'),
(29, 'Storage Bay', 'SB3-001-M29', 0, 39.00, 'empty'),
(29, 'Equipment Area', 'EA2-001-M29', 1, 46.00, 'empty'),
(29, 'Parts Storage', 'PS2-001-M29', 0, 35.00, 'empty'),
(29, 'Office', 'OFF2-001-M29', 0, 28.00, 'empty'),
(29, 'Supply Room', 'SR2-001-M29', 0, 33.00, 'empty'),
(29, 'Loading Area', 'LA2-001-M29', 0, 47.00, 'empty'),

-- Move 30 boxes (11 boxes)
(30, 'Apartment Main', 'AM-001-M30', 0, 27.00, 'empty'),
(30, 'Apartment Main', 'AM-002-M30', 0, 25.00, 'empty'),
(30, 'Bedroom', 'BED2-001-M30', 0, 24.00, 'empty'),
(30, 'Kitchen', 'KIT2-001-M30', 1, 28.00, 'empty'),
(30, 'Kitchen', 'KIT2-002-M30', 1, 26.00, 'empty'),
(30, 'Living Room', 'LR2-001-M30', 0, 31.00, 'empty'),
(30, 'Office', 'OFF3-001-M30', 0, 32.00, 'empty'),
(30, 'Dining Area', 'DA3-001-M30', 1, 23.00, 'empty'),
(30, 'Storage', 'STOR2-001-M30', 0, 35.00, 'empty'),
(30, 'Laundry', 'LAU2-001-M30', 0, 19.00, 'empty'),
(30, 'Closet', 'CLO2-001-M30', 0, 20.00, 'empty'),

-- Move 31 boxes (10 boxes)
(31, 'Castro Living', 'CL-001-M31', 0, 29.00, 'empty'),
(31, 'Bedroom 1', 'B1-001-M31', 0, 25.00, 'empty'),
(31, 'Bedroom 2', 'B2-001-M31', 0, 26.00, 'empty'),
(31, 'Kitchen', 'KIT3-001-M31', 1, 30.00, 'empty'),
(31, 'Kitchen', 'KIT3-002-M31', 1, 28.00, 'empty'),
(31, 'Office', 'OFF4-001-M31', 0, 33.00, 'empty'),
(31, 'Office', 'OFF4-002-M31', 0, 31.00, 'empty'),
(31, 'Dining Room', 'DR2-001-M31', 1, 24.00, 'empty'),
(31, 'Storage', 'STOR3-001-M31', 0, 36.00, 'empty'),
(31, 'Laundry', 'LAU3-001-M31', 0, 20.00, 'empty'),

-- Move 32 boxes (11 boxes)
(32, 'Condo Main', 'CM-001-M32', 0, 31.00, 'empty'),
(32, 'Master Suite', 'MS2-001-M32', 0, 28.00, 'empty'),
(32, 'Guest Room', 'GR2-001-M32', 0, 25.00, 'empty'),
(32, 'Kitchen', 'KIT4-001-M32', 1, 32.00, 'empty'),
(32, 'Kitchen', 'KIT4-002-M32', 1, 30.00, 'empty'),
(32, 'Living Room', 'LR3-001-M32', 0, 34.00, 'empty'),
(32, 'Dining Room', 'DR3-001-M32', 1, 26.00, 'empty'),
(32, 'Office', 'OFF5-001-M32', 0, 35.00, 'empty'),
(32, 'Office', 'OFF5-002-M32', 0, 33.00, 'empty'),
(32, 'Storage', 'STOR4-001-M32', 0, 38.00, 'empty'),
(32, 'Balcony', 'BAL3-001-M32', 0, 24.00, 'empty'),

-- Move 33 boxes (12 boxes)
(33, 'Shared Office A', 'SOA-001-M33', 0, 33.00, 'empty'),
(33, 'Shared Office A', 'SOA-002-M33', 0, 31.00, 'empty'),
(33, 'Shared Office B', 'SOB-001-M33', 0, 34.00, 'empty'),
(33, 'Meeting Room', 'MR2-001-M33', 0, 27.00, 'empty'),
(33, 'Break Area', 'BA2-001-M33', 0, 22.00, 'empty'),
(33, 'Kitchen', 'KIT5-001-M33', 0, 23.00, 'empty'),
(33, 'Reception', 'REC2-001-M33', 0, 24.00, 'empty'),
(33, 'Conference', 'CONF2-001-M33', 0, 28.00, 'empty'),
(33, 'Storage', 'STOR5-001-M33', 0, 37.00, 'empty'),
(33, 'Storage', 'STOR5-002-M33', 0, 35.00, 'empty'),
(33, 'Lounge', 'LOU-001-M33', 0, 26.00, 'empty'),
(33, 'Tech Area', 'TA2-001-M33', 1, 42.00, 'empty'),

-- Move 34 boxes (11 boxes)
(34, 'Living Room', 'LR4-001-M34', 0, 28.00, 'unpacked'),
(34, 'Living Room', 'LR4-002-M34', 0, 26.00, 'unpacked'),
(34, 'Master Bedroom', 'MB2-001-M34', 0, 26.00, 'unpacked'),
(34, 'Kitchen', 'KIT6-001-M34', 1, 30.00, 'unpacked'),
(34, 'Kitchen', 'KIT6-002-M34', 1, 28.00, 'unpacked'),
(34, 'Guest Bedroom', 'GB2-001-M34', 0, 25.00, 'unpacked'),
(34, 'Office', 'OFF6-001-M34', 0, 33.00, 'unpacked'),
(34, 'Dining Area', 'DA4-001-M34', 1, 24.00, 'unpacked'),
(34, 'Storage', 'STOR6-001-M34', 0, 36.00, 'unpacked'),
(34, 'Storage', 'STOR6-002-M34', 0, 34.00, 'unpacked'),
(34, 'Laundry', 'LAU4-001-M34', 0, 20.00, 'unpacked'),

-- Move 35 boxes (12 boxes)
(35, 'Main Office', 'MO2-001-M35', 0, 34.00, 'unpacked'),
(35, 'Main Office', 'MO2-002-M35', 0, 32.00, 'unpacked'),
(35, 'Conference Room', 'CR2-001-M35', 0, 28.00, 'unpacked'),
(35, 'Manager Suite', 'MS3-001-M35', 0, 31.00, 'unpacked'),
(35, 'Manager Suite', 'MS3-002-M35', 0, 29.00, 'unpacked'),
(35, 'Reception', 'REC3-001-M35', 0, 25.00, 'unpacked'),
(35, 'Meeting Room A', 'MRA2-001-M35', 0, 27.00, 'unpacked'),
(35, 'Meeting Room B', 'MRB2-001-M35', 0, 27.00, 'unpacked'),
(35, 'Storage', 'STOR7-001-M35', 0, 39.00, 'unpacked'),
(35, 'Kitchen', 'KIT7-001-M35', 0, 23.00, 'unpacked'),
(35, 'Copy Room', 'COPY2-001-M35', 0, 26.00, 'unpacked'),
(35, 'Server Room', 'SRV2-001-M35', 1, 57.00, 'unpacked'),

-- Move 36 boxes (13 boxes)
(36, 'Self Storage A', 'SSA2-001-M36', 0, 35.00, 'unpacked'),
(36, 'Self Storage A', 'SSA2-002-M36', 0, 33.00, 'unpacked'),
(36, 'Self Storage B', 'SSB2-001-M36', 0, 36.00, 'unpacked'),
(36, 'Self Storage C', 'SSC2-001-M36', 0, 37.00, 'unpacked'),
(36, 'Self Storage D', 'SSD2-001-M36', 0, 38.00, 'unpacked'),
(36, 'Box Storage', 'BS3-001-M36', 0, 30.00, 'unpacked'),
(36, 'Box Storage', 'BS3-002-M36', 0, 28.00, 'unpacked'),
(36, 'Furniture Storage', 'FS-001-M36', 0, 59.00, 'unpacked'),
(36, 'Equipment Storage', 'ES2-001-M36', 1, 46.00, 'unpacked'),
(36, 'Seasonal Storage', 'SS2-001-M36', 0, 32.00, 'unpacked'),
(36, 'Archive Storage', 'AS2-001-M36', 0, 43.00, 'unpacked'),
(36, 'Overflow Storage', 'OS3-001-M36', 0, 41.00, 'unpacked'),
(36, 'Misc Storage', 'MS4-001-M36', 0, 34.00, 'unpacked'),

-- Move 37 boxes (11 boxes)
(37, 'Apartment Living', 'AL2-001-M37', 0, 29.00, 'delivered'),
(37, 'Apartment Living', 'AL2-002-M37', 0, 27.00, 'delivered'),
(37, 'Master Bedroom', 'MB3-001-M37', 0, 27.00, 'delivered'),
(37, 'Second Bedroom', 'SB2-001-M37', 0, 25.00, 'loaded'),
(37, 'Kitchen', 'KIT8-001-M37', 1, 31.00, 'loaded'),
(37, 'Kitchen', 'KIT8-002-M37', 1, 29.00, 'loaded'),
(37, 'Living Area', 'LA3-001-M37', 0, 32.00, 'packed'),
(37, 'Dining Area', 'DA5-001-M37', 1, 24.00, 'packed'),
(37, 'Office', 'OFF7-001-M37', 0, 34.00, 'packed'),
(37, 'Storage', 'STOR8-001-M37', 0, 37.00, 'empty'),
(37, 'Laundry', 'LAU5-001-M37', 0, 20.00, 'empty'),

-- Move 38 boxes (10 boxes)
(38, 'Sister House Living', 'SHL-001-M38', 0, 30.00, 'loaded'),
(38, 'Bedroom 1', 'B1-001-M38', 0, 26.00, 'loaded'),
(38, 'Bedroom 2', 'B2-001-M38', 0, 27.00, 'packed'),
(38, 'Kitchen', 'KIT9-001-M38', 1, 29.00, 'packed'),
(38, 'Kitchen', 'KIT9-002-M38', 1, 27.00, 'packed'),
(38, 'Dining Room', 'DR4-001-M38', 1, 25.00, 'packed'),
(38, 'Office', 'OFF8-001-M38', 0, 33.00, 'packed'),
(38, 'Storage', 'STOR9-001-M38', 0, 38.00, 'empty'),
(38, 'Garage', 'GAR2-001-M38', 0, 45.00, 'empty'),
(38, 'Basement', 'BASE2-001-M38', 0, 42.00, 'empty'),

-- Move 39 boxes (11 boxes)
(39, 'Cabin Main', 'CM2-001-M39', 0, 28.00, 'packed'),
(39, 'Cabin Main', 'CM2-002-M39', 0, 26.00, 'packed'),
(39, 'Bedroom 1', 'B1-001-M39', 0, 24.00, 'packed'),
(39, 'Bedroom 2', 'B2-001-M39', 0, 25.00, 'packed'),
(39, 'Kitchen', 'KIT10-001-M39', 1, 27.00, 'packed'),
(39, 'Kitchen', 'KIT10-002-M39', 1, 25.00, 'packed'),
(39, 'Living Area', 'LA4-001-M39', 0, 31.00, 'packed'),
(39, 'Storage Room', 'SR3-001-M39', 0, 35.00, 'empty'),
(39, 'Porch Storage', 'PS3-001-M39', 0, 33.00, 'empty'),
(39, 'Shed', 'SHED2-001-M39', 0, 39.00, 'empty'),
(39, 'Loft Area', 'LA5-001-M39', 0, 26.00, 'empty'),

-- Move 40 boxes (10 boxes)
(40, 'Business Suite', 'BS4-001-M40', 0, 32.00, 'empty'),
(40, 'Private Office 1', 'PO1-001-M40', 0, 29.00, 'empty'),
(40, 'Private Office 2', 'PO2-001-M40', 0, 30.00, 'empty'),
(40, 'Conference Room', 'CR3-001-M40', 0, 27.00, 'empty'),
(40, 'Conference Room', 'CR3-002-M40', 0, 25.00, 'empty'),
(40, 'Reception', 'REC4-001-M40', 0, 24.00, 'empty'),
(40, 'Storage', 'STOR10-001-M40', 0, 38.00, 'empty'),
(40, 'Meeting Room', 'MR3-001-M40', 0, 26.00, 'empty'),
(40, 'Copy Area', 'CA2-001-M40', 0, 25.00, 'empty'),
(40, 'Server Room', 'SRV3-001-M40', 1, 56.00, 'empty'),

-- Move 41 boxes (11 boxes)
(41, 'Sheridan Living', 'SL-001-M41', 0, 30.00, 'empty'),
(41, 'Sheridan Living', 'SL-002-M41', 0, 28.00, 'empty'),
(41, 'Master Bedroom', 'MB4-001-M41', 0, 27.00, 'empty'),
(41, 'Guest Bedroom', 'GB3-001-M41', 0, 25.00, 'empty'),
(41, 'Kitchen', 'KIT12-001-M41', 1, 31.00, 'empty'),
(41, 'Kitchen', 'KIT12-002-M41', 1, 29.00, 'empty'),
(41, 'Dining Room', 'DR5-001-M41', 1, 25.00, 'empty'),
(41, 'Living Room', 'LR5-001-M41', 0, 33.00, 'empty'),
(41, 'Office', 'OFF9-001-M41', 0, 34.00, 'empty'),
(41, 'Storage', 'STOR11-001-M41', 0, 37.00, 'empty'),
(41, 'Balcony', 'BAL5-001-M41', 0, 23.00, 'empty'),

-- Move 42 boxes (12 boxes)
(42, 'Garage Main', 'GM-001-M42', 0, 48.00, 'empty'),
(42, 'Garage Bay 1', 'GB1-001-M42', 0, 52.00, 'empty'),
(42, 'Garage Bay 1', 'GB1-002-M42', 0, 50.00, 'empty'),
(42, 'Garage Bay 2', 'GB2-001-M42', 0, 53.00, 'empty'),
(42, 'Tool Area', 'TA3-001-M42', 0, 43.00, 'empty'),
(42, 'Storage Shelves', 'SS3-001-M42', 0, 38.00, 'empty'),
(42, 'Equipment Corner', 'EC2-001-M42', 1, 46.00, 'empty'),
(42, 'Work Bench', 'WB2-001-M42', 0, 50.00, 'empty'),
(42, 'Parts Storage', 'PS4-001-M42', 0, 36.00, 'empty'),
(42, 'Overflow Area', 'OA2-001-M42', 0, 42.00, 'empty'),
(42, 'Bike Storage', 'BS5-001-M42', 0, 29.00, 'empty'),
(42, 'Garden Storage', 'GS-001-M42', 0, 34.00, 'empty'),

-- Move 43 boxes (10 boxes)
(43, 'Diversey Living', 'DL-001-M43', 0, 28.00, 'empty'),
(43, 'Bedroom', 'BED3-001-M43', 0, 25.00, 'empty'),
(43, 'Kitchen', 'KIT13-001-M43', 1, 29.00, 'empty'),
(43, 'Kitchen', 'KIT13-002-M43', 1, 27.00, 'empty'),
(43, 'Living Area', 'LA6-001-M43', 0, 31.00, 'empty'),
(43, 'Dining Space', 'DS3-001-M43', 1, 23.00, 'empty'),
(43, 'Office', 'OFF10-001-M43', 0, 32.00, 'empty'),
(43, 'Storage', 'STOR12-001-M43', 0, 36.00, 'empty'),
(43, 'Storage', 'STOR12-002-M43', 0, 34.00, 'empty'),
(43, 'Laundry', 'LAU6-001-M43', 0, 20.00, 'empty'),

-- Move 44 boxes (11 boxes)
(44, 'Remote Office Main', 'ROM-001-M44', 0, 33.00, 'empty'),
(44, 'Remote Office Main', 'ROM-002-M44', 0, 31.00, 'empty'),
(44, 'Meeting Room', 'MR4-001-M44', 0, 27.00, 'empty'),
(44, 'Private Office', 'PO3-001-M44', 0, 30.00, 'empty'),
(44, 'Open Workspace', 'OW2-001-M44', 0, 35.00, 'empty'),
(44, 'Open Workspace', 'OW2-002-M44', 0, 33.00, 'empty'),
(44, 'Storage', 'STOR13-001-M44', 0, 38.00, 'empty'),
(44, 'Conference Room', 'CR4-001-M44', 0, 28.00, 'empty'),
(44, 'Reception', 'REC5-001-M44', 0, 24.00, 'empty'),
(44, 'Tech Hub', 'TH2-001-M44', 1, 44.00, 'empty'),
(44, 'Tech Hub', 'TH2-002-M44', 1, 42.00, 'empty'),

-- Move 45 boxes (11 boxes)
(45, 'Loft Living', 'LL2-001-M45', 0, 29.00, 'unpacked'),
(45, 'Loft Living', 'LL2-002-M45', 0, 27.00, 'unpacked'),
(45, 'Master Bedroom', 'MB5-001-M45', 0, 27.00, 'unpacked'),
(45, 'Kitchen', 'KIT15-001-M45', 1, 30.00, 'unpacked'),
(45, 'Kitchen', 'KIT15-002-M45', 1, 28.00, 'unpacked'),
(45, 'Guest Bedroom', 'GB4-001-M45', 0, 25.00, 'unpacked'),
(45, 'Office', 'OFF11-001-M45', 0, 33.00, 'unpacked'),
(45, 'Dining Area', 'DA6-001-M45', 1, 24.00, 'unpacked'),
(45, 'Storage', 'STOR14-001-M45', 0, 36.00, 'unpacked'),
(45, 'Storage', 'STOR14-002-M45', 0, 34.00, 'unpacked'),
(45, 'Laundry', 'LAU7-001-M45', 0, 20.00, 'unpacked'),
-- Move 46 boxes (12 boxes)
(46, 'Office Main', 'OM-001-M46', 0, 33.00, 'unpacked'),
(46, 'Office Main', 'OM-002-M46', 0, 31.00, 'unpacked'),
(46, 'Conference A', 'CA2-001-M46', 0, 28.00, 'unpacked'),
(46, 'Conference B', 'CB2-001-M46', 0, 29.00, 'unpacked'),
(46, 'Manager Office', 'MGR2-001-M46', 0, 30.00, 'unpacked'),
(46, 'Manager Office', 'MGR2-002-M46', 0, 28.00, 'unpacked'),
(46, 'Storage', 'STOR15-001-M46', 0, 38.00, 'unpacked'),
(46, 'Kitchen', 'KIT16-001-M46', 0, 23.00, 'unpacked'),
(46, 'Meeting Room', 'MR5-001-M46', 0, 26.00, 'unpacked'),
(46, 'Copy Center', 'CC2-001-M46', 0, 25.00, 'unpacked'),
(46, 'Server Room', 'SRV4-001-M46', 1, 57.00, 'unpacked'),
(46, 'Server Room', 'SRV4-002-M46', 1, 55.00, 'unpacked'),
-- Move 47 boxes (11 boxes)
(47, 'Storage Unit Main', 'SUM-001-M47', 0, 36.00, 'unpacked'),
(47, 'Box Area', 'BA2-001-M47', 0, 30.00, 'unpacked'),
(47, 'Box Area', 'BA2-002-M47', 0, 28.00, 'unpacked'),
(47, 'Furniture Area', 'FA2-001-M47', 0, 58.00, 'unpacked'),
(47, 'Equipment Area', 'EA3-001-M47', 1, 45.00, 'unpacked'),
(47, 'Seasonal Area', 'SA2-001-M47', 0, 31.00, 'unpacked'),
(47, 'Archive Area', 'AA2-001-M47', 0, 42.00, 'unpacked'),
(47, 'Overflow Area', 'OA3-001-M47', 0, 40.00, 'unpacked'),
(47, 'Heavy Items', 'HI-001-M47', 0, 63.00, 'unpacked'),
(47, 'Fragile Items', 'FI2-001-M47', 1, 22.00, 'unpacked'),
(47, 'Misc Area', 'MA2-001-M47', 0, 33.00, 'unpacked'),
-- Move 48 boxes (13 boxes)
(48, 'Spring Loft Main', 'SLM-001-M48', 0, 30.00, 'delivered'),
(48, 'Spring Loft Main', 'SLM-002-M48', 0, 28.00, 'delivered'),
(48, 'Master Suite', 'MS4-001-M48', 0, 27.00, 'delivered'),
(48, 'Second Bedroom', 'SB3-001-M48', 0, 25.00, 'loaded'),
(48, 'Kitchen', 'KIT17-001-M48', 1, 31.00, 'loaded'),
(48, 'Kitchen', 'KIT17-002-M48', 1, 29.00, 'loaded'),
(48, 'Living Room', 'LR6-001-M48', 0, 33.00, 'packed'),
(48, 'Dining Area', 'DA7-001-M48', 1, 24.00, 'packed'),
(48, 'Office Space', 'OS4-001-M48', 0, 34.00, 'packed'),
(48, 'Office Space', 'OS4-002-M48', 0, 32.00, 'packed'),
(48, 'Storage', 'STOR16-001-M48', 0, 37.00, 'packed'),
(48, 'Terrace', 'TER2-001-M48', 0, 26.00, 'empty'),
(48, 'Terrace', 'TER2-002-M48', 0, 24.00, 'empty'),
-- Move 49 boxes (11 boxes)
(49, 'Brother House Main', 'BHM-001-M49', 0, 31.00, 'loaded'),
(49, 'Brother House Main', 'BHM-002-M49', 0, 29.00, 'loaded'),
(49, 'Bedroom 1', 'B1-002-M49', 0, 26.00, 'packed'),
(49, 'Bedroom 2', 'B2-002-M49', 0, 27.00, 'packed'),
(49, 'Kitchen', 'KIT18-001-M49', 1, 30.00, 'packed'),
(49, 'Kitchen', 'KIT18-002-M49', 1, 28.00, 'packed'),
(49, 'Living Room', 'LR7-001-M49', 0, 33.00, 'packed'),
(49, 'Dining Room', 'DR6-001-M49', 1, 25.00, 'packed'),
(49, 'Office', 'OFF12-001-M49', 0, 32.00, 'empty'),
(49, 'Storage', 'STOR17-001-M49', 0, 36.00, 'empty'),
(49, 'Garage', 'GAR3-001-M49', 0, 45.00, 'empty'),
-- Move 50 boxes (12 boxes)
(50, 'Lake House Main', 'LHM-001-M50', 0, 32.00, 'packed'),
(50, 'Lake House Main', 'LHM-002-M50', 0, 30.00, 'packed'),
(50, 'Master Bedroom', 'MB6-001-M50', 0, 27.00, 'packed'),
(50, 'Guest Room 1', 'GR3-001-M50', 0, 25.00, 'packed'),
(50, 'Guest Room 2', 'GR4-001-M50', 0, 24.00, 'packed'),
(50, 'Kitchen', 'KIT19-001-M50', 1, 29.00, 'packed'),
(50, 'Kitchen', 'KIT19-002-M50', 1, 27.00, 'packed'),
(50, 'Living Area', 'LA7-001-M50', 0, 32.00, 'packed'),
(50, 'Dining Area', 'DA8-001-M50', 1, 24.00, 'packed'),
(50, 'Deck Storage', 'DS4-001-M50', 0, 35.00, 'empty'),
(50, 'Boat Storage', 'BS6-001-M50', 0, 48.00, 'empty'),
(50, 'Boat Storage', 'BS6-002-M50', 0, 46.00, 'empty'),
-- Move 51 boxes (10 boxes)
(51, 'Art Studio Main', 'ASM-001-M51', 0, 33.00, 'empty'),
(51, 'Work Area 1', 'WA3-001-M51', 0, 35.00, 'empty'),
(51, 'Work Area 2', 'WA4-001-M51', 0, 36.00, 'empty'),
(51, 'Storage Area', 'SA3-001-M51', 0, 38.00, 'empty'),
(51, 'Supply Room', 'SR4-001-M51', 0, 32.00, 'empty'),
(51, 'Display Area', 'DA9-001-M51', 1, 26.00, 'empty'),
(51, 'Display Area', 'DA9-002-M51', 1, 24.00, 'empty'),
(51, 'Office', 'OFF13-001-M51', 0, 30.00, 'empty'),
(51, 'Equipment Area', 'EA4-001-M51', 1, 44.00, 'empty'),
(51, 'Back Room', 'BR5-001-M51', 0, 34.00, 'empty'),
-- Move 52 boxes (11 boxes)
(52, 'Howell Mill Living', 'HML-001-M52', 0, 29.00, 'empty'),
(52, 'Howell Mill Living', 'HML-002-M52', 0, 27.00, 'empty'),
(52, 'Master Bedroom', 'MB7-001-M52', 0, 26.00, 'empty'),
(52, 'Second Bedroom', 'SB4-001-M52', 0, 25.00, 'empty'),
(52, 'Kitchen', 'KIT20-001-M52', 1, 30.00, 'empty'),
(52, 'Kitchen', 'KIT20-002-M52', 1, 28.00, 'empty'),
(52, 'Living Room', 'LR8-001-M52', 0, 32.00, 'empty'),
(52, 'Dining Area', 'DA10-001-M52', 1, 24.00, 'empty'),
(52, 'Office', 'OFF14-001-M52', 0, 33.00, 'empty'),
(52, 'Storage', 'STOR18-001-M52', 0, 37.00, 'empty'),
(52, 'Balcony', 'BAL8-001-M52', 0, 23.00, 'empty'),
-- Move 53 boxes (12 boxes)
(53, 'Warehouse Section A', 'WSA-001-M53', 0, 66.00, 'empty'),
(53, 'Warehouse Section B', 'WSB-001-M53', 0, 64.00, 'empty'),
(53, 'Warehouse Section C', 'WSC-001-M53', 0, 68.00, 'empty'),
(53, 'Warehouse Section D', 'WSD-001-M53', 0, 65.00, 'empty'),
(53, 'Office Area', 'OA4-001-M53', 0, 31.00, 'empty'),
(53, 'Storage Bay 1', 'SB4-001-M53', 0, 50.00, 'empty'),
(53, 'Storage Bay 2', 'SB5-001-M53', 0, 52.00, 'empty'),
(53, 'Equipment Bay', 'EB2-001-M53', 1, 54.00, 'empty'),
(53, 'Loading Area', 'LA8-001-M53', 0, 48.00, 'empty'),
(53, 'Shipping Area', 'SHA2-001-M53', 0, 46.00, 'empty'),
(53, 'Receiving Area', 'RA2-001-M53', 0, 47.00, 'empty'),
(53, 'Receiving Area', 'RA2-002-M53', 0, 45.00, 'empty'),
-- Move 54 boxes (10 boxes)
(54, 'Buford Living', 'BL2-001-M54', 0, 28.00, 'empty'),
(54, 'Bedroom 1', 'B1-003-M54', 0, 25.00, 'empty'),
(54, 'Bedroom 2', 'B2-003-M54', 0, 26.00, 'empty'),
(54, 'Kitchen', 'KIT21-001-M54', 1, 29.00, 'empty'),
(54, 'Kitchen', 'KIT21-002-M54', 1, 27.00, 'empty'),
(54, 'Living Area', 'LA9-001-M54', 0, 31.00, 'empty'),
(54, 'Dining Area', 'DA11-001-M54', 1, 23.00, 'empty'),
(54, 'Office', 'OFF15-001-M54', 0, 32.00, 'empty'),
(54, 'Storage', 'STOR19-001-M54', 0, 36.00, 'empty'),
(54, 'Patio', 'PAT2-001-M54', 0, 27.00, 'empty'),
-- Move 55 boxes (13 boxes)
(55, 'Coworking Main', 'CWM-001-M55', 0, 34.00, 'empty'),
(55, 'Coworking Main', 'CWM-002-M55', 0, 32.00, 'empty'),
(55, 'Private Office 1', 'PO4-001-M55', 0, 30.00, 'empty'),
(55, 'Private Office 2', 'PO5-001-M55', 0, 31.00, 'empty'),
(55, 'Open Workspace', 'OW3-001-M55', 0, 35.00, 'empty'),
(55, 'Open Workspace', 'OW3-002-M55', 0, 33.00, 'empty'),
(55, 'Meeting Room A', 'MRA3-001-M55', 0, 27.00, 'empty'),
(55, 'Meeting Room B', 'MRB3-001-M55', 0, 28.00, 'empty'),
(55, 'Kitchen', 'KIT22-001-M55', 0, 24.00, 'empty'),
(55, 'Lounge Area', 'LA10-001-M55', 0, 29.00, 'empty'),
(55, 'Storage', 'STOR20-001-M55', 0, 38.00, 'empty'),
(55, 'Reception', 'REC6-001-M55', 0, 25.00, 'empty'),
(55, 'Reception', 'REC6-002-M55', 0, 23.00, 'empty');


-- ITEMS TABLE
-- 5-6 items per box for some boxes, some boxes have no items

INSERT INTO items (box_id, name, quantity, value) VALUES
-- Box 1 items (5 items)
(1, 'Throw Pillows', 3, 45.00),
(1, 'Photo Frames', 5, 75.00),
(1, 'Decorative Vase', 1, 85.00),
(1, 'Coffee Table Books', 4, 120.00),
(1, 'Remote Controls', 2, 30.00),

-- Box 2 items (6 items)
(2, 'Glass Picture Frame', 2, 150.00),
(2, 'Ceramic Figurines', 4, 200.00),
(2, 'Crystal Bowl', 1, 180.00),
(2, 'Porcelain Plates', 6, 240.00),
(2, 'Glass Candle Holders', 3, 90.00),
(2, 'Decorative Mirror', 1, 220.00),

-- Box 3 items (5 items)
(3, 'Table Lamp', 1, 95.00),
(3, 'Magazine Rack', 1, 45.00),
(3, 'Wall Art', 2, 160.00),
(3, 'Curtain Rods', 2, 80.00),
(3, 'Coasters Set', 1, 25.00),

-- Box 4 items (6 items)
(4, 'Bed Sheets', 3, 120.00),
(4, 'Pillowcases', 6, 60.00),
(4, 'Blankets', 2, 150.00),
(4, 'Comforter', 1, 200.00),
(4, 'Mattress Protector', 1, 85.00),
(4, 'Decorative Cushions', 4, 80.00),

-- Box 5 items (5 items)
(5, 'Alarm Clock', 1, 35.00),
(5, 'Bedside Lamp', 1, 65.00),
(5, 'Jewelry Box', 1, 120.00),
(5, 'Books', 8, 160.00),
(5, 'Reading Glasses', 2, 50.00),

-- Box 6 items (6 items)
(6, 'Dinner Plates', 8, 200.00),
(6, 'Coffee Mugs', 6, 90.00),
(6, 'Wine Glasses', 8, 240.00),
(6, 'Salad Bowls', 4, 100.00),
(6, 'Serving Platters', 2, 180.00),
(6, 'Cutlery Set', 1, 250.00),

-- Box 7 items (5 items)
(7, 'Cooking Pots', 4, 280.00),
(7, 'Frying Pans', 3, 180.00),
(7, 'Mixing Bowls', 5, 75.00),
(7, 'Kitchen Utensils', 12, 120.00),
(7, 'Measuring Cups', 1, 40.00),

-- Box 8 items (6 items)
(8, 'Blender', 1, 150.00),
(8, 'Toaster', 1, 85.00),
(8, 'Coffee Maker', 1, 180.00),
(8, 'Food Processor', 1, 220.00),
(8, 'Electric Kettle', 1, 65.00),
(8, 'Stand Mixer', 1, 350.00),

-- Box 9 items (5 items)
(9, 'Spice Rack', 1, 45.00),
(9, 'Cutting Boards', 3, 90.00),
(9, 'Kitchen Towels', 6, 48.00),
(9, 'Oven Mitts', 2, 24.00),
(9, 'Baking Sheets', 3, 75.00),

-- Box 10 (empty - no items)

-- Box 11 items (5 items)
(11, 'Filing Cabinet Contents', 1, 50.00),
(11, 'Office Supplies', 1, 85.00),
(11, 'Desk Organizers', 2, 60.00),
(11, 'Binders', 12, 96.00),
(11, 'Notebooks', 8, 64.00),

-- Box 12 items (6 items)
(12, 'Garden Tools', 8, 180.00),
(12, 'Extension Cords', 4, 80.00),
(12, 'Power Tools', 3, 450.00),
(12, 'Tool Box', 1, 120.00),
(12, 'Work Gloves', 3, 36.00),
(12, 'Safety Goggles', 2, 40.00),

-- Box 13 (empty - no items)

-- Box 14 items (5 items)
(14, 'Reception Desk Items', 1, 120.00),
(14, 'Phone System', 1, 300.00),
(14, 'Office Decor', 4, 200.00),
(14, 'Welcome Sign', 1, 85.00),
(14, 'Business Cards', 500, 50.00),

-- Box 15 items (6 items)
(15, 'Projector', 1, 800.00),
(15, 'Conference Phone', 1, 350.00),
(15, 'Whiteboard Markers', 12, 48.00),
(15, 'Presentation Clicker', 2, 80.00),
(15, 'HDMI Cables', 4, 60.00),
(15, 'Extension Cords', 3, 45.00),

-- Box 16 items (5 items)
(16, 'Executive Chair', 1, 650.00),
(16, 'Desk Lamp', 1, 120.00),
(16, 'Desktop Organizer', 1, 75.00),
(16, 'File Folders', 20, 40.00),
(16, 'Office Plants', 2, 80.00),

-- Box 17 (empty - no items)

-- Box 18 items (6 items)
(18, 'Storage Bins', 6, 120.00),
(18, 'Label Maker', 1, 85.00),
(18, 'Packing Supplies', 1, 60.00),
(18, 'Shelving Units', 2, 280.00),
(18, 'Storage Boxes', 10, 100.00),
(18, 'Bubble Wrap', 3, 45.00),

-- Box 19 items (5 items)
(19, 'Server Equipment', 2, 2500.00),
(19, 'Network Cables', 20, 100.00),
(19, 'Power Strips', 4, 80.00),
(19, 'Cable Management', 1, 50.00),
(19, 'Backup Drives', 3, 450.00),

-- Box 20 items (6 items)
(20, 'Desk Supplies', 1, 120.00),
(20, 'Computer Monitors', 3, 900.00),
(20, 'Keyboards', 3, 240.00),
(20, 'Mice', 3, 120.00),
(20, 'Laptop Stands', 3, 180.00),
(20, 'USB Hubs', 3, 90.00),

-- Box 21 items (5 items)
(21, 'Office Chairs', 2, 800.00),
(21, 'Desk Accessories', 1, 150.00),
(21, 'Plants', 3, 120.00),
(21, 'Coat Rack', 1, 95.00),
(21, 'Umbrella Stand', 1, 45.00),

-- Box 22 (empty - no items)

-- Box 23 items (6 items)
(23, 'Copy Paper', 10, 50.00),
(23, 'Printer Cartridges', 6, 300.00),
(23, 'Staplers', 4, 60.00),
(23, 'Paper Clips', 10, 20.00),
(23, 'Scissors', 6, 48.00),
(23, 'Tape Dispensers', 4, 40.00),

-- Box 24 items (5 items)
(24, 'Winter Clothes', 15, 450.00),
(24, 'Winter Boots', 3, 300.00),
(24, 'Winter Coats', 4, 600.00),
(24, 'Scarves', 6, 120.00),
(24, 'Gloves', 5, 100.00),

-- Box 25 items (6 items)
(25, 'Sofa Cushions', 4, 200.00),
(25, 'Dining Chairs', 2, 400.00),
(25, 'Bar Stools', 2, 300.00),
(25, 'Ottoman', 1, 180.00),
(25, 'Side Table', 1, 150.00),
(25, 'Console Table', 1, 280.00),

-- Box 26 items (5 items)
(26, 'Christmas Decorations', 1, 200.00),
(26, 'Holiday Lights', 5, 100.00),
(26, 'Wreath', 2, 80.00),
(26, 'Tree Ornaments', 30, 150.00),
(26, 'Stockings', 4, 60.00),

-- Box 27 items (6 items)
(27, 'Desk', 1, 450.00),
(27, 'Bookshelf', 1, 320.00),
(27, 'Filing Cabinet', 1, 280.00),
(27, 'Office Chair', 1, 350.00),
(27, 'Desk Accessories', 1, 100.00),
(27, 'Monitor Stand', 1, 85.00),

-- Box 28 (empty - no items)

-- Box 29 items (5 items)
(29, 'Sports Equipment', 1, 300.00),
(29, 'Tennis Rackets', 2, 280.00),
(29, 'Soccer Ball', 2, 60.00),
(29, 'Basketball', 1, 40.00),
(29, 'Yoga Mat', 2, 80.00),

-- Box 30 items (6 items)
(30, 'Power Drill', 1, 180.00),
(30, 'Hammer', 2, 60.00),
(30, 'Screwdriver Set', 1, 85.00),
(30, 'Wrench Set', 1, 120.00),
(30, 'Tape Measure', 3, 45.00),
(30, 'Level', 2, 50.00),

-- Box 31 items (5 items)
(31, 'Paint Supplies', 1, 150.00),
(31, 'Paint Brushes', 8, 80.00),
(31, 'Paint Rollers', 4, 60.00),
(31, 'Drop Cloths', 3, 45.00),
(31, 'Painters Tape', 6, 36.00),

-- Box 32 (empty - no items)

-- Box 33 items (6 items)
(33, 'Camping Tent', 1, 350.00),
(33, 'Sleeping Bags', 2, 240.00),
(33, 'Camp Chairs', 4, 160.00),
(33, 'Cooler', 1, 120.00),
(33, 'Camping Stove', 1, 95.00),
(33, 'Lantern', 2, 70.00),

-- Box 34 items (5 items)
(34, 'Throw Pillows', 4, 80.00),
(34, 'Area Rug', 1, 350.00),
(34, 'Floor Lamp', 1, 180.00),
(34, 'Wall Clock', 1, 65.00),
(34, 'Picture Frames', 6, 120.00),

-- Box 35 items (6 items)
(35, 'TV Stand', 1, 280.00),
(35, 'Entertainment Center', 1, 450.00),
(35, 'DVD Player', 1, 85.00),
(35, 'Sound Bar', 1, 320.00),
(35, 'Gaming Console', 1, 450.00),
(35, 'Controllers', 3, 180.00),

-- Box 36 items (5 items)
(36, 'Coffee Table', 1, 320.00),
(36, 'End Tables', 2, 240.00),
(37, 'Decorative Bowls', 3, 120.00),
(37, 'Candles', 8, 96.00),
(37, 'Candle Holders', 4, 80.00),

-- Box 38 (empty - no items)

-- Box 39 items (6 items)
(39, 'Bed Frame', 1, 650.00),
(39, 'Headboard', 1, 380.00),
(39, 'Nightstands', 2, 360.00),
(39, 'Table Lamps', 2, 180.00),
(39, 'Dresser', 1, 580.00),
(39, 'Mirror', 1, 220.00),

-- Box 40 items (5 items)
(40, 'Wardrobe', 1, 750.00),
(40, 'Hangers', 50, 50.00),
(40, 'Storage Boxes', 6, 90.00),
(40, 'Shoe Rack', 1, 85.00),
(40, 'Closet Organizers', 3, 120.00),

-- Box 41 items (6 items)
(41, 'Dining Table', 1, 850.00),
(41, 'Dining Chairs', 6, 900.00),
(41, 'China Cabinet', 1, 980.00),
(41, 'Table Runner', 2, 60.00),
(41, 'Placemats', 8, 64.00),
(41, 'Napkin Rings', 8, 48.00),

-- Box 42 items (5 items)
(42, 'Kitchen Island', 1, 1200.00),
(42, 'Bar Stools', 3, 450.00),
(42, 'Microwave', 1, 180.00),
(42, 'Rice Cooker', 1, 95.00),
(42, 'Slow Cooker', 1, 85.00),

-- Box 43 (empty - no items)

-- Box 44 items (6 items)
(44, 'Dishware Set', 1, 320.00),
(44, 'Glassware Set', 1, 240.00),
(44, 'Silverware Set', 1, 280.00),
(44, 'Serving Bowls', 4, 120.00),
(44, 'Casserole Dishes', 3, 150.00),
(44, 'Baking Dishes', 4, 100.00),

-- Box 45 items (5 items)
(45, 'Bathroom Towels', 8, 160.00),
(45, 'Bath Mats', 3, 75.00),
(45, 'Shower Curtain', 1, 45.00),
(45, 'Toilet Paper Holder', 2, 40.00),
(45, 'Soap Dispensers', 3, 60.00),

-- Box 46 items (6 items)
(46, 'Toiletries', 1, 120.00),
(46, 'Hair Dryer', 1, 85.00),
(46, 'Bathroom Scale', 1, 55.00),
(46, 'Medicine Cabinet', 1, 150.00),
(46, 'Toothbrush Holders', 2, 30.00),
(46, 'Waste Basket', 2, 40.00),

-- Box 47 items (5 items)
(47, 'Board Games', 8, 240.00),
(47, 'Puzzles', 5, 100.00),
(47, 'Playing Cards', 4, 32.00),
(47, 'Chess Set', 1, 85.00),
(47, 'Game Console', 1, 350.00),

-- Box 48 (empty - no items)

-- Box 49 items (6 items)
(49, 'Kids Toys', 15, 300.00),
(49, 'Stuffed Animals', 10, 150.00),
(49, 'Building Blocks', 3, 120.00),
(49, 'Action Figures', 12, 180.00),
(49, 'Toy Cars', 8, 96.00),
(49, 'Dolls', 4, 160.00),

-- Box 50 items (5 items)
(50, 'Baby Clothes', 20, 200.00),
(50, 'Baby Blankets', 5, 100.00),
(50, 'Baby Bottles', 8, 64.00),
(51, 'Pacifiers', 6, 36.00),
(51, 'Baby Toys', 10, 120.00),

-- Box 52 items (6 items)
(52, 'Laptop', 1, 1200.00),
(52, 'Tablet', 1, 650.00),
(52, 'Smartphone', 2, 1600.00),
(52, 'Chargers', 5, 100.00),
(52, 'Headphones', 3, 450.00),
(52, 'External Hard Drive', 2, 240.00),

-- Box 53 items (5 items)
(53, 'Camera', 1, 850.00),
(53, 'Camera Lenses', 3, 1800.00),
(53, 'Tripod', 1, 180.00),
(53, 'Camera Bag', 1, 120.00),
(53, 'Memory Cards', 4, 160.00),

-- Box 54 (empty - no items)

-- Box 55 items (6 items)
(55, 'Printer', 1, 350.00),
(55, 'Scanner', 1, 280.00),
(55, 'Router', 1, 180.00),
(55, 'Modem', 1, 120.00),
(55, 'Network Switch', 1, 95.00),
(55, 'Ethernet Cables', 10, 50.00),

-- Box 56 items (5 items)
(56, 'Vinyl Records', 30, 450.00),
(56, 'Record Player', 1, 380.00),
(56, 'Speakers', 2, 600.00),
(56, 'Amplifier', 1, 450.00),
(56, 'Audio Cables', 5, 75.00),

-- Box 57 items (6 items)
(57, 'Guitar', 1, 850.00),
(57, 'Guitar Case', 1, 120.00),
(57, 'Guitar Strings', 5, 50.00),
(57, 'Picks', 20, 20.00),
(57, 'Music Stand', 1, 65.00),
(57, 'Tuner', 1, 45.00),

-- Box 58 items (5 items)
(58, 'Art Supplies', 1, 250.00),
(58, 'Canvas', 8, 160.00),
(58, 'Paint Set', 2, 180.00),
(58, 'Brushes', 15, 150.00),
(58, 'Easel', 1, 180.00),

-- Box 59 (empty - no items)

-- Box 60 items (6 items)
(60, 'Sewing Machine', 1, 450.00),
(60, 'Fabric', 10, 150.00),
(60, 'Thread', 20, 40.00),
(60, 'Scissors', 4, 60.00),
(60, 'Patterns', 8, 64.00),
(60, 'Measuring Tape', 3, 24.00),

-- Box 61 items (5 items)
(61, 'Vacuum Cleaner', 1, 320.00),
(61, 'Mop', 1, 45.00),
(61, 'Broom', 1, 35.00),
(61, 'Dustpan', 2, 20.00),
(61, 'Cleaning Supplies', 1, 85.00),

-- Box 62 items (6 items)
(62, 'Ironing Board', 1, 75.00),
(62, 'Iron', 1, 85.00),
(62, 'Laundry Basket', 2, 60.00),
(62, 'Hangers', 30, 30.00),
(62, 'Drying Rack', 1, 55.00),
(62, 'Laundry Detergent', 3, 36.00),

-- Box 63 items (5 items)
(63, 'Pet Bed', 2, 120.00),
(63, 'Pet Toys', 10, 100.00),
(63, 'Pet Food Bowls', 4, 48.00),
(63, 'Leash', 2, 40.00),
(63, 'Pet Carrier', 1, 95.00),

-- Box 64 (empty - no items)

-- Box 65 items (6 items)
(65, 'Aquarium', 1, 350.00),
(65, 'Fish Tank Accessories', 1, 120.00),
(65, 'Fish Food', 3, 36.00),
(65, 'Water Filter', 1, 85.00),
(65, 'Aquarium Heater', 1, 65.00),
(65, 'Decorative Rocks', 1, 45.00),

-- Box 66 items (5 items)
(66, 'Bicycle', 1, 650.00),
(66, 'Bike Helmet', 2, 120.00),
(66, 'Bike Lock', 1, 55.00),
(66, 'Bike Pump', 1, 40.00),
(66, 'Bike Lights', 2, 60.00),

-- Box 67 items (6 items)
(67, 'Skateboard', 2, 240.00),
(67, 'Roller Skates', 1, 120.00),
(67, 'Protective Pads', 2, 80.00),
(67, 'Knee Pads', 2, 50.00),
(67, 'Elbow Pads', 2, 45.00),
(67, 'Wrist Guards', 2, 40.00),

-- Box 68 items (5 items)
(68, 'Fishing Rod', 2, 280.00),
(68, 'Tackle Box', 1, 85.00),
(68, 'Fishing Lures', 15, 90.00),
(68, 'Fishing Line', 3, 45.00),
(68, 'Cooler', 1, 95.00),

-- Box 69 (empty - no items)

-- Box 70 items (6 items)
(70, 'Golf Clubs', 1, 850.00),
(70, 'Golf Bag', 1, 280.00),
(70, 'Golf Balls', 24, 60.00),
(70, 'Golf Tees', 50, 10.00),
(70, 'Golf Gloves', 3, 60.00),
(70, 'Golf Shoes', 1, 180.00),

-- Box 71 items (5 items)
(71, 'Dumbbells', 4, 320.00),
(71, 'Resistance Bands', 3, 60.00),
(71, 'Yoga Mat', 2, 80.00),
(71, 'Jump Rope', 2, 30.00),
(71, 'Exercise Ball', 1, 45.00),

-- Box 72 items (6 items)
(72, 'Treadmill', 1, 1200.00),
(72, 'Exercise Bike', 1, 850.00),
(72, 'Weight Bench', 1, 380.00),
(72, 'Kettlebells', 3, 180.00),
(72, 'Pull-up Bar', 1, 65.00),
(72, 'Gym Mat', 2, 100.00),

-- Box 73 items (5 items)
(73, 'Cookbooks', 12, 180.00),
(73, 'Recipe Cards', 50, 25.00),
(73, 'Kitchen Timer', 2, 40.00),
(73, 'Apron', 3, 60.00),
(73, 'Oven Thermometer', 2, 30.00),

-- Box 74 (empty - no items)

-- Box 75 items (6 items)
(75, 'Wine Rack', 1, 180.00),
(75, 'Wine Glasses', 12, 180.00),
(75, 'Corkscrew', 3, 60.00),
(75, 'Wine Bottles', 8, 320.00),
(75, 'Wine Decanter', 1, 85.00),
(75, 'Wine Chiller', 1, 75.00),

-- Box 76 items (5 items)
(76, 'Bar Tools', 1, 120.00),
(76, 'Cocktail Shaker', 2, 80.00),
(76, 'Martini Glasses', 6, 90.00),
(76, 'Bar Cart', 1, 280.00),
(76, 'Ice Bucket', 1, 65.00),

-- Box 77 items (6 items)
(77, 'Luggage Set', 1, 450.00),
(77, 'Travel Pillow', 2, 60.00),
(77, 'Travel Adapter', 3, 75.00),
(77, 'Passport Holder', 2, 40.00),
(77, 'Luggage Tags', 4, 24.00),
(77, 'Travel Toiletries', 1, 50.00),

-- Box 78 items (5 items)
(78, 'Backpack', 2, 180.00),
(78, 'Messenger Bag', 1, 120.00),
(78, 'Wallet', 2, 100.00),
(78, 'Sunglasses', 3, 240.00),
(78, 'Watch', 1, 350.00),

-- Box 79 (empty - no items)

-- Box 80 items (6 items)
(80, 'Jewelry', 1, 850.00),
(80, 'Necklaces', 5, 400.00),
(80, 'Earrings', 8, 320.00),
(80, 'Bracelets', 4, 280.00),
(80, 'Rings', 6, 480.00),
(80, 'Jewelry Box', 1, 150.00),

-- Box 81 items (5 items)
(81, 'Perfume', 4, 320.00),
(81, 'Cologne', 2, 180.00),
(81, 'Makeup', 1, 250.00),
(81, 'Skincare Products', 1, 180.00),
(81, 'Hair Products', 1, 120.00),

-- Box 82 items (6 items)
(82, 'Shoes', 8, 640.00),
(82, 'Boots', 3, 450.00),
(82, 'Sandals', 4, 240.00),
(82, 'Sneakers', 3, 360.00),
(82, 'Slippers', 2, 80.00),
(82, 'Shoe Care Kit', 1, 55.00),

-- Box 83 items (5 items)
(83, 'Hats', 6, 180.00),
(83, 'Caps', 4, 80.00),
(83, 'Beanie', 3, 60.00),
(83, 'Sun Hat', 2, 70.00),
(83, 'Winter Hat', 3, 90.00),

-- Box 84 (empty - no items)

-- Box 85 items (6 items)
(85, 'Belts', 5, 250.00),
(85, 'Ties', 8, 240.00),
(85, 'Bow Ties', 4, 120.00),
(85, 'Cufflinks', 3, 180.00),
(85, 'Pocket Squares', 5, 75.00),
(85, 'Tie Clips', 3, 90.00),

-- Box 86 items (5 items)
(86, 'Formal Shirts', 6, 480.00),
(86, 'Dress Pants', 4, 400.00),
(86, 'Blazers', 2, 600.00),
(86, 'Suit', 1, 850.00),
(86, 'Dress Shoes', 2, 320.00),

-- Box 87 items (6 items)
(87, 'Casual Shirts', 10, 300.00),
(87, 'T-Shirts', 15, 225.00),
(87, 'Jeans', 5, 400.00),
(87, 'Shorts', 4, 160.00),
(87, 'Polo Shirts', 6, 240.00),
(87, 'Hoodies', 3, 180.00),

-- Box 88 items (5 items)
(88, 'Jackets', 3, 540.00),
(88, 'Sweaters', 5, 350.00),
(88, 'Cardigans', 3, 210.00),
(88, 'Vests', 2, 140.00),
(88, 'Overcoat', 1, 380.00),

-- Box 89 (empty - no items)

-- Box 90 items (6 items)
(90, 'Dresses', 6, 720.00),
(90, 'Skirts', 4, 280.00),
(90, 'Blouses', 5, 350.00),
(90, 'Leggings', 6, 120.00),
(90, 'Jumpsuit', 2, 280.00),
(90, 'Evening Gown', 1, 450.00),

-- Box 91 items (5 items)
(91, 'Workout Clothes', 8, 320.00),
(91, 'Sports Bras', 4, 120.00),
(91, 'Athletic Shorts', 5, 125.00),
(91, 'Tank Tops', 6, 90.00),
(91, 'Sweatpants', 3, 135.00),

-- Box 92 items (6 items)
(92, 'Swimsuit', 3, 180.00),
(92, 'Beach Towels', 4, 80.00),
(92, 'Flip Flops', 3, 60.00),
(92, 'Beach Bag', 1, 55.00),
(92, 'Sunscreen', 3, 45.00),
(92, 'Beach Umbrella', 1, 75.00),

-- Box 93 items (5 items)
(93, 'Winter Coat', 2, 600.00),
(93, 'Snow Boots', 2, 320.00),
(93, 'Thermal Underwear', 4, 160.00),
(93, 'Winter Gloves', 3, 90.00),
(93, 'Ear Muffs', 2, 40.00),

-- Box 94 (empty - no items)

-- Box 95 items (6 items)
(95, 'Rain Jacket', 2, 240.00),
(95, 'Umbrella', 3, 90.00),
(95, 'Rain Boots', 2, 160.00),
(95, 'Raincoat', 1, 120.00),
(95, 'Waterproof Bag', 1, 75.00),
(95, 'Rain Poncho', 2, 50.00),

-- Box 96 items (5 items)
(96, 'Backpacking Gear', 1, 450.00),
(96, 'Hiking Boots', 2, 360.00),
(96, 'Water Bottle', 3, 60.00),
(96, 'Compass', 1, 40.00),
(96, 'Flashlight', 2, 80.00),

-- Box 97 items (6 items)
(97, 'Tent Stakes', 12, 36.00),
(97, 'Sleeping Pad', 2, 160.00),
(97, 'Camping Pillow', 2, 60.00),
(97, 'Insect Repellent', 3, 30.00),
(97, 'First Aid Kit', 1, 55.00),
(97, 'Multi-tool', 2, 90.00),

-- Box 98 items (5 items)
(98, 'Binoculars', 1, 280.00),
(98, 'Field Guide', 3, 75.00),
(98, 'Bird Feeder', 2, 80.00),
(98, 'Bird Bath', 1, 95.00),
(98, 'Nature Journal', 2, 40.00),

-- Box 99 (empty - no items)

-- Box 100 items (6 items)
(100, 'Gardening Tools', 8, 240.00),
(100, 'Garden Hose', 1, 85.00),
(100, 'Watering Can', 2, 60.00),
(100, 'Plant Pots', 10, 100.00),
(100, 'Gardening Gloves', 3, 45.00),
(100, 'Seeds', 15, 45.00);



-- BOX_CATEGORIES TABLE
-- Linking boxes to categories (each box can have 1-3 categories)

INSERT INTO box_categories (box_id, category_id) VALUES
-- Box 1 categories
(1, 4),  -- Living Room

-- Box 2 categories
(2, 4),  -- Living Room
(2, 14), -- Fragile

-- Box 3 categories
(3, 4),  -- Living Room

-- Box 4 categories
(4, 2),  -- Bedroom
(4, 13), -- Linens

-- Box 5 categories
(5, 2),  -- Bedroom

-- Box 6 categories
(6, 1),  -- Kitchen
(6, 14), -- Fragile

-- Box 7 categories
(7, 1),  -- Kitchen
(7, 14), -- Fragile

-- Box 8 categories
(8, 1),  -- Kitchen
(8, 6),  -- Electronics

-- Box 9 categories
(9, 1),  -- Kitchen

-- Box 10 categories
(10, 2), -- Bedroom

-- Box 11 categories
(11, 5),  -- Office
(11, 7),  -- Books

-- Box 12 categories
(12, 11), -- Tools
(12, 15), -- Heavy

-- Box 13 categories
(13, 5),  -- Office

-- Box 14 categories
(14, 5),  -- Office

-- Box 15 categories
(15, 5),  -- Office
(15, 6),  -- Electronics

-- Box 16 categories
(16, 5),  -- Office

-- Box 17 categories
(17, 5),  -- Office

-- Box 18 categories
(18, 5),  -- Office

-- Box 19 categories
(19, 6),  -- Electronics
(19, 15), -- Heavy

-- Box 20 categories
(20, 5),  -- Office
(20, 6),  -- Electronics

-- Box 21 categories
(21, 5),  -- Office

-- Box 22 categories
(22, 5),  -- Office

-- Box 23 categories
(23, 5),  -- Office

-- Box 24 categories
(24, 8),  -- Clothing

-- Box 25 categories
(25, 4),  -- Living Room
(25, 15), -- Heavy

-- Box 26 categories
(26, 12), -- Decorations

-- Box 27 categories
(27, 5),  -- Office
(27, 15), -- Heavy

-- Box 28 categories
(28, 3),  -- Bathroom

-- Box 29 categories
(29, 10), -- Sports

-- Box 30 categories
(30, 11), -- Tools

-- Box 31 categories
(31, 11), -- Tools

-- Box 32 categories
(32, 16), -- Outdoor

-- Box 33 categories
(33, 16), -- Outdoor
(33, 10), -- Sports

-- Box 34 categories
(34, 4),  -- Living Room
(34, 12), -- Decorations

-- Box 35 categories
(35, 4),  -- Living Room
(35, 6),  -- Electronics

-- Box 36 categories
(36, 4),  -- Living Room

-- Box 37 categories
(37, 4),  -- Living Room
(37, 12), -- Decorations

-- Box 38 categories
(38, 2),  -- Bedroom

-- Box 39 categories
(39, 2),  -- Bedroom
(39, 15), -- Heavy

-- Box 40 categories
(40, 2),  -- Bedroom
(40, 8),  -- Clothing

-- Box 41 categories
(41, 4),  -- Living Room
(41, 14), -- Fragile

-- Box 42 categories
(42, 1),  -- Kitchen
(42, 15), -- Heavy

-- Box 43 categories
(43, 1),  -- Kitchen

-- Box 44 categories
(44, 1),  -- Kitchen
(44, 14), -- Fragile

-- Box 45 categories
(45, 3),  -- Bathroom
(45, 13), -- Linens

-- Box 46 categories
(46, 3),  -- Bathroom

-- Box 47 categories
(47, 9),  -- Toys

-- Box 48 categories
(48, 9),  -- Toys

-- Box 49 categories
(49, 9),  -- Toys

-- Box 50 categories
(50, 9),  -- Toys

-- Box 51 categories
(51, 9),  -- Toys

-- Box 52 categories
(52, 6),  -- Electronics
(52, 14), -- Fragile

-- Box 53 categories
(53, 6),  -- Electronics
(53, 14), -- Fragile

-- Box 54 categories
(54, 6),  -- Electronics

-- Box 55 categories
(55, 6),  -- Electronics
(55, 5),  -- Office

-- Box 56 categories
(56, 6),  -- Electronics
(56, 14), -- Fragile

-- Box 57 categories
(57, 6),  -- Electronics

-- Box 58 categories
(58, 20), -- Art Supplies

-- Box 59 categories
(59, 20), -- Art Supplies

-- Box 60 categories
(60, 8),  -- Clothing

-- Box 61 categories
(61, 19), -- Cleaning Supplies

-- Box 62 categories
(62, 13), -- Linens
(62, 8),  -- Clothing

-- Box 63 categories
(63, 18), -- Pet Supplies

-- Box 64 categories
(64, 18), -- Pet Supplies

-- Box 65 categories
(65, 18), -- Pet Supplies
(65, 14), -- Fragile

-- Box 66 categories
(66, 10), -- Sports

-- Box 67 categories
(67, 10), -- Sports

-- Box 68 categories
(68, 10), -- Sports
(68, 16), -- Outdoor

-- Box 69 categories
(69, 10), -- Sports

-- Box 70 categories
(70, 10), -- Sports

-- Box 71 categories
(71, 10), -- Sports
(71, 15), -- Heavy

-- Box 72 categories
(72, 10), -- Sports
(72, 15), -- Heavy

-- Box 73 categories
(73, 1),  -- Kitchen
(73, 7),  -- Books

-- Box 74 categories
(74, 1),  -- Kitchen

-- Box 75 categories
(75, 1),  -- Kitchen
(75, 14), -- Fragile

-- Box 76 categories
(76, 1),  -- Kitchen
(76, 14), -- Fragile

-- Box 77 categories
(77, 8),  -- Clothing

-- Box 78 categories
(78, 8),  -- Clothing

-- Box 79 categories
(79, 8),  -- Clothing

-- Box 80 categories
(80, 14), -- Fragile
(80, 8),  -- Clothing

-- Box 81 categories
(81, 3),  -- Bathroom

-- Box 82 categories
(82, 8),  -- Clothing

-- Box 83 categories
(83, 8),  -- Clothing

-- Box 84 categories
(84, 8),  -- Clothing

-- Box 85 categories
(85, 8),  -- Clothing

-- Box 86 categories
(86, 8),  -- Clothing

-- Box 87 categories
(87, 8),  -- Clothing

-- Box 88 categories
(88, 8),  -- Clothing

-- Box 89 categories
(89, 8),  -- Clothing

-- Box 90 categories
(90, 8),  -- Clothing

-- Box 91 categories
(91, 8),  -- Clothing
(91, 10), -- Sports

-- Box 92 categories
(92, 8),  -- Clothing
(92, 16), -- Outdoor

-- Box 93 categories
(93, 8),  -- Clothing

-- Box 94 categories
(94, 8),  -- Clothing

-- Box 95 categories
(95, 8),  -- Clothing
(95, 16), -- Outdoor

-- Box 96 categories
(96, 16), -- Outdoor
(96, 10), -- Sports

-- Box 97 categories
(97, 16), -- Outdoor
(97, 10), -- Sports

-- Box 98 categories
(98, 16), -- Outdoor

-- Box 99 categories
(99, 17), -- Garden

-- Box 100 categories
(100, 17), -- Garden
(100, 11), -- Tools

-- Box 101 categories
(101, 4),  -- Living Room

-- Box 102 categories
(102, 2),  -- Bedroom

-- Box 103 categories
(103, 1),  -- Kitchen
(103, 14), -- Fragile

-- Box 104 categories
(104, 2),  -- Bedroom

-- Box 105 categories
(105, 5),  -- Office

-- Box 106 categories
(106, 3),  -- Bathroom

-- Box 107 categories
(107, 4),  -- Living Room
(107, 14), -- Fragile

-- Box 108 categories
(108, 2),  -- Bedroom

-- Box 109 categories
(109, 4),  -- Living Room

-- Box 110 categories
(110, 3),  -- Bathroom

-- Box 111 categories
(111, 5),  -- Office
(111, 6),  -- Electronics

-- Box 112 categories
(112, 5),  -- Office

-- Box 113 categories
(113, 5),  -- Office

-- Box 114 categories
(114, 5),  -- Office

-- Box 115 categories
(115, 5),  -- Office

-- Box 116 categories
(116, 5),  -- Office
(116, 7),  -- Books

-- Box 117 categories
(117, 1),  -- Kitchen
(117, 14), -- Fragile

-- Box 118 categories
(118, 5),  -- Office

-- Box 119 categories
(119, 5),  -- Office

-- Box 120 categories
(120, 6),  -- Electronics
(120, 15), -- Heavy

-- Box 121 categories
(121, 1),  -- Kitchen

-- Box 122 categories
(122, 1),  -- Kitchen

-- Box 123 categories
(123, 2),  -- Bedroom
(123, 13), -- Linens

-- Box 124 categories
(124, 2),  -- Bedroom

-- Box 125 categories
(125, 1),  -- Kitchen
(125, 14), -- Fragile

-- Box 126 categories
(126, 4),  -- Living Room

-- Box 127 categories
(127, 4),  -- Living Room
(127, 14), -- Fragile

-- Box 128 categories
(128, 4),  -- Living Room

-- Box 129 categories
(129, 2),  -- Bedroom

-- Box 130 categories
(130, 5),  -- Office

-- Box 131 categories
(131, 5),  -- Office

-- Box 132 categories
(132, 4),  -- Living Room
(132, 6),  -- Electronics

-- Box 133 categories
(133, 4),  -- Living Room

-- Box 134 categories
(134, 1),  -- Kitchen
(134, 14), -- Fragile

-- Box 135 categories
(135, 3),  -- Bathroom

-- Box 136 categories
(136, 8),  -- Clothing

-- Box 137 categories
(137, 8),  -- Clothing

-- Box 138 categories
(138, 9),  -- Toys

-- Box 139 categories
(139, 10), -- Sports

-- Box 140 categories
(140, 11), -- Tools

-- Box 141 categories
(141, 4),  -- Living Room

-- Box 142 categories
(142, 2),  -- Bedroom

-- Box 143 categories
(143, 1),  -- Kitchen
(143, 14), -- Fragile

-- Box 144 categories
(144, 5),  -- Office

-- Box 145 categories
(145, 6),  -- Electronics
(145, 14), -- Fragile

-- Box 146 categories
(146, 4),  -- Living Room

-- Box 147 categories
(147, 2),  -- Bedroom

-- Box 148 categories
(148, 1),  -- Kitchen

-- Box 149 categories
(149, 3),  -- Bathroom

-- Box 150 categories
(150, 8),  -- Clothing

-- Box 151 categories
(151, 4),  -- Living Room

-- Box 152 categories
(152, 2),  -- Bedroom

-- Box 153 categories
(153, 1),  -- Kitchen
(153, 14), -- Fragile

-- Box 154 categories
(154, 5),  -- Office

-- Box 155 categories
(155, 4),  -- Living Room
(155, 6),  -- Electronics

-- Box 156 categories
(156, 2),  -- Bedroom

-- Box 157 categories
(157, 3),  -- Bathroom

-- Box 158 categories
(158, 8),  -- Clothing

-- Box 159 categories
(159, 5),  -- Office

-- Box 160 categories
(160, 1),  -- Kitchen

-- Box 161 categories
(161, 4),  -- Living Room

-- Box 162 categories
(162, 6),  -- Electronics

-- Box 163 categories
(163, 5),  -- Office
(163, 7),  -- Books

-- Box 164 categories
(164, 11), -- Tools

-- Box 165 categories
(165, 10), -- Sports

-- Box 166 categories
(166, 9),  -- Toys

-- Box 167 categories
(167, 12), -- Decorations

-- Box 168 categories
(168, 8),  -- Clothing

-- Box 169 categories
(169, 16), -- Outdoor

-- Box 170 categories
(170, 17), -- Garden

-- Box 171 categories
(171, 4),  -- Living Room

-- Box 172 categories
(172, 2),  -- Bedroom

-- Box 173 categories
(173, 1),  -- Kitchen
(173, 14), -- Fragile

-- Box 174 categories
(174, 3),  -- Bathroom

-- Box 175 categories
(175, 5),  -- Office

-- Box 176 categories
(176, 4),  -- Living Room

-- Box 177 categories
(177, 2),  -- Bedroom

-- Box 178 categories
(178, 8),  -- Clothing

-- Box 179 categories
(179, 6),  -- Electronics

-- Box 180 categories
(180, 1),  -- Kitchen

-- Box 181 categories
(181, 4),  -- Living Room

-- Box 182 categories
(182, 2),  -- Bedroom

-- Box 183 categories
(183, 1),  -- Kitchen
(183, 14), -- Fragile

-- Box 184 categories
(184, 5),  -- Office

-- Box 185 categories
(185, 3),  -- Bathroom

-- Box 186 categories
(186, 8),  -- Clothing

-- Box 187 categories
(187, 4),  -- Living Room

-- Box 188 categories
(188, 2),  -- Bedroom

-- Box 189 categories
(189, 6),  -- Electronics

-- Box 190 categories
(190, 5),  -- Office

-- Box 191 categories
(191, 1),  -- Kitchen

-- Box 192 categories
(192, 10), -- Sports

-- Box 193 categories
(193, 11), -- Tools

-- Box 194 categories
(194, 8),  -- Clothing

-- Box 195 categories
(195, 9),  -- Toys

-- Box 196 categories
(196, 4),  -- Living Room

-- Box 197 categories
(197, 2),  -- Bedroom

-- Box 198 categories
(198, 1),  -- Kitchen
(198, 14), -- Fragile

-- Box 199 categories
(199, 5),  -- Office

-- Box 200 categories
(200, 3),  -- Bathroom

-- Box 201 categories
(201, 4),  -- Living Room

-- Box 202 categories
(202, 2),  -- Bedroom

-- Box 203 categories
(203, 1),  -- Kitchen

-- Box 204 categories
(204, 8),  -- Clothing

-- Box 205 categories
(205, 6),  -- Electronics

-- Box 206 categories
(206, 5),  -- Office

-- Box 207 categories
(207, 3),  -- Bathroom

-- Box 208 categories
(208, 4),  -- Living Room

-- Box 209 categories
(209, 2),  -- Bedroom

-- Box 210 categories
(210, 1),  -- Kitchen
(210, 14), -- Fragile

-- Box 211 categories
(211, 5),  -- Office

-- Box 212 categories
(212, 4),  -- Living Room

-- Box 213 categories
(213, 2),  -- Bedroom

-- Box 214 categories
(214, 1),  -- Kitchen

-- Box 215 categories
(215, 3),  -- Bathroom

-- Box 216 categories
(216, 8),  -- Clothing

-- Box 217 categories
(217, 6),  -- Electronics

-- Box 218 categories
(218, 5),  -- Office

-- Box 219 categories
(219, 10), -- Sports

-- Box 220 categories
(220, 11), -- Tools

-- Box 221 categories
(221, 4),  -- Living Room

-- Box 222 categories
(222, 2),  -- Bedroom

-- Box 223 categories
(223, 1),  -- Kitchen
(223, 14), -- Fragile

-- Box 224 categories
(224, 8),  -- Clothing

-- Box 225 categories
(225, 5),  -- Office

-- Box 226 categories
(226, 4),  -- Living Room

-- Box 227 categories
(227, 2),  -- Bedroom

-- Box 228 categories
(228, 1),  -- Kitchen

-- Box 229 categories
(229, 3),  -- Bathroom

-- Box 230 categories
(230, 6),  -- Electronics

-- Box 231 categories
(231, 5),  -- Office

-- Box 232 categories
(232, 4),  -- Living Room

-- Box 233 categories
(233, 8),  -- Clothing

-- Box 234 categories
(234, 2),  -- Bedroom

-- Box 235 categories
(235, 1),  -- Kitchen
(235, 14), -- Fragile

-- Box 236 categories
(236, 3),  -- Bathroom

-- Box 237 categories
(237, 5),  -- Office

-- Box 238 categories
(238, 4),  -- Living Room

-- Box 239 categories
(239, 10), -- Sports

-- Box 240 categories
(240, 11), -- Tools

-- Box 241 categories
(241, 4),  -- Living Room

-- Box 242 categories
(242, 2),  -- Bedroom

-- Box 243 categories
(243, 1),  -- Kitchen

-- Box 244 categories
(244, 8),  -- Clothing

-- Box 245 categories
(245, 5),  -- Office

-- Box 246 categories
(246, 6),  -- Electronics

-- Box 247 categories
(247, 3),  -- Bathroom

-- Box 248 categories
(248, 4),  -- Living Room

-- Box 249 categories
(249, 17), -- Garden

-- Box 250 categories
(250, 11), -- Tools

-- Box 251 categories
(251, 4),  -- Living Room

-- Box 252 categories
(252, 2),  -- Bedroom

-- Box 253 categories
(253, 1),  -- Kitchen
(253, 14), -- Fragile

-- Box 254 categories
(254, 5),  -- Office

-- Box 255 categories
(255, 3),  -- Bathroom

-- Box 256 categories
(256, 8),  -- Clothing

-- Box 257 categories
(257, 4),  -- Living Room

-- Box 258 categories
(258, 2),  -- Bedroom

-- Box 259 categories
(259, 6),  -- Electronics

-- Box 260 categories
(260, 5),  -- Office

-- Box 261 categories
(261, 1),  -- Kitchen

-- Box 262 categories
(262, 4),  -- Living Room

-- Box 263 categories
(263, 2),  -- Bedroom

-- Box 264 categories
(264, 8),  -- Clothing

-- Box 265 categories
(265, 3),  -- Bathroom

-- Box 266 categories
(266, 5),  -- Office

-- Box 267 categories
(267, 6),  -- Electronics

-- Box 268 categories
(268, 10), -- Sports

-- Box 269 categories
(269, 11), -- Tools

-- Box 270 categories
(270, 1),  -- Kitchen

-- Box 271 categories
(271, 4),  -- Living Room

-- Box 272 categories
(272, 2),  -- Bedroom

-- Box 273 categories
(273, 1),  -- Kitchen
(273, 14), -- Fragile

-- Box 274 categories
(274, 8),  -- Clothing

-- Box 275 categories
(275, 5),  -- Office

-- Box 276 categories
(276, 4),  -- Living Room

-- Box 277 categories
(277, 3),  -- Bathroom

-- Box 278 categories
(278, 2),  -- Bedroom

-- Box 279 categories
(279, 6),  -- Electronics

-- Box 280 categories
(280, 1),  -- Kitchen

-- Box 281 categories
(281, 4),  -- Living Room

-- Box 282 categories
(282, 2),  -- Bedroom

-- Box 283 categories
(283, 5),  -- Office

-- Box 284 categories
(284, 8),  -- Clothing

-- Box 285 categories
(285, 1),  -- Kitchen
(285, 14), -- Fragile

-- Box 286 categories
(286, 3),  -- Bathroom

-- Box 287 categories
(287, 6),  -- Electronics

-- Box 288 categories
(288, 4),  -- Living Room

-- Box 289 categories
(289, 2),  -- Bedroom

-- Box 290 categories
(290, 5),  -- Office

-- Box 291 categories
(291, 10), -- Sports

-- Box 292 categories
(292, 11), -- Tools

-- Box 293 categories
(293, 1),  -- Kitchen

-- Box 294 categories
(294, 4),  -- Living Room

-- Box 295 categories
(295, 2),  -- Bedroom

-- Box 296 categories
(296, 8),  -- Clothing

-- Box 297 categories
(297, 5),  -- Office

-- Box 298 categories
(298, 3),  -- Bathroom

-- Box 299 categories
(299, 6),  -- Electronics

-- Box 300 categories
(300, 1),  -- Kitchen

-- Box 301 categories
(301, 4),  -- Living Room

-- Box 302 categories
(302, 2),  -- Bedroom

-- Box 303 categories
(303, 1),  -- Kitchen
(303, 14), -- Fragile

-- Box 304 categories
(304, 5),  -- Office

-- Box 305 categories
(305, 3),  -- Bathroom

-- Box 306 categories
(306, 8),  -- Clothing

-- Box 307 categories
(307, 4),  -- Living Room

-- Box 308 categories
(308, 2),  -- Bedroom

-- Box 309 categories
(309, 6),  -- Electronics

-- Box 310 categories
(310, 1),  -- Kitchen

-- Box 311 categories
(311, 5),  -- Office

-- Box 312 categories
(312, 4),  -- Living Room

-- Box 313 categories
(313, 2),  -- Bedroom

-- Box 314 categories
(314, 8),  -- Clothing

-- Box 315 categories
(315, 1),  -- Kitchen

-- Box 316 categories
(316, 3),  -- Bathroom

-- Box 317 categories
(317, 5),  -- Office

-- Box 318 categories
(318, 6),  -- Electronics

-- Box 319 categories
(319, 10), -- Sports

-- Box 320 categories
(320, 11), -- Tools

-- Box 321 categories
(321, 4),  -- Living Room

-- Box 322 categories
(322, 2),  -- Bedroom

-- Box 323 categories
(323, 1),  -- Kitchen
(323, 14), -- Fragile

-- Box 324 categories
(324, 5),  -- Office

-- Box 325 categories
(325, 3),  -- Bathroom

-- Box 326 categories
(326, 8),  -- Clothing

-- Box 327 categories
(327, 4),  -- Living Room

-- Box 328 categories
(328, 2),  -- Bedroom

-- Box 329 categories
(329, 6),  -- Electronics

-- Box 330 categories
(330, 1),  -- Kitchen

-- Box 331 categories
(331, 5),  -- Office

-- Box 332 categories
(332, 4),  -- Living Room

-- Box 333 categories
(333, 2),  -- Bedroom

-- Box 334 categories
(334, 8),  -- Clothing

-- Box 335 categories
(335, 1),  -- Kitchen

-- Box 336 categories
(336, 3),  -- Bathroom

-- Box 337 categories
(337, 5),  -- Office

-- Box 338 categories
(338, 6),  -- Electronics

-- Box 339 categories
(339, 10), -- Sports

-- Box 340 categories
(340, 11), -- Tools

-- Box 341 categories
(341, 4),  -- Living Room

-- Box 342 categories
(342, 2),  -- Bedroom

-- Box 343 categories
(343, 1),  -- Kitchen
(343, 14), -- Fragile

-- Box 344 categories
(344, 5),  -- Office

-- Box 345 categories
(345, 3),  -- Bathroom

-- Box 346 categories
(346, 8),  -- Clothing

-- Box 347 categories
(347, 4),  -- Living Room

-- Box 348 categories
(348, 2),  -- Bedroom

-- Box 349 categories
(349, 6),  -- Electronics

-- Box 350 categories
(350, 1),  -- Kitchen

-- Box 351 categories
(351, 5),  -- Office

-- Box 352 categories
(352, 4),  -- Living Room

-- Box 353 categories
(353, 2),  -- Bedroom

-- Box 354 categories
(354, 8),  -- Clothing

-- Box 355 categories
(355, 1),  -- Kitchen

-- Box 356 categories
(356, 3),  -- Bathroom

-- Box 357 categories
(357, 5),  -- Office

-- Box 358 categories
(358, 6),  -- Electronics

-- Box 359 categories
(359, 10), -- Sports

-- Box 360 categories
(360, 11), -- Tools

-- Box 361 categories
(361, 4),  -- Living Room

-- Box 362 categories
(362, 2),  -- Bedroom

-- Box 363 categories
(363, 1),  -- Kitchen
(363, 14), -- Fragile

-- Box 364 categories
(364, 5),  -- Office

-- Box 365 categories
(365, 3),  -- Bathroom

-- Box 366 categories
(366, 8),  -- Clothing

-- Box 367 categories
(367, 4),  -- Living Room

-- Box 368 categories
(368, 2),  -- Bedroom

-- Box 369 categories
(369, 6),  -- Electronics

-- Box 370 categories
(370, 1),  -- Kitchen

-- Box 371 categories
(371, 5),  -- Office

-- Box 372 categories
(372, 4),  -- Living Room

-- Box 373 categories
(373, 2),  -- Bedroom

-- Box 374 categories
(374, 8),  -- Clothing

-- Box 375 categories
(375, 1),  -- Kitchen

-- Box 376 categories
(376, 3),  -- Bathroom

-- Box 377 categories
(377, 5),  -- Office

-- Box 378 categories
(378, 6),  -- Electronics

-- Box 379 categories
(379, 10), -- Sports

-- Box 380 categories
(380, 11), -- Tools

-- Box 381 categories
(381, 4),  -- Living Room

-- Box 382 categories
(382, 2),  -- Bedroom

-- Box 383 categories
(383, 1),  -- Kitchen
(383, 14), -- Fragile

-- Box 384 categories
(384, 5),  -- Office

-- Box 385 categories
(385, 3),  -- Bathroom

-- Box 386 categories
(386, 8),  -- Clothing

-- Box 387 categories
(387, 4),  -- Living Room

-- Box 388 categories
(388, 2),  -- Bedroom

-- Box 389 categories
(389, 6),  -- Electronics

-- Box 390 categories
(390, 1),  -- Kitchen

-- Box 391 categories
(391, 5),  -- Office

-- Box 392 categories
(392, 4),  -- Living Room

-- Box 393 categories
(393, 2),  -- Bedroom

-- Box 394 categories
(394, 8),  -- Clothing

-- Box 395 categories
(395, 1),  -- Kitchen

-- Box 396 categories
(396, 3),  -- Bathroom

-- Box 397 categories
(397, 5),  -- Office

-- Box 398 categories
(398, 6),  -- Electronics

-- Box 399 categories
(399, 10), -- Sports

-- Box 400 categories
(400, 11), -- Tools

-- Box 401 categories
(401, 4),  -- Living Room

-- Box 402 categories
(402, 2),  -- Bedroom

-- Box 403 categories
(403, 1),  -- Kitchen
(403, 14), -- Fragile

-- Box 404 categories
(404, 5),  -- Office

-- Box 405 categories
(405, 3),  -- Bathroom

-- Box 406 categories
(406, 8),  -- Clothing

-- Box 407 categories
(407, 4),  -- Living Room

-- Box 408 categories
(408, 2),  -- Bedroom

-- Box 409 categories
(409, 6),  -- Electronics

-- Box 410 categories
(410, 1),  -- Kitchen

-- Box 411 categories
(411, 5),  -- Office

-- Box 412 categories
(412, 4),  -- Living Room

-- Box 413 categories
(413, 2),  -- Bedroom

-- Box 414 categories
(414, 8),  -- Clothing

-- Box 415 categories
(415, 1),  -- Kitchen

-- Box 416 categories
(416, 3),  -- Bathroom

-- Box 417 categories
(417, 5),  -- Office

-- Box 418 categories
(418, 6),  -- Electronics

-- Box 419 categories
(419, 10), -- Sports

-- Box 420 categories
(420, 11), -- Tools

-- Box 421 categories
(421, 4),  -- Living Room

-- Box 422 categories
(422, 2),  -- Bedroom

-- Box 423 categories
(423, 1),  -- Kitchen
(423, 14), -- Fragile

-- Box 424 categories
(424, 5),  -- Office

-- Box 425 categories
(425, 3),  -- Bathroom

-- Box 426 categories
(426, 8),  -- Clothing

-- Box 427 categories
(427, 4),  -- Living Room

-- Box 428 categories
(428, 2),  -- Bedroom

-- Box 429 categories
(429, 6),  -- Electronics

-- Box 430 categories
(430, 1),  -- Kitchen

-- Box 431 categories
(431, 5),  -- Office

-- Box 432 categories
(432, 4),  -- Living Room

-- Box 433 categories
(433, 2),  -- Bedroom

-- Box 434 categories
(434, 8),  -- Clothing

-- Box 435 categories
(435, 1),  -- Kitchen

-- Box 436 categories
(436, 3),  -- Bathroom

-- Box 437 categories
(437, 5),  -- Office

-- Box 438 categories
(438, 6),  -- Electronics

-- Box 439 categories
(439, 10), -- Sports

-- Box 440 categories
(440, 11), -- Tools

-- Box 441 categories
(441, 4),  -- Living Room

-- Box 442 categories
(442, 2),  -- Bedroom

-- Box 443 categories
(443, 1),  -- Kitchen
(443, 14), -- Fragile

-- Box 444 categories
(444, 5),  -- Office

-- Box 445 categories
(445, 3),  -- Bathroom

-- Box 446 categories
(446, 8),  -- Clothing

-- Box 447 categories
(447, 4),  -- Living Room

-- Box 448 categories
(448, 2),  -- Bedroom

-- Box 449 categories
(449, 6),  -- Electronics

-- Box 450 categories
(450, 1),  -- Kitchen

-- Box 451 categories
(451, 5),  -- Office

-- Box 452 categories
(452, 4),  -- Living Room

-- Box 453 categories
(453, 2),  -- Bedroom

-- Box 454 categories
(454, 8),  -- Clothing

-- Box 455 categories
(455, 1),  -- Kitchen

-- Box 456 categories
(456, 3),  -- Bathroom

-- Box 457 categories
(457, 5),  -- Office

-- Box 458 categories
(458, 6),  -- Electronics

-- Box 459 categories
(459, 10), -- Sports

-- Box 460 categories
(460, 11), -- Tools

-- Box 461 categories
(461, 4),  -- Living Room

-- Box 462 categories
(462, 2),  -- Bedroom

-- Box 463 categories
(463, 1),  -- Kitchen
(463, 14), -- Fragile

-- Box 464 categories
(464, 5),  -- Office

-- Box 465 categories
(465, 3),  -- Bathroom

-- Box 466 categories
(466, 8),  -- Clothing

-- Box 467 categories
(467, 4),  -- Living Room

-- Box 468 categories
(468, 2),  -- Bedroom

-- Box 469 categories
(469, 6),  -- Electronics

-- Box 470 categories
(470, 1),  -- Kitchen

-- Box 471 categories
(471, 5),  -- Office

-- Box 472 categories
(472, 4),  -- Living Room

-- Box 473 categories
(473, 2),  -- Bedroom

-- Box 474 categories
(474, 8),  -- Clothing

-- Box 475 categories
(475, 1),  -- Kitchen

-- Box 476 categories
(476, 3),  -- Bathroom

-- Box 477 categories
(477, 5),  -- Office

-- Box 478 categories
(478, 6),  -- Electronics

-- Box 479 categories
(479, 10), -- Sports

-- Box 480 categories
(480, 11), -- Tools

-- Box 481 categories
(481, 4),  -- Living Room

-- Box 482 categories
(482, 2),  -- Bedroom

-- Box 483 categories
(483, 1),  -- Kitchen
(483, 14), -- Fragile

-- Box 484 categories
(484, 5),  -- Office

-- Box 485 categories
(485, 3),  -- Bathroom

-- Box 486 categories
(486, 8),  -- Clothing

-- Box 487 categories
(487, 4),  -- Living Room

-- Box 488 categories
(488, 2),  -- Bedroom

-- Box 489 categories
(489, 6),  -- Electronics

-- Box 490 categories
(490, 1),  -- Kitchen

-- Box 491 categories
(491, 5),  -- Office

-- Box 492 categories
(492, 4),  -- Living Room

-- Box 493 categories
(493, 2),  -- Bedroom

-- Box 494 categories
(494, 8),  -- Clothing

-- Box 495 categories
(495, 1),  -- Kitchen

-- Box 496 categories
(496, 3),  -- Bathroom

-- Box 497 categories
(497, 5),  -- Office

-- Box 498 categories
(498, 6),  -- Electronics

-- Box 499 categories
(499, 10), -- Sports

-- Box 500 categories
(500, 11), -- Tools

-- Box 501 categories
(501, 4),  -- Living Room

-- Box 502 categories
(502, 2),  -- Bedroom

-- Box 503 categories
(503, 1),  -- Kitchen
(503, 14), -- Fragile

-- Box 504 categories
(504, 5),  -- Office

-- Box 505 categories
(505, 3),  -- Bathroom

-- Box 506 categories
(506, 8),  -- Clothing

-- Box 507 categories
(507, 4),  -- Living Room

-- Box 508 categories
(508, 2),  -- Bedroom

-- Box 509 categories
(509, 6),  -- Electronics

-- Box 510 categories
(510, 1),  -- Kitchen

-- Box 511 categories
(511, 5),  -- Office

-- Box 512 categories
(512, 4),  -- Living Room

-- Box 513 categories
(513, 2),  -- Bedroom

-- Box 514 categories
(514, 8),  -- Clothing

-- Box 515 categories
(515, 1),  -- Kitchen

-- Box 516 categories
(516, 3),  -- Bathroom

-- Box 517 categories
(517, 5),  -- Office

-- Box 518 categories
(518, 6),  -- Electronics

-- Box 519 categories
(519, 10), -- Sports

-- Box 520 categories
(520, 11), -- Tools

-- Box 521 categories
(521, 4),  -- Living Room

-- Box 522 categories
(522, 2),  -- Bedroom

-- Box 523 categories
(523, 1),  -- Kitchen
(523, 14), -- Fragile

-- Box 524 categories
(524, 5),  -- Office

-- Box 525 categories
(525, 3),  -- Bathroom

-- Box 526 categories
(526, 8),  -- Clothing

-- Box 527 categories
(527, 4),  -- Living Room

-- Box 528 categories
(528, 2),  -- Bedroom

-- Box 529 categories
(529, 6),  -- Electronics

-- Box 530 categories
(530, 1),  -- Kitchen

-- Box 531 categories
(531, 5),  -- Office

-- Box 532 categories
(532, 4),  -- Living Room

-- Box 533 categories
(533, 2),  -- Bedroom

-- Box 534 categories
(534, 8),  -- Clothing

-- Box 535 categories
(535, 1),  -- Kitchen

-- Box 536 categories
(536, 3),  -- Bathroom

-- Box 537 categories
(537, 5),  -- Office

-- Box 538 categories
(538, 6),  -- Electronics

-- Box 539 categories
(539, 10), -- Sports

-- Box 540 categories
(540, 11), -- Tools

-- Box 541 categories
(541, 4),  -- Living Room

-- Box 542 categories
(542, 2),  -- Bedroom

-- Box 543 categories
(543, 1),  -- Kitchen
(543, 14), -- Fragile

-- Box 544 categories
(544, 5),  -- Office

-- Box 545 categories
(545, 3),  -- Bathroom

-- Box 546 categories
(546, 8),  -- Clothing

-- Box 547 categories
(547, 4),  -- Living Room

-- Box 548 categories
(548, 2),  -- Bedroom

-- Box 549 categories
(549, 6),  -- Electronics

-- Box 550 categories
(550, 1),  -- Kitchen

-- Box 551 categories
(551, 5),  -- Office

-- Box 552 categories
(552, 4),  -- Living Room

-- Box 553 categories
(553, 2),  -- Bedroom

-- Box 554 categories
(554, 8),  -- Clothing

-- Box 555 categories
(555, 1),  -- Kitchen

-- Box 556 categories
(556, 3),  -- Bathroom

-- Box 557 categories
(557, 5),  -- Office

-- Box 558 categories
(558, 6),  -- Electronics

-- Box 559 categories
(559, 10), -- Sports

-- Box 560 categories
(560, 11), -- Tools

-- Box 561 categories
(561, 4),  -- Living Room

-- Box 562 categories
(562, 2),  -- Bedroom

-- Box 563 categories
(563, 1),  -- Kitchen
(563, 14), -- Fragile

-- Box 564 categories
(564, 5),  -- Office

-- Box 565 categories
(565, 3),  -- Bathroom

-- Box 566 categories
(566, 8),  -- Clothing

-- Box 567 categories
(567, 4),  -- Living Room

-- Box 568 categories
(568, 2),  -- Bedroom

-- Box 569 categories
(569, 6),  -- Electronics

-- Box 570 categories
(570, 1),  -- Kitchen

-- Box 571 categories
(571, 5),  -- Office

-- Box 572 categories
(572, 4),  -- Living Room

-- Box 573 categories
(573, 2),  -- Bedroom

-- Box 574 categories
(574, 8),  -- Clothing

-- Box 575 categories
(575, 1),  -- Kitchen

-- Box 576 categories
(576, 3),  -- Bathroom

-- Box 577 categories
(577, 5),  -- Office

-- Box 578 categories
(578, 6),  -- Electronics

-- Box 579 categories
(579, 10), -- Sports

-- Box 580 categories
(580, 11), -- Tools

-- Box 581 categories
(581, 4),  -- Living Room

-- Box 582 categories
(582, 2),  -- Bedroom

-- Box 583 categories
(583, 1),  -- Kitchen
(583, 14), -- Fragile

-- Box 584 categories
(584, 5),  -- Office

-- Box 585 categories
(585, 3),  -- Bathroom

-- Box 586 categories
(586, 8),  -- Clothing

-- Box 587 categories
(587, 4),  -- Living Room

-- Box 588 categories
(588, 2),  -- Bedroom

-- Box 589 categories
(589, 6),  -- Electronics

-- Box 590 categories
(590, 1),  -- Kitchen

-- Box 591 categories
(591, 5),  -- Office

-- Box 592 categories
(592, 4),  -- Living Room

-- Box 593 categories
(593, 2),  -- Bedroom

-- Box 594 categories
(594, 8),  -- Clothing

-- Box 595 categories
(595, 1),  -- Kitchen

-- Box 596 categories
(596, 3),  -- Bathroom

-- Box 597 categories
(597, 5),  -- Office

-- Box 598 categories
(598, 6),  -- Electronics

-- Box 599 categories
(599, 10), -- Sports

-- Box 600 categories
(600, 11), -- Tools

-- Box 601 categories
(601, 4),  -- Living Room

-- Box 602 categories
(602, 2),  -- Bedroom

-- Box 603 categories
(603, 1),  -- Kitchen
(603, 14), -- Fragile

-- Box 604 categories
(604, 5),  -- Office

-- Box 605 categories
(605, 3),  -- Bathroom

-- Box 606 categories
(606, 8),  -- Clothing

-- Box 607 categories
(607, 4),  -- Living Room

-- Box 608 categories
(608, 2);  -- Bedroom


-- MOVE_UTILITIES TABLE
-- Each move gets 10+ utility service records

-- Error Code: 1062. Duplicate entry '49-5' for key 'move_utilities.PRIMARY'


INSERT INTO move_utilities (utility_id, move_id, account_number, stop_date, start_date, status) VALUES
-- Move 1 utilities (10 utilities)
(1, 1, 'ELEC-001-2024', '2024-03-14', '2024-03-16', 'active'),
(11, 1, 'GAS-001-2024', '2024-03-14', '2024-03-16', 'active'),
(21, 1, 'WATER-001-2024', '2024-03-14', '2024-03-16', 'active'),
(31, 1, 'INT-001-2024', '2024-03-14', '2024-03-17', 'active'),
(41, 1, 'TRASH-001-2024', '2024-03-14', '2024-03-20', 'active'),
(6, 1, 'ELEC-002-2024', NULL, '2024-03-16', 'active'),
(12, 1, 'GAS-002-2024', NULL, '2024-03-16', 'active'),
(22, 1, 'WATER-002-2024', NULL, '2024-03-16', 'active'),
(32, 1, 'INT-002-2024', NULL, '2024-03-17', 'active'),
(42, 1, 'TRASH-002-2024', NULL, '2024-03-20', 'active'),

-- Move 2 utilities (10 utilities)
(3, 2, 'ELEC-003-2024', '2024-05-19', '2024-05-21', 'active'),
(13, 2, 'GAS-003-2024', '2024-05-19', '2024-05-21', 'active'),
(23, 2, 'WATER-003-2024', '2024-05-19', '2024-05-21', 'active'),
(33, 2, 'INT-003-2024', '2024-05-19', '2024-05-22', 'active'),
(43, 2, 'TRASH-003-2024', '2024-05-19', '2024-05-25', 'active'),
(7, 2, 'ELEC-004-2024', NULL, '2024-05-21', 'active'),
(14, 2, 'GAS-004-2024', NULL, '2024-05-21', 'active'),
(24, 2, 'WATER-004-2024', NULL, '2024-05-21', 'active'),
(34, 2, 'INT-004-2024', NULL, '2024-05-22', 'active'),
(44, 2, 'TRASH-004-2024', NULL, '2024-05-25', 'active'),

-- Move 3 utilities (10 utilities)
(2, 3, 'ELEC-005-2024', '2024-06-09', '2024-06-11', 'active'),
(12, 3, 'GAS-005-2024', '2024-06-09', '2024-06-11', 'active'),
(22, 3, 'WATER-005-2024', '2024-06-09', '2024-06-11', 'active'),
(32, 3, 'INT-005-2024', '2024-06-09', '2024-06-12', 'active'),
(42, 3, 'TRASH-005-2024', '2024-06-09', '2024-06-15', 'active'),
(6, 3, 'ELEC-006-2024', NULL, '2024-06-11', 'active'),
(16, 3, 'GAS-006-2024', NULL, '2024-06-11', 'active'),
(26, 3, 'WATER-006-2024', NULL, '2024-06-11', 'active'),
(36, 3, 'INT-006-2024', NULL, '2024-06-12', 'active'),
(46, 3, 'TRASH-006-2024', NULL, '2024-06-15', 'active'),

-- Move 4 utilities (11 utilities)
(1, 4, 'ELEC-007-2024', '2024-07-31', '2024-08-02', 'confirmed'),
(11, 4, 'GAS-007-2024', '2024-07-31', '2024-08-02', 'confirmed'),
(21, 4, 'WATER-007-2024', '2024-07-31', '2024-08-02', 'confirmed'),
(31, 4, 'INT-007-2024', '2024-07-31', '2024-08-03', 'confirmed'),
(41, 4, 'TRASH-007-2024', '2024-07-31', '2024-08-05', 'confirmed'),
(6, 4, 'ELEC-008-2024', NULL, '2024-08-02', 'confirmed'),
(12, 4, 'GAS-008-2024', NULL, '2024-08-02', 'confirmed'),
(22, 4, 'WATER-008-2024', NULL, '2024-08-02', 'confirmed'),
(32, 4, 'INT-008-2024', NULL, '2024-08-03', 'confirmed'),
(42, 4, 'TRASH-008-2024', NULL, '2024-08-05', 'confirmed'),
(51, 4, 'SEC-001-2024', NULL, '2024-08-02', 'confirmed'),

-- Move 5 utilities (10 utilities)
(2, 5, 'ELEC-009-2024', '2024-09-11', '2024-09-13', 'requested'),
(12, 5, 'GAS-009-2024', '2024-09-11', '2024-09-13', 'requested'),
(22, 5, 'WATER-009-2024', '2024-09-11', '2024-09-13', 'requested'),
(32, 5, 'INT-009-2024', '2024-09-11', '2024-09-14', 'requested'),
(42, 5, 'TRASH-009-2024', '2024-09-11', '2024-09-15', 'requested'),
(6, 5, 'ELEC-010-2024', NULL, '2024-09-13', 'planned'),
(16, 5, 'GAS-010-2024', NULL, '2024-09-13', 'planned'),
(26, 5, 'WATER-010-2024', NULL, '2024-09-13', 'planned'),
(36, 5, 'INT-010-2024', NULL, '2024-09-14', 'planned'),
(46, 5, 'TRASH-010-2024', NULL, '2024-09-15', 'planned'),

-- Move 6 utilities (11 utilities)
(1, 6, 'ELEC-011-2024', '2024-10-04', '2024-10-06', 'requested'),
(11, 6, 'GAS-011-2024', '2024-10-04', '2024-10-06', 'requested'),
(21, 6, 'WATER-011-2024', '2024-10-04', '2024-10-06', 'requested'),
(31, 6, 'INT-011-2024', '2024-10-04', '2024-10-07', 'requested'),
(41, 6, 'TRASH-011-2024', '2024-10-04', '2024-10-08', 'requested'),
(6, 6, 'ELEC-012-2024', NULL, '2024-10-06', 'planned'),
(12, 6, 'GAS-012-2024', NULL, '2024-10-06', 'planned'),
(22, 6, 'WATER-012-2024', NULL, '2024-10-06', 'planned'),
(32, 6, 'INT-012-2024', NULL, '2024-10-07', 'planned'),
(42, 6, 'TRASH-012-2024', NULL, '2024-10-08', 'planned'),
(52, 6, 'SEC-002-2024', NULL, '2024-10-06', 'planned'),

-- Move 7 utilities (10 utilities)
(1, 7, 'ELEC-013-2024', '2024-11-19', '2024-11-21', 'planned'),
(11, 7, 'GAS-013-2024', '2024-11-19', '2024-11-21', 'planned'),
(21, 7, 'WATER-013-2024', '2024-11-19', '2024-11-21', 'planned'),
(31, 7, 'INT-013-2024', '2024-11-19', '2024-11-22', 'planned'),
(41, 7, 'TRASH-013-2024', '2024-11-19', '2024-11-25', 'planned'),
(6, 7, 'ELEC-014-2024', NULL, '2024-11-21', 'planned'),
(12, 7, 'GAS-014-2024', NULL, '2024-11-21', 'planned'),
(22, 7, 'WATER-014-2024', NULL, '2024-11-21', 'planned'),
(32, 7, 'INT-014-2024', NULL, '2024-11-22', 'planned'),
(42, 7, 'TRASH-014-2024', NULL, '2024-11-25', 'planned'),

-- Move 8 utilities (11 utilities)
(2, 8, 'ELEC-015-2024', '2024-12-14', '2024-12-16', 'planned'),
(12, 8, 'GAS-015-2024', '2024-12-14', '2024-12-16', 'planned'),
(22, 8, 'WATER-015-2024', '2024-12-14', '2024-12-16', 'planned'),
(32, 8, 'INT-015-2024', '2024-12-14', '2024-12-17', 'planned'),
(42, 8, 'TRASH-015-2024', '2024-12-14', '2024-12-18', 'planned'),
(7, 8, 'ELEC-016-2024', NULL, '2024-12-16', 'planned'),
(17, 8, 'GAS-016-2024', NULL, '2024-12-16', 'planned'),
(27, 8, 'WATER-016-2024', NULL, '2024-12-16', 'planned'),
(37, 8, 'INT-016-2024', NULL, '2024-12-17', 'planned'),
(47, 8, 'TRASH-016-2024', NULL, '2024-12-18', 'planned'),
(51, 8, 'SEC-003-2024', NULL, '2024-12-16', 'planned'),

-- Move 9 utilities (10 utilities)
(1, 9, 'ELEC-017-2025', '2025-01-09', '2025-01-11', 'planned'),
(11, 9, 'GAS-017-2025', '2025-01-09', '2025-01-11', 'planned'),
(21, 9, 'WATER-017-2025', '2025-01-09', '2025-01-11', 'planned'),
(31, 9, 'INT-017-2025', '2025-01-09', '2025-01-12', 'planned'),
(41, 9, 'TRASH-017-2025', '2025-01-09', '2025-01-13', 'planned'),
(6, 9, 'ELEC-018-2025', NULL, '2025-01-11', 'planned'),
(12, 9, 'GAS-018-2025', NULL, '2025-01-11', 'planned'),
(22, 9, 'WATER-018-2025', NULL, '2025-01-11', 'planned'),
(32, 9, 'INT-018-2025', NULL, '2025-01-12', 'planned'),
(42, 9, 'TRASH-018-2025', NULL, '2025-01-13', 'planned'),

-- Move 10 utilities (11 utilities)
(1, 10, 'ELEC-019-2025', '2025-02-13', '2025-02-15', 'planned'),
(11, 10, 'GAS-019-2025', '2025-02-13', '2025-02-15', 'planned'),
(21, 10, 'WATER-019-2025', '2025-02-13', '2025-02-15', 'planned'),
(31, 10, 'INT-019-2025', '2025-02-13', '2025-02-16', 'planned'),
(41, 10, 'TRASH-019-2025', '2025-02-13', '2025-02-18', 'planned'),
(6, 10, 'ELEC-020-2025', NULL, '2025-02-15', 'planned'),
(12, 10, 'GAS-020-2025', NULL, '2025-02-15', 'planned'),
(22, 10, 'WATER-020-2025', NULL, '2025-02-15', 'planned'),
(32, 10, 'INT-020-2025', NULL, '2025-02-16', 'planned'),
(42, 10, 'TRASH-020-2025', NULL, '2025-02-18', 'planned'),
(52, 10, 'SEC-004-2025', NULL, '2025-02-15', 'planned'),

-- Move 11 utilities (10 utilities)
(2, 11, 'ELEC-021-2025', '2025-02-28', '2025-03-02', 'planned'),
(12, 11, 'GAS-021-2025', '2025-02-28', '2025-03-02', 'planned'),
(22, 11, 'WATER-021-2025', '2025-02-28', '2025-03-02', 'planned'),
(32, 11, 'INT-021-2025', '2025-02-28', '2025-03-03', 'planned'),
(42, 11, 'TRASH-021-2025', '2025-02-28', '2025-03-05', 'planned'),
(7, 11, 'ELEC-022-2025', NULL, '2025-03-02', 'planned'),
(17, 11, 'GAS-022-2025', NULL, '2025-03-02', 'planned'),
(27, 11, 'WATER-022-2025', NULL, '2025-03-02', 'planned'),
(37, 11, 'INT-022-2025', NULL, '2025-03-03', 'planned'),
(47, 11, 'TRASH-022-2025', NULL, '2025-03-05', 'planned'),

-- Move 12 utilities (11 utilities)
(2, 12, 'ELEC-023-2024', '2024-02-27', '2024-02-29', 'active'),
(12, 12, 'GAS-023-2024', '2024-02-27', '2024-02-29', 'active'),
(22, 12, 'WATER-023-2024', '2024-02-27', '2024-02-29', 'active'),
(32, 12, 'INT-023-2024', '2024-02-27', '2024-03-01', 'active'),
(42, 12, 'TRASH-023-2024', '2024-02-27', '2024-03-03', 'active'),
(3, 12, 'ELEC-024-2024', NULL, '2024-02-29', 'active'),
(13, 12, 'GAS-024-2024', NULL, '2024-02-29', 'active'),
(23, 12, 'WATER-024-2024', NULL, '2024-02-29', 'active'),
(33, 12, 'INT-024-2024', NULL, '2024-03-01', 'active'),
(43, 12, 'TRASH-024-2024', NULL, '2024-03-03', 'active'),
(51, 12, 'SEC-005-2024', NULL, '2024-02-29', 'active'),

-- Move 13 utilities (10 utilities)
(2, 13, 'ELEC-025-2024', '2024-04-17', '2024-04-19', 'active'),
(12, 13, 'GAS-025-2024', '2024-04-17', '2024-04-19', 'active'),
(22, 13, 'WATER-025-2024', '2024-04-17', '2024-04-19', 'active'),
(32, 13, 'INT-025-2024', '2024-04-17', '2024-04-20', 'active'),
(42, 13, 'TRASH-025-2024', '2024-04-17', '2024-04-22', 'active'),
(3, 13, 'ELEC-026-2024', NULL, '2024-04-19', 'active'),
(13, 13, 'GAS-026-2024', NULL, '2024-04-19', 'active'),
(23, 13, 'WATER-026-2024', NULL, '2024-04-19', 'active'),
(33, 13, 'INT-026-2024', NULL, '2024-04-20', 'active'),
(43, 13, 'TRASH-026-2024', NULL, '2024-04-22', 'active'),

-- Move 14 utilities (11 utilities)
(2, 14, 'ELEC-027-2024', '2024-06-04', '2024-06-06', 'active'),
(12, 14, 'GAS-027-2024', '2024-06-04', '2024-06-06', 'active'),
(22, 14, 'WATER-027-2024', '2024-06-04', '2024-06-06', 'active'),
(32, 14, 'INT-027-2024', '2024-06-04', '2024-06-07', 'active'),
(42, 14, 'TRASH-027-2024', '2024-06-04', '2024-06-08', 'active'),
(3, 14, 'ELEC-028-2024', NULL, '2024-06-06', 'active'),
(13, 14, 'GAS-028-2024', NULL, '2024-06-06', 'active'),
(23, 14, 'WATER-028-2024', NULL, '2024-06-06', 'active'),
(33, 14, 'INT-028-2024', NULL, '2024-06-07', 'active'),
(43, 14, 'TRASH-028-2024', NULL, '2024-06-08', 'active'),
(52, 14, 'SEC-006-2024', NULL, '2024-06-06', 'active'),

-- Move 15 utilities (10 utilities)
(2, 15, 'ELEC-029-2024', '2024-07-21', '2024-07-23', 'confirmed'),
(12, 15, 'GAS-029-2024', '2024-07-21', '2024-07-23', 'confirmed'),
(22, 15, 'WATER-029-2024', '2024-07-21', '2024-07-23', 'confirmed'),
(32, 15, 'INT-029-2024', '2024-07-21', '2024-07-24', 'confirmed'),
(42, 15, 'TRASH-029-2024', '2024-07-21', '2024-07-25', 'confirmed'),
(3, 15, 'ELEC-030-2024', NULL, '2024-07-23', 'confirmed'),
(13, 15, 'GAS-030-2024', NULL, '2024-07-23', 'confirmed'),
(23, 15, 'WATER-030-2024', NULL, '2024-07-23', 'confirmed'),
(33, 15, 'INT-030-2024', NULL, '2024-07-24', 'confirmed'),
(43, 15, 'TRASH-030-2024', NULL, '2024-07-25', 'confirmed'),

-- Move 16 utilities (11 utilities)
(2, 16, 'ELEC-031-2024', '2024-08-29', '2024-08-31', 'requested'),
(12, 16, 'GAS-031-2024', '2024-08-29', '2024-08-31', 'requested'),
(22, 16, 'WATER-031-2024', '2024-08-29', '2024-08-31', 'requested'),
(32, 16, 'INT-031-2024', '2024-08-29', '2024-09-01', 'requested'),
(42, 16, 'TRASH-031-2024', '2024-08-29', '2024-09-02', 'requested'),
(3, 16, 'ELEC-032-2024', NULL, '2024-08-31', 'planned'),
(13, 16, 'GAS-032-2024', NULL, '2024-08-31', 'planned'),
(23, 16, 'WATER-032-2024', NULL, '2024-08-31', 'planned'),
(33, 16, 'INT-032-2024', NULL, '2024-09-01', 'planned'),
(43, 16, 'TRASH-032-2024', NULL, '2024-09-02', 'planned'),
(51, 16, 'SEC-007-2024', NULL, '2024-08-31', 'planned'),

-- Move 17 utilities (10 utilities)
(2, 17, 'ELEC-033-2024', '2024-10-11', '2024-10-13', 'requested'),
(12, 17, 'GAS-033-2024', '2024-10-11', '2024-10-13', 'requested'),
(22, 17, 'WATER-033-2024', '2024-10-11', '2024-10-13', 'requested'),
(32, 17, 'INT-033-2024', '2024-10-11', '2024-10-14', 'requested'),
(42, 17, 'TRASH-033-2024', '2024-10-11', '2024-10-15', 'requested'),
(3, 17, 'ELEC-034-2024', NULL, '2024-10-13', 'planned'),
(13, 17, 'GAS-034-2024', NULL, '2024-10-13', 'planned'),
(23, 17, 'WATER-034-2024', NULL, '2024-10-13', 'planned'),
(33, 17, 'INT-034-2024', NULL, '2024-10-14', 'planned'),
(43, 17, 'TRASH-034-2024', NULL, '2024-10-15', 'planned'),

-- Move 18 utilities (11 utilities)
(2, 18, 'ELEC-035-2024', '2024-11-07', '2024-11-09', 'planned'),
(12, 18, 'GAS-035-2024', '2024-11-07', '2024-11-09', 'planned'),
(22, 18, 'WATER-035-2024', '2024-11-07', '2024-11-09', 'planned'),
(32, 18, 'INT-035-2024', '2024-11-07', '2024-11-10', 'planned'),
(42, 18, 'TRASH-035-2024', '2024-11-07', '2024-11-11', 'planned'),
(3, 18, 'ELEC-036-2024', NULL, '2024-11-09', 'planned'),
(13, 18, 'GAS-036-2024', NULL, '2024-11-09', 'planned'),
(23, 18, 'WATER-036-2024', NULL, '2024-11-09', 'planned'),
(33, 18, 'INT-036-2024', NULL, '2024-11-10', 'planned'),
(43, 18, 'TRASH-036-2024', NULL, '2024-11-11', 'planned'),
(52, 18, 'SEC-008-2024', NULL, '2024-11-09', 'planned'),

-- Move 19 utilities (10 utilities)
(2, 19, 'ELEC-037-2024', '2024-12-19', '2024-12-21', 'planned'),
(12, 19, 'GAS-037-2024', '2024-12-19', '2024-12-21', 'planned'),
(22, 19, 'WATER-037-2024', '2024-12-19', '2024-12-21', 'planned'),
(32, 19, 'INT-037-2024', '2024-12-19', '2024-12-22', 'planned'),
(42, 19, 'TRASH-037-2024', '2024-12-19', '2024-12-23', 'planned'),
(3, 19, 'ELEC-038-2024', NULL, '2024-12-21', 'planned'),
(13, 19, 'GAS-038-2024', NULL, '2024-12-21', 'planned'),
(23, 19, 'WATER-038-2024', NULL, '2024-12-21', 'planned'),
(33, 19, 'INT-038-2024', NULL, '2024-12-22', 'planned'),
(43, 19, 'TRASH-038-2024', NULL, '2024-12-23', 'planned'),

-- Move 20 utilities (11 utilities)
(2, 20, 'ELEC-039-2025', '2025-01-24', '2025-01-26', 'planned'),
(12, 20, 'GAS-039-2025', '2025-01-24', '2025-01-26', 'planned'),
(22, 20, 'WATER-039-2025', '2025-01-24', '2025-01-26', 'planned'),
(32, 20, 'INT-039-2025', '2025-01-24', '2025-01-27', 'planned'),
(42, 20, 'TRASH-039-2025', '2025-01-24', '2025-01-28', 'planned'),
(3, 20, 'ELEC-040-2025', NULL, '2025-01-26', 'planned'),
(13, 20, 'GAS-040-2025', NULL, '2025-01-26', 'planned'),
(23, 20, 'WATER-040-2025', NULL, '2025-01-26', 'planned'),
(33, 20, 'INT-040-2025', NULL, '2025-01-27', 'planned'),
(43, 20, 'TRASH-040-2025', NULL, '2025-01-28', 'planned'),
(51, 20, 'SEC-009-2025', NULL, '2025-01-26', 'planned'),

-- Move 21 utilities (10 utilities)
(2, 21, 'ELEC-041-2025', '2025-02-27', '2025-03-01', 'planned'),
(12, 21, 'GAS-041-2025', '2025-02-27', '2025-03-01', 'planned'),
(22, 21, 'WATER-041-2025', '2025-02-27', '2025-03-01', 'planned'),
(32, 21, 'INT-041-2025', '2025-02-27', '2025-03-02', 'planned'),
(42, 21, 'TRASH-041-2025', '2025-02-27', '2025-03-03', 'planned'),
(3, 21, 'ELEC-042-2025', NULL, '2025-03-01', 'planned'),
(13, 21, 'GAS-042-2025', NULL, '2025-03-01', 'planned'),
(23, 21, 'WATER-042-2025', NULL, '2025-03-01', 'planned'),
(33, 21, 'INT-042-2025', NULL, '2025-03-02', 'planned'),
(43, 21, 'TRASH-042-2025', NULL, '2025-03-03', 'planned'),

-- Move 22 utilities (11 utilities)
(2, 22, 'ELEC-043-2025', '2025-03-14', '2025-03-16', 'planned'),
(12, 22, 'GAS-043-2025', '2025-03-14', '2025-03-16', 'planned'),
(22, 22, 'WATER-043-2025', '2025-03-14', '2025-03-16', 'planned'),
(32, 22, 'INT-043-2025', '2025-03-14', '2025-03-17', 'planned'),
(42, 22, 'TRASH-043-2025', '2025-03-14', '2025-03-18', 'planned'),
(3, 22, 'ELEC-044-2025', NULL, '2025-03-16', 'planned'),
(13, 22, 'GAS-044-2025', NULL, '2025-03-16', 'planned'),
(23, 22, 'WATER-044-2025', NULL, '2025-03-16', 'planned'),
(33, 22, 'INT-044-2025', NULL, '2025-03-17', 'planned'),
(43, 22, 'TRASH-044-2025', NULL, '2025-03-18', 'planned'),
(52, 22, 'SEC-010-2025', NULL, '2025-03-16', 'planned'),

-- Move 23 utilities (10 utilities)
(3, 23, 'ELEC-045-2024', '2024-03-09', '2024-03-11', 'active'),
(13, 23, 'GAS-045-2024', '2024-03-09', '2024-03-11', 'active'),
(23, 23, 'WATER-045-2024', '2024-03-09', '2024-03-11', 'active'),
(33, 23, 'INT-045-2024', '2024-03-09', '2024-03-12', 'active'),
(43, 23, 'TRASH-045-2024', '2024-03-09', '2024-03-13', 'active'),
(4, 23, 'ELEC-046-2024', NULL, '2024-03-11', 'active'),
(14, 23, 'GAS-046-2024', NULL, '2024-03-11', 'active'),
(24, 23, 'WATER-046-2024', NULL, '2024-03-11', 'active'),
(34, 23, 'INT-046-2024', NULL, '2024-03-12', 'active'),
(44, 23, 'TRASH-046-2024', NULL, '2024-03-13', 'active'),

-- Move 24 utilities (11 utilities)
(3, 24, 'ELEC-047-2024', '2024-05-14', '2024-05-16', 'active'),
(13, 24, 'GAS-047-2024', '2024-05-14', '2024-05-16', 'active'),
(23, 24, 'WATER-047-2024', '2024-05-14', '2024-05-16', 'active'),
(33, 24, 'INT-047-2024', '2024-05-14', '2024-05-17', 'active'),
(43, 24, 'TRASH-047-2024', '2024-05-14', '2024-05-18', 'active'),
(4, 24, 'ELEC-048-2024', NULL, '2024-05-16', 'active'),
(14, 24, 'GAS-048-2024', NULL, '2024-05-16', 'active'),
(24, 24, 'WATER-048-2024', NULL, '2024-05-16', 'active'),
(34, 24, 'INT-048-2024', NULL, '2024-05-17', 'active'),
(44, 24, 'TRASH-048-2024', NULL, '2024-05-18', 'active'),
(51, 24, 'SEC-011-2024', NULL, '2024-05-16', 'active'),

-- Move 25 utilities (10 utilities)
(3, 25, 'ELEC-049-2024', '2024-06-21', '2024-06-23', 'active'),
(13, 25, 'GAS-049-2024', '2024-06-21', '2024-06-23', 'active'),
(23, 25, 'WATER-049-2024', '2024-06-21', '2024-06-23', 'active'),
(33, 25, 'INT-049-2024', '2024-06-21', '2024-06-24', 'active'),
(43, 25, 'TRASH-049-2024', '2024-06-21', '2024-06-25', 'active'),
(4, 25, 'ELEC-050-2024', NULL, '2024-06-23', 'active'),
(14, 25, 'GAS-050-2024', NULL, '2024-06-23', 'active'),
(24, 25, 'WATER-050-2024', NULL, '2024-06-23', 'active'),
(34, 25, 'INT-050-2024', NULL, '2024-06-24', 'active'),
(44, 25, 'TRASH-050-2024', NULL, '2024-06-25', 'active'),

-- Move 26 utilities (11 utilities)
(3, 26, 'ELEC-051-2024', '2024-08-07', '2024-08-09', 'confirmed'),
(13, 26, 'GAS-051-2024', '2024-08-07', '2024-08-09', 'confirmed'),
(23, 26, 'WATER-051-2024', '2024-08-07', '2024-08-09', 'confirmed'),
(33, 26, 'INT-051-2024', '2024-08-07', '2024-08-10', 'confirmed'),
(43, 26, 'TRASH-051-2024', '2024-08-07', '2024-08-11', 'confirmed'),
(4, 26, 'ELEC-052-2024', NULL, '2024-08-09', 'confirmed'),
(14, 26, 'GAS-052-2024', NULL, '2024-08-09', 'confirmed'),
(24, 26, 'WATER-052-2024', NULL, '2024-08-09', 'confirmed'),
(34, 26, 'INT-052-2024', NULL, '2024-08-10', 'confirmed'),
(44, 26, 'TRASH-052-2024', NULL, '2024-08-11', 'confirmed'),
(52, 26, 'SEC-012-2024', NULL, '2024-08-09', 'confirmed'),

-- Move 27 utilities (10 utilities)
(3, 27, 'ELEC-053-2024', '2024-09-17', '2024-09-19', 'requested'),
(13, 27, 'GAS-053-2024', '2024-09-17', '2024-09-19', 'requested'),
(23, 27, 'WATER-053-2024', '2024-09-17', '2024-09-19', 'requested'),
(33, 27, 'INT-053-2024', '2024-09-17', '2024-09-20', 'requested'),
(43, 27, 'TRASH-053-2024', '2024-09-17', '2024-09-21', 'requested'),
(4, 27, 'ELEC-054-2024', NULL, '2024-09-19', 'planned'),
(14, 27, 'GAS-054-2024', NULL, '2024-09-19', 'planned'),
(24, 27, 'WATER-054-2024', NULL, '2024-09-19', 'planned'),
(34, 27, 'INT-054-2024', NULL, '2024-09-20', 'planned'),
(44, 27, 'TRASH-054-2024', NULL, '2024-09-21', 'planned'),

-- Move 28 utilities (11 utilities)
(3, 28, 'ELEC-055-2024', '2024-10-24', '2024-10-26', 'requested'),
(13, 28, 'GAS-055-2024', '2024-10-24', '2024-10-26', 'requested'),
(23, 28, 'WATER-055-2024', '2024-10-24', '2024-10-26', 'requested'),
(33, 28, 'INT-055-2024', '2024-10-24', '2024-10-27', 'requested'),
(43, 28, 'TRASH-055-2024', '2024-10-24', '2024-10-28', 'requested'),
(4, 28, 'ELEC-056-2024', NULL, '2024-10-26', 'planned'),
(14, 28, 'GAS-056-2024', NULL, '2024-10-26', 'planned'),
(24, 28, 'WATER-056-2024', NULL, '2024-10-26', 'planned'),
(34, 28, 'INT-056-2024', NULL, '2024-10-27', 'planned'),
(44, 28, 'TRASH-056-2024', NULL, '2024-10-28', 'planned'),
(51, 28, 'SEC-013-2024', NULL, '2024-10-26', 'planned'),

-- Move 29 utilities (10 utilities)
(3, 29, 'ELEC-057-2024', '2024-11-29', '2024-12-01', 'planned'),
(13, 29, 'GAS-057-2024', '2024-11-29', '2024-12-01', 'planned'),
(23, 29, 'WATER-057-2024', '2024-11-29', '2024-12-01', 'planned'),
(33, 29, 'INT-057-2024', '2024-11-29', '2024-12-02', 'planned'),
(43, 29, 'TRASH-057-2024', '2024-11-29', '2024-12-03', 'planned'),
(4, 29, 'ELEC-058-2024', NULL, '2024-12-01', 'planned'),
(14, 29, 'GAS-058-2024', NULL, '2024-12-01', 'planned'),
(24, 29, 'WATER-058-2024', NULL, '2024-12-01', 'planned'),
(34, 29, 'INT-058-2024', NULL, '2024-12-02', 'planned'),
(44, 29, 'TRASH-058-2024', NULL, '2024-12-03', 'planned'),

-- Move 30 utilities (11 utilities)
(3, 30, 'ELEC-059-2024', '2024-12-09', '2024-12-11', 'planned'),
(13, 30, 'GAS-059-2024', '2024-12-09', '2024-12-11', 'planned'),
(23, 30, 'WATER-059-2024', '2024-12-09', '2024-12-11', 'planned'),
(33, 30, 'INT-059-2024', '2024-12-09', '2024-12-12', 'planned'),
(43, 30, 'TRASH-059-2024', '2024-12-09', '2024-12-13', 'planned'),
(4, 30, 'ELEC-060-2024', NULL, '2024-12-11', 'planned'),
(14, 30, 'GAS-060-2024', NULL, '2024-12-11', 'planned'),
(24, 30, 'WATER-060-2024', NULL, '2024-12-11', 'planned'),
(34, 30, 'INT-060-2024', NULL, '2024-12-12', 'planned'),
(44, 30, 'TRASH-060-2024', NULL, '2024-12-13', 'planned'),
(52, 30, 'SEC-014-2024', NULL, '2024-12-11', 'planned'),

-- Move 31 utilities (10 utilities)
(3, 31, 'ELEC-061-2025', '2025-01-19', '2025-01-21', 'planned'),
(13, 31, 'GAS-061-2025', '2025-01-19', '2025-01-21', 'planned'),
(23, 31, 'WATER-061-2025', '2025-01-19', '2025-01-21', 'planned'),
(33, 31, 'INT-061-2025', '2025-01-19', '2025-01-22', 'planned'),
(43, 31, 'TRASH-061-2025', '2025-01-19', '2025-01-23', 'planned'),
(4, 31, 'ELEC-062-2025', NULL, '2025-01-21', 'planned'),
(14, 31, 'GAS-062-2025', NULL, '2025-01-21', 'planned'),
(24, 31, 'WATER-062-2025', NULL, '2025-01-21', 'planned'),
(34, 31, 'INT-062-2025', NULL, '2025-01-22', 'planned'),
(44, 31, 'TRASH-062-2025', NULL, '2025-01-23', 'planned'),

-- Move 32 utilities (11 utilities)
(3, 32, 'ELEC-063-2025', '2025-02-17', '2025-02-19', 'planned'),
(13, 32, 'GAS-063-2025', '2025-02-17', '2025-02-19', 'planned'),
(23, 32, 'WATER-063-2025', '2025-02-17', '2025-02-19', 'planned'),
(33, 32, 'INT-063-2025', '2025-02-17', '2025-02-20', 'planned'),
(43, 32, 'TRASH-063-2025', '2025-02-17', '2025-02-21', 'planned'),
(4, 32, 'ELEC-064-2025', NULL, '2025-02-19', 'planned'),
(14, 32, 'GAS-064-2025', NULL, '2025-02-19', 'planned'),
(24, 32, 'WATER-064-2025', NULL, '2025-02-19', 'planned'),
(34, 32, 'INT-064-2025', NULL, '2025-02-20', 'planned'),
(44, 32, 'TRASH-064-2025', NULL, '2025-02-21', 'planned'),
(51, 32, 'SEC-015-2025', NULL, '2025-02-19', 'planned'),

-- Move 33 utilities (10 utilities)
(3, 33, 'ELEC-065-2025', '2025-03-21', '2025-03-23', 'planned'),
(13, 33, 'GAS-065-2025', '2025-03-21', '2025-03-23', 'planned'),
(23, 33, 'WATER-065-2025', '2025-03-21', '2025-03-23', 'planned'),
(33, 33, 'INT-065-2025', '2025-03-21', '2025-03-24', 'planned'),
(43, 33, 'TRASH-065-2025', '2025-03-21', '2025-03-25', 'planned'),
(4, 33, 'ELEC-066-2025', NULL, '2025-03-23', 'planned'),
(14, 33, 'GAS-066-2025', NULL, '2025-03-23', 'planned'),
(24, 33, 'WATER-066-2025', NULL, '2025-03-23', 'planned'),
(34, 33, 'INT-066-2025', NULL, '2025-03-24', 'planned'),
(44, 33, 'TRASH-066-2025', NULL, '2025-03-25', 'planned'),

-- Move 34 utilities (11 utilities)
(4, 34, 'ELEC-067-2024', '2024-02-14', '2024-02-16', 'active'),
(14, 34, 'GAS-067-2024', '2024-02-14', '2024-02-16', 'active'),
(24, 34, 'WATER-067-2024', '2024-02-14', '2024-02-16', 'active'),
(34, 34, 'INT-067-2024', '2024-02-14', '2024-02-17', 'active'),
(44, 34, 'TRASH-067-2024', '2024-02-14', '2024-02-18', 'active'),
(5, 34, 'ELEC-068-2024', NULL, '2024-02-16', 'active'),
(15, 34, 'GAS-068-2024', NULL, '2024-02-16', 'active'),
(25, 34, 'WATER-068-2024', NULL, '2024-02-16', 'active'),
(35, 34, 'INT-068-2024', NULL, '2024-02-17', 'active'),
(45, 34, 'TRASH-068-2024', NULL, '2024-02-18', 'active'),
(52, 34, 'SEC-016-2024', NULL, '2024-02-16', 'active'),

-- Move 35 utilities (10 utilities)
(4, 35, 'ELEC-069-2024', '2024-04-24', '2024-04-26', 'active'),
(14, 35, 'GAS-069-2024', '2024-04-24', '2024-04-26', 'active'),
(24, 35, 'WATER-069-2024', '2024-04-24', '2024-04-26', 'active'),
(34, 35, 'INT-069-2024', '2024-04-24', '2024-04-27', 'active'),
(44, 35, 'TRASH-069-2024', '2024-04-24', '2024-04-28', 'active'),
(5, 35, 'ELEC-070-2024', NULL, '2024-04-26', 'active'),
(15, 35, 'GAS-070-2024', NULL, '2024-04-26', 'active'),
(25, 35, 'WATER-070-2024', NULL, '2024-04-26', 'active'),
(35, 35, 'INT-070-2024', NULL, '2024-04-27', 'active'),
(45, 35, 'TRASH-070-2024', NULL, '2024-04-28', 'active'),

-- Move 36 utilities (11 utilities)
(4, 36, 'ELEC-071-2024', '2024-06-11', '2024-06-13', 'active'),
(14, 36, 'GAS-071-2024', '2024-06-11', '2024-06-13', 'active'),
(24, 36, 'WATER-071-2024', '2024-06-11', '2024-06-13', 'active'),
(34, 36, 'INT-071-2024', '2024-06-11', '2024-06-14', 'active'),
(44, 36, 'TRASH-071-2024', '2024-06-11', '2024-06-15', 'active'),
(5, 36, 'ELEC-072-2024', NULL, '2024-06-13', 'active'),
(15, 36, 'GAS-072-2024', NULL, '2024-06-13', 'active'),
(25, 36, 'WATER-072-2024', NULL, '2024-06-13', 'active'),
(35, 36, 'INT-072-2024', NULL, '2024-06-14', 'active'),
(45, 36, 'TRASH-072-2024', NULL, '2024-06-15', 'active'),
(51, 36, 'SEC-017-2024', NULL, '2024-06-13', 'active'),

-- Move 37 utilities (10 utilities)
(4, 37, 'ELEC-073-2024', '2024-07-29', '2024-07-31', 'confirmed'),
(14, 37, 'GAS-073-2024', '2024-07-29', '2024-07-31', 'confirmed'),
(24, 37, 'WATER-073-2024', '2024-07-29', '2024-07-31', 'confirmed'),
(34, 37, 'INT-073-2024', '2024-07-29', '2024-08-01', 'confirmed'),
(44, 37, 'TRASH-073-2024', '2024-07-29', '2024-08-02', 'confirmed'),
(5, 37, 'ELEC-074-2024', NULL, '2024-07-31', 'confirmed'),
(15, 37, 'GAS-074-2024', NULL, '2024-07-31', 'confirmed'),
(25, 37, 'WATER-074-2024', NULL, '2024-07-31', 'confirmed'),
(35, 37, 'INT-074-2024', NULL, '2024-08-01', 'confirmed'),
(45, 37, 'TRASH-074-2024', NULL, '2024-08-02', 'confirmed'),

-- Move 38 utilities (11 utilities)
(4, 38, 'ELEC-075-2024', '2024-09-04', '2024-09-06', 'requested'),
(14, 38, 'GAS-075-2024', '2024-09-04', '2024-09-06', 'requested'),
(24, 38, 'WATER-075-2024', '2024-09-04', '2024-09-06', 'requested'),
(34, 38, 'INT-075-2024', '2024-09-04', '2024-09-07', 'requested'),
(44, 38, 'TRASH-075-2024', '2024-09-04', '2024-09-08', 'requested'),
(5, 38, 'ELEC-076-2024', NULL, '2024-09-06', 'planned'),
(15, 38, 'GAS-076-2024', NULL, '2024-09-06', 'planned'),
(25, 38, 'WATER-076-2024', NULL, '2024-09-06', 'planned'),
(35, 38, 'INT-076-2024', NULL, '2024-09-07', 'planned'),
(45, 38, 'TRASH-076-2024', NULL, '2024-09-08', 'planned'),
(52, 38, 'SEC-018-2024', NULL, '2024-09-06', 'planned'),

-- Move 39 utilities (10 utilities)
(4, 39, 'ELEC-077-2024', '2024-10-17', '2024-10-19', 'requested'),
(14, 39, 'GAS-077-2024', '2024-10-17', '2024-10-19', 'requested'),
(24, 39, 'WATER-077-2024', '2024-10-17', '2024-10-19', 'requested'),
(34, 39, 'INT-077-2024', '2024-10-17', '2024-10-20', 'requested'),
(44, 39, 'TRASH-077-2024', '2024-10-17', '2024-10-21', 'requested'),
(5, 39, 'ELEC-078-2024', NULL, '2024-10-19', 'planned'),
(15, 39, 'GAS-078-2024', NULL, '2024-10-19', 'planned'),
(25, 39, 'WATER-078-2024', NULL, '2024-10-19', 'planned'),
(35, 39, 'INT-078-2024', NULL, '2024-10-20', 'planned'),
(45, 39, 'TRASH-078-2024', NULL, '2024-10-21', 'planned'),

-- Move 40 utilities (11 utilities)
(4, 40, 'ELEC-079-2024', '2024-11-21', '2024-11-23', 'planned'),
(14, 40, 'GAS-079-2024', '2024-11-21', '2024-11-23', 'planned'),
(24, 40, 'WATER-079-2024', '2024-11-21', '2024-11-23', 'planned'),
(34, 40, 'INT-079-2024', '2024-11-21', '2024-11-24', 'planned'),
(44, 40, 'TRASH-079-2024', '2024-11-21', '2024-11-25', 'planned'),
(5, 40, 'ELEC-080-2024', NULL, '2024-11-23', 'planned'),
(15, 40, 'GAS-080-2024', NULL, '2024-11-23', 'planned'),
(25, 40, 'WATER-080-2024', NULL, '2024-11-23', 'planned'),
(35, 40, 'INT-080-2024', NULL, '2024-11-24', 'planned'),
(45, 40, 'TRASH-080-2024', NULL, '2024-11-25', 'planned'),
(51, 40, 'SEC-019-2024', NULL, '2024-11-23', 'planned'),

-- Move 41 utilities (10 utilities)
(4, 41, 'ELEC-081-2024', '2024-12-27', '2024-12-29', 'planned'),
(14, 41, 'GAS-081-2024', '2024-12-27', '2024-12-29', 'planned'),
(24, 41, 'WATER-081-2024', '2024-12-27', '2024-12-29', 'planned'),
(34, 41, 'INT-081-2024', '2024-12-27', '2024-12-30', 'planned'),
(44, 41, 'TRASH-081-2024', '2024-12-27', '2024-12-31', 'planned'),
(5, 41, 'ELEC-082-2024', NULL, '2024-12-29', 'planned'),
(15, 41, 'GAS-082-2024', NULL, '2024-12-29', 'planned'),
(25, 41, 'WATER-082-2024', NULL, '2024-12-29', 'planned'),
(35, 41, 'INT-082-2024', NULL, '2024-12-30', 'planned'),
(45, 41, 'TRASH-082-2024', NULL, '2024-12-31', 'planned'),

-- Move 42 utilities (11 utilities)
(4, 42, 'ELEC-083-2025', '2025-01-14', '2025-01-16', 'planned'),
(14, 42, 'GAS-083-2025', '2025-01-14', '2025-01-16', 'planned'),
(24, 42, 'WATER-083-2025', '2025-01-14', '2025-01-16', 'planned'),
(34, 42, 'INT-083-2025', '2025-01-14', '2025-01-17', 'planned'),
(44, 42, 'TRASH-083-2025', '2025-01-14', '2025-01-18', 'planned'),
(5, 42, 'ELEC-084-2025', NULL, '2025-01-16', 'planned'),
(15, 42, 'GAS-084-2025', NULL, '2025-01-16', 'planned'),
(25, 42, 'WATER-084-2025', NULL, '2025-01-16', 'planned'),
(35, 42, 'INT-084-2025', NULL, '2025-01-17', 'planned'),
(45, 42, 'TRASH-084-2025', NULL, '2025-01-18', 'planned'),
(52, 42, 'SEC-020-2025', NULL, '2025-01-16', 'planned'),

-- Move 43 utilities (10 utilities)
(4, 43, 'ELEC-085-2025', '2025-02-19', '2025-02-21', 'planned'),
(14, 43, 'GAS-085-2025', '2025-02-19', '2025-02-21', 'planned'),
(24, 43, 'WATER-085-2025', '2025-02-19', '2025-02-21', 'planned'),
(34, 43, 'INT-085-2025', '2025-02-19', '2025-02-22', 'planned'),
(44, 43, 'TRASH-085-2025', '2025-02-19', '2025-02-23', 'planned'),
(5, 43, 'ELEC-086-2025', NULL, '2025-02-21', 'planned'),
(15, 43, 'GAS-086-2025', NULL, '2025-02-21', 'planned'),
(25, 43, 'WATER-086-2025', NULL, '2025-02-21', 'planned'),
(35, 43, 'INT-086-2025', NULL, '2025-02-22', 'planned'),
(45, 43, 'TRASH-086-2025', NULL, '2025-02-23', 'planned'),

-- Move 44 utilities (11 utilities)
(4, 44, 'ELEC-087-2025', '2025-03-24', '2025-03-26', 'planned'),
(14, 44, 'GAS-087-2025', '2025-03-24', '2025-03-26', 'planned'),
(24, 44, 'WATER-087-2025', '2025-03-24', '2025-03-26', 'planned'),
(34, 44, 'INT-087-2025', '2025-03-24', '2025-03-27', 'planned'),
(44, 44, 'TRASH-087-2025', '2025-03-24', '2025-03-28', 'planned'),
(5, 44, 'ELEC-088-2025', NULL, '2025-03-26', 'planned'),
(15, 44, 'GAS-088-2025', NULL, '2025-03-26', 'planned'),
(25, 44, 'WATER-088-2025', NULL, '2025-03-26', 'planned'),
(35, 44, 'INT-088-2025', NULL, '2025-03-27', 'planned'),
(45, 44, 'TRASH-088-2025', NULL, '2025-03-28', 'planned'),
(51, 44, 'SEC-021-2025', NULL, '2025-03-26', 'planned'),

-- Move 45 utilities (10 utilities)
(5, 45, 'ELEC-089-2024', '2024-03-04', '2024-03-06', 'active'),
(15, 45, 'GAS-089-2024', '2024-03-04', '2024-03-06', 'active'),
(25, 45, 'WATER-089-2024', '2024-03-04', '2024-03-06', 'active'),
(35, 45, 'INT-089-2024', '2024-03-04', '2024-03-07', 'active'),
(45, 45, 'TRASH-089-2024', '2024-03-04', '2024-08-18', 'confirmed'),
(5, 48, 'ELEC-096-2024', NULL, '2024-08-16', 'confirmed'),
(15, 48, 'GAS-096-2024', NULL, '2024-08-16', 'confirmed'),
(25, 48, 'WATER-096-2024', NULL, '2024-08-16', 'confirmed'),
(35, 48, 'INT-096-2024', NULL, '2024-08-17', 'confirmed'),
(45, 48, 'TRASH-096-2024', NULL, '2024-08-18', 'confirmed'),
(51, 48, 'SEC-023-2024', NULL, '2024-08-16', 'confirmed'),

-- Move 49 utilities (10 utilities)
(5, 49, 'ELEC-097-2024', '2024-09-21', '2024-09-23', 'requested'),
(15, 49, 'GAS-097-2024', '2024-09-21', '2024-09-23', 'requested'),
(25, 49, 'WATER-097-2024', '2024-09-21', '2024-09-23', 'requested'),
(35, 49, 'INT-097-2024', '2024-09-21', '2024-09-24', 'requested'),
(45, 49, 'TRASH-097-2024', '2024-09-21', '2024-09-25', 'requested'),
(6, 49, 'ELEC-098-2024', NULL, '2024-09-23', 'planned'),
(16, 49, 'GAS-098-2024', NULL, '2024-09-23', 'planned'),
(26, 49, 'WATER-098-2024', NULL, '2024-09-23', 'planned'),
(36, 49, 'INT-098-2024', NULL, '2024-09-24', 'planned'),
(46, 49, 'TRASH-098-2024', NULL, '2024-09-25', 'planned'),

-- Move 50 utilities (11 utilities)
(5, 50, 'ELEC-099-2024', '2024-10-27', '2024-10-29', 'requested'),
(15, 50, 'GAS-099-2024', '2024-10-27', '2024-10-29', 'requested'),
(25, 50, 'WATER-099-2024', '2024-10-27', '2024-10-29', 'requested'),
(35, 50, 'INT-099-2024', '2024-10-27', '2024-10-30', 'requested'),
(45, 50, 'TRASH-099-2024', '2024-10-27', '2024-10-31', 'requested'),
(6, 50, 'ELEC-100-2024', NULL, '2024-10-29', 'planned'),
(16, 50, 'GAS-100-2024', NULL, '2024-10-29', 'planned'),
(26, 50, 'WATER-100-2024', NULL, '2024-10-29', 'planned'),
(36, 50, 'INT-100-2024', NULL, '2024-10-30', 'planned'),
(46, 50, 'TRASH-100-2024', NULL, '2024-10-31', 'planned'),
(52, 50, 'SEC-024-2024', NULL, '2024-10-29', 'planned'),

-- Move 51 utilities (10 utilities)
(5, 51, 'ELEC-101-2024', '2024-11-14', '2024-11-16', 'planned'),
(15, 51, 'GAS-101-2024', '2024-11-14', '2024-11-16', 'planned'),
(25, 51, 'WATER-101-2024', '2024-11-14', '2024-11-16', 'planned'),
(35, 51, 'INT-101-2024', '2024-11-14', '2024-11-17', 'planned'),
(45, 51, 'TRASH-101-2024', '2024-11-14', '2024-11-18', 'planned'),
(6, 51, 'ELEC-102-2024', NULL, '2024-11-16', 'planned'),
(16, 51, 'GAS-102-2024', NULL, '2024-11-16', 'planned'),
(26, 51, 'WATER-102-2024', NULL, '2024-11-16', 'planned'),
(36, 51, 'INT-102-2024', NULL, '2024-11-17', 'planned'),
(46, 51, 'TRASH-102-2024', NULL, '2024-11-18', 'planned'),

-- Move 52 utilities (11 utilities)
(5, 52, 'ELEC-103-2024', '2024-12-21', '2024-12-23', 'planned'),
(15, 52, 'GAS-103-2024', '2024-12-21', '2024-12-23', 'planned'),
(25, 52, 'WATER-103-2024', '2024-12-21', '2024-12-23', 'planned'),
(35, 52, 'INT-103-2024', '2024-12-21', '2024-12-24', 'planned'),
(45, 52, 'TRASH-103-2024', '2024-12-21', '2024-12-25', 'planned'),
(6, 52, 'ELEC-104-2024', NULL, '2024-12-23', 'planned'),
(16, 52, 'GAS-104-2024', NULL, '2024-12-23', 'planned'),
(26, 52, 'WATER-104-2024', NULL, '2024-12-23', 'planned'),
(36, 52, 'INT-104-2024', NULL, '2024-12-24', 'planned'),
(46, 52, 'TRASH-104-2024', NULL, '2024-12-25', 'planned'),
(51, 52, 'SEC-025-2024', NULL, '2024-12-23', 'planned'),

-- Move 53 utilities (10 utilities)
(5, 53, 'ELEC-105-2025', '2025-01-17', '2025-01-19', 'planned'),
(15, 53, 'GAS-105-2025', '2025-01-17', '2025-01-19', 'planned'),
(25, 53, 'WATER-105-2025', '2025-01-17', '2025-01-19', 'planned'),
(35, 53, 'INT-105-2025', '2025-01-17', '2025-01-20', 'planned'),
(45, 53, 'TRASH-105-2025', '2025-01-17', '2025-01-21', 'planned'),
(6, 53, 'ELEC-106-2025', NULL, '2025-01-19', 'planned'),
(16, 53, 'GAS-106-2025', NULL, '2025-01-19', 'planned'),
(26, 53, 'WATER-106-2025', NULL, '2025-01-19', 'planned'),
(36, 53, 'INT-106-2025', NULL, '2025-01-20', 'planned'),
(46, 53, 'TRASH-106-2025', NULL, '2025-01-21', 'planned'),

-- Move 54 utilities (11 utilities)
(5, 54, 'ELEC-107-2025', '2025-02-24', '2025-02-26', 'planned'),
(15, 54, 'GAS-107-2025', '2025-02-24', '2025-02-26', 'planned'),
(25, 54, 'WATER-107-2025', '2025-02-24', '2025-02-26', 'planned'),
(35, 54, 'INT-107-2025', '2025-02-24', '2025-02-27', 'planned'),
(45, 54, 'TRASH-107-2025', '2025-02-24', '2025-02-28', 'planned'),
(6, 54, 'ELEC-108-2025', NULL, '2025-02-26', 'planned'),
(16, 54, 'GAS-108-2025', NULL, '2025-02-26', 'planned'),
(26, 54, 'WATER-108-2025', NULL, '2025-02-26', 'planned'),
(36, 54, 'INT-108-2025', NULL, '2025-02-27', 'planned'),
(46, 54, 'TRASH-108-2025', NULL, '2025-02-28', 'planned'),
(52, 54, 'SEC-026-2025', NULL, '2025-02-26', 'planned'),

-- Move 55 utilities (10 utilities)
(5, 55, 'ELEC-109-2025', '2025-03-29', '2025-03-31', 'planned'),
(15, 55, 'GAS-109-2025', '2025-03-29', '2025-03-31', 'planned'),
(25, 55, 'WATER-109-2025', '2025-03-29', '2025-03-31', 'planned'),
(35, 55, 'INT-109-2025', '2025-03-29', '2025-04-01', 'planned'),
(45, 55, 'TRASH-109-2025', '2025-03-29', '2025-04-02', 'planned'),
(6, 55, 'ELEC-110-2025', NULL, '2025-03-31', 'planned'),
(16, 55, 'GAS-110-2025', NULL, '2025-03-31', 'planned'),
(26, 55, 'WATER-110-2025', NULL, '2025-03-31', 'planned'),
(36, 55, 'INT-110-2025', NULL, '2025-04-01', 'planned'),
(46, 55, 'TRASH-110-2025', NULL, '2025-04-02', 'planned');


-- APPOINTMENTS TABLE
-- Varying appointments per move: some empty, some 2-3, some 4-5, some 6-7, very few 10

INSERT INTO appointments (move_id, title, description, apt_date, apt_time, person, contact_person, contact_phone, status) VALUES
-- Move 1 appointments (3 appointments)
(1, 'Movers Arrival', 'Professional moving company to load items', '2024-03-15', '08:00:00', 'John Smith', 'Mike Johnson', '617-555-0101', 'completed'),
(1, 'Internet Installation', 'Technician to set up internet at new address', '2024-03-16', '13:00:00', 'Tech Support', 'Sarah Williams', '617-555-0102', 'completed'),
(1, 'Furniture Delivery', 'New furniture delivery from IKEA', '2024-03-17', '10:00:00', 'Delivery Team', 'David Brown', '617-555-0103', 'completed'),

-- Move 2 appointments (5 appointments)
(2, 'Office Move Coordination', 'Meeting with building manager', '2024-05-19', '09:00:00', 'Building Manager', 'Tom Anderson', '617-555-0201', 'completed'),
(2, 'IT Equipment Setup', 'Setting up servers and network', '2024-05-20', '08:00:00', 'IT Team', 'Lisa Martinez', '617-555-0202', 'completed'),
(2, 'Furniture Assembly', 'Office furniture installation', '2024-05-21', '10:00:00', 'Assembly Crew', 'Robert Taylor', '617-555-0203', 'completed'),
(2, 'Security System Install', 'Installing office security cameras', '2024-05-22', '14:00:00', 'Security Tech', 'James Wilson', '617-555-0204', 'completed'),
(2, 'Final Inspection', 'Building walkthrough and inspection', '2024-05-23', '16:00:00', 'Inspector', 'Mary Davis', '617-555-0205', 'completed'),

-- Move 3 (empty - no appointments)

-- Move 4 appointments (6 appointments)
(4, 'Packing Service', 'Professional packers for fragile items', '2024-07-30', '09:00:00', 'Packing Team', 'Nancy Clark', '617-555-0301', 'completed'),
(4, 'Moving Day', 'Full service movers', '2024-08-01', '07:00:00', 'Move Crew', 'Kevin White', '617-555-0302', 'completed'),
(4, 'Cleaning Service', 'Deep clean of old apartment', '2024-08-01', '15:00:00', 'Cleaners', 'Emma Garcia', '617-555-0303', 'completed'),
(4, 'Utility Setup', 'Gas and electric activation', '2024-08-02', '10:00:00', 'Utility Rep', 'Daniel Lee', '617-555-0304', 'completed'),
(4, 'Cable Installation', 'Cable and internet setup', '2024-08-02', '14:00:00', 'Cable Tech', 'Olivia Harris', '617-555-0305', 'completed'),
(4, 'Appliance Delivery', 'Washer and dryer delivery', '2024-08-03', '11:00:00', 'Delivery', 'Chris Martin', '617-555-0306', 'completed'),

-- Move 5 appointments (2 appointments)
(5, 'Initial Moving Quote', 'Get estimate from moving company', '2024-09-10', '10:00:00', 'Sales Rep', 'Amanda Scott', '617-555-0401', 'scheduled'),
(5, 'Pre-move Inspection', 'Assess items to be moved', '2024-09-11', '14:00:00', 'Inspector', 'Brian Thomas', '617-555-0402', 'scheduled'),

-- Move 6 (empty - no appointments)

-- Move 7 appointments (4 appointments)
(7, 'Real Estate Walkthrough', 'Final walkthrough of new property', '2024-11-18', '10:00:00', 'Agent', 'Jennifer Moore', '617-555-0501', 'scheduled'),
(7, 'Moving Company', 'Professional movers scheduled', '2024-11-20', '08:00:00', 'Move Team', 'Paul Jackson', '617-555-0502', 'scheduled'),
(7, 'Home Security', 'Security system installation', '2024-11-21', '13:00:00', 'Security', 'Rachel Lewis', '617-555-0503', 'scheduled'),
(7, 'HVAC Inspection', 'Check heating and cooling systems', '2024-11-22', '09:00:00', 'HVAC Tech', 'Steven Walker', '617-555-0504', 'scheduled'),

-- Move 8 appointments (3 appointments)
(8, 'Warehouse Keys', 'Pick up keys and access cards', '2024-12-13', '09:00:00', 'Property Mgr', 'Michelle Hall', '617-555-0601', 'scheduled'),
(8, 'Loading Dock Reservation', 'Reserve loading dock time', '2024-12-15', '07:00:00', 'Building Coord', 'Andrew Allen', '617-555-0602', 'scheduled'),
(8, 'Equipment Movers', 'Heavy equipment moving service', '2024-12-15', '08:00:00', 'Specialized', 'Laura Young', '617-555-0603', 'scheduled'),

-- Move 9 (empty - no appointments)

-- Move 10 appointments (7 appointments)
(10, 'Home Inspection', 'Pre-move home inspection', '2025-02-12', '10:00:00', 'Inspector', 'Matthew King', '617-555-0701', 'scheduled'),
(10, 'Pest Control', 'Termite and pest inspection', '2025-02-13', '09:00:00', 'Exterminator', 'Susan Wright', '617-555-0702', 'scheduled'),
(10, 'Moving Estimate', 'Get moving quote', '2025-02-13', '14:00:00', 'Sales', 'Timothy Lopez', '617-555-0703', 'scheduled'),
(10, 'Packing Day 1', 'Professional packing service', '2025-02-13', '08:00:00', 'Packers', 'Nicole Hill', '617-555-0704', 'scheduled'),
(10, 'Moving Day', 'Full service move', '2025-02-14', '07:00:00', 'Movers', 'Brandon Scott', '617-555-0705', 'scheduled'),
(10, 'Unpacking Service', 'Professional unpacking', '2025-02-15', '09:00:00', 'Unpackers', 'Jessica Green', '617-555-0706', 'scheduled'),
(10, 'Cleaning Old House', 'Final cleaning service', '2025-02-15', '14:00:00', 'Cleaners', 'Aaron Adams', '617-555-0707', 'scheduled'),

-- Move 11 appointments (2 appointments)
(11, 'Storage Consolidation', 'Moving items between units', '2025-02-27', '10:00:00', 'Self', NULL, NULL, 'scheduled'),
(11, 'Storage Unit Access', 'Get access to new unit', '2025-03-01', '09:00:00', 'Facility Mgr', 'Victoria Baker', '617-555-0801', 'scheduled'),

-- Move 12 appointments (5 appointments)
(12, 'Apartment Viewing', 'Final walkthrough before move', '2024-02-26', '11:00:00', 'Landlord', 'Gary Nelson', '212-555-0101', 'completed'),
(12, 'Moving Company Quote', 'Get estimate for move', '2024-02-27', '10:00:00', 'Sales Rep', 'Diana Carter', '212-555-0102', 'completed'),
(12, 'Moving Day', 'Professional movers', '2024-02-28', '08:00:00', 'Move Team', 'Frank Mitchell', '212-555-0103', 'completed'),
(12, 'Internet Setup', 'ISP installation', '2024-02-29', '13:00:00', 'Technician', 'Karen Perez', '212-555-0104', 'completed'),
(12, 'Furniture Assembly', 'Assemble bed and desk', '2024-03-01', '10:00:00', 'Handyman', 'Ronald Roberts', '212-555-0105', 'completed'),

-- Move 13 (empty - no appointments)

-- Move 14 appointments (3 appointments)
(14, 'Storage Unit Rental', 'Sign lease for storage', '2024-06-03', '09:00:00', 'Manager', 'Helen Turner', '212-555-0201', 'completed'),
(14, 'Load Storage', 'Move items into storage', '2024-06-05', '10:00:00', 'Self', NULL, NULL, 'completed'),
(14, 'Final Check', 'Verify all items stored', '2024-06-06', '14:00:00', 'Self', NULL, NULL, 'completed'),

-- Move 15 appointments (10 appointments)
(15, 'Luxury Moving Consultation', 'White glove service consultation', '2024-07-18', '10:00:00', 'Consultant', 'Elizabeth Phillips', '212-555-0301', 'completed'),
(15, 'Art Handler', 'Specialized art moving service', '2024-07-19', '09:00:00', 'Art Mover', 'George Campbell', '212-555-0302', 'completed'),
(15, 'Wine Collection', 'Temperature controlled wine transport', '2024-07-20', '11:00:00', 'Wine Specialist', 'Patricia Parker', '212-555-0303', 'completed'),
(15, 'Piano Movers', 'Grand piano moving specialists', '2024-07-21', '08:00:00', 'Piano Team', 'Richard Evans', '212-555-0304', 'completed'),
(15, 'Pre-Move Day 1', 'Pack fragile and valuable items', '2024-07-21', '09:00:00', 'Packers', 'Linda Edwards', '212-555-0305', 'completed'),
(15, 'Pre-Move Day 2', 'Continue packing', '2024-07-22', '09:00:00', 'Packers', 'Joseph Collins', '212-555-0306', 'completed'),
(15, 'Moving Day', 'Full service luxury movers', '2024-07-22', '07:00:00', 'Move Team', 'Barbara Stewart', '212-555-0307', 'completed'),
(15, 'Interior Designer', 'Placement consultation', '2024-07-23', '10:00:00', 'Designer', 'William Morris', '212-555-0308', 'completed'),
(15, 'Smart Home Setup', 'Home automation installation', '2024-07-24', '09:00:00', 'Tech Team', 'Margaret Rogers', '212-555-0309', 'completed'),
(15, 'Final Walkthrough', 'Ensure everything is perfect', '2024-07-25', '15:00:00', 'Coordinator', 'Charles Reed', '212-555-0310', 'completed'),

-- Move 16 appointments (4 appointments)
(16, 'Pre-Move Meeting', 'Discuss move logistics', '2024-08-28', '10:00:00', 'Coordinator', 'Dorothy Cook', '212-555-0401', 'scheduled'),
(16, 'Packing Service', 'Professional packing', '2024-08-29', '09:00:00', 'Packers', 'Kenneth Morgan', '212-555-0402', 'scheduled'),
(16, 'Moving Day', 'Move to new apartment', '2024-08-30', '08:00:00', 'Movers', 'Betty Bell', '212-555-0403', 'scheduled'),
(16, 'Utility Activation', 'Turn on utilities', '2024-08-31', '10:00:00', 'Utility Rep', 'Mark Murphy', '212-555-0404', 'scheduled'),

-- Move 17 (empty - no appointments)

-- Move 18 appointments (6 appointments)
(18, 'House Showing', 'View weekend house', '2024-11-05', '11:00:00', 'Agent', 'Sandra Bailey', '212-555-0501', 'scheduled'),
(18, 'Home Inspection', 'Professional inspection', '2024-11-06', '09:00:00', 'Inspector', 'Donald Rivera', '212-555-0502', 'scheduled'),
(18, 'Moving Quote', 'Get estimate', '2024-11-07', '10:00:00', 'Sales', 'Ashley Cooper', '212-555-0503', 'scheduled'),
(18, 'Packing Day', 'Pack belongings', '2024-11-08', '08:00:00', 'Packers', 'Joshua Richardson', '212-555-0504', 'scheduled'),
(18, 'Moving Day', 'Transport items', '2024-11-08', '10:00:00', 'Movers', 'Emily Cox', '212-555-0505', 'scheduled'),
(18, 'Setup Services', 'Unpack and setup', '2024-11-09', '09:00:00', 'Team', 'Ryan Howard', '212-555-0506', 'scheduled'),

-- Move 19 appointments (2 appointments)
(19, 'Office Space Tour', 'View new office space', '2024-12-18', '10:00:00', 'Broker', 'Stephanie Ward', '212-555-0601', 'scheduled'),
(19, 'Lease Signing', 'Sign office lease', '2024-12-19', '14:00:00', 'Attorney', 'Jeremy Torres', '212-555-0602', 'scheduled'),

-- Move 20 (empty - no appointments)

-- Move 21 appointments (3 appointments)
(21, 'Apartment Search', 'View potential apartments', '2025-02-25', '10:00:00', 'Agent', 'Angela Peterson', '212-555-0701', 'scheduled'),
(21, 'Application Submit', 'Submit rental application', '2025-02-26', '09:00:00', 'Landlord', 'Justin Gray', '212-555-0702', 'scheduled'),
(21, 'Move-in Inspection', 'Document apartment condition', '2025-02-28', '11:00:00', 'Manager', 'Samantha Ramirez', '212-555-0703', 'scheduled'),

-- Move 22 appointments (5 appointments)
(22, 'Coworking Tour', 'Visit coworking space', '2025-03-12', '10:00:00', 'Manager', 'Eric James', '212-555-0801', 'scheduled'),
(22, 'Membership Setup', 'Sign up for membership', '2025-03-13', '09:00:00', 'Sales', 'Hannah Watson', '212-555-0802', 'scheduled'),
(22, 'Move Office Items', 'Transport office supplies', '2025-03-15', '08:00:00', 'Self', NULL, NULL, 'scheduled'),
(22, 'Setup Workstation', 'Arrange desk and equipment', '2025-03-16', '09:00:00', 'Self', NULL, NULL, 'scheduled'),
(22, 'IT Configuration', 'Setup network access', '2025-03-17', '10:00:00', 'IT Support', 'Tyler Brooks', '212-555-0803', 'scheduled'),

-- Move 23 appointments (4 appointments)
(23, 'Apartment Lease', 'Sign new lease agreement', '2024-03-08', '10:00:00', 'Landlord', 'Megan Kelly', '415-555-0101', 'completed'),
(23, 'Moving Company', 'Schedule movers', '2024-03-09', '09:00:00', 'Dispatcher', 'Jacob Sanders', '415-555-0102', 'completed'),
(23, 'Move Day', 'Moving day', '2024-03-10', '08:00:00', 'Move Team', 'Lauren Price', '415-555-0103', 'completed'),
(23, 'Internet Install', 'Setup internet', '2024-03-11', '13:00:00', 'Technician', 'Nathan Bennett', '415-555-0104', 'completed'),

-- Move 24 (empty - no appointments)

-- Move 25 appointments (7 appointments)
(25, 'Storage Evaluation', 'Assess storage needs', '2024-06-19', '10:00:00', 'Manager', 'Julia Wood', '415-555-0201', 'completed'),
(25, 'Climate Control Setup', 'Configure climate control', '2024-06-20', '09:00:00', 'Technician', 'Kyle Barnes', '415-555-0202', 'completed'),
(25, 'First Load', 'Move first batch of items', '2024-06-21', '08:00:00', 'Self', NULL, NULL, 'completed'),
(25, 'Second Load', 'Move second batch', '2024-06-22', '09:00:00', 'Self', NULL, NULL, 'completed'),
(25, 'Furniture Storage', 'Store large furniture', '2024-06-23', '10:00:00', 'Movers', 'Amber Ross', '415-555-0203', 'completed'),
(25, 'Organize Storage', 'Organize items in unit', '2024-06-24', '10:00:00', 'Self', NULL, NULL, 'completed'),
(25, 'Final Inventory', 'Complete inventory list', '2024-06-25', '14:00:00', 'Self', NULL, NULL, 'completed'),

-- Move 26 appointments (3 appointments)
(26, 'Loft Viewing', 'Tour loft space', '2024-08-05', '11:00:00', 'Agent', 'Dylan Henderson', '415-555-0301', 'completed'),
(26, 'Move Coordination', 'Plan move details', '2024-08-06', '10:00:00', 'Coordinator', 'Alexis Coleman', '415-555-0302', 'completed'),
(26, 'Moving Day', 'Execute move', '2024-08-08', '07:00:00', 'Movers', 'Sean Jenkins', '415-555-0303', 'completed'),

-- Move 27 (empty - no appointments)

-- Move 28 appointments (5 appointments)
(28, 'Beach House Tour', 'Visit beach property', '2024-10-22', '10:00:00', 'Owner', 'Brittany Perry', '415-555-0401', 'scheduled'),
(28, 'Furniture Rental', 'Arrange furniture rental', '2024-10-23', '09:00:00', 'Rental Co', 'Marcus Powell', '415-555-0402', 'scheduled'),
(28, 'Moving Service', 'Schedule movers', '2024-10-24', '08:00:00', 'Move Team', 'Vanessa Long', '415-555-0403', 'scheduled'),
(28, 'Deck Furniture', 'Deliver outdoor furniture', '2024-10-25', '11:00:00', 'Delivery', 'Gregory Patterson', '415-555-0404', 'scheduled'),
(28, 'House Setup', 'Arrange and setup', '2024-10-26', '09:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 29 appointments (2 appointments)
(29, 'Workshop Lease', 'Sign workshop lease', '2024-11-28', '10:00:00', 'Landlord', 'Cynthia Hughes', '415-555-0501', 'scheduled'),
(29, 'Equipment Move', 'Transport workshop equipment', '2024-11-30', '08:00:00', 'Specialized', 'Russell Flores', '415-555-0502', 'scheduled'),

-- Move 30 appointments (6 appointments)
(30, 'Apartment Application', 'Submit application', '2024-12-08', '09:00:00', 'Manager', 'Heather Washington', '415-555-0601', 'scheduled'),
(30, 'Credit Check', 'Complete credit verification', '2024-12-09', '10:00:00', 'Office', 'Johnny Butler', '415-555-0602', 'scheduled'),
(30, 'Lease Signing', 'Sign lease documents', '2024-12-09', '14:00:00', 'Manager', 'Heather Washington', '415-555-0603', 'scheduled'),
(30, 'Move Estimate', 'Get moving quote', '2024-12-10', '10:00:00', 'Sales', 'Denise Simmons', '415-555-0604', 'scheduled'),
(30, 'Moving Day', 'Execute move', '2024-12-11', '08:00:00', 'Movers', 'Roger Foster', '415-555-0605', 'scheduled'),
(30, 'Utility Setup', 'Activate utilities', '2024-12-11', '13:00:00', 'Rep', 'Joan Gonzales', '415-555-0606', 'scheduled'),

-- Move 31 (empty - no appointments)

-- Move 32 appointments (4 appointments)
(32, 'Condo Tour', 'Visit condo building', '2025-02-16', '11:00:00', 'Agent', 'Philip Bryant', '415-555-0701', 'scheduled'),
(32, 'HOA Meeting', 'Meet with HOA board', '2025-02-17', '10:00:00', 'HOA President', 'Evelyn Alexander', '415-555-0702', 'scheduled'),
(32, 'Moving Company', 'Schedule movers', '2025-02-18', '09:00:00', 'Coordinator', 'Walter Russell', '415-555-0703', 'scheduled'),
(32, 'Move Day', 'Moving day', '2025-02-18', '08:00:00', 'Move Team', 'Gloria Griffin', '415-555-0704', 'scheduled'),

-- Move 33 appointments (3 appointments)
(33, 'Office Space Tour', 'View shared office', '2025-03-20', '10:00:00', 'Manager', 'Carl Diaz', '415-555-0801', 'scheduled'),
(33, 'Membership Agreement', 'Sign membership', '2025-03-21', '09:00:00', 'Admin', 'Teresa Hayes', '415-555-0802', 'scheduled'),
(33, 'Move Office Items', 'Transport supplies', '2025-03-22', '10:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 34 appointments (5 appointments)
(34, 'Apartment Search', 'View apartments', '2024-02-12', '10:00:00', 'Agent', 'Bryan Myers', '312-555-0101', 'completed'),
(34, 'Background Check', 'Complete screening', '2024-02-13', '09:00:00', 'Office', 'Joyce Ford', '312-555-0102', 'completed'),
(34, 'Move Quote', 'Get estimate', '2024-02-14', '10:00:00', 'Sales', 'Randy Hamilton', '312-555-0103', 'completed'),
(34, 'Moving Day', 'Execute move', '2024-02-15', '08:00:00', 'Movers', 'Cheryl Graham', '312-555-0104', 'completed'),
(34, 'Furniture Delivery', 'New furniture arrival', '2024-02-16', '11:00:00', 'Delivery', 'Albert Sullivan', '312-555-0105', 'completed'),

-- Move 35 (empty - no appointments)

-- Move 36 appointments (7 appointments)
(36, 'Storage Consultation', 'Discuss storage options', '2024-06-09', '10:00:00', 'Manager', 'Ruby Wallace', '312-555-0201', 'completed'),
(36, 'Insurance Setup', 'Arrange storage insurance', '2024-06-10', '09:00:00', 'Agent', 'Louis Woods', '312-555-0202', 'completed'),
(36, 'Pack Day 1', 'Pack items for storage', '2024-06-11', '08:00:00', 'Self', NULL, NULL, 'completed'),
(36, 'Pack Day 2', 'Continue packing', '2024-06-12', '08:00:00', 'Self', NULL, NULL, 'completed'),
(36, 'Moving Day', 'Move to storage', '2024-06-12', '10:00:00', 'Movers', 'Frances Kennedy', '312-555-0203', 'completed'),
(36, 'Organize Unit', 'Arrange storage unit', '2024-06-13', '09:00:00', 'Self', NULL, NULL, 'completed'),
(36, 'Final Check', 'Verify all items stored', '2024-06-13', '14:00:00', 'Self', NULL, NULL, 'completed'),

-- Move 37 appointments (2 appointments)
(37, 'Apartment Walkthrough', 'Final inspection', '2024-07-29', '10:00:00', 'Landlord', 'Eugene Warren', '312-555-0301', 'completed'),
(37, 'Moving Day', 'Move belongings', '2024-07-30', '08:00:00', 'Movers', 'Marilyn Burton', '312-555-0302', 'completed'),

-- Move 38 (empty - no appointments)

-- Move 39 appointments (4 appointments)
(39, 'Cabin Inspection', 'Inspect cabin condition', '2024-10-16', '11:00:00', 'Inspector', 'Gerald Porter', '312-555-0401', 'scheduled'),
(39, 'Furniture Purchase', 'Buy cabin furniture', '2024-10-17', '10:00:00', 'Store Rep', 'Janice Lawson', '312-555-0402', 'scheduled'),
(39, 'Moving Service', 'Transport to cabin', '2024-10-18', '08:00:00', 'Movers', 'Keith Fields', '312-555-0403', 'scheduled'),
(39, 'Setup Day', 'Arrange cabin interior', '2024-10-19', '09:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 40 appointments (3 appointments)
(40, 'Office Lease Review', 'Review lease terms', '2024-11-20', '10:00:00', 'Attorney', 'Willie Webb', '312-555-0501', 'scheduled'),
(40, 'Office Setup', 'Configure office space', '2024-11-22', '09:00:00', 'Designer', 'Virginia Tucker', '312-555-0502', 'scheduled'),
(40, 'IT Installation', 'Setup network and phones', '2024-11-23', '08:00:00', 'IT Team', 'Harold Carr', '312-555-0503', 'scheduled'),

-- Move 41 (empty - no appointments)

-- Move 42 appointments (6 appointments)
(42, 'Garage Rental', 'Sign garage lease', '2025-01-13', '10:00:00', 'Owner', 'Lillian Pierce', '312-555-0601', 'scheduled'),
(42, 'Tool Organization', 'Plan tool storage', '2025-01-14', '09:00:00', 'Self', NULL, NULL, 'scheduled'),
(42, 'Move Equipment', 'Transport garage items', '2025-01-15', '08:00:00', 'Self', NULL, NULL, 'scheduled'),
(42, 'Shelving Install', 'Install garage shelving', '2025-01-16', '09:00:00', 'Handyman', 'Arthur Reid', '312-555-0602', 'scheduled'),
(42, 'Organize Tools', 'Arrange tools and equipment', '2025-01-16', '13:00:00', 'Self', NULL, NULL, 'scheduled'),
(42, 'Final Setup', 'Complete garage organization', '2025-01-17', '10:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 43 appointments (2 appointments)
(43, 'Apartment Tour', 'View new apartment', '2025-02-18', '11:00:00', 'Agent', 'Kelly Elliott', '312-555-0701', 'scheduled'),
(43, 'Move Day', 'Execute move', '2025-02-20', '08:00:00', 'Movers', 'Douglas Garza', '312-555-0702', 'scheduled'),

-- Move 44 appointments (5 appointments)
(44, 'Office Space Tour', 'Visit remote office', '2025-03-22', '10:00:00', 'Manager', 'Sara Duncan', '312-555-0801', 'scheduled'),
(44, 'Network Setup', 'Configure office network', '2025-03-24', '09:00:00', 'IT', 'Frank Hunter', '312-555-0802', 'scheduled'),
(44, 'Furniture Order', 'Order office furniture', '2025-03-25', '10:00:00', 'Sales', 'Annie Holmes', '312-555-0803', 'scheduled'),
(44, 'Move Equipment', 'Transport office items', '2025-03-26', '08:00:00', 'Movers', 'Raymond Webb', '312-555-0804', 'scheduled'),
(44, 'Office Setup', 'Arrange workspace', '2025-03-27', '09:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 45 (empty - no appointments)

-- Move 46 appointments (4 appointments)
(46, 'Office Building Tour', 'View office space', '2024-05-08', '10:00:00', 'Broker', 'Kathryn Meyer', '404-555-0101', 'completed'),
(46, 'Lease Negotiation', 'Discuss lease terms', '2024-05-09', '09:00:00', 'Attorney', 'Jesse Hudson', '404-555-0102', 'completed'),
(46, 'Moving Company', 'Schedule office movers', '2024-05-10', '10:00:00', 'Coordinator', 'Beverly Knight', '404-555-0103', 'completed'),
(46, 'Move Day', 'Office relocation', '2024-05-10', '08:00:00', 'Move Team', 'Wayne Boyd', '404-555-0104', 'completed'),

-- Move 47 appointments (3 appointments)
(47, 'Storage Tour', 'View storage facility', '2024-06-16', '10:00:00', 'Manager', 'Judith Palmer', '404-555-0201', 'completed'),
(47, 'Load Storage', 'Move items to storage', '2024-06-18', '09:00:00', 'Self', NULL, NULL, 'completed'),
(47, 'Inventory Check', 'Create storage inventory', '2024-06-19', '10:00:00', 'Self', NULL, NULL, 'completed'),

-- Move 48 (empty - no appointments)

-- Move 49 appointments (7 appointments)
(49, 'House Viewing', 'Tour brother house', '2024-09-19', '11:00:00', 'Brother', 'Family Member', '404-555-0301', 'scheduled'),
(49, 'Room Planning', 'Plan room arrangements', '2024-09-20', '10:00:00', 'Self', NULL, NULL, 'scheduled'),
(49, 'Packing Day', 'Pack belongings', '2024-09-21', '08:00:00', 'Self', NULL, NULL, 'scheduled'),
(49, 'Moving Day', 'Move to brother house', '2024-09-22', '09:00:00', 'Friends', NULL, NULL, 'scheduled'),
(49, 'Unpacking', 'Unpack boxes', '2024-09-23', '10:00:00', 'Self', NULL, NULL, 'scheduled'),
(49, 'Furniture Arrange', 'Arrange furniture', '2024-09-24', '09:00:00', 'Self', NULL, NULL, 'scheduled'),
(49, 'Final Setup', 'Complete room setup', '2024-09-25', '10:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 50 appointments (2 appointments)
(50, 'Lake House Keys', 'Pick up house keys', '2024-10-26', '10:00:00', 'Owner', 'Property Manager', '404-555-0401', 'scheduled'),
(50, 'Furniture Delivery', 'Deliver lake house furniture', '2024-10-28', '11:00:00', 'Delivery', 'Todd Rice', '404-555-0402', 'scheduled'),

-- Move 51 (empty - no appointments)

-- Move 52 appointments (5 appointments)
(52, 'Apartment Search', 'View potential apartments', '2024-12-19', '10:00:00', 'Agent', 'Shirley Stone', '404-555-0501', 'scheduled'),
(52, 'Application', 'Submit rental application', '2024-12-20', '09:00:00', 'Office', 'Jerry Armstrong', '404-555-0502', 'scheduled'),
(52, 'Move Planning', 'Plan move logistics', '2024-12-21', '10:00:00', 'Self', NULL, NULL, 'scheduled'),
(52, 'Moving Day', 'Execute move', '2024-12-22', '08:00:00', 'Movers', 'Norma Cunningham', '404-555-0503', 'scheduled'),
(52, 'Setup Day', 'Arrange apartment', '2024-12-23', '09:00:00', 'Self', NULL, NULL, 'scheduled'),

-- Move 53 appointments (3 appointments)
(53, 'Warehouse Tour', 'View warehouse space', '2025-01-16', '10:00:00', 'Manager', 'Ernest Lane', '404-555-0601', 'scheduled'),
(53, 'Equipment Planning', 'Plan equipment layout', '2025-01-17', '09:00:00', 'Self', NULL, NULL, 'scheduled'),
(53, 'Moving Day', 'Transport to warehouse', '2025-01-18', '08:00:00', 'Movers', 'Donna Oliver', '404-555-0602', 'scheduled'),

-- Move 54 (empty - no appointments)

-- Move 55 appointments (4 appointments)
(55, 'Coworking Membership', 'Sign up for membership', '2025-03-28', '10:00:00', 'Manager', 'Ralph Berry', '404-555-0701', 'scheduled'),
(55, 'Tour Facilities', 'Tour coworking space', '2025-03-29', '09:00:00', 'Guide', 'Phyllis Watkins', '404-555-0702', 'scheduled'),
(55, 'Move Office Items', 'Transport office supplies', '2025-03-30', '08:00:00', 'Self', NULL, NULL, 'scheduled'),
(55, 'Workspace Setup', 'Setup workstation', '2025-03-31', '09:00:00', 'Self', NULL, NULL, 'scheduled');


-- DOCUMENTS TABLE
-- Varying documents per move: some empty, some 2-3, some 4-5, some 6-7, very few 10

INSERT INTO documents (move_id, doc_type, file_url, uploaded_on) VALUES
-- Move 1 documents (4 documents)
(1, 'Lease Agreement', 'https://storage.movemind.com/docs/move1_lease.pdf', '2024-02-15 10:30:00'),
(1, 'Moving Quote', 'https://storage.movemind.com/docs/move1_quote.pdf', '2024-02-20 14:20:00'),
(1, 'Insurance Certificate', 'https://storage.movemind.com/docs/move1_insurance.pdf', '2024-03-01 09:15:00'),
(1, 'Inventory List', 'https://storage.movemind.com/docs/move1_inventory.pdf', '2024-03-14 16:45:00'),

-- Move 2 documents (6 documents)
(2, 'Office Lease', 'https://storage.movemind.com/docs/move2_lease.pdf', '2024-04-10 11:00:00'),
(2, 'Moving Contract', 'https://storage.movemind.com/docs/move2_contract.pdf', '2024-04-25 13:30:00'),
(2, 'Building Rules', 'https://storage.movemind.com/docs/move2_rules.pdf', '2024-05-01 10:00:00'),
(2, 'Insurance Policy', 'https://storage.movemind.com/docs/move2_insurance.pdf', '2024-05-05 14:15:00'),
(2, 'Equipment List', 'https://storage.movemind.com/docs/move2_equipment.pdf', '2024-05-15 09:30:00'),
(2, 'Floor Plan', 'https://storage.movemind.com/docs/move2_floorplan.pdf', '2024-05-18 15:20:00'),

-- Move 3 (empty - no documents)

-- Move 4 documents (5 documents)
(4, 'Apartment Lease', 'https://storage.movemind.com/docs/move4_lease.pdf', '2024-07-10 10:00:00'),
(4, 'Moving Estimate', 'https://storage.movemind.com/docs/move4_estimate.pdf', '2024-07-15 11:30:00'),
(4, 'Packing Receipt', 'https://storage.movemind.com/docs/move4_receipt.pdf', '2024-07-30 14:00:00'),
(4, 'Utility Transfers', 'https://storage.movemind.com/docs/move4_utilities.pdf', '2024-07-25 09:45:00'),
(4, 'Inventory Checklist', 'https://storage.movemind.com/docs/move4_checklist.pdf', '2024-08-01 16:30:00'),

-- Move 5 documents (2 documents)
(5, 'Moving Quote', 'https://storage.movemind.com/docs/move5_quote.pdf', '2024-09-05 10:15:00'),
(5, 'Insurance Quote', 'https://storage.movemind.com/docs/move5_insurance.pdf', '2024-09-08 11:20:00'),

-- Move 6 (empty - no documents)

-- Move 7 documents (7 documents)
(7, 'Home Purchase Agreement', 'https://storage.movemind.com/docs/move7_purchase.pdf', '2024-10-15 10:00:00'),
(7, 'Home Inspection Report', 'https://storage.movemind.com/docs/move7_inspection.pdf', '2024-10-20 14:30:00'),
(7, 'Moving Contract', 'https://storage.movemind.com/docs/move7_contract.pdf', '2024-11-01 09:00:00'),
(7, 'Insurance Policy', 'https://storage.movemind.com/docs/move7_insurance.pdf', '2024-11-05 11:45:00'),
(7, 'Utility Setup Forms', 'https://storage.movemind.com/docs/move7_utilities.pdf', '2024-11-10 13:20:00'),
(7, 'Home Warranty', 'https://storage.movemind.com/docs/move7_warranty.pdf', '2024-11-12 15:00:00'),
(7, 'Moving Inventory', 'https://storage.movemind.com/docs/move7_inventory.pdf', '2024-11-19 16:30:00'),

-- Move 8 documents (3 documents)
(8, 'Warehouse Lease', 'https://storage.movemind.com/docs/move8_lease.pdf', '2024-11-20 10:00:00'),
(8, 'Moving Quote', 'https://storage.movemind.com/docs/move8_quote.pdf', '2024-12-01 11:30:00'),
(8, 'Equipment List', 'https://storage.movemind.com/docs/move8_equipment.pdf', '2024-12-10 14:00:00'),

-- Move 9 (empty - no documents)

-- Move 10 documents (10 documents)
(10, 'Home Sale Contract', 'https://storage.movemind.com/docs/move10_sale.pdf', '2025-01-15 10:00:00'),
(10, 'Home Purchase Contract', 'https://storage.movemind.com/docs/move10_purchase.pdf', '2025-01-20 11:00:00'),
(10, 'Home Inspection', 'https://storage.movemind.com/docs/move10_inspection.pdf', '2025-01-25 14:30:00'),
(10, 'Pest Inspection', 'https://storage.movemind.com/docs/move10_pest.pdf', '2025-01-28 09:45:00'),
(10, 'Moving Estimate', 'https://storage.movemind.com/docs/move10_estimate.pdf', '2025-02-01 10:30:00'),
(10, 'Moving Contract', 'https://storage.movemind.com/docs/move10_contract.pdf', '2025-02-05 13:00:00'),
(10, 'Insurance Policy', 'https://storage.movemind.com/docs/move10_insurance.pdf', '2025-02-08 15:20:00'),
(10, 'Utility Transfer Forms', 'https://storage.movemind.com/docs/move10_utilities.pdf', '2025-02-10 11:45:00'),
(10, 'Moving Inventory', 'https://storage.movemind.com/docs/move10_inventory.pdf', '2025-02-13 16:00:00'),
(10, 'Closing Documents', 'https://storage.movemind.com/docs/move10_closing.pdf', '2025-02-14 17:30:00'),

-- Move 11 documents (2 documents)
(11, 'Storage Contract', 'https://storage.movemind.com/docs/move11_contract.pdf', '2025-02-20 10:00:00'),
(11, 'Inventory List', 'https://storage.movemind.com/docs/move11_inventory.pdf', '2025-02-28 14:30:00'),

-- Move 12 documents (5 documents)
(12, 'Lease Agreement', 'https://storage.movemind.com/docs/move12_lease.pdf', '2024-02-15 10:00:00'),
(12, 'Renter Insurance', 'https://storage.movemind.com/docs/move12_insurance.pdf', '2024-02-20 11:30:00'),
(12, 'Moving Receipt', 'https://storage.movemind.com/docs/move12_receipt.pdf', '2024-02-28 15:00:00'),
(12, 'Utility Accounts', 'https://storage.movemind.com/docs/move12_utilities.pdf', '2024-02-25 09:45:00'),
(12, 'Move-in Checklist', 'https://storage.movemind.com/docs/move12_checklist.pdf', '2024-02-29 16:30:00'),

-- Move 13 (empty - no documents)

-- Move 14 documents (3 documents)
(14, 'Storage Lease', 'https://storage.movemind.com/docs/move14_lease.pdf', '2024-06-01 10:00:00'),
(14, 'Storage Insurance', 'https://storage.movemind.com/docs/move14_insurance.pdf', '2024-06-03 11:30:00'),
(14, 'Item Inventory', 'https://storage.movemind.com/docs/move14_inventory.pdf', '2024-06-05 14:00:00'),

-- Move 15 documents (10 documents)
(15, 'Condo Purchase Agreement', 'https://storage.movemind.com/docs/move15_purchase.pdf', '2024-06-15 10:00:00'),
(15, 'HOA Documents', 'https://storage.movemind.com/docs/move15_hoa.pdf', '2024-06-20 11:00:00'),
(15, 'Home Inspection', 'https://storage.movemind.com/docs/move15_inspection.pdf', '2024-06-25 14:30:00'),
(15, 'Luxury Moving Contract', 'https://storage.movemind.com/docs/move15_contract.pdf', '2024-07-01 10:30:00'),
(15, 'White Glove Services', 'https://storage.movemind.com/docs/move15_services.pdf', '2024-07-05 13:00:00'),
(15, 'Art Moving Insurance', 'https://storage.movemind.com/docs/move15_art_insurance.pdf', '2024-07-08 15:20:00'),
(15, 'Wine Transport Certificate', 'https://storage.movemind.com/docs/move15_wine.pdf', '2024-07-10 11:45:00'),
(15, 'Piano Moving Agreement', 'https://storage.movemind.com/docs/move15_piano.pdf', '2024-07-12 16:00:00'),
(15, 'Complete Inventory', 'https://storage.movemind.com/docs/move15_inventory.pdf', '2024-07-20 17:30:00'),
(15, 'Closing Papers', 'https://storage.movemind.com/docs/move15_closing.pdf', '2024-07-22 18:00:00'),

-- Move 16 documents (4 documents)
(16, 'Apartment Lease', 'https://storage.movemind.com/docs/move16_lease.pdf', '2024-08-20 10:00:00'),
(16, 'Moving Quote', 'https://storage.movemind.com/docs/move16_quote.pdf', '2024-08-25 11:30:00'),
(16, 'Insurance Policy', 'https://storage.movemind.com/docs/move16_insurance.pdf', '2024-08-28 14:00:00'),
(16, 'Move-in Inspection', 'https://storage.movemind.com/docs/move16_inspection.pdf', '2024-08-30 16:30:00'),

-- Move 17 (empty - no documents)

-- Move 18 documents (6 documents)
(18, 'Vacation Home Lease', 'https://storage.movemind.com/docs/move18_lease.pdf', '2024-11-01 10:00:00'),
(18, 'Property Inspection', 'https://storage.movemind.com/docs/move18_inspection.pdf', '2024-11-05 11:30:00'),
(18, 'Moving Contract', 'https://storage.movemind.com/docs/move18_contract.pdf', '2024-11-06 14:00:00'),
(18, 'Insurance Certificate', 'https://storage.movemind.com/docs/move18_insurance.pdf', '2024-11-07 15:30:00'),
(18, 'Furniture Order', 'https://storage.movemind.com/docs/move18_furniture.pdf', '2024-11-08 10:45:00'),
(18, 'Inventory List', 'https://storage.movemind.com/docs/move18_inventory.pdf', '2024-11-08 16:00:00'),

-- Move 19 documents (2 documents)
(19, 'Office Lease', 'https://storage.movemind.com/docs/move19_lease.pdf', '2024-12-10 10:00:00'),
(19, 'Building Regulations', 'https://storage.movemind.com/docs/move19_regulations.pdf', '2024-12-15 11:30:00'),

-- Move 20 (empty - no documents)

-- Move 21 documents (3 documents)
(21, 'Apartment Application', 'https://storage.movemind.com/docs/move21_application.pdf', '2025-02-20 10:00:00'),
(21, 'Credit Report', 'https://storage.movemind.com/docs/move21_credit.pdf', '2025-02-22 11:30:00'),
(21, 'Lease Agreement', 'https://storage.movemind.com/docs/move21_lease.pdf', '2025-02-28 14:00:00'),

-- Move 22 documents (5 documents)
(22, 'Coworking Membership', 'https://storage.movemind.com/docs/move22_membership.pdf', '2025-03-10 10:00:00'),
(22, 'Facility Rules', 'https://storage.movemind.com/docs/move22_rules.pdf', '2025-03-12 11:30:00'),
(22, 'Payment Agreement', 'https://storage.movemind.com/docs/move22_payment.pdf', '2025-03-13 14:00:00'),
(22, 'Network Access Form', 'https://storage.movemind.com/docs/move22_network.pdf', '2025-03-15 15:30:00'),
(22, 'Equipment List', 'https://storage.movemind.com/docs/move22_equipment.pdf', '2025-03-15 16:00:00'),

-- Move 23 documents (4 documents)
(23, 'Lease Agreement', 'https://storage.movemind.com/docs/move23_lease.pdf', '2024-03-05 10:00:00'),
(23, 'Moving Quote', 'https://storage.movemind.com/docs/move23_quote.pdf', '2024-03-08 11:30:00'),
(23, 'Renter Insurance', 'https://storage.movemind.com/docs/move23_insurance.pdf', '2024-03-09 14:00:00'),
(23, 'Inventory Checklist', 'https://storage.movemind.com/docs/move23_inventory.pdf', '2024-03-10 16:30:00'),

-- Move 24 (empty - no documents)

-- Move 25 documents (7 documents)
(25, 'Storage Unit Agreement', 'https://storage.movemind.com/docs/move25_agreement.pdf', '2024-06-15 10:00:00'),
(25, 'Climate Control Contract', 'https://storage.movemind.com/docs/move25_climate.pdf', '2024-06-18 11:30:00'),
(25, 'Storage Insurance', 'https://storage.movemind.com/docs/move25_insurance.pdf', '2024-06-20 14:00:00'),
(25, 'Access Agreement', 'https://storage.movemind.com/docs/move25_access.pdf', '2024-06-21 15:30:00'),
(25, 'Item Inventory', 'https://storage.movemind.com/docs/move25_inventory.pdf', '2024-06-22 10:45:00'),
(25, 'Photos of Items', 'https://storage.movemind.com/docs/move25_photos.pdf', '2024-06-23 16:00:00'),
(25, 'Final Checklist', 'https://storage.movemind.com/docs/move25_checklist.pdf', '2024-06-25 17:00:00'),

-- Move 26 documents (3 documents)
(26, 'Loft Lease', 'https://storage.movemind.com/docs/move26_lease.pdf', '2024-08-01 10:00:00'),
(26, 'Moving Contract', 'https://storage.movemind.com/docs/move26_contract.pdf', '2024-08-05 11:30:00'),
(26, 'Move-in Photos', 'https://storage.movemind.com/docs/move26_photos.pdf', '2024-08-08 16:00:00'),

-- Move 27 (empty - no documents)

-- Move 28 documents (5 documents)
(28, 'Beach House Rental', 'https://storage.movemind.com/docs/move28_rental.pdf', '2024-10-20 10:00:00'),
(28, 'Furniture Rental Agreement', 'https://storage.movemind.com/docs/move28_furniture.pdf', '2024-10-22 11:30:00'),
(28, 'Moving Receipt', 'https://storage.movemind.com/docs/move28_receipt.pdf', '2024-10-24 14:00:00'),
(28, 'Property Insurance', 'https://storage.movemind.com/docs/move28_insurance.pdf', '2024-10-25 15:30:00'),
(28, 'Inventory List', 'https://storage.movemind.com/docs/move28_inventory.pdf', '2024-10-28 16:00:00'),

-- Move 29 documents (2 documents)
(29, 'Workshop Lease', 'https://storage.movemind.com/docs/move29_lease.pdf', '2024-11-25 10:00:00'),
(29, 'Equipment List', 'https://storage.movemind.com/docs/move29_equipment.pdf', '2024-11-30 11:30:00'),

-- Move 30 documents (6 documents)
(30, 'Rental Application', 'https://storage.movemind.com/docs/move30_application.pdf', '2024-12-05 10:00:00'),
(30, 'Background Check', 'https://storage.movemind.com/docs/move30_background.pdf', '2024-12-08 11:30:00'),
(30, 'Lease Agreement', 'https://storage.movemind.com/docs/move30_lease.pdf', '2024-12-09 14:00:00'),
(30, 'Moving Estimate', 'https://storage.movemind.com/docs/move30_estimate.pdf', '2024-12-10 15:30:00'),
(30, 'Utility Setup Forms', 'https://storage.movemind.com/docs/move30_utilities.pdf', '2024-12-11 10:45:00'),
(30, 'Move-in Checklist', 'https://storage.movemind.com/docs/move30_checklist.pdf', '2024-12-11 16:00:00'),

-- Move 31 (empty - no documents)

-- Move 32 documents (4 documents)
(32, 'Condo Lease', 'https://storage.movemind.com/docs/move32_lease.pdf', '2025-02-15 10:00:00'),
(32, 'HOA Rules', 'https://storage.movemind.com/docs/move32_hoa.pdf', '2025-02-16 11:30:00'),
(32, 'Moving Contract', 'https://storage.movemind.com/docs/move32_contract.pdf', '2025-02-17 14:00:00'),
(32, 'Insurance Policy', 'https://storage.movemind.com/docs/move32_insurance.pdf', '2025-02-18 16:30:00'),

-- Move 33 documents (3 documents)
(33, 'Office Membership', 'https://storage.movemind.com/docs/move33_membership.pdf', '2025-03-18 10:00:00'),
(33, 'Agreement Terms', 'https://storage.movemind.com/docs/move33_terms.pdf', '2025-03-20 11:30:00'),
(33, 'Access Card Form', 'https://storage.movemind.com/docs/move33_access.pdf', '2025-03-22 14:00:00'),

-- Move 34 documents (5 documents)
(34, 'Apartment Lease', 'https://storage.movemind.com/docs/move34_lease.pdf', '2024-02-10 10:00:00'),
(34, 'Renter Insurance', 'https://storage.movemind.com/docs/move34_insurance.pdf', '2024-02-12 11:30:00'),
(34, 'Moving Quote', 'https://storage.movemind.com/docs/move34_quote.pdf', '2024-02-13 14:00:00'),
(34, 'Moving Receipt', 'https://storage.movemind.com/docs/move34_receipt.pdf', '2024-02-15 15:30:00'),
(34, 'Inventory List', 'https://storage.movemind.com/docs/move34_inventory.pdf', '2024-02-16 16:00:00'),

-- Move 35 (empty - no documents)

-- Move 36 documents (7 documents)
(36, 'Storage Lease', 'https://storage.movemind.com/docs/move36_lease.pdf', '2024-06-05 10:00:00'),
(36, 'Storage Insurance', 'https://storage.movemind.com/docs/move36_insurance.pdf', '2024-06-08 11:30:00'),
(36, 'Insurance Claim Form', 'https://storage.movemind.com/docs/move36_claim.pdf', '2024-06-10 14:00:00'),
(36, 'Item Photos', 'https://storage.movemind.com/docs/move36_photos.pdf', '2024-06-11 15:30:00'),
(36, 'Inventory List', 'https://storage.movemind.com/docs/move36_inventory.pdf', '2024-06-12 10:45:00'),
(36, 'Access Log', 'https://storage.movemind.com/docs/move36_access.pdf', '2024-06-13 16:00:00'),
(36, 'Final Documentation', 'https://storage.movemind.com/docs/move36_final.pdf', '2024-06-13 17:00:00'),

-- Move 37 documents (2 documents)
(37, 'Lease Agreement', 'https://storage.movemind.com/docs/move37_lease.pdf', '2024-07-25 10:00:00'),
(37, 'Moving Receipt', 'https://storage.movemind.com/docs/move37_receipt.pdf', '2024-07-30 11:30:00'),

-- Move 38 (empty - no documents)

-- Move 39 documents (4 documents)
(39, 'Cabin Rental Agreement', 'https://storage.movemind.com/docs/move39_rental.pdf', '2024-10-15 10:00:00'),
(39, 'Inspection Report', 'https://storage.movemind.com/docs/move39_inspection.pdf', '2024-10-16 11:30:00'),
(39, 'Furniture Purchase', 'https://storage.movemind.com/docs/move39_furniture.pdf', '2024-10-17 14:00:00'),
(39, 'Moving Receipt', 'https://storage.movemind.com/docs/move39_receipt.pdf', '2024-10-18 16:30:00'),

-- Move 40 documents (3 documents)
(40, 'Office Lease', 'https://storage.movemind.com/docs/move40_lease.pdf', '2024-11-18 10:00:00'),
(40, 'Lease Review', 'https://storage.movemind.com/docs/move40_review.pdf', '2024-11-20 11:30:00'),
(40, 'IT Setup Agreement', 'https://storage.movemind.com/docs/move40_it.pdf', '2024-11-23 14:00:00'),

-- Move 41 (empty - no documents)

-- Move 42 documents (6 documents)
(42, 'Garage Lease', 'https://storage.movemind.com/docs/move42_lease.pdf', '2025-01-10 10:00:00'),
(42, 'Shelving Quote', 'https://storage.movemind.com/docs/move42_shelving.pdf', '2025-01-12 11:30:00'),
(42, 'Tool Inventory', 'https://storage.movemind.com/docs/move42_tools.pdf', '2025-01-14 14:00:00'),
(42, 'Installation Receipt', 'https://storage.movemind.com/docs/move42_install.pdf', '2025-01-16 15:30:00'),
(42, 'Organization Plan', 'https://storage.movemind.com/docs/move42_plan.pdf', '2025-01-16 10:45:00'),
(42, 'Final Photos', 'https://storage.movemind.com/docs/move42_photos.pdf', '2025-01-17 16:00:00'),

-- Move 43 documents (2 documents)
(43, 'Apartment Lease', 'https://storage.movemind.com/docs/move43_lease.pdf', '2025-02-17 10:00:00'),
(43, 'Moving Contract', 'https://storage.movemind.com/docs/move43_contract.pdf', '2025-02-19 11:30:00'),

-- Move 44 documents (5 documents)
(44, 'Office Lease', 'https://storage.movemind.com/docs/move44_lease.pdf', '2025-03-20 10:00:00'),
(44, 'Network Setup', 'https://storage.movemind.com/docs/move44_network.pdf', '2025-03-24 11:30:00'),
(44, 'Furniture Order', 'https://storage.movemind.com/docs/move44_furniture.pdf', '2025-03-25 14:00:00'),
(44, 'Moving Receipt', 'https://storage.movemind.com/docs/move44_receipt.pdf', '2025-03-26 15:30:00'),
(44, 'Equipment List', 'https://storage.movemind.com/docs/move44_equipment.pdf', '2025-03-27 16:00:00'),

-- Move 45 (empty - no documents)

-- Move 46 documents (4 documents)
(46, 'Office Lease', 'https://storage.movemind.com/docs/move46_lease.pdf', '2024-05-05 10:00:00'),
(46, 'Lease Negotiation', 'https://storage.movemind.com/docs/move46_negotiation.pdf', '2024-05-08 11:30:00'),
(46, 'Moving Contract', 'https://storage.movemind.com/docs/move46_contract.pdf', '2024-05-09 14:00:00'),
(46, 'Move Completion', 'https://storage.movemind.com/docs/move46_completion.pdf', '2024-05-10 16:30:00'),

-- Move 47 documents (3 documents)
(47, 'Storage Agreement', 'https://storage.movemind.com/docs/move47_agreement.pdf', '2024-06-15 10:00:00'),
(47, 'Item Inventory', 'https://storage.movemind.com/docs/move47_inventory.pdf', '2024-06-18 11:30:00'),
(47, 'Storage Photos', 'https://storage.movemind.com/docs/move47_photos.pdf', '2024-06-19 14:00:00'),

-- Move 48 (empty - no documents)

-- Move 49 documents (7 documents)
(49, 'Temporary Housing Agreement', 'https://storage.movemind.com/docs/move49_agreement.pdf', '2024-09-15 10:00:00'),
(49, 'Room Assignment', 'https://storage.movemind.com/docs/move49_room.pdf', '2024-09-18 11:30:00'),
(49, 'House Rules', 'https://storage.movemind.com/docs/move49_rules.pdf', '2024-09-19 14:00:00'),
(49, 'Moving Checklist', 'https://storage.movemind.com/docs/move49_checklist.pdf', '2024-09-21 15:30:00'),
(49, 'Item Inventory', 'https://storage.movemind.com/docs/move49_inventory.pdf', '2024-09-22 10:45:00'),
(49, 'Move-in Photos', 'https://storage.movemind.com/docs/move49_photos.pdf', '2024-09-23 16:00:00'),
(49, 'Final Setup', 'https://storage.movemind.com/docs/move49_setup.pdf', '2024-09-25 17:00:00'),

-- Move 50 documents (2 documents)
(50, 'Lake House Rental', 'https://storage.movemind.com/docs/move50_rental.pdf', '2024-10-20 10:00:00'),
(50, 'Furniture Delivery', 'https://storage.movemind.com/docs/move50_furniture.pdf', '2024-10-28 11:30:00'),

-- Move 51 (empty - no documents)

-- Move 52 documents (5 documents)
(52, 'Rental Application', 'https://storage.movemind.com/docs/move52_application.pdf', '2024-12-18 10:00:00'),
(52, 'Lease Agreement', 'https://storage.movemind.com/docs/move52_lease.pdf', '2024-12-20 11:30:00'),
(52, 'Moving Quote', 'https://storage.movemind.com/docs/move52_quote.pdf', '2024-12-21 14:00:00'),
(52, 'Moving Receipt', 'https://storage.movemind.com/docs/move52_receipt.pdf', '2024-12-22 15:30:00'),
(52, 'Move-in Checklist', 'https://storage.movemind.com/docs/move52_checklist.pdf', '2024-12-23 16:00:00'),

-- Move 53 documents (3 documents)
(53, 'Warehouse Lease', 'https://storage.movemind.com/docs/move53_lease.pdf', '2025-01-15 10:00:00'),
(53, 'Equipment Plan', 'https://storage.movemind.com/docs/move53_plan.pdf', '2025-01-17 11:30:00'),
(53, 'Moving Receipt', 'https://storage.movemind.com/docs/move53_receipt.pdf', '2025-01-18 14:00:00'),

-- Move 54 (empty - no documents)

-- Move 55 documents (4 documents)
(55, 'Coworking Membership', 'https://storage.movemind.com/docs/move55_membership.pdf', '2025-03-27 10:00:00'),
(55, 'Facility Agreement', 'https://storage.movemind.com/docs/move55_agreement.pdf', '2025-03-28 11:30:00'),
(55, 'Payment Setup', 'https://storage.movemind.com/docs/move55_payment.pdf', '2025-03-29 14:00:00'),
(55, 'Workspace Checklist', 'https://storage.movemind.com/docs/move55_checklist.pdf', '2025-03-31 16:00:00');