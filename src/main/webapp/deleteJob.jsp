<%@page import="java.sql.*"%>
<%
    String jobId = request.getParameter("jobId");

    if (jobId != null && !jobId.trim().equals("")) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            String sql = "DELETE FROM jobs WHERE jobId = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(jobId));
            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<script>alert('Job deleted successfully!'); window.location='adminpanel.jsp';</script>");
            } else {
                out.println("<script>alert('Job not found.'); window.location='adminpanel.jsp';</script>");
            }

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location='adminpanel.jsp';</script>");
        } finally {
            try { if (ps != null) ps.close(); } catch(Exception e) {}
            try { if (con != null) con.close(); } catch(Exception e) {}
        }
    } else {
        out.println("<script>alert('Invalid Job ID.'); window.location='adminpanel.jsp';</script>");
    }
%>
