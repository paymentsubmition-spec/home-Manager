<?php

/**
 * WestSide Smart Property Management System
 * Entry Point
 */

error_reporting(E_ALL);
ini_set('display_errors', APP_DEBUG ? 1 : 0);
ini_set('log_errors', 1);
ini_set('error_log', LOGS_PATH . '/php-errors.log');

set_error_handler(function ($errno, $errstr, $errfile, $errline) {
    $logger = \Helpers\LoggerHelper::getInstance();
    $logger->error($errstr, [
        'file' => $errfile,
        'line' => $errline,
        'errno' => $errno,
    ]);
    return false;
});

set_exception_handler(function (\Throwable $e) {
    $logger = \Helpers\LoggerHelper::getInstance();
    $logger->error($e->getMessage(), [
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString(),
    ]);
    echo \Helpers\ResponseFormatter::serverError($e->getMessage());
});

register_shutdown_function(function () {
    $error = error_get_last();
    if ($error && in_array($error['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR])) {
        $logger = \Helpers\LoggerHelper::getInstance();
        $logger->error($error['message'], [
            'file' => $error['file'],
            'line' => $error['line'],
            'type' => $error['type'],
        ]);
    }
});

require_once __DIR__ . '/vendor/autoload.php';
