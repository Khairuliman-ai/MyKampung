package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Notifications;
import util.DBUtil;

public class NotificationsDAO {

    public boolean insertNotifications(Notifications n) {
        String sql = "INSERT INTO notifikasi (id_pengguna, jenis, tajuk, mesej, pautan, sudah_baca, dibuat_pada) "
                   + "VALUES (?, ?, ?, ?, ?, 0, NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, n.getId_pengguna());
            ps.setString(2, n.getJenis());
            ps.setString(3, n.getTajuk());
            ps.setString(4, n.getMesej());
            ps.setString(5, n.getPautan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Notifications> getByPengguna(int idPengguna, int limit) {
        List<Notifications> list = new ArrayList<>();
        String sql = "SELECT * FROM notifikasi WHERE id_pengguna = ? ORDER BY dibuat_pada DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countBelumBaca(int idPengguna) {
        String sql = "SELECT COUNT(*) FROM notifikasi WHERE id_pengguna = ? AND sudah_baca = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean tandaBaca(int idNotification, int idPengguna) {
        String sql = "UPDATE notifikasi SET sudah_baca = 1 WHERE id_notifikasi = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idNotification);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean tandaSemuaBaca(int idPengguna) {
        String sql = "UPDATE notifikasi SET sudah_baca = 1 WHERE id_pengguna = ? AND sudah_baca = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertBatch(List<Integer> ids, String jenis, String tajuk, String mesej, String pautan) {
        if (ids == null || ids.isEmpty()) return;
        String sql = "INSERT INTO notifikasi (id_pengguna, jenis, tajuk, mesej, pautan, sudah_baca, dibuat_pada) "
                   + "VALUES (?, ?, ?, ?, ?, 0, NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            for (int id : ids) {
                ps.setInt(1, id);
                ps.setString(2, jenis);
                ps.setString(3, tajuk);
                ps.setString(4, mesej);
                ps.setString(5, pautan);
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Notifications mapRow(ResultSet rs) throws SQLException {
        Notifications n = new Notifications();
        n.setId_notification(rs.getInt("id_notifikasi"));
        n.setId_pengguna(rs.getInt("id_pengguna"));
        n.setJenis(rs.getString("jenis"));
        n.setTajuk(rs.getString("tajuk"));
        n.setMesej(rs.getString("mesej"));
        n.setPautan(rs.getString("pautan"));
        n.setSudah_baca(rs.getInt("sudah_baca") == 1);
        n.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        return n;
    }
}
