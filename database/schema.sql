-- WestSide Smart Property Management System
-- Database Schema
-- MySQL 8.0+

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `propatyhob`
--
CREATE DATABASE IF NOT EXISTS `propatyhob` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `propatyhob`;

-- --------------------------------------------------------

--
-- Table structure for table `account_types`
--

CREATE TABLE `account_types` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `account_types`
--

INSERT INTO `account_types` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'HK_account', NULL, '2026-06-29 00:32:15'),
(2, 'Engineering', NULL, '2026-06-29 00:32:15'),
(3, 'Coordinator', NULL, '2026-06-29 00:32:15'),
(4, 'ITadmin', NULL, '2026-06-29 00:32:15'),
(5, 'Management', NULL, '2026-06-29 00:32:15'),
(6, 'Reception', NULL, '2026-06-29 00:32:42'),
(7, 'Guest Assist', NULL, '2026-06-29 00:32:42');

-- --------------------------------------------------------

--
-- Table structure for table `account_type_privileges`
--

CREATE TABLE `account_type_privileges` (
  `account_type_id` int NOT NULL,
  `privilege_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `account_type_privileges`
--

INSERT INTO `account_type_privileges` (`account_type_id`, `privilege_id`) VALUES
(4, 1),
(4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `asset_id` int NOT NULL,
  `property_id` int NOT NULL,
  `room_id` int DEFAULT NULL,
  `asset_name` varchar(150) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `estimated_value` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `assets`
--

INSERT INTO `assets` (`asset_id`, `property_id`, `room_id`, `asset_name`, `category`, `estimated_value`) VALUES
(1, 1, 1, 'Sony Bravia 4K TV', 'Electronics', 1200.00);

-- --------------------------------------------------------

--
-- Table structure for table `asset_conditions`
--

CREATE TABLE `asset_conditions` (
  `condition_id` int NOT NULL,
  `asset_id` int NOT NULL,
  `status` enum('Mint','Good','Worn','Damaged','Broken') NOT NULL,
  `notes` text,
  `logged_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `asset_conditions`
--

INSERT INTO `asset_conditions` (`condition_id`, `asset_id`, `status`, `notes`, `logged_at`) VALUES
(1, 1, 'Mint', 'Brand new installation during onboarding clean.', '2026-06-28 15:55:02');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `privileges`
--

CREATE TABLE `privileges` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `privileges`
--

INSERT INTO `privileges` (`id`, `name`, `description`, `created_at`) VALUES
(1, 'access_admin_panel', 'Allows entry to the IT admin dashboard', '2026-06-29 00:32:15'),
(2, 'edit_users', 'Allows modifying worker details', '2026-06-29 00:32:15'),
(3, 'view_housekeeping', 'Allows viewing HK schedules', '2026-06-29 00:32:15'),
(4, 'manage_tasks', 'Allows assigning tasks to engineering', '2026-06-29 00:32:15');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `property_id` int NOT NULL,
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`property_id`, `title`, `type_id`, `address_line1`, `city`, `state`, `zip_code`, `status`, `comment`, `special_note`, `registered_by`, `created_at`) VALUES
(1, 'Ocean View Luxury Villa', 1, '102 Beachside Way', 'Malibu', NULL, NULL, 'Inactive', NULL, NULL, NULL, '2026-06-28 15:54:40');

-- --------------------------------------------------------

--
-- Table structure for table `property_contacts`
--

