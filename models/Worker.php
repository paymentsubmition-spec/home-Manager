<?php

/**
 * WestSide Smart Property Management System
 * Worker Model - Database Abstraction Layer
 */

namespace Models;

use Config\Database;

class Worker
{
    private Database $db;

    public function __construct()
    {
        $this->db = Database::getInstance();
    }

    public function findById(int $id): ?array
    {
        try {
            $stmt = $this->db->execute(
                'SELECT w.*, at.name as account_type_name, d.name as department_name 
                 FROM workers w 
                 LEFT JOIN account_types at ON w.account_type_id = at.id 
                 LEFT JOIN departments d ON w.department_id = d.id 
                 WHERE w.id = ?',
                [$id]
            );
            return $stmt->fetch() ?: null;
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to fetch worker: ' . $e->getMessage());
        }
    }

    public function findByEmail(string $email): ?array
    {
        try {
            $stmt = $this->db->execute(
                'SELECT w.*, at.name as account_type_name, d.name as department_name 
                 FROM workers w 
                 LEFT JOIN account_types at ON w.account_type_id = at.id 
                 LEFT JOIN departments d ON w.department_id = d.id 
                 WHERE w.email = ?',
                [$email]
            );
            return $stmt->fetch() ?: null;
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to fetch worker by email: ' . $e->getMessage());
        }
    }

    public function findByUserId(int $userId): ?array
    {
        try {
            $stmt = $this->db->execute(
                'SELECT w.*, at.name as account_type_name, d.name as department_name 
                 FROM workers w 
                 LEFT JOIN account_types at ON w.account_type_id = at.id 
                 LEFT JOIN departments d ON w.department_id = d.id 
                 WHERE w.user_id = ?',
                [$userId]
            );
            return $stmt->fetch() ?: null;
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to fetch worker by user ID: ' . $e->getMessage());
        }
    }

    public function create(array $data): int
    {
        try {
            $this->db->beginTransaction();

            $stmt = $this->db->execute(
                'INSERT INTO workers (user_id, email, first_name, last_name, password_hash, department_id, account_type_id, status) 
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                [
                    $data['user_id'],
                    $data['email'],
                    $data['first_name'],
                    $data['last_name'],
                    $data['password_hash'],
                    $data['department_id'] ?? null,
                    $data['account_type_id'] ?? null,
                    $data['status'] ?? 'active',
                ]
            );

            $workerId = (int)$this->db->lastInsertId();
            $this->db->commit();

            return $workerId;
        } catch (\Exception $e) {
            $this->db->rollback();
            throw new \RuntimeException('Failed to create worker: ' . $e->getMessage());
        }
    }

    public function update(int $id, array $data): bool
    {
        try {
            $this->db->beginTransaction();

            $fields = [];
            $values = [];

            foreach ($data as $field => $value) {
                if (in_array($field, ['email', 'first_name', 'last_name', 'password_hash', 'department_id', 'account_type_id', 'status', 'profile_picture_url'])) {
                    $fields[] = $field . ' = ?';
                    $values[] = $value;
                }
            }

            if (empty($fields)) {
                $this->db->commit();
                return true;
            }

            $values[] = $id;
            $sql = 'UPDATE workers SET ' . implode(', ', $fields) . ' WHERE id = ?';
            $this->db->execute($sql, $values);
            $this->db->commit();

            return true;
        } catch (\Exception $e) {
            $this->db->rollback();
            throw new \RuntimeException('Failed to update worker: ' . $e->getMessage());
        }
    }

