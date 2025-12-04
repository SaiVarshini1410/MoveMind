USE movemind_db;

-- =====================================================
-- DEMO USER 1: demo1@gmail.com (password: Demo123!)
-- =====================================================

-- 1. CREATE USER (user_id will be 1)
-- Register Demo One User with above creds before running this script.

-- 2. CREATE ADDRESSES (10 addresses for Demo User 1)
INSERT INTO addresses (line1, line2, city, state, postal_code, country) VALUES
('100 Boylston Street', 'Apt 5A', 'Boston', 'Massachusetts', '02116', 'USA'),
('250 Commonwealth Ave', NULL, 'Boston', 'Massachusetts', '02115', 'USA'),
('75 Arlington Street', 'Unit 12B', 'Boston', 'Massachusetts', '02116', 'USA'),
('500 Beacon Street', NULL, 'Boston', 'Massachusetts', '02215', 'USA'),
('1200 Tremont Street', 'Apt 3C', 'Boston', 'Massachusetts', '02120', 'USA'),
('350 Newbury Street', 'Suite 200', 'Boston', 'Massachusetts', '02115', 'USA'),
('890 Massachusetts Ave', NULL, 'Cambridge', 'Massachusetts', '02139', 'USA'),
('45 Harvard Street', 'Apt 7', 'Brookline', 'Massachusetts', '02446', 'USA'),
('678 Washington Street', NULL, 'Somerville', 'Massachusetts', '02143', 'USA'),
('234 Main Street', 'Unit 4D', 'Watertown', 'Massachusetts', '02472', 'USA');

-- 3. LINK ADDRESSES TO USER
INSERT INTO user_addresses (user_id, address_id, label) VALUES
(1, (SELECT id FROM addresses WHERE line1 = '100 Boylston Street' LIMIT 1), 'Current Home'),
(1, (SELECT id FROM addresses WHERE line1 = '250 Commonwealth Ave' LIMIT 1), 'New Apartment'),
(1, (SELECT id FROM addresses WHERE line1 = '75 Arlington Street' LIMIT 1), 'Summer Place'),
(1, (SELECT id FROM addresses WHERE line1 = '500 Beacon Street' LIMIT 1), 'Office Location'),
(1, (SELECT id FROM addresses WHERE line1 = '1200 Tremont Street' LIMIT 1), 'Storage Unit'),
(1, (SELECT id FROM addresses WHERE line1 = '350 Newbury Street' LIMIT 1), 'Weekend Home'),
(1, (SELECT id FROM addresses WHERE line1 = '890 Massachusetts Ave' LIMIT 1), 'Parents House'),
(1, (SELECT id FROM addresses WHERE line1 = '45 Harvard Street' LIMIT 1), 'Old Apartment'),
(1, (SELECT id FROM addresses WHERE line1 = '678 Washington Street' LIMIT 1), 'Friends Place'),
(1, (SELECT id FROM addresses WHERE line1 = '234 Main Street' LIMIT 1), 'Temporary Stay');

-- 4. CREATE MOVES (6 moves for variety)
INSERT INTO moves (user_id, title, move_date, status, from_address_id, to_address_id) VALUES
(1, 'Downtown to Back Bay Move', '2025-01-15', 'planned',
    (SELECT id FROM addresses WHERE line1 = '100 Boylston Street' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '250 Commonwealth Ave' LIMIT 1)),
    
(1, 'Summer Home Setup', '2025-02-20', 'packing',
    (SELECT id FROM addresses WHERE line1 = '250 Commonwealth Ave' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '75 Arlington Street' LIMIT 1)),
    
(1, 'Office Relocation', '2025-03-10', 'in_transit',
    (SELECT id FROM addresses WHERE line1 = '500 Beacon Street' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '350 Newbury Street' LIMIT 1)),
    
(1, 'Storage to New Place', '2024-12-01', 'unpacking',
    (SELECT id FROM addresses WHERE line1 = '1200 Tremont Street' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '890 Massachusetts Ave' LIMIT 1)),
    
(1, 'Quick Weekend Move', '2024-11-15', 'done',
    (SELECT id FROM addresses WHERE line1 = '45 Harvard Street' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '678 Washington Street' LIMIT 1)),
    
(1, 'Cambridge Relocation', '2025-04-05', 'planned',
    (SELECT id FROM addresses WHERE line1 = '890 Massachusetts Ave' LIMIT 1),
    (SELECT id FROM addresses WHERE line1 = '234 Main Street' LIMIT 1));

