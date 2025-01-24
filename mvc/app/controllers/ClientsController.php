<?php

namespace App\Controllers;

class ClientsController
{
    function __construct() {}

    public function getClients() {
        return ['message' => 'clients works!'];
    }
}