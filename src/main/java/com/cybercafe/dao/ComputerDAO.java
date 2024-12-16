package com.cybercafe.dao;

import com.cybercafe.model.Computer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComputerDAO {
    
    public List<Computer> getAllComputers() throws SQLException {
        List<Computer> computers = new ArrayList<>();
        String sql = "SELECT * FROM computers ORDER BY computer_number";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Computer computer = new Computer();
                computer.setId(rs.getInt("id"));
                computer.setComputerNumber(rs.getString("computer_number"));
                computer.setOccupied(rs.getBoolean("is_occupied"));
                computer.setHourlyRate(rs.getDouble("hourly_rate"));
                computers.add(computer);
            }
        }
        return computers;
    }
    
    public void updateComputerStatus(int computerId, boolean isOccupied) throws SQLException {
        String sql = "UPDATE computers SET is_occupied = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBoolean(1, isOccupied);
            pstmt.setInt(2, computerId);
            pstmt.executeUpdate();
        }
    }

    public void deleteComputer(int computerId) throws SQLException {
        String sql = "DELETE FROM computers WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, computerId);
            pstmt.executeUpdate();
        }
    }

    public void updateComputer(int computerId, String computerNumber, double hourlyRate) throws SQLException {
        String sql = "UPDATE computers SET computer_number = ?, hourly_rate = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, computerNumber);
            pstmt.setDouble(2, hourlyRate);
            pstmt.setInt(3, computerId);
            pstmt.executeUpdate();
        }
    }
}