-- 5. CREATE ROOMS (5+ rooms for first move)
SET @move1_id = (SELECT id FROM moves WHERE title = 'Downtown to Back Bay Move' LIMIT 1);
SET @move2_id = (SELECT id FROM moves WHERE title = 'Summer Home Setup' LIMIT 1);
SET @move3_id = (SELECT id FROM moves WHERE title = 'Office Relocation' LIMIT 1);

INSERT INTO rooms (move_id, name, floor) VALUES
(@move1_id, 'Master Bedroom', '2'),
(@move1_id, 'Guest Bedroom', '2'),
(@move1_id, 'Living Room', '1'),
(@move1_id, 'Kitchen', '1'),
(@move1_id, 'Home Office', '1'),
(@move1_id, 'Bathroom', '2'),
(@move1_id, 'Garage', 'G'),

(@move2_id, 'Main Bedroom', '1'),
(@move2_id, 'Living Area', '1'),
(@move2_id, 'Kitchen', '1'),
(@move2_id, 'Patio', '1'),
(@move2_id, 'Storage Closet', '1'),

(@move3_id, 'Reception Area', '3'),
(@move3_id, 'Main Office', '3'),
(@move3_id, 'Conference Room', '3'),
(@move3_id, 'Break Room', '3'),
(@move3_id, 'Storage Room', '3');

-- 6. CREATE BOXES (5+ boxes per move)
INSERT INTO boxes (move_id, room_name, label_code, fragile, weight, status) VALUES
-- Move 1 boxes
(@move1_id, 'Master Bedroom', 'MB-001', 0, 25.50, 'packed'),
(@move1_id, 'Master Bedroom', 'MB-002', 1, 15.00, 'packed'),
(@move1_id, 'Kitchen', 'KIT-001', 1, 30.00, 'empty'),
(@move1_id, 'Kitchen', 'KIT-002', 1, 28.50, 'empty'),
(@move1_id, 'Living Room', 'LR-001', 0, 35.00, 'packed'),
(@move1_id, 'Home Office', 'HO-001', 0, 20.00, 'packed'),
(@move1_id, 'Garage', 'GAR-001', 0, 45.00, 'empty'),

-- Move 2 boxes
(@move2_id, 'Main Bedroom', 'SH-BED-001', 0, 22.00, 'packed'),
(@move2_id, 'Kitchen', 'SH-KIT-001', 1, 18.50, 'packed'),
(@move2_id, 'Living Area', 'SH-LIV-001', 0, 30.00, 'loaded'),
(@move2_id, 'Patio', 'SH-PAT-001', 0, 40.00, 'empty'),
(@move2_id, 'Storage Closet', 'SH-STO-001', 0, 15.00, 'packed'),

-- Move 3 boxes
(@move3_id, 'Main Office', 'OFF-001', 0, 25.00, 'delivered'),
(@move3_id, 'Conference Room', 'CONF-001', 1, 20.00, 'delivered'),
(@move3_id, 'Break Room', 'BRK-001', 0, 18.00, 'loaded'),
(@move3_id, 'Storage Room', 'STO-001', 0, 50.00, 'empty'),
(@move3_id, 'Reception Area', 'REC-001', 1, 12.00, 'packed');

-- 7. CREATE ITEMS (5+ items per box for first few boxes)
SET @box1 = (SELECT id FROM boxes WHERE label_code = 'MB-001' LIMIT 1);
SET @box2 = (SELECT id FROM boxes WHERE label_code = 'MB-002' LIMIT 1);
SET @box3 = (SELECT id FROM boxes WHERE label_code = 'KIT-001' LIMIT 1);
SET @box4 = (SELECT id FROM boxes WHERE label_code = 'LR-001' LIMIT 1);
SET @box5 = (SELECT id FROM boxes WHERE label_code = 'HO-001' LIMIT 1);

INSERT INTO items (box_id, name, quantity, value) VALUES
-- Box 1 items (Master Bedroom)
(@box1, 'Bed Sheets Set', 3, 150.00),
(@box1, 'Pillows', 6, 120.00),
(@box1, 'Blankets', 4, 200.00),
(@box1, 'Alarm Clock', 1, 45.00),
(@box1, 'Bedside Lamp', 2, 80.00),
(@box1, 'Picture Frames', 5, 75.00),

-- Box 2 items (Master Bedroom - Fragile)
(@box2, 'Jewelry Box', 1, 500.00),
(@box2, 'Glass Figurines', 8, 300.00),
(@box2, 'Perfume Collection', 12, 400.00),
(@box2, 'Photo Albums', 4, 100.00),
(@box2, 'Decorative Mirror', 1, 250.00),

-- Box 3 items (Kitchen - Fragile)
(@box3, 'Dinner Plates Set', 12, 180.00),
(@box3, 'Wine Glasses', 8, 120.00),
(@box3, 'Coffee Mugs', 10, 60.00),
(@box3, 'Serving Bowls', 6, 90.00),
(@box3, 'Glass Containers', 15, 75.00),

