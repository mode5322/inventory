<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$id = $_POST['id'] ?? '';

if (empty($id)) {
    echo json_encode(['success' => false, 'message' => 'missing_id']);
    exit;
}

echo json_encode(db::delitem((int) $id));
