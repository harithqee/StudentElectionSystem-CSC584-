package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteCandidateServlet", urlPatterns = {"/DeleteCandidateServlet"})
public class DeleteCandidateServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if(idStr != null) {
            VoteDAO dao = new VoteDAO();
            boolean success = dao.deleteCandidate(Integer.parseInt(idStr));
            if(success) {
                request.getSession().setAttribute("msg", "Candidate deleted successfully.");
            } else {
                request.getSession().setAttribute("error", "Failed to delete candidate.");
            }
        }
        response.sendRedirect("admin_dashboard.jsp");
    }
}