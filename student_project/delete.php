<?php
require 'db.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    exit("Invalid student ID.");
}
$uploadDir = 'C:/xampp/student_uploads/';
$stmt = $conn->prepare(
    "SELECT id FROM students WHERE id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$student = $result->fetch_assoc();
$stmt->close();
if (!$student) {
    exit("Student not found.");
}
$stmt = $conn->prepare(
    "SELECT stored_name
     FROM student_files
     WHERE student_id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$storedNames = [];
while ($row = $result->fetch_assoc()) {
    $storedNames[] = basename($row['stored_name']);
}
$stmt->close();
$conn->begin_transaction();
try {
    $stmt = $conn->prepare(
        "DELETE FROM student_files WHERE student_id = ?"
    );
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->close();
    $stmt = $conn->prepare(
        "DELETE FROM students WHERE id = ?"
    );
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->close();
    $conn->commit();
} catch (Throwable $e) {
    $conn->rollback();
    http_response_code(500);
    exit("Unable to delete student.");
}
foreach ($storedNames as $storedName) {
    $path = $uploadDir . $storedName;
    if (is_file($path)) {
        @unlink($path);
    }
}
header("Location: index.php");
exit;
?>