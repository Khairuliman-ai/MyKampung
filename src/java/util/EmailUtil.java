package util;

import java.security.SecureRandom;
import java.sql.*;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

/**
 * EmailUtil handles email transmission and password-recovery token lifecycle logic.
 * Reads SMTP credentials dynamically from config.properties to send account status updates and OTP verification emails via Gmail.
 */
public class EmailUtil {

    /**
     * Generates a random 6-digit One-Time Password (OTP).
     * Uses SecureRandom for cryptographic safety.
     * 
     * @return a 6-digit OTP string
     */
    public static String generateOTP() {
        SecureRandom random = new SecureRandom();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }

    /**
     * Stores a password reset token in the database with an expiration timestamp set to 30 minutes in the future.
     * 
     * @param email the user's registered email
     * @param token the OTP reset token
     * @return true if the database update succeeded, false otherwise
     */
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

    /**
     * Loads SMTP configurations from the config.properties classpath resource.
     * 
     * @return populated Properties object
     */
    private static Properties loadEmailConfig() {
        Properties config = new Properties();
        try (java.io.InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input != null) {
                config.load(input);
            } else {
                System.err.println("Fail config.properties tidak dijumpai dalam classpath! Sila pastikan fail wujud.");
            }
        } catch (java.io.IOException e) {
            System.err.println("Ralat membaca fail config.properties: " + e.getMessage());
        }
        return config;
    }

    /**
     * Sends a password reset OTP verification email to the recipient.
     * Configures a TLS-based mail session to connect to Google SMTP on port 587.
     * 
     * @param recipientEmail the target user's email address
     * @param token the OTP string
     */
    public static void sendResetEmail(String recipientEmail, String token) {
        Properties emailConfig = loadEmailConfig();
        final String myEmail = emailConfig.getProperty("smtp.email", "YOUR_EMAIL_HERE");
        final String appPassword = emailConfig.getProperty("smtp.password", "YOUR_APP_PASSWORD_HERE");

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
                          + "Kod ini akan luput dalam masa 5 minit.");

            Transport.send(message);
            System.out.println("Emel berjaya dihantar!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    /**
     * Sends an email notification to a resident indicating whether their registration has been approved or rejected.
     * 
     * @param recipientEmail the resident's email
     * @param namaPenuh the resident's full name
     * @param isApproved true if approved, false if rejected
     */
    public static void sendRegistrationStatusEmail(String recipientEmail, String namaPenuh, boolean isApproved) {
        Properties emailConfig = loadEmailConfig();
        final String myEmail = emailConfig.getProperty("smtp.email", "YOUR_EMAIL_HERE");
        final String appPassword = emailConfig.getProperty("smtp.password", "YOUR_APP_PASSWORD_HERE");

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
            message.setFrom(new InternetAddress(myEmail, "Sistem MyKampung"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            
            String subject = isApproved ? "Pendaftaran DILULUSKAN - MyKampung" : "Pendaftaran DITOLAK - MyKampung";
            message.setSubject(subject);

            String statusMsg = isApproved ? "telah DILULUSKAN" : "telah DITOLAK";
            String actionMsg = isApproved ? "Anda kini boleh log masuk ke dalam sistem menggunakan Nombor KP dan kata laluan yang telah didaftarkan." 
                                        : "Maaf, permohonan anda tidak dapat diluluskan buat masa ini. Sila hubungi pihak pengurusan kampung untuk maklumat lanjut.";

            String content = "Assalamualaikum dan Salam Sejahtera,\n\n"
                           + "Hai " + namaPenuh + ",\n\n"
                           + "Status permohonan pendaftaran akaun MyKampung anda " + statusMsg + ".\n\n"
                           + actionMsg + "\n\n"
                           + "Terima Kasih,\n"
                           + "Pihak Pengurusan MyKampung";

            message.setText(content);

            Transport.send(message);
            System.out.println("Emel status pendaftaran berjaya dihantar ke: " + recipientEmail);

        } catch (Exception e) {
            System.err.println("Gagal menghantar emel: " + e.getMessage());
            e.printStackTrace();
        }
    }
}