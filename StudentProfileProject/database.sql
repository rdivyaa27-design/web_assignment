CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(30) DEFAULT 'Faculty'
);
INSERT INTO users (username, password, full_name, role) VALUES
('admin', 'admin123', 'Lab Administrator', 'Admin'),
('faculty', 'faculty123', 'Prof. Divya R.', 'Faculty'),
('student', 'student123', 'Guest Student', 'Student');
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    roll_number VARCHAR(30) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    course VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    photo VARCHAR(255),
    document VARCHAR(255)
);
INSERT INTO students (name, roll_number, email, course, phone, photo, document) VALUES
('Aarav Sharma', 'CS2026-001', 'aarav.sharma@example.com', 'Computer Science & Engineering', '+91 98765 43210', 'student1.png', 'resume_aarav.pdf'),
('Diya Patel', 'IT2026-015', 'diya.patel@example.com', 'Information Technology', '+91 98123 45678', 'student2.png', 'marksheet_diya.pdf'),
('Rohan Verma', 'CS2026-042', 'rohan.verma@example.com', 'Computer Science & Engineering', '+91 97654 32109', 'student3.png', 'resume_rohan.pdf'),
('Sneha Reddy', 'ECE2026-008', 'sneha.reddy@example.com', 'Electronics & Communication', '+91 99887 76655', 'student4.png', 'certificate_sneha.pdf'),
('Aditya Singh', 'AI2026-023', 'aditya.singh@example.com', 'Artificial Intelligence & DS', '+91 91234 56780', 'student5.png', 'idcard_aditya.pdf'),
('Pooja Nair', 'ME2026-011', 'pooja.nair@example.com', 'Mechanical Engineering', '+91 94455 66778', NULL, NULL);
SELECT * FROM users;
SELECT * FROM students;
