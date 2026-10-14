package com.student.servlet;

import com.student.model.Student;
import com.student.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet to handle retrieving student profiles along with their associated
 * photo and document paths from the MySQL database.
 * 
 * Compatible with Jakarta EE 10 / Tomcat 10.1.
 */
@WebServlet(name = "StudentServlet", urlPatterns = {"/students", "/student-profile"})
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Student> studentList = new ArrayList<>();
        String errorMessage = null;

        // Retrieve optional search query parameter
        String searchQuery = request.getParameter("search");
        boolean hasSearch = (searchQuery != null && !searchQuery.trim().isEmpty());
        String trimmedQuery = hasSearch ? searchQuery.trim() : "";

        // SQL queries using prepared statements
        String sql;
        if (hasSearch) {
            sql = "SELECT id, name, roll_number, email, course, phone, photo, document FROM students "
                + "WHERE name LIKE ? OR roll_number LIKE ? OR course LIKE ? "
                + "ORDER BY id ASC";
        } else {
            sql = "SELECT id, name, roll_number, email, course, phone, photo, document FROM students "
                + "ORDER BY id ASC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (hasSearch) {
                String searchPattern = "%" + trimmedQuery + "%";
                stmt.setString(1, searchPattern);
                stmt.setString(2, searchPattern);
                stmt.setString(3, searchPattern);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Student student = new Student();
                    student.setId(rs.getInt("id"));
                    student.setName(rs.getString("name"));
                    student.setRollNumber(rs.getString("roll_number"));
                    student.setEmail(rs.getString("email"));
                    student.setCourse(rs.getString("course"));
                    student.setPhone(rs.getString("phone"));
                    student.setPhoto(rs.getString("photo"));
                    student.setDocument(rs.getString("document"));

                    studentList.add(student);
                }
            }

        } catch (ClassNotFoundException e) {
            errorMessage = "JDBC Driver Error: MySQL Driver class (com.mysql.cj.jdbc.Driver) was not found. "
                         + "Ensure mysql-connector-j is present in WEB-INF/lib.";
            System.err.println("[StudentServlet] ClassNotFoundException: " + e.getMessage());
        } catch (SQLException e) {
            errorMessage = "Database Error: Unable to connect to MySQL or execute query. Details: " + e.getMessage()
                         + " | Please verify that MySQL service is running on localhost:3306 and student_db exists.";
            System.err.println("[StudentServlet] SQLException: " + e.getMessage());
        } catch (Exception e) {
            errorMessage = "Unexpected Server Error: " + e.getMessage();
            System.err.println("[StudentServlet] Exception: " + e.getMessage());
        }

        // Pass retrieved data and status to the JSP view
        request.setAttribute("studentList", studentList);
        request.setAttribute("searchQuery", trimmedQuery);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("totalCount", studentList.size());

        // Forward to students.jsp
        request.getRequestDispatcher("/students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
