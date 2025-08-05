<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    String dbURL = "jdbc:mysql://localhost:3306/jobportal";
    String dbUser = "root";
    String dbPassword = "root";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        // String department = request.getParameter("department"); // Removed

        if (name != null && email != null && password != null) {
            String query = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<script>alert('Signup Successful!'); window.location='login.jsp';</script>");
            } else {
                out.println("<script>alert('Signup Failed. Try Again!'); window.history.back();</script>");
            }
        } else {
            out.println("<script>alert('All fields are required!'); window.history.back();</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('email is already exist'); window.history.back();</script>");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
