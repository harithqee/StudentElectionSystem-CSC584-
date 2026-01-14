<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%>
<%
    // 1. Fetch Student Data
    UserBean s = (UserBean) request.getAttribute("student");
    if(s == null) { 
        response.sendRedirect("admin_dashboard.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student - Admin Panel</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-body: #0a0a0a;
            --bg-card: #141414;
            --border-color: #333;
            --text-main: #ffffff;
            --text-muted: #888888;
            --primary-accent: #ffffff;
            --input-bg: #0f0f0f;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #0a0a0a 100%);
        }

        .edit-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 450px;
            animation: fadeIn 0.5s ease-out;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .input-group { margin-bottom: 20px; }

        label {
            display: block;
            color: var(--text-muted);
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 12px 16px;
            background: var(--input-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 1rem;
            color: white;
            outline: none;
            transition: 0.3s;
            font-family: 'Inter', sans-serif;
        }

        input:focus {
            border-color: var(--primary-accent);
            background: var(--bg-card);
            box-shadow: 0 0 0 2px rgba(255,255,255,0.1);
        }

        /* Read-only styling */
        input[readonly] {
            opacity: 0.6;
            cursor: not-allowed;
            background: #1a1a1a;
        }

        button[type="submit"] {
            width: 100%;
            padding: 14px;
            background: var(--primary-accent);
            color: black;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        button:hover {
            transform: translateY(-2px);
            background: #e0e0e0;
            box-shadow: 0 5px 15px rgba(255,255,255,0.1);
        }

        .cancel-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border-color);
        }

        .cancel-link a {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .cancel-link a:hover { color: white; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <main class="edit-card">
        <h2>Edit Student Details</h2>

        <form action="EditStudentServlet" method="POST">
            
            <div class="input-group">
                <label>Student ID (Read-only)</label>
                <input type="text" name="studentId" value="<%= s.getId() %>" readonly>
            </div>

            <div class="input-group">
                <label>Full Name</label>
                <input type="text" name="name" value="<%= s.getName() %>" required>
            </div>

            <div class="input-group">
                <label>Faculty</label>
                <input type="text" name="faculty" value="<%= s.getFaculty() %>" required>
            </div>

            <div class="input-group">
                <label>Email Address</label>
                <input type="email" name="email" value="<%= s.getEmail() %>" required>
            </div>

            <button type="submit">Save Updates</button>
        </form>

        <div class="cancel-link">
            <a href="admin_dashboard.jsp">Cancel & Return</a>
        </div>
    </main>

</body>
</html>