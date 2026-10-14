<?php
require 'db.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    http_response_code(400);
    exit("Invalid file ID.");
}
$stmt = $conn->prepare(
    "SELECT original_name, stored_name, file_type
     FROM student_files
     WHERE id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$file = $result->fetch_assoc();
$stmt->close();
if (!$file) {
    http_response_code(404);
    exit("File not found.");
}
$uploadDir = 'C:/xampp/student_uploads/';
$storedName = basename($file['stored_name']);
$path = $uploadDir . $storedName;
$allowedTypes = [
    'image/jpeg',
    'image/png',
    'application/pdf'
];
if (!in_array($file['file_type'], $allowedTypes, true) ||
    !is_file($path)) {
    http_response_code(404);
    exit("The requested file is unavailable.");
}
$originalName = str_replace(
    ["\r", "\n", '"'],
    '',
    basename($file['original_name'])
);
header('X-Content-Type-Options: nosniff');
header('Content-Type: ' . $file['file_type']);
header('Content-Length: ' . filesize($path));
header(
    'Content-Disposition: inline; filename="' .
    $originalName . '"; filename*=UTF-8\'\'' .
    rawurlencode($originalName)
);
readfile($path);
exit;
?>