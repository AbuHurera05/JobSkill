<%@ page import="java.sql.*" %>
<%
    String jobId = request.getParameter("jobId");
    String title = "", description = "", location = "", department = "", company = "", type = "", lastDate = "", image = "";
    int salary = 0;

    if (jobId != null && !jobId.trim().equals("")) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            String sql = "SELECT * FROM jobs WHERE jobId = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(jobId));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                title = rs.getString("title");
                description = rs.getString("description");
                salary = rs.getInt("salary");
                location = rs.getString("location");
                department = rs.getString("department");
                company = rs.getString("company");
                type = rs.getString("job_category");
                lastDate = rs.getString("lastDate");
                image = rs.getString("company_pic");
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Job</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background: #f0f2f5;
        }
        .form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            margin-top: 40px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        .form-title {
            font-weight: bold;
            margin-bottom: 20px;
            text-align: center;
            color: #333;
        }
        .btn-primary {
            width: 100%;
        }
        .btn-success {
            width: 100%;
        }
        @media (max-width: 768px) {
            .form-container {
                margin: 20px 10px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-container col-md-8 offset-md-2">
        <h2 class="form-title">Edit Job</h2>

        <form action="UpdateJobServlet" method="POST">
            <input type="hidden" name="jobId" value="<%=jobId%>">

            <div class="mb-3">
                <label class="form-label">Job Title</label>
                <input type="text" class="form-control" name="title" value="<%=title%>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Salary</label>
                <input type="number" class="form-control" name="salary" value="<%=salary%>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Location</label>
                <input type="text" class="form-control" name="location" value="<%=location%>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Department</label>
                <select class="form-select" name="department" required>
                    <option value="IT" <%=department.equals("IT") ? "selected" : ""%>>IT</option>
                    <option value="Finance" <%=department.equals("Finance") ? "selected" : ""%>>Finance</option>
                    <option value="HR" <%=department.equals("HR") ? "selected" : ""%>>HR</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Type</label>
                <select class="form-select" name="type" required>
                    <option value="full-time" <%=type.equals("full-time") ? "selected" : ""%>>Full Time</option>
                    <option value="part-time" <%=type.equals("part-time") ? "selected" : ""%>>Part Time</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Last Date to Apply</label>
                <input type="date" class="form-control" name="lastDate" value="<%=lastDate%>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="description" rows="4" required><%=description%></textarea>
            </div>

            <% if (image != null && !image.isEmpty()) { %>
                <div class="mb-3">
                    <label class="form-label">Current Company Image:</label><br>
                    <img src="<%= "uploads/" + image %>"  alt="Company Image" style="max-width: 150px; max-height: 150px; border: 1px solid #ccc; padding: 5px;">
                </div>
            <% } %>

            <button type="submit" class="btn btn-primary">Update Job</button>
        </form>
        
        <a href="adminpanel.jsp" class="btn btn-success mt-3">Back</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
