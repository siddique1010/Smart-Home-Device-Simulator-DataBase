-- =====================================================
--           SMART HOME SYSTEM DATABASE
-- =====================================================

-- =====================================================
-- CREATE DATABASE
-- =====================================================
CREATE DATABASE SmartHome2DB;
USE SmartHome2DB;

-- =====================================================
-- TABLE 1: Users
-- =====================================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(20) CHECK (role IN ('Owner', 'Family', 'Guest')),
    created_at DATETIME DEFAULT GETDATE()
);

-- =====================================================
-- TABLE 2: Rooms
-- =====================================================
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_name VARCHAR(50) NOT NULL,
    floor_number INT,
    square_feet INT
);

-- =====================================================
-- TABLE 3: DeviceTypes
-- =====================================================
CREATE TABLE DeviceTypes (
    device_type_id INT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    has_brightness TINYINT DEFAULT 0,
    has_temperature TINYINT DEFAULT 0,
    has_speed TINYINT DEFAULT 0,
    has_motion_detection TINYINT DEFAULT 0,
    has_volume TINYINT DEFAULT 0
);

-- =====================================================
-- TABLE 4: Devices
-- =====================================================
CREATE TABLE Devices (
    device_id INT PRIMARY KEY,
    device_name VARCHAR(100) NOT NULL,
    device_type_id INT NOT NULL,
    room_id INT,
    user_id INT,
    is_on TINYINT DEFAULT 0,
    current_setting VARCHAR(50),
    power_rating_watts INT NOT NULL,
    installed_date DATE
);

-- =====================================================
-- TABLE 5: Modes
-- =====================================================
CREATE TABLE Modes (
    mode_id INT PRIMARY KEY,
    mode_name VARCHAR(50) NOT NULL,
    category VARCHAR(30) CHECK (category IN ('Seasonal', 'Presence', 'Energy', 'Security', 'Weather')),
    priority_level INT DEFAULT 5,
    description VARCHAR(255)
);

-- Add is_active column for triggers
ALTER TABLE Modes ADD is_active INT DEFAULT 0;

-- =====================================================
-- TABLE 6: Schedules
-- =====================================================
CREATE TABLE Schedules (
    schedule_id INT PRIMARY KEY,
    device_id INT NOT NULL,
    mode_id INT,
    action_command VARCHAR(50) NOT NULL,
    action_value VARCHAR(50),
    schedule_time TIME NOT NULL,
    repeat_type VARCHAR(20) DEFAULT 'daily',
    is_active TINYINT DEFAULT 1
);

-- =====================================================
-- TABLE 7: AutomationRules
-- =====================================================
CREATE TABLE AutomationRules (
    rule_id INT PRIMARY KEY,
    rule_name VARCHAR(100) NOT NULL,
    trigger_type VARCHAR(30) CHECK (trigger_type IN ('motion', 'time', 'temperature', 'weather')),
    trigger_device_id INT,
    trigger_condition VARCHAR(100),
    action_device_id INT NOT NULL,
    action_command VARCHAR(50) NOT NULL,
    action_value VARCHAR(50),
    is_active TINYINT DEFAULT 1
);

-- =====================================================
-- TABLE 8: MotionEvents
-- =====================================================
CREATE TABLE MotionEvents (
    event_id INT PRIMARY KEY,
    camera_id INT NOT NULL,
    detected_at DATETIME DEFAULT GETDATE(),
    duration_seconds INT DEFAULT 0,
    triggered_rule_id INT
);

-- =====================================================
-- TABLE 9: EnergyLogs
-- =====================================================
CREATE TABLE EnergyLogs (
    log_id INT PRIMARY KEY,
    device_id INT NOT NULL,
    mode_id INT,
    log_date DATE NOT NULL,
    hours_on DECIMAL(5,2) DEFAULT 0,
    power_rating_watts INT NOT NULL,
    units_consumed DECIMAL(8,2) DEFAULT 0,
    rate_per_unit DECIMAL(5,2) DEFAULT 20.00,
    cost_rs DECIMAL(8,2) DEFAULT 0
);

-- =====================================================
-- TABLE 10: MonthlyBills
-- =====================================================
CREATE TABLE MonthlyBills (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    bill_month DATE NOT NULL,
    total_units DECIMAL(10,2) DEFAULT 0,
    rate_per_unit DECIMAL(5,2) DEFAULT 20.00,
    total_cost DECIMAL(10,2) DEFAULT 0,
    fixed_charges DECIMAL(8,2) DEFAULT 100,
    tax_amount DECIMAL(8,2) DEFAULT 0,
    grand_total DECIMAL(10,2) DEFAULT 0,
    payment_status VARCHAR(20) DEFAULT 'Unpaid',
    generated_date DATETIME DEFAULT GETDATE(),
    due_date DATE
);

-- =====================================================
-- TABLE 11: VoiceCommands
-- =====================================================
CREATE TABLE VoiceCommands (
    command_id INT PRIMARY KEY,
    user_id INT,
    device_id INT,
    command_text VARCHAR(255) NOT NULL,
    parsed_command VARCHAR(50),
    parsed_value VARCHAR(50),
    executed_at DATETIME DEFAULT GETDATE(),
    success TINYINT DEFAULT 1
);

-- =====================================================
-- TABLE 12: GuestAccessCodes
-- =====================================================
CREATE TABLE GuestAccessCodes (
    code_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    device_id INT NOT NULL,
    access_code VARCHAR(10) NOT NULL,
    guest_name VARCHAR(100),
    valid_from DATETIME NOT NULL,
    valid_until DATETIME NOT NULL,
    times_used INT DEFAULT 0,
    is_active TINYINT DEFAULT 1
);

-- =====================================================
-- TABLE 13: WeatherData
-- =====================================================
CREATE TABLE WeatherData (
    weather_id INT PRIMARY KEY,
    recorded_at DATETIME DEFAULT GETDATE(),
    condition_type VARCHAR(50),
    temperature_celsius DECIMAL(5,2),
    humidity_percent INT,
    is_raining TINYINT DEFAULT 0,
    is_storming TINYINT DEFAULT 0,
    is_heatwave TINYINT DEFAULT 0
);

-- =====================================================
-- TABLE 14: PresenceLogs
-- =====================================================
CREATE TABLE PresenceLogs (
    log_id INT PRIMARY KEY,
    user_id INT,
    detected_at DATETIME DEFAULT GETDATE(),
    presence_status VARCHAR(20) CHECK (presence_status IN ('Home', 'Away', 'Sleeping', 'Guest'))
);

