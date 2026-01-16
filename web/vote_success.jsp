<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.controller.VoteDAO"%> 

<%
    // 1. Get IDs from URL
    String studentId = request.getParameter("sid");
    String status = request.getParameter("status");
    String candidateName = request.getParameter("cname"); 

    // Safety Default
    if(studentId == null) studentId = "Student";
    
    // 2. LOGIC: If they already voted, FETCH the name from DB using the DAO
    if ("ALREADY_VOTED".equals(status)) {
        VoteDAO dao = new VoteDAO();
        
        // This calls the SQL: SELECT c.NAME FROM ... WHERE v.STUDENTID = ?
        String dbCandidateName = dao.getVotedCandidateName(studentId);
        
        // If DB returned a valid name, use it. Otherwise keep "Unknown".
        if (dbCandidateName != null && !dbCandidateName.equals("Unknown Candidate")) {
            candidateName = dbCandidateName;
        }
    }
    
    // Final Fallback
    if(candidateName == null || candidateName.isEmpty()) candidateName = "Unknown Candidate";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voting Status</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        /* --- DARK MODERN THEME VARIABLES --- */
        :root {
            --bg-body: #0a0a0a;
            --bg-card: #141414;
            --border-color: #333;
            --text-main: #ffffff;
            --text-muted: #888888;
            --success-text: #27ae60;
            --success-bg: rgba(39, 174, 96, 0.1);
            --warning-text: #ffc107;
            --warning-bg: rgba(255, 193, 7, 0.1);
        }

        /* --- PAGE LAYOUT --- */
        body { 
            font-family: 'Inter', sans-serif; 
            margin: 0; padding: 0;
            background-color: var(--bg-body); 
            color: var(--text-main);
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh;
            background-image: radial-gradient(circle at 50% 50%, #1a1a1a 0%, #0a0a0a 100%);
        }

        /* --- CARD STYLE --- */
        .success-card {
            background: var(--bg-card); 
            padding: 50px 40px; 
            border-radius: 24px; 
            text-align: center; 
            border: 1px solid var(--border-color);
            box-shadow: 0 20px 50px rgba(0,0,0,0.5); 
            max-width: 450px; 
            width: 90%; 
            animation: popIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* --- TYPOGRAPHY & ELEMENTS --- */
        .status-icon { 
            font-size: 4rem; 
            margin-bottom: 20px; 
            display: block;
        }

        h2 { margin: 0 0 15px 0; font-size: 2rem; font-weight: 700; }

        p { 
            color: var(--text-muted); 
            font-size: 1.05rem; 
            line-height: 1.6; 
            margin-bottom: 30px; 
        }

        .highlight { 
            font-weight: 600; 
            color: var(--text-main); 
            background: rgba(255,255,255,0.1); 
            padding: 2px 8px; 
            border-radius: 4px; 
        }

        /* Status Colors */
        .status-success h2 { color: var(--success-text); }
        .status-warning h2 { color: var(--warning-text); }

        /* --- INFO BOXES --- */
        .vote-recap-box { 
            background: var(--success-bg); 
            border: 1px solid rgba(39, 174, 96, 0.3); 
            padding: 15px; 
            border-radius: 12px; 
            margin-bottom: 30px; 
        }

        .prev-vote-box {
            background: var(--warning-bg); 
            border: 1px solid rgba(255, 193, 7, 0.3); 
            padding: 15px; 
            border-radius: 12px; 
            margin-bottom: 30px; 
        }
        
        .vote-label { 
            display: block; 
            font-size: 0.85rem; 
            color: #aaa; 
            text-transform: uppercase; 
            margin-bottom: 5px; 
        }
        .vote-name { 
            font-size: 1.2rem; 
            color: #fff; 
            font-weight: 700; 
        }

        /* --- BUTTONS --- */
        .btn-home {
            display: inline-block; 
            padding: 14px 40px; 
            background: var(--text-main); 
            color: black; 
            text-decoration: none; 
            border-radius: 50px; 
            font-weight: 600; 
            transition: 0.3s;
        }
        .btn-home:hover { 
            transform: translateY(-2px); 
            background: #e0e0e0; 
            box-shadow: 0 10px 20px rgba(255, 255, 255, 0.15); 
        }

        @keyframes popIn { 
            0% { transform: scale(0.9); opacity: 0; } 
            100% { transform: scale(1); opacity: 1; } 
        }
    </style>
</head>
<body>
    
    <% if ("ALREADY_VOTED".equals(status)) { %>
        <div class="success-card status-warning">
            <div class="status-icon">⚠️</div>
            <h2>Vote Attempted</h2>
            
            <p>
                Student <span class="highlight"><%= studentId %></span>, our records show you have <strong>already voted</strong>.
            </p>
            
            <div class="prev-vote-box">
                <span class="vote-label">You previously voted for</span>
                <strong class="vote-name"><%= candidateName %></strong>
            </div>

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
                <span class="vote-label">You Voted For</span>
                <strong class="vote-name"><%= candidateName %></strong>
            </div>

            <a href="LogoutServlet" class="btn-home">Back to Login</a>
        </div>
    <% } %>

</body>
</html>