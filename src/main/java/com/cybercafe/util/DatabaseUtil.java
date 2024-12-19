package com.cybercafe.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    private static final String URL = "jdbc.url=jdbc:mysql://localhost:3306/cybercafe_db?useUnicode=true&characterEncoding=gb2312";
    private static final String USER = "root";
    private static final String PASSWORD = "313268";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
    }
}