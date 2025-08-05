package com.Servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig
public class UpdateCompanyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String companyName = request.getParameter("companyName");
        String headQuarter = request.getParameter("headQuarter");
        String branch = request.getParameter("branch");

        Part filePart = request.getPart("logo");
        String fileName = filePart.getSubmittedFileName();
        boolean hasNewLogo = fileName != null && !fileName.trim().isEmpty();

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        if (hasNewLogo) {
            InputStream fileContent = filePart.getInputStream();
            Files.copy(fileContent, new File(uploadPath + File.separator + fileName).toPath());
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            String sql;
            if (hasNewLogo) {
                sql = "UPDATE companies SET companyName=?, headQuarter=?, branch=?, logo=? WHERE comId=?";
            } else {
                sql = "UPDATE companies SET companyName=?, headQuarter=?, branch=? WHERE comId=?";
            }

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, companyName);
            ps.setString(2, headQuarter);
            ps.setString(3, branch);
            if (hasNewLogo) {
                ps.setString(4, fileName);
                ps.setInt(5, id);
            } else {
                ps.setInt(4, id);
            }

            ps.executeUpdate();
            ps.close();
            con.close();

            response.sendRedirect("adminpanel.jsp?message=Company+Updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
