create database session5;
use session5; 
drop table Customer;
drop table Product ; 
-- -- kha 1; 
create table Product(	
  product_id int primary key, 
  product_name varchar(255), 
  price decimal(10,2), 
  stock int , 
  status enum('active', 'inactive' )
);
insert into Product (product_id,product_name,price,stock,status) 
value 
	(1, 'Áo thun basic',     129000.00, 50, 'active'),
	(2, 'Quần jean nam',     399000.00, 20, 'active'),
	(3, 'Giày sneaker',      59200000.00, 15, 'active'),
	(4, 'Nón lưỡi trai',      59200000.00,  0, 'inactive'),
	(5, 'Balo đi học',       249000.00, 10, 'active');
-- Lấy toàn bộ sản phẩm đang có trong hệ thống
select * from Product; 
-- Lấy danh sách sản phẩm đang bán (status = 'active')
select *from Product where status = 'active';
-- Lấy các sản phẩm có giá lớn hơn 1.000.000
select *from Product where price > 1000000;
-- hien thi danh sach san pham dang ban va xap xep theo gia tang dan 
select *from Product where status  = 'active' order by price ASC;

-- -- kha 2;
create table Customer (	
  customer_id int primary key, 
  full_name varchar(255), 
  email varchar(255),
  city varchar(255),
  status enum('active','inactive')
);
insert into Customer(customer_id, full_name, email, city, status)
value 
    (1, 'Nguyễn Văn An',  'an.nguyen@gmail.com',   'Hà Nội',      'active'),
    (2, 'Lê Minh Châu',   'chau.le@gmail.com',     'Đà Nẵng',     'inactive'),
	(3, 'Trần Thị Bình',  'binh.tran@gmail.com',   'TP.HCM',      'active'),
	(4, 'Phạm Quốc Duy',  'duy.pham@gmail.com',    'Hà Nội',     'active'),
	(5, 'Vũ Thảo Em',     'em.vu@gmail.com',       'Hải Phòng',   'inactive');
-- lay danh sach tat ca khach hang; 
select *from Customer ; 
-- lay khach hang o TP.HCM
select *from Customer where city = 'TP.HCM';
-- lay khach hang dang hoat dong va o Ha Noi
select *from Customer where city = 'Hà Nội' and status = 'active';
-- Sắp xếp danh sách khách hàng theo tên (A → Z)
select *from Customer  ORDER BY SUBSTRING_INDEX(full_name, ' ', -1) ASC, full_name ASC;

-- gioi 1 
create table Orders(
  order_id int primary key, 
  customer_id int , 
  total_amount decimal(10,2),
  order_date date, 
  status ENUM('pending', 'completed', 'cancelled')
);
INSERT INTO Orders (order_id, customer_id, total_amount, order_date, status) VALUES
	(1, 1, 529000.00, '2025-12-01', 'completed'),
	(2, 2, 5199000.00, '2025-12-03', 'pending'),
	(3, 3, 799000.00, '2025-12-05', 'completed'),
	(4, 4, 159000.00, '2025-12-06', 'cancelled'),
	(5, 5, 5349000.00, '2025-12-10', 'pending'),
	(6, 1, 5999000.00, '2025-12-12', 'completed'),
	(7, 2, 129000.00, '2025-12-15', 'cancelled');
-- Lấy danh sách đơn hàng đã hoàn thành
select  *from Orders where status  = 'completed';
-- Lấy các đơn hàng có tổng tiền > 5.000.000
select *from Orders where total_amount > 5000000;
-- Hiển thị 5 đơn hàng mới nhất
select *from Orders order by order_date ASC limit 5;
-- Hiển thị các đơn hàng đã hoàn thành, sắp xếp theo tổng tiền giảm dần
select *from Orders where status = 'completed' order by total_amount desc;

-- gioi 2 
alter table Product add column sold_quantity int default 0 ; 
update Product 
set sold_quantity = case  product_id
    when 1 then 2 
    when 2 then 3
    when 3 then 4 
    when 4 then 5 
    when 5 then 6
    else sold_quantity
    end
WHERE product_id IN (1,2,3,4,5);
-- lay 2 san pham ban chay nhat 
select * from  Product 
order by sold_quantity desc
limit 2;
-- lay 2 san pham ban chay tiep theo      
select * from Product 
order by sold_quantity desc
limit 2 offset 2;
-- offset = (so trang - 1 )* so dong moi trang

-- xuat xac 1 
-- hien thi 2 don hang moi nhat 
select *from Orders
order by order_date desc 
limit 2 offset 0 ;
-- hien thi 2 don hang moi tiep theo
select *from Orders 
order by order_date desc
limit 2 offset 2;
-- hien thi 2 don hang moi tiep theo nua
select *from Orders 
order by order_date desc
limit 2 offset 4;
-- hien thi cac don hang chua bi huy
select *from Orders 
where status <> 'cancelled';

-- xuat xac 2
-- tim kiem san pham dang ban
select * from Product 
where status = 'active';
-- tim kiem san pham trong khoang gia tu 100000 den 500000
select * from Product 
where price >= 100000 and price <= 500000;
-- xap xep theo gia tang dan 
select *from Product 
order by price asc;
-- hien thi 3 san pham moi trang 
-- truy van trang 1 
select *from Product 
limit 3 offset 0;
-- truy van trang 2
select *from Product 
limit 3 offset 3;