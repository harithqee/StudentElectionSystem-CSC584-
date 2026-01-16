package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteCandidateServlet", urlPatterns = {"/DeleteCandidateServlet"})
public class DeleteCandidateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String idStr = request.getParameter("id");
            
            if(idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                VoteDAO dao = new VoteDAO();
                
                // Perform Delete Logic
                boolean success = dao.deleteCandidate(id);
                
                if(success) {
                    // Success: Set message and Forward
                    request.setAttribute("successMessage", "Candidate deleted successfully and student candidacy status reset to None.");
                    request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                } else {
                    // Failure: Set error and Forward
                    request.setAttribute("errorMessage", "Failed to delete candidate.");
                    request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                }
            } else {
                // Handle case where ID is missing
                request.setAttribute("errorMessage", "Error: Candidate ID is missing.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
}