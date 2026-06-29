<?php

/**
 * WestSide Smart Property Management System
 * API Router
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

$logger = LoggerHelper::getInstance();
$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestPath = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestPath = str_replace('/api', '', $requestPath);

$logger->info('API Request', [
    'method' => $requestMethod,
    'path' => $requestPath,
    'ip' => \Helpers\UtilityHelper::getIPAddress(),
]);

$routes = [
    'GET' => [
        '/health' => fn() => ResponseFormatter::success(['status' => 'ok'], 'API is healthy'),
    ],
    'POST' => [
        '/auth/login' => 'AuthController@login',
    ],
];

$matchedRoute = null;
if (isset($routes[$requestMethod])) {
    foreach ($routes[$requestMethod] as $pattern => $handler) {
        if ($pattern === $requestPath) {
            $matchedRoute = $handler;
            break;
        }
    }
}

if ($matchedRoute === null) {
    echo ResponseFormatter::notFound('Endpoint not found');
    exit();
}

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
