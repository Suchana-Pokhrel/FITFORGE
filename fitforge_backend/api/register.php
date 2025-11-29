<?php
require '../config/db_connect.php';

$data = json_decode(file_get_contents('php://input'), true);

$name     = $data['name']     ?? '';
$email    = $data['email']    ?? '';
$password = $data['password'] ?? '';
$role     = $data['role']     ?? 'user';
$secret   = $data['secret_key'] ?? '';

if (empty($name) || empty($email) || empty($password)) {
    echo json_encode(["success" => false, "message" => "All fields required"]);
    exit;
}

if ($role === 'admin' && $secret !== "FITFORGE_ADMIN_2025") {
    echo json_encode(["success" => false, "message" => "Wrong Admin Key"]);
    exit;
}

// Check if email exists
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Email already exists"]);
    exit;
}

$stmt = $conn->prepare("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $name, $email, $password, $role);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Registered!"]);
} else {
    echo json_encode(["success" => false, "message" => "Failed"]);
}

$stmt->close();
$conn->close();
?>