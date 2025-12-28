USE school_db;
CREATE TABLE IF NOT EXISTS Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL
);
CREATE TABLE IF NOT EXISTS Subject (
    subject_id INT PRIMARY KEY,
    subject_name NVARCHAR(100) NOT NULL,
    credits INT CHECK (credits > 0)
);
SHOW TABLES;
SHOW CREATE TABLE Subject;


