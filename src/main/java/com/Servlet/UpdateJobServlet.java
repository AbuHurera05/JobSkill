package com.Servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.sql.*;

@MultipartConfig
public class UpdateJobServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        int jobId = Integer.parseInt(request.getParameter("jobId"));
        String title = request.getParameter("title");
        String salary = request.getParameter("salary");
        String location = request.getParameter("location");
        String department = request.getParameter("department");
        String type = request.getParameter("type");
        String lastDate = request.getParameter("lastDate");
        String description = request.getParameter("description");
        int companyId = Integer.parseInt(request.getParameter("companyId"));

        String dbURL = "jdbc:mysql://localhost:3306/jobportal";
        String dbUser = "root";
        String dbPass = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Get company name and logo from companies table
            String companyName = "";
            String companyLogo = "";

            PreparedStatement companyStmt = conn.prepareStatement("SELECT companyName, logo FROM companies WHERE comId = ?");
            companyStmt.setInt(1, companyId);
            ResultSet rs = companyStmt.executeQuery();
            if (rs.next()) {
                companyName = rs.getString("companyName");
                companyLogo = rs.getString("logo");
            }
            rs.close();
            companyStmt.close();

            // Update job record
            String sql = "UPDATE jobs SET title=?, salary=?, location=?, department=?, company=?, job_category=?, lastDate=?, description=?, company_pic=? WHERE jobId=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, title);
            stmt.setString(2, salary);
            stmt.setString(3, location);
            stmt.setString(4, department);
            stmt.setString(5, companyName);
            stmt.setString(6, type);
            stmt.setString(7, lastDate);
            stmt.setString(8, description);
            stmt.setString(9, companyLogo);
            stmt.setInt(10, jobId);

            int rows = stmt.executeUpdate();
            stmt.close();
            conn.close();

            if (rows > 0) {
                out.println("<script>alert('✅ Job Updated Successfully!'); window.location.href='adminpanel.jsp';</script>");
            } else {
                out.println("<script>alert('❌ Job Update Failed!'); window.location.href='adminpanel.jsp';</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('⚠ Error: " + e.getMessage() + "'); window.location.href='adminpanel.jsp';</script>");
        }
    }
}
