package com.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;

public class SendOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userEmail = request.getParameter("email");
        HttpSession session = request.getSession();
        
        // Generate Random OTP
        Random rand = new Random();
        int otp = 100000 + rand.nextInt(900000);
        
        // Save OTP in Session
        session.setAttribute("otp", otp);
        session.setAttribute("email", userEmail);

        // Email Configuration
        final String senderEmail = "abujunejo82@gmail.com"; // Change this
        final String senderPassword = "vflwnnzcbjvjlsdwq"; // Change this

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.socketFactory.port", "587");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");


        Session mailSession = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
            message.setSubject("Your OTP for Signup");
            message.setText("Your OTP Code is: " + otp);

            Transport.send(message);
            response.sendRedirect("verifyOTP.jsp"); // Redirect to OTP Verification Page
        } catch (MessagingException e) {
            e.printStackTrace();
          
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
