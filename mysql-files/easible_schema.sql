-- Easible full schema + expanded dummy data
CREATE DATABASE IF NOT EXISTS easible_db;
CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(180) UNIQUE,
  phone VARCHAR(32),
  password VARCHAR(255),
  role VARCHAR(32) DEFAULT 'user',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS facilities (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(200) NOT NULL,
  category_id INT NOT NULL,
  address VARCHAR(300),
  city VARCHAR(120),
  state VARCHAR(120),
  lat DOUBLE,
  lng DOUBLE,
  phone VARCHAR(32),
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  facility_id INT,
  category_id INT,
  name VARCHAR(200) NOT NULL,
  documents TEXT,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS slots (
  id INT PRIMARY KEY AUTO_INCREMENT,
  facility_id INT NOT NULL,
  category_id INT,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  available TINYINT(1) DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS booking (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  slot_id INT,
  facility_id INT,
  status VARCHAR(32) DEFAULT 'confirmed',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (slot_id) REFERENCES slots(id) ON DELETE SET NULL,
  FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS complaints (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  facility_id INT,
  message TEXT,
  status VARCHAR(32) DEFAULT 'open',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS booking_requests (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_id INT,
  name VARCHAR(120),
  phone VARCHAR(32),
  preferred_time DATETIME,
  status VARCHAR(32) DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Insert base users
INSERT INTO users (id, name, email, phone, password, role) VALUES
(1, 'Admin User', 'admin@example.com', '5551112222', '$2y$10$dTEqx/aL1vk80pQGVYtvg.dXI2Cne83TfsINsjgODcDYq9mIEsVnK', 'admin');

-- Categories
INSERT INTO categories (id, name, description) VALUES
(1, 'Hospital', 'Medical facilities and emergency hospitals'),
(2, 'Police Station', 'Police and law enforcement stations'),
(3, 'Fire Station', 'Fire departments and rescue'),
(4, 'Pharmacy', 'Medicines and 24/7 pharmacies'),
(5, 'Municipal Services', 'Government offices and civic services'),
(6, 'Ambulance Service', 'Ambulance and emergency transport'),
(7, 'RTO', 'Regional Transport Office services'),
(8, 'Electricity', 'Electricity provider offices');

-- Facilities (expanded)
INSERT INTO facilities (id, name, category_id, address, city, state, lat, lng, phone, description) VALUES
(1, 'City General Hospital', 1, '123 Main St', 'Springfield', 'IL', 39.7817, -89.6501, '5553334444', '24/7 emergency hospital.'),
(2, 'Northside Pharmacy', 4, '45 North Ave', 'Springfield', 'IL', 39.7890, -89.6600, '5554445555', 'Open 24 hours.'),
(3, 'Downtown Fire Station', 3, '10 Fire Ln', 'Shelbyville', 'IL', 39.5000, -89.7000, '5556667777', 'Rapid response team.'),
(4, 'Central Police Station', 2, '200 Justice Rd', 'Springfield', 'IL', 39.7800, -89.6520, '5558889999', 'Main police station.'),
(5, 'Westside Community Hospital', 1, '77 West Ave', 'Shelbyville', 'IL', 39.5100, -89.7100, '5551010202', 'Community hospital with outpatient services.'),
(6, 'East End Pharmacy', 4, '12 East St', 'Capitol City', 'IL', 39.8200, -89.6000, '5552020303', 'Open till midnight.'),
(7, 'North Precinct Police', 2, '88 North Rd', 'Capitol City', 'IL', 39.8300, -89.6100, '5553030404', 'Police precinct for north districts.'),
(8, 'Central Fire Station', 3, '1 Flame Blvd', 'Capitol City', 'IL', 39.8350, -89.6150, '5554040505', 'Fire and rescue HQ.'),
(9, 'Regional RTO Office', 7, '500 Transport Way', 'Springfield', 'IL', 39.7900, -89.6550, '5555050606', 'License and vehicle registration.'),
(10, 'Municipal Office - Civic Services', 5, '250 Civic Plaza', 'Shelbyville', 'IL', 39.4950, -89.7050, '5556060707', 'Local municipal services and complaints.'),
(11, 'Ambulance Station Alpha', 6, 'Ambulance Bay 3', 'Capitol City', 'IL', 39.8400, -89.6200, '5557070808', '24/7 ambulance service.'),
(12, 'Power Distribution Office', 8, '120 Grid Rd', 'Springfield', 'IL', 39.7820, -89.6480, '5558080909', 'Report outages and payments.');

-- Services linked to facilities
INSERT INTO services (id, facility_id, category_id, name, documents, description) VALUES
(1, 1, 1, 'Emergency Room', 'ID Proof, Insurance Card', 'Full-service ER for trauma and urgent care'),
(2, 1, 1, 'Outpatient Clinic', 'ID Proof', 'General consultations and follow-ups'),
(3, 2, 4, 'Prescription Pick-up', 'Prescription', 'Medicine dispensing and counselling'),
(4, NULL, 5, 'Driving License', 'Aadhar Card, Passport Photo, Address Proof', 'Government driving license service'),
(5, 9, 7, 'Vehicle Registration', 'RC, Insurance', 'New and renew vehicle registration services'),
(6, 11, 6, 'Emergency Ambulance', 'ID Proof', 'Ambulance dispatch and emergency transport');

-- Slots
INSERT INTO slots (id, facility_id, category_id, start_time, end_time, available) VALUES
(1, 1, 1, '2026-04-24 09:00:00', '2026-04-24 09:30:00', 1),
(2, 1, 1, '2026-04-24 09:30:00', '2026-04-24 10:00:00', 0),
(3, 2, 4, '2026-04-24 10:00:00', '2026-04-24 10:30:00', 1),
(4, 9, 7, '2026-04-25 11:00:00', '2026-04-25 11:30:00', 1);

-- Bookings
INSERT INTO booking (id, user_id, slot_id, facility_id, created_at) VALUES
(1, 2, 1, 1, NOW());

-- Complaints
INSERT INTO complaints (id, user_id, facility_id, message, created_at) VALUES
(1, 2, 1, 'Long waiting time in ER', NOW());

-- Booking requests
INSERT INTO booking_requests (id, category_id, name, phone, preferred_time, status, created_at) VALUES
(1, 3, 'Charlie Request', '5550001111', '2026-04-25 14:00:00', 'pending', NOW());

-- Requirements-related entries (services that require documents or fees)
INSERT INTO services (facility_id, category_id, name, documents, description) VALUES
(10, 5, 'Birth Certificate Issuance', 'Aadhar, Proof of Birth', 'Municipal birth certificate service'),
(10, 5, 'Property Tax Payment', 'Property ID, Bill', 'Municipal tax collection office');

-- Additional hospitals / public services for coverage
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
('St. Mary Hospital', 1, '99 St Mary Rd', 'Capitol City', 'IL', 39.8450, -89.6300, '5559091010', 'Specialized maternity and pediatric care.'),
('Greenfield Clinic', 1, '14 Greenfield', 'Shelbyville', 'IL', 39.5150, -89.7120, '5550101112', 'Primary care and immunizations'),
('Union Police Station', 2, '3 Union St', 'Northfield', 'IL', 39.9000, -89.7000, '5551213141', 'Local policing services'),
('Harbor Fire Station', 3, 'Dockside 7', 'Harbor Town', 'IL', 39.6000, -89.5800, '5551516171', 'Harbor rescue and fire services');



-- state wise facilities
INSERT INTO facilities (name, category_id, address, city, state, lat, lng, phone, description) VALUES
('Apollo Hospital Delhi', 1, 'Sarita Vihar', 'Delhi', 'Delhi', 28.5355, 77.2880, '9991112222', 'Multi-speciality hospital'),
('AIIMS Delhi', 1, 'Ansari Nagar', 'Delhi', 'Delhi', 28.5672, 77.2100, '9991113333', 'Top government hospital'),
('Mumbai Police HQ', 2, 'Marine Drive', 'Mumbai', 'Maharashtra', 18.9430, 72.8238, '8881112222', 'Main police HQ'),
('Bandra Police Station', 2, 'Bandra West', 'Mumbai', 'Maharashtra', 19.0596, 72.8295, '8881113333', 'Local police station'),
('Chennai Fire Station', 3, 'T Nagar', 'Chennai', 'Tamil Nadu', 13.0418, 80.2341, '7771112222', 'Fire response team'),
('Bangalore Fire Dept', 3, 'Indiranagar', 'Bangalore', 'Karnataka', 12.9716, 77.5946, '7771113333', 'Emergency fire service');



-- requirements 
INSERT INTO services (category_id, name, documents, description) VALUES
(2, 'File FIR', 'ID Proof, Address Proof', 'Register a police complaint'),
(2, 'Police Verification', 'ID Proof, Photo', 'Verification for jobs/passports'),

(1, 'Hospital Admission', 'ID Proof, Insurance, Medical History', 'Get admitted in hospital'),
(1, 'Medical Certificate', 'Doctor Consultation', 'Fitness/medical certificate'),

(5, 'Death Certificate', 'Hospital Report, ID Proof', 'Municipal service'),
(5, 'Water Connection', 'Address Proof, ID Proof', 'Apply for water supply'),

(7, 'Driving License Renewal', 'Old License, ID Proof', 'Renew DL'),
(7, 'Vehicle Transfer', 'RC, ID Proof, Insurance', 'Transfer ownership');

use easible_db;
rename table services to requirements;

describe booking_requests;
ALTER TABLE booking_requests 
MODIFY preferred_time VARCHAR(50);
-- End of seed file
