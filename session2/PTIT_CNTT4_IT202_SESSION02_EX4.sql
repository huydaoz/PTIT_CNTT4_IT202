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
CREATE TABLE IF NOT EXISTS Enrollment (
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
