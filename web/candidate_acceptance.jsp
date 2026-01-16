<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%>
<%
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if(currentUser == null) { response.sendRedirect("index.jsp"); return; }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Acceptance Form</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* --- 1. THEME VARIABLES (Dark Modern) --- */
        :root {
            --bg-body: #0a0a0a;
            --bg-card: #141414;
            --border-color: #333;
            --text-main: #ffffff;
            --text-muted: #888888;
            --primary-accent: #ffffff;
            --input-bg: #0f0f0f;
            --btn-bg: #ffffff;
            --btn-text: #000000;
        }

        /* --- 2. GLOBAL RESET & BODY --- */
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
            /* Subtle radial gradient background */
            background-image: radial-gradient(circle at 50% 0%, #1a1a1a 0%, #0a0a0a 100%);
        }

        /* --- 3. CARD CONTAINER (Glassmorphism style) --- */
        .container {
            background: var(--bg-card);
            width: 100%;
            max-width: 500px;
            padding: 40px;
            border-radius: 24px;
            border: 1px solid var(--border-color);
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            animation: fadeIn 0.5s ease-out;
        }

        /* --- 4. TYPOGRAPHY --- */
        h2 {
            text-align: center;
            margin-bottom: 10px;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: -0.5px;
        }

        p.subtitle {
            text-align: center;
            color: var(--text-muted);
            margin-bottom: 30px;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* --- 5. FORM ELEMENTS --- */
        .form-group { margin-bottom: 20px; }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input[type="text"], textarea {
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
            resize: vertical;
        }

        input[type="text"]:focus, textarea:focus {
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

        /* --- 6. FILE UPLOAD STYLING --- */
        input[type="file"] { display: none; }

        .file-upload-label {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px;
            background: #222;
            color: var(--text-muted);
            border: 1px dashed var(--border-color);
            border-radius: 12px;
            cursor: pointer;
            transition: 0.3s;
            font-size: 0.9rem;
            margin-top: 5px;
        }

        .file-upload-label:hover {
            border-color: var(--primary-accent);
            color: white;
            background: #2a2a2a;
        }

        /* --- 7. BUTTONS --- */
        button[type="submit"] {
            width: 100%;
            padding: 14px;
            background: var(--btn-bg);
            color: var(--btn-text);
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
            display: block;
            text-align: center;
            margin-top: 20px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .cancel-link:hover { color: white; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <div class="container">
        <h2>Candidate Profile Form</h2>
        <p class="subtitle">Please complete your details to finalize your candidacy.</p>
        
        <form action="StudentSubmitProfileServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="studentId" value="<%= currentUser.getId() %>">
            <input type="hidden" name="faculty" value="<%= currentUser.getFaculty() %>">

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="candidateName" value="<%= currentUser.getName() %>" readonly>
            </div>

            <div class="form-group">
                <label>Election Manifesto / Slogan</label>
                <textarea name="manifesto" rows="4" placeholder="e.g. Innovation for the future..." required></textarea>
            </div>

            <div class="form-group">
                <label>Profile Photo</label>
                <label for="candidatePhoto" class="file-upload-label" id="fileLabel">
                    Tap to upload photo
                </label>
                <input type="file" id="candidatePhoto" name="candidatePhoto" accept="image/*" required onchange="updateFileName()">
            </div>

            <button type="submit">Submit Profile</button>
        </form>
        
        <a href="student_dashboard.jsp" class="cancel-link">Cancel</a>
    </div>

    <script>
        function updateFileName() {
            const input = document.getElementById('candidatePhoto');
            const label = document.getElementById('fileLabel');
            if (input.files && input.files.length > 0) {
                label.textContent = "Selected: " + input.files[0].name;
                label.style.color = "#fff";
                label.style.borderColor = "#fff";
            } else {
                label.textContent = "Tap to upload photo";
            }
        }
    </script>
</body>
</html>