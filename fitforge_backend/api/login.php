<?php
// fitforge_backend/api/login.php
require '../config/db_connect.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$data = json_decode(file_get_contents('php://input'), true);

$email = $data['email'] ?? '';
$password = $data['password'] ?? '';
$role = $data['role'] ?? 'user';

$stmt = $conn->prepare("SELECT id, name, password, role, profile_completed FROM users WHERE email = ? AND role = ?");
$stmt->bind_param("ss", $email, $role);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows == 0) {
    echo json_encode(["success" => false, "message" => "Wrong credentials"]);
    exit;
}

$stmt->bind_result($id, $name, $db_pass, $db_role, $profile_completed);
$stmt->fetch();

if ($password === $db_pass) {
    echo json_encode([
        "success" => true,
        "user" => [
            "id" => $id,
            "name" => $name,
            "role" => $db_role,
            "profile_completed" => (bool)$profile_completed
        ]
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Wrong password"]);
}

$stmt->close();
$conn->close();
?>