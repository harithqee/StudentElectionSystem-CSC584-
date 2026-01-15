<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%>
<%
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if(currentUser == null) { response.sendRedirect("login.jsp"); return; }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Candidate Acceptance Form</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 20px; width: 100%; max-width: 500px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        input[type="text"], textarea { width: 100%; padding: 12px; border: 2px solid #eee; border-radius: 8px; font-size: 1rem; }
        input[readonly] { background-color: #f9f9f9; color: #888; }
        button { width: 100%; padding: 15px; background: #28a745; color: white; border: none; border-radius: 10px; font-size: 1.1rem; font-weight: bold; cursor: pointer; }
        button:hover { background: #218838; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Candidate Profile Form</h2>
        <p style="text-align:center; color:#666; margin-bottom:30px;">Please complete your details to finalize your candidacy.</p>
        
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
                <input type="file" name="candidatePhoto" accept="image/*" required style="border:none;">
            </div>

            <button type="submit">Submit Profile</button>
        </form>
    </div>
</body>
</html>