<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String profilePic = "";
    String message = "";
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch user's name and profile pic
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

        PreparedStatement getUser = con.prepareStatement("SELECT name, profile_pic FROM users WHERE email = ?");
        getUser.setString(1, userEmail);
        ResultSet rs = getUser.executeQuery();
        if (rs.next()) {
            userName = rs.getString("name");
            profilePic = rs.getString("profile_pic");
        }
    } catch (Exception e) {
        message = "Error fetching user data: " + e.getMessage();
    }

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String review = request.getParameter("review");
        String visibility = request.getParameter("visibility");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO testimonials (user_name, review, visibility, profile_pic) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, userName);
            ps.setString(2, review);
            ps.setString(3, visibility);
            ps.setString(4, profilePic);
            ps.executeUpdate();

            message = "✅ Review submitted successfully!";
        } catch (Exception e) {
            message = "❌ Error saving review: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>SkillLink Website</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
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

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>

<body>
    <div class="container-xxl bg-white p-0">
        <!-- Spinner Start -->
        <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
            <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                <span class="sr-only">Loading...</span>
            </div>
        </div>
        <!-- Spinner End -->


        <!-- Navbar Start -->
        <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
            <a href="index.jsp" class="navbar-brand d-flex align-items-center text-center py-0 px-4 px-lg-5">
                <h1 class="m-0 text-primary">SkillLink</h1>
            </a>
            <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto p-4 p-lg-0">
                    <a href="index.jsp" class="nav-item nav-link">Home</a>
                    <a href="about.jsp" class="nav-item nav-link">About</a>
                    <a href="contact.jsp" class="nav-item nav-link">Contact</a>
                    <a href="testmonial.jsp" class="nav-item nav-link">Testimonial</a>
                    <% if (userEmail != null) { %>
                <!-- User Logged In - Show Profile & Logout -->
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                        <i class="fa fa-user"></i> <%= userName %>
                    </a>
                    <div class="dropdown-menu rounded-0 m-0">
                        <a href="profile.jsp?userId=<%= session.getAttribute("userId") %>" class="dropdown-item">
    					<i class="fa fa-user-circle"></i> Profile
							</a>
                        <a href="logout.jsp?type=user" class="dropdown-item"><i class="fa fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            <% } else { %>
                <!-- User Not Logged In - Show Login -->
                <a href="login.jsp" class="btn btn-primary rounded-0 py-4 px-lg-5 d-none d-lg-block">
                    Login <i class="fa fa-arrow-right ms-3"></i>
                </a>
            <% } %>
                </div>
                
            </div>
        </nav>
        <!-- Navbar End -->


        <!-- Header End -->
        <div class="container-xxl py-5 bg-dark page-header mb-5">
            <div class="container my-5 pt-5 pb-4">
                <h1 class="display-3 text-white mb-3 animated slideInDown">Testimonial</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb text-uppercase">
                        <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                       
                        <li class="breadcrumb-item text-white active" aria-current="page">Testimonial</li>
                    </ol>
                    
                </nav>
            </div>
        </div>
        <!-- Header End -->
		

<div class="container">
    <h2 class="mb-4">Submit Your Testimonial</h2>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <form method="post" class="bg-white p-4 rounded shadow-sm">
        <div class="mb-3">
            <label for="review" class="form-label">Your Review</label>
            <textarea class="form-control" name="review" id="review" rows="3" required></textarea>
        </div>
        <div class="mb-3">
            <label class="form-label">Visibility</label><br>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="visibility" id="public" value="public" checked>
                <label class="form-check-label" for="public">Public</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="visibility" id="private" value="private">
                <label class="form-check-label" for="private">Private</label>
            </div>
        </div>
        <button type="submit" class="btn btn-primary">Submit Review</button>
    </form>

    </div>
		
		<!-- Testimonial Start -->
<div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
    <div class="container">
        <h1 class="text-center mb-5">Our Clients Say!!!</h1>
        <div class="owl-carousel testimonial-carousel">
<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/jobportal", "root", "root");

        // Join using user_name
        String query = "SELECT t.review, t.user_name, u.profile_pic " +
                       "FROM testimonials t " +
                       "JOIN users u ON t.user_name = u.name " +
                       "WHERE t.visibility = 'public' " +
                       "ORDER BY t.testmonialId DESC";

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);

        while (rs.next()) {
            String name = rs.getString("user_name");
            String review = rs.getString("review");
            String imagePath = rs.getString("profile_pic");

            if (imagePath == null || imagePath.trim().equals("")) {
                imagePath = "img/testimonial-placeholder.jpg";
            }
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

        <!-- Testimonial Start -->
 <!--       <div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
            <div class="container">
                <h1 class="text-center mb-5">Our Clients Say!!!</h1>
                <div class="owl-carousel testimonial-carousel">
                    <div class="testimonial-item bg-light rounded p-4">
                        <i class="fa fa-quote-left fa-2x text-primary mb-3"></i>
                        <p>Dolor et eos labore, stet justo sed est sed. Diam sed sed dolor stet amet eirmod eos labore diam</p>
                        <div class="d-flex align-items-center">
                            <img class="img-fluid flex-shrink-0 rounded" src="img/testimonial-1.jpg" style="width: 50px; height: 50px;">
                            <div class="ps-3">
                                <h5 class="mb-1">Client Name</h5>
                                <small>Profession</small>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-item bg-light rounded p-4">
                        <i class="fa fa-quote-left fa-2x text-primary mb-3"></i>
                        <p>Dolor et eos labore, stet justo sed est sed. Diam sed sed dolor stet amet eirmod eos labore diam</p>
                        <div class="d-flex align-items-center">
                            <img class="img-fluid flex-shrink-0 rounded" src="img/testimonial-2.jpg" style="width: 50px; height: 50px;">
                            <div class="ps-3">
                                <h5 class="mb-1">Client Name</h5>
                                <small>Profession</small>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-item bg-light rounded p-4">
                        <i class="fa fa-quote-left fa-2x text-primary mb-3"></i>
                        <p>Dolor et eos labore, stet justo sed est sed. Diam sed sed dolor stet amet eirmod eos labore diam</p>
                        <div class="d-flex align-items-center">
                            <img class="img-fluid flex-shrink-0 rounded" src="img/testimonial-3.jpg" style="width: 50px; height: 50px;">
                            <div class="ps-3">
                                <h5 class="mb-1">Client Name</h5>
                                <small>Profession</small>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-item bg-light rounded p-4">
                        <i class="fa fa-quote-left fa-2x text-primary mb-3"></i>
                        <p>Dolor et eos labore, stet justo sed est sed. Diam sed sed dolor stet amet eirmod eos labore diam</p>
                        <div class="d-flex align-items-center">
                            <img class="img-fluid flex-shrink-0 rounded" src="img/testimonial-4.jpg" style="width: 50px; height: 50px;">
                            <div class="ps-3">
                                <h5 class="mb-1">Client Name</h5>
                                <small>Profession</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>		-->
        <!-- Testimonial End -->


        <!-- Footer Start -->
        <div class="container-fluid bg-dark text-white-50 footer pt-5 mt-5 wow fadeIn" data-wow-delay="0.1s">
            <div class="container py-5">
                <div class="row g-5">
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white mb-4">Company</h5>
                        <a class="btn btn-link text-white-50" href="about.jsp">About Us</a>
                        <a class="btn btn-link text-white-50" href="contact.jsp">Contact Us</a>
                        <a class="btn btn-link text-white-50" href="">Our Services</a>
                        <a class="btn btn-link text-white-50" href="">Privacy Policy</a>
                        <a class="btn btn-link text-white-50" href="">Terms & Condition</a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white mb-4">Quick Links</h5>
                        <a class="btn btn-link text-white-50" href="about.jsp">About Us</a>
                        <a class="btn btn-link text-white-50" href="contact.jsp">Contact Us</a>
                        <a class="btn btn-link text-white-50" href="">Our Services</a>
                        <a class="btn btn-link text-white-50" href="">Privacy Policy</a>
                        <a class="btn btn-link text-white-50" href="">Terms & Condition</a>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white mb-4">Contact</h5>
                        <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>Badin,Sindh</p>
                        <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+923326181426</p>
                        <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+923153726380</p>
                        <p class="mb-2"><i class="fa fa-envelope me-3"></i>skilllink360@gmail.com</p>
                        <div class="d-flex pt-2">
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-twitter"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-facebook-f"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-youtube"></i></a>
                            <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="text-white mb-4">Newsletter</h5>
                        <p>Dolor amet sit justo amet elitr clita ipsum elitr est.</p>
                        <div class="position-relative mx-auto" style="max-width: 400px;">
                            <input class="form-control bg-transparent w-100 py-3 ps-4 pe-5" type="text" placeholder="Your email">
                            <button type="button" class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">SignUp</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="copyright">
                    <div class="row">
                        <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                            &copy; <a class="border-bottom" href="#">JobLink</a>, All Right Reserved. 
							
							<!--/__________________________________________________________________________/-->
							Designed By <a class="border-bottom" href="">Code By Muslim Khuwaja</a>
                        </div>
                        <div class="col-md-6 text-center text-md-end">
                            <div class="footer-menu">
                                <a href="index.jsp">Home</a>
                                <a href="">Cookies</a>
                                <a href="">Help</a>
                                <a href="">FQAs</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer End -->


        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>
    </div>

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