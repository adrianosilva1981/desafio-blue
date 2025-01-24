<?php

namespace App\Services;

use PDO;
use PDOException;

class DatabaseConnectionService
{
    private PDO $connection;
    private $host;
    private $dbName;
    private $username;
    private $password;
    private $port;

    public function __construct($host, $dbName, $username, $password, $port) {
        $this->host = $host;
        $this->dbName = $dbName;
        $this->username = $username;
        $this->password = $password;
        $this->port = $port;

        $this->connect();
    }

    private function connect() {
        $connString = "mysql:host={$this->host};port={$this->port};dbname={$this->dbName}";

        try {
            $this->connection = new PDO($connString, $this->username, $this->password);
        } catch (PDOException $e) {
            throw new PDOException('SQL connection error: ' . $e->getMessage());
        }
    }

    public function getConnection(): PDO {
        return $this->connection;
    }
}