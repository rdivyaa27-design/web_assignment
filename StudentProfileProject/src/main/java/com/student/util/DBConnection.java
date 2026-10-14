package com.student.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class to manage MySQL Database Connections using JDBC.
 * Configured for student_db.
 */
public class DBConnection {

    // Database Configuration Parameters
    // Modify these parameters according to your MySQL server installation.
    private static final String DB_HOST = "localhost";
    private static final String DB_PORT = "3306";
    private static final String DB_NAME = "student_db";
    
    // Default XAMPP/WAMP MySQL username is 'root'
    private static final String DB_USER = "root";
    
    // Configurable: By default in XAMPP, the root password is empty ("").
    // If you set a password for MySQL (e.g., MySQL Installer default 'root' or 'admin123'),
    // update this value accordingly.
    private static final String DB_PASSWORD = "2006";

    // JDBC URL with modern timezone and SSL flags
    private static final String JDBC_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME 
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    // MySQL Connector/J Driver Class Name
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            // Explicitly load MySQL JDBC Driver
            Class.forName(JDBC_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] ERROR: MySQL JDBC Driver not found in classpath.");
            e.printStackTrace();
        }
    }

    /**
     * Establishes and returns a new Connection to the MySQL database.
     * 
     * @return Connection object
     * @throws SQLException if connection fails
     * @throws ClassNotFoundException if JDBC driver class is missing
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Ensure driver is loaded
        Class.forName(JDBC_DRIVER);
        return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely closes an active database connection.
     * 
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("[DBConnection] Error closing connection: " + e.getMessage());
            }
        }
    }

    /**
     * Quick helper to test database connectivity.
     * 
     * @return true if connection succeeds, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            System.err.println("[DBConnection] Connection test failed: " + e.getMessage());
            return false;
        }
    }
}
