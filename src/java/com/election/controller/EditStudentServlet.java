package com.election.controller;

import com.election.model.UserBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EditStudentServlet", urlPatterns = {"/EditStudentServlet"})
public class EditStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Retrieve Data from Form
            String studentId = request.getParameter("studentId"); // ID is usually read-only
            String name = request.getParameter("name");
            String faculty = request.getParameter("faculty");
            String email = request.getParameter("email");
            
            // 2. Create User Object
            UserBean u = new UserBean();
            u.setId(studentId);
            u.setName(name);
            u.setFaculty(faculty);
            u.setEmail(email);
            
            // 3. Update Database
            UserDAO dao = new UserDAO();
            boolean success = dao.updateStudent(u); // Ensure you have this method in UserDAO
            
            // 4. Send Response (Forwarding with Message)
            if (success) {
                request.setAttribute("successMessage", "Student updated successfully.");
                // Forwarding preserves the request attributes so the JSP can display the message
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Update failed. Please try again.");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
    
    // Handles the GET request to populate the form
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        UserDAO dao = new UserDAO();
        UserBean s = dao.getStudentById(id);
        
        request.setAttribute("student", s);
        request.getRequestDispatcher("edit_student.jsp").forward(request, response);
    }
}