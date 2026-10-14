package com.student.servlet;

import com.student.model.User;
import com.student.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet handling user authentication and session creation.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If already logged in, redirect straight to students portal
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/students");
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("loginError", "Please enter both username and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String sql = "SELECT id, username, full_name, role FROM users WHERE username = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username.trim());
            stmt.setString(2, password.trim());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Valid credentials: Create user session
                    User user = new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("role")
                    );

                    HttpSession session = request.getSession(true);
                    session.setAttribute("currentUser", user);

                    // Optional: session timeout of 30 minutes
                    session.setMaxInactiveInterval(30 * 60);

                    // Redirect to secure student profiles page
                    response.sendRedirect(request.getContextPath() + "/students");
                    return;
                } else {
                    request.setAttribute("loginError", "Invalid username or password. Please try again.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            }

        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("[LoginServlet] Database Error during login: " + e.getMessage());
            request.setAttribute("loginError", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
