package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ApproveCandidateServlet", urlPatterns = {"/ApproveCandidateServlet"})
public class ApproveCandidateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Candidate ID
        String idStr = request.getParameter("id");
        
        if(idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                
                // 2. Call DAO to Approve
                VoteDAO dao = new VoteDAO();
                boolean success = dao.approveCandidate(id);
                
                // 3. Redirect
                if(success) {
                    response.sendRedirect("admin_dashboard.jsp?msg=Candidate_Approved_Successfully");
                } else {
                    response.sendRedirect("admin_dashboard.jsp?error=Approval_Failed_Check_Database");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?error=Invalid_ID");
            }
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Missing_ID");
        }
    }
}