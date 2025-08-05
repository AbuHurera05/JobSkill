<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*,jakarta.servlet.*" %>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");
String errorMessage = "";

if (email != null && password != null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/jobportal?useSSL=false&serverTimezone=UTC", "root", "root"
        );

        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM admin WHERE email=? AND password=?");
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            session.setAttribute("adminId", rs.getInt("adminId"));
            session.setAttribute("adminName", rs.getString("name"));
            response.sendRedirect("adminpanel.jsp");
        } else {
            errorMessage = "Invalid admin credentials!";
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "Database Error!";
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
  <link href="css/login.css" rel="stylesheet">
  <title>Admin Login Page</title>
</head>
<body>
  <div class="container" id="container">
    
    
    <div class="form-container sign-in">
      <form method="post" action="adminLogin.jsp">
        <h1>Sign In</h1>
        <% if (!errorMessage.equals("")) { %>
  			<p style="color:red;"><%= errorMessage %></p>
		<% } %>
        

        <div class="social-icons">
          <a href="#" class="icon"><i class="fa-brands fa-google-plus-g"></i></a>
          <a href="#" class="icon"><i class="fa-brands fa-facebook-f"></i></a>
          <a href="#" class="icon"><i class="fa-brands fa-github"></i></a>
          <a href="#" class="icon"><i class="fa-brands fa-linkedin-in"></i></a>
        </div>
        <span>Or use your email and password</span>
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="password" placeholder="Password" required />
        
        <button type="submit">Sign In</button>
      </form>
    </div>

    <!-- Toggle Panel -->
    <div class="toggle-container">
      <div class="toggle">
        <div class="toggle-panel toggle-left">
          <h1>Welcome Back!</h1>
          <p>Enter your personal details to use all of site features</p>
          <button class="hidden" id="login">Sign In</button>
        </div>
        <div class="toggle-panel toggle-right">
          <h1>Hello, Friend!</h1>
          <p>Register with your personal details to use all of site features</p>
         
        </div>
      </div>
    </div>
  </div>


	
  <script src="./js/login.js"></script>
</body>
</html>
