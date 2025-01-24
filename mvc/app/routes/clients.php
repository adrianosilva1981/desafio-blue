<?php
header('Content-Type: application/json');

use App\Controllers\ClientsController;

$method = $_SERVER['REQUEST_METHOD'];
$headers = getallheaders();
$response = '';

$clients = new ClientsController($_SERVER, $headers);

switch ($method) {
    case 'GET':
        $response = $clients->getClients();
        break;
    default:
        http_response_code(204);
        die();
}

echo json_encode($response);