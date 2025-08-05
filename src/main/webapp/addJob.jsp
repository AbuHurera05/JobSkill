<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Database Connection Details
    String dbURL = "jdbc:mysql://localhost:3306/jobportal";
    String dbUser = "root";
    String dbPass = "root";

    // Form Data
    String title = request.getParameter("title");
    String salary = request.getParameter("salary");
    String location = request.getParameter("location");
    String department = request.getParameter("department");
    String company = request.getParameter("company");
    String type = request.getParameter("type"); // Full-Time / Part-Time
    String lastDate=request.getParameter("lastDate");
    String description = request.getParameter("description");

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // SQL Insert Query (Without Image)
        String sql = "INSERT INTO jobs (title, salary, location, department, company, job_category,lastDate,company_pic description) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, title);
        stmt.setString(2, salary);
        stmt.setString(3, location);
        stmt.setString(4, department);
        stmt.setString(5, company);
        stmt.setString(6, type);
        stmt.setString(7, lastDate);
        stmt.setString(8, description);

        int rowsInserted = stmt.executeUpdate();
        stmt.close();
        conn.close();

        // Redirect to View Jobs Section
        if (rowsInserted > 0) {
%>
            <script>
                alert("✅ Job Added Successfully!");
                window.location.href = "adminpanel.jsp#viewJobsSection"; // Redirect
            </script>
<%
        } else {
            out.println("<h3>❌ Failed to Add Job!</h3>");
        }

    } catch (Exception e) {
        out.println("<h3>⚠ Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    }
%>