CREATE TABLE `property_contacts` (
  `id` int NOT NULL,
  `property_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `contact_type` enum('owner','current_guest','previous_guest','business_relation') NOT NULL,
  `special_note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `property_custom_features`
--

CREATE TABLE `property_custom_features` (
  `feature_id` int NOT NULL,
  `property_id` int NOT NULL,
  `feature_name` varchar(150) NOT NULL,
  `feature_value` varchar(255) DEFAULT NULL,
  `description` text,
  `image_url` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `property_custom_features`
--

INSERT INTO `property_custom_features` (`feature_id`, `property_id`, `feature_name`, `feature_value`, `description`, `image_url`, `created_at`) VALUES
(1, 1, 'Solar Backup Inverter', '15 KVA Grid System', 'Inverter and lith-ion batteries located in garage locker.', '/images/prop_1/custom/solar_setup.jpg', '2026-06-28 15:55:26');

-- --------------------------------------------------------

--
-- Table structure for table `property_images`
--

CREATE TABLE `property_images` (
  `image_id` int NOT NULL,
  `property_id` int NOT NULL,
  `room_id` int DEFAULT NULL,
  `asset_id` int DEFAULT NULL,
  `image_type` enum('room_view','asset_baseline','inspection_checkout','maintenance_proof') NOT NULL,
  `image_url` varchar(2048) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `property_images`
--

INSERT INTO `property_images` (`image_id`, `property_id`, `room_id`, `asset_id`, `image_type`, `image_url`, `uploaded_at`) VALUES
(1, 1, 1, 1, 'asset_baseline', '/images/prop_1/assets/sony_tv_baseline.jpg', '2026-06-28 15:55:02');

-- --------------------------------------------------------

--
-- Table structure for table `property_rooms`
--

CREATE TABLE `property_rooms` (
  `room_id` int NOT NULL,
  `property_id` int NOT NULL,
  `room_type_id` int NOT NULL,
  `room_label` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `property_rooms`
--

INSERT INTO `property_rooms` (`room_id`, `property_id`, `room_type_id`, `room_label`) VALUES
(1, 1, 1, 'Master Suite'),
(2, 1, 1, 'Guest Room East'),
(3, 1, 2, 'Gourmet Kitchen');

-- --------------------------------------------------------

--
-- Table structure for table `property_types`
--

CREATE TABLE `property_types` (
  `type_id` int NOT NULL,
  `type_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `property_types`
--

INSERT INTO `property_types` (`type_id`, `type_name`) VALUES
(4, 'Apartment'),
(2, 'Penthouse'),
(3, 'Studio'),
(1, 'Villa');

-- --------------------------------------------------------

--
-- Table structure for table `room_types`
--

CREATE TABLE `room_types` (
  `room_type_id` int NOT NULL,
  `room_name` varchar(50) NOT NULL,
  `min_pictures_required` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `room_types`
--

INSERT INTO `room_types` (`room_type_id`, `room_name`, `min_pictures_required`) VALUES
(1, 'Bedroom', 2),
(2, 'Kitchen', 1),
(3, 'Living Room', 1),
(4, 'Bathroom', 1),
(5, 'Balcony/Terrace', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` int NOT NULL,
  `task_id` varchar(15) NOT NULL,
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `task_logs`
--

CREATE TABLE `task_logs` (
  `id` int NOT NULL,
  `task_id` int DEFAULT NULL,
  `worker_id` int DEFAULT NULL,
  `note` text,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `task_types`
--

CREATE TABLE `task_types` (
  `id` int NOT NULL,
  `task_name` varchar(100) NOT NULL,
  `description` text,
  `department_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `task_types`
--

INSERT INTO `task_types` (`id`, `task_name`, `description`, `department_id`, `created_at`) VALUES
(1, 'Cleaning', 'Deep cleaning of the apartment/house', NULL, '2026-06-29 00:57:47'),
(2, 'Maintenance', 'AC filter cleaning and repair', NULL, '2026-06-29 00:57:47'),
(3, 'Delivery', 'Drop off requested guest amenities', NULL, '2026-06-29 00:57:47');

-- --------------------------------------------------------

--
-- Table structure for table `task_type_durations`
--

CREATE TABLE `task_type_durations` (
  `task_type_id` int NOT NULL,
  `property_type_id` int NOT NULL,
  `estimated_duration` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `task_type_durations`
--

INSERT INTO `task_type_durations` (`task_type_id`, `property_type_id`, `estimated_duration`) VALUES
(1, 1, 180),
(1, 3, 45);

-- --------------------------------------------------------

--
-- Table structure for table `workers`
--

CREATE TABLE `workers` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `email` varchar(150) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `department_id` int DEFAULT NULL,
  `account_type_id` int DEFAULT NULL,
  `profile_picture_url` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `worker_custom_privileges`
--

CREATE TABLE `worker_custom_privileges` (
  `worker_id` int NOT NULL,
  `privilege_id` int NOT NULL,
  `permission_type` enum('grant','deny') DEFAULT 'grant'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_types`
--
ALTER TABLE `account_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `account_type_privileges`
--
ALTER TABLE `account_type_privileges`
  ADD PRIMARY KEY (`account_type_id`,`privilege_id`),
  ADD KEY `privilege_id` (`privilege_id`);

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`asset_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `asset_conditions`
--
ALTER TABLE `asset_conditions`
  ADD PRIMARY KEY (`condition_id`),
  ADD KEY `asset_id` (`asset_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `privileges`
--
ALTER TABLE `privileges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`property_id`),
  ADD KEY `type_id` (`type_id`);

--
-- Indexes for table `property_contacts`
--
ALTER TABLE `property_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_contact_property` (`property_id`);

--
-- Indexes for table `property_custom_features`
--
ALTER TABLE `property_custom_features`
  ADD PRIMARY KEY (`feature_id`),
  ADD KEY `property_id` (`property_id`);

--
-- Indexes for table `property_images`
--
ALTER TABLE `property_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `asset_id` (`asset_id`);

--
-- Indexes for table `property_rooms`
--
ALTER TABLE `property_rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `room_type_id` (`room_type_id`);

--
-- Indexes for table `property_types`
--
ALTER TABLE `property_types`
  ADD PRIMARY KEY (`type_id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- Indexes for table `room_types`
--
ALTER TABLE `room_types`
  ADD PRIMARY KEY (`room_type_id`),
  ADD UNIQUE KEY `room_name` (`room_name`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `task_id` (`task_id`),
  ADD KEY `task_type_id` (`task_type_id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `assigned_to` (`assigned_to`);

--
-- Indexes for table `task_logs`
--
ALTER TABLE `task_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `worker_id` (`worker_id`);

--
-- Indexes for table `task_types`
--
ALTER TABLE `task_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `task_name` (`task_name`),
  ADD KEY `task_types_ibfk_1` (`department_id`);

--
-- Indexes for table `task_type_durations`
--
ALTER TABLE `task_type_durations`
  ADD PRIMARY KEY (`task_type_id`,`property_type_id`),
  ADD KEY `property_type_id` (`property_type_id`);

--
-- Indexes for table `workers`
--
ALTER TABLE `workers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `account_type_id` (`account_type_id`);

--
-- Indexes for table `worker_custom_privileges`
--
ALTER TABLE `worker_custom_privileges`
  ADD PRIMARY KEY (`worker_id`,`privilege_id`),
  ADD KEY `privilege_id` (`privilege_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_types`
--
ALTER TABLE `account_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `assets`
--
ALTER TABLE `assets`
  MODIFY `asset_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `asset_conditions`
--
ALTER TABLE `asset_conditions`
  MODIFY `condition_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `privileges`
--
ALTER TABLE `privileges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `property_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `property_contacts`
--
ALTER TABLE `property_contacts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `property_custom_features`
--
ALTER TABLE `property_custom_features`
  MODIFY `feature_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `property_images`
--
ALTER TABLE `property_images`
  MODIFY `image_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `property_rooms`
--
ALTER TABLE `property_rooms`
  MODIFY `room_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `property_types`
--
ALTER TABLE `property_types`
  MODIFY `type_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `room_types`
--
ALTER TABLE `room_types`
  MODIFY `room_type_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `task_logs`
--
ALTER TABLE `task_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `task_types`
--
ALTER TABLE `task_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `workers`
--
ALTER TABLE `workers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_type_privileges`
--
ALTER TABLE `account_type_privileges`
  ADD CONSTRAINT `account_type_privileges_ibfk_1` FOREIGN KEY (`account_type_id`) REFERENCES `account_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_type_privileges_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `assets`
--
ALTER TABLE `assets`
  ADD CONSTRAINT `assets_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assets_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `property_rooms` (`room_id`) ON DELETE SET NULL;

--
-- Constraints for table `asset_conditions`
--
ALTER TABLE `asset_conditions`
  ADD CONSTRAINT `asset_conditions_ibfk_1` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE CASCADE;

--
-- Constraints for table `properties`
--
ALTER TABLE `properties`
  ADD CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `property_types` (`type_id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_properties_registered_by` FOREIGN KEY (`registered_by`) REFERENCES `workers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `property_contacts`
--
ALTER TABLE `property_contacts`
  ADD CONSTRAINT `fk_contact_property` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE;

--
-- Constraints for table `property_custom_features`
--
ALTER TABLE `property_custom_features`
  ADD CONSTRAINT `property_custom_features_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE;

--
-- Constraints for table `property_images`
--
ALTER TABLE `property_images`
  ADD CONSTRAINT `property_images_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `property_images_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `property_rooms` (`room_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `property_images_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`) ON DELETE SET NULL;

--
-- Constraints for table `property_rooms`
--
ALTER TABLE `property_rooms`
  ADD CONSTRAINT `property_rooms_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `property_rooms_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`room_type_id`) ON DELETE RESTRICT;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`),
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`),
  ADD CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`assigned_to`) REFERENCES `workers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `task_logs`
--
ALTER TABLE `task_logs`
  ADD CONSTRAINT `task_logs_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_logs_ibfk_2` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `task_types`
--
ALTER TABLE `task_types`
  ADD CONSTRAINT `task_types_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `task_type_durations`
--
ALTER TABLE `task_type_durations`
  ADD CONSTRAINT `task_type_durations_ibfk_1` FOREIGN KEY (`task_type_id`) REFERENCES `task_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_type_durations_ibfk_2` FOREIGN KEY (`property_type_id`) REFERENCES `property_types` (`type_id`) ON DELETE CASCADE;

--
-- Constraints for table `workers`
--
ALTER TABLE `workers`
  ADD CONSTRAINT `workers_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `workers_ibfk_2` FOREIGN KEY (`account_type_id`) REFERENCES `account_types` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `worker_custom_privileges`
--
ALTER TABLE `worker_custom_privileges`
  ADD CONSTRAINT `worker_custom_privileges_ibfk_1` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `worker_custom_privileges_ibfk_2` FOREIGN KEY (`privilege_id`) REFERENCES `privileges` (`id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;