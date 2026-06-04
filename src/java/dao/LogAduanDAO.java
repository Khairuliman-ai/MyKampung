package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.LogAduan;
import util.DBUtil;

/**
 * LogAduanDAO handles database CRUD operations for the complaint lifecycle history (log_aduan).
 * Tracks changes in complaint status, recording when transitions occurred and who authorized them.
 */
public class LogAduanDAO {
    
    /**
     * Inserts an audit trail log entry for a complaint status transition.
     * 
     * @param log the LogAduan model containing details of the status transition
     * @return true if insertion succeeded, false otherwise
     */
    public boolean insertLog(LogAduan log) {
        String sql = "INSERT INTO log_aduan (id_aduan, id_pelaku, status_lama, status_baru, catatan) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, log.getId_aduan());
            ps.setInt(2, log.getId_pelaku());
            ps.setString(3, log.getStatus_lama());
            ps.setString(4, log.getStatus_baru());
            ps.setString(5, log.getCatatan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Retrieves all lifecycle history logs recorded for a specific complaint, sorted chronologically.
     * Joins with the pengguna table to resolve the name of the user who made each change.
     * 
     * @param idAduan the complaint ID
     * @return list of LogAduan history entries
     */
    public List<LogAduan> getByAduan(int idAduan) {
        List<LogAduan> list = new ArrayList<>();
        String sql = "SELECT l.*, p.nama_penuh as nama_pelaku " +
                     "FROM log_aduan l " +
                     "JOIN pengguna p ON l.id_pelaku = p.id_pengguna " +
                     "WHERE l.id_aduan = ? " +
                     "ORDER BY l.dibuat_pada ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAduan);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LogAduan l = new LogAduan();
                    l.setId_log_aduan(rs.getInt("id_log_aduan"));
                    l.setId_aduan(rs.getInt("id_aduan"));
                    l.setId_pelaku(rs.getInt("id_pelaku"));
                    l.setStatus_lama(rs.getString("status_lama"));
                    l.setStatus_baru(rs.getString("status_baru"));
                    l.setCatatan(rs.getString("catatan"));
                    l.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    l.setNama_pelaku(rs.getString("nama_pelaku"));
                    list.add(l);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
