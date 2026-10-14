<?php
require 'db.php';
function escape($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    exit("Invalid student ID.");
}
$stmt = $conn->prepare(
    "SELECT * FROM students WHERE id = ?"
);
$stmt->bind_param("i", $id);
$stmt->execute();
$result = $stmt->get_result();
$student = $result->fetch_assoc();
$stmt->close();
if (!$student) {
    exit("Student not found.");
}
$message = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = trim($_POST['name'] ?? '');
    $roll = trim($_POST['roll_number'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $course = trim($_POST['course'] ?? '');
    if ($name === '' || $roll === '' ||
        $email === '' || $course === '') {
        $message = "Please fill in all fields.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $message = "Enter a valid email address.";
    } else {
        $update = $conn->prepare(
            "UPDATE students
             SET name = ?, roll_number = ?,
                 email = ?, course = ?
             WHERE id = ?"
        );
        $update->bind_param( "ssssi", $name, $roll, $email, $course, $id);
        if ($update->execute()) {
            $update->close();
            header("Location: view.php?id=" . $id);
            exit;
        } elseif ($conn->errno === 1062) {
            $message = "This roll number already exists.";
        } else {
            $message = "Unable to update student details.";
        }
        if (isset($update)) {
            $update->close();
        }
    }
    $student['name'] = $name;
    $student['roll_number'] = $roll;
    $student['email'] = $email;
    $student['course'] = $course;
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Student</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            padding: 30px;
        }
        .container {
            max-width: 400px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: #2563eb;
        }
        input {
            width: 100%;
            padding: 10px;
            margin: 8px 0 15px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: none;
            cursor: pointer;
        }
        .message {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Edit Student</h2>
    <?php if ($message !== ''): ?>
        <p class="message"><?= escape($message) ?></p>
    <?php endif; ?>
    <form method="POST">
        <label>Name</label>
        <input type="text" name="name" value="<?= escape($student['name']) ?>" required>
        <label>Roll Number</label>
        <input type="text" name="roll_number" value="<?= escape($student['roll_number']) ?>" required>
        <label>Email</label>
        <input type="email" name="email" value="<?= escape($student['email']) ?>" required>
        <label>Course</label>
        <input type="text" name="course" value="<?= escape($student['course']) ?>" required>
        <button type="submit"> Update Student </button>
    </form>
    <p><a href="index.php">Back to Student List</a></p>
</div>
</body>
</html>