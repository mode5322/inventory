<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$name = $_POST['name'] ?? '';
$email = $_POST['email'] ?? '';
$uid = (int)($_POST['uid'] ?? 0);

if (empty($email) || empty($name) || $uid === 0) {
    echo json_encode(['success' => false, 'message' => 'missing_fields']);
    exit;
}

echo json_encode(db::updateProfile($name, $email, $uid));
