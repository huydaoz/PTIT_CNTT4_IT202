drop database if exists session14;
create database session14;
use session14;

-- bài 1: users + posts + đăng bài bằng transaction
create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0,
    following_count int default 0,
    followers_count int default 0,
    friends_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    likes_count int default 0,
    comments_count int default 0,
    foreign key (user_id) references users(user_id)
);

insert into users(username) values ('alice'), ('bob');

-- case thành công
start transaction;

insert into posts(user_id, content)
values (1, 'hello world');

update users
set posts_count = posts_count + 1
where user_id = 1;

commit;

-- case lỗi (user_id không tồn tại)
start transaction;

insert into posts(user_id, content)
values (999, 'invalid user');

update users
set posts_count = posts_count + 1
where user_id = 999;

rollback;

-- bài 2: likes + like bằng transaction
create table likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    unique key unique_like (post_id, user_id),
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

-- like lần đầu (commit)
start transaction;

insert into likes(post_id, user_id)
values (1, 2);

update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

-- like lần 2 (rollback do unique)
start transaction;

insert into likes(post_id, user_id)
values (1, 2);

update posts
set likes_count = likes_count + 1
where post_id = 1;

rollback;

-- bài 3: follow bằng stored procedure + transaction
create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

create table follow_log (
    log_id int primary key auto_increment,
    message varchar(255),
    created_at datetime default current_timestamp
);

delimiter $$

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare cnt int;

    start transaction;

    if p_follower_id = p_followed_id then
        insert into follow_log(message)
        values ('cannot follow yourself');
        rollback;
        leave proc;
    end if;

    select count(*) into cnt from users where user_id in (p_follower_id, p_followed_id);
    if cnt < 2 then
        insert into follow_log(message)
        values ('user not found');
        rollback;
        leave proc;
    end if;

    select count(*) into cnt
    from followers
    where follower_id = p_follower_id and followed_id = p_followed_id;

    if cnt > 0 then
        rollback;
        leave proc;
    end if;

    insert into followers values (p_follower_id, p_followed_id);

    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;

    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;

    commit;
end$$

delimiter ;

call sp_follow_user(1, 2);
call sp_follow_user(1, 1);
call sp_follow_user(1, 2);

-- bài 4: comments + savepoint rollback partial
create table comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

delimiter $$

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    start transaction;

    insert into comments(post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);

    savepoint after_insert;

    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;

    commit;
end$$

delimiter ;

call sp_post_comment(1, 1, 'nice post');

-- bài 5: xóa bài viết hoàn toàn
create table delete_log (
    log_id int primary key auto_increment,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
);

delimiter $$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare owner_id int;

    start transaction;

    select user_id into owner_id
    from posts
    where post_id = p_post_id;

    if owner_id is null or owner_id <> p_user_id then
        rollback;
        leave proc;
    end if;

    delete from likes where post_id = p_post_id;
    delete from comments where post_id = p_post_id;
    delete from posts where post_id = p_post_id;

    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id;

    insert into delete_log(post_id, deleted_by)
    values (p_post_id, p_user_id);

    commit;
end$$

delimiter ;

-- bài 6: friend request + accept bằng transaction
create table friend_requests (
    request_id int primary key auto_increment,
    from_user_id int,
    to_user_id int,
    status enum('pending','accepted','rejected') default 'pending'
);

create table friends (
    user_id int,
    friend_id int,
    primary key (user_id, friend_id)
);

delimiter $$

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from int;
    declare v_status varchar(10);

    set transaction isolation level repeatable read;
    start transaction;

    select from_user_id, status
    into v_from, v_status
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id;

    if v_status <> 'pending' then
        rollback;
        leave proc;
    end if;

    insert into friends values (v_from, p_to_user_id);
    insert into friends values (p_to_user_id, v_from);

    update users
    set friends_count = friends_count + 1
    where user_id in (v_from, p_to_user_id);

    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;

    commit;
end$$

delimiter ;
