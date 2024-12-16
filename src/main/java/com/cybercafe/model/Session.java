package com.cybercafe.model;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class Session {
    private int id;
    private int computerId;
    private int userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private double totalCost;
    private boolean isActive;
    private String computerNumber;
    private double hourlyRate;
    private String username;  // Added username field

    public Session() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getComputerId() {
        return computerId;
    }

    public void setComputerId(int computerId) {
        this.computerId = computerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getComputerNumber() {
        return computerNumber;
    }

    public void setComputerNumber(String computerNumber) {
        this.computerNumber = computerNumber;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(double hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // Helper methods for JSP date formatting
    public Date getStartTimeAsDate() {
        return Date.from(startTime.atZone(ZoneId.systemDefault()).toInstant());
    }

    public Date getEndTimeAsDate() {
        return endTime != null ? Date.from(endTime.atZone(ZoneId.systemDefault()).toInstant()) : null;
    }

    public String getDuration() {
        if (endTime == null) return "";
        long hours = java.time.Duration.between(startTime, endTime).toHours();
        return String.valueOf(hours);
    }
}