    public function getPrivileges(int $workerId): array
    {
        try {
            $worker = $this->findById($workerId);
            if (!$worker) {
                return [];
            }

            $privileges = [];

            // Role-based privileges
            $stmt = $this->db->execute(
                'SELECT p.* FROM privileges p 
                 INNER JOIN account_type_privileges atp ON p.id = atp.privilege_id 
                 WHERE atp.account_type_id = ?',
                [$worker['account_type_id']]
            );
            $rolePrivileges = $stmt->fetchAll();

            foreach ($rolePrivileges as $priv) {
                $privileges[$priv['id']] = ['name' => $priv['name'], 'source' => 'role'];
            }

            // Custom privileges (override role privileges)
            $stmt = $this->db->execute(
                'SELECT p.*, wcp.permission_type FROM privileges p 
                 INNER JOIN worker_custom_privileges wcp ON p.id = wcp.privilege_id 
                 WHERE wcp.worker_id = ?',
                [$workerId]
            );
            $customPrivileges = $stmt->fetchAll();

            foreach ($customPrivileges as $priv) {
                if ($priv['permission_type'] === 'deny') {
                    unset($privileges[$priv['id']]);
                } else {
                    $privileges[$priv['id']] = ['name' => $priv['name'], 'source' => 'custom'];
                }
            }

            return array_values($privileges);
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to fetch privileges: ' . $e->getMessage());
        }
    }

    public function hasPrivilege(int $workerId, string $privilegeName): bool
    {
        try {
            $privileges = $this->getPrivileges($workerId);
            foreach ($privileges as $priv) {
                if ($priv['name'] === $privilegeName) {
                    return true;
                }
            }
            return false;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function grantPrivilege(int $workerId, int $privilegeId): bool
    {
        try {
            $this->db->execute(
                'INSERT IGNORE INTO worker_custom_privileges (worker_id, privilege_id, permission_type) VALUES (?, ?, "grant")',
                [$workerId, $privilegeId]
            );
            return true;
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to grant privilege: ' . $e->getMessage());
        }
    }

    public function denyPrivilege(int $workerId, int $privilegeId): bool
    {
        try {
            $stmt = $this->db->execute(
                'SELECT id FROM worker_custom_privileges WHERE worker_id = ? AND privilege_id = ?',
                [$workerId, $privilegeId]
            );
            $existing = $stmt->fetch();

            if ($existing) {
                $this->db->execute(
                    'UPDATE worker_custom_privileges SET permission_type = "deny" WHERE worker_id = ? AND privilege_id = ?',
                    [$workerId, $privilegeId]
                );
            } else {
                $this->db->execute(
                    'INSERT INTO worker_custom_privileges (worker_id, privilege_id, permission_type) VALUES (?, ?, "deny")',
                    [$workerId, $privilegeId]
                );
            }
            return true;
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to deny privilege: ' . $e->getMessage());
        }
    }

    public function list(int $page = 1, int $perPage = 20, array $filters = []): array
    {
        try {
            $offset = ($page - 1) * $perPage;
            $where = ['1=1'];
            $params = [];

            if (!empty($filters['status'])) {
                $where[] = 'w.status = ?';
                $params[] = $filters['status'];
            }
            if (!empty($filters['account_type_id'])) {
                $where[] = 'w.account_type_id = ?';
                $params[] = $filters['account_type_id'];
            }
            if (!empty($filters['department_id'])) {
                $where[] = 'w.department_id = ?';
                $params[] = $filters['department_id'];
            }
            if (!empty($filters['search'])) {
                $where[] = '(w.first_name LIKE ? OR w.last_name LIKE ? OR w.email LIKE ?)';
                $search = '%' . $filters['search'] . '%';
                $params[] = $search;
                $params[] = $search;
                $params[] = $search;
            }

            $countStmt = $this->db->execute(
                'SELECT COUNT(*) as total FROM workers w WHERE ' . implode(' AND ', $where),
                $params
            );
            $total = (int)$countStmt->fetch()['total'];

            $params[] = $perPage;
            $params[] = $offset;

            $stmt = $this->db->execute(
                'SELECT w.*, at.name as account_type_name, d.name as department_name 
                 FROM workers w 
                 LEFT JOIN account_types at ON w.account_type_id = at.id 
                 LEFT JOIN departments d ON w.department_id = d.id 
                 WHERE ' . implode(' AND ', $where) . ' 
                 ORDER BY w.created_at DESC 
                 LIMIT ? OFFSET ?',
                $params
            );

            return [
                'total' => $total,
                'page' => $page,
                'per_page' => $perPage,
                'data' => $stmt->fetchAll(),
            ];
        } catch (\Exception $e) {
            throw new \RuntimeException('Failed to list workers: ' . $e->getMessage());
        }
    }
}
