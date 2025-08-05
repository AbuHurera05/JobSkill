<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page session="true" %>
<%
    String userEmail = (String) session.getAttribute("userEmail"); // Email سے چیک کر سکتے ہیں
    if (userEmail == null) {
        response.sendRedirect("login.jsp"); // اگر user login نہیں تو واپس بھیج دیں
        return;
    }

    // **Database Connection**
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

    // **Logged-in User ID**
    int userId = (int) session.getAttribute("userId");

    // **Retrieve updated data**
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");

    // Default values for profilePic and cvFile if no files are selected
    Part profilePicPart = request.getPart("profilePic");
    Part cvFilePart = request.getPart("cvFile");

    InputStream profilePicStream = (profilePicPart != null && profilePicPart.getSize() > 0) ? profilePicPart.getInputStream() : null;
    InputStream cvFileStream = (cvFilePart != null && cvFilePart.getSize() > 0) ? cvFilePart.getInputStream() : null;

    // **Random data insertion (for demo purposes)**
    if (profilePicStream == null) {
        // Use random placeholder if no picture is uploaded
        profilePicStream = new ByteArrayInputStream("randomImageData".getBytes());
    }
    if (cvFileStream == null) {
        // Use random data for CV if no file is uploaded
        cvFileStream = new ByteArrayInputStream("randomCVData".getBytes());
    }

    // **SQL Query for updating profile**
    String updateQuery = "UPDATE users SET name = ?, phone = ?, address = ?, profile_pic = ?, cv_file = ? WHERE uId = ?";
    PreparedStatement stmt = conn.prepareStatement(updateQuery);

    stmt.setString(1, name);
    stmt.setString(2, phone);
    stmt.setString(3, address);

    // Set the BLOB data for profile pic and CV (either actual data or random)
    stmt.setBlob(4, profilePicStream);
    stmt.setBlob(5, cvFileStream);

    stmt.setInt(6, userId);

    // Execute update
    int rowsUpdated = stmt.executeUpdate();
    if (rowsUpdated > 0) {
        out.println("<script>alert('Profile updated successfully!'); window.location='profile.jsp';</script>");
    } else {
        out.println("<script>alert('Error updating profile.');</script>");
    }
%>