-- =====================================================
-- TABLE 15: Alerts (FIXED WITH IDENTITY)
-- =====================================================
CREATE TABLE Alerts (
    alert_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    alert_type VARCHAR(30) CHECK (alert_type IN ('Security', 'Weather', 'Energy', 'General')),
    alert_message VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    is_read TINYINT DEFAULT 0
);

-- =====================================================
-- TABLE 16: Scenes
-- =====================================================
CREATE TABLE Scenes (
    scene_id INT PRIMARY KEY,
    scene_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

-- =====================================================
-- TABLE 17: SceneActions
-- =====================================================
CREATE TABLE SceneActions (
    action_id INT PRIMARY KEY,
    scene_id INT NOT NULL,
    device_id INT NOT NULL,
    action_command VARCHAR(50) NOT NULL,
    action_value VARCHAR(50)
);

-- =====================================================
-- TABLE 18: ElectricityRates
-- =====================================================
CREATE TABLE ElectricityRates (
    rate_id INT PRIMARY KEY,
    rate_per_unit DECIMAL(5,2) NOT NULL,
    rate_type VARCHAR(20) CHECK (rate_type IN ('Normal', 'Peak', 'Off-Peak')),
    is_current TINYINT DEFAULT 0
);

-- =====================================================
-- TABLE 19: ModeActions
-- =====================================================
CREATE TABLE ModeActions (
    mode_action_id INT PRIMARY KEY,
    mode_id INT NOT NULL,
    device_id INT NOT NULL,
    action_command VARCHAR(50) NOT NULL,
    action_value VARCHAR(50)
);

-- =====================================================
-- ALL FOREIGN KEYS
-- =====================================================

ALTER TABLE Devices ADD FOREIGN KEY (device_type_id) REFERENCES DeviceTypes(device_type_id);
ALTER TABLE Devices ADD FOREIGN KEY (room_id) REFERENCES Rooms(room_id);
ALTER TABLE Devices ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Schedules ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);
ALTER TABLE Schedules ADD FOREIGN KEY (mode_id) REFERENCES Modes(mode_id);

ALTER TABLE AutomationRules ADD FOREIGN KEY (trigger_device_id) REFERENCES Devices(device_id);
ALTER TABLE AutomationRules ADD FOREIGN KEY (action_device_id) REFERENCES Devices(device_id);

ALTER TABLE MotionEvents ADD FOREIGN KEY (camera_id) REFERENCES Devices(device_id);
ALTER TABLE MotionEvents ADD FOREIGN KEY (triggered_rule_id) REFERENCES AutomationRules(rule_id);

ALTER TABLE EnergyLogs ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);
ALTER TABLE EnergyLogs ADD FOREIGN KEY (mode_id) REFERENCES Modes(mode_id);

ALTER TABLE MonthlyBills ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE VoiceCommands ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);
ALTER TABLE VoiceCommands ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);

ALTER TABLE GuestAccessCodes ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);
ALTER TABLE GuestAccessCodes ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);

ALTER TABLE PresenceLogs ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Alerts ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE SceneActions ADD FOREIGN KEY (scene_id) REFERENCES Scenes(scene_id);
ALTER TABLE SceneActions ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);

ALTER TABLE ModeActions ADD FOREIGN KEY (mode_id) REFERENCES Modes(mode_id);
ALTER TABLE ModeActions ADD FOREIGN KEY (device_id) REFERENCES Devices(device_id);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================

INSERT INTO Users (user_id, full_name, email, password_hash, phone_number, role, created_at) VALUES
(1, 'Abdullah', 'abdullah@example.com', 'hash123', '03001234567', 'Owner', GETDATE()),
(2, 'Abdubakar', 'abdubakar@example.com', 'hash456', '03007654321', 'Family', GETDATE()),
(3, 'Ahmad', 'ahmad@example.com', 'hash789', '03009999999', 'Guest', GETDATE());

INSERT INTO Rooms (room_id, room_name, floor_number, square_feet) VALUES
(1, 'Master Bedroom', 1, 250),
(2, 'Living Room', 0, 400),
(3, 'Kitchen', 0, 200),
(4, 'Guest Room', 1, 180),
(5, 'Home Office', 1, 150);

INSERT INTO DeviceTypes (device_type_id, type_name, has_brightness, has_temperature, has_speed, has_motion_detection, has_volume) VALUES
(1, 'Light', 1, 0, 0, 0, 0),
(2, 'AC', 0, 1, 1, 0, 0),
(3, 'Fan', 0, 0, 1, 0, 0),
(4, 'Heater', 0, 1, 0, 0, 0),
(5, 'Camera', 0, 0, 0, 1, 0),
(6, 'Speaker', 0, 0, 0, 0, 1),
(7, 'Lock', 0, 0, 0, 0, 0),
(8, 'Blinds', 0, 0, 0, 0, 0);

INSERT INTO Devices (device_id, device_name, device_type_id, room_id, user_id, is_on, current_setting, power_rating_watts, installed_date) VALUES
(1, 'Master Bedroom AC', 2, 1, 1, 0, '24°C', 1500, '2026-01-15'),
(2, 'Master Bedroom Fan', 3, 1, 1, 0, 'Speed 2', 75, '2026-01-15'),
(3, 'Master Bedroom Light', 1, 1, 1, 0, '50%', 10, '2026-01-15'),
(4, 'Living Room AC', 2, 2, 1, 0, '24°C', 1800, '2026-01-15'),
(5, 'Living Room Light', 1, 2, 1, 0, '100%', 15, '2026-01-15'),
(6, 'Front Door Camera', 5, NULL, 1, 1, 'Armed', 10, '2026-02-01'),
(7, 'Living Room Speaker', 6, 2, 1, 0, 'Volume 30%', 20, '2026-02-01'),
(8, 'Front Door Lock', 7, NULL, 1, 1, 'Locked', 5, '2026-02-01'),
(9, 'Bedroom Heater', 4, 1, 1, 0, '22°C', 2000, '2026-11-01'),
(10, 'Kitchen Light', 1, 3, 1, 0, '100%', 10, '2026-01-15'),
(11, 'Master Bedroom Speaker', 6, 1, 1, 0, 'Volume 30%', 20, '2026-06-06'),
(12, 'Guest Room Speaker', 6, 4, 1, 0, 'Volume 30%', 20, '2026-06-06'),
(13, 'Home Office Speaker', 6, 5, 1, 0, 'Volume 30%', 20, '2026-06-06'),
(14, 'Kitchen Speaker', 6, 3, 1, 0, 'Volume 30%', 20, '2026-06-06');

