<?php

namespace App\Controllers;

class ClientsController extends Controller
{
    private const METHODS = ['GET'];

    function __construct($request, $headers) {
        parent::__construct($request, $headers);
        $this->isMethosdAllowed(self::METHODS);
    }

    public function getClients() {
        return ['message' => 'clients works!'];
    }
}