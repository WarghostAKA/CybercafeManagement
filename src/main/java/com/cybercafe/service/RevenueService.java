package com.cybercafe.service;

import com.cybercafe.dao.RevenueDAO;
import com.cybercafe.model.DailyRevenue;
import com.cybercafe.model.RevenueStatistics;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public class RevenueService {
    private final RevenueDAO revenueDAO;

    public RevenueService() {
        this.revenueDAO = new RevenueDAO();
    }

    public List<DailyRevenue> getAllRevenues() throws SQLException {
        return revenueDAO.getAllRevenues();
    }

    public List<DailyRevenue> getRevenuesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        return revenueDAO.getRevenuesByDateRange(startDate, endDate);
    }

    public RevenueStatistics calculateStatistics(List<DailyRevenue> revenues) {
        double totalTheoretical = revenues.stream()
                .mapToDouble(DailyRevenue::getTheoreticalRevenue)
                .sum();
        
        double totalActual = revenues.stream()
                .mapToDouble(DailyRevenue::getActualRevenue)
                .sum();
        
        double averageDaily = revenues.isEmpty() ? 0 : 
                revenues.stream()
                        .mapToDouble(DailyRevenue::getActualRevenue)
                        .average()
                        .orElse(0);

        return new RevenueStatistics(totalTheoretical, totalActual, averageDaily, revenues.size());
    }
}