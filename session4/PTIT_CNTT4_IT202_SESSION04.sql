
use session4;
create table student (
    student_id int primary key auto_increment,
    full_name varchar(100) not null,
    dob date,
    email varchar(100) unique
);

create table teacher (
    teacher_id int primary key auto_increment,
    full_name varchar(100) not null,
    email varchar(100) unique 
);

create table course (
    course_id int primary key auto_increment,
    course_name varchar(150) not null,
    description text,
    sessions int,
    teacher_id int,
    foreign key (teacher_id) references teacher(teacher_id)
);

create table enrollment (
    student_id int,
    course_id int,
    enroll_date date default '2025-12-30',
    primary key(student_id, course_id), 
    foreign key(student_id) references student(student_id),
    foreign key(course_id) references course(course_id)
);

create table score (
    student_id int,
    course_id int,
    midterm float check(midterm between 0 and 10),
    final float check(final between 0 and 10),
    primary key(student_id, course_id),
    foreign key(student_id) references student(student_id),
    foreign key(course_id) references course(course_id)
);
INSERT INTO Student(full_name, dob, email) VALUES
('Nguyen Van A', '2004-01-10', 'a@gmail.com'),
('Tran Thi B', '2003-11-22', 'b@gmail.com'),
('Le Van C', '2004-05-19', 'c@gmail.com'),
('Pham Thi D', '2003-09-01', 'd@gmail.com'),
('Vu Van E', '2004-12-12', 'e@gmail.com');
INSERT INTO Instructor(full_name, email) VALUES
('Thay Nguyen', 'nguyen@school.com'),
('Co Tran', 'tran@school.com'),
('Thay Le', 'le@school.com'),
('Co Pham', 'pham@school.com'),
('Thay Hoang', 'hoang@school.com');
INSERT INTO Course(course_name, description, sessions, instructor_id) VALUES
('Database Fundamentals', 'Learn SQL and database basics', 20, 1),
('Web Development', 'HTML, CSS, JS fundamentals', 25, 2),
('Python Programming', 'Learn Python from zero', 30, 3),
('Data Structures', 'Core CS algorithms & structures', 28, 4),
('AI Introduction', 'Basic AI and ML concepts', 24, 5);
INSERT INTO Enrollment(student_id, course_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);
INSERT INTO Result(student_id, course_id, midterm, final) VALUES
(1, 1, 8.0, 9.0),
(1, 3, 7.0, 8.5),
(2, 1, 6.0, 7.0),
(2, 2, 9.0, 9.5),
(3, 3, 5.0, 6.0);
UPDATE Student 
SET email = 'newA@gmail.com'
WHERE student_id = 1;
UPDATE Course
SET description = 'Updated course description for Web Development'
WHERE course_id = 2;
UPDATE Result
SET final = 9.8
WHERE student_id = 2 AND course_id = 2;
DELETE FROM Enrollment
WHERE student_id = 5 AND course_id = 5;
DELETE FROM Result
WHERE student_id = 5 AND course_id = 5;
SELECT * FROM Student;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT 
    e.student_id,
    s.full_name AS student_name,
    e.course_id,
    c.course_name,
    e.enroll_date
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id;
SELECT 
    r.student_id,
    s.full_name AS student_name,
    r.course_id,
    c.course_name,
    r.midterm,
    r.final
FROM Result r
JOIN Student s ON r.student_id = s.student_id
JOIN Course c ON r.course_id = c.course_id;