INSERT INTO Modes (mode_id, mode_name, category, priority_level, description) VALUES
(1, 'Summer', 'Seasonal', 10, 'AC and fans active, cool temperature 22-24°C'),
(2, 'Winter', 'Seasonal', 10, 'Heater active, warm temperature 24-26°C'),
(3, 'Home', 'Presence', 10, 'Normal operation when at home'),
(4, 'Away', 'Presence', 5, 'Energy saving when away'),
(5, 'Vacation', 'Presence', 3, 'Long term away - simulated occupancy'),
(6, 'Sleeping', 'Presence', 4, 'Night time - lights OFF, AC at 22°C'),
(7, 'Guest', 'Presence', 6, 'Visitors present - limited access'),
(8, 'Eco', 'Energy', 8, 'Maximum energy saving'),
(9, 'Peak', 'Energy', 7, 'Reduce usage during expensive hours'),
(10, 'Solar', 'Energy', 9, 'Use virtual solar power'),
(11, 'NightSecurity', 'Security', 10, 'All cameras armed'),
(12, 'Lockdown', 'Security', 1, 'Emergency mode - all doors lock, cameras record'),
(13, 'Rain', 'Weather', 6, 'Close windows, indoor lights ON'),
(14, 'Storm', 'Weather', 2, 'Safety mode - non-essentials OFF'),
(15, 'Heatwave', 'Weather', 5, 'Extreme cooling - AC at 18°C');

-- Set initial active mode
UPDATE Modes SET is_active = 0;
UPDATE Modes SET is_active = 1 WHERE mode_id = 3;

INSERT INTO Schedules (schedule_id, device_id, mode_id, action_command, action_value, schedule_time, repeat_type, is_active) VALUES
(1, 1, 1, 'turn_on', NULL, '18:00:00', 'daily', 1),
(2, 1, 1, 'set_temperature', '22', '18:00:00', 'daily', 1),
(3, 1, 1, 'turn_off', NULL, '06:00:00', 'daily', 1),
(4, 3, 1, 'set_brightness', '100', '07:00:00', 'daily', 1),
(5, 3, 1, 'set_brightness', '10', '22:00:00', 'daily', 1),
(6, 11, 3, 'set_volume', '50', '07:00:00', 'daily', 1);

INSERT INTO AutomationRules (rule_id, rule_name, trigger_type, trigger_device_id, trigger_condition, action_device_id, action_command, action_value, is_active) VALUES
(1, 'Night Motion Light', 'motion', 6, 'after_11pm', 5, 'turn_on', NULL, 1),
(2, 'Heatwave AC Control', 'temperature', NULL, 'above_40', 1, 'set_temperature', '18', 1),
(3, 'Rain Window Close', 'weather', NULL, 'rain', 8, 'close', NULL, 1);

INSERT INTO MotionEvents (event_id, camera_id, detected_at, duration_seconds, triggered_rule_id) VALUES
(1, 6, '2026-06-15 23:15:00', 45, 1),
(2, 6, '2026-06-16 02:30:00', 120, 1);

INSERT INTO EnergyLogs (log_id, device_id, mode_id, log_date, hours_on, power_rating_watts, units_consumed, rate_per_unit, cost_rs) VALUES
(1, 1, 1, '2026-06-15', 8.5, 1500, 12.75, 20.00, 255.00),
(2, 2, 1, '2026-06-15', 10.0, 75, 0.75, 20.00, 15.00),
(3, 3, 1, '2026-06-15', 5.0, 10, 0.05, 20.00, 1.00),
(4, 1, 15, '2026-06-25', 16.0, 1500, 24.00, 20.00, 480.00),
(5, 2, 15, '2026-06-25', 20.0, 75, 1.50, 20.00, 30.00),
(6, 4, 1, '2026-06-15', 6.0, 1800, 10.80, 20.00, 216.00),
(7, 5, 1, '2026-06-15', 4.0, 15, 0.06, 20.00, 1.20);

INSERT INTO MonthlyBills (user_id, bill_month, total_units, rate_per_unit, total_cost, fixed_charges, tax_amount, grand_total, payment_status, generated_date, due_date) VALUES
(1, '2026-06-01', 740.5, 20.00, 14810.00, 100.00, 745.50, 15655.50, 'Unpaid', GETDATE(), DATEADD(DAY, 15, GETDATE()));

INSERT INTO VoiceCommands (command_id, user_id, device_id, command_text, parsed_command, parsed_value, executed_at, success) VALUES
(1, 1, 3, 'turn on bedroom light', 'turn_on', NULL, '2026-06-15 19:30:00', 1),
(2, 1, 1, 'set AC to 22 degrees', 'set_temperature', '22', '2026-06-15 19:31:00', 1),
(3, 1, 3, 'dim lights to 50 percent', 'set_brightness', '50', '2026-06-15 20:00:00', 1),
(4, 1, 11, 'turn on bedroom speaker', 'turn_on', NULL, GETDATE(), 1),
(5, 1, 11, 'set bedroom speaker volume 50', 'set_volume', '50', GETDATE(), 1),
(6, 1, 12, 'turn on guest speaker', 'turn_on', NULL, GETDATE(), 1),
(7, 1, 13, 'turn on office speaker', 'turn_on', NULL, GETDATE(), 1),
(8, 1, 14, 'turn on kitchen speaker', 'turn_on', NULL, GETDATE(), 1);

INSERT INTO GuestAccessCodes (code_id, user_id, device_id, access_code, guest_name, valid_from, valid_until, times_used, is_active) VALUES
(1, 1, 8, '7890', 'John Friend', '2026-06-20 10:00:00', '2026-06-20 22:00:00', 0, 1);

INSERT INTO WeatherData (weather_id, recorded_at, condition_type, temperature_celsius, humidity_percent, is_raining, is_storming, is_heatwave) VALUES
(1, '2026-06-15 14:00:00', 'Sunny', 35.5, 65, 0, 0, 0),
(2, '2026-06-25 14:00:00', 'Heatwave', 44.5, 40, 0, 0, 1),
(3, '2026-07-10 14:00:00', 'Rainy', 28.0, 85, 1, 0, 0);

INSERT INTO PresenceLogs (log_id, user_id, detected_at, presence_status) VALUES
(1, 1, '2026-06-15 08:30:00', 'Home'),
(2, 1, '2026-06-15 09:00:00', 'Away'),
(3, 1, '2026-06-15 18:00:00', 'Home');

