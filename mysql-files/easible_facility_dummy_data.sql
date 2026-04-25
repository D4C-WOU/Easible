use easible_db;
select * from categories;


-- facility dummy data

-- hospitals
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
('Apollo Hospital Delhi', 1, 'Sarita Vihar', 'Delhi', 'Delhi', 28.5355, 77.2880, '9991110001', 'Multi-speciality'),
('AIIMS Delhi', 1, 'Ansari Nagar', 'Delhi', 'Delhi', 28.5672, 77.2100, '9991110002', 'Govt hospital'),
('Fortis Hospital Delhi', 1, 'Okhla', 'Delhi', 'Delhi', 28.5400, 77.2700, '9991110003', 'Private hospital'),
('Max Hospital Delhi', 1, 'Saket', 'Delhi', 'Delhi', 28.5245, 77.2066, '9991110004', 'Advanced care'),

('Lilavati Hospital', 1, 'Bandra', 'Mumbai', 'Maharashtra', 19.0500, 72.8258, '9991111001', 'Top hospital'),
('KEM Hospital', 1, 'Parel', 'Mumbai', 'Maharashtra', 19.0020, 72.8410, '9991111002', 'Govt hospital'),
('Hinduja Hospital', 1, 'Mahim', 'Mumbai', 'Maharashtra', 19.0330, 72.8400, '9991111003', 'Multi-speciality'),
('Nanavati Hospital', 1, 'Vile Parle', 'Mumbai', 'Maharashtra', 19.1000, 72.8400, '9991111004', 'Private'),

('Apollo Chennai', 1, 'Greams Road', 'Chennai', 'Tamil Nadu', 13.0600, 80.2500, '9991112001', 'Premium hospital'),
('MIOT Hospital', 1, 'Manapakkam', 'Chennai', 'Tamil Nadu', 13.0100, 80.1800, '9991112002', 'Speciality'),
('SRM Hospital', 1, 'Kattankulathur', 'Chennai', 'Tamil Nadu', 12.8200, 80.0400, '9991112003', 'University hospital'),
('Global Hospital Chennai', 1, 'Perumbakkam', 'Chennai', 'Tamil Nadu', 12.9000, 80.2000, '9991112004', 'Multi-speciality');


-- police stations
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
('Connaught Place Police Station', 2, 'CP', 'Delhi', 'Delhi', 28.6315, 77.2167, '8881110001', 'Central zone'),
('Saket Police Station', 2, 'Saket', 'Delhi', 'Delhi', 28.5245, 77.2066, '8881110002', 'South Delhi'),
('Dwarka Police Station', 2, 'Dwarka', 'Delhi', 'Delhi', 28.5921, 77.0460, '8881110003', 'West Delhi'),
('Rohini Police Station', 2, 'Rohini', 'Delhi', 'Delhi', 28.7041, 77.1025, '8881110004', 'North Delhi'),

('Bandra Police Station', 2, 'Bandra', 'Mumbai', 'Maharashtra', 19.0596, 72.8295, '8881111001', 'West Mumbai'),
('Andheri Police Station', 2, 'Andheri', 'Mumbai', 'Maharashtra', 19.1136, 72.8697, '8881111002', 'Busy area'),
('Colaba Police Station', 2, 'Colaba', 'Mumbai', 'Maharashtra', 18.9067, 72.8147, '8881111003', 'South Mumbai'),
('Dadar Police Station', 2, 'Dadar', 'Mumbai', 'Maharashtra', 19.0176, 72.8562, '8881111004', 'Central'),

('T Nagar Police Station', 2, 'T Nagar', 'Chennai', 'Tamil Nadu', 13.0418, 80.2341, '8881112001', 'City center'),
('Adyar Police Station', 2, 'Adyar', 'Chennai', 'Tamil Nadu', 13.0067, 80.2570, '8881112002', 'South Chennai'),
('Velachery Police Station', 2, 'Velachery', 'Chennai', 'Tamil Nadu', 12.9750, 80.2200, '8881112003', 'Residential'),
('Anna Nagar Police Station', 2, 'Anna Nagar', 'Chennai', 'Tamil Nadu', 13.0878, 80.2100, '8881112004', 'North Chennai');



-- fire stations
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
('Delhi Fire Station HQ', 3, 'ITO', 'Delhi', 'Delhi', 28.6280, 77.2410, '7771110001', 'Main HQ'),
('Lajpat Nagar Fire Station', 3, 'Lajpat Nagar', 'Delhi', 'Delhi', 28.5670, 77.2430, '7771110002', 'South Delhi'),
('Karol Bagh Fire Station', 3, 'Karol Bagh', 'Delhi', 'Delhi', 28.6510, 77.1900, '7771110003', 'Central'),
('Dwarka Fire Station', 3, 'Dwarka', 'Delhi', 'Delhi', 28.5921, 77.0460, '7771110004', 'West'),

