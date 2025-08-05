<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup Page</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">Signup</div>
                    <div class="card-body">
                        <form id="signupForm">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Signup</button>
                            <p id="message" class="mt-2"></p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById("signupForm").addEventListener("submit", function(event) {
            event.preventDefault();
            let email = document.getElementById("email").value;
            let password = document.getElementById("password").value;

            fetch("check_email.jsp?email=" + email)
                .then(response => response.text())
                .then(data => {
                    if (data.trim() === "exists") {
                        document.getElementById("message").innerHTML = "<span class='text-danger'>Email already exists.</span>";
                    } else {
                        fetch("signup.jsp", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: "email=" + email + "&password=" + password
                        })
                        .then(response => response.text())
                        .then(data => {
                            document.getElementById("message").innerHTML = "<span class='text-success'>Signup successful!</span>";
                        });
                    }
                });
        });
    </script>
</body>
</html>
