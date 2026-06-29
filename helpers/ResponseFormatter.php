<?php

/**
 * WestSide Smart Property Management System
 * Response Formatter Helper
 */

namespace Helpers;

class ResponseFormatter
{
    public static function success(
        mixed $data = null,
        string $message = 'Success',
        int $statusCode = 200
    ): string {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');

        return json_encode([
            'success' => true,
            'message' => $message,
            'data' => $data,
            'errors' => [],
            'timestamp' => date('c'),
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    public static function error(
        string $message = 'Error',
        array $errors = [],
        int $statusCode = 400,
        mixed $data = null
    ): string {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');

        return json_encode([
            'success' => false,
            'message' => $message,
            'data' => $data,
            'errors' => $errors,
            'timestamp' => date('c'),
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    public static function paginated(
        array $items,
        int $currentPage,
        int $totalPages,
        int $totalItems,
        int $perPage,
        string $message = 'Success',
        int $statusCode = 200
    ): string {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');

        return json_encode([
            'success' => true,
            'message' => $message,
            'data' => $items,
            'pagination' => [
                'current_page' => $currentPage,
                'total_pages' => $totalPages,
                'total_items' => $totalItems,
                'per_page' => $perPage,
            ],
            'errors' => [],
            'timestamp' => date('c'),
        ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    public static function created(
        mixed $data,
        string $message = 'Resource created successfully'
    ): string {
        return self::success($data, $message, HTTP_CREATED);
    }

    public static function notFound(
        string $message = 'Resource not found'
    ): string {
        return self::error($message, [], HTTP_NOT_FOUND);
    }

    public static function unauthorized(
        string $message = 'Unauthorized access'
    ): string {
        return self::error($message, [], HTTP_UNAUTHORIZED);
    }

    public static function forbidden(
        string $message = 'Access forbidden'
    ): string {
        return self::error($message, [], HTTP_FORBIDDEN);
    }

    public static function validation(
        array $errors,
        string $message = 'Validation failed'
    ): string {
        return self::error($message, $errors, HTTP_UNPROCESSABLE);
    }

    public static function serverError(
        string $message = 'Internal server error'
    ): string {
        return self::error($message, [], HTTP_INTERNAL_ERROR);
    }
}
