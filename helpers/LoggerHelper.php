<?php

/**
 * WestSide Smart Property Management System
 * Logging Helper
 */

namespace Helpers;

class LoggerHelper
{
    private string $logPath;
    private string $logLevel;
    private const LEVELS = ['debug' => 0, 'info' => 1, 'warning' => 2, 'error' => 3];

    public function __construct(
        string $logPath = LOGS_PATH,
        string $logLevel = LOG_LEVEL
    ) {
        $this->logPath = $logPath;
        $this->logLevel = $logLevel;

        if (!is_dir($logPath)) {
            @mkdir($logPath, 0755, true);
        }
    }

    public function debug(string $message, array $context = []): void
    {
        $this->log('debug', $message, $context);
    }

    public function info(string $message, array $context = []): void
    {
        $this->log('info', $message, $context);
    }

    public function warning(string $message, array $context = []): void
    {
        $this->log('warning', $message, $context);
    }

    public function error(string $message, array $context = []): void
    {
        $this->log('error', $message, $context);
    }

    private function log(string $level, string $message, array $context = []): void
    {
        if (self::LEVELS[$level] < self::LEVELS[$this->logLevel]) {
            return;
        }

        $timestamp = date('Y-m-d H:i:s');
        $contextStr = !empty($context) ? ' | ' . json_encode($context) : '';
        $logMessage = sprintf(
            '[%s] [%s] %s%s',
            $timestamp,
            strtoupper($level),
            $message,
            $contextStr
        );

        $filename = $this->logPath . '/app-' . date('Y-m-d') . '.log';
        error_log($logMessage . PHP_EOL, 3, $filename);

        if (APP_DEBUG && php_sapi_name() !== 'cli') {
            error_log($logMessage);
        }
    }

    public static function getInstance(): self
    {
        static $instance = null;
        if ($instance === null) {
            $instance = new self();
        }
        return $instance;
    }
}
