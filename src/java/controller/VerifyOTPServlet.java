package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.DBUtil;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try (Connection conn = DBUtil.getConnection()) {
            // Semak jika OTP sah dan belum tamat tempoh
            String sql = "SELECT id_pengguna FROM pengguna WHERE email = ? AND reset_token = ? AND token_expiry > ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                out.print("{\"success\": true, \"message\": \"OTP sah.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Kod OTP tidak sah atau telah tamat tempoh.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"Ralat sistem.\"}");
        } finally {
            out.flush();
        }
    }
}
