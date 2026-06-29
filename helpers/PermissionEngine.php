<?php

/**
 * WestSide Smart Property Management System
 * Permission Engine - Role-Based Access Control
 */

namespace Helpers;

use Models\Worker;

class PermissionEngine
{
    private static ?PermissionEngine $instance = null;
    private Worker $workerModel;
    private array $currentWorkerPrivileges = [];
    private int $currentWorkerId = 0;

    private function __construct()
    {
        $this->workerModel = new Worker();
    }

    public static function getInstance(): PermissionEngine
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function setCurrentWorker(int $workerId): void
    {
        $this->currentWorkerId = $workerId;
        $this->currentWorkerPrivileges = [];
        $this->loadPrivileges();
    }

    private function loadPrivileges(): void
    {
        try {
            $privileges = $this->workerModel->getPrivileges($this->currentWorkerId);
            $this->currentWorkerPrivileges = array_column($privileges, 'name');
        } catch (\Exception $e) {
            $this->currentWorkerPrivileges = [];
        }
    }

    public function can(string $permission): bool
    {
        if ($this->currentWorkerId === 0) {
            return false;
        }
        return in_array($permission, $this->currentWorkerPrivileges, true);
    }

    public function cannot(string $permission): bool
    {
        return !$this->can($permission);
    }

    public function canAny(array $permissions): bool
    {
        foreach ($permissions as $permission) {
            if ($this->can($permission)) {
                return true;
            }
        }
        return false;
    }

    public function canAll(array $permissions): bool
    {
        foreach ($permissions as $permission) {
            if (!$this->can($permission)) {
                return false;
            }
        }
        return true;
    }

    public function authorize(string $permission, string $errorMessage = 'Access denied'): void
    {
        if ($this->cannot($permission)) {
            throw new \RuntimeException($errorMessage);
        }
    }

    public function getPermissions(): array
    {
        return $this->currentWorkerPrivileges;
    }

    public function getWorkerRole(): ?string
    {
        if ($this->currentWorkerId === 0) {
            return null;
        }

        try {
            $worker = $this->workerModel->findById($this->currentWorkerId);
            return $worker ? $worker['account_type_name'] : null;
        } catch (\Exception $e) {
            return null;
        }
    }

    public function isAdmin(): bool
    {
        return $this->getWorkerRole() === 'ITadmin';
    }

    public function isCoordinator(): bool
    {
        return $this->getWorkerRole() === 'Coordinator';
    }

    public function isManagement(): bool
    {
        return $this->getWorkerRole() === 'Management';
    }

    public function isEngineering(): bool
    {
        return $this->getWorkerRole() === 'Engineering';
    }

    public function isHousekeeping(): bool
    {
        return $this->getWorkerRole() === 'HK_account';
    }

    public function bypassGPS(): bool
    {
        return $this->isAdmin() || $this->isCoordinator() || $this->isManagement();
    }
}
