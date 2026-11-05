<?php
declare(strict_types=1);

require dirname(__DIR__) . '/vendor/autoload.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
http_response_code(503);
echo json_encode([
    'application' => 'Anoar CRM',
    'status' => 'setup_required',
    'message' => 'API ainda não habilitada. Autenticação e seleção segura de tenant pendentes.'
], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
