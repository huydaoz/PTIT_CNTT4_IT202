create database mini_project_ss08;
use mini_project_ss08;

drop table if exists bookings;
drop table if exists rooms;
drop table if exists guests;

create table guests (
    guest_id int primary key auto_increment,
    guest_name varchar(100),
    phone varchar(20)
);

create table rooms (
    room_id int primary key auto_increment,
    room_type varchar(50),
    price_per_day decimal(10,0)
);

create table bookings (
    booking_id int primary key auto_increment,
    guest_id int,
    room_id int,
    check_in date,
    check_out date,
    foreign key (guest_id) references guests(guest_id),
    foreign key (room_id) references rooms(room_id)
);

insert into guests (guest_name, phone) values
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

insert into rooms (room_type, price_per_day) values
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

insert into bookings (guest_id, room_id, check_in, check_out) values
(1, 1, '2024-01-10', '2024-01-12'),
(1, 3, '2024-03-05', '2024-03-10'),
(2, 2, '2024-02-01', '2024-02-03'),
(2, 5, '2024-04-15', '2024-04-18'),
(3, 4, '2023-12-20', '2023-12-25'),
(3, 6, '2024-05-01', '2024-05-06'),
(4, 1, '2024-06-10', '2024-06-11');

select guest_name, phone
from guests;

select distinct room_type
from rooms;

select room_type, price_per_day
from rooms
order by price_per_day asc;

select *
from rooms
where price_per_day > 1000000;

select *
from bookings
where year(check_in) = 2024;

select room_type, count(*) as total_rooms
from rooms
group by room_type;

select g.guest_name, r.room_type, b.check_in
from bookings b
join guests g on b.guest_id = g.guest_id
join rooms r on b.room_id = r.room_id;

select g.guest_name, count(b.booking_id) as total_bookings
from guests g
left join bookings b on g.guest_id = b.guest_id
group by g.guest_id, g.guest_name;

select 
    r.room_id,
    r.room_type,
    sum(datediff(b.check_out, b.check_in) * r.price_per_day) as revenue
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_id, r.room_type;

select 
    r.room_type,
    sum(datediff(b.check_out, b.check_in) * r.price_per_day) as total_revenue
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type;

select g.guest_name, count(b.booking_id) as total_bookings
from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_id, g.guest_name
having count(b.booking_id) >= 2;

select r.room_type, count(*) as total_bookings
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type
order by total_bookings desc
limit 1;

select *
from rooms
where price_per_day > (
    select avg(price_per_day)
    from rooms
);

select *
from guests
where guest_id not in (
    select distinct guest_id
    from bookings
);

select *
from rooms
where room_id = (
    select room_id
    from bookings
    group by room_id
    order by count(*) desc
    limit 1
);
