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

        // 1. Gracefully shut down the MySQL AbandonedConnectionCleanupThread
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL AbandonedConnectionCleanupThread shut down successfully.");
        } catch (Throwable t) {
            System.err.println("Error shutting down MySQL AbandonedConnectionCleanupThread: " + t.getMessage());
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
