<?php

/**
 * WestSide Smart Property Management System
 * Updated API Router with Authentication Routes
 */

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/bootstrap.php';

use Helpers\ResponseFormatter;
use Helpers\LoggerHelper;
use Helpers\UtilityHelper;

$logger = LoggerHelper::getInstance();
$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestPath = str_replace('/api', '', $requestPath);
$requestPath = preg_replace('#/+#', '/', $requestPath);
$requestPath = rtrim($requestPath, '/');

$logger->info('API Request', [
    'method' => $requestMethod,
    'path' => $requestPath,
    'ip' => UtilityHelper::getIPAddress(),
]);

// Public Routes (No Authentication Required)
$publicRoutes = [
    'GET' => [
        '/health' => fn() => ResponseFormatter::success(['status' => 'ok'], 'API is healthy'),
    ],
    'POST' => [
        '/auth/login' => 'AuthController@login',
        '/auth/register' => 'AuthController@register',
    ],
];

// Protected Routes (Authentication Required)
$protectedRoutes = [
    'POST' => [
        '/auth/logout' => 'AuthController@logout',
    ],
    'GET' => [
        '/auth/me' => 'AuthController@me',
    ],
];

$allRoutes = array_merge_recursive($publicRoutes, $protectedRoutes);

// Find matching route
$matchedRoute = null;
$isProtected = false;

if (isset($publicRoutes[$requestMethod])) {
    foreach ($publicRoutes[$requestMethod] as $pattern => $handler) {
        if ($pattern === $requestPath) {
            $matchedRoute = $handler;
            $isProtected = false;
            break;
        }
    }
}

if ($matchedRoute === null && isset($protectedRoutes[$requestMethod])) {
    foreach ($protectedRoutes[$requestMethod] as $pattern => $handler) {
        if ($pattern === $requestPath) {
            $matchedRoute = $handler;
            $isProtected = true;
            break;
        }
    }
}

if ($matchedRoute === null) {
    echo ResponseFormatter::notFound('Endpoint not found');
    exit();
}

// Check authentication for protected routes
if ($isProtected) {
    $middleware = new \Helpers\AuthMiddleware();
    $middleware->requireAuth();
}

// Execute route
if (is_string($matchedRoute) && strpos($matchedRoute, '@') !== false) {
    [$controller, $method] = explode('@', $matchedRoute);
    $controllerClass = '\\Controllers\\' . $controller;
    if (!class_exists($controllerClass)) {
        echo ResponseFormatter::serverError('Controller not found');
        exit();
    }
    echo call_user_func([new $controllerClass(), $method]);
} elseif (is_callable($matchedRoute)) {
    echo call_user_func($matchedRoute);
}
