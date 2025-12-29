USE session3;
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
(1, 'Nguyen Van A', '2003-05-12', 'a.nguyen@student.edu'),
(2, 'Tran Thi B', '2002-11-20', 'b.tran@student.edu'),
(3, 'Le Van C', '2003-01-08', 'c.le@student.edu');

SELECT * FROM Student;

SELECT student_id, full_name FROM Student;
UPDATE Student
SET email = 'c.le_new@student.edu'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2002-08-15'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student;

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100),
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
    (101, 'Database System', 3),
    (102, 'Programming C', 4),
    (103, 'Web Development', 3);

UPDATE Subject
SET credit = 5
WHERE subject_id = 102;

UPDATE Subject
SET subject_name = 'Advanced Web Development'
WHERE subject_id = 103;

CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE,
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
    (1, 101, '2024-09-01'),
    (1, 102, '2024-09-01'),
    (2, 101, '2024-09-02'),
    (3, 103, '2024-09-03');

SELECT * FROM Enrollment;

SELECT * FROM Enrollment
WHERE student_id = 1;

CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
    (1, 101, 7.5, 8.5),
    (2, 101, 6.0, 7.0),
    (3, 103, 8.0, 9.0);

UPDATE Score
SET final_score = 9.5
WHERE student_id = 1 AND subject_id = 101;

SELECT * FROM Score;

SELECT *
FROM Score
WHERE final_score >= 8;

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES (4, 'Pham Thi D', '2003-10-10', 'd.pham@student.edu');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
    (4, 101, '2024-09-05'),
    (4, 102, '2024-09-05');

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
    (4, 101, 8.0, 8.5),
    (4, 102, 7.0, 7.5);

UPDATE Score
SET final_score = 8.8
WHERE student_id = 4 AND subject_id = 102;

DELETE FROM Enrollment
WHERE student_id = 4 AND subject_id = 101;

SELECT s.student_id, s.full_name, sub.subject_name, sc.mid_score, sc.final_score
FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;