INSERT INTO Alerts (user_id, alert_type, alert_message, created_at, is_read) VALUES
(1, 'Security', 'Motion detected at front door at 11:15 PM', '2026-06-15 23:15:00', 0),
(1, 'Weather', 'Heatwave alert! Temperature above 40°C', '2026-06-25 14:00:00', 0);

INSERT INTO Scenes (scene_id, scene_name, description) VALUES
(1, 'Movie Mode', 'Lights dim, AC cool, speakers ON'),
(2, 'Dinner Mode', 'Warm lights, soft music'),
(3, 'Morning Mode', 'Full brightness, AC OFF'),
(4, 'Sleep Mode', 'All OFF, AC at 22°C'),
(5, 'Party Mode', 'Colorful lights, loud music');

INSERT INTO SceneActions (action_id, scene_id, device_id, action_command, action_value) VALUES
(1, 1, 5, 'set_brightness', '10'),
(2, 1, 4, 'set_temperature', '22'),
(3, 1, 7, 'set_volume', '40'),
(4, 2, 5, 'set_brightness', '50'),
(5, 2, 7, 'set_volume', '20'),
(6, 3, 3, 'set_brightness', '100'),
(7, 4, 3, 'turn_off', NULL),
(8, 4, 1, 'set_temperature', '22'),
(9, 1, 11, 'set_volume', '30'),
(10, 1, 12, 'set_volume', '30'),
(11, 1, 13, 'set_volume', '30'),
(12, 1, 14, 'set_volume', '30');

INSERT INTO ElectricityRates (rate_id, rate_per_unit, rate_type, is_current) VALUES
(1, 20.00, 'Normal', 1),
(2, 25.00, 'Peak', 1),
(3, 15.00, 'Off-Peak', 1);

INSERT INTO ModeActions (mode_action_id, mode_id, device_id, action_command, action_value) VALUES
(1, 1, 1, 'set_temperature', '22'),
(2, 1, 2, 'set_speed', '3'),
(3, 15, 1, 'set_temperature', '18'),
(4, 15, 2, 'set_speed', '5'),
(5, 8, 1, 'set_temperature', '26'),
(6, 8, 3, 'set_brightness', '30');


-- =====================================================
-- TABLE STRUCTURES USING sp_help
-- =====================================================

PRINT '==========================================';
PRINT 'TABLE STRUCTURES';
PRINT '==========================================';

EXEC sp_help 'Users';
EXEC sp_help 'Rooms';
EXEC sp_help 'DeviceTypes';
EXEC sp_help 'Devices';
EXEC sp_help 'Modes';
EXEC sp_help 'Schedules';
EXEC sp_help 'AutomationRules';
EXEC sp_help 'MotionEvents';
EXEC sp_help 'EnergyLogs';
EXEC sp_help 'MonthlyBills';
EXEC sp_help 'VoiceCommands';
EXEC sp_help 'GuestAccessCodes';
EXEC sp_help 'WeatherData';
EXEC sp_help 'PresenceLogs';
EXEC sp_help 'Alerts';
EXEC sp_help 'Scenes';
EXEC sp_help 'SceneActions';
EXEC sp_help 'ElectricityRates';
EXEC sp_help 'ModeActions';





-- =====================================================
-- QUERIES
-- =====================================================

-- Query 1: Device Details with Room and Type
SELECT 
    d.device_id,
    d.device_name,
    r.room_name,
    t.type_name,
    CASE WHEN d.is_on = 1 THEN 'ON' ELSE 'OFF' END AS status,
    d.current_setting,
    d.power_rating_watts AS power_watts
FROM Devices d
LEFT JOIN Rooms r ON d.room_id = r.room_id
JOIN DeviceTypes t ON d.device_type_id = t.device_type_id
ORDER BY r.room_name, d.device_name;

-- QUERY 1: یہ کوئری تمام ڈیوائسز کو ان کے کمرے اور ٹائپ کے ساتھ دکھاتی ہے

-- Query 2: Energy Usage by Room with Ranking
SELECT 
    ROW_NUMBER() OVER(ORDER BY SUM(e.units_consumed) DESC) AS rank,
    r.room_name,
    COUNT(e.log_id) AS total_logs,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.units_consumed) AS avg_units_per_day
FROM EnergyLogs e
JOIN Devices d ON e.device_id = d.device_id
JOIN Rooms r ON d.room_id = r.room_id
GROUP BY r.room_id, r.room_name
ORDER BY total_units DESC;

-- QUERY 2: یہ کوئری ہر کمرے کی بجلی استعمال کو رینک کے ساتھ دکھاتی ہے


-- Query 3: Complete Monthly Bill Breakdown
SELECT 
    b.bill_id,
    u.full_name AS customer_name,
    FORMAT(b.bill_month, 'MMMM yyyy') AS bill_period,
    b.total_units,
    b.rate_per_unit,
    b.total_cost AS energy_charges,
    b.fixed_charges,
    b.tax_amount,
    b.grand_total,
    b.payment_status,
    DATEDIFF(DAY, GETDATE(), b.due_date) AS days_until_due,
    CASE 
        WHEN b.payment_status = 'Paid' THEN 'PAID'
        WHEN GETDATE() > b.due_date THEN 'OVERDUE'
        ELSE 'PENDING'
    END AS payment_alert
FROM MonthlyBills b
JOIN Users u ON b.user_id = u.user_id
ORDER BY b.bill_month DESC;

-- QUERY 3: یہ کوئری ماہانہ بل کی مکمل تفصیل دکھاتی ہے


-- Query 4: Which Mode Uses Most Energy?
SELECT 
    m.mode_name,
    m.category,
    COUNT(e.log_id) AS usage_count,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.units_consumed) AS avg_units_per_session,
    RANK() OVER(ORDER BY SUM(e.units_consumed) DESC) AS energy_rank
FROM EnergyLogs e
JOIN Modes m ON e.mode_id = m.mode_id
GROUP BY m.mode_id, m.mode_name, m.category
ORDER BY total_units DESC;

-- QUERY 4: یہ کوئری بتاتی ہے کہ کونسا موڈ سب سے زیادہ بجلی استعمال کرتا ہے


-- Query 5: All Active Automation Rules
SELECT 
    ar.rule_id,
    ar.rule_name,
    ar.trigger_type,
    ar.trigger_condition,
    trigger_dev.device_name AS trigger_device,
    action_dev.device_name AS action_device,
    ar.action_command,
    ar.action_value,
    CASE WHEN ar.is_active = 1 THEN 'Active' ELSE 'Inactive' END AS status
