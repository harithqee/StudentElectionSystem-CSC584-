<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%> 
<%@page import="com.election.model.CandidateBean"%> 
<%@page import="com.election.controller.VoteDAO"%>
<%@page import="com.election.controller.UserDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>

<%
    /* ===============================
       1. SECURITY CHECK (LECTURER)
       =============================== */
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect("index.jsp");
        return;
    }

    /* ===============================
       2. INITIALIZE DAOS
       =============================== */
    VoteDAO voteDao = new VoteDAO();
    UserDAO userDao = new UserDAO();

    /* ===============================
       3. FETCH & FILTER DATA
       =============================== */
    String lecturerFaculty = currentUser.getFaculty();
    int totalVotes = voteDao.getTotalVotes();
    List<CandidateBean> approvedList = voteDao.getApprovedCandidates();
    
    // --- FILTER STUDENT DIRECTORY BY FACULTY ---
    List<UserBean> allStudentList = userDao.getNonCandidateStudents();
    List<UserBean> facultyStudentList = new ArrayList<UserBean>();

    if (allStudentList != null) {
        for (UserBean s : allStudentList) {
            if (s.getFaculty() != null && s.getFaculty().equalsIgnoreCase(lecturerFaculty)) {
                facultyStudentList.add(s);
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lecturer Dashboard - <%= lecturerFaculty %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }
        .voted { background: rgba(46, 204, 113, 0.15); color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.3); }
        .pending { background: rgba(231, 76, 60, 0.15); color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.3); }
    </style>
</head>
<body>

<header>
    <div class="brand">Lecturer<span>Dashboard</span></div>
    <div class="user-pill">
        <span style="opacity: 0.7; font-size: 0.8rem; margin-right: 5px;"><%= lecturerFaculty %> |</span>
        <span><%= currentUser.getName() %></span>
        <a href="LogoutServlet" class="btn-logout">Logout</a>
    </div>
</header>

<main>
    <h2 class="section-title" style="margin-top: 0;">Overview</h2>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number"><%= totalVotes %></div>
            <div class="stat-label">Total Votes Cast</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><%= approvedList.size() %></div>
            <div class="stat-label">Active Candidates</div>
        </div>
    </div>

    <h2 class="section-title">Live Results</h2>
    <div class="candidates-grid" style="margin-bottom: 50px;">
        <% for(CandidateBean c : approvedList) { %>
        <div class="candidate-card">
            <div class="candidate-image-wrapper">
                <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>"
                     onerror="this.onerror=null; this.src='picture/default.jpg';">
            </div>
            <div class="card-content">
                <span class="faculty-badge"><%= c.getFaculty() %></span>
                <div class="candidate-name"><%= c.getName() %></div>
                <span class="total-votes"><%= c.getVoteCount() %></span>
                <span class="vote-label">Votes</span>
            </div>
        </div>
        <% } %>
    </div>

    <h2 class="section-title" style="margin-top: 60px;">Student Directory (<%= lecturerFaculty %>)</h2>
    <div class="search-wrapper">
        <input type="text" id="studentSearchInput" onkeyup="filterStudents()" placeholder="Search <%= lecturerFaculty %> students...">
    </div>

    <div class="table-container" style="max-height: 500px; overflow-y: auto;">
        <table id="studentTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Faculty</th>
                    <th>Vote Status</th>
                </tr>
            </thead>
            <tbody>
                <% if(facultyStudentList.isEmpty()) { %>
                    <tr><td colspan="4" style="text-align: center; padding: 30px;">No students found for <%= lecturerFaculty %>.</td></tr>
                <% } else { %>
                    <% for(UserBean s : facultyStudentList) { %>
                    <tr>
                        <td style="color: var(--text-muted);"><%= s.getId() %></td>
                        <td style="font-weight: 500; color: white;"><%= s.getName() %></td>
                        <td><span class="faculty-badge" style="margin:0;"><%= s.getFaculty() %></span></td>
                        <td>
                            <% if(s.isVoted()) { %>
                                <span class="status-badge voted">Voted</span>
                            <% } else { %>
                                <span class="status-badge pending">Not Voted</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                <% } %>
            </tbody>
        </table>
    </div>
</main>

<script>
    function filterStudents() {
        var input = document.getElementById("studentSearchInput");
        var filter = input.value.toUpperCase();
        var table = document.getElementById("studentTable");
        var tr = table.getElementsByTagName("tr");
        for (var i = 1; i < tr.length; i++) {
            var tdId = tr[i].getElementsByTagName("td")[0]; 
            var tdName = tr[i].getElementsByTagName("td")[1];
            if (tdId || tdName) {
                var idValue = tdId.textContent || tdId.innerText;
                var nameValue = tdName.textContent || tdName.innerText;
                tr[i].style.display = (idValue.toUpperCase().indexOf(filter) > -1 || nameValue.toUpperCase().indexOf(filter) > -1) ? "" : "none";
            }
        }
    }
</script>
</body>
</html>