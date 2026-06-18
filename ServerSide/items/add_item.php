<?php
require_once '../config/db.php';

header('Content-Type: application/json');

$name = $_POST['name'] ?? '';

if (empty($name)) {
    echo json_encode(['success' => false, 'message' => 'missing_name']);
    exit;
}

$uploadsDir = __DIR__ . '/../uploads';
if (!is_dir($uploadsDir)) {
    mkdir($uploadsDir, 0777, true);
}

$imgPath = '';

if (isset($_FILES['image']) && $_FILES['image']['error'] === UPLOAD_ERR_OK) {
    $info = getimagesize($_FILES['image']['tmp_name']);
    $extMap = [
        IMAGETYPE_JPEG => 'jpg',
        IMAGETYPE_PNG => 'png',
        IMAGETYPE_GIF => 'gif',
        IMAGETYPE_WEBP => 'webp',
    ];
    $ext = ($info !== false) ? ($extMap[$info[2]] ?? null) : null;

    if ($ext !== null) {
        $fileName = uniqid('', true) . '.' . $ext;
        $dest = "$uploadsDir/$fileName";    
        if (move_uploaded_file($_FILES['image']['tmp_name'], $dest)) {
            $imgPath = "uploads/$fileName";
        }
    }
}

echo json_encode(db::addItem($name, $imgPath));
