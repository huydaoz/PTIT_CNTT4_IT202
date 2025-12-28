DROP TABLE IF EXISTS Score;
DROP TABLE IF EXISTS Enrollment;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS Class;

USE school_db;
CREATE TABLE Class (
    class_id INT PRIMARY KEY,
    class_name NVARCHAR(50) NOT NULL,
    school_year VARCHAR(9) NOT NULL
);
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    class_id INT NOT NULL,
    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);
CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name NVARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    teacher_id INT NOT NULL,
    CONSTRAINT fk_subject_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
);
CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);
CREATE TABLE Score (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    process_score DECIMAL(4,2) NOT NULL CHECK (process_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) NOT NULL CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_score_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),
    CONSTRAINT fk_score_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);
