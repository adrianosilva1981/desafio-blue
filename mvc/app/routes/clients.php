<?php
header('Content-Type: application/json');

use App\Controllers\ClientsController;

$method = $_SERVER['REQUEST_METHOD'];
$headers = getallheaders();
$statusCode = 204;
$response = '';

$clients = new ClientsController($_SERVER, $headers);

switch ($method) {
    case 'GET':
        $response = $clients->getClients();
        $statusCode = 200;
        break;
    default:
        http_response_code($statusCode);
        die();
}

http_response_code($statusCode);
echo json_encode($response);