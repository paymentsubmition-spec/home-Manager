<?php

/**
 * WestSide Smart Property Management System
 * Authentication Controller
 */

namespace Controllers;

use Helpers\ResponseFormatter;
use Helpers\ValidationHelper;
use Helpers\AuthHelper;
use Helpers\LoggerHelper;
use Models\Worker;

class AuthController
{
    private Worker $workerModel;
    private LoggerHelper $logger;

    public function __construct()
    {
        $this->workerModel = new Worker();
        $this->logger = LoggerHelper::getInstance();
    }

    public function login(): string
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return ResponseFormatter::error('Method not allowed', [], 405);
        }

        try {
            $input = json_decode(file_get_contents('php://input'), true) ?? [];

            $validator = new ValidationHelper();
            if (!$validator->validate($input, [
                'email' => 'required|email',
                'password' => 'required|min:8',
            ])) {
                return ResponseFormatter::validation($validator->getErrors());
            }

            $worker = $this->workerModel->findByEmail(ValidationHelper::sanitize($input['email']));
            if (!$worker || $worker['status'] !== 'active') {
                $this->logger->warning('Failed login attempt', ['email' => $input['email']]);
                return ResponseFormatter::unauthorized('Invalid credentials');
            }

            if (!AuthHelper::verifyPassword($input['password'], $worker['password_hash'])) {
                $this->logger->warning('Failed login attempt', ['email' => $input['email']]);
                return ResponseFormatter::unauthorized('Invalid credentials');
            }

            $token = AuthHelper::generateJWT([
                'worker_id' => $worker['id'],
                'email' => $worker['email'],
                'account_type_id' => $worker['account_type_id'],
            ]);

            $this->logger->info('Worker login successful', [
                'worker_id' => $worker['id'],
                'email' => $worker['email'],
            ]);

            return ResponseFormatter::success([
                'token' => $token,
                'worker' => [
                    'id' => $worker['id'],
                    'email' => $worker['email'],
                    'first_name' => $worker['first_name'],
                    'last_name' => $worker['last_name'],
                    'account_type' => $worker['account_type_name'],
                ],
            ], 'Login successful', 200);
        } catch (\Exception $e) {
            $this->logger->error('Login error: ' . $e->getMessage());
            return ResponseFormatter::serverError();
        }
    }

    public function register(): string
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return ResponseFormatter::error('Method not allowed', [], 405);
        }

        try {
            $input = json_decode(file_get_contents('php://input'), true) ?? [];

            $validator = new ValidationHelper();
            if (!$validator->validate($input, [
                'email' => 'required|email',
                'first_name' => 'required|min:2',
                'last_name' => 'required|min:2',
                'password' => 'required|min:8',
                'account_type_id' => 'required|integer',
            ])) {
                return ResponseFormatter::validation($validator->getErrors());
            }

            $existingWorker = $this->workerModel->findByEmail($input['email']);
            if ($existingWorker) {
                return ResponseFormatter::error('Email already registered', ['email' => ['Email already in use']], 409);
            }

            $userId = time() + rand(1000, 9999);
            $workerId = $this->workerModel->create([
                'user_id' => $userId,
                'email' => ValidationHelper::sanitize($input['email']),
                'first_name' => ValidationHelper::sanitize($input['first_name']),
                'last_name' => ValidationHelper::sanitize($input['last_name']),
                'password_hash' => AuthHelper::hashPassword($input['password']),
                'account_type_id' => (int)$input['account_type_id'],
                'status' => 'active',
            ]);

            $this->logger->info('New worker registered', [
                'worker_id' => $workerId,
                'email' => $input['email'],
            ]);

            return ResponseFormatter::created([
                'worker_id' => $workerId,
                'email' => $input['email'],
            ], 'Registration successful');
        } catch (\Exception $e) {
            $this->logger->error('Registration error: ' . $e->getMessage());
            return ResponseFormatter::serverError();
        }
    }

    public function logout(): string
    {
        try {
            AuthHelper::destroySession();
            $this->logger->info('Worker logout');
            return ResponseFormatter::success(null, 'Logout successful');
        } catch (\Exception $e) {
            $this->logger->error('Logout error: ' . $e->getMessage());
            return ResponseFormatter::serverError();
        }
    }

    public function me(): string
    {
        try {
            $headers = getallheaders();
            if (!isset($headers['Authorization'])) {
                return ResponseFormatter::unauthorized('Missing authorization token');
            }

            $token = str_replace('Bearer ', '', $headers['Authorization']);
            $payload = AuthHelper::verifyJWT($token);

            if (!$payload) {
                return ResponseFormatter::unauthorized('Invalid or expired token');
            }

            $worker = $this->workerModel->findById($payload['worker_id']);
            if (!$worker) {
                return ResponseFormatter::notFound('Worker not found');
            }

            return ResponseFormatter::success([
                'id' => $worker['id'],
                'email' => $worker['email'],
                'first_name' => $worker['first_name'],
                'last_name' => $worker['last_name'],
                'account_type' => $worker['account_type_name'],
                'status' => $worker['status'],
            ], 'Current worker data');
        } catch (\Exception $e) {
            $this->logger->error('Me endpoint error: ' . $e->getMessage());
            return ResponseFormatter::serverError();
        }
    }
}
