<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$email = $_POST['email'] ?? '';

if (empty($email)) {
    echo json_encode(['success' => false, 'message' => 'missing_email']);
    exit;
}

echo json_encode(db::uid($email));
