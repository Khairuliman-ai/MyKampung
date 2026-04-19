package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ActivityLog;
import util.DBUtil;

public class ActivityLogDAO {
    
    private Connection conn;
    
    public ActivityLogDAO(Connection conn) {
        this.conn = conn;
    }

    public void insertLog(ActivityLog log) {
        String query = "INSERT INTO log_aktiviti (id_pengguna, id_admin, jenis_tindakan, keterangan_tindakan) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, log.getId_pengguna());
            ps.setInt(2, log.getId_admin());
            ps.setString(3, log.getJenis_tindakan());
            ps.setString(4, log.getKeterangan_tindakan());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ActivityLog> getLogsByResidentId(int residentId) {
        List<ActivityLog> logs = new ArrayList<>();
        String query = "SELECT al.*, p.nama_penuh as admin_name " +
                       "FROM log_aktiviti al " +
                       "JOIN pengguna p ON al.id_admin = p.id_pengguna " +
                       "WHERE al.id_pengguna = ? " +
                       "ORDER BY al.dibuat_pada DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, residentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ActivityLog log = new ActivityLog();
                    log.setId_log(rs.getInt("id_log"));
                    log.setId_pengguna(rs.getInt("id_pengguna"));
                    log.setId_admin(rs.getInt("id_admin"));
                    log.setJenis_tindakan(rs.getString("jenis_tindakan"));
                    log.setKeterangan_tindakan(rs.getString("keterangan_tindakan"));
                    log.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    log.setAdminName(rs.getString("admin_name"));
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
}
