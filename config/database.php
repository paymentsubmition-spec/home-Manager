<?php

/**
 * WestSide Smart Property Management System
 * Database Configuration
 */

namespace Config;

use PDO;

class Database
{
    private static ?Database $instance = null;
    private ?PDO $connection = null;
    private array $config;

    private function __construct()
    {
        $this->loadConfig();
    }

    public static function getInstance(): Database
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function loadConfig(): void
    {
        $this->config = [
            'host' => $_ENV['DB_HOST'] ?? 'localhost',
            'port' => $_ENV['DB_PORT'] ?? 3306,
            'name' => $_ENV['DB_NAME'] ?? 'propatyhob',
            'user' => $_ENV['DB_USER'] ?? 'root',
            'password' => $_ENV['DB_PASSWORD'] ?? '',
            'charset' => $_ENV['DB_CHARSET'] ?? 'utf8mb4',
        ];
    }

    public function connect(): PDO
    {
        if ($this->connection === null) {
            try {
                $dsn = sprintf(
                    'mysql:host=%s;port=%d;dbname=%s;charset=%s',
                    $this->config['host'],
                    $this->config['port'],
                    $this->config['name'],
                    $this->config['charset']
                );

                $this->connection = new PDO(
                    $dsn,
                    $this->config['user'],
                    $this->config['password'],
                    [
                        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                        PDO::ATTR_EMULATE_PREPARES => false,
                        PDO::ATTR_TIMEOUT => 5,
                    ]
                );

                $this->connection->exec('SET SESSION sql_mode="STRICT_TRANS_TABLES"');
            } catch (\PDOException $e) {
                throw new \RuntimeException('Database connection failed: ' . $e->getMessage());
            }
        }
        return $this->connection;
    }

    public function getConnection(): PDO
    {
        return $this->connect();
    }

    public function disconnect(): void
    {
        $this->connection = null;
    }

    public function prepare(string $sql): \PDOStatement
    {
        return $this->connect()->prepare($sql);
    }

    public function execute(string $sql, array $params = []): \PDOStatement
    {
        $stmt = $this->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

    public function beginTransaction(): bool
    {
        return $this->connect()->beginTransaction();
    }

    public function commit(): bool
    {
        return $this->connect()->commit();
    }

    public function rollback(): bool
    {
        return $this->connect()->rollBack();
    }

    public function lastInsertId(): string
    {
        return $this->connect()->lastInsertId();
    }
}
