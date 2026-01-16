<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.election.model.CandidateBean"%>
<%
    // 1. Fetch Candidate Data
    CandidateBean c = (CandidateBean) request.getAttribute("candidate");
    
    // Redirect if no candidate found (Security)
    if(c == null) { 
        response.sendRedirect("admin_dashboard.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Candidate</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        /* --- DARK MODERN THEME --- */
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

        /* --- CENTERED CARD --- */
        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
            width: 100%;
            max-width: 480px;
            animation: fadeIn 0.5s ease-out;
        }

        h2 { 
            text-align: center; 
            margin-bottom: 30px; 
            font-size: 1.6rem; 
            font-weight: 700; 
            color: var(--text-main);
            letter-spacing: -0.5px;
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

        input[type="text"] {
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

        input[type="text"]:focus {
            border-color: var(--primary-accent);
            background: var(--bg-card);
            box-shadow: 0 0 0 2px rgba(255,255,255,0.1);
        }

        /* --- IMAGE PREVIEW BOX --- */
        .current-img-box {
            text-align: center;
            margin-bottom: 25px;
            padding: 20px;
            background: #0f0f0f;
            border-radius: 16px;
            border: 1px dashed var(--border-color);
        }

        .current-img {
            width: 110px; height: 110px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid var(--border-color);
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            transition: 0.3s;
        }
        
        .current-img:hover { border-color: var(--primary-accent); transform: scale(1.05); }

        /* --- CUSTOM FILE INPUT --- */
        input[type="file"] { display: none; } /* Hide default browser input */

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

        button[type="submit"] {
            width: 100%; padding: 14px; 
            background: var(--primary-accent); 
            color: black;
            border: none; border-radius: 50px; 
            font-size: 1rem; font-weight: 700; 
            cursor: pointer; transition: 0.3s; 
            margin-top: 20px;
        }

        button:hover { 
            transform: translateY(-2px); 
            background: #e0e0e0; 
            box-shadow: 0 5px 15px rgba(255,255,255,0.1); 
        }

        .cancel-link { 
            text-align: center; 
            margin-top: 25px; 
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

    <main class="form-card">
        <h2>Edit Candidate</h2>
        
        <form action="EditCandidateServlet" method="POST" enctype="multipart/form-data">
            
            <input type="hidden" name="candidateId" value="<%= c.getCandidateId() %>">
            <input type="hidden" name="existingImagePath" value="<%= c.getImagePath() %>">
            
            <div class="current-img-box">
                <img src="<%= (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" %>" 
                     alt="Current Photo" 
                     class="current-img" id="previewImg"
                     onerror="this.onerror=null; this.src='picture/default.jpg';">
                <div style="font-size: 0.8rem; color: #666; margin-top: 10px;">Current Profile Photo</div>
            </div>

            <div class="input-group">
                <label>Name</label>
                <input type="text" name="name" value="<%= c.getName() %>" required>
            </div>
            
            <div class="input-group">
                <label>Slogan / Manifesto</label>
                <input type="text" name="slogan" value="<%= c.getManifesto() %>" required>
            </div>
            
            <div class="input-group">
                <label>Upload New Image (Optional)</label>
                <label for="profileImage" class="file-upload-label" id="fileLabel">
                    Tap to select new photo
                </label>
                <input type="file" id="profileImage" name="profileImage" accept="image/*" onchange="previewFile()">
            </div>
            
            <button type="submit">Save Changes</button>
        </form>
        
        <div class="cancel-link">
            <a href="admin_dashboard.jsp">Cancel & Return</a>
        </div>
    </main>

    <script>
        function previewFile() {
            const preview = document.getElementById('previewImg');
            const fileInput = document.getElementById('profileImage');
            const fileLabel = document.getElementById('fileLabel');
            const file = fileInput.files[0];

            if (file) {
                const reader = new FileReader();
                reader.onloadend = function() {
                    preview.src = reader.result; // Update image src to file data
                }
                reader.readAsDataURL(file);
                
                // Update label text
                fileLabel.textContent = "Selected: " + file.name;
                fileLabel.style.color = "#fff";
                fileLabel.style.borderColor = "#fff";
            }
        }
    </script>

</body>
</html>