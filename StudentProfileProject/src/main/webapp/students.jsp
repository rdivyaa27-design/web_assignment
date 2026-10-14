<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.student.model.Student" %>
<%@ page import="com.student.model.User" %>
<%@ page import="java.util.List" %>
<%
    // Safety check: Retrieve session user
    User currentUser = (User) session.getAttribute("currentUser");

    // Retrieve request attributes populated by StudentServlet
    List<Student> studentList = (List<Student>) request.getAttribute("studentList");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String searchQuery = (String) request.getAttribute("searchQuery");
    Integer totalCount = (Integer) request.getAttribute("totalCount");

    if (studentList == null && errorMessage == null) {
        response.sendRedirect(request.getContextPath() + "/students");
        return;
    }

    if (searchQuery == null) searchQuery = "";
    if (totalCount == null) totalCount = (studentList != null) ? studentList.size() : 0;
    boolean isFiltered = !searchQuery.trim().isEmpty();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profiles &amp; Documents | Portal</title>
    <!-- External CSS Stylesheet -->
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <div class="container">

        <!-- Top Header / Banner with Session Details -->
        <header class="page-header">
            <div class="header-top-bar">
                <h1>Student Profile &amp; Document Portal</h1>
                <% if (currentUser != null) { %>
                    <div class="session-user-badge">
                        <span class="session-user-name">&#128100; <%= currentUser.getFullName() %> (<%= currentUser.getRole() %>)</span>
                        <a href="<%= request.getContextPath() %>/logout" class="btn-logout" title="Sign out">&#128682; Logout</a>
                    </div>
                <% } %>
            </div>
        </header>

        <!-- Database Error Banner (conditionally displayed if DB connection fails) -->
        <% if (errorMessage != null) { %>
            <div class="alert-error" role="alert">
                <h3>&#9888; Database Connectivity / Server Error</h3>
                <p><%= errorMessage %></p>
                <p><strong>Troubleshooting Steps for Beginners:</strong></p>
                <ul class="troubleshoot-list">
                    <li>Ensure your MySQL Server is running on localhost:3306.</li>
                    <li>Ensure you executed <code>database.sql</code> to create <code>student_db</code>, <code>users</code>, and <code>students</code> tables.</li>
                    <li>Verify database credentials in <code>src/main/java/com/student/util/DBConnection.java</code>.</li>
                </ul>
            </div>
        <% } %>

        <!-- Action Card: Search Filter & Quick Controls -->
        <section class="action-card">
            <form action="<%= request.getContextPath() %>/students" method="GET" class="search-form">
                <div class="search-input-wrapper">
                    <span class="search-icon">&#128269;</span>
                    <input type="text" 
                           name="search" 
                           class="search-input" 
                           placeholder="Search by Name, Roll Number, or Course..." 
                           value="<%= searchQuery %>" 
                           autocomplete="off">
                </div>
                <button type="submit" class="btn btn-primary">&#128269; Search</button>
                <% if (isFiltered) { %>
                    <a href="<%= request.getContextPath() %>/students" class="btn btn-secondary">&#10006; Reset</a>
                <% } %>
            </form>

            <div class="results-meta">
                <span>Showing <span class="results-count"><%= totalCount %></span> student profile(s)</span>
                <% if (isFiltered) { %>
                    <span>for filter: <em>"<%= searchQuery %>"</em></span>
                <% } %>
            </div>
        </section>

        <!-- Main Content Area: Student Table with Streamed Images & Documents -->
        <% if (studentList != null && !studentList.isEmpty()) { %>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="students-table">
                        <thead>
                            <tr>
                                <th style="width: 70px; text-align: center;">Photo</th>
                                <th style="width: 130px;">Roll Number</th>
                                <th>Student Name</th>
                                <th>Course / Department</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th style="width: 200px; text-align: center;">Academic Document</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Looping through each student --%>
                            <% for (Student s : studentList) { %>
                                <tr>
                                    <%-- Conditional Logic: Image Streaming via Servlet --%>
                                    <td style="text-align: center;">
                                        <% if (s.getPhoto() != null && !s.getPhoto().trim().isEmpty()) { %>
                                            <%-- <img> tag points directly to the Image Streaming Servlet --%>
                                            <img src="<%= request.getContextPath() %>/student-image?id=<%= s.getId() %>" 
                                                 alt="<%= s.getName() %>" 
                                                 class="student-avatar-img"
                                                 title="Streamed via Servlet">
                                        <% } else { %>
                                            <%-- Fallback placeholder when no photo path exists --%>
                                            <div class="avatar-placeholder" title="No photo uploaded">
                                                <%= (s.getName() != null && s.getName().length() > 0) ? s.getName().substring(0, 1) : "?" %>
                                            </div>
                                        <% } %>
                                    </td>

                                    <td><span class="student-roll"><%= s.getRollNumber() %></span></td>
                                    <td class="student-name"><%= s.getName() %></td>
                                    <td><span class="student-course"><%= s.getCourse() %></span></td>
                                    <td class="student-email">
                                        <a href="mailto:<%= s.getEmail() %>">&#9993; <%= s.getEmail() %></a>
                                    </td>
                                    <td class="student-phone">
                                        <a href="tel:<%= s.getPhone() %>">&#9742; <%= s.getPhone() %></a>
                                    </td>

                                    <%-- Conditional Logic: Document Streaming (View + Download) via Servlet --%>
                                    <td style="text-align: center;">
                                        <% if (s.getDocument() != null && !s.getDocument().trim().isEmpty()) { %>
                                            <div class="doc-actions-group">
                                                <%-- Option 1: View PDF inline in new browser tab --%>
                                                <a href="<%= request.getContextPath() %>/student-document?id=<%= s.getId() %>" 
                                                   target="_blank" 
                                                   class="btn-doc-view"
                                                   title="View <%= s.getDocument() %> in browser">
                                                    &#128065; View
                                                </a>
                                                <%-- Option 2: Download PDF directly to local machine --%>
                                                <a href="<%= request.getContextPath() %>/student-document?id=<%= s.getId() %>&download=true" 
                                                   class="btn-doc-download"
                                                   download="<%= s.getDocument() %>"
                                                   title="Download <%= s.getDocument() %> to computer">
                                                    &#11015; Download
                                                </a>
                                            </div>
                                        <% } else { %>
                                            <span class="badge-none">No Document</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } else if (errorMessage == null) { %>
            <!-- Friendly Empty State -->
            <div class="table-card">
                <div class="empty-state">
                    <div class="empty-state-icon">&#128100;</div>
                    <h3>No Student Records Found</h3>
                    <% if (isFiltered) { %>
                        <p>No student profiles matched your search term <strong>"<%= searchQuery %>"</strong>.</p>
                        <a href="<%= request.getContextPath() %>/students" class="btn btn-primary">View All Students</a>
                    <% } else { %>
                        <p>There are currently no student records in MySQL. Please run <code>database.sql</code> to insert records.</p>
                        <a href="<%= request.getContextPath() %>/students" class="btn btn-secondary">&#8635; Refresh</a>
                    <% } %>
                </div>
            </div>
        <% } %>

        <!-- Footer -->
        <footer class="page-footer">
            <p><strong>Student Profile Display System</strong> &bull; Secure Image &amp; Document Streaming</p>
            <p>Servlet File Streaming &bull; Active Session Validation &bull; Student Record Protection</p>
        </footer>

    </div>

</body>
</html>
