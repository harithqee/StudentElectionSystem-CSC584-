package com.election.model;

import java.io.Serializable;

public class CandidateBean implements Serializable {
    
    private int candidateId;      // Unique ID for the candidate (Database Auto-Increment)
    private String studentId;     // Link to the student table
    private String name;
    private String faculty;
    private String manifesto;     // Slogan
    private String imagePath;     // Path to their profile picture
    private int voteCount;        // Total votes received

    // Default Constructor
    public CandidateBean() {
    }

    // --- Getters and Setters ---

    public int getCandidateId() {
        return candidateId;
    }

    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFaculty() {
        return faculty;
    }

    public void setFaculty(String faculty) {
        this.faculty = faculty;
    }

    public String getManifesto() {
        return manifesto;
    }

    public void setManifesto(String manifesto) {
        this.manifesto = manifesto;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }
}