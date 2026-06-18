<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['success' => false, 'message' => 'missing_fields']);
    exit;
}

echo json_encode(db::login($email, $password));
