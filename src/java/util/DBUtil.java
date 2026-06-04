package util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * DBUtil manages database connection pooling using JNDI InitialContext lookups.
 * Resolves the "jdbc/mykampung" DataSource configured in the application server's environment context.
 */
public class DBUtil {

    private static DataSource dataSource;

    static {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            dataSource = (DataSource) envCtx.lookup("jdbc/mykampung");
        } catch (Exception e) {
            System.err.println("DBUtil JNDI Initialization Error:");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize DataSource: " + e.getMessage(), e);
        }
    }

    /**
     * Obtains an active connection from the JNDI DataSource connection pool.
     * 
     * @return an active SQL Connection
     * @throws SQLException if a database access error occurs or pool limit is reached
     */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}