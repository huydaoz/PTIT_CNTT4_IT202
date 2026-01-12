USE social_network_pro;

-- BÀI 1
DELIMITER $$

CREATE PROCEDURE GetPostsByUser (
    IN p_user_id INT
)
BEGIN
    SELECT
        post_id   AS PostID,
        content   AS NoiDung,
        created_at AS ThoiGianTao
    FROM posts
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

CALL GetPostsByUser(1);

DROP PROCEDURE IF EXISTS GetPostsByUser;

-- BÀI 2
DELIMITER $$

CREATE PROCEDURE CalculatePostLikes (
    IN p_post_id INT,
    OUT total_likes INT
)
BEGIN
    SELECT COUNT(*)
    INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END$$

DELIMITER ;

SET @total_likes = 0;
CALL CalculatePostLikes(1, @total_likes);

SELECT @total_likes AS TotalLikes;

DROP PROCEDURE IF EXISTS CalculatePostLikes;

-- BÀI 3
DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints (
    IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE post_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    IF post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
END$$

DELIMITER ;

SET @bonus = 100;
CALL CalculateBonusPoints(1, @bonus);

SELECT @bonus AS BonusPoints;

DROP PROCEDURE IF EXISTS CalculateBonusPoints;

-- BÀI 4
DELIMITER $$

CREATE PROCEDURE CreatePostWithValidation (
    IN p_user_id INT,
    IN p_content TEXT,
    OUT result_message VARCHAR(255)
)
BEGIN
    IF CHAR_LENGTH(p_content) < 5 THEN
        SET result_message = 'Nội dung quá ngắn';
    ELSE
        INSERT INTO posts (user_id, content)
        VALUES (p_user_id, p_content);

        SET result_message = 'Thêm bài viết thành công';
    END IF;
END$$

DELIMITER ;

CALL CreatePostWithValidation(1, 'Hi', @msg);
SELECT @msg AS Result;

CALL CreatePostWithValidation(1, 'Bài viết hợp lệ', @msg);
SELECT @msg AS Result;

DROP PROCEDURE IF EXISTS CreatePostWithValidation;

-- BÀI 5
DELIMITER $$

CREATE PROCEDURE CalculateUserActivityScore (
    IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE post_count INT DEFAULT 0;
    DECLARE comment_count INT DEFAULT 0;
    DECLARE like_count INT DEFAULT 0;

    SELECT COUNT(*) INTO post_count
    FROM posts
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO comment_count
    FROM comments
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO like_count
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score =
        post_count * 10 +
        comment_count * 5 +
        like_count * 3;

    SET activity_level = CASE
        WHEN activity_score > 500 THEN 'Rất tích cực'
        WHEN activity_score BETWEEN 200 AND 500 THEN 'Tích cực'
        ELSE 'Bình thường'
    END;
END$$

DELIMITER ;

CALL CalculateUserActivityScore(1, @score, @level);

SELECT @score AS ActivityScore, @level AS ActivityLevel;

DROP PROCEDURE IF EXISTS CalculateUserActivityScore;

-- BÀI 6
DELIMITER $$

CREATE PROCEDURE NotifyFriendsOnNewPost (
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_friend_id INT;
    DECLARE v_full_name VARCHAR(100);

    DECLARE friend_cursor CURSOR FOR
        SELECT friend_id FROM friends
        WHERE user_id = p_user_id AND status = 'accepted'
        UNION
        SELECT user_id FROM friends
        WHERE friend_id = p_user_id AND status = 'accepted';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT full_name
    INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    INSERT INTO posts (user_id, content)
    VALUES (p_user_id, p_content);

    OPEN friend_cursor;

    read_loop: LOOP
        FETCH friend_cursor INTO v_friend_id;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_friend_id <> p_user_id THEN
            INSERT INTO notifications (user_id, type, content)
            VALUES (
                v_friend_id,
                'new_post',
                CONCAT(v_full_name, ' đã đăng một bài viết mới')
            );
        END IF;
    END LOOP;

    CLOSE friend_cursor;
END$$

DELIMITER ;

CALL NotifyFriendsOnNewPost(1, 'Bài viết test gửi thông báo');

SELECT *
FROM notifications
ORDER BY created_at DESC;

DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
