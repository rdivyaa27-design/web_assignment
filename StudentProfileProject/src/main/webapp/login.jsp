<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String loginError = (String) request.getAttribute("loginError");
    String paramError = request.getParameter("error");
    String logoutParam = request.getParameter("logout");

    if (loginError == null && "unauthorized".equals(paramError)) {
        loginError = "Access Denied: Please log in first to access the student portal.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Student Profile Portal</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

    <div class="auth-container">
        <div class="auth-card">
            
            <div class="auth-header">
                <h2>Student Portal Login</h2>
            </div>

            <% if (logoutParam != null) { %>
                <div class="alert-success" role="alert">
                    <span>&#10004; You have been successfully logged out.</span>
                </div>
            <% } %>

            <% if (loginError != null) { %>
                <div class="alert-error" role="alert">
                    <span>&#9888; <%= loginError %></span>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="POST" class="auth-form">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="Enter your username" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">&#128274; Sign In to Portal</button>
            </form>

        </div>
    </div>

</body>
</html>
