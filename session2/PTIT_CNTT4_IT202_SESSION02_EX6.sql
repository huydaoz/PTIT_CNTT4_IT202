USE school_db;

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