-- Box 4 items (Living Room)
(@box4, 'Throw Pillows', 8, 160.00),
(@box4, 'Coffee Table Books', 12, 240.00),
(@box4, 'Decorative Vases', 4, 200.00),
(@box4, 'Candle Holders', 6, 90.00),
(@box4, 'Photo Frames', 10, 150.00),
(@box4, 'Area Rug', 1, 350.00),

-- Box 5 items (Home Office)
(@box5, 'Office Supplies Bundle', 1, 80.00),
(@box5, 'Notebooks', 15, 45.00),
(@box5, 'Pens and Markers', 50, 30.00),
(@box5, 'Desk Organizers', 3, 60.00),
(@box5, 'File Folders', 25, 40.00),
(@box5, 'Monitor Stand', 1, 75.00);

-- 8. ATTACH CATEGORIES TO BOXES
-- 8. ATTACH CATEGORIES TO BOXES (using ONLY your new categories)
SET @cat_music = (SELECT id FROM categories WHERE name = 'Music & Instruments' LIMIT 1);
SET @cat_pantry = (SELECT id FROM categories WHERE name = 'Pantry & Food' LIMIT 1);
SET @cat_medical = (SELECT id FROM categories WHERE name = 'Medical Supplies' LIMIT 1);
SET @cat_workshop = (SELECT id FROM categories WHERE name = 'Workshop' LIMIT 1);
SET @cat_collectibles = (SELECT id FROM categories WHERE name = 'Collectibles' LIMIT 1);
SET @cat_plants = (SELECT id FROM categories WHERE name = 'Plants & Gardening' LIMIT 1);
SET @cat_crafts = (SELECT id FROM categories WHERE name = 'Crafts & Sewing' LIMIT 1);
SET @cat_photo = (SELECT id FROM categories WHERE name = 'Photography Equipment' LIMIT 1);
SET @cat_gaming = (SELECT id FROM categories WHERE name = 'Gaming & Entertainment' LIMIT 1);

INSERT INTO box_categories (box_id, category_id) VALUES
-- Master Bedroom boxes
(@box1, @cat_collectibles),
(@box2, @cat_crafts),
-- Kitchen box
(@box3, @cat_pantry),
-- Living Room box
(@box4, @cat_gaming),
(@box4, @cat_music),
-- Home Office box
(@box5, @cat_photo),
(@box5, @cat_medical),
-- Additional boxes
((SELECT id FROM boxes WHERE label_code = 'GAR-001' LIMIT 1), @cat_workshop),
((SELECT id FROM boxes WHERE label_code = 'SH-PAT-001' LIMIT 1), @cat_plants);

-- 9. CREATE APPOINTMENTS (5+ appointments)
INSERT INTO appointments (move_id, title, description, apt_date, apt_time, person, contact_person, contact_phone, status) VALUES
(@move1_id, 'Moving Company Consultation', 'Get quote from moving company', '2025-01-10', '10:00:00', 'Demo One', 'John Smith', '617-555-0101', 'scheduled'),
(@move1_id, 'Building Management Checkout', 'Final walkthrough at old place', '2025-01-14', '14:00:00', 'Demo One', 'Property Manager', '617-555-0102', 'scheduled'),
(@move1_id, 'Movers Arrival', 'Moving truck arrives', '2025-01-15', '08:00:00', 'Demo One', 'Moving Team Lead', '617-555-0103', 'scheduled'),
(@move1_id, 'Internet Installation', 'Setup internet at new place', '2025-01-16', '13:00:00', 'Demo One', 'Comcast Tech', '800-555-0104', 'scheduled'),
(@move1_id, 'Furniture Delivery', 'New couch delivery', '2025-01-17', '11:00:00', 'Demo One', 'Furniture Store', '617-555-0105', 'scheduled'),

(@move2_id, 'Summer Home Inspection', 'Check condition before move', '2025-02-15', '09:00:00', 'Demo One', 'Inspector', '617-555-0106', 'scheduled'),
(@move2_id, 'Cleaning Service', 'Deep clean before moving in', '2025-02-19', '10:00:00', NULL, 'CleanCo', '617-555-0107', 'scheduled'),

(@move3_id, 'Office Equipment Movers', 'Move heavy equipment', '2025-03-09', '08:00:00', 'Demo One', 'Office Movers Inc', '617-555-0108', 'completed'),

(@move1_id, 'Utility Transfer Meeting', 'Transfer utilities to new address', '2025-01-13', '15:00:00', 'Demo One', 'Utility Rep', '617-555-0109', 'scheduled');

