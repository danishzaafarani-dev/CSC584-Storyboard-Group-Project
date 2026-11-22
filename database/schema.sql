-- Campus Bazaar database schema (MySQL 8.0.16+)
-- Updated design: 10 entities for a student-to-student marketplace.
-- Run this script in a NEW database. It creates tables but does not create a real backend.

CREATE DATABASE IF NOT EXISTS campus_bazaar
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE campus_bazaar;

CREATE TABLE `User` (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(20) NOT NULL UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  campus VARCHAR(100) NOT NULL,
  account_status ENUM('PENDING','ACTIVE','SUSPENDED','INACTIVE') NOT NULL DEFAULT 'PENDING',
  verified_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Category (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(60) NOT NULL UNIQUE,
  description VARCHAR(255),
  category_status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE Item (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  seller_id INT NOT NULL,
  category_id INT NOT NULL,
  item_name VARCHAR(120) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  item_condition ENUM('NEW','LIKE_NEW','GOOD','FAIR') NOT NULL,
  item_status ENUM('AVAILABLE','RESERVED','SOLD','EXCHANGED','INACTIVE') NOT NULL DEFAULT 'AVAILABLE',
  quantity SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  listed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_item_price CHECK (price >= 0),
  CONSTRAINT chk_item_quantity CHECK (quantity >= 1),
  CONSTRAINT fk_item_seller FOREIGN KEY (seller_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_item_category FOREIGN KEY (category_id) REFERENCES Category(category_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_item_status_category (item_status, category_id),
  INDEX idx_item_name (item_name)
) ENGINE=InnoDB;

CREATE TABLE Item_Image (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  item_id INT NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_image_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  INDEX idx_image_item (item_id)
) ENGINE=InnoDB;

CREATE TABLE `Transaction` (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY,
  buyer_id INT NOT NULL,
  item_id INT NOT NULL,
  offered_item_id INT NULL,
  transaction_type ENUM('PURCHASE','EXCHANGE') NOT NULL,
  transaction_status ENUM('PENDING','ACCEPTED','REJECTED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  accepted_at DATETIME NULL,
  completed_at DATETIME NULL,
  cancelled_at DATETIME NULL,
  cancellation_reason VARCHAR(255),
  meeting_location VARCHAR(150),
  CONSTRAINT fk_transaction_buyer FOREIGN KEY (buyer_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_transaction_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_transaction_offered_item FOREIGN KEY (offered_item_id) REFERENCES Item(item_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_transaction_exchange_item CHECK (
    (transaction_type = 'PURCHASE' AND offered_item_id IS NULL) OR
    (transaction_type = 'EXCHANGE' AND offered_item_id IS NOT NULL)
  ),
  INDEX idx_transaction_buyer_status (buyer_id, transaction_status),
  INDEX idx_transaction_item_status (item_id, transaction_status)
) ENGINE=InnoDB;

CREATE TABLE Wishlist (
  wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  item_id INT NOT NULL,
  added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_wishlist_user_item UNIQUE (user_id, item_id),
  CONSTRAINT fk_wishlist_user FOREIGN KEY (user_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Message (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  transaction_id INT NULL,
  message_content TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_message_receiver FOREIGN KEY (receiver_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_message_transaction FOREIGN KEY (transaction_id) REFERENCES `Transaction`(transaction_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT chk_message_participants CHECK (sender_id <> receiver_id),
  INDEX idx_message_conversation (sender_id, receiver_id, sent_at),
  INDEX idx_message_receiver_read (receiver_id, is_read)
) ENGINE=InnoDB;

CREATE TABLE Review (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  transaction_id INT NOT NULL,
  reviewer_id INT NOT NULL,
  reviewee_id INT NOT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  comment VARCHAR(1000),
  review_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_review_transaction_reviewer UNIQUE (transaction_id, reviewer_id),
  CONSTRAINT fk_review_transaction FOREIGN KEY (transaction_id) REFERENCES `Transaction`(transaction_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_review_reviewer FOREIGN KEY (reviewer_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_review_reviewee FOREIGN KEY (reviewee_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5),
  CONSTRAINT chk_review_users CHECK (reviewer_id <> reviewee_id)
) ENGINE=InnoDB;

CREATE TABLE Notification (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  notification_type ENUM('TRANSACTION','MESSAGE','REVIEW','SYSTEM','REPORT_UPDATE') NOT NULL,
  notification_content VARCHAR(500) NOT NULL,
  related_transaction_id INT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_notification_transaction FOREIGN KEY (related_transaction_id) REFERENCES `Transaction`(transaction_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  INDEX idx_notification_user_read (user_id, is_read, created_at)
) ENGINE=InnoDB;

CREATE TABLE Report (
  report_id INT AUTO_INCREMENT PRIMARY KEY,
  reporter_id INT NOT NULL,
  reported_user_id INT NULL,
  item_id INT NULL,
  report_reason VARCHAR(100) NOT NULL,
  report_description TEXT,
  report_status ENUM('SUBMITTED','UNDER_REVIEW','RESOLVED','DISMISSED') NOT NULL DEFAULT 'SUBMITTED',
  reported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME NULL,
  CONSTRAINT fk_report_reporter FOREIGN KEY (reporter_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_report_user FOREIGN KEY (reported_user_id) REFERENCES `User`(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_report_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_report_target CHECK (
    (reported_user_id IS NOT NULL AND item_id IS NULL) OR
    (reported_user_id IS NULL AND item_id IS NOT NULL)
  ),
  INDEX idx_report_status (report_status, reported_at)
) ENGINE=InnoDB;

-- Seed categories only. Add real users/items through a secure application.
INSERT INTO Category (category_name, description) VALUES
('Textbooks', 'Textbooks, reference books and study notes'),
('Tech & Gadgets', 'Calculators and electronic accessories'),
('Campus Gear', 'Bags, stationery and student essentials'),
('Others', 'Other useful pre-loved items');

-- IMPLEMENTATION RULES THAT REQUIRE APPLICATION LOGIC / TRANSACTIONS:
-- 1. Seller is derived from Item.seller_id; it is intentionally not duplicated in Transaction.
-- 2. Buyer must not be the seller of the requested item.
-- 3. For EXCHANGE, offered_item_id must belong to buyer_id.
-- 4. Only one active (PENDING/ACCEPTED) transaction should reserve an item at a time.
-- 5. Only ACCEPTED transactions can be completed; both parties should confirm completion.
-- 6. Only COMPLETED transactions can be reviewed; reviewer/reviewee must be the two parties.
-- 7. A wishlist item should normally be AVAILABLE; validate this in the application.
-- 8. Enforce role/permission checks for report moderation and account suspension.
-- 9. Store password hashes (e.g. Argon2id/bcrypt), never plaintext passwords.