('Mumbai Fire Brigade HQ', 3, 'Byculla', 'Mumbai', 'Maharashtra', 18.9750, 72.8320, '7771111001', 'HQ'),
('Andheri Fire Station', 3, 'Andheri', 'Mumbai', 'Maharashtra', 19.1136, 72.8697, '7771111002', 'West'),
('Borivali Fire Station', 3, 'Borivali', 'Mumbai', 'Maharashtra', 19.2307, 72.8567, '7771111003', 'North'),
('Chembur Fire Station', 3, 'Chembur', 'Mumbai', 'Maharashtra', 19.0626, 72.9005, '7771111004', 'East'),

('Chennai Fire HQ', 3, 'Egmore', 'Chennai', 'Tamil Nadu', 13.0827, 80.2707, '7771112001', 'Main HQ'),
('Tambaram Fire Station', 3, 'Tambaram', 'Chennai', 'Tamil Nadu', 12.9249, 80.1000, '7771112002', 'Suburban'),
('Guindy Fire Station', 3, 'Guindy', 'Chennai', 'Tamil Nadu', 13.0067, 80.2200, '7771112003', 'Industrial'),
('Perambur Fire Station', 3, 'Perambur', 'Chennai', 'Tamil Nadu', 13.1210, 80.2400, '7771112004', 'North');


-- pharmacy 
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
-- Springfield
('HealthPlus Pharmacy', 4, '12 Oak St', 'Springfield', 'IL', 39.7810, -89.6505, '5551000001', '24/7 pharmacy'),
('MediCare Pharmacy', 4, '45 Pine St', 'Springfield', 'IL', 39.7820, -89.6510, '5551000002', 'Prescription services'),
('LifeLine Pharmacy', 4, '78 Elm St', 'Springfield', 'IL', 39.7830, -89.6520, '5551000003', 'Affordable medicines'),
('QuickMeds Pharmacy', 4, '90 Cedar St', 'Springfield', 'IL', 39.7840, -89.6530, '5551000004', 'Fast service'),

-- Shelbyville
('Shelby Pharmacy', 4, '10 Market Rd', 'Shelbyville', 'IL', 39.5001, -89.7001, '5551000005', 'Local pharmacy'),
('CarePlus Drugs', 4, '22 Center St', 'Shelbyville', 'IL', 39.5010, -89.7010, '5551000006', 'Medicine and supplies'),
('PharmaHub', 4, '33 Hill Rd', 'Shelbyville', 'IL', 39.5020, -89.7020, '5551000007', 'Health essentials'),
('CityMeds Pharmacy', 4, '44 Lake Rd', 'Shelbyville', 'IL', 39.5030, -89.7030, '5551000008', 'Quick prescriptions'),

-- Capitol City
('Capitol Care Pharmacy', 4, '11 Main Blvd', 'Capitol City', 'IL', 39.8201, -89.6001, '5551000009', '24hr pharmacy'),
('UrbanMeds', 4, '22 Metro Rd', 'Capitol City', 'IL', 39.8210, -89.6010, '5551000010', 'Urban pharmacy'),
('Wellness Drugs', 4, '33 Health St', 'Capitol City', 'IL', 39.8220, -89.6020, '5551000011', 'Wellness products'),
('CityLife Pharmacy', 4, '44 Park Ave', 'Capitol City', 'IL', 39.8230, -89.6030, '5551000012', 'Affordable meds'),

-- Northfield
('NorthCare Pharmacy', 4, '12 North St', 'Northfield', 'IL', 39.9001, -89.7001, '5551000013', 'Healthcare supplies'),
('MediPoint', 4, '25 River Rd', 'Northfield', 'IL', 39.9010, -89.7010, '5551000014', 'Prescription drugs'),
('QuickCare Pharmacy', 4, '37 Hill Rd', 'Northfield', 'IL', 39.9020, -89.7020, '5551000015', 'Quick service'),
('GreenHealth Pharmacy', 4, '49 Valley Rd', 'Northfield', 'IL', 39.9030, -89.7030, '5551000016', 'Natural products'),

-- Harbor Town
('Harbor Pharmacy', 4, '1 Dock St', 'Harbor Town', 'IL', 39.6001, -89.5801, '5551000017', 'Harbor area pharmacy'),
('SeaCare Drugs', 4, '2 Port Rd', 'Harbor Town', 'IL', 39.6010, -89.5810, '5551000018', 'Medicine & supplies'),
('WaveMeds', 4, '3 Shore Rd', 'Harbor Town', 'IL', 39.6020, -89.5820, '5551000019', 'Fast delivery'),
('Dockside Pharmacy', 4, '4 Bay Rd', 'Harbor Town', 'IL', 39.6030, -89.5830, '5551000020', 'Local pharmacy'),

