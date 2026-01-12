create database company_db;
use company_db;

create table department(
    department_id varchar(10) primary key,
    department_name varchar(100) not null unique,
    location varchar(255) not null
);

create table employee(
    employee_id varchar(10) primary key,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone_number varchar(15) not null unique,
    hire_date date not null,
    department_id varchar(10) not null,
    foreign key (department_id) references department(department_id)
);

create table project(
    project_id int primary key auto_increment,
    project_name varchar(150) not null,
    budget decimal(15,2) not null,
    status varchar(50) not null
);

create table assignment(
    assignment_id int primary key auto_increment,
    employee_id varchar(10) not null,
    project_id int not null,
    role varchar(50) not null,
    bonus_amount decimal(10,2),
    foreign key (employee_id) references employee(employee_id),
    foreign key (project_id) references project(project_id)
);

insert into department values
('D001', 'Information Technology', 'Floor 4, Building A'),
('D002', 'Human Resources', 'Floor 2, Building B'),
('D003', 'Finance & Accounting', 'Floor 3, Building A'),
('D004', 'Marketing & Sales', 'Floor 5, Building C'),
('D005', 'Research & Development', 'Floor 6, Building D');

insert into employee values
('E001', 'Nguyen Minh Anh', 'anh.nm@company.com', '0912345678', '2022-01-15', 'D001'),
('E002', 'Tran Thi Thanh', 'thanh.tt@company.com', '0923456789', '2021-05-20', 'D002'),
('E003', 'Pham Hoang Nam', 'nam.ph@company.com', '0934567890', '2023-03-10', 'D001'),
('E004', 'Le Thu Thao', 'thao.lt@company.com', '0945678901', '2020-11-25', 'D003'),
('E005', 'Vu Duc Cuong', 'cuong.vd@company.com', '0956789012', '2024-02-01', 'D005');

insert into project(project_id, project_name, budget, status) values
(1, 'ERP System Upgrade', 500000.00, 'Active'),
(2, 'Mobile App Launch', 250000.00, 'Pending'),
(3, 'Annual Financial Audit', 100000.00, 'Completed'),
(4, 'Market Expansion Asia', 800000.00, 'Active'),
(5, 'AI Research Pilot', 150000.00, 'Pending');

insert into assignment(assignment_id, employee_id, project_id, role, bonus_amount) values
(1, 'E001', 1, 'Manager', 2000.00),
(2, 'E003', 1, 'Developer', 1700.00),
(3, 'E002', 4, 'Developer', 1500.00),
(4, 'E004', 3, 'Tester', 1200.00),
(5, 'E005', 5, 'Tester', 1000.00);

-- 3
update department
set location = 'Landmark Tower, HCM City'
where department_id = 'D003';

-- 4
update project
set budget = budget * 1.2,
status = 'Active'
where project_id = 1;

-- 5
delete a
from assignment a
join project p on a.project_id = p.project_id
where a.bonus_amount < 1200
and p.status = 'Completed';

-- 6
select project_id, project_name
from project
where budget > 300000
and status = 'Active';

-- 7
select full_name, email, phone_number
from employee
where full_name like '%Anh%';

-- 8
select employee_id, full_name, hire_date
from employee
order by hire_date desc;

-- 9
select employee_id, full_name, hire_date
from employee
order by hire_date asc
limit 3;

-- 10
select employee_id, full_name
from employee
limit 2 offset 2;

-- 11
select e.employee_id, e.full_name, d.department_name
from employee e
join department d on e.department_id = d.department_id;

-- 12
select d.department_id, d.department_name, e.employee_id
from department d
left join employee e on d.department_id = e.department_id;

-- 13
select status, sum(budget) as total_budget
from project
group by status;

-- 14

-- 15
select project_id, project_name, budget
from project
where budget > (select avg(budget) from project);

-- 16
select e.full_name, e.email
from employee e
join assignment a on e.employee_id = a.employee_id
join project p on a.project_id = p.project_id
where p.project_name = 'ERP System Upgrade';

-- 17
select e.full_name, d.department_name, p.project_name, a.role, a.bonus_amount
from assignment a
join employee e on a.employee_id = e.employee_id
join department d on e.department_id = d.department_id
join project p on a.project_id = p.project_id;
