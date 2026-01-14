drop database if exists session13;
create database session13;
use session13;

-- bai 1: tao bang users va posts + trigger dem bai viet
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- du lieu mau users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- trigger tang post_count khi them bai viet
delimiter //
create trigger after_insert_posts
after insert on posts
for each row
begin
    update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end;
//
delimiter ;

-- trigger giam post_count khi xoa bai viet
delimiter //
create trigger after_delete_posts
after delete on posts
for each row
begin
    update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end;
//
delimiter ;

-- insert bai viet
insert into posts (user_id, content, created_at) values
(1, 'hello world from alice!', '2025-01-10 10:00:00'),
(1, 'second post by alice', '2025-01-10 12:00:00'),
(2, 'bob first post', '2025-01-11 09:00:00'),
(3, 'charlie sharing thoughts', '2025-01-12 15:00:00');

select * from users;

-- xoa bai viet
delete from posts where post_id = 2;
select * from users;

-- bai 2: likes + trigger cap nhat like_count + view thong ke
create table likes (
    like_id int auto_increment primary key,
    user_id int,
    post_id int,
    liked_at datetime default now(),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

-- du lieu mau likes
insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- trigger tang like_count
delimiter //
create trigger after_insert_likes
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end;
//
delimiter ;

-- trigger giam like_count
delimiter //
create trigger after_delete_likes
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end;
//
delimiter ;

-- view thong ke nguoi dung
create view user_statistics as
select 
    u.user_id,
    u.username,
    u.post_count,
    ifnull(sum(p.like_count), 0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

-- kiem thu
insert into likes (user_id, post_id) values (2, 4);
select * from posts where post_id = 4;
select * from user_statistics;

delete from likes where like_id = 1;
select * from user_statistics;

-- bai 3: mo rong trigger likes (before/after update)
delimiter //
create trigger before_insert_likes
before insert on likes
for each row
begin
    if new.user_id = (select user_id from posts where post_id = new.post_id) then
        signal sqlstate '45000'
        set message_text = 'khong duoc like bai viet cua chinh minh';
    end if;
end;
//
delimiter ;

delimiter //
create trigger after_update_likes
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        update posts set like_count = like_count - 1 where post_id = old.post_id;
        update posts set like_count = like_count + 1 where post_id = new.post_id;
    end if;
end;
//
delimiter ;

-- bai 4: post_history + trigger ghi lich su chinh sua
create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);

delimiter //
create trigger before_update_posts
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history
        (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values
        (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end;
//
delimiter ;

-- test update
update posts
set content = 'alice updated her first post'
where post_id = 1;

select * from post_history;

-- bai 5: trigger kiem tra users + procedure add_user
delimiter //
create trigger before_insert_users
before insert on users
for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'email khong hop le';
    end if;

    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000'
        set message_text = 'username khong hop le';
    end if;
end;
//
delimiter ;

delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end;
//
delimiter ;

-- test procedure
call add_user('valid_user', 'valid@email.com', curdate());
-- call add_user('bad user', 'invalidemail', curdate());

select * from users;

-- bai 6: friendships + trigger follower_count + procedure + view profile
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

delimiter //
create trigger after_insert_friendships
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end;
//
delimiter ;

delimiter //
create trigger after_delete_friendships
after delete on friendships
for each row
begin
    update users
    set follower_count = follower_count - 1
    where user_id = old.followee_id;
end;
//
delimiter ;

delimiter //
create procedure follow_user(
    in p_follower int,
    in p_followee int,
    in p_status enum('pending','accepted')
)
begin
    if p_follower = p_followee then
        signal sqlstate '45000'
        set message_text = 'khong duoc tu follow chinh minh';
    end if;

    if exists (
        select 1 from friendships
        where follower_id = p_follower and followee_id = p_followee
    ) then
        signal sqlstate '45000'
        set message_text = 'da follow truoc do';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower, p_followee, p_status);
end;
//
delimiter ;

-- view profile chi tiet
create view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    ifnull(sum(p.like_count),0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

-- test follow
call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

select * from users;
select * from user_profile;
