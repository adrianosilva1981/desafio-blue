<?php
header('Content-Type: application/json');

use App\Controllers\ClientsController;
use App\Utils\Response;

$method = $_SERVER['REQUEST_METHOD'];
$headers = getallheaders();
$statusCode = 400;
$response = ['message' => 'Bad request'];

$clients = new ClientsController($_SERVER, $headers);

switch ($method) {
    case 'GET':
        $response = $clients->getClients();
        $statusCode = 200;
        break;
    default:
        Response::json(['message' => 'Page not found'], 404);
}

if (in_array('status', $response)) {
    $statusCode = $response['status'];
    $response = $response['message'];
}

Response::json($response, $statusCode);