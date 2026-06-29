<?php

/**
 * WestSide Smart Property Management System
 * Auth Middleware - Route Protection & JWT Validation
 */

namespace Helpers;

class AuthMiddleware
{
    private PermissionEngine $permissionEngine;
    private LoggerHelper $logger;

    public function __construct()
    {
        $this->permissionEngine = PermissionEngine::getInstance();
        $this->logger = LoggerHelper::getInstance();
    }

    public function authenticate(): ?array
    {
        try {
            $headers = getallheaders();
            if (!isset($headers['Authorization'])) {
                return null;
            }

            $token = str_replace('Bearer ', '', $headers['Authorization']);
            $payload = AuthHelper::verifyJWT($token);

            if (!$payload) {
                return null;
            }

            $this->permissionEngine->setCurrentWorker($payload['worker_id']);
            return $payload;
        } catch (\Exception $e) {
            $this->logger->error('Authentication error: ' . $e->getMessage());
            return null;
        }
    }

    public function requireAuth(): ?array
    {
        $auth = $this->authenticate();
        if (!$auth) {
            http_response_code(401);
            echo ResponseFormatter::unauthorized('Authentication required');
            exit();
        }
        return $auth;
    }

    public function requirePermission(string $permission): void
    {
        $this->requireAuth();
        if ($this->permissionEngine->cannot($permission)) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Insufficient permissions');
            exit();
        }
    }

    public function requireAnyPermission(array $permissions): void
    {
        $this->requireAuth();
        if (!$this->permissionEngine->canAny($permissions)) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Insufficient permissions');
            exit();
        }
    }

    public function requireRole(string $role): void
    {
        $this->requireAuth();
        if ($this->permissionEngine->getWorkerRole() !== $role) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Insufficient role privileges');
            exit();
        }
    }

    public function requireAdmin(): void
    {
        $this->requireAuth();
        if (!$this->permissionEngine->isAdmin()) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Admin access required');
            exit();
        }
    }

    public function requireCoordinator(): void
    {
        $this->requireAuth();
        if (!$this->permissionEngine->isCoordinator()) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Coordinator access required');
            exit();
        }
    }

    public function requireManagement(): void
    {
        $this->requireAuth();
        if (!$this->permissionEngine->isManagement()) {
            http_response_code(403);
            echo ResponseFormatter::forbidden('Management access required');
            exit();
        }
    }

    public static function getHeaderAuthToken(): ?string
    {
        $headers = getallheaders();
        if (!isset($headers['Authorization'])) {
            return null;
        }
        return str_replace('Bearer ', '', $headers['Authorization']);
    }
}
