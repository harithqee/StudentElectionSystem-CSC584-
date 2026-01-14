package com.election.controller;

import com.election.model.CandidateBean;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "EditCandidateServlet", urlPatterns = {"/EditCandidateServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class EditCandidateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        try {
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                VoteDAO dao = new VoteDAO();
                CandidateBean candidate = dao.getCandidateById(id);
                if (candidate != null) {
                    request.setAttribute("candidate", candidate);
                    request.getRequestDispatcher("editCandidate.jsp").forward(request, response);
                } else {
                    response.sendRedirect("admin_dashboard.jsp");
                }
            } else {
                response.sendRedirect("admin_dashboard.jsp");
            }
        } catch (Exception e) {
            response.sendRedirect("admin_dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Get Text Parameters
            int id = Integer.parseInt(request.getParameter("candidateId"));
            String name = request.getParameter("name");
            String slogan = request.getParameter("slogan");
            String existingPath = request.getParameter("existingImagePath");

            // 2. Handle File Upload (Using Files.copy logic)
            Part filePart = request.getPart("profileImage"); // Matches JSP input name="profileImage"
            String finalImagePath = existingPath; // Default to existing if no new file

            String fileName = getFileName(filePart);

            // Check if user actually uploaded a file
            if (fileName != null && !fileName.isEmpty()) {
                
                // Create unique filename: ID_filename.jpg
                String cleanFileName = id + "_" + fileName.replaceAll("\\s+", "_");
                
                // Get upload directory path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "picture";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String fullPath = uploadPath + File.separator + cleanFileName;

                // SAVE FILE using Files.copy (Reliable Method)
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, new File(fullPath).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                
                // Update the path string for the database
                finalImagePath = "picture/" + cleanFileName; 
            }

            // 3. Update Database
            CandidateBean c = new CandidateBean();
            c.setCandidateId(id);
            c.setName(name);
            c.setManifesto(slogan);
            c.setImagePath(finalImagePath);

            VoteDAO dao = new VoteDAO();
            boolean success = dao.updateCandidate(c);

            // 4. Send Response (Using your requested logic)
            if (success) {
                request.setAttribute("successMessage", "Candidate updated successfully.");
                
                // Refresh lists so dashboard shows updated data immediately
                request.setAttribute("approvedList", dao.getApprovedCandidates());
                request.setAttribute("pendingList", dao.getPendingCandidates());
                
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Update failed.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }

    // Helper method to extract filename from Part
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}