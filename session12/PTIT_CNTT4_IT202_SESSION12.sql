create database session12;
use session12;

create table users(
  user_id int primary key auto_increment,
  username varchar(50) unique not null,
  password varchar(255) not null,
  email varchar(100) unique not null,
  created_at datetime default current_timestamp
);

create table posts(
  post_id int primary key auto_increment,
  user_id int,
  content text not null,
  created_at datetime default current_timestamp,
  foreign key (user_id) references users(user_id)
);

create table comments(
  comment_id int primary key auto_increment,
  post_id int,
  user_id int,
  content text not null,
  created_at datetime default current_timestamp,
  foreign key (post_id) references posts(post_id),
  foreign key (user_id) references users(user_id)
);

create table friends(
  user_id int,
  friend_id int,
  status varchar(20),
  check (status in ('pending','accepted')),
  foreign key (user_id) references users(user_id),
  foreign key (friend_id) references users(user_id)
);

create table likes(
  user_id int,
  post_id int,
  foreign key (user_id) references users(user_id),
  foreign key (post_id) references posts(post_id)
);

-- ===== 1) USERS (10 rows) =====
insert into users (username, password, email) values
('user01','pass01','user01@gmail.com'),
('user02','pass02','user02@gmail.com'),
('user03','pass03','user03@gmail.com'),
('user04','pass04','user04@gmail.com'),
('user05','pass05','user05@gmail.com'),
('user06','pass06','user06@gmail.com'),
('user07','pass07','user07@gmail.com'),
('user08','pass08','user08@gmail.com'),
('user09','pass09','user09@gmail.com'),
('user10','pass10','user10@gmail.com');

-- ===== 2) POSTS (10 rows) =====
insert into posts (user_id, content) values
(1, 'Post 1: Hello world!'),
(2, 'Post 2: Today is a good day.'),
(3, 'Post 3: Learning MySQL.'),
(4, 'Post 4: Mini project social network.'),
(5, 'Post 5: I love databases.'),
(6, 'Post 6: Practice makes perfect.'),
(7, 'Post 7: Views and indexes are useful.'),
(8, 'Post 8: Stored procedures are cool.'),
(9, 'Post 9: Working on comments & likes.'),
(10,'Post 10: Done posting!');

-- ===== 3) COMMENTS (10 rows) =====
insert into comments (post_id, user_id, content) values
(1, 2, 'Nice post!'),
(1, 3, 'Hello!'),
(2, 1, 'Agree with you.'),
(3, 4, 'Good luck!'),
(4, 5, 'Interesting project.'),
(5, 6, 'Database is fun.'),
(6, 7, 'Keep going!'),
(7, 8, 'Great info.'),
(8, 9, 'Procedures help a lot.'),
(10,1, 'Congrats!');

-- ===== 4) FRIENDS (10 rows) =====
insert into friends (user_id, friend_id, status) values
(1, 2, 'accepted'),
(1, 3, 'pending'),
(2, 3, 'accepted'),
(2, 4, 'pending'),
(3, 5, 'accepted'),
(4, 5, 'pending'),
(6, 7, 'accepted'),
(7, 8, 'pending'),
(8, 9, 'accepted'),
(9,10, 'pending');

-- ===== 5) LIKES (10 rows) =====
insert into likes (user_id, post_id) values
(2, 1),
(3, 1),
(1, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 6),
(8, 7),
(9, 8),
(10,9);

-- bai 1 
insert into users (username, password, email)
values ('newuser', 'newpass123', 'newuser@gmail.com');
select 
    user_id,
    username,
    email,
    created_at
from users;

-- bai 2
create view vw_public_users as
select user_id, username, created_at
from users;
select * from vw_public_users;

-- bai 3 
EXPLAIN ANALYZE
select * from users
where username = 'user02';
-- lan dau actual time = 0.002
create index index_username on users(username); 
EXPLAIN ANALYZE
select * from users
where username = 'user02';
-- lan 2 actual time = 300e-6

-- bai 4 
delimiter $$
create procedure p_post(
    in p_user_id int,
    in p_content varchar(10000),
    out validate varchar(100)
)
begin
    insert into posts(user_id, content)
    select p_user_id, p_content
    from users
    where user_id = p_user_id;
    set validate = 'ok';
end $$
delimiter ;
drop procedure p_post;
call p_post(1, "abcabcabc", @validate);
select @validate;

-- bai 5
create view vw_recent_posts as
select 
    p.post_id,
    u.username,
    p.content,
    p.created_at
from posts p
join users u on p.user_id = u.user_id
where p.created_at >= now() - interval 7 day
order by p.created_at desc;
select * from vw_recent_posts;

-- bai 6 
create index idx_posts_user_id 
 on posts(user_id);
create index idx_posts_user_created
on posts(user_id, created_at);

select * from posts
where user_id = 1 
order by created_at desc;

-- bai 7 
delimiter //
create procedure sp_count_posts(
    in p_user_id int,
    out p_total int
)
begin
    select count(*) into p_total
    from posts
    where user_id = p_user_id;
end //
delimiter ;
set @total = 0;
call sp_count_posts(1, @total);  
select @total as total_posts;
-- bai 8 
create or replace view vw_active_users as
select
    user_id,
    username,
    password,
    email,
    created_at,
    is_active
