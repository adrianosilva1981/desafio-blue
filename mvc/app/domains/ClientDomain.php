<?php

namespace App\Domains;

use App\Services\DatabaseConnectionService;
use PDO;

class ClientDomain
{
    private $host;
    private $dbName;
    private $username;
    private $password;
    private $port;

    function __construct() {
        $this->host = $_ENV['DB_HOST'];
        $this->dbName = $_ENV['DB_DATABASE'];
        $this->username = $_ENV['DB_USERNAME'];
        $this->password = $_ENV['DB_PASSWORD'];
        $this->port = $_ENV['DB_PORT'];
    }

    public function getClients() {
        $pdo = new DatabaseConnectionService($this->host, $this->dbName, $this->username, $this->password, $this->port);
        $conn = $pdo->getConnection();
        $stmt = $conn->query('SELECT * FROM cliente');
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

}