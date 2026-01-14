package com.election.model;

import java.io.Serializable;

/**
 * UserBean represents all users in the system (Student, Lecturer, Admin).
 */
public class UserBean implements Serializable {
    private String id;
    private String name;
    private String password;
    private String email;
    private String faculty;
    private String role; // 'student', 'lecturer', 'admin'
    private boolean voted; // Represents if the student has a record in the VOTE table

    public UserBean() {}

    // Identification
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    // Profile Details
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFaculty() { return faculty; }
    public void setFaculty(String faculty) { this.faculty = faculty; }

    // Access Control
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    // Voting Status Logic
    public boolean isVoted() { 
        return voted; 
    }
    
    public void setVoted(boolean voted) { 
        this.voted = voted; 
    }
}