FROM AutomationRules ar
LEFT JOIN Devices trigger_dev ON ar.trigger_device_id = trigger_dev.device_id
JOIN Devices action_dev ON ar.action_device_id = action_dev.device_id
WHERE ar.is_active = 1;

-- QUERY 5: یہ کوئری تمام ایکٹو آٹومیشن رولز دکھاتی ہے


-- Query 6: Today's Automation Schedule
SELECT 
    s.schedule_id,
    d.device_name,
    s.action_command,
    CASE 
        WHEN s.action_value IS NOT NULL THEN s.action_command + ' ' + s.action_value
        ELSE s.action_command
    END AS full_action,
    CONVERT(VARCHAR(5), s.schedule_time, 108) AS time_24h,
    s.repeat_type,
    CASE WHEN s.is_active = 1 THEN 'Active' ELSE 'Inactive' END AS status
FROM Schedules s
JOIN Devices d ON s.device_id = d.device_id
WHERE s.is_active = 1
ORDER BY s.schedule_time;

-- QUERY 6: یہ کوئری آج کے آٹومیشن شیڈول کو دکھاتی ہے


-- Query 7: How Weather Affects Energy Consumption
SELECT 
    w.condition_type,
    COUNT(e.log_id) AS days_analyzed,
    AVG(e.units_consumed) AS avg_daily_units,
    AVG(e.cost_rs) AS avg_daily_cost,
    AVG(w.temperature_celsius) AS avg_temperature,
    AVG(w.humidity_percent) AS avg_humidity
FROM WeatherData w
JOIN EnergyLogs e ON CAST(w.recorded_at AS DATE) = e.log_date
GROUP BY w.condition_type
ORDER BY avg_daily_units DESC;

-- QUERY 7: یہ کوئری بتاتی ہے کہ موسم کا بجلی استعمال پر کیا اثر ہوتا ہے


-- Query 8: Security Dashboard
SELECT 
    d.device_name AS camera_name,
    COUNT(m.event_id) AS motion_count,
    SUM(m.duration_seconds) AS total_duration_seconds,
    SUM(m.duration_seconds) / 60 AS total_duration_minutes,
    COUNT(a.alert_id) AS alert_count,
    MAX(m.detected_at) AS last_motion_detected
FROM Devices d
LEFT JOIN MotionEvents m ON d.device_id = m.camera_id
LEFT JOIN Alerts a ON a.alert_type = 'Security' AND CAST(a.created_at AS DATE) = CAST(m.detected_at AS DATE)
WHERE d.device_type_id = 5
GROUP BY d.device_id, d.device_name
ORDER BY motion_count DESC;



-- Query 9: Alexa Voice Command Analytics
SELECT 
    u.full_name AS user_name,
    COUNT(vc.command_id) AS total_commands,
    SUM(CASE WHEN vc.success = 1 THEN 1 ELSE 0 END) AS successful_commands,
    SUM(CASE WHEN vc.success = 0 THEN 1 ELSE 0 END) AS failed_commands,
    CAST(SUM(CASE WHEN vc.success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(vc.command_id) AS DECIMAL(5,2)) AS success_rate_percent
FROM VoiceCommands vc
JOIN Users u ON vc.user_id = u.user_id
GROUP BY u.user_id, u.full_name;

-- Query 10: Most Active Devices (Top 5)
SELECT TOP 5
    d.device_name,
    r.room_name,
    COUNT(e.log_id) AS days_used,
    SUM(e.hours_on) AS total_hours_on,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.hours_on) AS avg_hours_per_day
FROM EnergyLogs e
JOIN Devices d ON e.device_id = d.device_id
LEFT JOIN Rooms r ON d.room_id = r.room_id
GROUP BY d.device_id, d.device_name, r.room_name
ORDER BY total_units DESC;

-- Query 11: Complete Scene Actions
SELECT 
    s.scene_name,
    d.device_name,
    sa.action_command,
    CASE 
        WHEN sa.action_value IS NOT NULL THEN sa.action_value
        ELSE 'N/A'
    END AS action_value,
    s.description
FROM Scenes s
JOIN SceneActions sa ON s.scene_id = sa.scene_id
JOIN Devices d ON sa.device_id = d.device_id
ORDER BY s.scene_name;

-- Query 12: Complete System Summary
SELECT 
    'Total Devices' AS metric,
    CAST(COUNT(*) AS VARCHAR) AS value
FROM Devices
UNION ALL
SELECT 
    'Active Devices',
    CAST(COUNT(*) AS VARCHAR)
FROM Devices WHERE is_on = 1
UNION ALL
SELECT 
    'Total Rooms',
    CAST(COUNT(*) AS VARCHAR)
FROM Rooms
UNION ALL
SELECT 
    'Total Modes',
    CAST(COUNT(*) AS VARCHAR)
FROM Modes
UNION ALL
SELECT 
    'Active Schedules',
    CAST(COUNT(*) AS VARCHAR)
FROM Schedules WHERE is_active = 1
UNION ALL
SELECT 
    'Total Energy Consumed (kWh)',
    CAST(SUM(units_consumed) AS VARCHAR) + ' kWh'
FROM EnergyLogs
UNION ALL
SELECT 
    'Total Cost (Rs.)',
    'Rs. ' + CAST(SUM(cost_rs) AS VARCHAR)
FROM EnergyLogs
UNION ALL
SELECT 
    'Motion Events',
    CAST(COUNT(*) AS VARCHAR)
FROM MotionEvents
UNION ALL
SELECT 
    'Unread Alerts',
    CAST(COUNT(*) AS VARCHAR)
FROM Alerts WHERE is_read = 0;

-- =====================================================
-- VIEWS
-- =====================================================

DROP VIEW IF EXISTS vw_CurrentDeviceStatus;
DROP VIEW IF EXISTS vw_MonthlyEnergySummary;
DROP VIEW IF EXISTS vw_ActiveAutomationRules;
DROP VIEW IF EXISTS vw_UnpaidBills;
DROP VIEW IF EXISTS vw_SecurityDashboard;
DROP VIEW IF EXISTS vw_DeviceTypeSummary;
DROP VIEW IF EXISTS vw_ModeEfficiency;
DROP VIEW IF EXISTS vw_TodaySchedule;
DROP VIEW IF EXISTS vw_UserActivity;
DROP VIEW IF EXISTS vw_WeatherImpact;

CREATE VIEW vw_CurrentDeviceStatus AS
SELECT 
    d.device_id,
    d.device_name,
    ISNULL(r.room_name, 'Not Assigned') AS room_name,
    t.type_name AS device_type,
    CASE WHEN d.is_on = 1 THEN 'ON' ELSE 'OFF' END AS current_state,
    d.current_setting,
    d.power_rating_watts AS power_rating,
    u.full_name AS owner_name