-- 10. CREATE DOCUMENTS (5+ documents)
INSERT INTO documents (move_id, doc_type, file_url) VALUES
(@move1_id, 'Lease Agreement', 'https://docs.google.com/document/d/lease-agreement-2025'),
(@move1_id, 'Moving Quote', 'https://docs.google.com/document/d/moving-quote-jan'),
(@move1_id, 'Insurance Certificate', 'https://docs.google.com/document/d/insurance-cert'),
(@move1_id, 'Inventory List', 'https://docs.google.com/spreadsheets/d/inventory-main'),
(@move1_id, 'Building Rules', 'https://docs.google.com/document/d/building-regulations'),

(@move2_id, 'Summer Home Lease', 'https://docs.google.com/document/d/summer-lease-2025'),
(@move2_id, 'Move Checklist', 'https://docs.google.com/document/d/move-checklist-summer'),

(@move3_id, 'Office Lease', 'https://docs.google.com/document/d/office-lease-newbury'),
(@move3_id, 'Equipment List', 'https://docs.google.com/spreadsheets/d/office-equipment');

-- 11. ATTACH UTILITIES TO MOVES (5+ utilities per move)
SET @util_electric1 = (SELECT id FROM utilities WHERE provider_name = 'Florida Power & Light' LIMIT 1);
SET @util_electric2 = (SELECT id FROM utilities WHERE provider_name = 'Arizona Public Service' LIMIT 1);
SET @util_electric3 = (SELECT id FROM utilities WHERE provider_name = 'Dominion Energy' LIMIT 1);
SET @util_gas1 = (SELECT id FROM utilities WHERE provider_name = 'Atmos Energy' LIMIT 1);
SET @util_gas2 = (SELECT id FROM utilities WHERE provider_name = 'Pacific Gas Company' LIMIT 1);
SET @util_water1 = (SELECT id FROM utilities WHERE provider_name = 'Philadelphia Water' LIMIT 1);
SET @util_water2 = (SELECT id FROM utilities WHERE provider_name = 'Seattle Public Utilities' LIMIT 1);
SET @util_water3 = (SELECT id FROM utilities WHERE provider_name = 'Denver Water' LIMIT 1);
SET @util_internet1 = (SELECT id FROM utilities WHERE provider_name = 'Starry Internet' LIMIT 1);
SET @util_internet2 = (SELECT id FROM utilities WHERE provider_name = 'Ziply Fiber' LIMIT 1);
SET @util_internet3 = (SELECT id FROM utilities WHERE provider_name = 'WOW Internet' LIMIT 1);
SET @util_trash1 = (SELECT id FROM utilities WHERE provider_name = 'BFI Waste Services' LIMIT 1);
SET @util_trash2 = (SELECT id FROM utilities WHERE provider_name = 'WCA Waste' LIMIT 1);
SET @util_trash3 = (SELECT id FROM utilities WHERE provider_name = 'Hometown Trash' LIMIT 1);

INSERT INTO move_utilities (move_id, utility_id, account_number, start_date, stop_date, status) VALUES
-- Move 1 utilities
(@move1_id, @util_electric1, 'ELEC-2025-001', '2025-01-15', NULL, 'requested'),
(@move1_id, @util_gas1, 'GAS-2025-001', '2025-01-15', NULL, 'requested'),
(@move1_id, @util_water1, 'WATER-2025-001', '2025-01-15', NULL, 'planned'),
(@move1_id, @util_internet1, 'INET-2025-001', '2025-01-16', NULL, 'confirmed'),
(@move1_id, @util_trash1, 'TRASH-2025-001', '2025-01-15', NULL, 'planned'),

-- Move 2 utilities
(@move2_id, @util_electric2, 'ELEC-2025-002', '2025-02-20', '2025-09-01', 'planned'),
(@move2_id, @util_water2, 'WATER-2025-002', '2025-02-20', '2025-09-01', 'planned'),
(@move2_id, @util_internet2, 'INET-2025-002', '2025-02-21', NULL, 'planned'),
(@move2_id, @util_trash2, 'TRASH-2025-002', '2025-02-20', NULL, 'planned'),

-- Move 3 utilities (office)
(@move3_id, @util_electric3, 'ELEC-OFF-2025', '2025-03-10', NULL, 'active'),
(@move3_id, @util_gas2, 'GAS-OFF-2025', '2025-03-10', NULL, 'active'),
(@move3_id, @util_internet3, 'INET-OFF-2025', '2025-03-10', NULL, 'active'),
(@move3_id, @util_water3, 'WATER-OFF-2025', '2025-03-10', NULL, 'active'),
(@move3_id, @util_trash3, 'TRASH-OFF-2025', '2025-03-10', NULL, 'active');