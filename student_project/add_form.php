<!DOCTYPE html>
<html>
<head>
    <title>Add Student</title>
    <style>
        body {
            font-family: Arial;
            background: #f1f5f9;
            padding: 30px;
        }
        .container {
            width: 400px;
            max-width: 90%;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: blue;
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
            background: blue;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Student Registration</h2>
    <form action="add.php"
          method="POST"
          enctype="multipart/form-data">
        <label>Student Name</label>
        <input type="text" name="name" required>
        <label>Roll Number</label>
        <input type="text" name="roll_number" required>
        <label>Email</label>
        <input type="email" name="email" required>
        <label>Course</label>
        <input type="text" name="course" required>
        <label>Upload Document (Optional)</label>
        <input type="file" name="document" accept=".jpg,.jpeg,.png,.pdf">
        <button type="submit">Add Student</button>
    </form>
    <p>
        <a href="index.php">Back to Student List</a>
    </p>
</div>
</body>
</html>