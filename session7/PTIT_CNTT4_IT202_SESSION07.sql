drop database if exists session7;
create database session7;
use session7;

-- bai 1

create table customers (
    id int primary key,
    name varchar(100),
    email varchar(100)
);

create table orders (
    id int primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2)
);

insert into customers values
(1,'an','an@gmail.com'),
(2,'binh','binh@gmail.com'),
(3,'chi','chi@gmail.com'),
(4,'duy','duy@gmail.com'),
(5,'hoa','hoa@gmail.com'),
(6,'hung','hung@gmail.com'),
(7,'lan','lan@gmail.com');

insert into orders values
(1,1,'2024-01-01',500),
(2,1,'2024-01-10',700),
(3,2,'2024-02-05',300),
(4,3,'2024-02-20',900),
(5,4,'2024-03-01',1200),
(6,5,'2024-03-10',400),
(7,6,'2024-03-15',800);

select *
from customers
where id in (
    select customer_id
    from orders
);

-- bai 2

create table products (
    id int primary key,
    name varchar(100),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int
);

insert into products values
(1,'laptop',1000),
(2,'mouse',50),
(3,'keyboard',150),
(4,'monitor',300),
(5,'printer',400),
(6,'usb',30),
(7,'headphone',200);

insert into order_items values
(1,1,1),
(1,2,2),
(2,3,1),
(3,4,1),
(4,1,1),
(5,5,1),
(6,6,3),
(7,7,1);

select *
from products
where id in (
    select product_id
    from order_items
);

-- bai 3

select *
from orders
where total_amount >
(
    select avg(total_amount)
    from orders
);

-- bai 4

select
    name,
    (
        select count(*)
        from orders
        where orders.customer_id = customers.id
    ) as total_orders
from customers;

-- bai 5

select *
from customers
where id =
(
    select customer_id
    from orders
    group by customer_id
    having sum(total_amount) =
    (
        select max(total_sum)
        from (
            select sum(total_amount) as total_sum
            from orders
            group by customer_id
        ) as t
    )
);

-- bai 6

select customer_id
from orders
group by customer_id
having sum(total_amount) >
(
    select avg(total_sum)
    from (
        select sum(total_amount) as total_sum
        from orders
        group by customer_id
    ) as x
);
