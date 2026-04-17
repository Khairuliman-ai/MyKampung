package controller; // Pastikan nama package sesuai dengan struktur projek awak

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Base64;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBUtil; // Import class connection awak
import util.EmailUtil;      // Import class hantar emel awak

@WebServlet("/ForgotPassServlet")
public class ForgotPassServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String emailInput = request.getParameter("email");
        String message = "Jika emel tersebut wujud dalam sistem, pautan reset telah dihantar. Sila semak peti masuk anda.";

        try (Connection conn = DBUtil.getConnection()) {
            
            // 1. Semak sama ada emel wujud dalam pangkalan data
            String sqlCheck = "SELECT id_pengguna FROM pengguna WHERE email = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, emailInput);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // 2. Jika wujud, jana OTP (6 digit)
                String otp = EmailUtil.generateOTP();

                // 3. Tetapkan waktu tamat (Expiry) - 10 minit dari sekarang
                long expiryTime = System.currentTimeMillis() + (10 * 60 * 1000);
                Timestamp expiryTimestamp = new Timestamp(expiryTime);

                // 4. Simpan token & expiry ke dalam database
                String sqlUpdate = "UPDATE pengguna SET reset_token = ?, token_expiry = ? WHERE email = ?";
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setString(1, otp);
                psUpdate.setTimestamp(2, expiryTimestamp);
                psUpdate.setString(3, emailInput);
                psUpdate.executeUpdate();

                // 5. Hantar emel menggunakan Gmail SMTP
                EmailUtil.sendResetEmail(emailInput, otp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Walaupun error, kita tak nak dedahkan ralat DB kepada user
        }

        // 6. Hantar maklum balas kepada pengguna dan redirect ke verify_otp.jsp
        request.setAttribute("notifikasi", message);
        request.setAttribute("email", emailInput);
        request.getRequestDispatcher("views/auth/verify_otp.jsp").forward(request, response);
    }
}