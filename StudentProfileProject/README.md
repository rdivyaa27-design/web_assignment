# Student Profile & Document Streaming Portal (16 AP CO5)

A complete, working **Java Web Application** developed for a **Web Technologies Lab Assignment**.

This project implements a secure student profile directory that streams student photos and academic documents directly from the filesystem through Java Servlets, complete with Jakarta EE 10 session authentication and conditional rendering in JSP.

---

## 📌 Technologies Used

| Technology | Version / Specification | Role in Application |
| :--- | :--- | :--- |
| **Java JDK** | Java SE 21 LTS | Core runtime and compilation |
| **Java Servlets** | Jakarta Servlet 6.0 (`jakarta.servlet.*`) | Controller & File Streaming layer (`FileStreamServlet`, `LoginServlet`, etc.) |
| **Servlet Filter** | Jakarta EE `Filter` (`AuthFilter`) | Enforces session security and redirects unauthorized visitors |
| **JSP (JavaServer Pages)** | Jakarta Server Pages 3.1 | View layer: renders dynamic student cards, `<img>` tags, and looping |
| **JDBC** | Java Database Connectivity 4.3 | Data access layer: connects Java code to MySQL |
| **Database** | MySQL 8.0+ / MariaDB (XAMPP) | Stores `users` and `students` tables with photo/doc file paths |
| **Web Server** | Apache Tomcat 10.1 | Jakarta EE 10 compliant Servlet container |
| **Build Tool** | Apache Maven 3.9+ | Dependency management and `.war` packaging |
| **Frontend** | HTML5 & CSS3 | Clean, modern user interface |

---

## 🔑 Lab Assignment Scenarios & Solutions (16 AP CO5)

### 1. Database & JDBC File Paths
- **Requirement:** Connect to MySQL using JDBC to fetch student details and associated file paths.
- **Solution:** `StudentServlet.java` executes prepared statements on `student_db.students` to fetch student details alongside `photo` (`student1.png`) and `document` (`resume_aarav.pdf`) filename paths.

### 2. Image & Document Streaming
- **Requirement:** Retrieve and stream images/documents from the folder where they are stored.
- **Solution:** `FileStreamServlet.java` handles requests to `/student-image?id=...` and `/student-document?id=...`. It reads the raw binary bytes from the server's `uploads/` directory, detects the MIME type (e.g., `image/png`, `application/pdf`), and streams the data through `response.getOutputStream()`. If a photo is missing, it dynamically generates an SVG avatar fallback.

### 3. Dynamic `<img>` Tags in JSP
- **Requirement:** Display student profiles dynamically in an HTML/JSP page with `<img>` tags pointing to the Servlet.
- **Solution:** In `students.jsp`:
  ```jsp
  <img src="<%= request.getContextPath() %>/student-image?id=<%= s.getId() %>" 
       alt="<%= s.getName() %>" class="student-avatar-img">
  ```

### 4. Looping & Conditional Logic
- **Requirement:** Implement looping and conditional logic to list multiple students and their files.
- **Solution:** In `students.jsp`:
  - Iterates over `studentList` using a loop.
  - **Conditional Check 1 (Photo):** If `s.getPhoto()` is present, renders the `<img>` tag; if `NULL`, renders a fallback initials avatar card.
  - **Conditional Check 2 (Document):** If `s.getDocument()` is present, renders a "View Doc" link; if `NULL`, renders a "No File" badge (tested with Student #6 Pooja Nair).

### 5. Session Handling & Portal Security
- **Requirement:** Ensure session handling so that only logged-in users can access the portal securely.
- **Solution:**
  - `login.jsp` provides the login form.
  - `LoginServlet.java` checks user credentials against the `users` table and creates an `HttpSession` storing the `User` object.
  - `AuthFilter.java` intercepts all requests to `/students`, `/student-image`, and `/student-document`. If the session is missing or expired, it automatically redirects the user to `/login.jsp?error=unauthorized`.
  - `LogoutServlet.java` calls `session.invalidate()` and returns to the login screen.

---

## 🔐 Demo Credentials

| Role | Username | Password |
| :--- | :--- | :--- |
| **Administrator** | `admin` | `admin123` |
| **Faculty Member** | `faculty` | `faculty123` |
| **Guest Student** | `student` | `student123` |

---

## 📁 Project Directory Structure

```text
StudentProfileProject/
│
├── pom.xml                                  <-- Maven build configuration (Java 21 & Tomcat 10.1)
├── database.sql                             <-- SQL schema: users, students, sample records
├── build.bat                                <-- 1-Click Maven build script
├── setup-db.bat                             <-- 1-Click MySQL database import script
├── deploy-to-tomcat.bat                     <-- 1-Click deployment to Tomcat 10.1
├── start-tomcat.bat                         <-- 1-Click Tomcat launcher
├── stop-tomcat.bat                          <-- 1-Click Tomcat stopper
├── README.md                                <-- Project documentation
│
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── student/
        │           ├── filter/
        │           │   └── AuthFilter.java  <-- Security Filter checking HttpSession
        │           ├── model/
        │           │   ├── Student.java     <-- Student Model (photo & document paths)
        │           │   └── User.java        <-- User Model for authenticated session
        │           ├── util/
        │           │   └── DBConnection.java<-- JDBC Connection Manager (MySQL)
        │           └── servlet/
        │               ├── FileStreamServlet.java <-- Streams images & PDF documents
        │               ├── LoginServlet.java      <-- Authenticates and creates session
        │               ├── LogoutServlet.java     <-- Invalidates session
        │               └── StudentServlet.java    <-- Retrieves students from MySQL
        │
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml                  <-- Deployment descriptor (Servlet 6.0)
            ├── css/
            │   └── style.css                <-- Modern stylesheet with avatars & login card
            ├── uploads/                     <-- Storage folder for student photos & PDFs
            │   ├── student1.png ... student5.png
            │   └── resume_aarav.pdf ... idcard_aditya.pdf
            ├── index.jsp                    <-- Entry point (routes to login or portal)
            ├── login.jsp                    <-- Login page with session authentication
            └── students.jsp                 <-- Portal view: table, streamed images, docs
```

---

## 🚀 How to Run the Application

1. **Verify MySQL is Running**: Port 3306.
2. **Start Tomcat**:
   - Double-click [`start-tomcat.bat`](file:///c:/Users/rdivy/OneDrive/Desktop/StudentProfileProject/start-tomcat.bat).
3. **Open in Browser**:
   - Navigate to: **`http://localhost:8080/StudentProfileProject/`**
4. **Sign In**:
   - Username: `admin`
   - Password: `admin123`
5. **View and Test**:
   - The student photos are streamed via `<img src="student-image?id=...">`.
   - The documents can be viewed/downloaded via `<a href="student-document?id=...">`.
   - Try the search bar (filter by name, roll number, or department).
   - Click **Logout** to verify session termination.
