<?php

namespace App\Exceptions;

use App\Utils\Response;
use Exception;

class RequestException extends Exception {

    private $customMessage;
    private $customCode;

    public function __construct(string $message, int $code = 500) {
        parent::__construct($message, $code);
        $this->customMessage = $message;
        $this->customCode = $code;
    }

    public function getRequestException() {
        return [
            'status' => self::isValid($this->code) ? $this->customCode : 500,
            'message' => $this->customMessage
        ];
    }

    private function isValid(int $code) {
        return Response::isValid($code);
    }
}