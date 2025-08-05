<%@ page import="java.sql.*" %>
 <%
if (session.getAttribute("adminId") == null) {
    response.sendRedirect("adminLogin.jsp");
}
%>
 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
     <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Inter:wght@700;800&display=swap" rel="stylesheet">
    
    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/adminpanel.css" rel="stylesheet">
     <link href="css/style.css" rel="stylesheet">
    <style>
    	body {
    		margin: 0;
    		font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
   	 		background: #f4f6f9;
    		height: 100vh;
    		overflow-y: auto;
			}

		.welcome-banner {
    		background: linear-gradient(135deg, #6a11cb, #2575fc);
    		color: white;
    		padding: 40px;
    		text-align: center;
    		border-radius: 8px;
    		margin-bottom: 30px;
    		box-shadow: 0 4px 8px rgba(0,0,0,0.1);
		}

		.welcome-banner h1 {
    		margin: 0;
    		font-size: 36px;
    		font-weight: bold;
		}

		.welcome-banner h1 span {
    		color: #ffd700;
		}

		.welcome-banner p {
    		font-size: 18px;
    		margin-top: 10px;
    		font-weight: 300;
		}
    	
        /* CSS for Buttons */
        .job-actions {
            display: flex;
            gap: 10px;
        }
        .edit-btn, .delete-btn {
            padding: 8px 15px;
            font-size: 14px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .edit-btn {
            background-color: #4CAF50;
            color: white;
        }
        .edit-btn:hover {
            background-color: #45a049;
        }
        .delete-btn {
            background-color: #f44336;
            color: white;
        }
        .delete-btn:hover {
            background-color: #e53935;
        }
        

       
    </style>
</head>
<body>

    <div class="sidebar">
        <h2 style="color:#3489eb" >Admin Panel</h2>
        <button onclick="showSection('addJob')">Add Job</button>
        <button onclick="showSection('viewJobs')">View Jobs</button>
        <button onclick="showSection('viewApplied')">View Applied</button>
        <button onclick="showSection('addDepartment')">Add Department</button>
        <button onclick="showSection('addCompany')">Add Company</button>
        <button onclick="showSection('showCompany')">Show Companies</button>
        
     <!--   <button onclick="showSection('viewReviews')">View Reviews</button>`-->
        
        <a href="logout.jsp?type=admin"><button>Logout</button></a>

    </div>

    <div class="content">
    		
    <!--  		<marquee class="welcome-banner " behavior="scroll" direction="left" scrollamount="10" style="background:#6a11cb; color:white; font-size:20px; padding:10px;">
  			
        
  			<h1>👋 Welcome to the <span>Admin Panel</span></h1>
  			<p>Manage jobs, update listings, and stay in control.</p>
				
			</marquee>	-->
<div class="container-xxl bg-white p-0">
	<!-- Testimonial Start -->
<div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
    <div class="container">
        <div class="owl-carousel testimonial-carousel">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

        // Join using user_name
        String query = "SELECT t.review, t.user_name " +
               "FROM testimonials t " +
               "WHERE t.visibility = 'public' " +
               "ORDER BY t.testmonialId DESC";


        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);

        while (rs.next()) {
            String name = rs.getString("user_name");
            String review = rs.getString("review");
           

            
%>
            <div class="testimonial-item bg-light rounded p-4">
                <i class="fa fa-quote-left fa-2x text-primary mb-3"></i>
                <p><%= review %></p>
                <div class="d-flex align-items-center">
                    
                    <div class="ps-3">
                        <h5 class="mb-1"><%= name %></h5>
                        <small>Client</small>
                    </div>
                </div>
            </div>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
        </div>
    </div>
</div>
<!-- Testimonial End -->
</div>		

		
        <!-- Add Job Form -->
       <!-- Add Job Form -->
<div id="addJobSection" class="section">
    <h2>Add Job</h2>

    <form action="AddJobServlet" method="POST" enctype="multipart/form-data">
        <label for="title">Job Title:</label>
        <input type="text" id="title" name="title" required>

        <label for="salary">Salary:</label>
        <input type="number" id="salary" name="salary" required>

        <label for="location">Job Location:</label>
        <input type="text" id="location" name="location" required>

        <%@ page import="java.sql.*" %>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

                // Department Dropdown
                stmt = conn.prepareStatement("SELECT * FROM departments");
                rs = stmt.executeQuery();
        %>

        <label for="department">Job Type:</label>
        <select id="department" name="department" class="form-select" required>
            <option value="">Select Department</option>
            <%
                while (rs.next()) {
                    int depId = rs.getInt("depId");
                    String depName = rs.getString("name");
            %>
                <option value="<%= depName %>"><%= depName %></option>
            <%
                }
                rs.close();
                stmt.close();
            %>
        </select>

        <%
            // Company Dropdown
            stmt = conn.prepareStatement("SELECT comId, companyName FROM companies");
            rs = stmt.executeQuery();
        %>
        <label for="company">Company Name:</label>
        <select id="company" name="companyId" required>
            <option value="">Select Company</option>
            <%
                while (rs.next()) {
                    int compId = rs.getInt("comId");
                    String compName = rs.getString("companyName");
            %>
                <option value="<%= compId %>"><%= compName %></option>
            <%
                }
               
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        </select>

        <label for="type">Full/Part Time:</label>
        <select id="type" name="type" required>
            <option value="">Select</option>
            <option value="full-time">Full Time</option>
            <option value="part-time">Part Time</option>
        </select>

        <label for="lastDate">Last Date to Apply:</label>
        <input type="date" id="lastDate" name="lastDate" required>

        <label for="description">Description:</label>
        <textarea id="description" name="description" required></textarea>

        <button type="submit">Submit</button>
    </form>
</div>

        <!-- View Jobs Section -->     

<div id="viewJobsSection" class="section">
    <h2>Posted Jobs</h2>
    <table border="1">
        <tr>
            <th>Job Title</th>
            <th>Description</th>
            <th>Salary</th>
            <th>Location</th>
            <th>Action</th>
        </tr>

        <%
            // Database Connection Details
            String dbURL = "jdbc:mysql://localhost:3306/jobportal";
            String dbUser = "root";
            String dbPass = "root";

            try {
                

                // Fetch jobs from database
                String sql = "SELECT jobId,title, description, salary,location FROM jobs";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                	int jobId = rs.getInt("jobId");
        %>
                    <tr>
                        <td><%= rs.getString("title") %></td>
                        <td><%= rs.getString("description") %></td>
                        <td><%= rs.getString("salary") %></td>
                        <td><%= rs.getString("location") %></td>
                        <td>
                        <div class="job-actions">
                                <a class="edit-btn" href="editJob.jsp?jobId=<%=jobId  %>">Edit</a>
                                <a class="delete-btn" href="deleteJob.jsp?jobId=<%=jobId  %>" onclick="return confirm('Are you sure you want to delete this job?')">Delete</a>

                            </div>
                        </td>
                    </tr>
        <%
                }

                
            } catch (Exception e) {
                out.println("<tr><td colspan='3'>⚠ Error: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            }
        %>
    </table>
	</div>
		<!-- View Applied Section -->
<div id="viewAppliedSection" class="section" style="display:none;">
    <h2>Applied Users</h2>
    <table border="1">
        <tr>
            <th>User Name</th>
            <th>Email</th>
            <th>Applied Job Title</th>
            <th>Company</th>
            <th>CV File</th> <!-- ✅ New Column -->
            <th>Status</th>
        </tr>
<%
    try {
        String sql = "SELECT u.name, u.email, u.cv_file, j.title, j.company, u.status " +
                     "FROM applications a " +
                     "JOIN users u ON a.userEmail = u.email " +
                     "JOIN jobs j ON a.jobId = j.jobId " +
                     "WHERE u.status = 'applied'";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            String cvFile = rs.getString("cv_file");
%>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getString("company") %></td>
            <td>
                <% if (cvFile != null && !cvFile.isEmpty()) { %>
                    <a style="text-decoration: none;" href="uploads/<%= cvFile %>" target="_blank">View CV</a>
                <% } else { %>
                    No CV
                <% } %>
            </td>
            <td style="color: green;"><%= rs.getString("status") %></td>
        </tr>
<%
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<tr><td colspan='6'>⚠ Error: " + e.getMessage() + "</td></tr>");
    }
%>
    </table>
</div>
<!-- Add Department Section -->
<div id="addDepartmentSection" class="section" style="display:none;">
    <h2>Add Department</h2>
    <form action="addDepartment.jsp" method="post" class="department-form">
        <label for="depName">Department Name:</label>
        <input type="text" id="depName" name="depName" required placeholder="Enter department name">

        <button type="submit">Add Department</button>
    </form>
</div>
<!-- Add Company Section -->
<div id="addCompanySection" class="section" style="display:none;">
    <h2>Add Company</h2>
    <form action="AddCompanyServlet" method="POST" enctype="multipart/form-data">
        <label for="companyName">Company Name:</label>
        <input type="text" id="companyName" name="companyName" required>
        
        <label for="headQuarter">Head Quarter:</label>
        <input type="text" id="branch" name="headQuarter" required>

        <label for="branch">Branch:</label>
        <input type="text" id="branch" name="branch" required>

        <label for="logo">Upload Company Logo:</label>
        <input type="file" id="logo" name="logo" accept="image/*" required>

        <button type="submit">Submit</button>
    </form>
</div>

<!-- 		Show Companies     -->
<div id="showCompanySection" class="section" style="display:none;">
    <h2>Company List</h2>
    <table border="1">
        <tr>
            <th>Logo</th>
            <th>Company Name</th>
            <th>Head Quarter</th>
            <th>Branch</th>
            <th>Action</th>
        </tr>
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");
        String sql = "SELECT * FROM companies";
        PreparedStatement ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        while (rs.next()) {
        	int id = rs.getInt("comId");
            String name = rs.getString("companyName");
            String headQuarter=rs.getString("headQuarter");
            String branch = rs.getString("branch");
            String logo = rs.getString("logo");
%>
        <tr>
            <td><img src="uploads/<%= logo %>" width="80" height="80" style="border-radius: 5px;"></td>
            <td><%= name %></td>
            <td><%= headQuarter %></td>
            <td><%= branch %></td>
            <td>
            <form action="editCompany.jsp" method="POST" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>">
                <button type="submit">Edit</button>
            </form>
            <form action="DeleteCompanyServlet" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this company?');">
                <input type="hidden" name="id" value="<%= id %>">
                <button class="delete-btn" type="submit">Delete</button>
            </form>
        </td>
        </tr>
<%
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<tr><td colspan='3'>⚠ Error: " + e.getMessage() + "</td></tr>");
    }
%>
    </table>
</div>

		
 </div>
 

    <script src="js/adminpanel.js"></script>
    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="lib/wow/wow.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="js/main.js"></script>
    

</body>
</html>
