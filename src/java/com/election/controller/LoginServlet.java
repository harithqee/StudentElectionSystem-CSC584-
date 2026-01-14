package com.election.controller;

import com.election.model.UserBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();
        UserBean user = null;

        // --- AUTOMATIC ROLE DETECTION ---
        
        // 1. Try to login as ADMIN
        user = dao.authenticateUser(username, pass, "admin");

        // 2. If not found, try as LECTURER
        if (user == null) {
            user = dao.authenticateUser(username, pass, "lecturer");
        }

        // 3. If still not found, try as STUDENT
        if (user == null) {
            user = dao.authenticateUser(username, pass, "student");
        }

        // --- RESULT HANDLING ---
        
        if (user != null) {
            // Login Successful
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            // Redirect based on the detected role
            if (user.getRole().equalsIgnoreCase("admin")) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if (user.getRole().equalsIgnoreCase("lecturer")) {
                response.sendRedirect("lecturer_dashboard.jsp");
            } else {
                response.sendRedirect("student_dashboard.jsp");
            }
        } else {
            // Login Failed
            request.setAttribute("errorMessage", "Invalid ID or Password.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}