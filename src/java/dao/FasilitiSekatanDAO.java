package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBUtil;

/**
 * FasilitiSekatanDAO handles database operations for facility restriction overrides (fasiliti_sekatan).
 * Restricts facility bookings on specific dates due to maintenance, events, or official closures.
 */
public class FasilitiSekatanDAO {

    /**
     * Checks if a facility has a restriction/maintenance block scheduled on a specific date.
     * 
     * @param idFasiliti the facility ID
     * @param tarikh the date to check
     * @return true if the facility is restricted/unavailable on that date, false otherwise
     */
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

    /**
     * Adds a new restriction/maintenance block for a facility on a specific date.
     * 
     * @param idFasiliti the facility ID
     * @param tarikh the date of restriction
     * @param sebab the reason for the restriction
     * @return true if the restriction was added successfully, false otherwise
     */
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
