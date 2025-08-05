<%@ page import="java.sql.*, java.util.Base64" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail"); // Email     
    if (userEmail == null) {
        response.sendRedirect("login.jsp"); 
        return;
    }

    // **Database Connection**
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

    // **Logged-in User ID**
    int userId = (int) session.getAttribute("userId");

    // **User Details Retrieve **
    String name = "", email = "", department = "", phone = "", address = "", profilePic = "default.jpg", cvFile = "";
    String query = "SELECT name, email, department, phone, address, profile_pic, cv_file FROM users WHERE uId = ?";
    PreparedStatement stmt = conn.prepareStatement(query);
    stmt.setInt(1, userId);
    ResultSet rs = stmt.executeQuery();

    if (rs.next()) {
        name = rs.getString("name");
        email = rs.getString("email");
        department = rs.getString("department");
        phone = rs.getString("phone");
        address = rs.getString("address");
        profilePic = (rs.getString("profile_pic") != null) ? rs.getString("profile_pic") : "default.jpg";
        cvFile = (rs.getString("cv_file") != null) ? rs.getString("cv_file") : "";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JobLink Website</title>
    <!-- Bootstrap & Google Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f8f9fa; }
        .container { max-width: 600px; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); margin-top: 50px; }
        .profile-pic { display: flex; flex-direction: column; align-items: center; margin-bottom: 20px; }
        .profile-pic img { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; box-shadow: 0 0 8px rgba(0,0,0,0.2); }
        .custom-file-label { cursor: pointer; color: #007bff; font-weight: 500; text-decoration: underline; }
        button { background: linear-gradient(45deg, #007bff, #00bfff); color: white; transition: 0.3s; }
        button:hover { background: linear-gradient(45deg, #0056b3, #0099cc); }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center mb-4">Edit Profile</h2>

    

    <!-- Profile Update Form -->
    <form action="ProfileUpdateServlet" method="POST" enctype="multipart/form-data">
    	<div class="profile-pic">
    
    <label class="custom-file-label mt-2">
        <input type="file" name="profilePic" id="profilePic" class="d-none" accept="image/*">
        Change Profile Picture
    </label>
</div>
        <div class="mb-3">
            <label class="form-label">Name:</label>
            <input type="text" class="form-control" name="name" value="<%= name %>" readonly>
        </div>

        <div class="mb-3">
            <label class="form-label">Email:</label>
            <input type="email" class="form-control" name="email" value="<%= email %>" readonly>
        </div>
        
        <%
    // All departments fetch 
    Statement deptStmt = conn.createStatement();
    ResultSet allDepartments = deptStmt.executeQuery("SELECT * FROM departments");

    // User  already selected departments
    PreparedStatement userDeptStmt = conn.prepareStatement("SELECT department_id FROM user_departments WHERE user_id = ?");
    userDeptStmt.setInt(1, userId);
    ResultSet userDepts = userDeptStmt.executeQuery();
    
    // Store selected department IDs
    java.util.List<Integer> selectedDeptIds = new java.util.ArrayList<>();
    while (userDepts.next()) {
        selectedDeptIds.add(userDepts.getInt("department_id"));
    }
%>

      <div class="mb-3">
    <label class="form-label">Departments:</label><br>
    <% while (allDepartments.next()) {
        int deptId = allDepartments.getInt("depId");
        String deptName = allDepartments.getString("name");
        boolean checked = selectedDeptIds.contains(deptId);
    %>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" name="departments" value="<%= deptId %>" <%= checked ? "checked" : "" %>>
            <label class="form-check-label"><%= deptName %></label>
        </div>
        	
    <% } %>
  <!--     <div class="form-check form-check-inline">
    <input class="form-check-input" type="checkbox" name="departments" value="other" id="otherCheckbox">
    <label class="form-check-label" for="otherCheckbox">Other</label>		-->
	</div>  
	
     <label class="form-label">Add Custom Department:</label>
    <input type="text" class="form-control" name="customDepartment" placeholder="Enter department name">

        <div class="mb-3">
            <label class="form-label">Phone:</label>
            <input type="text" class="form-control" name="phone" value="<%= phone %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Address:</label>
            <input type="text" class="form-control" name="address" value="<%= address %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Upload CV:</label>
            <input type="file" class="form-control" name="cvFile" accept=".pdf,.doc,.docx">
            <% if (!cvFile.isEmpty()) { %>
                <p class="mt-2">Current CV: <a href="uploads/<%= cvFile %>" target="_blank" class="text-primary">Download</a></p>
            <% } %>
        </div>

        <button type="submit" class="btn btn-success w-100 mt-3">Update Profile</button>
        
    </form>
    <a href="index.jsp"><button  class="btn btn-primary w-100 mt-3">Back</button></a>
</div>

<script>
    // Profile picture preview script
    document.getElementById("profilePic").addEventListener("change", function(event) {
        var reader = new FileReader();
        reader.onload = function() {
            document.getElementById("profilePreview").src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
