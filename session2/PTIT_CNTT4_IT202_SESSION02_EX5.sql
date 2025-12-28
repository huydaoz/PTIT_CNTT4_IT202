USE school_db;
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL
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
    teacher_id INT,
    CONSTRAINT fk_subject_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
);
CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    CONSTRAINT fk_enroll_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);
