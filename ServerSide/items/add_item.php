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
    $tmp = $_FILES['image']['tmp_name'];
    $info = @getimagesize($tmp);
    $extMap = [
        IMAGETYPE_JPEG => 'jpg',
        IMAGETYPE_PNG => 'png',
        IMAGETYPE_GIF => 'gif',
        IMAGETYPE_WEBP => 'webp',
    ];
    $ext = ($info !== false) ? ($extMap[$info[2]] ?? null) : null;

    if ($ext === null) {
        $fromName = strtolower(pathinfo($_FILES['image']['name'] ?? '', PATHINFO_EXTENSION));
        if (in_array($fromName, ['jpg', 'jpeg', 'png', 'gif', 'webp'], true)) {
            $ext = $fromName === 'jpeg' ? 'jpg' : $fromName;
        }
    }

    if ($ext === null && function_exists('mime_content_type')) {
        $mimeMap = [
            'image/jpeg' => 'jpg',
            'image/png' => 'png',
            'image/gif' => 'gif',
            'image/webp' => 'webp',
        ];
        $mime = mime_content_type($tmp);
        $ext = $mimeMap[$mime] ?? null;
    }

    if ($ext !== null) {
        $fileName = uniqid('', true) . '.' . $ext;
        $dest = "$uploadsDir/$fileName";
        if (move_uploaded_file($tmp, $dest)) {
            $imgPath = "uploads/$fileName";
        }
    }
}

echo json_encode(db::addItem($name, $imgPath));
