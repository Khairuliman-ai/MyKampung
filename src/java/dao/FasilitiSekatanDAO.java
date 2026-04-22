package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBUtil;

public class FasilitiSekatanDAO {

    public boolean checkKetersediaanTarikh(int idFasiliti, Date tarikh) {
        String sql = "SELECT COUNT(*) FROM fasiliti_sekatan WHERE id_fasiliti = ? AND tarikh = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setDate(2, tarikh);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean tambahSekatan(int idFasiliti, Date tarikh, String sebab) {
        String sql = "INSERT INTO fasiliti_sekatan (id_fasiliti, tarikh, sebab) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setDate(2, tarikh);
            ps.setString(3, sebab);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
