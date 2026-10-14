<?php
require 'db.php';
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    exit("Invalid student ID.");
}
$stmt = $conn->prepare( "SELECT * FROM students WHERE id = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$student = $result->fetch_assoc();
$stmt->close();
if (!$student) {
    exit("Student not found.");
}
$fileStmt = $conn->prepare(
    "SELECT id, original_name, file_type, file_size, upload_date
     FROM student_files
     WHERE student_id = ?
     ORDER BY id DESC"
);
$fileStmt->bind_param("i", $id);
$fileStmt->execute();
$files = $fileStmt->get_result();
function escape($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Student Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            padding: 30px;
        }
        .container {
            max-width: 650px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }
        h2 {
            color: #2563eb;
        }
        .detail {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .label {
            font-weight: bold;
        }
        li {
            margin: 12px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Student Profile</h2>
    <div class="detail">
        <span class="label">ID:</span>
        <?= (int)$student['id'] ?>
    </div>
    <div class="detail">
        <span class="label">Name:</span>
        <?= escape($student['name']) ?>
    </div>
    <div class="detail">
        <span class="label">Roll Number:</span>
        <?= escape($student['roll_number']) ?>
    </div>
    <div class="detail">
        <span class="label">Email:</span>
        <?= escape($student['email']) ?>
    </div>
    <div class="detail">
        <span class="label">Course:</span>
        <?= escape($student['course']) ?>
    </div>
    <h3>Uploaded Documents</h3>
    <?php if ($files->num_rows > 0): ?>
        <ul>
            <?php while ($file = $files->fetch_assoc()): ?>
                <li>
                    <strong>
                        <?= escape($file['original_name']) ?>
                    </strong>
                    <br>
                    Type:
                    <?= escape($file['file_type']) ?>
                    <br>
                    Size:
                    <?= number_format($file['file_size'] / 1024, 2) ?>
                    KB
                    <br>
                    Uploaded:
                    <?= escape($file['upload_date']) ?>
                    <br>
                    <a href="download.php?id=<?= (int)$file['id'] ?>">
                        View / Download File
                    </a>
                </li>
            <?php endwhile; ?>
        </ul>
    <?php else: ?>
        <p>No documents uploaded.</p>
    <?php endif; ?>
    <p>
        <a href="edit.php?id=<?= (int)$student['id'] ?>">
            Edit Student
        </a>
    </p>
    <p>
        <a href="index.php">Back to Student List</a>
    </p>
</div>
</body>
</html>
<?php
$fileStmt->close();
?>