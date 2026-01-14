package com.election.controller;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.election.model.CandidateBean;

public class VoteDAO {

    // Database Connection Configuration
    private static final String JDBC_URL = "jdbc:derby://localhost:1527/StudentElection;create=true";
    private static final String JDBC_USER = "app";
    private static final String JDBC_PASS = "app";

    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
    }

    // ==========================================
    // 1. ADD CANDIDATE
    // ==========================================
    public boolean addCandidate(String studentId, String name, String slogan, String imagePath) {
        String sql = "INSERT INTO APP.CANDIDATE (STUDENTID, NAME, SLOGAN, IMAGE_PATH, APPROVED, VOTECOUNT, VOTES) VALUES (?, ?, ?, ?, FALSE, 0, 0)";
        
        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
             
            pst.setString(1, studentId);
            pst.setString(2, name);
            pst.setString(3, slogan);
            pst.setString(4, imagePath);
            
            int rows = pst.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==========================================
    // 2. GET PENDING CANDIDATES (For Admin Review)
    // ==========================================
    public List<CandidateBean> getPendingCandidates() {
        List<CandidateBean> list = new ArrayList<>();
        // Join with STUDENT to get FACULTY
        String sql = "SELECT c.CANDIDATEID, c.STUDENTID, c.NAME, c.SLOGAN, c.IMAGE_PATH, s.FACULTY " +
                     "FROM APP.CANDIDATE c " +
                     "JOIN APP.STUDENT s ON c.STUDENTID = s.STUDENTID " +
                     "WHERE c.APPROVED = FALSE";
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
             
            while (rs.next()) {
                CandidateBean c = new CandidateBean();
                c.setCandidateId(rs.getInt("CANDIDATEID"));
                c.setStudentId(rs.getString("STUDENTID"));
                c.setName(rs.getString("NAME"));
                c.setManifesto(rs.getString("SLOGAN"));      
                c.setImagePath(rs.getString("IMAGE_PATH"));  
                c.setFaculty(rs.getString("FACULTY"));       
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // 3. GET APPROVED CANDIDATES (For Dashboard Grid & Voting)
    // ==========================================
    public List<CandidateBean> getApprovedCandidates() {
        List<CandidateBean> list = new ArrayList<>();
        // Join with STUDENT to get FACULTY
        String sql = "SELECT c.CANDIDATEID, c.STUDENTID, c.NAME, c.SLOGAN, c.IMAGE_PATH, c.VOTECOUNT, s.FACULTY " +
                     "FROM APP.CANDIDATE c " +
                     "JOIN APP.STUDENT s ON c.STUDENTID = s.STUDENTID " +
                     "WHERE c.APPROVED = TRUE"; 
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
             
            while (rs.next()) {
                CandidateBean c = new CandidateBean();
                c.setCandidateId(rs.getInt("CANDIDATEID")); 
                c.setStudentId(rs.getString("STUDENTID"));
                c.setName(rs.getString("NAME"));
                // Map 'Slogan' to 'Manifesto' or 'Slogan' in bean depending on usage
                c.setManifesto(rs.getString("SLOGAN")); 
                c.setManifesto(rs.getString("SLOGAN"));
                c.setImagePath(rs.getString("IMAGE_PATH"));
                c.setVoteCount(rs.getInt("VOTECOUNT"));
                // Also set 'votes' if your bean has both fields
                c.setFaculty(rs.getString("FACULTY"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==========================================
    // 4. APPROVE CANDIDATE
    // ==========================================
    public boolean approveCandidate(int candidateId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); 

            // Update CANDIDATE table
            PreparedStatement pst1 = conn.prepareStatement("UPDATE APP.CANDIDATE SET APPROVED = TRUE WHERE CANDIDATEID = ?");
            pst1.setInt(1, candidateId);
            pst1.executeUpdate();

            // Get StudentID to update status in STUDENT table
            String studentId = "";
            PreparedStatement pstGetId = conn.prepareStatement("SELECT STUDENTID FROM APP.CANDIDATE WHERE CANDIDATEID = ?");
            pstGetId.setInt(1, candidateId);
            ResultSet rs = pstGetId.executeQuery();
            if (rs.next()) studentId = rs.getString("STUDENTID");

            // Update STUDENT status
            if (!studentId.isEmpty()) {
                PreparedStatement pst2 = conn.prepareStatement("UPDATE APP.STUDENT SET CANDIDACY_STATUS = 'APPROVED' WHERE STUDENTID = ?");
                pst2.setString(1, studentId);
                pst2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    // ==========================================
    // 5. CAST VOTE
    // ==========================================
    public String castVote(String studentId, int candidateId) {
    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false);

        // 1. CHECK LIMIT: Changed from 5 to 1
        PreparedStatement checkLimit = conn.prepareStatement("SELECT COUNT(*) FROM APP.VOTE WHERE STUDENTID = ?");
        checkLimit.setString(1, studentId);
        ResultSet rs1 = checkLimit.executeQuery();
        
        // If they have voted 1 or more times, stop them.
        if (rs1.next() && rs1.getInt(1) >= 1) {
            return "ALREADY_VOTED"; 
        }

        // (The duplicate check is technically redundant now, but you can keep it)

        // 2. INSERT VOTE
        PreparedStatement insertVote = conn.prepareStatement("INSERT INTO APP.VOTE (STUDENTID, CANDIDATEID) VALUES (?, ?)");
        insertVote.setString(1, studentId);
        insertVote.setInt(2, candidateId);
        insertVote.executeUpdate();

        // 3. UPDATE COUNT
        PreparedStatement updateCount = conn.prepareStatement("UPDATE APP.CANDIDATE SET VOTECOUNT = VOTECOUNT + 1 WHERE CANDIDATEID = ?");
        updateCount.setInt(1, candidateId);
        updateCount.executeUpdate();

        conn.commit(); 
        return "SUCCESS";

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return "ERROR";
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }

    // ==========================================
    // 6. GET TOTAL VOTES (For Stats)
    // ==========================================
    public int getTotalVotes() {
        int total = 0;
        try (Connection con = getConnection()) {
            String sql = "SELECT COUNT(*) FROM APP.VOTE";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // ==========================================
    // 7. CRUD: GET CANDIDATE BY ID (For Editing)
    // ==========================================
    public CandidateBean getCandidateById(int id) {
        CandidateBean c = null;
        try (Connection con = getConnection()) {
            // FIX: JOIN with STUDENT table to fetch FACULTY. 
            // The CANDIDATE table does not have a FACULTY column.
            String sql = "SELECT c.*, s.FACULTY FROM APP.CANDIDATE c " + 
                         "JOIN APP.STUDENT s ON c.STUDENTID = s.STUDENTID " + 
                         "WHERE c.CANDIDATEID = ?";
                         
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = new CandidateBean();
                c.setCandidateId(rs.getInt("CANDIDATEID"));
                c.setName(rs.getString("NAME"));
                c.setManifesto(rs.getString("SLOGAN"));
                c.setImagePath(rs.getString("IMAGE_PATH"));
                c.setFaculty(rs.getString("FACULTY")); 
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return c;
    }

    // ==========================================
    // 8. CRUD: UPDATE CANDIDATE
    // ==========================================
    public boolean updateCandidate(CandidateBean c) {
        try (Connection con = getConnection()) {
            String sql = "UPDATE APP.CANDIDATE SET NAME=?, SLOGAN=?, IMAGE_PATH=? WHERE CANDIDATEID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, c.getName());
            ps.setString(2, c.getManifesto());
            ps.setString(3, c.getImagePath());
            ps.setInt(4, c.getCandidateId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // ==========================================
    // 9. CRUD: DELETE CANDIDATE
    // ==========================================
    public boolean deleteCandidate(int id) {
        try (Connection con = getConnection()) {
            // Step 1: Delete votes associated with this candidate first (Foreign Key Constraint)
            String sqlVotes = "DELETE FROM APP.VOTE WHERE CANDIDATEID = ?";
            PreparedStatement ps1 = con.prepareStatement(sqlVotes);
            ps1.setInt(1, id);
            ps1.executeUpdate();

            // Step 2: Delete the candidate
            String sql = "DELETE FROM APP.CANDIDATE WHERE CANDIDATEID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
    // ==========================================
// 10. GET ALL CANDIDATES (Legacy/Voting Page Support)
// ==========================================
public List<CandidateBean> getAllCandidates() {
    // This simply calls the new method, so both names work.
    return getApprovedCandidates();
}
// Add to VoteDAO.java

// 11. GET ALL CANDIDATE STUDENT IDs (Helper for checking status)
public List<String> getAllCandidateStudentIds() {
    List<String> ids = new ArrayList<>();
    String sql = "SELECT STUDENTID FROM APP.CANDIDATE";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
         
        while (rs.next()) {
            ids.add(rs.getString("STUDENTID"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return ids;
}

// Add inside VoteDAO.java

// 12. GET RECENT VOTES (Log)
public List<String[]> getRecentVotes() {
    List<String[]> logs = new ArrayList<>();
    
    // Join Vote and Candidate tables to get readable names
    String sql = "SELECT v.STUDENTID, c.NAME " +
                 "FROM APP.VOTE v " +
                 "JOIN APP.CANDIDATE c ON v.CANDIDATEID = c.CANDIDATEID";
    
    try (Connection con = getConnection();
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {
         
        while (rs.next()) {
            // Store as a simple String array: [StudentID, CandidateName]
            String[] entry = new String[2];
            entry[0] = rs.getString("STUDENTID");
            entry[1] = rs.getString("NAME");
            logs.add(entry);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return logs;
}
    }