FROM Devices d
LEFT JOIN Rooms r ON d.room_id = r.room_id
JOIN DeviceTypes t ON d.device_type_id = t.device_type_id
JOIN Users u ON d.user_id = u.user_id;

CREATE VIEW vw_MonthlyEnergySummary AS
SELECT 
    FORMAT(e.log_date, 'yyyy-MM') AS year_month,
    COUNT(DISTINCT e.device_id) AS active_devices,
    SUM(e.hours_on) AS total_hours,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.units_consumed) AS avg_units_per_device
FROM EnergyLogs e
GROUP BY FORMAT(e.log_date, 'yyyy-MM');

CREATE VIEW vw_ActiveAutomationRules AS
SELECT 
    ar.rule_id,
    ar.rule_name,
    ar.trigger_type,
    ar.trigger_condition,
    ISNULL(td.device_name, 'System') AS trigger_device,
    ad.device_name AS action_device,
    ar.action_command,
    ISNULL(ar.action_value, 'N/A') AS action_value
FROM AutomationRules ar
LEFT JOIN Devices td ON ar.trigger_device_id = td.device_id
JOIN Devices ad ON ar.action_device_id = ad.device_id
WHERE ar.is_active = 1;

CREATE VIEW vw_UnpaidBills AS
SELECT 
    b.bill_id,
    u.full_name,
    FORMAT(b.bill_month, 'MMMM yyyy') AS bill_period,
    b.total_units,
    b.grand_total AS amount_due,
    b.due_date,
    DATEDIFF(DAY, GETDATE(), b.due_date) AS days_left,
    CASE 
        WHEN GETDATE() > b.due_date THEN 'OVERDUE'
        ELSE 'Pending'
    END AS status
FROM MonthlyBills b
JOIN Users u ON b.user_id = u.user_id
WHERE b.payment_status = 'Unpaid';

CREATE VIEW vw_SecurityDashboard AS
SELECT 
    d.device_name AS camera_name,
    r.room_name AS location,
    CASE WHEN d.is_on = 1 THEN 'Armed' ELSE 'Disarmed' END AS status,
    COUNT(m.event_id) AS motion_detections,
    ISNULL(SUM(m.duration_seconds), 0) AS total_detection_seconds,
    MAX(m.detected_at) AS last_motion,
    COUNT(a.alert_id) AS alerts_generated
FROM Devices d
LEFT JOIN Rooms r ON d.room_id = r.room_id
LEFT JOIN MotionEvents m ON d.device_id = m.camera_id
LEFT JOIN Alerts a ON a.alert_type = 'Security' AND a.user_id = d.user_id
WHERE d.device_type_id = 5
GROUP BY d.device_id, d.device_name, r.room_name, d.is_on;

CREATE VIEW vw_DeviceTypeSummary AS
SELECT 
    t.type_name,
    COUNT(d.device_id) AS total_devices,
    SUM(CASE WHEN d.is_on = 1 THEN 1 ELSE 0 END) AS active_devices,
    SUM(CASE WHEN t.has_brightness = 1 THEN 1 ELSE 0 END) AS has_brightness,
    SUM(CASE WHEN t.has_temperature = 1 THEN 1 ELSE 0 END) AS has_temperature,
    SUM(CASE WHEN t.has_speed = 1 THEN 1 ELSE 0 END) AS has_speed,
    SUM(CASE WHEN t.has_motion_detection = 1 THEN 1 ELSE 0 END) AS has_motion_detection
FROM DeviceTypes t
LEFT JOIN Devices d ON t.device_type_id = d.device_type_id
GROUP BY t.device_type_id, t.type_name;

CREATE VIEW vw_ModeEfficiency AS
SELECT 
    m.mode_name,
    m.category,
    COUNT(e.log_id) AS times_used,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.units_consumed) AS avg_units_per_use,
    RANK() OVER(ORDER BY AVG(e.units_consumed) ASC) AS efficiency_rank
FROM Modes m
JOIN EnergyLogs e ON m.mode_id = e.mode_id
GROUP BY m.mode_id, m.mode_name, m.category;

CREATE VIEW vw_TodaySchedule AS
SELECT
    s.schedule_id,
    d.device_name,
    r.room_name,
    s.action_command,
    s.action_value,
    CONVERT(VARCHAR(5), s.schedule_time, 108) AS trigger_time,
    s.repeat_type
FROM Schedules s
JOIN Devices d ON s.device_id = d.device_id
LEFT JOIN Rooms r ON d.room_id = r.room_id
WHERE s.is_active = 1;

CREATE VIEW vw_UserActivity AS
SELECT 
    u.full_name,
    u.role,
    COUNT(DISTINCT vc.command_id) AS voice_commands,
    COUNT(DISTINCT gc.code_id) AS guest_codes_created,
    (
        SELECT COUNT(*)
        FROM PresenceLogs p
        WHERE p.user_id = u.user_id
    ) AS presence_logs,
    (
        SELECT SUM(e.units_consumed)
        FROM EnergyLogs e
        JOIN Devices d ON e.device_id = d.device_id
        WHERE d.user_id = u.user_id
    ) AS total_energy_consumed
FROM Users u
LEFT JOIN VoiceCommands vc ON u.user_id = vc.user_id
LEFT JOIN GuestAccessCodes gc ON u.user_id = gc.user_id
GROUP BY u.user_id, u.full_name, u.role;

CREATE VIEW vw_WeatherImpact AS
SELECT
    w.condition_type,
    COUNT(DISTINCT CAST(w.recorded_at AS DATE)) AS days,
    AVG(w.temperature_celsius) AS avg_temp,
    AVG(w.humidity_percent) AS avg_humidity,
    SUM(e.units_consumed) AS total_units,
    SUM(e.cost_rs) AS total_cost,
    AVG(e.units_consumed) AS avg_units_per_day
FROM WeatherData w
JOIN EnergyLogs e ON CAST(w.recorded_at AS DATE) = e.log_date
GROUP BY w.condition_type;


-- =====================================================
-- ALL VIEWS OUTPUT - COPY AND RUN THIS WHOLE SCRIPT
-- =====================================================

PRINT '==========================================';
PRINT 'VIEW 1: Current Device Status';
PRINT '==========================================';
SELECT * FROM vw_CurrentDeviceStatus;

PRINT '==========================================';
PRINT 'VIEW 2: Monthly Energy Summary';
PRINT '==========================================';
SELECT * FROM vw_MonthlyEnergySummary;

