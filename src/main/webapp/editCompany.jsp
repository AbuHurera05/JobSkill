<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String companyName = "", headQuarter = "", branch = "", logo = "";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");
    PreparedStatement ps = con.prepareStatement("SELECT * FROM companies WHERE comId = ?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        companyName = rs.getString("companyName");
        headQuarter = rs.getString("headQuarter");
        branch = rs.getString("branch");
        logo = rs.getString("logo");
    }

    rs.close();
    ps.close();
    con.close();
%>

<h2>Edit Company</h2>
<form action="UpdateCompanyServlet" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="id" value="<%= id %>">
    
    <label>Company Name:</label>
    <input type="text" name="companyName" value="<%= companyName %>" required><br>

    <label>Head Quarter:</label>
    <input type="text" name="headQuarter" value="<%= headQuarter %>" required><br>

    <label>Branch:</label>
    <input type="text" name="branch" value="<%= branch %>" required><br>

    <label>Old Logo:</label>
    <img src="uploads/<%= logo %>" width="80"><br>

    <label>New Logo (optional):</label>
    <input type="file" name="logo" accept="image/*"><br><br>

    <button type="submit">Update</button>
</form>
