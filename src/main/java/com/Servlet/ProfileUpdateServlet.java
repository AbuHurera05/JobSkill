package com.Servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@MultipartConfig
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String[] selectedDepartments = request.getParameterValues("departments");
        String customDepartment= request.getParameter("customDepartment");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            // ========================= Upload Profile Picture =========================
            Part profilePicPart = request.getPart("profilePic");
            String profilePicFileName = null;

            if (profilePicPart != null && profilePicPart.getSize() > 0) {
                profilePicFileName = System.currentTimeMillis() + "_" + profilePicPart.getSubmittedFileName();
                String uploadDirPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadDirPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String uploadPath = uploadDirPath + File.separator + profilePicFileName;
                try (InputStream inputStream = profilePicPart.getInputStream();
                     FileOutputStream outputStream = new FileOutputStream(uploadPath)) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }
            }

            // ========================= Upload CV File =========================
            Part cvPart = request.getPart("cvFile");
            String cvFileName = null;

            if (cvPart != null && cvPart.getSize() > 0) {
                cvFileName = System.currentTimeMillis() + "_" + cvPart.getSubmittedFileName();
                String uploadDirPath = getServletContext().getRealPath("/uploads");
                String uploadPath = uploadDirPath + File.separator + cvFileName;

                try (InputStream inputStream = cvPart.getInputStream();
                     FileOutputStream outputStream = new FileOutputStream(uploadPath)) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }
            }

            // ========================= Update users Table =========================
            String updateUser = "UPDATE users SET phone = ?, address = ?" +
                    (profilePicFileName != null ? ", profile_pic = ?" : "") +
                    (cvFileName != null ? ", cv_file = ?" : "") +
                    " WHERE uId = ?";
            stmt = conn.prepareStatement(updateUser);

            int paramIndex = 1;
            stmt.setString(paramIndex++, phone);
            stmt.setString(paramIndex++, address);
            if (profilePicFileName != null) stmt.setString(paramIndex++, profilePicFileName);
            if (cvFileName != null) stmt.setString(paramIndex++, cvFileName);
            stmt.setInt(paramIndex, userId);
            stmt.executeUpdate();
            stmt.close();

            // ========================= Delete old departments =========================
            stmt = conn.prepareStatement("DELETE FROM user_departments WHERE user_id = ?");
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            stmt.close();

            // ========================= Insert new departments =========================
            if (selectedDepartments != null) {
                stmt = conn.prepareStatement("INSERT INTO user_departments (user_id, department_id) VALUES (?, ?)");
                for (String depIdStr : selectedDepartments) {
                    try {
                        int depId = Integer.parseInt(depIdStr);
                        stmt.setInt(1, userId);
                        stmt.setInt(2, depId);
                        stmt.addBatch();
                    } catch (NumberFormatException e) {
                        e.printStackTrace(); // Invalid department ID, skip
                    }
                }
                stmt.executeBatch();
                stmt.close();
            }
         // ========================= Handle custom department =========================
            if (customDepartment != null && !customDepartment.trim().isEmpty()) {
                // Check if department already exists (optional, or just insert blindly)
                String insertDep = "INSERT INTO departments (name) VALUES (?)";
                stmt = conn.prepareStatement(insertDep, Statement.RETURN_GENERATED_KEYS);
                stmt.setString(1, customDepartment.trim());
                stmt.executeUpdate();

                // Get generated department ID
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int customDepId = generatedKeys.getInt(1);

                    // Now insert into user_departments
                    PreparedStatement userDepStmt = conn.prepareStatement(
                        "INSERT INTO user_departments (user_id, department_id) VALUES (?, ?)");
                    userDepStmt.setInt(1, userId);
                    userDepStmt.setInt(2, customDepId);
                    userDepStmt.executeUpdate();
                    userDepStmt.close();
                }
                stmt.close();
            }

            out.println("<script>alert('✅ Profile updated successfully!'); window.location.href='profile.jsp';</script>");

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('⚠ Error occurred while updating profile.'); window.location.href='profile.jsp';</script>");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
