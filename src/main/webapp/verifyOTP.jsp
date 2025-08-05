<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP</title>
    
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
            background: #f2f2f2;
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
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
            transition: transform 0.3s ease-in-out;
        }

        h2 {
            color: #333;
            font-size: 26px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            color: #555;
            font-size: 16px;
            margin-bottom: 8px;
            text-align: left;
        }

        input[type="text"] {
            padding: 12px;
            margin-bottom: 20px;
            border: 2px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease-in-out;
        }

        input[type="text"]:focus {
            border-color: #007BFF;
            box-shadow: 0 0 10px rgba(0, 123, 255, 0.3);
        }

        button {
            background-color: #007BFF;
            color: #fff;
            padding: 12px;
            font-size: 18px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease-in-out;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* For responsive design */
        @media screen and (max-width: 600px) {
            .container {
                padding: 30px 40px;
            }

            h2 {
                font-size: 22px;
            }

            input[type="text"], button {
                font-size: 14px;
            }
        }

        /* Smooth animation when form loads */
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
    <h2>Verify OTP</h2>
    <form action="verifyOTP.jsp" method="post">
        <label for="otp">Enter OTP:</label>
        <input type="text" id="otp" name="otp" required placeholder="Enter your OTP" maxlength="6" />
        <button type="submit">Verify OTP</button>
    </form>
</div>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String enteredOTP = request.getParameter("otp");
        String sessionOTP = (String) session.getAttribute("resetOTP");
        String resetEmail = (String) session.getAttribute("resetEmail");

        if (enteredOTP != null && sessionOTP != null && enteredOTP.equals(sessionOTP)) {
            // OTP correct, redirect to reset password page
            response.sendRedirect("resetPassword.jsp");
        } else {
            // OTP incorrect
            out.println("<script>alert('Invalid OTP! Please try again.'); window.history.back();</script>");
        }
    }
%>

</body>
</html>