from users
where is_active = 1
with check option;

-- INSERT HỢP LỆ 
insert into vw_active_users (username, password, email)
values ('nguyenvana1', '1234561', 'van1a@gmail.com');
select * from vw_active_users;
-- UPDATE HỢP LỆ
update vw_active_users
set email = 'vana_new@gmail.com'
where username = 'nguyenvana1';
select * from vw_active_users
where username = 'nguyenvana1';

-- UPDATE KHÔNG HỢP LỆ

-- Cố tình chuyển user active -> inactive
update vw_active_users
set is_active = 0
where username = 'nguyenvana1';

-- Bai09:
DELIMITER $$
create procedure sp_add_friend(
    in p_user_id int,
    in p_friend_id int
)
BEGIN
    if p_user_id = p_friend_id then
        select 'Không thể kết bạn với chính mình' as message;
    else
        if exists (
            select 1 from friends
            where user_id = p_user_id
              and friend_id = p_friend_id
        ) then
            select 'Đã gửi lời mời hoặc đã là bạn' as message;
        else
            insert into friends(user_id, friend_id, status)
            value (p_user_id, p_friend_id, 'pending');
            select 'Gửi lời mời kết bạn thành công' as message;
        end if;
    end if;
end $$
DELIMITER ;
CALL sp_add_friend(1, 4);
CALL sp_add_friend(1, 1);
-- bai 10 
delimiter $$
create procedure sp_suggest_friends(
    in p_user_id int,
    in p_limit int
)
begin
    select u.user_id, u.username
    from users u
    where u.user_id <> p_user_id
      and not exists (
          select 1
          from friends f
          where (f.user_id = p_user_id and f.friend_id = u.user_id)
             or (f.user_id = u.user_id and f.friend_id = p_user_id)
      )
    limit p_limit;
end $$
delimiter ;

set @limit = 5;
call sp_suggest_friends(1, @limit);

-- bai 11 
create index idx_likes_post_id
on likes(post_id);
create or replace view vw_top_posts as
select 
    p.post_id,
    p.content,
    count(l.user_id) as total_likes
from posts p
left join likes l on p.post_id = l.post_id
group by p.post_id, p.content
order by total_likes desc
limit 5;

-- bai 12 
delimiter $$
create procedure sp_add_comment(in p_user_id int, in p_post_id int, in p_content text, out validate text)
begin 
   declare v_user_count int default 0;
   declare v_post_count int default 0;
   select count(*) into v_user_count
   from users
   where user_id = p_user_id;
   select count(*) into v_post_count
   from posts 
   where post_id = p_post_id;
   
   if v_user_count = 0 then
   set validate = 'Post khong ton tai';
   elseif v_post_count = 0 then
   set validate = 'User khong ton tai';
   elseif v_user_count = 0 and v_post_count = 0 then 
   set validate = 'User va post khong ton tai';
   else 
	insert into comments (post_id, user_id, content, created_at)
    values (p_post_id, p_user_id, p_content, current_timestamp);
    set validate = 'them thanh cong';
	end if; 
end $$;
delimiter ;
call sp_add_comment(8,8,'tien dep trai vl', @validate);
select @validate;

select c.content,u.username,c.created_at
from users u
left join comments c on u.user_id = c.user_id
where c.user_id = 8 and c.post_id = 8;

-- bai 13 
--  sp_like_post
delimiter $$
create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    declare v_count int default 0;
    -- dem so lan like
    select count(*)
    into v_count
    from likes
    where user_id = p_user_id
      and post_id = p_post_id;
    if v_count > 0 then
        select 'nguoi dung da like roi ' as message ;
    elseif(v_count = 0) then
        insert into likes (user_id, post_id)
        values (p_user_id, p_post_id);
        select 'Da like thanh cong' as message;
    end if;
end $$ delimiter ;

drop procedure sp_like_post;
-- chuc nang like
call sp_like_post(1, 1);
call sp_like_post(2, 1);
call sp_like_post(8, 1);



-- bai 14
delimiter $$
create procedure sp_search_social(
  in  p_option int,
  in  p_keyword varchar(100),
  out validate_msg text
)
begin
  declare v_count int default 0;
  if p_option = 1 then
    select count(*) into v_count
    from users
    where username like concat('%', p_keyword, '%');
    if v_count = 0 then
      set validate_msg = 'khong tim thay user';
    else
      set validate_msg = 'ok';
      select * from users
      where username like concat('%', p_keyword, '%');
    end if;
  elseif p_option = 2 then
    select count(*) into v_count
    from posts
    where content like concat('%', p_keyword, '%');
    if v_count = 0 then
      set validate_msg = 'khong tim thay post';
    else
      set validate_msg = 'ok';
      select * from posts
      where content like concat('%', p_keyword, '%');
    end if;
  else
    set validate_msg = 'loi: p_option chi nhan 1 hoac 2';
  end if;
end $$
delimiter ;

drop procedure sp_search_social;
call    sp_search_social(1, 'user01', @result);
select @result;
call    sp_search_social(2, 'bla bla', @abc);
select @abc;
      
   
   
   
   
   
   