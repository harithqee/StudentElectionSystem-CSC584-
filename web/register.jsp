<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Voting System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        header {
            text-align: center;
            margin-bottom: 30px;
            animation: fadeInDown 0.8s ease-out;
        }

        header h1 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        main {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 500px;
            animation: fadeInUp 0.8s ease-out;
        }

        h2 {
            color: #333;
            margin-bottom: 30px;
            font-size: 1.8rem;
            text-align: center;
        }

        fieldset {
            border: none;
            margin-bottom: 25px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 12px;
        }

        legend {
            color: #555;
            font-weight: 600;
            font-size: 1rem;
            margin-bottom: 15px;
            padding: 0 10px;
        }

        .role-option {
            display: flex;
            align-items: center;
            padding: 12px;
            margin: 8px 0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .role-option:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .role-option input[type="radio"] {
            width: 20px;
            height: 20px;
            margin-right: 12px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .role-option label {
            cursor: pointer;
            font-size: 1rem;
            color: #333;
            flex: 1;
        }

        .input-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #555;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 14px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }

        select {
            cursor: pointer;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .error-message {
            color: #dc3545;
            text-align: center;
            margin-bottom: 20px;
            padding: 12px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            font-size: 0.95rem;
            animation: fadeIn 0.3s ease;
        }

        button[type="submit"] {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        button[type="submit"]:active {
            transform: translateY(0);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }

        .login-link p {
            color: #666;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .login-link a {
            display: inline-block;
            padding: 14px 40px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            border: 2px solid #667eea;
            transition: all 0.3s ease;
        }

        .login-link a:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        footer {
            margin-top: 30px;
            text-align: center;
            color: white;
            font-size: 0.9rem;
            animation: fadeIn 1s ease-out 0.5s both;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @media (max-width: 500px) {
            header h1 {
                font-size: 2rem;
            }

            main {
                padding: 30px 25px;
            }

            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>

    <header>
        <h1>🗳️ Voting System Registration</h1>
    </header>

    <main>
        <h2>Create Account</h2>
        
        <%-- JSP error message display --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <form action="RegisterServlet" method="POST">
            <fieldset>
                <legend>Select Your Role</legend>
                <div class="role-option">
                    <input type="radio" id="role_student" name="user_role" value="student" required>
                    <label for="role_student">Student</label>
                </div>
                <div class="role-option">
                    <input type="radio" id="role_lecturer" name="user_role" value="lecturer">
                    <label for="role_lecturer">Lecturer</label>
                </div>
                <div class="role-option">
                    <input type="radio" id="role_admin" name="user_role" value="admin">
                    <label for="role_admin">Admin</label>
                </div>
            </fieldset>

            <div class="input-group">
                <label for="full_name">Full Name:</label>
                <input type="text" id="full_name" name="full_name" placeholder="Enter your full name" required>
            </div>

            <div class="input-group">
                <label for="user_id">Student/Staff ID:</label>
                <input type="text" id="user_id" name="user_id" placeholder="Enter your ID" required>
            </div>

            <div class="input-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="input-group">
                <label for="faculty">Faculty:</label>
                <select id="faculty" name="faculty" required>
                    <option value="">-- Select Faculty --</option>
                    <option value="FSKM">Computer Science (FSKM)</option>
                    <option value="ENG">Engineering</option>
                    <option value="BUS">Business</option>
                </select>
            </div>

            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Create a password" required>
            </div>

            <div class="input-group">
                <label for="confirm_password">Confirm Password:</label>
                <input type="password" id="confirm_password" name="confirm_password" placeholder="Confirm your password" required>
            </div>
            
            <button type="submit">Register</button>
        </form>

        <div class="login-link">
            <p>Already have an account?</p>
            <a href="index.jsp">Back to Login</a>
        </div>
    </main>

    <footer>
        <p>&copy; 2025 Voting System</p>
    </footer>

    <script>
        // Optional: Add client-side validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return false;
            }
            
            return true;
        });
        
        // Optional: Preselect radio button if there was an error
        <% if (request.getParameter("user_role") != null) { %>
            const previousRole = "<%= request.getParameter("user_role") %>";
            const roleRadio = document.querySelector('input[name="user_role"][value="' + previousRole + '"]');
            if (roleRadio) {
                roleRadio.checked = true;
            }
        <% } %>
    </script>

</body>
</html>