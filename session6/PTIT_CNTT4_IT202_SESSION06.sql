use session6;
drop table if exists order_items;
drop table if exists products;
drop table if exists orders;
drop table if exists customers;

create table customers (
    customer_id int primary key,
    full_name varchar(255),
    city varchar(255)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    status enum('pending','completed','cancelled'),
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

create table products (
    product_id int primary key,
    product_name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into customers values
(1,'an','ha noi'),
(2,'binh','da nang'),
(3,'cuong','ho chi minh'),
(4,'dung','ha noi'),
(5,'lan','can tho');

insert into orders values
(101,1,'2024-01-01','completed',3000000),
(102,1,'2024-01-02','completed',4500000),
(103,2,'2024-01-02','completed',2500000),
(104,3,'2024-01-03','completed',6000000),
(105,3,'2024-01-03','completed',2000000),
(106,3,'2024-01-04','pending',1500000),
(107,4,'2024-01-04','completed',7000000);

insert into products values
(1,'laptop',15000000),
(2,'mouse',300000),
(3,'keyboard',800000),
(4,'monitor',4000000),
(5,'headphone',1200000);

insert into order_items values
(101,1,1),
(101,2,2),
(102,3,2),
(103,2,3),
(104,4,1),
(104,5,2),
(105,2,5),
(107,1,1),
(107,3,3),
(107,2,4);

select o.order_id, c.full_name
from orders o
join customers c on o.customer_id = c.customer_id;

select c.customer_id, c.full_name, count(o.order_id) as total_orders
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select c.customer_id, c.full_name, count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select c.customer_id, c.full_name, sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select c.customer_id, c.full_name, max(o.total_amount) as max_order_value
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select c.customer_id, c.full_name, sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
order by total_spent desc;

select order_date, sum(total_amount) as total_revenue
from orders
where status = 'completed'
group by order_date;

select order_date, count(order_id) as total_orders
from orders
where status = 'completed'
group by order_date;

select order_date, sum(total_amount) as total_revenue
from orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;

select p.product_id, p.product_name, sum(oi.quantity) as total_quantity
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select p.product_id, p.product_name,
       sum(oi.quantity * p.price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select p.product_id, p.product_name,
       sum(oi.quantity * p.price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity * p.price) > 5000000;

select c.customer_id, c.full_name,
       count(o.order_id) as total_orders,
       sum(o.total_amount) as total_spent,
       avg(o.total_amount) as avg_order_value
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having count(o.order_id) >= 3
   and sum(o.total_amount) > 10000000
order by total_spent desc;

select p.product_name,
       sum(oi.quantity) as total_quantity,
       sum(oi.quantity * p.price) as total_revenue,
       avg(p.price) as avg_price
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_name
having sum(oi.quantity) >= 10
order by total_revenue desc
limit 5;
	