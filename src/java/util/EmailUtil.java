package util;

import java.security.SecureRandom;
import java.util.Base64;
import java.sql.*;
import java.util.Properties;
import javax.mail.*; // Pastikan JAR sudah dimasukkan dalam Libraries
import javax.mail.internet.*;

public class EmailUtil {

    // 1. Method untuk jana OTP 6 digit
    public static String generateOTP() {
        SecureRandom random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    // 2. Method untuk simpan ke Database
    public static boolean saveTokenToDB(String email, String token) {
        boolean isSuccess = false;
        long expiryTimeMs = System.currentTimeMillis() + (30 * 60 * 1000);
        Timestamp expiryTimestamp = new Timestamp(expiryTimeMs);

        String sql = "UPDATE pengguna SET reset_token = ?, token_expiry = ? WHERE email = ?";

        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expiryTimestamp);
            ps.setString(3, email);
            isSuccess = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 3. Method untuk HANTAR EMEL (Guna App Password Google awak)
    public static void sendResetEmail(String recipientEmail, String token) {
        final String myEmail = "khairulworkmoney@gmail.com"; // GANTI EMEL AWAK
        final String appPassword = "qqxriajykuxyxiqp"; // GANTI 16 DIGIT APP PASSWORD

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(myEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            message.setSubject("Reset Kata Laluan - Sistem Pengurusan Kampung");

            message.setText("Sila gunakan Kod OTP di bawah untuk menetapkan semula kata laluan anda:\n\n" 
                          + "Kod OTP: " + token + "\n\n"
                          + "Kod ini akan luput dalam masa 10 minit.");

            Transport.send(message);
            System.out.println("Emel berjaya dihantar!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}