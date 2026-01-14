<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%>
<%@page import="com.election.model.CandidateBean"%>
<%@page import="com.election.controller.VoteDAO"%>
<%@page import="com.election.controller.UserDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%
    // 1. Security Check
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if(currentUser == null || !currentUser.getRole().equals("student")) {
        response.sendRedirect("index.jsp"); 
        return;
    }

    // 2. Fetch Voting Data
    VoteDAO voteDao = new VoteDAO();
    List<CandidateBean> candidateList = voteDao.getAllCandidates();

    // 3. CHECK CANDIDACY STATUS
    UserDAO userDao = new UserDAO();
    String myStatus = userDao.getCandidacyStatus(currentUser.getId());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Voting Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <header>
        <div class="brand">Campus<span>Vote</span></div>
        <div class="user-pill">
            <span><%= currentUser.getName() %> (<%= currentUser.getId() %>)</span>
            <a href="LogoutServlet" class="btn-logout">Logout</a>
        </div>
    </header>

    <main>
        <div class="intro-text">
            <h2>Cast Your Vote</h2>
            <p>Select your representative for the upcoming term.</p>
        </div>

        <% if ("APPOINTED".equals(myStatus)) { %>
            <div class="notification-bar warning">
                <span>🎉 You have been appointed! Complete your profile to run.</span>
                <a href="candidate_acceptance.jsp">Setup Profile &rarr;</a>
            </div>
        <% } else if ("SUBMITTED".equals(myStatus)) { %>
            <div class="notification-bar success">
                <span>✅ Application Submitted. Waiting for Admin Approval.</span>
            </div>
        <% } %>

        <form action="VoteServlet" method="POST" id="votingForm">
            <div class="candidates-grid">
                <% if (candidateList != null && !candidateList.isEmpty()) {
                        for(CandidateBean c : candidateList) { %>
                
                <div class="candidate-card" onclick="selectCard(this, '<%= c.getName() %>', 'candidate_<%= c.getCandidateId() %>')">
                    
                    <input type="radio" id="candidate_<%= c.getCandidateId() %>" name="vote" value="<%= c.getCandidateId() %>">
                    
                    <div class="select-indicator"></div>

                    <div class="candidate-image-wrapper">
                        <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>" 
                             alt="<%= c.getName() %>"
                             onerror="this.onerror=null; this.src='picture/default.jpg';">
                    </div>

                    <div class="card-content">
                        <span class="faculty-badge"><%= c.getFaculty() != null ? c.getFaculty() : "FSKM" %></span>
                        <div class="candidate-name"><%= c.getName() %></div>
                        <div class="slogan">"<%= c.getManifesto() %>"</div>
                    </div>
                </div>

                <%      } 
                   } else { %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 100px 0; color: #555;">
                        <h3>No active candidates found.</h3>
                    </div>
                <% } %>
            </div>

            <div class="bottom-nav" id="actionBar">
                <span class="selection-text">Selected: <strong id="selectedName">None</strong></span>
                <button type="submit" class="btn-vote" onclick="return confirmVote()">Confirm Vote</button>
            </div>
        </form>
    </main>

    <script>
        function selectCard(cardElement, name, radioId) {
            // 1. Remove 'selected' class from all cards
            document.querySelectorAll('.candidate-card').forEach(el => el.classList.remove('selected'));
            
            // 2. Add 'selected' class to the clicked card
            cardElement.classList.add('selected');
            
            // 3. Check the hidden radio button
            document.getElementById(radioId).checked = true;

            // 4. Show the floating action bar
            document.getElementById('selectedName').textContent = name;
            document.getElementById('actionBar').classList.add('active');
        }

        function confirmVote() {
            if (!document.querySelector('input[name="vote"]:checked')) {
                alert("Please select a candidate first.");
                return false;
            }
            return confirm("Are you sure you want to cast your vote? This action cannot be undone.");
        }
    </script>

</body>
</html>