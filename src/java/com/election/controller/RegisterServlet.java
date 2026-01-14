package com.election.controller;

import com.election.model.UserBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Retrieve Data from JSP Form
        // These names must match the 'name' attributes in your register.jsp
        String role = request.getParameter("user_role");
        String name = request.getParameter("full_name");
        String id = request.getParameter("user_id"); 
        String email = request.getParameter("email");
        String faculty = request.getParameter("faculty");
        String pass = request.getParameter("password");
        
        // 2. Create and Populate the JavaBean (Model)
        UserBean user = new UserBean();
        user.setRole(role);
        user.setName(name);
        user.setId(id);
        user.setEmail(email);
        user.setFaculty(faculty);
        user.setPassword(pass);

        // 3. Call DAO to handle Database Insertion
        // This uses the UserDAO we just updated with the Derby connection
        UserDAO dao = new UserDAO();
        String result = dao.registerUser(user);

        // 4. Handle the Result
        if (result.equals("SUCCESS")) {
            // Success: Redirect to login page with a success message
            response.sendRedirect("index.jsp?msg=Registration Successful! Please Login.");
        } else {
            // Failure: Stay on register page and show error
            request.setAttribute("errorMessage", result);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}