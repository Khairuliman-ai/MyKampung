package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    // DB untuk CURSOR_
    private static final String URL = "jdbc:mysql://localhost:3306/s71383_mykampung";
    private static final String USER = "s71383";
    private static final String PASS = "dPtVvs0JQZYi";

    // DB untuk local
    // private static final String URL = "jdbc:mysql://localhost:3306/mykampung_v2_db?useSSL=false";
    // private static final String USER = "root";
    // private static final String PASS = "";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}