package com.election.controller;

import com.election.model.UserBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AddStudentServlet", urlPatterns = {"/AddStudentServlet"})
public class AddStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve Data from JSP Form (Admin Dashboard)
        String id = request.getParameter("studentId");
        String name = request.getParameter("name");
        String faculty = request.getParameter("faculty");
        String email = request.getParameter("email");
        
        // Default values since Admin is creating the account
        String role = "student"; 
        String password = id; // Set default password same as ID
        
        // 2. Create and Populate the JavaBean (Model)
        UserBean user = new UserBean();
        user.setId(id);
        user.setName(name);
        user.setFaculty(faculty);
        user.setEmail(email);
        user.setRole(role);
        user.setPassword(password); 
        
        // 3. Call DAO to handle Database Insertion
        // We reuse 'registerUser' because it already handles the INSERT logic correctly
        UserDAO dao = new UserDAO();
        String result = dao.registerUser(user);
        
        // 4. Handle the Result
        if (result.equals("SUCCESS")) {
            // Success: Stay on Admin Dashboard and show Green Success Message
            request.setAttribute("successMessage", "Student " + name + " added successfully.");
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            
        } else {
            // Failure: Stay on Admin Dashboard and show Red Error Message
            request.setAttribute("errorMessage", "Failed to add student: " + result);
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
}