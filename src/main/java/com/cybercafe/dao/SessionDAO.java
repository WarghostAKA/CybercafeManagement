package com.cybercafe.dao;

import com.cybercafe.model.Session;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SessionDAO {
    
    public void startSession(int computerId, int userId) throws SQLException {
        String sql = "INSERT INTO sessions (computer_id, user_id, start_time, is_active) VALUES (?, ?, ?, true)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, computerId);
            pstmt.setInt(2, userId);
            pstmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.executeUpdate();
        }
    }
    
    public void endSession(int sessionId, double totalCost) throws SQLException {
        String sql = "UPDATE sessions SET end_time = ?, total_cost = ?, is_active = false WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setDouble(2, totalCost);
            pstmt.setInt(3, sessionId);
            pstmt.executeUpdate();
        }
    }
    
    public Session getActiveSession(int computerId) throws SQLException {
        String sql = "SELECT s.*, c.computer_number, c.hourly_rate, u.username FROM sessions s " +
                    "JOIN computers c ON s.computer_id = c.id " +
                    "JOIN users u ON s.user_id = u.id " +
                    "WHERE s.computer_id = ? AND s.is_active = true";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, computerId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Session session = new Session();
                session.setId(rs.getInt("id"));
                session.setComputerId(rs.getInt("computer_id"));
                session.setUserId(rs.getInt("user_id"));
                session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                session.setActive(true);
                session.setComputerNumber(rs.getString("computer_number"));
                session.setHourlyRate(rs.getDouble("hourly_rate"));
                session.setUsername(rs.getString("username"));
                return session;
            }
        }
        return null;
    }

    public List<Session> getUserSessions(int userId) throws SQLException {
        String sql = "SELECT s.*, c.computer_number, c.hourly_rate, u.username FROM sessions s " +
                    "JOIN computers c ON s.computer_id = c.id " +
                    "JOIN users u ON s.user_id = u.id " +
                    "WHERE s.user_id = ? ORDER BY s.start_time DESC";
        
        List<Session> sessions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Session session = new Session();
                session.setId(rs.getInt("id"));
                session.setComputerId(rs.getInt("computer_id"));
                session.setUserId(userId);
                session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                if (rs.getTimestamp("end_time") != null) {
                    session.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                }
                session.setTotalCost(rs.getDouble("total_cost"));
                session.setActive(rs.getBoolean("is_active"));
                session.setComputerNumber(rs.getString("computer_number"));
                session.setHourlyRate(rs.getDouble("hourly_rate"));
                session.setUsername(rs.getString("username"));
                sessions.add(session);
            }
        }
        return sessions;
    }

    public List<Session> getAllSessions() throws SQLException {
        String sql = "SELECT s.*, c.computer_number, c.hourly_rate, u.username FROM sessions s " +
                    "JOIN computers c ON s.computer_id = c.id " +
                    "JOIN users u ON s.user_id = u.id " +
                    "ORDER BY s.start_time DESC";
        
        List<Session> sessions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Session session = new Session();
                session.setId(rs.getInt("id"));
                session.setComputerId(rs.getInt("computer_id"));
                session.setUserId(rs.getInt("user_id"));
                session.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                if (rs.getTimestamp("end_time") != null) {
                    session.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                }
                session.setTotalCost(rs.getDouble("total_cost"));
                session.setActive(rs.getBoolean("is_active"));
                session.setComputerNumber(rs.getString("computer_number"));
                session.setHourlyRate(rs.getDouble("hourly_rate"));
                session.setUsername(rs.getString("username"));
                sessions.add(session);
            }
        }
        return sessions;
    }

    public void deleteSession(int sessionId) throws SQLException {
        String sql = "DELETE FROM sessions WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sessionId);
            pstmt.executeUpdate();
        }
    }
    
    public void paySession(int sessionId) throws SQLException {
        String sql = "UPDATE sessions SET is_active = false WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, sessionId);
            pstmt.executeUpdate();
        }
    }
}