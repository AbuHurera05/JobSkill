<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String jobId = request.getParameter("jobId");
    String jobTitle = "", companyName = "", location = "", salary = "", jobDescription = "", department = "", lastDate = "", company_pic = "";

    if (jobId != null) {
        String dbURL = "jdbc:mysql://localhost:3306/jobportal?useSSL=false&serverTimezone=UTC";
        String dbUser = "root"; 
        String dbPassword = "root"; 

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String query = "SELECT * FROM jobs WHERE jobId = ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, jobId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                jobTitle = rs.getString("title");
                companyName = rs.getString("company");
                location = rs.getString("location");
                salary = rs.getString("salary");
                jobDescription = rs.getString("description");
                department = rs.getString("department");
                lastDate = rs.getString("lastDate");
                company_pic = rs.getString("company_pic");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job Details</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <style>
        body {
            background-color: #f8f9fa;
        }
        .job-container {
            max-width: 900px;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
        }
        .job-header {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .job-header img {
            width: 80px;
            height: 80px;
            border-radius: 10px;
        }
        .job-title {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        .job-info {
            margin-top: 20px;
        }
        .job-info table {
            width: 100%;
        }
        .job-info th {
            background: #007bff;
            color: white;
            padding: 10px;
            text-align: left;
            width: 30%;
        }
        .job-info td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
        .btn-apply {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-apply:hover {
            background: #218838;
        }
        .btn-back {
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-back:hover {
            background: #c82333;
        }
    </style>
</head>
<body>

<div class="job-container">
    <div class="job-header">
        <img src="<%= "uploads/" + company_pic %>" alt="Company Logo">
        <div>
            <h2 class="job-title"><%= jobTitle %></h2>
            <p class="text-muted"><i class="fas fa-building"></i> <strong>Company:</strong> <%= companyName %></p>
        </div>
    </div>

    <div class="job-info">
        <table class="table table-bordered">
            <tr>
                <th>Location</th>
                <td><i class="fas fa-map-marker-alt"></i> <%= location %></td>
            </tr>
            <tr>
                <th>Salary</th>
                <td><i class="fas fa-money-bill-wave"></i> <%= salary %></td>
            </tr>
            <tr>
                <th>Department</th>
                <td><i class="fas fa-sitemap"></i> <%= department %></td>
            </tr>
            <tr>
                <th>Last Date to Apply</th>
                <td><i class="fas fa-calendar-alt"></i> <%= lastDate %></td>
            </tr>
            <tr>
                <th>Job Description</th>
                <td><%= jobDescription %></td>
            </tr>
        </table>
    </div>

    <div class="btn-container">
        <a class="btn btn-apply" href="applyJob.jsp?jobId=<%= jobId %>">Apply Now</a>
        <a class="btn btn-back" href="index.jsp">Back to Home</a>
    </div>
</div>

<!-- Bootstrap JS & FontAwesome -->
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
