<%@ page import="jakarta.servlet.http.*" %>
<%
    String type = request.getParameter("type");

    session.invalidate(); // Session  

    if ("admin".equals(type)) {
        response.sendRedirect("adminLogin.jsp");
    } else {
        response.sendRedirect("index.jsp");
    }
%>
