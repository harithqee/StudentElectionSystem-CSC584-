package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AppointCandidateServlet", urlPatterns = {"/AppointCandidateServlet"})
public class AppointCandidateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Get Student ID
            String studentId = request.getParameter("studentId");
            
            // 2. Check Current Status
            UserDAO dao = new UserDAO();
            String currentStatus = dao.getCandidacyStatus(studentId); // Assuming you have this method

            if ("APPOINTED".equals(currentStatus)) {
                // CASE 1: Already Appointed
                request.setAttribute("errorMessage", "Action Cancelled: Student " + studentId + " is already appointed and needs to accept.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                return;

            } else if ("SUBMITTED".equals(currentStatus) || "APPROVED".equals(currentStatus)) {
                // CASE 2: Already a Candidate (or Pending Approval)
                request.setAttribute("errorMessage", "Action Cancelled: Student " + studentId + " is already an active candidate.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                return;
            }

            // 3. If Status is NULL or EMPTY, Proceed to Appoint
            boolean success = dao.appointStudent(studentId); 
            
            if(success) {
                request.setAttribute("successMessage", "Student " + studentId + " appointed successfully! Waiting for form submission.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to appoint student. Please try again.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
}