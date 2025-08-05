package com.Servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@MultipartConfig
public class AddCompanyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String companyName = request.getParameter("companyName");
        String headQuarter = request.getParameter("headQuarter");
        String branch = request.getParameter("branch");

        Part filePart = request.getPart("logo");
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

        // Create folder if not exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // Save image to uploads folder
        String filePath = uploadPath + File.separator + fileName;
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, new File(filePath).toPath());
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            String sql = "INSERT INTO companies (companyName, headQuarter, branch, logo) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, companyName);
            ps.setString(2, headQuarter);
            ps.setString(3, branch);
            ps.setString(4, fileName);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("adminpanel.jsp?message=Company Added Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
