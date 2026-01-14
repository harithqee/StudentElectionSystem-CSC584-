package com.election.controller;

import com.election.model.UserBean;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "StudentSubmitProfileServlet", urlPatterns = {"/StudentSubmitProfileServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class StudentSubmitProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        UserBean currentUser = (UserBean) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 1. Retrieve Data
            String studentId = request.getParameter("studentId");
            String name = request.getParameter("candidateName");
            // String faculty = request.getParameter("faculty"); // NOT USED in DB
            String manifesto = request.getParameter("manifesto");

            if (studentId == null || name == null) {
                out.println("<h2>Error: Missing Data</h2>");
                return;
            }

            // 2. Handle File
            Part filePart = request.getPart("candidatePhoto");
            String fileName = getFileName(filePart);
            if(fileName.isEmpty()) fileName = "default.jpg";
            String cleanFileName = studentId + "_" + fileName.replaceAll("\\s+", "_");
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "picture";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String fullPath = uploadPath + File.separator + cleanFileName;
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, new File(fullPath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 3. Database Insert
            VoteDAO voteDao = new VoteDAO();
            UserDAO userDao = new UserDAO();
            String dbImagePath = "picture/" + cleanFileName;

            // UPDATED CALL: Removed 'faculty' because your table doesn't have it
            boolean candidateAdded = voteDao.addCandidate(studentId, name, manifesto, dbImagePath);
            
            if (candidateAdded) {
                boolean statusUpdated = userDao.updateStudentStatus(studentId, "SUBMITTED");
                response.sendRedirect("student_dashboard.jsp?msg=Profile_Submitted_Successfully");
            } else {
                out.println("<h2 style='color:red'>FAILURE: Insert Failed.</h2>");
                out.println("<p>Check NetBeans Output for SQL errors (e.g., column names).</p>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}