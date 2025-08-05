<%@ page import="java.sql.*" %>
<%@ page import="java.util.Random" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String email = request.getParameter("email");
    String otp = "";
    boolean emailExists = false;
    
    if (email != null && !email.isEmpty()) {
        String dbURL = "jdbc:mysql://localhost:3306/jobportal?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                emailExists = true;
                Random random = new Random();
                otp = String.format("%06d", random.nextInt(999999));
                session.setAttribute("resetOTP", otp);
                session.setAttribute("resetEmail", email);
                out.println("<script>alert('Your OTP is: " + otp + "'); window.location='verifyOTP.jsp';</script>");
            } else {
                out.println("<script>alert('Email not registered!'); window.history.back();</script>");
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error Occurred! Try again.'); window.history.back();</script>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <!-- Advanced CSS Styling -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: #fff;
            padding: 40px 60px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            max-width: 450px;
            width: 100%;
            text-align: center;
            transition: transform 0.3s ease-in-out;
        }

        h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        label {
            color: #555;
            font-size: 16px;
            margin-bottom: 10px;
            text-align: left;
            width: 100%;
        }

        input[type="email"] {
            padding: 12px;
            margin-bottom: 25px;
            width: 100%;
            border: 2px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease-in-out;
        }

        input[type="email"]:focus {
            border-color: #007BFF;
            box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
        }

        button {
            background-color: #007BFF;
            color: #fff;
            padding: 14px;
            font-size: 18px;
            width: 100%;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease-in-out;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Responsive Design */
        @media screen and (max-width: 600px) {
            .container {
                padding: 30px 40px;
            }

            h2 {
                font-size: 24px;
            }

            input[type="email"], button {
                font-size: 14px;
            }
        }

        /* Animation */
        .container {
            transform: translateY(-20px);
            animation: slideIn 0.5s ease-out forwards;
        }

        @keyframes slideIn {
            0% {
                transform: translateY(-20px);
            }
            100% {
                transform: translateY(0);
            }
        }

    </style>
</head>
<body>

<div class="container">
    <h2>Forgot Password</h2>
    <form action="forgotPassword.jsp" method="post">
        <label for="email">Enter your registered email:</label>
        <input type="email" id="email" name="email" required placeholder="Your email address" />
        <button type="submit">Get OTP</button>
    </form>
</div>

</body>
</html>
