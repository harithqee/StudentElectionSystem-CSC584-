<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%>

<%
    // --- SECURITY PROTOCOL ---
    // 1. Retrieve current user
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");

    // 2. Strict Role Check: Only 'admin' can see this page.
    if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Candidate - Admin Portal</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            min-height: 100vh; 
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px; 
        }

        .container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 600px;
            animation: fadeInUp 0.8s ease-out;
        }

        h2 { 
            color: #333; 
            margin-bottom: 10px; 
            font-size: 1.8rem; 
            text-align: center;
        }

        p.subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            color: #555;
            font-weight: 600;
            margin-bottom: 8px;
        }

        input[type="text"], 
        textarea,
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        input[type="text"]:focus, 
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            background: #fafafa;
        }

        /* File Upload Styling */
        .file-upload-wrapper {
            position: relative;
            width: 100%;
            height: 50px;
            border: 2px dashed #667eea;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            background: #f8f9fa;
            transition: all 0.3s;
        }

        .file-upload-wrapper:hover {
            background: #eef2ff;
        }

        input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }

        .file-label {
            color: #667eea;
            font-weight: 600;
        }

        button {
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

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #666;
            text-decoration: none;
            font-weight: 500;
        }

        .back-link:hover {
            color: #333;
            text-decoration: underline;
        }

        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <div class="container">
        <h2>Appoint Candidate</h2>
        <p class="subtitle">Enter the details of the student to promote to candidacy.</p>

        <form action="AddCandidateServlet" method="POST" enctype="multipart/form-data">
            
            <div class="form-group">
                <label for="studentId">Student ID</label>
                <input type="text" id="studentId" name="studentId" placeholder="e.g. 2024123456" required>
                <small style="color: #888; font-size: 0.8rem;">Must match an existing registered student.</small>
            </div>

            <div class="form-group">
                <label for="candidateName">Candidate Name</label>
                <input type="text" id="candidateName" name="candidateName" placeholder="Full Name" required>
            </div>

            <div class="form-group">
                <label for="faculty">Faculty</label>
                <select id="faculty" name="faculty" required>
                    <option value="">-- Select Faculty --</option>
                    <option value="FSKM">Comp. Sci & Math (FSKM)</option>
                    <option value="ENG">Engineering</option>
                    <option value="BUS">Business</option>
                    <option value="ART">Art & Design</option>
                </select>
            </div>

            <div class="form-group">
                <label for="manifesto">Election Manifesto / Slogan</label>
                <textarea id="manifesto" name="manifesto" rows="3" placeholder="Short phrase displayed on voting card..." required></textarea>
            </div>

            <div class="form-group">
                <label>Profile Picture</label>
                <div class="file-upload-wrapper">
                    <span class="file-label">📂 Click to Upload Photo</span>
                    <input type="file" name="candidatePhoto" accept="image/*" required>
                </div>
            </div>

            <button type="submit">Confirm Appointment</button>
        </form>

        <a href="admin_dashboard.jsp" class="back-link">← Cancel & Return to Dashboard</a>
    </div>

</body>
</html>