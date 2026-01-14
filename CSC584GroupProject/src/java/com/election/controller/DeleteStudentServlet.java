package com.election.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteStudentServlet", urlPatterns = {"/DeleteStudentServlet"})
public class DeleteStudentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        UserDAO dao = new UserDAO();
        
        if(dao.deleteStudent(id)) {
            response.sendRedirect("admin_dashboard.jsp?msg=Student_Deleted");
        } else {
            response.sendRedirect("admin_dashboard.jsp?error=Delete_Failed");
        }
    }
}