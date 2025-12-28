CREATE DATABASE IF NOT EXISTS school_db;
USE school_db;
CREATE TABLE IF NOT EXISTS Class (
    class_id INT PRIMARY KEY,
    class_name NVARCHAR(50) NOT NULL,
    school_year VARCHAR(9) NOT NULL
);
CREATE TABLE IF NOT EXISTS Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    class_id INT,
    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
SHOW TABLES;
SHOW CREATE TABLE Student;



