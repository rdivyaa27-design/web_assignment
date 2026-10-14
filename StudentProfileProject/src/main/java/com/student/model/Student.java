package com.student.model;

import java.io.Serializable;

/**
 * Model class representing a Student entity.
 * Includes student profile details and associated uploaded file paths (photo & document).
 */
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String rollNumber;
    private String email;
    private String course;
    private String phone;
    private String photo;
    private String document;

    // Default constructor
    public Student() {
    }

    // Constructor without ID
    public Student(String name, String rollNumber, String email, String course, String phone, String photo, String document) {
        this.name = name;
        this.rollNumber = rollNumber;
        this.email = email;
        this.course = course;
        this.phone = phone;
        this.photo = photo;
        this.document = document;
    }

    // Full constructor with ID
    public Student(int id, String name, String rollNumber, String email, String course, String phone, String photo, String document) {
        this.id = id;
        this.name = name;
        this.rollNumber = rollNumber;
        this.email = email;
        this.course = course;
        this.phone = phone;
        this.photo = photo;
        this.document = document;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getDocument() {
        return document;
    }

    public void setDocument(String document) {
        this.document = document;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", rollNumber='" + rollNumber + '\'' +
                ", email='" + email + '\'' +
                ", course='" + course + '\'' +
                ", phone='" + phone + '\'' +
                ", photo='" + photo + '\'' +
                ", document='" + document + '\'' +
                '}';
    }
}
