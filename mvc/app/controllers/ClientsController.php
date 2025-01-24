<?php

namespace App\Controllers;

use App\Domains\ClientDomain;
use App\Exceptions\RequestException;

class ClientsController extends Controller
{
    private const METHODS = ['GET'];
    private $clientDomain;

    function __construct($request, $headers) {
        parent::__construct($request, $headers);
        $this->isMethosdAllowed(self::METHODS);
        $this->clientDomain = new ClientDomain();
    }

    public function getClients() {
        try {
            return $this->clientDomain->getClients();
        } catch (RequestException $e) {
            return $e->getRequestException();
        }
    }
}