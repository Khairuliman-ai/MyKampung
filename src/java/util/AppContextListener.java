package util;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * AppContextListener performs clean-up actions when the web application
 * is stopped or redeployed to prevent memory leaks and thread resource issues in Tomcat.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("MyKampung web application context initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("MyKampung web application context destroying. Starting resource cleanup...");

        // 1. Gracefully shut down the MySQL AbandonedConnectionCleanupThread using reflection
        try {
            Class<?> cleanupThreadClass = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
            java.lang.reflect.Method checkedShutdownMethod = cleanupThreadClass.getMethod("checkedShutdown");
            checkedShutdownMethod.invoke(null);
            System.out.println("MySQL AbandonedConnectionCleanupThread shut down successfully via reflection.");
        } catch (ClassNotFoundException e) {
            // Under older MySQL driver versions, it might be in a different package, or not used.
            try {
                Class<?> oldCleanupThreadClass = Class.forName("com.mysql.jdbc.AbandonedConnectionCleanupThread");
                java.lang.reflect.Method shutdownMethod = oldCleanupThreadClass.getMethod("shutdown");
                shutdownMethod.invoke(null);
                System.out.println("MySQL legacy AbandonedConnectionCleanupThread shut down successfully via reflection.");
            } catch (ClassNotFoundException ex) {
                System.out.println("MySQL AbandonedConnectionCleanupThread class not found (not using MySQL or driver registered at server level).");
            } catch (Exception ex) {
                System.err.println("Error shutting down legacy MySQL AbandonedConnectionCleanupThread: " + ex.getMessage());
            }
        } catch (Exception e) {
            System.err.println("Error shutting down MySQL AbandonedConnectionCleanupThread: " + e.getMessage());
        }

        // 2. Deregister JDBC drivers registered by this web app's classloader
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == getClass().getClassLoader()) {
                try {
                    DriverManager.deregisterDriver(driver);
                    System.out.println("Deregistered JDBC driver: " + driver);
                } catch (SQLException e) {
                    System.err.println("Error deregistering JDBC driver: " + e.getMessage());
                }
            }
        }
        System.out.println("Resource cleanup complete.");
    }
}
