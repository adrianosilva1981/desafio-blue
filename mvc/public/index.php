<?php

require __DIR__ . '/../vendor/autoload.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$routes = [
    '/' => __DIR__ . '/app.html',
    '/clients' => __DIR__ . '/../app/routes/clients.php',
];

if (array_key_exists($uri, $routes)) {
    require_once $routes[$uri];
} else {
    http_response_code(404);
    echo json_encode([
        'message' => 'Page not found'
    ]);
}