<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // If user has an active session, go to students portal; otherwise, go to login page
    if (session.getAttribute("currentUser") != null) {
        response.sendRedirect(request.getContextPath() + "/students");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
%>