PRINT '==========================================';
PRINT 'VIEW 3: Active Automation Rules';
PRINT '==========================================';
SELECT * FROM vw_ActiveAutomationRules;

PRINT '==========================================';
PRINT 'VIEW 4: Unpaid Bills';
PRINT '==========================================';
SELECT * FROM vw_UnpaidBills;

PRINT '==========================================';
PRINT 'VIEW 5: Security Dashboard';
PRINT '==========================================';
SELECT * FROM vw_SecurityDashboard;

PRINT '==========================================';
PRINT 'VIEW 6: Device Type Summary';
PRINT '==========================================';
SELECT * FROM vw_DeviceTypeSummary;

PRINT '==========================================';
PRINT 'VIEW 7: Mode Efficiency';
PRINT '==========================================';
SELECT * FROM vw_ModeEfficiency;

PRINT '==========================================';
PRINT 'VIEW 8: Today Schedule';
PRINT '==========================================';
SELECT * FROM vw_TodaySchedule ORDER BY trigger_time;

PRINT '==========================================';
PRINT 'VIEW 9: User Activity';
PRINT '==========================================';
SELECT * FROM vw_UserActivity;

PRINT '==========================================';
PRINT 'VIEW 10: Weather Impact';
PRINT '==========================================';
SELECT * FROM vw_WeatherImpact;

PRINT '==========================================';
PRINT 'ALL VIEWS DISPLAYED SUCCESSFULLY!';
PRINT '==========================================';



-- =====================================================
-- TRIGGERS
-- =====================================================

DROP TRIGGER IF EXISTS trg_AutoLogEnergy;
DROP TRIGGER IF EXISTS trg_AutoMotionAlert;
DROP TRIGGER IF EXISTS trg_AutoCalculateBill;
DROP TRIGGER IF EXISTS trg_AutoWeatherMode;
DROP TRIGGER IF EXISTS trg_AutoPresenceLog;
DROP TRIGGER IF EXISTS trg_AutoDeviceFromVoice;
DROP TRIGGER IF EXISTS trg_AutoExpireGuestCodes;
DROP TRIGGER IF EXISTS trg_CheckRoomCapacity;

CREATE TRIGGER trg_AutoLogEnergy
ON Devices
AFTER UPDATE
AS
BEGIN
    INSERT INTO EnergyLogs (device_id, log_date, hours_on, power_rating_watts, units_consumed, rate_per_unit, cost_rs)
    SELECT 
        i.device_id,
        CAST(GETDATE() AS DATE),
        0,
        i.power_rating_watts,
        0,
        20.00,
        0
    FROM inserted i
    JOIN deleted d ON i.device_id = d.device_id
    WHERE i.is_on = 1 AND d.is_on = 0;
    
    UPDATE e
    SET e.hours_on = DATEDIFF(HOUR, e.log_date, GETDATE()),
        e.units_consumed = (DATEDIFF(HOUR, e.log_date, GETDATE()) * e.power_rating_watts) / 1000.0,
        e.cost_rs = ((DATEDIFF(HOUR, e.log_date, GETDATE()) * e.power_rating_watts) / 1000.0) * 20.00
    FROM EnergyLogs e
    JOIN inserted i ON e.device_id = i.device_id
    JOIN deleted d ON i.device_id = d.device_id
    WHERE i.is_on = 0 AND d.is_on = 1
    AND e.log_date = CAST(GETDATE() AS DATE)
    AND e.hours_on = 0;
END;

CREATE TRIGGER trg_AutoMotionAlert
ON MotionEvents
AFTER INSERT
AS
BEGIN
    INSERT INTO Alerts (user_id, alert_type, alert_message, created_at, is_read)
    SELECT 
        d.user_id,
        'Security',
        'MOTION ALERT: Motion detected on ' + d.device_name,
        GETDATE(),
        0
    FROM inserted i
    JOIN Devices d ON i.camera_id = d.device_id;
END;

CREATE TRIGGER trg_AutoCalculateBill
ON MonthlyBills
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO MonthlyBills (user_id, bill_month, total_units, rate_per_unit, total_cost, fixed_charges, tax_amount, grand_total, payment_status, generated_date, due_date)
    SELECT 
        user_id,
        bill_month,
        total_units,
        rate_per_unit,
        (total_units * rate_per_unit) AS total_cost,
        100 AS fixed_charges,
        ((total_units * rate_per_unit) + 100) * 0.05 AS tax_amount,
        ((total_units * rate_per_unit) + 100) * 1.05 AS grand_total,
        'Unpaid',
        GETDATE(),
        DATEADD(DAY, 15, GETDATE())
    FROM inserted;
END;

CREATE TRIGGER trg_AutoWeatherMode
ON WeatherData
AFTER INSERT
AS
BEGIN
    DECLARE @is_heatwave INT;
    DECLARE @is_raining INT;
    DECLARE @is_storming INT;
    
    SELECT 
        @is_heatwave = ISNULL(is_heatwave, 0),
        @is_raining = ISNULL(is_raining, 0), 
        @is_storming = ISNULL(is_storming, 0)
    FROM inserted;
    
    UPDATE Modes SET is_active = 0;
    
    IF @is_heatwave = 1
        UPDATE Modes SET is_active = 1 WHERE mode_id = 15;
    ELSE IF @is_storming = 1
        UPDATE Modes SET is_active = 1 WHERE mode_id = 14;
    ELSE IF @is_raining = 1
        UPDATE Modes SET is_active = 1 WHERE mode_id = 13;
    ELSE
        UPDATE Modes SET is_active = 1 WHERE mode_id = 3;
END;

CREATE TRIGGER trg_AutoPresenceLog
ON PresenceLogs
AFTER INSERT
AS
BEGIN
    DECLARE @presence_status VARCHAR(20);
    SELECT @presence_status = presence_status FROM inserted;
    
    IF @presence_status = 'Away'
    BEGIN
        UPDATE Modes SET is_active = 0;
        UPDATE Modes SET is_active = 1 WHERE mode_id = 4;
    END
    ELSE IF @presence_status = 'Home'
    BEGIN
        UPDATE Modes SET is_active = 0;
        UPDATE Modes SET is_active = 1 WHERE mode_id = 3;
    END
    ELSE IF @presence_status = 'Sleeping'
    BEGIN
        UPDATE Modes SET is_active = 0;
        UPDATE Modes SET is_active = 1 WHERE mode_id = 6;
    END
END;

