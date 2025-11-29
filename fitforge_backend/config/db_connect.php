<?php
$conn = new mysqli("localhost", "root", "", "fitforge_db");

if ($conn->connect_error) {
    die('{"success":false,"message":"DB Error"}');
}

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");
?>