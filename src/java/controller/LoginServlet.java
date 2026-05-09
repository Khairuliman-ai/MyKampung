package controller;

import dao.PenggunaDAO;
import model.Pengguna;
import util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles user authentication (login process).
 * 
 * Responsibilities:
 * - Validate user credentials
 * - Verify password using BCrypt
 * - Manage user session
 * - Redirect authenticated users to dashboard
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    /**
     * Processes login request (POST).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = DBUtil.getConnection()) {

            /*
             * =========================
             * 1. INPUT PROCESSING
             * =========================
             */

            String kp = request.getParameter("nombor_kp");
            String passwordInput = request.getParameter("kata_laluan");

            // Normalize IC number by removing non-numeric characters
            String noKpClean = (kp != null) ? kp.replaceAll("[^0-9]", "") : "";

            /*
             * =========================
             * 2. USER AUTHENTICATION
             * =========================
             */

            PenggunaDAO dao = new PenggunaDAO(conn);
            Pengguna user = dao.findByKP(noKpClean);

            // Validate user existence and password hash
            boolean isAuthenticated = user != null && BCrypt.checkpw(passwordInput, user.getKata_laluan());

            if (!isAuthenticated) {
                request.setAttribute("errorMessage", "No. KP atau Kata Laluan salah.");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                return;
            }

            /*
             * =========================
             * 3. ACCOUNT STATUS CHECK
             * =========================
             */

            if (user.getStatus() != 1) {
                request.setAttribute("errorMessage", "Akaun anda belum diaktifkan. Sila semak emel anda untuk jika Setiausaha telah meluluskan atau menolak pendaftaran anda.");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                return;
            }

            /*
             * =========================
             * 4. SESSION CREATION
             * =========================
             */

            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            // Redirect authenticated user to dashboard
            response.sendRedirect("DashboardServlet");

        } catch (SQLException e) {

            /*
             * =========================
             * DATABASE ERROR HANDLING
             * =========================
             */

            e.printStackTrace();
            request.setAttribute("errorMessage", "Ralat sistem pangkalan data.");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }

    /**
     * Redirects GET request to login page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
    }
}