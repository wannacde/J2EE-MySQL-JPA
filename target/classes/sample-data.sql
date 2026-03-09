-- ============================================================
-- SQL mẫu: Tạo bảng & user trong database cho Spring Security
-- ============================================================
-- Mật khẩu PHẢI được mã hoá BCrypt TRƯỚC khi insert.
-- Dùng https://bcrypt-generator.com/ để tạo hash.
--
-- Ví dụ: mật khẩu gốc "123456"
--   → hash BCrypt (12 rounds):
--     $2a$12$WApznUPhDubN0oeveSj3JOgBMRnMQMuDhKjCP3KbSIO.Vu1AdMIz6
-- ============================================================

-- ========== BƯỚC 0: Tạo database (nếu chưa có) =============
CREATE DATABASE IF NOT EXISTS bookdb;
USE bookdb;

-- ========== BƯỚC 1: Tạo bảng ================================
-- Xoá bảng cũ (nếu có) theo đúng thứ tự phụ thuộc foreign key
DROP TABLE IF EXISTS users_roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS book;

CREATE TABLE roles (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE users (
    id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    enabled  TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE users_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

CREATE TABLE book (
    id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    title  VARCHAR(255),
    author VARCHAR(255),
    price  DOUBLE
) ENGINE=InnoDB;

-- ========== BƯỚC 2: Thêm roles ==============================

INSERT IGNORE INTO roles (name) VALUES ('ROLE_USER');
INSERT IGNORE INTO roles (name) VALUES ('ROLE_ADMIN');

-- ========== BƯỚC 3: Thêm user ===============================

-- Tạo user thường (ROLE_USER) — chỉ xem danh sách sách
INSERT INTO users (username, password, enabled)
VALUES ('user1', '$2a$12$hEEr7Ko1i8kr67drOeqpweyn.2hUIR3hjeNZ99JV9VKWZYUFNmK8y', true);

-- Gán ROLE_USER cho user1
-- (thay @user_id và @role_user_id bằng id thực tế trong DB)
INSERT INTO users_roles (user_id, role_id)
VALUES (
    (SELECT id FROM users WHERE username = 'user1'),
    (SELECT id FROM roles WHERE name = 'ROLE_USER')
);

-- Tạo admin (ROLE_ADMIN) — toàn quyền thêm/sửa/xoá
INSERT INTO users (username, password, enabled)
VALUES ('admin1', '$2a$12$hEEr7Ko1i8kr67drOeqpweyn.2hUIR3hjeNZ99JV9VKWZYUFNmK8y', true);

-- Gán cả ROLE_USER + ROLE_ADMIN cho admin1
INSERT INTO users_roles (user_id, role_id)
VALUES (
    (SELECT id FROM users WHERE username = 'admin1'),
    (SELECT id FROM roles WHERE name = 'ROLE_USER')
);
INSERT INTO users_roles (user_id, role_id)
VALUES (
    (SELECT id FROM users WHERE username = 'admin1'),
    (SELECT id FROM roles WHERE name = 'ROLE_ADMIN')
);

-- ============================================================
-- LƯU Ý:
-- 1. Hash ở trên tương ứng với mật khẩu "123456"
-- 2. Để đổi mật khẩu: vào https://bcrypt-generator.com/,
--    nhập mật khẩu mới, copy hash, rồi UPDATE bảng users.
-- 3. Bảng roles được tự tạo khi app khởi động lần đầu.
-- ============================================================
