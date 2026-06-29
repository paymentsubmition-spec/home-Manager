<?php

/**
 * WestSide Smart Property Management System
 * Application Constants
 */

define('APP_NAME', $_ENV['APP_NAME'] ?? 'WestSide');
define('APP_VERSION', $_ENV['APP_VERSION'] ?? '1.0.0');
define('APP_ENV', $_ENV['APP_ENV'] ?? 'development');
define('APP_DEBUG', $_ENV['APP_DEBUG'] ?? false);

// Paths
define('ROOT_PATH', dirname(__DIR__));
define('CONFIG_PATH', ROOT_PATH . '/config');
define('HELPERS_PATH', ROOT_PATH . '/helpers');
define('MODELS_PATH', ROOT_PATH . '/models');
define('CONTROLLERS_PATH', ROOT_PATH . '/controllers');
define('API_PATH', ROOT_PATH . '/api');
define('VIEWS_PATH', ROOT_PATH . '/views');
define('ASSETS_PATH', ROOT_PATH . '/assets');
define('UPLOADS_PATH', ROOT_PATH . '/' . ($_ENV['UPLOAD_PATH'] ?? 'uploads'));
define('LOGS_PATH', ROOT_PATH . '/' . ($_ENV['LOG_PATH'] ?? 'logs'));

// Security
define('JWT_SECRET', $_ENV['JWT_SECRET'] ?? 'change-me-in-production');
define('CSRF_TOKEN_LENGTH', (int)($_ENV['CSRF_TOKEN_LENGTH'] ?? 32));
define('SESSION_TIMEOUT', (int)($_ENV['SESSION_TIMEOUT'] ?? 3600));
define('PASSWORD_MIN_LENGTH', 8);

// Database
define('DB_MAX_CONNECTIONS', 10);
define('DB_TIMEOUT', 5);

// File Upload
define('MAX_UPLOAD_SIZE', (int)($_ENV['MAX_UPLOAD_SIZE'] ?? 52428800)); // 50MB
define('ALLOWED_IMAGE_TYPES', ['jpg', 'jpeg', 'png', 'gif']);
define('ALLOWED_MIME_TYPES', [
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/gif' => 'gif',
]);

// Logging
define('LOG_LEVEL', $_ENV['LOG_LEVEL'] ?? 'info');
define('LOG_FORMAT', '[{timestamp}] [{level}] {message}');

// Rate Limiting
define('RATE_LIMIT_ENABLED', (bool)($_ENV['RATE_LIMIT_ENABLED'] ?? true));
define('RATE_LIMIT_REQUESTS', (int)($_ENV['RATE_LIMIT_REQUESTS'] ?? 100));
define('RATE_LIMIT_WINDOW', (int)($_ENV['RATE_LIMIT_WINDOW'] ?? 3600));

// Account Types
define('ACCOUNT_TYPES', [
    1 => 'HK_account',
    2 => 'Engineering',
    3 => 'Coordinator',
    4 => 'ITadmin',
    5 => 'Management',
    6 => 'Reception',
    7 => 'Guest Assist',
]);

// Task Status
define('TASK_STATUS', [
    'pending' => 'pending',
    'in_progress' => 'in_progress',
    'completed' => 'completed',
    'cancelled' => 'cancelled',
]);

// Worker Status
define('WORKER_STATUS', [
    'active' => 'active',
    'inactive' => 'inactive',
    'suspended' => 'suspended',
]);

// Property Status
define('PROPERTY_STATUS', [
    'Available' => 'Available',
    'Rented' => 'Rented',
    'Under Maintenance' => 'Under Maintenance',
    'Inactive' => 'Inactive',
]);

// Asset Condition Status
define('ASSET_CONDITIONS', [
    'Mint' => 'Mint',
    'Good' => 'Good',
    'Worn' => 'Worn',
    'Damaged' => 'Damaged',
    'Broken' => 'Broken',
]);

// Permission Types
define('PERMISSION_TYPES', [
    'grant' => 'grant',
    'deny' => 'deny',
]);

// HTTP Status Codes
define('HTTP_OK', 200);
define('HTTP_CREATED', 201);
define('HTTP_BAD_REQUEST', 400);
define('HTTP_UNAUTHORIZED', 401);
define('HTTP_FORBIDDEN', 403);
define('HTTP_NOT_FOUND', 404);
define('HTTP_CONFLICT', 409);
define('HTTP_UNPROCESSABLE', 422);
define('HTTP_INTERNAL_ERROR', 500);

// Timezone
date_default_timezone_set($_ENV['TIMEZONE'] ?? 'UTC');
