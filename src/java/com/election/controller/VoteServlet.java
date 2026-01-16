package com.election.controller;

import com.election.model.CandidateBean;
import com.election.model.UserBean;
import java.io.IOException;
import java.net.URLEncoder; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "VoteServlet", urlPatterns = {"/VoteServlet"})
public class VoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check: Ensure user is logged in
        HttpSession session = request.getSession();
        UserBean currentUser = (UserBean) session.getAttribute("currentUser");

        if (currentUser == null || !currentUser.getRole().equals("student")) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Retrieve Vote Data
        String candidateIdStr = request.getParameter("vote");

        if (candidateIdStr != null && !candidateIdStr.isEmpty()) {
            try {
                // Parse inputs
                int candidateId = Integer.parseInt(candidateIdStr);
                String studentId = currentUser.getId();

                VoteDAO dao = new VoteDAO();

                // 3. Get Candidate Name (For the message display)
                CandidateBean candidate = dao.getCandidateById(candidateId);
                String candidateName = (candidate != null) ? candidate.getName() : "Unknown";
                
                // Encode name for URL (e.g., "John Doe" becomes "John+Doe")
                String encodedName = URLEncoder.encode(candidateName, "UTF-8");

                // 4. Process Vote via DAO
                String result = dao.castVote(studentId, candidateId);

                // 5. Handle Result & Redirect
                if (result.equals("SUCCESS")) {
                    // CASE A: Vote Successful
                    response.sendRedirect("vote_success.jsp?status=SUCCESS&sid=" + studentId + "&cname=" + encodedName);
                
                } else if (result.equals("ALREADY_VOTED") || result.equals("LIMIT_REACHED")) {
                    // CASE B: Already Voted
                    // We send them to the same page, but with status=ALREADY_VOTED
                    response.sendRedirect("vote_success.jsp?status=ALREADY_VOTED&sid=" + studentId + "&cname=" + encodedName);
                
                } else if (result.equals("ALREADY_VOTED_FOR_THIS_CANDIDATE")) {
                    // CASE C: Duplicate Check (Safety)
                    response.sendRedirect("vote_success.jsp?status=ALREADY_VOTED&sid=" + studentId + "&cname=" + encodedName);
                
                } else {
                    // CASE D: System Error
                    response.sendRedirect("student_dashboard.jsp?error=System_Error_Please_try_again");
                }

            } catch (NumberFormatException e) {
                // ID was not a number
                response.sendRedirect("student_dashboard.jsp?error=Invalid_Candidate_Selection");
            } catch (Exception e) {
                // General error
                e.printStackTrace();
                response.sendRedirect("student_dashboard.jsp?error=Unexpected_Error");
            }
        } else {
            response.sendRedirect("student_dashboard.jsp?error=Please_select_a_candidate");
        }
    }
}