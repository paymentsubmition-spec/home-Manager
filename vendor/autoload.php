<?php

/**
 * WestSide Smart Property Management System
 * PSR-4 Autoloader
 */

spl_autoload_register(function ($class) {
    $prefix = '';
    $baseDir = __DIR__ . '/../';

    $namespaces = [
        'Config\\' => 'config/',
        'Helpers\\' => 'helpers/',
        'Models\\' => 'models/',
        'Controllers\\' => 'controllers/',
    ];

    foreach ($namespaces as $ns => $dir) {
        if (strpos($class, $ns) === 0) {
            $relative_class = substr($class, strlen($ns));
            $file = $baseDir . $dir . str_replace('\\', '/', $relative_class) . '.php';
            if (file_exists($file)) {
                require_once $file;
                return;
            }
        }
    }
});
