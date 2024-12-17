package com.cybercafe.dao;

import com.cybercafe.model.DailyRevenue;
import com.cybercafe.util.DatabaseUtil;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RevenueDAO {
    
    public List<DailyRevenue> getAllRevenues() throws SQLException {
        String sql = "SELECT * FROM daily_revenue ORDER BY date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return mapResultSetToRevenues(rs);
        }
    }

    public List<DailyRevenue> getRevenuesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        String sql = "SELECT * FROM daily_revenue WHERE date BETWEEN ? AND ? ORDER BY date DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, Date.valueOf(startDate));
            pstmt.setDate(2, Date.valueOf(endDate));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                return mapResultSetToRevenues(rs);
            }
        }
    }

    private List<DailyRevenue> mapResultSetToRevenues(ResultSet rs) throws SQLException {
        List<DailyRevenue> revenues = new ArrayList<>();
        while (rs.next()) {
            DailyRevenue revenue = new DailyRevenue();
            revenue.setDate(rs.getDate("date").toLocalDate());
            revenue.setTheoreticalRevenue(rs.getDouble("theoretical_revenue"));
            revenue.setActualRevenue(rs.getDouble("actual_revenue"));
            revenues.add(revenue);
        }
        return revenues;
    }
}