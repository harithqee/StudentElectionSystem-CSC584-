package com.election.controller;

import com.election.model.UserBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // 1. Derby Configuration
    private static final String JDBC_URL = "jdbc:derby://localhost:1527/StudentElection;create=true";
    private static final String JDBC_USER = "app";
    private static final String JDBC_PASS = "app";

    // 2. Connection Helper
    private Connection getConnection() throws Exception {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        return DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASS);
    }

    // ==========================================
    // SECTION 1: AUTHENTICATION & REGISTRATION
    // ==========================================

    public UserBean authenticateUser(String username, String password, String role) {
        UserBean user = null;
        String sql = "";

        if (role.equals("student")) {
            sql = "SELECT * FROM Student WHERE studentId=? AND password=?";
        } else if (role.equals("lecturer")) {
            sql = "SELECT * FROM Lecturer WHERE LecturerID=? AND password=?";
        } else if (role.equals("admin")) {
            sql = "SELECT * FROM Admin WHERE adminID=? AND password=?";
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setString(1, username);
            pst.setString(2, password);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    user = new UserBean();
                    user.setRole(role);
                    user.setPassword(password);
                    
                    if (role.equals("student")) {
                        user.setId(rs.getString("studentId"));
                        user.setName(rs.getString("studentName"));
                        user.setFaculty(rs.getString("faculty"));
                    } else if (role.equals("lecturer")) {
                        user.setId(rs.getString("LecturerID"));
                        user.setName(rs.getString("lecturerName"));
                        user.setFaculty(rs.getString("faculty"));
                    } else if (role.equals("admin")) {
                        user.setId(rs.getString("adminID"));
                        user.setName(rs.getString("name"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public String registerUser(UserBean user) {
        String sql = "";
        
        if (user.getRole().equals("student")) {
            sql = "INSERT INTO Student (studentId, studentName, email, faculty, password) VALUES (?, ?, ?, ?, ?)";
        } else if (user.getRole().equals("lecturer")) {
            sql = "INSERT INTO Lecturer (LecturerID, lecturerName, email, faculty, password) VALUES (?, ?, ?, ?, ?)";
        } else if (user.getRole().equals("admin")) {
            sql = "INSERT INTO Admin (adminID, name, email, password) VALUES (?, ?, ?, ?)";
        }

        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            if (user.getRole().equals("admin")) {
                pst.setString(1, user.getId());
                pst.setString(2, user.getName());
                pst.setString(3, user.getEmail());
                pst.setString(4, user.getPassword());
            } else {
                pst.setString(1, user.getId());
                pst.setString(2, user.getName());
                pst.setString(3, user.getEmail());
                pst.setString(4, user.getFaculty());
                pst.setString(5, user.getPassword());
            }

            pst.executeUpdate();
            return "SUCCESS";

        } catch (SQLIntegrityConstraintViolationException e) {
            return "ID already exists!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Database Error: " + e.getMessage();
        }
    }

    // ==========================================
    // SECTION 2: CANDIDATE APPOINTMENT (ADMIN)
    // ==========================================

    // Search for students who are NOT candidates yet (Status is NULL or NONE)
    public List<UserBean> searchStudents(String query) {
        List<UserBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Student WHERE (studentId LIKE ? OR studentName LIKE ?) AND (candidacy_status IS NULL OR candidacy_status = 'NONE')";
        
        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
             
            pst.setString(1, "%" + query + "%");
            pst.setString(2, "%" + query + "%");
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    UserBean s = new UserBean();
                    s.setId(rs.getString("studentId"));
                    s.setName(rs.getString("studentName"));
                    s.setFaculty(rs.getString("faculty"));
                    list.add(s);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // Update student status to 'APPOINTIED'
    public boolean appointStudent(String studentId) {
        String sql = "UPDATE Student SET candidacy_status = 'APPOINTED' WHERE studentId = ?";
        try (Connection conn = getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setString(1, studentId);
            int rows = pst.executeUpdate();
            return rows > 0;
            
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false;
        }
    }
    
    // Add this inside UserDAO.java

public String getCandidacyStatus(String studentId) {
    String status = "NONE";
    String sql = "SELECT candidacy_status FROM Student WHERE studentId = ?";
    
    try (Connection conn = getConnection();
         PreparedStatement pst = conn.prepareStatement(sql)) {
         
        pst.setString(1, studentId);
        try (ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                String s = rs.getString("candidacy_status");
                if (s != null) status = s;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return status;
}

// Add this inside UserDAO.java

public boolean updateStudentStatus(String studentId, String newStatus) {
    String sql = "UPDATE Student SET candidacy_status = ? WHERE studentId = ?";
    try (java.sql.Connection conn = getConnection();
         java.sql.PreparedStatement pst = conn.prepareStatement(sql)) {
        
        pst.setString(1, newStatus);
        pst.setString(2, studentId);
        int rows = pst.executeUpdate();
        return rows > 0;
        
    } catch (Exception e) { 
        e.printStackTrace(); 
        return false;
    }
}
// Add this inside UserDAO.java

public List<UserBean> getNonCandidateStudents() {
        List<UserBean> list = new ArrayList<>();
        String sql = "SELECT s.*, " +
                     "(SELECT COUNT(*) FROM APP.VOTE v WHERE v.STUDENTID = s.STUDENTID) as vote_count " +
                     "FROM APP.STUDENT s " 
                     ;
        
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                UserBean user = new UserBean();
                user.setId(rs.getString("STUDENTID"));
                user.setName(rs.getString("STUDENTNAME"));
                user.setFaculty(rs.getString("FACULTY"));
                user.setEmail(rs.getString("EMAIL"));
                user.setVoted(rs.getInt("vote_count") > 0);
                list.add(user);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
// Add to com.election.controller.UserDAO.java

// 1. CREATE: Add a new student
// Inside com.election.controller.UserDAO

public boolean addStudent(UserBean user) {
    // SQL: We must include PASSWORD and ROLE, even if the form didn't send them
    String sql = "INSERT INTO APP.USERS (ID, NAME, PASSWORD, ROLE, FACULTY, EMAIL) VALUES (?, ?, ?, ?, ?, ?)";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, user.getId());
        ps.setString(2, user.getName());
        
        // 1. Set Default Password (same as ID)
        ps.setString(3, user.getId()); 
        
        // 2. Set Default Role
        ps.setString(4, "student"); 
        
        ps.setString(5, user.getFaculty());
        ps.setString(6, user.getEmail());
        
        int rows = ps.executeUpdate();
        return rows > 0;
        
    } catch (Exception e) {
        e.printStackTrace(); // Check NetBeans Output window for specific SQL errors
        return false;
    }
}

// 2. READ (Single): Get student by ID (for editing)
public UserBean getStudentById(String id) {
    UserBean u = null;
    String sql = "SELECT * FROM APP.STUDENT WHERE STUDENTID = ?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
         
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            u = new UserBean();
            u.setId(rs.getString("STUDENTID"));
            u.setName(rs.getString("STUDENTNAME"));
            u.setFaculty(rs.getString("FACULTY"));
            u.setEmail(rs.getString("EMAIL"));
            u.setRole(rs.getString("ROLE"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return u;
}

// 3. UPDATE: Save changes to student
public boolean updateStudent(UserBean user) {
    String sql = "UPDATE APP.STUDENT SET STUDENTNAME=?, FACULTY=?, EMAIL=? WHERE STUDENTID=?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
         
        ps.setString(1, user.getName());
        ps.setString(2, user.getFaculty());
        ps.setString(3, user.getEmail());
        ps.setString(4, user.getId());
        
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

// 4. DELETE: Remove student
public boolean deleteStudent(String id) {
    String sql = "DELETE FROM APP.STUDENT WHERE STUDENTID = ?";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
         
        ps.setString(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
public List<UserBean> getAllStudents() {
    List<UserBean> list = new ArrayList<>();
    // SQL: Get all students EXCEPT those who are already candidates
    String sql = "SELECT * FROM APP.STUDENT ";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
         
        while (rs.next()) {
            UserBean user = new UserBean();
            user.setId(rs.getString("STUDENTID"));
            user.setName(rs.getString("STUDENTNAME")); // Ensure column matches your DB (STUDENTNAME or NAME)
            user.setFaculty(rs.getString("FACULTY"));
            user.setEmail(rs.getString("EMAIL"));
            list.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
