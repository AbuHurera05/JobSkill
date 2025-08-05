<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String userEmail = (String) session.getAttribute("userEmail"); // Logged-in User's Email
    String jobId = request.getParameter("jobId");
    String jobTitle = "";
    boolean applicationSuccess = false;
    boolean alreadyApplied = false;

    if (jobId != null && userEmail != null) {
        String dbURL = "jdbc:mysql://localhost:3306/jobportal?useSSL=false&serverTimezone=UTC";
        String dbUser = "root"; 
        String dbPassword = "root"; 

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Step 1: Check if CV is uploaded
            String cvCheckQuery = "SELECT cv_file FROM users WHERE email = ?";
            stmt = conn.prepareStatement(cvCheckQuery);
            stmt.setString(1, userEmail);
            rs = stmt.executeQuery();
            if (rs.next()) {
                String cvPath = rs.getString("cv_file");
                if (cvPath == null || cvPath.trim().equals("")) {
                    // Redirect to profile.jsp if CV not uploaded
                    response.sendRedirect("profile.jsp");
                    return;
                }
            } else {
                // If user not found in DB
                response.sendRedirect("profile.jsp");
                return;
            }
            rs.close();
            stmt.close();

            // Step 2: Check if already applied
            String checkQuery = "SELECT * FROM applications WHERE jobId = ? AND userEmail = ?";
            stmt = conn.prepareStatement(checkQuery);
            stmt.setString(1, jobId);
            stmt.setString(2, userEmail);
            rs = stmt.executeQuery();

            if (rs.next()) {
                alreadyApplied = true;
            }
            rs.close();
            stmt.close();

            if (!alreadyApplied) {
                // Step 3: Get job title
                String jobQuery = "SELECT title FROM jobs WHERE jobId = ?";
                stmt = conn.prepareStatement(jobQuery);
                stmt.setString(1, jobId);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    jobTitle = rs.getString("title");
                }
                rs.close();
                stmt.close();

                // Step 4: Insert application record in applications table
                String insertQuery = "INSERT INTO applications (jobId, userEmail) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertQuery);
                stmt.setString(1, jobId);
                stmt.setString(2, userEmail);
                int rowsInserted = stmt.executeUpdate();

                if (rowsInserted > 0) {
                    applicationSuccess = true;

                    // Step 5: Update user's status in users table to "applied"
                    String updateStatusQuery = "UPDATE users SET status = ? WHERE email = ?";
                    stmt = conn.prepareStatement(updateStatusQuery);
                    stmt.setString(1, "applied");
                    stmt.setString(2, userEmail);
                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
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
    <title>Application Status</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to right, #00c6ff, #0072ff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        h2 {
            color: #0072ff;
            font-size: 24px;
            margin-bottom: 15px;
        }
        p {
            font-size: 18px;
            color: #555;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            padding: 12px 20px;
            font-size: 16px;
            color: #fff;
            background: #0072ff;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        .btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Job Application Status</h2>

    <% if (alreadyApplied) { %>
        <p><strong>Oops!</strong> You have already applied for the <strong><%= jobTitle %></strong>.</p>
    <% } else if (applicationSuccess) { %>
        <p>Congratulations! You have successfully applied for the <strong><%= jobTitle %></strong>.</p>
    <% } else { %>
        <p>Oops! Something went wrong. Please try again.</p>
    <% } %>

    <a href="index.jsp" class="btn">Back to Home</a>
</div>

</body>
</html>
