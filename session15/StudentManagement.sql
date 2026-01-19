drop database if exists StudentManagement;
create database StudentManagement;
use StudentManagement;

create table Students (
    StudentID char(5) primary key,
    FullName varchar(50) not null,
    TotalDebt decimal(10,2) default 0
);

create table Subjects (
    SubjectID char(5) primary key,
    SubjectName varchar(50) not null,
    Credits int check (Credits > 0)
);

create table Grades (
    StudentID char(5),
    SubjectID char(5),
    Score decimal(4,2) check (Score between 0 and 10),
    primary key (StudentID, SubjectID),
    foreign key (StudentID) references Students(StudentID),
    foreign key (SubjectID) references Subjects(SubjectID)
);

create table GradeLog (
    LogID int primary key auto_increment,
    StudentID char(5),
    OldScore decimal(4,2),
    NewScore decimal(4,2),
    ChangeDate datetime default current_timestamp
);

-- câu 1: 
delimiter $$

create trigger tg_CheckScore
before insert on Grades
for each row
begin
    if new.Score < 0 then
        set new.Score = 0;
    elseif new.Score > 10 then
        set new.Score = 10;
    end if;
end$$

delimiter ;

-- câu 2:
start transaction;

insert into Students (StudentID, FullName)
values ('S001', 'Bich Ngoc');

update Students
set TotalDebt = 5000000
where StudentID = 'S001';

commit;

-- cau 3:
delimiter $$

create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
    if old.Score <> new.Score then
        insert into GradeLog (StudentID, OldScore, NewScore, ChangeDate)
        values (old.StudentID, old.Score, new.Score, now());
    end if;
end$$

delimiter ;

-- câu 4:
delimiter $$

create procedure sp_PayTuition(
    in p_StudentID char(5)
)
begin
    start transaction;

    update Students
    set TotalDebt = TotalDebt - 2000000
    where StudentID = p_StudentID;

    if (select TotalDebt from Students where StudentID = p_StudentID) < 0 then
        rollback;
    else
        commit;
    end if;
end$$

delimiter ;

-- câu 5:
delimiter $$

create trigger tg_PreventPassUpdate
before update on Grades
for each row
begin
    if old.Score >= 4.0 then
        signal sqlstate '45000'
        set message_text = 'cannot update passed grade';
    end if;
end$$

delimiter ;

-- câu 6:
delimiter $$

create procedure sp_DeleteStudentGrade(
    in p_StudentID char(5),
    in p_SubjectID char(5)
)
begin
    declare v_score decimal(4,2);

    start transaction;

    select Score
    into v_score
    from Grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    insert into GradeLog (StudentID, OldScore, NewScore, ChangeDate)
    values (p_StudentID, v_score, null, now());

    delete from Grades
    where StudentID = p_StudentID
      and SubjectID = p_SubjectID;

    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end$$

delimiter ;
