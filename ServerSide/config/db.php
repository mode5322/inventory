<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// $host = '';
// $db = '';
// $user = '';
// $pass = '';

$host = 'localhost';
$db = 'mega';
$user = 'root';
$pass = '0000';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(['success' => false, 'message' => 'db_connection_failed: ' . $e->getMessage()]));
}

$pdo->exec("CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user'
)");

$pdo->exec("CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    img TEXT
)");

class db
{

    // result good : 2 ,4
    // result bad : 1 , 3
    //  --------------------------register function--------------------------------
    public static function register($email, $password, $name, $role)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT id FROM users WHERE email = :email");
        $stmt->execute(['email' => $email]);
        if ($stmt->fetch()) {
            return ['success' => false, 'message' => '1'];
        }

        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare("INSERT INTO users (email, password, name, role) VALUES (:email, :password, :name, :role)");
        $stmt->execute(['email' => $email, 'password' => $hashedPassword, 'name' => $name, 'role' => $role]);

        return ['success' => true, 'message' => '2'];
    }
        //  --------------------------login function--------------------------------
        public static function login($email, $password)
        {
            global $pdo;
            $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
            $stmt->execute(['email' => $email]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
            if (!$user) {
                return ['success' => false, 'message' => '1'];
            }
            if (!password_verify($password, $user['password'])) {
                return ['success' => false, 'message' => '3'];
            }
    
            return ['success' => true, 'message' => '2', 'name' => $user['name'], 'email' => $user['email'], 'role' => $user['role'], 'uid' => $user['id']];
        }
    
    //  --------------------------userID function--------------------------------
    public static function uid($email)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
        $stmt->execute(['email' => $email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            return ['success' => false, 'message' => '1'];
        }

        return ['success' => true, 'message' => '2', 'name' => $user['name'], 'email' => $user['email'], 'role' => $user['role'], 'uid' => $user['id']];
    }
    //  --------------------------getUsers function--------------------------------
    public static function uids()
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT id, name, email, role FROM users");
        $stmt->execute();
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

        return ['success' => true, 'message' => '2', 'users' => $users ?: []];
    }
    //  --------------------------updateProfile function--------------------------------
    public static function updateProfile($name, $email, int $uid)
    {
        global $pdo;
        $stmt = $pdo->prepare("UPDATE users SET name = ?, email = ? WHERE id = ?");
        $update = $stmt->execute([$name, $email, $uid]);

        if (!$update) {
            return ['success' => false, 'message' => '1'];
        }

        $stmt2 = $pdo->prepare("SELECT * FROM users WHERE id = ?");
        $stmt2->execute([$uid]);
        $userData = $stmt2->fetch(PDO::FETCH_ASSOC);

        if (!$userData) {
            return ['success' => false, 'message' => '1'];
        }

        return ['success' => true, 'message' => '2', 'name' => $userData['name'], 'email' => $userData['email'], 'role' => $userData['role']];
    }

    public static function deleteUser($email)
    {
        global $pdo;
        $stmt = $pdo->prepare("DELETE FROM users WHERE email = :email");
        if ($stmt->execute(['email' => $email])) {
            return ['success' => true, 'message' => '2'];
        }

        return ['success' => false, 'message' => '1'];
    }

    public static function addItem($name, $img)
    {
        global $pdo;
        $stmt = $pdo->prepare("INSERT INTO items (name, img) VALUES (:name, :img)");
        if ($stmt->execute(['name' => $name, 'img' => $img])) {
            return ['success' => true, 'message' => '2', 'img' => $img];
        }

        return ['success' => false, 'message' => '1'];
    }
    //  --------------------------updateItem function--------------------------------
    public static function updateItem($id, $name, $img)
    {
        global $pdo;
        $stmt = $pdo->prepare("UPDATE items SET name = :name, img = :img WHERE id = :id");
        if ($stmt->execute(['id' => $id, 'name' => $name, 'img' => $img])) {
            return ['success' => true, 'message' => '2'];
        }

        return ['success' => false, 'message' => '1'];
    }
    //  --------------------------deleteItem function--------------------------------
    public static function delitem($id)
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT img FROM items WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row && !empty($row['img'])) {
            $img = str_replace('\\', '/', trim($row['img']));
            if (str_starts_with($img, 'uploads/')) {
                $file = __DIR__ . '/../' . $img;
                if (is_file($file)) {
                    @unlink($file);
                }
            }
        }

        $stmt = $pdo->prepare("DELETE FROM items WHERE id = :id");
        if ($stmt->execute(['id' => $id])) {
            return ['success' => true, 'message' => '2'];
        }

        return ['success' => false, 'message' => '1'];
    }
    //  --------------------------getItems function--------------------------------
    public static function getItems()
    {
        global $pdo;
        $stmt = $pdo->prepare("SELECT * FROM items");
        $stmt->execute();
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($items as &$item) {
            $item['img'] = !empty($item['img'])
                ? str_replace('\\', '/', trim($item['img']))
                : '';
        }
        unset($item);
        return ['success' => true, 'message' => '2', 'items' => $items ?: []];
    }
}
