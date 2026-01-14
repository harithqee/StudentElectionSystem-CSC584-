<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get parameters from URL
    String studentId = request.getParameter("sid");
    String candidateName = request.getParameter("cname");
    String status = request.getParameter("status"); 
    
    // Safety check
    if(studentId == null) studentId = "Student";
    if(candidateName == null) candidateName = "Unknown Candidate";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voting Status</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="centered-view">
    
    <% if ("ALREADY_VOTED".equals(status)) { %>
        <div class="success-card status-warning">
            <div class="status-icon">⚠️</div>
            <h2>Vote Attempted</h2>
            
            <p>
                Student <span class="highlight"><%= studentId %></span>, our records show you have <strong>already voted</strong>.
            </p>
            
            <p style="font-size: 0.9rem; border-top: 1px solid var(--border-color); padding-top: 20px;">
                You previously voted for <br> 
                <span class="highlight" style="margin-top:5px; display:inline-block;"><%= candidateName %></span>.
            </p>

            <a href="LogoutServlet" class="btn-home">Back to Login</a>
        </div>
        
    <% } else { %>
        <div class="success-card status-success">
            <div class="status-icon">✅</div>
            <h2>Vote Confirmed</h2>
            
            <p>
                Student <span class="highlight"><%= studentId %></span>, your vote has been successfully cast.
            </p>
            
            <div class="vote-recap-box">
                <span class="vote-recap-label">Voted For</span>
                <strong class="vote-recap-name"><%= candidateName %></strong>
            </div>

            <a href="LogoutServlet" class="btn-home">Back to Login</a>
        </div>
    <% } %>

</body>
</html>