-- Extra
('Express Pharmacy', 4, '5 Express Rd', 'Springfield', 'IL', 39.7850, -89.6540, '5551000021', 'Quick meds'),
('Community Pharmacy', 4, '6 Community Rd', 'Shelbyville', 'IL', 39.5040, -89.7040, '5551000022', 'Neighborhood pharmacy'),
('CareWell Pharmacy', 4, '7 Wellness Rd', 'Capitol City', 'IL', 39.8240, -89.6040, '5551000023', 'Wellness focus'),
('SafeMeds', 4, '8 Safe Rd', 'Northfield', 'IL', 39.9040, -89.7040, '5551000024', 'Safe medicines'),
('Prime Pharmacy', 4, '9 Prime Rd', 'Harbor Town', 'IL', 39.6040, -89.5840, '5551000025', 'Premium pharmacy');


-- municipal services
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
-- Springfield
('Springfield Municipal Office', 5, '100 Civic St', 'Springfield', 'IL', 39.7811, -89.6502, '5552000001', 'City services'),
('Water Supply Office', 5, '101 Water Rd', 'Springfield', 'IL', 39.7821, -89.6512, '5552000002', 'Water services'),
('Property Tax Office', 5, '102 Tax Rd', 'Springfield', 'IL', 39.7831, -89.6522, '5552000003', 'Tax payments'),
('Birth & Death Office', 5, '103 Records Rd', 'Springfield', 'IL', 39.7841, -89.6532, '5552000004', 'Certificates'),

-- Shelbyville
('Shelby Civic Center', 5, '10 Center Rd', 'Shelbyville', 'IL', 39.5002, -89.7002, '5552000005', 'Public services'),
('Water Board Shelby', 5, '11 Water Rd', 'Shelbyville', 'IL', 39.5012, -89.7012, '5552000006', 'Water department'),
('Shelby Tax Office', 5, '12 Tax Rd', 'Shelbyville', 'IL', 39.5022, -89.7022, '5552000007', 'Tax services'),
('Shelby Records Office', 5, '13 Records Rd', 'Shelbyville', 'IL', 39.5032, -89.7032, '5552000008', 'Certificates'),

-- Capitol City
('Capitol Municipal HQ', 5, '1 Capitol Rd', 'Capitol City', 'IL', 39.8202, -89.6002, '5552000009', 'Main civic office'),
('Capitol Water Dept', 5, '2 Water Rd', 'Capitol City', 'IL', 39.8212, -89.6012, '5552000010', 'Water services'),
('Capitol Tax Dept', 5, '3 Tax Rd', 'Capitol City', 'IL', 39.8222, -89.6022, '5552000011', 'Taxes'),
('Capitol Records Dept', 5, '4 Records Rd', 'Capitol City', 'IL', 39.8232, -89.6032, '5552000012', 'Certificates'),

-- Northfield
('Northfield Civic Office', 5, '10 North Rd', 'Northfield', 'IL', 39.9002, -89.7002, '5552000013', 'Local governance'),
('North Water Office', 5, '11 River Rd', 'Northfield', 'IL', 39.9012, -89.7012, '5552000014', 'Water services'),
('North Tax Office', 5, '12 Hill Rd', 'Northfield', 'IL', 39.9022, -89.7022, '5552000015', 'Tax office'),
('North Records Office', 5, '13 Valley Rd', 'Northfield', 'IL', 39.9032, -89.7032, '5552000016', 'Certificates'),

-- Harbor Town
('Harbor Civic Center', 5, '1 Dock Rd', 'Harbor Town', 'IL', 39.6002, -89.5802, '5552000017', 'City services'),
('Harbor Water Dept', 5, '2 Port Rd', 'Harbor Town', 'IL', 39.6012, -89.5812, '5552000018', 'Water services'),
('Harbor Tax Office', 5, '3 Shore Rd', 'Harbor Town', 'IL', 39.6022, -89.5822, '5552000019', 'Tax office'),
('Harbor Records Office', 5, '4 Bay Rd', 'Harbor Town', 'IL', 39.6032, -89.5832, '5552000020', 'Certificates'),

-- Extra
('Urban Civic Office', 5, '5 Urban Rd', 'Springfield', 'IL', 39.7851, -89.6541, '5552000021', 'Urban services'),
('City Tax Hub', 5, '6 Tax Hub Rd', 'Shelbyville', 'IL', 39.5042, -89.7042, '5552000022', 'Tax hub'),
('Metro Civic Office', 5, '7 Metro Rd', 'Capitol City', 'IL', 39.8242, -89.6042, '5552000023', 'Metro services'),
('Green Civic Center', 5, '8 Green Rd', 'Northfield', 'IL', 39.9042, -89.7042, '5552000024', 'Green services'),
('Harbor Civic Annex', 5, '9 Annex Rd', 'Harbor Town', 'IL', 39.6042, -89.5842, '5552000025', 'Annex office');