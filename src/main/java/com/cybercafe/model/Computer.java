package com.cybercafe.model;

public class Computer {
    private int id;
    private String computerNumber;
    private boolean isOccupied;
    private double hourlyRate;

    public Computer() {}

    public Computer(int id, String computerNumber, boolean isOccupied, double hourlyRate) {
        this.id = id;
        this.computerNumber = computerNumber;
        this.isOccupied = isOccupied;
        this.hourlyRate = hourlyRate;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getComputerNumber() {
        return computerNumber;
    }

    public void setComputerNumber(String computerNumber) {
        this.computerNumber = computerNumber;
    }

    public boolean isOccupied() {
        return isOccupied;
    }

    public void setOccupied(boolean occupied) {
        isOccupied = occupied;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(double hourlyRate) {
        this.hourlyRate = hourlyRate;
    }
}