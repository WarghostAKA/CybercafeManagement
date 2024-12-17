package com.cybercafe.model;

import java.time.LocalDate;

public class DailyRevenue {
    private LocalDate date;
    private double theoreticalRevenue;
    private double actualRevenue;

    // Constructors
    public DailyRevenue() {}

    public DailyRevenue(LocalDate date, double theoreticalRevenue, double actualRevenue) {
        this.date = date;
        this.theoreticalRevenue = theoreticalRevenue;
        this.actualRevenue = actualRevenue;
    }

    // Getters and Setters
    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public double getTheoreticalRevenue() {
        return theoreticalRevenue;
    }

    public void setTheoreticalRevenue(double theoreticalRevenue) {
        this.theoreticalRevenue = theoreticalRevenue;
    }

    public double getActualRevenue() {
        return actualRevenue;
    }

    public void setActualRevenue(double actualRevenue) {
        this.actualRevenue = actualRevenue;
    }

    // Business Logic Methods
    public double getRevenueDifference() {
        return actualRevenue - theoreticalRevenue;
    }

    public double getRevenuePercentage() {
        return theoreticalRevenue == 0 ? 0 : (actualRevenue / theoreticalRevenue) * 100;
    }
}