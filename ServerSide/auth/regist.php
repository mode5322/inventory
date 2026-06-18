<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$email = $_POST['email'] ?? 'fdsfds';
$password = $_POST['password'] ?? 'fdsfds';
$name = $_POST['name'] ?? 'fdsfdsfd';
$role = $_POST['role'] ?? 'user';
if (empty($email) || empty($password) || empty($name) || empty($role)) {
    echo json_encode(['success' => false, 'message' => 'missing_fields']);
    exit;
}

echo json_encode(db::register($email, $password, $name, $role));
