<?php

/**
 * WestSide Smart Property Management System
 * Validation Helper
 */

namespace Helpers;

class ValidationHelper
{
    private array $errors = [];

    public function validate(array $data, array $rules): bool
    {
        $this->errors = [];

        foreach ($rules as $field => $ruleString) {
            $rules_array = explode('|', $ruleString);
            $value = $data[$field] ?? null;

            foreach ($rules_array as $rule) {
                $this->validateRule($field, $value, trim($rule));
            }
        }

        return empty($this->errors);
    }

    private function validateRule(string $field, mixed $value, string $rule): void
    {
        if (strpos($rule, ':') !== false) {
            [$ruleName, $ruleParam] = explode(':', $rule, 2);
        } else {
            $ruleName = $rule;
            $ruleParam = null;
        }

        match (trim($ruleName)) {
            'required' => $this->required($field, $value),
            'email' => $this->email($field, $value),
            'min' => $this->min($field, $value, (int)$ruleParam),
            'max' => $this->max($field, $value, (int)$ruleParam),
            'length' => $this->length($field, $value, (int)$ruleParam),
            'numeric' => $this->numeric($field, $value),
            'integer' => $this->integer($field, $value),
            'url' => $this->url($field, $value),
            'phone' => $this->phone($field, $value),
            'alpha' => $this->alpha($field, $value),
            'alphanumeric' => $this->alphanumeric($field, $value),
            'in' => $this->in($field, $value, $ruleParam),
            'unique' => $this->unique($field, $value, $ruleParam),
            'match' => $this->match($field, $value, $ruleParam),
            default => null,
        };
    }

    private function required(string $field, mixed $value): void
    {
        if ($value === null || $value === '' || (is_array($value) && empty($value))) {
            $this->errors[$field][] = ucfirst($field) . ' is required';
        }
    }

    private function email(string $field, mixed $value): void
    {
        if ($value !== null && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
            $this->errors[$field][] = ucfirst($field) . ' must be a valid email';
        }
    }

    private function min(string $field, mixed $value, int $min): void
    {
        if ($value !== null && is_string($value) && strlen($value) < $min) {
            $this->errors[$field][] = ucfirst($field) . ' must be at least ' . $min . ' characters';
        }
        if ($value !== null && is_numeric($value) && $value < $min) {
            $this->errors[$field][] = ucfirst($field) . ' must be at least ' . $min;
        }
    }

    private function max(string $field, mixed $value, int $max): void
    {
        if ($value !== null && is_string($value) && strlen($value) > $max) {
            $this->errors[$field][] = ucfirst($field) . ' must not exceed ' . $max . ' characters';
        }
        if ($value !== null && is_numeric($value) && $value > $max) {
            $this->errors[$field][] = ucfirst($field) . ' must not exceed ' . $max;
        }
    }

    private function length(string $field, mixed $value, int $length): void
    {
        if ($value !== null && strlen($value) !== $length) {
            $this->errors[$field][] = ucfirst($field) . ' must be exactly ' . $length . ' characters';
        }
    }

    private function numeric(string $field, mixed $value): void
    {
        if ($value !== null && !is_numeric($value)) {
            $this->errors[$field][] = ucfirst($field) . ' must be numeric';
        }
    }

    private function integer(string $field, mixed $value): void
    {
        if ($value !== null && !is_int($value) && !ctype_digit((string)$value)) {
            $this->errors[$field][] = ucfirst($field) . ' must be an integer';
        }
    }

    private function url(string $field, mixed $value): void
    {
        if ($value !== null && !filter_var($value, FILTER_VALIDATE_URL)) {
            $this->errors[$field][] = ucfirst($field) . ' must be a valid URL';
        }
    }

    private function phone(string $field, mixed $value): void
    {
        if ($value !== null && !preg_match('/^[+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$/', $value)) {
            $this->errors[$field][] = ucfirst($field) . ' must be a valid phone number';
        }
    }

    private function alpha(string $field, mixed $value): void
    {
        if ($value !== null && !ctype_alpha(str_replace(' ', '', $value))) {
            $this->errors[$field][] = ucfirst($field) . ' must contain only alphabetic characters';
        }
    }

    private function alphanumeric(string $field, mixed $value): void
    {
        if ($value !== null && !ctype_alnum(str_replace(' ', '', $value))) {
            $this->errors[$field][] = ucfirst($field) . ' must contain only alphanumeric characters';
        }
    }

    private function in(string $field, mixed $value, ?string $options): void
    {
        if ($value !== null && $options) {
            $allowedValues = explode(',', $options);
            if (!in_array($value, $allowedValues, true)) {
                $this->errors[$field][] = ucfirst($field) . ' must be one of: ' . $options;
            }
        }
    }

    private function unique(string $field, mixed $value, ?string $table): void
    {
        // Placeholder for database unique check
        // Implementation requires database connection
    }

    private function match(string $field, mixed $value, ?string $otherField): void
    {
        // Placeholder for field matching (e.g., password confirmation)
        // Implementation requires additional data context
    }

    public function getErrors(): array
    {
        return $this->errors;
    }

    public static function sanitize(string $value): string
    {
        return trim(htmlspecialchars($value, ENT_QUOTES, 'UTF-8'));
    }

    public static function sanitizeArray(array $data): array
    {
        $sanitized = [];
        foreach ($data as $key => $value) {
            $sanitized[$key] = is_array($value) ? self::sanitizeArray($value) : self::sanitize((string)$value);
        }
        return $sanitized;
    }
}
