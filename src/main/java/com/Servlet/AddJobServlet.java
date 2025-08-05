package com.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.sql.*;

@MultipartConfig
public class AddJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // DB Info
        String dbURL = "jdbc:mysql://localhost:3306/jobportal";
        String dbUser = "root";
        String dbPass = "root";

        // Form Data
        String title = request.getParameter("title");
        String salary = request.getParameter("salary");
        String location = request.getParameter("location");
        String department = request.getParameter("department");
        String type = request.getParameter("type");
        String lastDate = request.getParameter("lastDate");
        String description = request.getParameter("description");

        int companyId = Integer.parseInt(request.getParameter("companyId"));
        String companyName = "";
        String companyLogo = "";

        try {
            // DB Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Fetch company info
            String query = "SELECT companyName, logo FROM companies WHERE comId = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setInt(1, companyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                companyName = rs.getString("companyName");
                companyLogo = rs.getString("logo");
            }
            rs.close();
            ps.close();

            // Insert job
            String sql = "INSERT INTO jobs (title, salary, location, department, company, job_category, lastDate, company_pic, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, salary);
            stmt.setString(3, location);
            stmt.setString(4, department);
            stmt.setString(5, companyName);
            stmt.setString(6, type);
            stmt.setString(7, lastDate);
            stmt.setString(8, companyLogo);  // From companies table
            stmt.setString(9, description);

            int inserted = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (inserted > 0) {
                out.println("<script>alert('✅ Job Added Successfully!'); window.location.href='adminpanel.jsp#viewJobsSection';</script>");
            } else {
                out.println("<script>alert('❌ Failed to Add Job!'); window.location.href='adminpanel.jsp#viewJobsSection';</script>");
            }

        } catch (Exception e) {
            out.println("<script>alert('⚠ Error: " + e.getMessage() + "'); window.location.href='adminpanel.jsp#viewJobsSection';</script>");
            e.printStackTrace();
        }
    }
}
