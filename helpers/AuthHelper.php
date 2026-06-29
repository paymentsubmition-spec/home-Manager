<?php

/**
 * WestSide Smart Property Management System
 * Authentication Helper
 */

namespace Helpers;

use Config\Database;

class AuthHelper
{
    private const HASH_ALGO = PASSWORD_BCRYPT;
    private const HASH_COST = 12;

    public static function hashPassword(string $password): string
    {
        if (strlen($password) < PASSWORD_MIN_LENGTH) {
            throw new \InvalidArgumentException('Password must be at least ' . PASSWORD_MIN_LENGTH . ' characters');
        }
        return password_hash($password, self::HASH_ALGO, ['cost' => self::HASH_COST]);
    }

    public static function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }

    public static function generateToken(int $length = 32): string
    {
        return bin2hex(random_bytes($length));
    }

    public static function generateJWT(array $payload, int $expiresIn = 3600): string
    {
        $header = [
            'alg' => 'HS256',
            'typ' => 'JWT',
        ];

        $payload['iat'] = time();
        $payload['exp'] = time() + $expiresIn;

        $headerEncoded = rtrim(strtr(base64_encode(json_encode($header)), '+/', '-_'), '=');
        $payloadEncoded = rtrim(strtr(base64_encode(json_encode($payload)), '+/', '-_'), '=');

        $signature = hash_hmac(
            'sha256',
            $headerEncoded . '.' . $payloadEncoded,
            JWT_SECRET,
            true
        );
        $signatureEncoded = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');

        return $headerEncoded . '.' . $payloadEncoded . '.' . $signatureEncoded;
    }

    public static function verifyJWT(string $token): ?array
    {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        [$headerEncoded, $payloadEncoded, $signatureEncoded] = $parts;

        $signature = hash_hmac(
            'sha256',
            $headerEncoded . '.' . $payloadEncoded,
            JWT_SECRET,
            true
        );
        $signatureExpected = rtrim(strtr(base64_encode($signature), '+/', '-_'), '=');

        if (!hash_equals($signatureEncoded, $signatureExpected)) {
            return null;
        }

        $payload = json_decode(
            base64_decode(strtr($payloadEncoded, '-_', '+/')),
            true
        );

        if ($payload['exp'] < time()) {
            return null;
        }

        return $payload;
    }

    public static function generateCSRFToken(): string
    {
        if (!isset($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(CSRF_TOKEN_LENGTH));
        }
        return $_SESSION['csrf_token'];
    }

    public static function verifyCSRFToken(string $token): bool
    {
        return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
    }

    public static function getWorkerFromToken(string $token): ?array
    {
        $payload = self::verifyJWT($token);
        if ($payload === null) {
            return null;
        }

        try {
            $db = Database::getInstance();
            $stmt = $db->execute(
                'SELECT id, user_id, email, first_name, last_name, account_type_id, status FROM workers WHERE id = ? AND status = "active"',
                [$payload['worker_id'] ?? null]
            );
            return $stmt->fetch();
        } catch (\Exception $e) {
            return null;
        }
    }

    public static function startSession(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            ini_set('session.use_strict_mode', 1);
            ini_set('session.use_only_cookies', 1);
            ini_set('session.cookie_httponly', 1);
            ini_set('session.cookie_secure', 1);
            ini_set('session.cookie_samesite', 'Strict');
            session_start();
        }
    }

    public static function regenerateSession(): void
    {
        session_regenerate_id(true);
    }

    public static function destroySession(): void
    {
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_destroy();
        }
    }
}
