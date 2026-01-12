drop database if exists session10;
create database session10;
use session10;


set sql_safe_updates = 0;
set foreign_key_checks = 0;

-- TẠO CÁC BẢNG
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  gender ENUM('Nam', 'Nữ') NOT NULL DEFAULT 'Nam',
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  birthdate DATE,
  hometown VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT posts_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT comments_fk_posts FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
  CONSTRAINT comments_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE likes (
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (post_id, user_id),
  CONSTRAINT likes_fk_posts FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
  CONSTRAINT likes_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE friends (
  user_id INT NOT NULL,
  friend_id INT NOT NULL,
  status ENUM('pending','accepted','blocked') DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, friend_id),
  CONSTRAINT friends_fk_user1 FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT friends_fk_user2 FOREIGN KEY (friend_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT messages_fk_sender FOREIGN KEY (sender_id) REFERENCES users(user_id),
  CONSTRAINT messages_fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50),
  content VARCHAR(255),
  is_read BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT notifications_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX posts_created_at_ix ON posts (created_at DESC);
CREATE INDEX messages_created_at_ix ON messages (created_at DESC);

-- INSERT DATA
INSERT INTO users (username, full_name, gender, email, password, birthdate, hometown) VALUES
('an', 'Nguyễn Văn An', 'Nam', 'an@gmail.com', '123', '1990-01-01', 'Hà Nội'),
('binh', 'Trần Thị Bình', 'Nữ', 'binh@gmail.com', '123', '1992-02-15', 'TP.HCM'),
('chi', 'Lê Minh Chi', 'Nữ', 'chi@gmail.com', '123', '1991-03-10', 'Đà Nẵng'),
('duy', 'Phạm Quốc Duy', 'Nam', 'duy@gmail.com', '123', '1990-05-20', 'Hải Phòng'),
('ha', 'Vũ Thu Hà', 'Nữ', 'ha@gmail.com', '123', '1994-07-25', 'Hà Nội'),
('hieu', 'Đặng Hữu Hiếu', 'Nam', 'hieu@gmail.com', '123', '1993-11-30', 'TP.HCM'),
('hoa', 'Ngô Mai Hoa', 'Nữ', 'hoa@gmail.com', '123', '1995-04-18', 'Đà Nẵng'),
('khanh', 'Bùi Khánh Linh', 'Nữ', 'khanh@gmail.com', '123', '1992-09-12', 'TP.HCM'),
('lam', 'Hoàng Đức Lâm', 'Nam', 'lam@gmail.com', '123', '1991-10-05', 'Hà Nội'),
('linh', 'Phan Mỹ Linh', 'Nữ', 'linh@gmail.com', '123', '1994-06-22', 'Đà Nẵng'),
('minh', 'Nguyễn Minh', 'Nam', 'minh@gmail.com', '123', '1990-12-01', 'Hà Nội'),
('nam', 'Trần Quốc Nam', 'Nam', 'nam@gmail.com', '123', '1992-02-05', 'TP.HCM'),
('nga', 'Lý Thúy Nga', 'Nữ', 'nga@gmail.com', '123', '1993-08-16', 'Hà Nội'),
('nhan', 'Đỗ Hoàng Nhân', 'Nam', 'nhan@gmail.com', '123', '1991-04-20', 'TP.HCM'),
('phuong', 'Tạ Kim Phương', 'Nữ', 'phuong@gmail.com', '123', '1990-05-14', 'Đà Nẵng'),
('quang', 'Lê Quang', 'Nam', 'quang@gmail.com', '123', '1992-09-25', 'Hà Nội'),
('son', 'Nguyễn Thành Sơn', 'Nam', 'son@gmail.com', '123', '1994-03-19', 'TP.HCM'),
('thao', 'Trần Thảo', 'Nữ', 'thao@gmail.com', '123', '1993-11-07', 'Đà Nẵng'),
('trang', 'Phạm Thu Trang', 'Nữ', 'trang@gmail.com', '123', '1995-06-02', 'Hà Nội'),
('tuan', 'Đinh Minh Tuấn', 'Nam', 'tuan@gmail.com', '123', '1990-07-30', 'TP.HCM'),
('dung', 'Hoàng Tuấn Dũng', 'Nam', 'dung@gmail.com', '123', '1993-05-10', 'Hải Phòng'),
('yen', 'Phạm Hải Yến', 'Nữ', 'yen@gmail.com', '123', '1995-08-22', 'Hà Nội'),
('thanh', 'Lê Văn Thành', 'Nam', 'thanh@gmail.com', '123', '1991-12-15', 'Cần Thơ'),
('mai', 'Nguyễn Tuyết Mai', 'Nữ', 'mai@gmail.com', '123', '1994-02-28', 'TP.HCM'),
('vinh', 'Trần Quang Vinh', 'Nam', 'vinh@gmail.com', '123', '1992-09-05', 'Đà Nẵng');

-- Posts (tất cả posts được gộp lại)
INSERT INTO posts (user_id, content) VALUES
(1,'Chào mọi người! Hôm nay mình bắt đầu học MySQL.'),
(2,'Ai có tài liệu SQL cơ bản cho người mới không?'),
(3,'Mình đang luyện JOIN, hơi rối nhưng vui.'),
(4,'Thiết kế ERD xong thấy dữ liệu rõ ràng hơn hẳn.'),
(5,'Học chuẩn hoá (normalization) giúp tránh trùng dữ liệu.'),
(6,'Tối ưu truy vấn: nhớ tạo index đúng chỗ.'),
(7,'Mình đang làm mini mạng xã hội bằng MySQL.'),
(8,'Bạn nào biết khác nhau giữa InnoDB và MyISAM không?'),
(9,'Uống cà phê rồi mới code tiếp thôi ☕'),
(10,'Hôm nay học GROUP BY và HAVING.'),
(11,'Subquery khó nhưng dùng quen sẽ “đã”.'),
(12,'Mình vừa tạo VIEW để xem thống kê bài viết.'),
(13,'Trigger dùng để tự tạo thông báo khi có comment.'),
(14,'Transaction quan trọng để tránh lỗi dữ liệu giữa chừng.'),
(15,'ACID là nền tảng của hệ quản trị CSDL.'),
(16,'Mình đang luyện câu truy vấn top bài nhiều like nhất.'),
(17,'Có ai muốn cùng luyện SQL mỗi ngày không?'),
(18,'Tạo bảng có khoá ngoại giúp dữ liệu “sạch” hơn.'),
(19,'Đang tìm cách sinh dữ liệu giả để test hiệu năng.'),
(20,'Backup database thường xuyên nhé mọi người!'),
(1,'Bài 2: hôm nay mình luyện insert dữ liệu tiếng Việt.'),
(2,'Lưu tiếng Việt nhớ dùng utf8mb4.'),
(3,'Đừng quên kiểm tra collation nữa.'),
(4,'Query phức tạp thì chia nhỏ ra debug dễ hơn.'),
(5,'Viết query xong nhớ EXPLAIN để xem plan.'),
(6,'Index nhiều quá cũng không tốt, phải cân bằng.'),
(7,'Mình thêm chức năng kết bạn: pending/accepted.'),
(8,'Nhắn tin (messages) cũng là quan hệ 2 user.'),
(9,'Notification giúp mô phỏng giống Facebook.'),
(10,'Cuối tuần mình tổng hợp 50 bài tập SQL.'),
(11,'Hôm nay mình tìm hiểu về Stored Procedure trong MySQL.'),
(12,'Phân quyền user trong MySQL cũng quan trọng không kém.'),
(13,'Ai đang dùng MySQL Workbench giống mình không?'),
(14,'Mình thử import database lớn thấy hơi chậm.'),
(15,'Backup bằng mysqldump khá tiện.'),
(16,'Replication giúp tăng khả năng chịu tải.'),
(17,'MySQL và PostgreSQL khác nhau khá nhiều đấy.'),
(18,'Mình đang học tối ưu query cho bảng lớn.'),
(19,'Partition table có ai dùng chưa?'),
(20,'Học database cần kiên nhẫn thật sự.'),
(3,'Hôm nay mình ngồi debug SQL gần 3 tiếng 😵'),
(7,'JOIN nhiều bảng quá nhìn hoa cả mắt.'),
(7,'Làm project CSDL mới thấy thiết kế ban đầu quan trọng thế nào.'),
(12,'Mình vừa thử dùng EXPLAIN, thấy query chạy khác hẳn.'),
(1,'Tối nay mình luyện thêm GROUP BY + HAVING.'),
(1,'Có ai từng quên index rồi query chậm kinh khủng chưa?'),
(15,'Backup dữ liệu mà quên test restore là toang 😅'),
(9,'Mình đang test feed bài viết giống Facebook.'),
(9,'Post này chỉ để test notification.'),
(18,'Partition table có vẻ hợp với log hệ thống.'),
(4,'FK giúp dữ liệu sạch hơn nhưng insert hơi chậm.'),
(6,'Index nhiều quá cũng không hẳn là tốt.'),
(6,'Mình vừa xoá bớt index thấy insert nhanh hơn.'),
(20,'Học database cần kiên nhẫn thật sự.'),
(1,'Spam nhẹ bài thứ 3 trong ngày 😅'),
(1,'Lại là mình, test feed xem sao.'),
(1,'Ai bảo làm mạng xã hội là dễ đâu.'),
(5,'Hôm nay mình chỉ ngồi đọc tài liệu DB.'),
(8,'Index composite dùng sai thứ tự là coi như bỏ.'),
(11,'Stored Procedure đôi khi khó debug thật.'),
(11,'Nhưng dùng quen thì khá tiện.'),
(14,'Import database lớn nên chia nhỏ file.'),
(17,'PostgreSQL và MySQL mỗi thằng mạnh một kiểu.'),
(19,'Log table mà không partition là rất mệt.'),
(20,'Cuối kỳ ai cũng vật vã với đồ án 😭'),
(2,'Hôm nay mình test truy vấn feed người dùng.'),
(2,'Feed mà load chậm là user thoát liền.'),
(4,'Thiết kế CSDL tốt giúp code backend nhàn hơn.'),
(10,'Post này đăng thử xem có ai đọc không.'),
(13,'Có nên dùng denormalization để tăng hiệu năng?'),
(16,'Index nên tạo sau khi đã có dữ liệu mẫu.'),
(18,'Partition theo RANGE vs HASH, mọi người hay dùng cái nào?'),
(3,'Lâu rồi mới đăng bài, mọi người học SQL tới đâu rồi?'),
(6,'Index chỉ hiệu quả khi WHERE/JOIN đúng cột.'),
(8,'Mình nghĩ dùng index càng nhiều càng tốt 🤔'),
(12,'So sánh B-Tree index và Hash index trong MySQL.'),
(15,'Post này chỉ để test dữ liệu thôi.'),
(18,'Partition theo RANGE rất hợp cho bảng log.'),
(18,'Partition mà không có where theo key thì cũng vô nghĩa.'),
(20,'Deadline đồ án CSDL dí quá rồi 😭'),
(5,'Lâu quá không đụng SQL, hôm nay mở lại thấy quên nhiều thứ ghê.'),
(7,'Làm project thật mới thấy dữ liệu test quan trọng cỡ nào.'),
(9,'Code chạy đúng nhưng vẫn thấy lo lo 🤯'),
(13,'Theo mọi người có nên đánh index cho cột boolean không?'),
(16,'Mình vừa đọc xong tài liệu về query cache.'),
(18,'Index không dùng thì optimizer cũng bỏ qua thôi.'),
(18,'Đừng tin cảm giác, hãy tin EXPLAIN.'),
(20,'Mới sửa xong bug lại phát sinh bug khác 😭'),
(1,'Test tiếp dữ liệu cho phần thống kê user hoạt động.'),
(4,'Làm CSDL nhớ nghĩ tới dữ liệu 1–2 năm sau.'),
(6,'Mọi người ơi, có phải index càng nhiều càng tốt không?'),
(8,'Mình thấy boolean cũng nên index cho chắc 🤔'),
(11,'Có ai cảm thấy học DB khó hơn học code không?'),
(14,'Mình từng quên WHERE trong câu UPDATE 😱'),
(17,'Mình toàn vào đọc chứ ít khi comment.'),
(19,'Clustered index và non-clustered index khác nhau thế nào?'),
(20,'Deadline càng gần bug càng nhiều 😭'),
(2,'Mọi người thường debug query chậm theo thứ tự nào?'),
(3,'Ngày xưa mình từng SELECT * và trả giá 😅'),
(5,'Mình đang đọc lại tài liệu normalization.'),
(7,'Test dữ liệu nhỏ chạy nhanh, lên dữ liệu lớn là khác liền.'),
(10,'INNER JOIN và LEFT JOIN khác nhau dễ nhớ không?'),
(12,'Nên viết query rõ ràng trước rồi mới tối ưu.'),
(15,'Post này để test thống kê thôi.'),
(18,'Index không dùng trong WHERE thì vô nghĩa.'),
(20,'Càng gần deadline càng dễ commit lỗi 😭'),
(1,'Test thêm dữ liệu cho biểu đồ thống kê like/comment.'),
(3,'Tối ưu query không phải lúc nào cũng là thêm index.'),
(6,'Mọi người thường đặt index trước hay sau khi có dữ liệu?'),
(8,'Theo mình thấy optimizer đôi khi chọn plan không tốt.'),
(11,'Học DB nhiều lúc thấy nản thật 😥'),
(13,'Composite index nên sắp xếp cột theo selectivity.'),
(16,'Mình đang đọc về isolation level.'),
(18,'Index chỉ giúp khi query dùng đúng cột.'),
(20,'Hy vọng đồ án này qua môn là mừng rồi 😭'),
(4,'Có ai từng bị thầy hỏi truy vấn mà não trống rỗng chưa? 😭'),
(7,'So sánh execution plan giữa MySQL và PostgreSQL.'),
(9,'Mình đang ôn lại các dạng JOIN.'),
(12,'Luôn viết SELECT trước rồi mới nghĩ tới index.'),
(15,'Post thêm để test thống kê.'),
(18,'Index không dùng trong JOIN thì cũng vô ích.'),
(20,'Qua đồ án này chắc bạc tóc 😭');

-- Comments (tất cả comments)
INSERT INTO comments (post_id, user_id, content) VALUES
(1,2,'Ủng hộ bạn! Cố lên nhé.'),(1,3,'Hay đó, mình cũng đang học.'),(2,4,'Mình có tài liệu, bạn cần phần nào?'),(2,5,'Bạn tìm “SQL basics + MySQL” là ra nhiều lắm.'),(3,6,'JOIN đầu khó, sau quen sẽ dễ.'),(3,7,'Bạn thử vẽ bảng ra giấy cho dễ hình dung.'),(4,8,'ERD đúng là cứu cánh.'),(5,9,'Chuẩn hoá giúp giảm lỗi cập nhật dữ liệu.'),(6,10,'Index đặt đúng cột hay lọc/ join là ổn.'),(7,11,'Mini mạng xã hội nghe thú vị đấy!'),(8,12,'InnoDB hỗ trợ transaction và FK tốt hơn.'),(9,13,'Cà phê là chân ái ☕'),(10,14,'GROUP BY nhớ cẩn thận HAVING nhé.'),(11,15,'Subquery dùng vừa đủ thôi kẻo chậm.'),(12,16,'VIEW tiện để tái sử dụng truy vấn.'),(13,17,'Trigger nhớ tránh loop vô hạn.'),(14,18,'Transaction giúp rollback khi lỗi.'),(15,19,'ACID rất quan trọng cho dữ liệu tiền bạc.'),(16,20,'Top bài nhiều like: GROUP BY + ORDER BY.'),(20,2,'Backup xong nhớ test restore nữa.'),(21,3,'Tiếng Việt ok khi dùng utf8mb4.'),(22,4,'Chuẩn rồi, mình từng bị lỗi mất dấu.'),(23,5,'Collation ảnh hưởng sắp xếp và so sánh.'),(24,6,'Chia nhỏ query là cách debug tốt.'),(25,7,'EXPLAIN giúp hiểu vì sao query chậm.'),(26,8,'Index dư thừa sẽ làm insert/update chậm.'),(27,9,'Pending/accepted giống Facebook đó.'),(28,10,'Messages thì nên index theo created_at.'),(29,11,'Notification nhìn “pro” hẳn.'),(30,12,'50 bài tập SQL nghe hấp dẫn!'),(2,13,'Bạn thử dùng sách Murach cũng ổn.'),(3,14,'JOIN nhiều bảng thì đặt alias cho gọn.'),(4,15,'Ràng buộc FK giúp tránh dữ liệu mồ côi.'),(5,16,'Bạn nhớ thêm UNIQUE cho like (post_id,user_id).'),(6,17,'Đúng rồi, mình cũng làm vậy.'),(7,18,'Khi cần hiệu năng, cân nhắc denormalize một chút.'),(8,19,'MySQL 8 có nhiều cải tiến optimizer.'),(9,20,'Chúc bạn học tốt!'),
(31,12,'Stored Procedure dùng tốt cho logic phức tạp.'),(31,13,'Nhưng lạm dụng thì khó bảo trì lắm.'),(32,14,'Phân quyền đúng giúp tăng bảo mật.'),(33,15,'Workbench tiện cho người mới.'),(34,16,'Import file lớn nhớ tắt index trước.'),(35,17,'mysqldump kết hợp cron là ổn áp.'),(36,18,'Replication dùng cho hệ thống lớn.'),(37,19,'PostgreSQL mạnh về chuẩn SQL.'),(38,20,'Query bảng lớn cần index hợp lý.'),(39,1,'Partition phù hợp cho dữ liệu theo thời gian.'),
(41,5,'Nghe quen ghê, mình cũng từng vậy.'),(41,8,'Debug SQL mệt nhất là logic sai.'),(41,10,'Cố lên bạn ơi!'),(42,3,'JOIN nhiều bảng nhớ đặt alias cho gọn.'),(42,11,'Thiếu index là chậm liền.'),(43,2,'Thiết kế sai từ đầu là sửa rất mệt.'),(43,6,'Chuẩn luôn, mình từng làm lại cả schema.'),(44,4,'EXPLAIN nhìn execution plan khá rõ.'),(44,7,'MySQL 8 tối ưu tốt hơn bản cũ nhiều.'),(44,9,'Xem rows estimate là biết có ổn không.'),(46,12,'GROUP BY + HAVING dễ nhầm lắm.'),(47,14,'Index quên tạo là query lag liền.'),(48,16,'Feed mà có notification nhìn chuyên nghiệp hơn.'),(48,17,'Làm xong phần này là demo được rồi.'),(49,1,'Post test nhưng nhìn giống thật ghê.'),(50,19,'Partition dùng cho dữ liệu theo thời gian là hợp lý.'),(52,3,'FK tăng an toàn dữ liệu, chậm chút cũng đáng.'),(53,5,'Index dư thừa làm insert/update chậm thật.'),(54,7,'Database đúng là càng học càng sâu.'),
(55,2,'Bạn đăng nhiều ghê 😂'),(55,3,'Feed toàn thấy bài của bạn.'),(55,4,'Spam nhẹ nhưng nội dung ổn.'),(55,6,'Test dữ liệu mà nhìn giống thật ghê.'),(56,7,'Bài này cũng thấy lúc nãy rồi.'),(56,8,'Feed hoạt động ổn là được.'),(57,9,'Lướt ngang qua 😅'),(59,10,'Composite index rất hay bị hiểu sai.'),(59,11,'Đúng rồi, thứ tự cột rất quan trọng.'),(59,12,'Sai thứ tự là optimizer không dùng.'),(60,13,'Procedure khó debug thật.'),(61,14,'Import file lớn hay bị timeout.'),(61,15,'Nên tắt FK + index trước.'),(61,16,'Import xong bật lại là ổn.'),(63,17,'So sánh DBMS đọc rất mở mang.'),(65,18,'Log mà không partition là query rất chậm.'),
(66,1,'Feed là phần quan trọng nhất luôn.'),(66,3,'Load chậm là người dùng bỏ ngay.'),(66,5,'Cần index theo created_at.'),(67,6,'Chuẩn, UX kém là mất user.'),(68,2,'Thiết kế tốt là nhàn cả team.'),(68,7,'Làm đúng từ đầu đỡ refactor.'),(69,8,'Lướt ngang qua thôi 😅'),(70,9,'Denormalize tăng hiệu năng nhưng dễ lỗi.'),(70,11,'Chỉ nên dùng khi bottleneck rõ ràng.'),(70,12,'Trade-off giữa performance và maintain.'),(71,14,'Index sớm quá đôi khi phản tác dụng.'),(72,15,'RANGE hợp dữ liệu theo thời gian.'),(72,17,'HASH phân tán đều nhưng khó query.'),
(55,9,'Mình toàn vào đọc chứ ít đăng bài.'),(59,9,'Comment vậy thôi chứ mình không hay post.'),(66,9,'Feed nhìn khá ổn rồi.'),(70,9,'Topic này tranh luận hoài không hết.'),
(73,1,'Mình vẫn đang vật vã với JOIN 😅'),(73,5,'Mình bắt đầu hiểu index hơn rồi.'),(74,2,'Chuẩn, index sai là vô dụng.'),(74,4,'EXPLAIN là công cụ không thể thiếu.'),(75,6,'Index nhiều quá làm insert chậm đó.'),(75,9,'Không phải cột nào cũng nên index.'),(75,11,'Cần đo bằng thực tế, không đoán.'),(76,3,'B-Tree dùng cho range query rất tốt.'),(76,7,'Hash index thì equality nhanh hơn.'),(77,10,'Lướt thấy nên comment cho đỡ trống.'),(78,12,'Log theo thời gian dùng RANGE là hợp lý.'),(79,13,'Không có WHERE thì partition không giúp gì mấy.'),(80,14,'Ai cuối kỳ cũng vậy thôi 😭'),(80,16,'Ráng qua là nhẹ người liền.'),
(75,17,'Mình chỉ vào đọc tranh luận thôi.'),(76,17,'Bài này đọc hơi nặng nhưng hay.'),(80,17,'Cuối kỳ ai cũng khổ như nhau 😅'),
(81,1,'Không đụng là quên liền 😅'),(81,3,'Mình cũng vậy, phải luyện lại từ đầu.'),(82,4,'Data test tốt là debug nhàn hẳn.'),(82,6,'Nhiều bug chỉ lộ ra khi data lớn.'),(83,2,'Cảm giác này ai code cũng từng trải qua.'),(83,5,'Miễn chạy đúng là ổn rồi.'),(84,7,'Boolean thường ít giá trị, index không hiệu quả.'),(84,10,'Index cho boolean hiếm khi có lợi.'),(84,12,'Trừ khi kết hợp composite index.'),(85,8,'Mình chưa dùng query cache bao giờ.'),(86,11,'EXPLAIN là chân ái.'),(87,14,'Tin số liệu hơn tin cảm giác.'),(88,15,'Bug nối tiếp bug là chuyện thường 😭'),(88,17,'Cuối kỳ ai cũng như nhau thôi.'),
(84,18,'Mình vào đọc tranh luận là chính.'),(87,18,'Bài này đọc là thấy đúng liền.'),(88,18,'Cuối kỳ áp lực thật sự.'),
(89,2,'Thống kê user là phần thầy hay hỏi đó.'),(89,3,'GROUP BY + HAVING là đủ demo rồi.'),(90,5,'Nghĩ xa từ đầu đỡ vỡ hệ thống.'),(91,7,'Không đâu, index nhiều quá còn hại.'),(91,8,'Insert/update sẽ chậm hơn.'),(92,9,'Boolean thường selectivity thấp.'),(92,10,'Index boolean hiếm khi có lợi.'),(93,12,'DB khó vì nhiều thứ phải đo đạc.'),(93,13,'Code sai còn sửa nhanh hơn.'),(94,1,'Ai cũng từng quên WHERE 😅'),(94,2,'UPDATE không WHERE là ác mộng.'),(94,3,'Nên dùng transaction cho an toàn.'),(95,6,'Mình cũng hay vào đọc thôi.'),(96,7,'Topic này hơi nặng.'),(97,8,'Cuối kỳ ai cũng vậy 😭'),(97,9,'Ráng lên là qua thôi.'),
(98,1,'Xem EXPLAIN trước tiên.'),(98,4,'Kiểm tra index là bước bắt buộc.'),(98,6,'Đừng quên đo bằng thời gian thực.'),(99,2,'SELECT * lúc đầu ai cũng từng 😅'),(99,7,'Sau này toàn chọn cột cần thiết.'),(100,8,'Normalization đọc hơi khô.'),(101,3,'Data lớn mới lộ bug.'),(101,9,'Test nhỏ chỉ mang tính tham khảo.'),(102,11,'INNER chỉ lấy khớp hai bên.'),(102,12,'LEFT lấy hết bảng trái.'),(103,13,'Làm rõ logic trước rất quan trọng.'),(104,14,'Comment cho đỡ trống.'),(105,15,'WHERE không dùng index là query quét bảng.'),(106,16,'Cuối kỳ dễ loạn thật 😭'),(106,17,'Cố lên là qua thôi.'),
(116,1,'Gặp rồi 😭'),(116,2,'Bị hỏi cái đứng hình luôn.'),(116,3,'Nhìn query quen mà không nói được.'),(116,5,'Ám ảnh thật sự.'),(116,6,'Nhất là lúc bảo giải thích JOIN 😵'),(116,7,'Ai cũng từng trải qua.'),(117,8,'Hai engine khác triết lý xử lý.'),(118,10,'JOIN làm bài thi hay ra lắm.'),(119,11,'Cách này học dễ hơn.'),(120,13,'Comment cho có.'),(121,14,'Chuẩn kiến thức.'),(122,15,'Cuối kỳ ai cũng vậy 😭'),(122,16,'Ráng chút nữa là xong.'),(116,17,'Bài này đúng nỗi ám ảnh.');

-- Likes 
INSERT INTO likes (post_id, user_id) VALUES
(1,2),(1,3),(1,4),(2,1),(2,5),(2,6),(3,7),(3,8),(4,9),(4,10),(5,11),(5,12),(6,13),(6,14),(7,15),(7,16),(8,17),(8,18),(9,19),(9,20),(10,2),(11,3),(12,4),(13,5),(14,6),
(31,1),(31,2),(31,3),(32,4),(32,5),(33,6),(33,7),(33,8),(34,9),(34,10),(35,11),(35,12),(36,13),(36,14),(37,15),(37,16),(38,17),(38,18),(39,19),(39,20),(40,1),(40,2),(40,3),
(41,2),(41,4),(41,7),(41,9),(42,1),(43,5),(43,8),(44,6),(44,10),(44,11),(44,12),(46,3),(47,15),(47,16),(48,18),(48,19),(48,20),(49,2),(50,4),(50,6),(52,7),(53,8),(53,9),(53,10),
(55,2),(55,3),(55,4),(55,5),(55,6),(55,7),(55,8),(56,1),(56,9),(56,10),(57,11),(59,12),(59,13),(59,14),(59,15),(61,16),(63,17),(65,18),(65,19),
(66,2),(66,4),(66,6),(66,7),(66,8),(67,1),(67,3),(68,5),(68,9),(68,10),(68,11),(69,12),(70,13),(70,14),(70,15),(70,16),(70,17),(71,18),(72,19),(72,20),
(73,2),(73,3),(74,5),(74,6),(74,7),(74,8),(75,9),(75,10),(75,11),(75,12),(75,13),(76,14),(76,15),(76,16),(77,17),(78,18),(78,19),(78,20),(79,1),(80,2),(80,3),(80,4),(80,5),
(81,2),(81,4),(82,5),(82,6),(82,7),(82,8),(83,1),(83,9),(84,10),(84,11),(84,12),(84,13),(84,14),(85,15),(86,16),(87,17),(87,18),(87,19),(88,2),(88,3),(88,4),(88,5),(88,6),
(89,4),(89,5),(90,6),(91,7),(91,8),(91,9),(92,10),(92,11),(93,12),(93,13),(93,14),(94,1),(94,2),(94,3),(94,4),(94,5),(94,6),(94,7),(95,8),(96,9),(97,10),(97,11),(97,12),(97,13),(94,18),(97,18),(93,18),
(98,2),(98,3),(98,4),(98,5),(98,6),(99,1),(99,7),(100,9),(101,10),(101,11),(101,12),(101,13),(102,14),(102,15),(103,16),(103,17),(103,18),(104,19),(105,20),(105,1),(105,2),(106,3),(106,4),(106,5),(106,6),
(107,3),(107,6),(108,8),(108,9),(108,10),(108,11),(109,12),(109,13),(110,14),(110,15),(110,16),(110,17),(110,18),(111,1),(111,2),(111,3),(111,4),(112,5),(112,6),(112,7),(113,8),(114,9),(114,10),(114,11),(114,12),(115,13),(115,14),(115,15),(115,16),(115,17),
(116,1),(116,2),(116,3),(116,4),(116,5),(116,6),(116,7),(116,8),(116,9),(116,10),(116,11),(116,12),(117,13),(117,14),(118,15),(118,16),(119,17),(119,18),(119,19),(120,20),(121,1),(121,2),(121,3),(122,4),(122,5),(122,6),(122,7),(116,17),(116,18),
(98,19),(101,19),(106,19),(107,10),(110,10),(115,10);

-- Friends
INSERT INTO friends (user_id, friend_id, status) VALUES
(1,2,'accepted'),(1,3,'accepted'),(2,4,'accepted'),(3,5,'pending'),(4,6,'accepted'),(5,7,'blocked'),(6,8,'accepted'),(7,9,'accepted'),(8,10,'accepted'),(9,11,'pending'),
(10,12,'accepted'),(11,13,'accepted'),(12,14,'pending'),(13,15,'accepted'),(14,16,'accepted'),(15,17,'blocked'),(16,18,'accepted'),(17,19,'accepted'),(18,20,'pending'),
(1,4,'accepted'),(1,5,'accepted'),(1,6,'accepted'),(1,7,'accepted'),(2,1,'accepted'),(3,1,'accepted'),(4,1,'accepted'),(5,2,'accepted'),(6,2,'accepted'),(7,3,'accepted'),(8,4,'accepted'),(9,5,'accepted'),(10,6,'accepted'),
(11,1,'pending'),(12,1,'pending'),(13,2,'pending'),(14,3,'pending'),(15,4,'pending'),(6,7,'blocked'),(8,9,'blocked'),(10,11,'blocked');

-- Messages
INSERT INTO messages (sender_id, receiver_id, content) VALUES
(1,2,'Chào Bình, hôm nay bạn học tới đâu rồi?'),(2,1,'Mình đang luyện JOIN, hơi chóng mặt 😅'),(3,4,'Duy ơi, share mình tài liệu MySQL 8 nhé.'),(4,3,'Ok Chi, để mình gửi link sau.'),(5,6,'Hiếu ơi, tối nay học transaction không?'),(6,5,'Ok Hà, 8h nhé!'),
(3,7,'Post của bạn nhìn giống dữ liệu thật ghê.'),(7,3,'Ừ, mình cố tình thêm không đều đó.'),(1,6,'Index nhiều quá có nên xoá bớt không?'),(6,1,'Xem EXPLAIN rồi quyết định.'),(12,9,'Feed chạy ổn chưa?'),(9,12,'Ổn rồi, chuẩn bị demo.'),
(2,1,'Feed toàn thấy bài của bạn luôn 😆'),(1,2,'Spam để test dữ liệu thôi mà.'),(11,14,'Import DB lớn có hay lỗi không?'),(14,11,'Có, phải chia nhỏ file ra.'),(19,20,'Cuối kỳ đồ án căng thật.'),(20,19,'Ráng xong là nhẹ người liền.');

-- Notifications
INSERT INTO notifications (user_id, type, content) VALUES
(1,'like','Bình đã thích bài viết của bạn.'),(1,'comment','Chi đã bình luận bài viết của bạn.'),(2,'friend','An đã gửi lời mời kết bạn.'),(3,'message','Bạn có tin nhắn mới từ Duy.'),(4,'like','Hà đã thích bài viết của bạn.'),(5,'comment','Hiếu đã bình luận bài viết của bạn.'),(6,'friend','Hoa đã chấp nhận lời mời kết bạn.'),
(7,'comment','Bạn có bình luận mới.'),(8,'like','Bài viết của bạn có lượt thích mới.'),(9,'message','Bạn có tin nhắn mới.'),(10,'friend','Bạn có lời mời kết bạn.'),(11,'like','Một người đã thích bài viết của bạn.'),(12,'comment','Có người vừa bình luận bài viết của bạn.');

set foreign_key_checks = 1;
-- bai 1: view nguoi dung ho nguyen
-- =====================================

create or replace view view_users_firstname as
select
    user_id,
    username,
    full_name,
    email,
    created_at
from users
where full_name like 'nguyễn%';

select * from view_users_firstname;

insert into users (
    username,
    full_name,
    gender,
    email,
    password,
    birthdate,
    hometown
) values (
    'nguyen_test',
    'nguyễn văn test',
    'nam',
    'nguyentest@gmail.com',
    '123',
    '2000-01-01',
    'hà nội'
);

select * from view_users_firstname;

delete from users
where username = 'nguyen_test';

select * from view_users_firstname;
-- bai 2: tao index tren username

create index idx_username
on users (username);
-- bai 3: view thong ke so bai viet

create or replace view view_users_summary as
select
    u.user_id,
    u.username,
    count(p.post_id) as total_posts
from users u
left join posts p
    on u.user_id = p.user_id
group by u.user_id, u.username;

select
    user_id,
    username,
    total_posts
from view_users_summary
where total_posts > 5;
-- bai 4: view trang thai hoat dong

create or replace view view_user_activity_status as
select
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    case
        when count(distinct p.post_id) > 0
          or count(distinct c.comment_id) > 0
        then 'active'
        else 'inactive'
    end as status
from users u
left join posts p
    on u.user_id = p.user_id
left join comments c
    on u.user_id = c.user_id
group by u.user_id, u.username, u.gender, u.created_at;
select * from view_user_activity_status;
select
    status,
    count(*) as user_count
from view_user_activity_status
group by status
order by user_count desc;
-- bai 5: index hometown + join posts
create index idx_hometown
on users (hometown);
select
    u.username,
    p.post_id,
    p.content
from users u
join posts p
    on u.user_id = p.user_id
where u.hometown = 'hà nội'
order by u.username desc
limit 10;

-- bai 6: index gender + view bai viet pho bien

create index idx_user_gender
on users (gender);

create or replace view view_popular_posts as
select
    p.post_id,
    u.username,
    p.content,
    count(distinct l.user_id) as total_likes,
    count(distinct c.comment_id) as total_comments
from posts p
join users u
    on p.user_id = u.user_id
left join likes l
    on p.post_id = l.post_id
left join comments c
    on p.post_id = c.post_id
group by p.post_id, u.username, p.content;


select * from view_popular_posts;

select *,
       (total_likes + total_comments) as total_interactions
from view_popular_posts
where (total_likes + total_comments) > 10
order by total_interactions desc;
