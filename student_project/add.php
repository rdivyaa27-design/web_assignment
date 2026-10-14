<?php
require 'db.php';
$uploadDir = 'C:/xampp/student_uploads/';
function failRequest($message) {
    http_response_code(400);
    exit(
        '<p style="color:red; font-family:Arial;">'
        . htmlspecialchars($message, ENT_QUOTES, 'UTF-8')
        . '</p><a href="add_form.php">Go Back</a>'
    );
}
$name = trim($_POST['name'] ?? '');
$roll = trim($_POST['roll_number'] ?? '');
$email = trim($_POST['email'] ?? '');
$course = trim($_POST['course'] ?? '');
if ($name === '' || $roll === '' ||
    $email === '' || $course === '') {
    failRequest("Please fill in all required fields.");
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    failRequest("Enter a valid email address.");
}
$stmt = $conn->prepare(
    "INSERT INTO students (name, roll_number, email, course)
     VALUES (?, ?, ?, ?)"
);
$stmt->bind_param("ssss", $name, $roll, $email, $course);
if (!$stmt->execute()) {
    if ($stmt->errno === 1062) {
        $stmt->close();
        failRequest("This roll number already exists.");
    }
    $stmt->close();
    failRequest("Unable to save student. Please check the database.");
}
$studentId = $conn->insert_id;
$stmt->close();
if (isset($_FILES['document']) &&
    $_FILES['document']['error'] !== UPLOAD_ERR_NO_FILE) {
    $file = $_FILES['document'];
    if ($file['error'] !== UPLOAD_ERR_OK) {
        failRequest( "Student was saved, but file upload failed. Error code: ". $file['error'] );
    }
    if ($file['size'] <= 0 ||
        $file['size'] > 2 * 1024 * 1024) {
        failRequest( "Student was saved, but the file must be smaller than 2 MB." );
    }
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime = $finfo->file($file['tmp_name']);
    $allowed = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'application/pdf' => 'pdf'
    ];
    if (!isset($allowed[$mime])) {
        failRequest( "Student was saved, but only JPG, PNG and PDF files are allowed." );
    }
    if (!is_dir($uploadDir)) {
        if (!mkdir($uploadDir, 0755, true)) {
            failRequest( "Student was saved, but the upload folder could not be created." );
        }
    }
    if (!is_writable($uploadDir)) {
        failRequest( "Student was saved, but the upload folder is not writable." );
    }
    $storedName = bin2hex(random_bytes(16))
                  . '.' . $allowed[$mime];
    $destination = $uploadDir . $storedName;
    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        failRequest(
            "Student was saved, but the uploaded file could not be stored."
        );
    }
    $relativePath = 'student_uploads/' . $storedName;
    $originalName = basename($file['name']);
    $fileSize = (int)$file['size'];
    $fileStmt = $conn->prepare(
        "INSERT INTO student_files
        (student_id, original_name, stored_name,
         file_path, file_type, file_size)
        VALUES (?, ?, ?, ?, ?, ?)"
    );
    $fileStmt->bind_param(
        "issssi",
        $studentId,
        $originalName,
        $storedName,
        $relativePath,
        $mime,
        $fileSize
    );
    if (!$fileStmt->execute()) {
        unlink($destination);
        $fileStmt->close();
        failRequest( "Student was saved, but file information could not be saved." );
    }
    $fileStmt->close();
}
header("Location: index.php?success=1");
exit;
?>