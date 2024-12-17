package com.cybercafe.model;

public class RevenueStatistics {
    private final double totalTheoretical;
    private final double totalActual;
    private final double averageDaily;
    private final int totalRecords;

    public RevenueStatistics(double totalTheoretical, double totalActual, double averageDaily, int totalRecords) {
        this.totalTheoretical = totalTheoretical;
        this.totalActual = totalActual;
        this.averageDaily = averageDaily;
        this.totalRecords = totalRecords;
    }

    public double getTotalTheoretical() {
        return totalTheoretical;
    }

    public double getTotalActual() {
        return totalActual;
    }

    public double getAverageDaily() {
        return averageDaily;
    }

    public int getTotalRecords() {
        return totalRecords;
    }
}