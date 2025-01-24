<?php

namespace App\Exceptions;

use Exception;

class RequestException extends Exception {

    private $customMessage;
    private $customCode;
    private const CODES = [
        100, 101, 102, 103,
        200, 201, 202, 203, 204, 205, 206, 207, 208, 226,
        300, 301, 302, 303, 304, 305, 307, 308,
        400, 401, 402, 403, 404, 405, 406, 407, 408, 409,
        410, 411, 412, 413, 414, 415, 416, 417, 418,
        421, 422, 423, 424, 425, 426, 428, 429, 431, 451,
        500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511,
    ];

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

    private static function isValid(int $code) {
        return in_array($code, self::CODES, true);
    }
}