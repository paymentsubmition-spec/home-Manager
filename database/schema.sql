-- WestSide Smart Property Management System
-- Database Schema with GPS & Task Enhancements
-- MySQL 8.0+

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `propatyhob` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `propatyhob`;

-- Account Types Table
CREATE TABLE IF NOT EXISTS `account_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL UNIQUE,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `account_types` (`id`, `name`, `description`) VALUES
(1, 'HK_account', 'Housekeeping Account'),
(2, 'Engineering', 'Engineering Department'),
(3, 'Coordinator', 'Coordinator'),
(4, 'ITadmin', 'IT Administrator'),
(5, 'Management', 'Management'),
(6, 'Reception', 'Reception'),
(7, 'Guest Assist', 'Guest Assistance');

-- Privileges Table
CREATE TABLE IF NOT EXISTS `privileges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL UNIQUE,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `privileges` (`id`, `name`, `description`) VALUES
(1, 'access_admin_panel', 'Allows entry to the IT admin dashboard'),
(2, 'edit_users', 'Allows modifying worker details'),
(3, 'view_housekeeping', 'Allows viewing HK schedules'),
(4, 'manage_tasks', 'Allows assigning tasks to engineering');

-- Account Type Privileges Table
CREATE TABLE IF NOT EXISTS `account_type_privileges` (
  `account_type_id` int NOT NULL,
  `privilege_id` int NOT NULL,
  PRIMARY KEY (`account_type_id`, `privilege_id`),
  KEY `privilege_id` (`privilege_id`),
  FOREIGN KEY (`account_type_id`) REFERENCES `account_types` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Departments Table
CREATE TABLE IF NOT EXISTS `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL UNIQUE,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Workers Table
CREATE TABLE IF NOT EXISTS `workers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL UNIQUE,
  `email` varchar(150) NOT NULL UNIQUE,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `department_id` int DEFAULT NULL,
  `account_type_id` int DEFAULT NULL,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `account_type_id` (`account_type_id`),
  FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  FOREIGN KEY (`account_type_id`) REFERENCES `account_types` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Worker Custom Privileges Table
CREATE TABLE IF NOT EXISTS `worker_custom_privileges` (
  `worker_id` int NOT NULL,
  `privilege_id` int NOT NULL,
  `permission_type` enum('grant','deny') DEFAULT 'grant',
  PRIMARY KEY (`worker_id`, `privilege_id`),
  KEY `privilege_id` (`privilege_id`),
  FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Property Types Table
CREATE TABLE IF NOT EXISTS `property_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL UNIQUE,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `property_types` (`type_id`, `type_name`) VALUES
(1, 'Villa'),
(2, 'Penthouse'),
(3, 'Studio'),
(4, 'Apartment');

-- Properties Table
CREATE TABLE IF NOT EXISTS `properties` (
  `property_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `type_id` int NOT NULL,
  `address_line1` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip_code` varchar(20) DEFAULT NULL,
  `latitude` DECIMAL(10,8) DEFAULT NULL,
  `longitude` DECIMAL(11,8) DEFAULT NULL,
  `allowed_gps_radius` INT DEFAULT 100,
  `status` enum('Available','Rented','Under Maintenance','Inactive') DEFAULT 'Inactive',
  `comment` text,
  `special_note` text,
  `registered_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`property_id`),
  KEY `type_id` (`type_id`),
  FOREIGN KEY (`type_id`) REFERENCES `property_types` (`type_id`) ON DELETE RESTRICT,
  FOREIGN KEY (`registered_by`) REFERENCES `workers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `properties` (`property_id`, `title`, `type_id`, `address_line1`, `city`, `latitude`, `longitude`, `allowed_gps_radius`, `status`) VALUES
(1, 'Ocean View Luxury Villa', 1, '102 Beachside Way', 'Malibu', 34.0195, -118.6850, 100, 'Inactive');

-- Room Types Table
CREATE TABLE IF NOT EXISTS `room_types` (
  `room_type_id` int NOT NULL AUTO_INCREMENT,
  `room_name` varchar(50) NOT NULL UNIQUE,
  `min_pictures_required` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`room_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `room_types` (`room_type_id`, `room_name`, `min_pictures_required`) VALUES
(1, 'Bedroom', 2),
(2, 'Kitchen', 1),
(3, 'Living Room', 1),
(4, 'Bathroom', 1),
(5, 'Balcony/Terrace', 1);

-- Property Rooms Table
CREATE TABLE IF NOT EXISTS `property_rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `room_type_id` int NOT NULL,
  `room_label` varchar(100) NOT NULL,
  PRIMARY KEY (`room_id`),
  KEY `property_id` (`property_id`),
  KEY `room_type_id` (`room_type_id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `property_rooms` (`room_id`, `property_id`, `room_type_id`, `room_label`) VALUES
(1, 1, 1, 'Master Suite'),
(2, 1, 1, 'Guest Room East'),
(3, 1, 2, 'Gourmet Kitchen');

-- Assets Table
CREATE TABLE IF NOT EXISTS `assets` (
  `asset_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `room_id` int DEFAULT NULL,
  `asset_name` varchar(150) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `estimated_value` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`asset_id`),
  KEY `property_id` (`property_id`),
  KEY `room_id` (`room_id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  FOREIGN KEY (`room_id`) REFERENCES `property_rooms` (`room_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `assets` (`asset_id`, `property_id`, `room_id`, `asset_name`, `category`, `estimated_value`) VALUES
(1, 1, 1, 'Sony Bravia 4K TV', 'Electronics', 1200.00);

-- Asset Conditions Table
CREATE TABLE IF NOT EXISTS `asset_conditions` (
  `condition_id` int NOT NULL AUTO_INCREMENT,
  `asset_id` int NOT NULL,
  `status` enum('Mint','Good','Worn','Damaged','Broken') NOT NULL,
  `notes` text,
  `logged_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`condition_id`),
  KEY `asset_id` (`asset_id`),
  FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `asset_conditions` (`condition_id`, `asset_id`, `status`, `notes`) VALUES
(1, 1, 'Mint', 'Brand new installation during onboarding clean.');

-- Property Images Table
CREATE TABLE IF NOT EXISTS `property_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `room_id` int DEFAULT NULL,
  `asset_id` int DEFAULT NULL,
  `image_type` enum('room_view','asset_baseline','inspection_checkout','maintenance_proof') NOT NULL,
  `image_url` varchar(2048) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`),
  KEY `property_id` (`property_id`),
  KEY `room_id` (`room_id`),
  KEY `asset_id` (`asset_id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  FOREIGN KEY (`room_id`) REFERENCES `property_rooms` (`room_id`) ON DELETE SET NULL,
  FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `property_images` (`image_id`, `property_id`, `room_id`, `asset_id`, `image_type`, `image_url`) VALUES
(1, 1, 1, 1, 'asset_baseline', '/images/prop_1/assets/sony_tv_baseline.jpg');

-- Property Contacts Table
CREATE TABLE IF NOT EXISTS `property_contacts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `contact_type` enum('owner','current_guest','previous_guest','business_relation') NOT NULL,
  `special_note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_contact_property` (`property_id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Property Custom Features Table
CREATE TABLE IF NOT EXISTS `property_custom_features` (
  `feature_id` int NOT NULL AUTO_INCREMENT,
  `property_id` int NOT NULL,
  `feature_name` varchar(150) NOT NULL,
  `feature_value` varchar(255) DEFAULT NULL,
  `description` text,
  `image_url` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feature_id`),
  KEY `property_id` (`property_id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `property_custom_features` (`feature_id`, `property_id`, `feature_name`, `feature_value`, `description`, `image_url`) VALUES
(1, 1, 'Solar Backup Inverter', '15 KVA Grid System', 'Inverter and lith-ion batteries located in garage locker.', '/images/prop_1/custom/solar_setup.jpg');

-- Task Types Table
CREATE TABLE IF NOT EXISTS `task_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_name` varchar(100) NOT NULL UNIQUE,
  `description` text,
  `department_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `task_types_ibfk_1` (`department_id`),
  FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `task_types` (`id`, `task_name`, `description`) VALUES
(1, 'Cleaning', 'Deep cleaning of the apartment/house'),
(2, 'Maintenance', 'AC filter cleaning and repair'),
(3, 'Delivery', 'Drop off requested guest amenities');

-- Task Type Durations Table
CREATE TABLE IF NOT EXISTS `task_type_durations` (
  `task_type_id` int NOT NULL,
  `property_type_id` int NOT NULL,
  `estimated_duration` int DEFAULT NULL,
  PRIMARY KEY (`task_type_id`, `property_type_id`),
  KEY `property_type_id` (`property_type_id`),
  FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`property_type_id`) REFERENCES `property_types` (`type_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT IGNORE INTO `task_type_durations` (`task_type_id`, `property_type_id`, `estimated_duration`) VALUES
(1, 1, 180),
(1, 3, 45);

-- Tasks Table
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` varchar(15) NOT NULL UNIQUE,
  `task_type_id` int DEFAULT NULL,
  `property_id` int DEFAULT NULL,
  `assigned_to` int DEFAULT NULL,
  `status` enum('pending','in_progress','completed','cancelled') DEFAULT 'pending',
  `scheduled_for` datetime NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `gps_start_lat` DECIMAL(10,8) DEFAULT NULL,
  `gps_start_lng` DECIMAL(11,8) DEFAULT NULL,
  `gps_end_lat` DECIMAL(10,8) DEFAULT NULL,
  `gps_end_lng` DECIMAL(11,8) DEFAULT NULL,
  `gps_accuracy` INT DEFAULT NULL,
  `actual_duration` int GENERATED ALWAYS AS (timestampdiff(MINUTE,`start_time`,`end_time`)) STORED,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `task_type_id` (`task_type_id`),
  KEY `property_id` (`property_id`),
  KEY `assigned_to` (`assigned_to`),
  FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`),
  FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`),
  FOREIGN KEY (`assigned_to`) REFERENCES `workers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Task Logs Table
CREATE TABLE IF NOT EXISTS `task_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` int DEFAULT NULL,
  `worker_id` int DEFAULT NULL,
  `note` text,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `task_id` (`task_id`),
  KEY `worker_id` (`worker_id`),
  FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;