CREATE TRIGGER trg_AutoDeviceFromVoice
ON VoiceCommands
AFTER INSERT
AS
BEGIN
    UPDATE d
    SET d.is_on = CASE 
            WHEN i.parsed_command = 'turn_on' THEN 1
            WHEN i.parsed_command = 'turn_off' THEN 0
            ELSE d.is_on
        END,
        d.current_setting = CASE 
            WHEN i.parsed_command = 'set_brightness' AND i.parsed_value IS NOT NULL THEN i.parsed_value + '%'
            WHEN i.parsed_command = 'set_temperature' AND i.parsed_value IS NOT NULL THEN i.parsed_value + '°C'
            ELSE d.current_setting
        END
    FROM Devices d
    JOIN inserted i ON d.device_id = i.device_id
    WHERE i.success = 1;
END;

CREATE TRIGGER trg_AutoExpireGuestCodes
ON GuestAccessCodes
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE GuestAccessCodes
    SET is_active = 0
    WHERE valid_until < GETDATE() AND is_active = 1;
END;

CREATE TRIGGER trg_CheckRoomCapacity
ON Devices
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @room_id INT;
    DECLARE @device_count INT;
    DECLARE @max_devices_per_room INT = 10;
    
    SELECT @room_id = room_id FROM inserted;
    SELECT @device_count = COUNT(*) FROM Devices WHERE room_id = @room_id;
    
    IF @device_count < @max_devices_per_room OR @room_id IS NULL
    BEGIN
        INSERT INTO Devices (device_id, device_name, device_type_id, room_id, user_id, is_on, current_setting, power_rating_watts, installed_date)
        SELECT device_id, device_name, device_type_id, room_id, user_id, is_on, current_setting, power_rating_watts, installed_date
        FROM inserted;
    END
    ELSE
    BEGIN
        RAISERROR('Room capacity exceeded! Cannot add more devices.', 16, 1);
    END
END;

-- =====================================================
-- TEST TRIGGERS
-- =====================================================

PRINT '==========================================';
PRINT 'TESTING TRIGGERS';
PRINT '==========================================';

PRINT '----- TEST 1: Auto-Log Energy -----';
UPDATE Devices SET is_on = 1 WHERE device_id = 3;
UPDATE Devices SET is_on = 0 WHERE device_id = 3;
PRINT 'Test 1 complete';

PRINT '----- TEST 2: Auto-Motion Alert -----';
INSERT INTO MotionEvents (event_id, camera_id, detected_at, duration_seconds, triggered_rule_id)
VALUES (999, 6, GETDATE(), 45, 1);
PRINT 'Test 2 complete';

PRINT '----- TEST 3: Auto-Calculate Bill -----';
INSERT INTO MonthlyBills (user_id, bill_month, total_units, rate_per_unit)
VALUES (1, '2026-07-01', 500, 20);
PRINT 'Test 3 complete';

PRINT '----- TEST 4: Auto-Weather Mode -----';
INSERT INTO WeatherData (weather_id, recorded_at, condition_type, temperature_celsius, humidity_percent, is_heatwave, is_raining, is_storming)
VALUES (999, GETDATE(), 'Heatwave', 44.5, 40, 1, 0, 0);
PRINT 'Test 4 complete';

PRINT '----- TEST 5: Auto-Presence Log -----';
UPDATE Modes SET is_active = 0;
UPDATE Modes SET is_active = 1 WHERE mode_id = 3;
INSERT INTO PresenceLogs (log_id, user_id, detected_at, presence_status)
VALUES (999, 1, GETDATE(), 'Away');
PRINT 'Test 5 complete';




PRINT '----- TEST 7: Auto-Expire Guest Codes -----';
INSERT INTO GuestAccessCodes (code_id, user_id, device_id, access_code, guest_name, valid_from, valid_until, times_used, is_active)
VALUES (999, 1, 8, '9999', 'Test Guest', DATEADD(HOUR, -1, GETDATE()), GETDATE(), 0, 1);
PRINT 'Test 7 complete';

PRINT '----- TEST 8: Auto-Check Room Capacity -----';
BEGIN TRY
    INSERT INTO Devices (device_id, device_name, device_type_id, room_id, user_id, is_on, current_setting, power_rating_watts, installed_date)
    VALUES (888, 'Test Device', 1, 1, 1, 0, 'Test', 100, GETDATE());
    PRINT 'Device added';
END TRY
BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH
PRINT 'Test 8 complete';

-- =====================================================
-- CLEAN UP TEST DATA
-- =====================================================
DELETE FROM MotionEvents WHERE event_id = 999;
DELETE FROM WeatherData WHERE weather_id = 999;
DELETE FROM PresenceLogs WHERE log_id = 999;
DELETE FROM VoiceCommands WHERE command_id = 999;
DELETE FROM GuestAccessCodes WHERE code_id = 999;
DELETE FROM Devices WHERE device_id IN (888, 999);
DELETE FROM MonthlyBills WHERE bill_month = '2026-07-01';   
-- Trigger ka sara data delte kar raha ha ju hm na test kia hain ok



SELECT TOP 1 * FROM Devices ORDER BY power_rating_watts DESC

SELECT device_name FROM Devices ORDER BY device_name ASC

SELECT device_name, power_rating_watts FROM Devices ORDER BY power_rating_watts DESC

SELECT d.device_name, r.room_name FROM Devices d JOIN Rooms r ON d.room_id = r.room_id

SELECT GETDATE()

SELECT SUM(units_consumed) FROM EnergyLogs

SELECT 
    r.room_name,
    COUNT(d.device_id) AS device_count
FROM Rooms r
LEFT JOIN Devices d ON r.room_id = d.room_id
GROUP BY r.room_name
HAVING COUNT(d.device_id) > 2;

SELECT device_name, room_id, current_setting 
FROM Devices 
WHERE room_id IS NULL OR current_setting IS NULL;


INSERT INTO Rooms (room_id, room_name, floor_number, square_feet) 
VALUES (6, 'Main Entrance', 0, 30);

INSERT INTO Rooms (room_id, room_name, floor_number, square_feet) 
VALUES (8, 'Security Room', 1, 100);

UPDATE Devices 
SET room_id = 6 
WHERE room_id IS NULL;

select* from Devices 
where room_id = 6;



SELECT * FROM WeatherData WHERE condition_type = 'Rainy';

SELECT 
    MIN(humidity_percent) AS overall_min_humidity
FROM WeatherData;

SELECT TOP 1
    weather_id,
    recorded_at,
    condition_type,
    temperature_celsius,
    humidity_percent,
    is_raining,
    is_storming,
    is_heatwave
FROM WeatherData
ORDER BY humidity_percent ASC;