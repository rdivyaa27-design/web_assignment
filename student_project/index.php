<?php
require 'db.php';
$sql = "SELECT * FROM students ORDER BY id DESC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            padding: 25px;
        }
        .container {
            max-width: 1100px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ddd;
        }
        h2 {
            color: #2563eb;
            text-align: center;
        }
        .success {
            background: #dcfce7;
            color: #166534;
            padding: 12px;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .add {
            display: inline-block;
            padding: 10px 15px;
            background: #16a34a;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .add:hover {
            background: #15803d;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: #2563eb;
            color: white;
        }
        tr:nth-child(even) {
            background: #f8fafc;
        }
        .action {
            display: inline-block;
            margin: 3px;
        }
        .empty {
            text-align: center;
            color: #666;
        }
        @media (max-width: 700px) {
            .container {
                overflow-x: auto;
            }
            table {
                min-width: 700px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Student Management System</h2>
    <?php if (isset($_GET['success']) && $_GET['success'] == '1'): ?>
        <div class="success">
            Student added successfully!
        </div>
    <?php endif; ?>
    <a class="add" href="add_form.php">
        + Add New Student
    </a>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Roll Number</th>
            <th>Email</th>
            <th>Course</th>
            <th>Actions</th>
        </tr>
        <?php if ($result && $result->num_rows > 0): ?>
            <?php while ($row = $result->fetch_assoc()): ?>
                <tr>
                    <td>
                        <?= (int)$row['id'] ?>
                    </td>
                    <td>
                        <?= htmlspecialchars($row['name']) ?>
                    </td>
                    <td>
                        <?= htmlspecialchars($row['roll_number']) ?>
                    </td>
                    <td>
                        <?= htmlspecialchars($row['email']) ?>
                    </td>
                    <td>
                        <?= htmlspecialchars($row['course']) ?>
                    </td>
                    <td>
                        <a class="action"
                           href="view.php?id=<?= (int)$row['id'] ?>">
                            View
                        </a>
                        <a class="action"
                           href="edit.php?id=<?= (int)$row['id'] ?>">
                            Edit
                        </a>
                        <a class="action"
                           href="delete.php?id=<?= (int)$row['id'] ?>"
                           onclick="return confirm('Are you sure you want to delete this student?');">
                            Delete
                        </a>
                    </td>
                </tr>
            <?php endwhile; ?>
        <?php else: ?>
            <tr>
                <td colspan="6" class="empty">
                    No students registered yet.
                </td>
            </tr>
        <?php endif; ?>
    </table>
</div>
</body>
</html>