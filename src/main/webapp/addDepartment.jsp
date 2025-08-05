<%@ page import="java.sql.*" %>
<%
    String depName = request.getParameter("depName");

    if (depName != null && !depName.trim().isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");
            PreparedStatement ps = conn.prepareStatement("INSERT INTO departments(name) VALUES(?)");
            ps.setString(1, depName);
            int i = ps.executeUpdate();
            if (i > 0) {
                response.sendRedirect("adminpanel.jsp");
            } else {
                out.print("Failed to add department.");
            }
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        }
    } else {
        out.print("Department name is required.");
    }
%>
