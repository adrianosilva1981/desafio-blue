<?php
require __DIR__ . '/../vendor/autoload.php';

use App\Utils\Response;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$routes = [
    '/' => __DIR__ . '/app.html',
    '/clients' => __DIR__ . '/../app/routes/clients.php',
];

if (array_key_exists($uri, $routes)) {
    require_once $routes[$uri];
} else {
    Response::json(['message' => 'Page not found'], 404);
}