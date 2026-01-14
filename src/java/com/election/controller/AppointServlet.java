package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AppointServlet", urlPatterns = {"/AppointServlet"})
public class AppointServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get Student ID from the button click
        String studentId = request.getParameter("studentId");
        
        // 2. Call DAO to update status
        UserDAO dao = new UserDAO();
        boolean success = dao.appointStudent(studentId); // Sets status to 'APPOINTED'
        
        // 3. Redirect back to dashboard
        if(success) {
            response.sendRedirect("admin_dashboard.jsp?msg=Student appointed successfully. Waiting for form submission.");
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Failed to appoint student.");
        }
    }
}