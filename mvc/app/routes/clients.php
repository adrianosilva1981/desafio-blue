<?php
header('Content-Type: application/json');

use App\Controllers\ClientsController;

$method = $_SERVER['REQUEST_METHOD'];

$clients = new ClientsController();
$response = '';

switch ($method) {
    case 'GET':
        $response = $clients->getClients();
        break;
    default:
        http_response_code(501);
        echo json_encode(['message' => 'Method not allowed']);
        die();
}

echo json_encode($response);