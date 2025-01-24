<?php

namespace App\Controllers;

use App\Exceptions\RequestException;

class Controller
{
    private $request = [];
    private $headers = null; // pode-se ser usado para autenticaçao

    function __construct($request, $headers) {
        $this->request = $request;
        $this->headers = $headers;
    }

    protected function isMethosdAllowed($methods) {
        if (!in_array($this->request['REQUEST_METHOD'], $methods)) {
            http_response_code(405);
            echo json_encode(['message' => 'Method not allowed']);
            die();
        }
    }
}