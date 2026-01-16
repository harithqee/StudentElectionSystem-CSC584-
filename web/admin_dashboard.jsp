<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.UserBean"%> 
<%@page import="com.election.model.CandidateBean"%> 
<%@page import="com.election.controller.VoteDAO"%>
<%@page import="com.election.controller.UserDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>

<%
    // --- 1. SECURITY CHECK ---
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    // --- 2. INITIALIZE DAOS ---
    VoteDAO voteDao = new VoteDAO();
    UserDAO userDao = new UserDAO();

    // --- 3. FETCH DATA ---
    List<CandidateBean> pendingList = voteDao.getPendingCandidates(); 
    List<CandidateBean> approvedList = voteDao.getApprovedCandidates();
    int totalVotes = voteDao.getTotalVotes();
    
    // Get existing candidates (to disable 'Appoint' buttons for them)
    List<String> existingCandidateIds = voteDao.getAllCandidateStudentIds();
    
    // Get all students for the management table
    List<UserBean> allStudentList = userDao.getAllStudents();

    // Get Recent Activity Log (Reverse to show newest first)
    List<String[]> recentVotes = voteDao.getRecentVotes();
    Collections.reverse(recentVotes);

    // Search Logic (Optional server-side check)
    String searchQuery = request.getParameter("search");
    List<UserBean> searchResultList = new ArrayList<UserBean>();
    if(searchQuery != null && !searchQuery.trim().isEmpty()){
        searchResultList = userDao.searchStudents(searchQuery);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <header>
        <div class="brand">Admin<span>Panel</span></div>
        <div class="user-pill">
            <span><%= currentUser.getName() %></span>
            <a href="LogoutServlet" class="btn-logout">Logout</a>
        </div>
    </header>
    
    <main>
        <% if(request.getAttribute("successMessage") != null) { %>
            <div style="background: var(--success-bg); color: var(--success-text); border: 1px solid var(--success-border); padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center;">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        <% if(request.getAttribute("errorMessage") != null) { %>
            <div style="background: rgba(231, 76, 60, 0.1); color: var(--danger-text); border: 1px solid rgba(231, 76, 60, 0.3); padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center;">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <h2 class="section-title" style="margin-top: 0;">Overview</h2>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalVotes %></div>
                <div class="stat-label">Total Votes</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= approvedList.size() %></div>
                <div class="stat-label">Active Candidates</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= pendingList.size() %></div>
                <div class="stat-label">Pending Reviews</div>
            </div>
        </div>

        <div class="table-container" style="padding: 25px; margin-bottom: 50px;">
            <h3 style="color: var(--text-muted); font-size: 0.9rem; text-transform: uppercase; margin-bottom: 15px; letter-spacing: 1px;">Recent Activity</h3>
            <% if (recentVotes.isEmpty()) { %>
                <p style="color: #555;">No votes cast yet.</p>
            <% } else { %>
                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <% int count = 0;
                       for(String[] log : recentVotes) { 
                           if(count >= 5) break; 
                           count++; %>
                    <div style="display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border-color);">
                        <span style="font-size: 0.95rem;">Student <strong style="color: white;"><%= log[0] %></strong> voted.</span>
                        <span style="color: var(--text-muted); font-size: 0.9rem;">For <%= log[1] %></span>
                    </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <h2 class="section-title">Live Results</h2>
        <% if (approvedList.isEmpty()) { %>
            <div style="padding: 50px; text-align: center; color: var(--text-muted); border: 1px dashed var(--border-color); border-radius: 16px; margin-bottom: 50px;">
                No active candidates found.
            </div>
        <% } else { %>
            <div class="candidates-grid" style="margin-bottom: 50px;">
                <% for(CandidateBean c : approvedList) { %>
                <div class="candidate-card">
                    <div class="candidate-image-wrapper">
                        <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>" 
                             onerror="this.onerror=null; this.src='picture/default.jpg';">
                    </div>
                    <div class="card-content">
                        <span class="faculty-badge"><%= c.getFaculty() != null ? c.getFaculty() : "FSKM" %></span>
                        <div class="candidate-name"><%= c.getName() %></div>
                        
                        <span class="total-votes"><%= c.getVoteCount() %></span>
                        <span class="vote-label">Votes</span>

                        <div style="margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 15px; display: flex; justify-content: center;">
                             <a href="EditCandidateServlet?id=<%= c.getCandidateId() %>" class="btn-action btn-edit">Edit</a>
                             <a href="DeleteCandidateServlet?id=<%= c.getCandidateId() %>" class="btn-action btn-delete" onclick="return confirm('Delete this candidate?')">Delete</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>

        <h2 class="section-title">Pending Approvals</h2>
        <div class="table-container">
    <% if (pendingList.isEmpty()) { %>
        <div style="padding: 30px; text-align: center; color: var(--text-muted);">No pending forms to review.</div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Faculty</th>
                    <th>Manifesto</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% for(CandidateBean c : pendingList) { %>
                <tr>
                    <td>
                        <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>" 
                             class="thumb-img" 
                             onerror="this.onerror=null; this.src='picture/default.jpg';">
                    </td>
                    <td style="color: white; font-weight: 500;"><%= c.getName() %></td>
                    <td><%= c.getFaculty() %></td>
                    <td style="color: var(--text-muted); font-style: italic;">"<%= c.getManifesto() %>"</td>
                    <td>
                        <a href="ApproveCandidateServlet?id=<%= c.getCandidateId() %>" class="btn-action btn-approve" style="margin-right: 5px;">Approve</a>
                        
                        <a href="DeleteCandidateServlet?id=<%= c.getCandidateId() %>" 
                           class="btn-action btn-delete" 
                           onclick="return confirm('Are you sure you want to REJECT this application? This will remove the candidate data and reset the student status.')">
                           Reject
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</div>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 60px; margin-bottom: 20px;">
            <h2 class="section-title" style="margin: 0; border: none; padding: 0;">Manage Students</h2>
            
            <button class="btn-create" onclick="toggleAddForm()">
                <span>+</span> Add New Student
            </button>
        </div>

        <div id="addStudentFormContainer">
            <h3 style="margin-bottom: 20px; color: white;">New Student Details</h3>
            <form action="AddStudentServlet" method="POST">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="text" name="studentId" required placeholder="e.g. 2024001">
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" required placeholder="e.g. John Doe">
                    </div>
                    <div class="form-group">
                        <label>Faculty</label>
                        <input type="text" name="faculty" required placeholder="e.g. FSKM">
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required placeholder="student@uitm.edu.my" 
                               style="background: var(--bg-body); border: 1px solid var(--border-color); color: white; padding: 12px 20px; border-radius: 8px; width: 100%; outline: none;">
                    </div>
                </div>
                <button type="submit" class="btn-submit-form">Save Student</button>
            </form>
        </div>
        
        <div class="search-wrapper">
            <input type="text" id="studentSearchInput" onkeyup="filterStudents()" placeholder="Filter by Name or ID...">
        </div>

        <div class="table-container" style="max-height: 500px; overflow-y: auto;">
            <table id="studentTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Faculty</th>
                        <th>Actions</th>
                        <th>Election</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(UserBean s : allStudentList) { 
                       boolean isCandidate = existingCandidateIds.contains(s.getId());
                    %>
                    <tr>
                        <td style="color: var(--text-muted);"><%= s.getId() %></td>
                        <td style="font-weight: 500; color: white;"><%= s.getName() %></td>
                        <td><span class="faculty-badge" style="margin:0;"><%= s.getFaculty() %></span></td>
                        
                        <td>
                            <a href="EditStudentServlet?id=<%= s.getId() %>" class="btn-action btn-edit" title="Edit">Edit</a>
                            <a href="DeleteStudentServlet?id=<%= s.getId() %>" class="btn-action btn-delete" 
                               onclick="return confirm('Delete <%= s.getName() %>? This cannot be undone.')" title="Delete">Delete</a>
                        </td>

                        <td>
                            <% if (isCandidate) { %>
                                <span style="color: var(--success-text); font-size: 0.85rem; font-weight: 600;">✓ Candidate</span>
                            <% } else { %>
                                <form action="AppointCandidateServlet" method="POST" style="margin: 0;">
                                    <input type="hidden" name="studentId" value="<%= s.getId() %>">
                                    <button type="submit" class="btn-appoint" style="padding: 6px 14px; font-size: 0.8rem;">+ Appoint</button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>  

    </main>

    <script>
        // Toggle the Add Student Form
        function toggleAddForm() {
            var form = document.getElementById("addStudentFormContainer");
            if (form.style.display === "none" || form.style.display === "") {
                form.style.display = "block";
            } else {
                form.style.display = "none";
            }
        }

        // Filter Table Logic
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
                    
                    if (idValue.toUpperCase().indexOf(filter) > -1 || nameValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</body>
</html>