CREATE DATABASE cybercafe_db;
USE cybercafe_db;

CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_admin BOOLEAN DEFAULT FALSE
);

CREATE TABLE computers (
    id INT PRIMARY KEY,
    computer_number VARCHAR(10) NOT NULL,
    is_occupied BOOLEAN DEFAULT FALSE,
    hourly_rate DECIMAL(10,2) NOT NULL
);

CREATE TABLE sessions (
    id INT PRIMARY KEY,
    computer_id INT NOT NULL,
    user_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    total_cost DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (computer_id) REFERENCES computers(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert sample computers
INSERT INTO computers (computer_number, hourly_rate) VALUES
('PC001', 10.00),
('PC002', 10.00),
('PC003', 10.00),
('PC004', 10.00),
('PC005', 10.00),
('PC006', 10.00);

-- Insert admin account
INSERT INTO users (id, username, password, email, phone, gender, is_admin) VALUES
(1, 'admin', 'admin', 'admin@cybercafe.com', '1234567890', 'Male', TRUE);
