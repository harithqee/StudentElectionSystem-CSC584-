<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CampusVote</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Dark Theme Variables */
            --bg-body: #0a0a0a;
            --bg-card: #141414;
            --border-color: #333;
            --text-main: #ffffff;
            --text-muted: #888888;
            --primary-accent: #ffffff;
            --input-bg: #0f0f0f;
            
            --error-bg: rgba(231, 76, 60, 0.1);
            --error-border: rgba(231, 76, 60, 0.3);
            --error-text: #e74c3c;
            
            --success-bg: rgba(39, 174, 96, 0.1);
            --success-border: rgba(39, 174, 96, 0.3);
            --success-text: #27ae60;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-body); 
            color: var(--text-main);
            min-height: 100vh; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: center; 
            padding: 20px;
            /* Subtle dark gradient background */
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #0a0a0a 100%);
        }

        /* --- HEADER --- */
        header { 
            text-align: center; margin-bottom: 40px; 
            animation: fadeInDown 0.8s ease-out; 
        }
        header h1 { 
            color: var(--text-main); 
            font-size: 2.5rem; 
            font-weight: 700; 
            letter-spacing: -1px;
        }
        header span { color: var(--text-muted); font-weight: 400; }

        /* --- CARD --- */
        main { 
            background: var(--bg-card); 
            border: 1px solid var(--border-color);
            border-radius: 24px; 
            padding: 50px 40px; 
            box-shadow: 0 20px 50px rgba(0,0,0,0.5); 
            width: 100%; 
            max-width: 420px; 
            animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        h2 { 
            color: var(--text-main); 
            margin-bottom: 30px; 
            font-size: 1.5rem; 
            font-weight: 600; 
            text-align: center; 
            letter-spacing: -0.5px;
        }

        /* --- MESSAGES --- */
        .error-message { 
            color: var(--error-text); 
            background-color: var(--error-bg); 
            border: 1px solid var(--error-border); 
            padding: 12px; border-radius: 8px; 
            font-size: 0.9rem; text-align: center; margin-bottom: 20px;
            animation: fadeIn 0.3s ease;
        }
        .success-message { 
            color: var(--success-text); 
            background-color: var(--success-bg); 
            border: 1px solid var(--success-border); 
            padding: 12px; border-radius: 8px; 
            font-size: 0.9rem; text-align: center; margin-bottom: 20px;
            animation: fadeIn 0.3s ease;
        }

        /* --- FORM ELEMENTS --- */
        .input-group { margin-bottom: 25px; }
        
        label { 
            display: block; 
            color: var(--text-muted); 
            font-size: 0.85rem; 
            font-weight: 500; 
            margin-bottom: 8px; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        input[type="text"], input[type="password"] { 
            width: 100%; 
            padding: 14px 16px; 
            background: var(--input-bg);
            border: 1px solid var(--border-color); 
            border-radius: 12px; 
            font-size: 1rem; 
            color: white;
            transition: all 0.3s ease; 
            outline: none;
        }
        
        input[type="text"]:focus, input[type="password"]:focus { 
            border-color: var(--primary-accent); 
            background: var(--bg-card);
            box-shadow: 0 0 0 2px rgba(255,255,255,0.1);
        }

        button[type="submit"] { 
            width: 100%; 
            padding: 16px; 
            background: var(--primary-accent); 
            color: black; 
            border: none; 
            border-radius: 50px; 
            font-size: 1rem; 
            font-weight: 700; 
            cursor: pointer; 
            transition: all 0.3s ease; 
            margin-top: 10px; 
        }
        
        button[type="submit"]:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 10px 20px rgba(255, 255, 255, 0.15); 
            background: #e0e0e0;
        }
        
        button[type="submit"]:active { transform: translateY(0); }

        /* --- FOOTER LINKS --- */
        .register-link { 
            text-align: center; 
            margin-top: 30px; 
            padding-top: 20px; 
            border-top: 1px solid var(--border-color); 
        }
        
        .register-link p { 
            color: var(--text-muted); 
            font-size: 0.9rem; 
            margin-bottom: 15px; 
        }
        
        .register-link a { 
            display: inline-block; 
            color: var(--text-main); 
            text-decoration: none; 
            font-weight: 600; 
            font-size: 0.95rem;
            border-bottom: 1px solid transparent;
            transition: 0.3s;
        }
        
        .register-link a:hover { 
            border-bottom: 1px solid var(--text-main);
        }
        
        footer { 
            margin-top: 40px; 
            text-align: center; 
            color: var(--text-muted); 
            font-size: 0.8rem; 
            animation: fadeIn 1s ease-out 0.5s both; 
        }
        
        @keyframes fadeInDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    </style>
</head>
<body>

    <header>
        <h1>Campus<span>Vote</span></h1>
    </header>

    <main>
        <h2>Sign In</h2>
        
        <%-- Error Message --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <%-- Success Message --%>
        <% if (request.getParameter("msg") != null) { %>
            <div class="success-message">
                <%= request.getParameter("msg") %>
            </div>
        <% } %>

        <form action="LoginServlet" method="POST">
            <div class="input-group">
                <label for="username">User ID</label>
                <input type="text" id="username" name="username" placeholder="e.g. 2024001" required>
            </div>
            
            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            
            <button type="submit">Access Portal</button>
        </form>

        <div class="register-link">
            <p>New to the platform?</p>
            <a href="register.jsp">Create an Account</a>
        </div>
    </main>

    <footer>
        <p>&copy; 2025 Voting System. Secure & Modern.</p>
    </footer>

    <script>
        // Auto-fill username if returned from server
        <% if (request.getParameter("username") != null) { %>
            document.getElementById('username').value = "<%= request.getParameter("username") %>";
        <% } %>
        
        // Simple client-side validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            if (!username || !password) {
                e.preventDefault();
                alert('Please fill in all fields.');
                return false;
            }
            return true;
        });
    </script>

</body>
</html>