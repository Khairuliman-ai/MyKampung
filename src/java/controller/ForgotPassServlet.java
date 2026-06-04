package controller;

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
import util.DBUtil;
import util.EmailUtil;

@WebServlet("/ForgotPassServlet")
/**
 * ForgotPassServlet handles password recovery via a one-time password (OTP) flow.
 * 
 * <p><strong>OTP Recovery Flow:</strong></p>
 * <ol>
 *   <li>The system verifies that the submitted email and IC number match an active resident.</li>
 *   <li>Enforces a 2-minute rate limit since the last OTP generation to prevent email spam.</li>
 *   <li>Generates a secure 6-digit numeric OTP.</li>
 *   <li>Persists the OTP token in the database with a 5-minute expiry timestamp.</li>
 *   <li>Sends the OTP to the resident's registered email address via SMTP.</li>
 * </ol>
 */
public class ForgotPassServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String emailInput = request.getParameter("email");
        String icInput = request.getParameter("nombor_kp");
        
        // Bersihkan nombor_kp (buang sempang if any) supaya sepadan dengan DB (12 digit)
        if (icInput != null) {
            icInput = icInput.replace("-", "").trim();
        }
        
        String message = "Jika butiran tersebut wujud dalam sistem, kod OTP telah dihantar. Sila semak emel anda.";

        try (Connection conn = DBUtil.getConnection()) {
            
            // 1. Semak sama ada emel DAN nombor_kp wujud dan sepadan
            String sqlCheck = "SELECT id_pengguna, token_expiry FROM pengguna WHERE email = ? AND nombor_kp = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setString(1, emailInput);
            psCheck.setString(2, icInput);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Rate Limiting: Prevent OTP spamming by enforcing a 2-minute cooldown.
                // Expiry is set to 5 minutes, so subtracting 3 minutes gives the 2-minute limit.
                Timestamp currentExpiry = rs.getTimestamp("token_expiry");
                if (currentExpiry != null) {
                    long lastSentTime = currentExpiry.getTime() - (5 * 60 * 1000);
                    if (System.currentTimeMillis() < (lastSentTime + (2 * 60 * 1000))) {
                        response.setContentType("application/json");
                        response.getWriter().print("{\"success\": false, \"message\": \"Sila tunggu 2 minit sebelum meminta kod baru.\"}");
                        return;
                    }
                }

                // 3. Jana OTP (6 digit)
                String otp = EmailUtil.generateOTP();

                // 4. Tetapkan waktu tamat (Expiry) - 5 minit dari sekarang
                long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000);
                Timestamp expiryTimestamp = new Timestamp(expiryTime);

                // 5. Simpan token & expiry ke dalam database
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
            // Security: Intentionally return a generic success message even if an exception occurs
            // to prevent email enumeration attacks that reveal whether an email exists in the DB.
        }

        // 6. Hantar maklum balas JSON
        response.setContentType("application/json");
        response.getWriter().print("{\"success\": true, \"message\": \"Kod OTP telah dihantar ke emel anda.\", \"email\": \"" + emailInput + "\"}");
    }
}