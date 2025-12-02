<?php
// fitforge_backend/api/save_profile.php
require '../config/db_connect.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

$user_id = $data['user_id'] ?? 0;
$age = $data['age'] ?? null;
$height = $data['height'] ?? null;
$weight = $data['weight'] ?? null;
$gender = $data['gender'] ?? null;
$goal = $data['goal'] ?? null;
$activity = $data['activity_level'] ?? null;

if ($user_id == 0) {
    echo json_encode(["success" => false, "message" => "Invalid user"]);
    exit;
}

$stmt = $conn->prepare("UPDATE users SET age=?, height=?, weight=?, gender=?, goal=?, activity_level=?, profile_completed=1 WHERE id=?");
$stmt->bind_param("iiisssi", $age, $height, $weight, $gender, $goal, $activity, $user_id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Profile saved"]);
} else {
    echo json_encode(["success" => false, "message" => "Save failed"]);
}

$stmt->close();
$conn->close();
?>