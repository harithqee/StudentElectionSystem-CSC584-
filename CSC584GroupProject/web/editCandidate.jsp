<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.CandidateBean"%>
<%
    CandidateBean c = (CandidateBean) request.getAttribute("candidate");
    if(c == null) { response.sendRedirect("admin_dashboard.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Candidate</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f4f4; display: flex; justify-content: center; padding-top: 50px; }
        .form-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 400px; }
        
        label { font-weight: 600; color: #333; display: block; margin-top: 15px; margin-bottom: 5px; }
        input[type="text"], input[type="file"] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        .current-img-box { text-align: center; margin-bottom: 15px; }
        .current-img { width: 100px; height: 100px; object-fit: cover; border-radius: 50%; border: 3px solid #667eea; }
        
        button { width: 100%; padding: 12px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; margin-top: 20px; transition: 0.3s; }
        button:hover { background: #5a6fd6; }
        
        .cancel-link { display: block; text-align: center; margin-top: 15px; text-decoration: none; color: #555; }
        .cancel-link:hover { color: #000; }
    </style>
</head>
<body>
    <div class="form-card">
        <h2 style="text-align: center; color: #333;">Edit Candidate</h2>
        
        <div class="current-img-box">
            <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>" 
     alt="Current Photo" 
     class="current-img"
     onerror="this.onerror=null; this.src='picture/default.jpg';">
        </div>

        <form action="EditCandidateServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="candidateId" value="<%= c.getCandidateId() %>">
            <input type="hidden" name="existingImagePath" value="<%= c.getImagePath() %>">
            
            <label>Name:</label>
            <input type="text" name="name" value="<%= c.getName() %>" required>
            
            <label>Slogan / Manifesto:</label>
            <input type="text" name="slogan" value="<%= c.getManifesto() %>" required>
            
            <label>Upload New Image (Optional):</label>
            <input type="file" name="profileImage" accept="image/*">
            
            <button type="submit">Save Changes</button>
        </form>
        
        <a href="admin_dashboard.jsp" class="cancel-link">Cancel</a>
    </div>
</body>
</html>