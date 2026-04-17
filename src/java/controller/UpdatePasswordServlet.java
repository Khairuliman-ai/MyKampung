package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt; // Untuk hashing
import util.DBUtil;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String message = "";

        try (Connection conn = DBUtil.getConnection()) {
            
            // 1. Semak jika OTP sah dan belum tamat tempoh (expiry > current time)
            String sqlCheck = "SELECT email FROM pengguna WHERE email = ? AND reset_token = ? AND token_expiry > ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, email);
            psCheck.setString(2, otp);
            psCheck.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {

                // 2. Hash kata laluan baru guna BCrypt
                String hashedPw = BCrypt.hashpw(newPassword, BCrypt.gensalt());

                // 3. Kemaskini password dan kosongkan token (Security best practice)
                String sqlUpdate = "UPDATE pengguna SET kata_laluan = ?, reset_token = NULL, token_expiry = NULL WHERE email = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setString(1, hashedPw);
                psUpdate.setString(2, email);
                
                int rows = psUpdate.executeUpdate();
                if (rows > 0) {
                    message = "Kata laluan berjaya dikemaskini. Sila log masuk.";
                    request.setAttribute("notifikasi", message);
                    request.getRequestDispatcher("views/auth/auth.jsp").forward(request, response);
                    return;
                }
            } else {
                message = "Pautan tidak sah atau telah tamat tempoh.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "Ralat sistem: " + e.getMessage();
        }

        request.setAttribute("notifikasi", message);
        request.setAttribute("email", email);
        request.getRequestDispatcher("views/auth/verify_otp.jsp").forward(request, response);
    }
}