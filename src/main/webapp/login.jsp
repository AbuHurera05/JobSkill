<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%	
String dbURL = "jdbc:mysql://localhost:3306/jobportal";
String dbUser = "root"; 
String dbPassword = "root"; 

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

String errorMessage="";
String email = request.getParameter("email");
String password = request.getParameter("password");
if (email != null && password != null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // User found -> Login Successful
            session.setAttribute("userId", rs.getInt("uId"));
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", rs.getString("name"));
            session.setAttribute("userDepartment", rs.getString("department"));
            response.sendRedirect("index.jsp");
        } else {
            // Invalid Credentials
        	errorMessage = "Invalid Email or Password!";
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('Database Error! Try Again.'); window.history.back();</script>");
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
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
    />
    <link href="css/login.css" rel="stylesheet">
    <title>Login Page</title>
  </head>
	
  <body>
    <div class="container" id="container">
      <div class="form-container sign-up">
        <form action="addSignup.jsp" method="post">
          <h1>Create Account</h1>
          <div class="social-icons">
            <a href="#" class="icon"
              ><i class="fa-brands fa-google-plus-g"></i
            ></a>
            <a href="#" class="icon"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="#" class="icon"><i class="fa-brands fa-github"></i></a>
            <a href="#" class="icon"
              ><i class="fa-brands fa-linkedin-in"></i
            ></a>
          </div>
          <span>use your email for registeration</span>
          <input type="text" name="name" placeholder="Name" required/>
          <input type="email" name="email" placeholder="Email" required />
          <input type="password" name="password" placeholder="Password" required />
         <!--   <select id="department" name="department" required>
        	<option value="">Select Department</option>
        	<option value="IT">IT</option>
        	<option value="Finance">Finance</option>
        	<option value="HR">HR</option>
    	</select>		-->
          <button type="submit">Signup</button>
        </form>
      </div>
      
      
      <div class="form-container sign-in">
        <form method="post" action="login.jsp">
          <h1>Sign In</h1>
          	<% if (errorMessage != null) { %>
  			<div style="color: red; margin-top: 10px;">
    		<%= errorMessage %>
  			</div>
			<% } %>
          
          <div class="social-icons">
            <a href="#" class="icon"
              ><i class="fa-brands fa-google-plus-g"></i
            ></a>
            <a href="#" class="icon"><i class="fa-brands fa-facebook-f"></i></a>
            <a href="#" class="icon"><i class="fa-brands fa-github"></i></a>
            <a href="#" class="icon"
              ><i class="fa-brands fa-linkedin-in"></i
            ></a>
          </div>
          <span>or use your email password</span>
          <input type="email" name="email" placeholder="Email" required />
          <input type="password" name="password" placeholder="Password" required />
          <a href="forgotPassword.jsp">Forget Your Password?</a>
          <button type="submit">Sign In</button>
        </form>
      </div>
      <div class="toggle-container">
        <div class="toggle">
          <div class="toggle-panel toggle-left">
            <h1>Welcome Back!</h1>
            <p>Enter your personal details to use all of site features</p>
            <button class="hidden" id="login">Sign In</button>
          </div>
          <div class="toggle-panel toggle-right">
            <h1>Hello, Friend!</h1>
            <p>
              Register with your personal details to use all of site features
            </p>
            <button class="hidden" id="register">Sign Up</button>
          </div>
        </div>
      </div>
    </div>

    <script src="./js/login.js"></script>


  </body>
</html>
