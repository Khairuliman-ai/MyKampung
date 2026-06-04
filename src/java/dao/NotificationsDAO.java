package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Notifications;
import util.DBUtil;

/**
 * NotificationsDAO handles database CRUD operations for user notifications.
 * This includes inserting single notifications, batch inserts for broad distribution (e.g. roles/biros),
 * counting unread messages, and marking notifications as read.
 */
public class NotificationsDAO {

    /**
     * Inserts a single user notification into the database.
     * Sets the status to unread (sudah_baca = 0) and the creation timestamp to NOW().
     * 
     * @param n the notifications model to insert
     * @return true if the insert succeeded, false otherwise
     */
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

    /**
     * Retrieves a list of notifications for a specific user, ordered by creation date descending.
     * 
     * @param idPengguna the recipient user ID
     * @param limit maximum number of notifications to retrieve
     * @return list of Notifications
     */
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

    /**
     * Counts the number of unread notifications for a specific user.
     * 
     * @param idPengguna the user ID
     * @return unread notification count
     */
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

    /**
     * Marks a specific notification as read (sudah_baca = 1).
     * Enforces user ownership of the notification for security.
     * 
     * @param idNotification the notification ID
     * @param idPengguna the user ID
     * @return true if updated successfully, false otherwise
     */
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

    /**
     * Marks all unread notifications for a specific user as read.
     * 
     * @param idPengguna the user ID
     * @return true if any notifications were updated, false otherwise
     */
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

    /**
     * Performs a batch insert of a notification to multiple user IDs.
     * Utilizes JDBC batch updates inside a disabled auto-commit block for optimal performance and atomic commit.
     * 
     * @param ids list of target user IDs
     * @param jenis type of notification
     * @param tajuk title of notification
     * @param mesej message content
     * @param pautan URL path linked to the notification
     */
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

    /**
     * Maps a database result set row to a Notifications domain model.
     * 
     * @param rs the database ResultSet
     * @return the populated Notifications model
     * @throws SQLException if a database error occurs during mapping
     */
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
