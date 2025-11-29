<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Super simple response - no database, no sessions
echo json_encode([
    "success" => true,
    "message" => "API IS WORKING!",
    "data_received" => file_get_contents('php://input')
]);
?>