package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Aduan;
import util.DBUtil;

/**
 * AduanDAO handles database CRUD operations for the community complaint (aduan) system.
 * Supports transaction handling for state transitions and audit logging,
 * along with statistical data aggregation for analytics reporting.
 */
public class AduanDAO {

    /**
     * Base SELECT clause shared by all read queries. JOINs in:
     * - pengguna (complainant's full name as nama_penuh)
     * - kategori_aduan (category label as nama_kategori)
     * - pengguna p2 (assigned handler's name as nama_pengendali, LEFT JOIN because unassigned complaints have NULL id_pengendali)
     */
    private static final String BASE_SQL =
        "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
        "FROM aduan a " +
        "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
        "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
        "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna ";

    /**
     * Inserts a new complaint record into the database.
     * Initial status is set to 'SUBMITTED'.
     * 
     * @param aduan the complaint model to insert
     * @return true if insertion succeeded, false otherwise
     */
    public boolean insertAduan(Aduan aduan) {
        String sql = "INSERT INTO aduan (id_pengguna, id_kategori_aduan, tajuk, keterangan, status, keutamaan, gambar_aduan, id_pengendali) VALUES (?, ?, ?, ?, 'SUBMITTED', ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, aduan.getId_pengguna());
            ps.setInt(2, aduan.getId_kategori_aduan());
            ps.setString(3, aduan.getTajuk());
            ps.setString(4, aduan.getKeterangan());
            ps.setString(5, aduan.getKeutamaan() != null ? aduan.getKeutamaan() : "SEDERHANA");
            ps.setString(6, aduan.getGambar_aduan());
            if (aduan.getId_pengendali() != null) ps.setInt(7, aduan.getId_pengendali());
            else ps.setNull(7, Types.INTEGER);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves a single complaint by its ID, including mapped helper fields.
     * 
     * @param id the complaint ID
     * @return the populated complaint model, or null if not found
     */
    public Aduan getById(int id) {
        String sql = BASE_SQL + "WHERE a.id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all non-deleted complaints submitted by a specific resident.
     * 
     * @param idPengguna the resident's user ID
     * @return list of matching complaints sorted by date descending
     */
    public List<Aduan> getByPenduduk(int idPengguna) {
        List<Aduan> list = new ArrayList<>();
        String sql = BASE_SQL + "WHERE a.id_pengguna = ? AND a.dipadam_pada IS NULL ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
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
     * Retrieves non-deleted complaints assigned to a specific AJK officer,
     * or unassigned complaints in 'SUBMITTED' state.
     * 
     * @param idAJK the AJK officer's user ID
     * @return list of complaints sorted by date descending
     */
    public List<Aduan> getByPengendali(int idAJK) {
        List<Aduan> list = new ArrayList<>();
        String sql = BASE_SQL + "WHERE (a.id_pengendali = ? OR (a.id_pengendali IS NULL AND a.status = 'SUBMITTED')) " +
                     "AND a.dipadam_pada IS NULL ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAJK);
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
     * Retrieves the user ID of the AJK member assigned to a specific jawatan.
     * 
     * @param idJawatan the jawatan ID
     * @return the AJK user ID, or null if no one is assigned
     */
    public Integer getAJKIdByJawatan(int idJawatan) {
        String sql = "SELECT id_pengguna FROM ajk_jawatan WHERE id_jawatan = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idJawatan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id_pengguna");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves the contact details (full name and phone) of the AJK assigned to a jawatan.
     * Used for escalating issues or providing support contacts.
     * 
     * @param idJawatan the jawatan ID
     * @return string array where index 0 is full name and index 1 is phone number
     */
    public String[] getAJKDetailsByJawatan(int idJawatan) {
        String sql = "SELECT p.nama_penuh, p.nombor_telefon " +
                     "FROM pengguna p " +
                     "JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " +
                     "WHERE aj.id_jawatan = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idJawatan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new String[]{rs.getString("nama_penuh"), rs.getString("nombor_telefon")};
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new String[]{"Tiada AJK", ""};
    }

    /**
     * Retrieves all non-deleted complaints in the system.
     * Used primarily by the Ketua Kampung.
     * 
     * @return list of all complaints sorted by date descending
     */
    public List<Aduan> getAll() {
        List<Aduan> list = new ArrayList<>();
        String sql = BASE_SQL + "WHERE a.dipadam_pada IS NULL ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Non-transactional status update. Updates status and optional remarks column.
     * 
     * @param id the complaint ID
     * @param status the new status string
     * @param catatanField the DB column name to update remarks (e.g. 'catatan_ajk')
     * @param catatanValue the text of the remarks
     * @return true if updated successfully
     */
    public boolean updateStatus(int id, String status, String catatanField, String catatanValue) {
        String sql;
        if (catatanField != null && ("catatan_ajk".equals(catatanField) || "catatan_ketua".equals(catatanField) || "catatan_pentadbir".equals(catatanField))) {
            sql = "UPDATE aduan SET status = ?, " + catatanField + " = ?, dikemaskini_pada = NOW() WHERE id_aduan = ?";
        } else {
            sql = "UPDATE aduan SET status = ?, dikemaskini_pada = NOW() WHERE id_aduan = ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            if (catatanField != null && ("catatan_ajk".equals(catatanField) || "catatan_ketua".equals(catatanField) || "catatan_pentadbir".equals(catatanField))) {
                ps.setString(2, catatanValue);
                ps.setInt(3, id);
            } else {
                ps.setInt(2, id);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates complaint status and records a change log entry inside a single database transaction.
     * Enforces atomic consistency between the complaint table and log table.
     * 
     * @param id the complaint ID
     * @param status the destination status
     * @param catatanField the DB remarks column to update (e.g., 'catatan_ajk')
     * @param catatanValue the remarks text
     * @param idPelaku the user ID performing the change
     * @param logCatatan audit trail details
     * @return true if both operations committed successfully
     */
    public boolean updateStatusWithLog(int id, String status, String catatanField, String catatanValue, int idPelaku, String logCatatan) {
        String sqlUpdate;
        if (catatanField != null && ("catatan_ajk".equals(catatanField) || "catatan_ketua".equals(catatanField) || "catatan_pentadbir".equals(catatanField))) {
            sqlUpdate = "UPDATE aduan SET status = ?, " + catatanField + " = ?, dikemaskini_pada = NOW() WHERE id_aduan = ?";
        } else {
            sqlUpdate = "UPDATE aduan SET status = ?, dikemaskini_pada = NOW() WHERE id_aduan = ?";
        }
        String sqlGetOldStatus = "SELECT status FROM aduan WHERE id_aduan = ?";
        String sqlInsertLog = "INSERT INTO log_aduan (id_aduan, id_pelaku, status_lama, status_baru, catatan, dibuat_pada) VALUES (?, ?, ?, ?, ?, NOW())";

        Connection conn = null;
        PreparedStatement psGet = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psLog = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Read current status WITHIN the transaction to prevent TOCTOU race conditions
            String oldStatus = "SUBMITTED";
            psGet = conn.prepareStatement(sqlGetOldStatus);
            psGet.setInt(1, id);
            rs = psGet.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            }

            // Step 2: Apply the status change
            psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setString(1, status);
            if (catatanField != null && ("catatan_ajk".equals(catatanField) || "catatan_ketua".equals(catatanField) || "catatan_pentadbir".equals(catatanField))) {
                psUpdate.setString(2, catatanValue);
                psUpdate.setInt(3, id);
            } else {
                psUpdate.setInt(2, id);
            }
            int affected = psUpdate.executeUpdate();

            if (affected > 0) {
                // Step 3: Audit trail — log must succeed atomically with the status change
                psLog = conn.prepareStatement(sqlInsertLog);
                psLog.setInt(1, id);
                psLog.setInt(2, idPelaku);
                psLog.setString(3, oldStatus != null ? oldStatus : "SUBMITTED");
                psLog.setString(4, status);
                psLog.setString(5, logCatatan);
                psLog.executeUpdate();

                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (psGet != null) psGet.close(); } catch (SQLException e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (SQLException e) {}
            try { if (psLog != null) psLog.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    /**
     * Reopens a completed or rejected complaint.
     * Enforces the JKKK business rule of a maximum of 2 reopens directly in the update logic.
     * 
     * @param id the complaint ID
     * @param idPelaku the resident reopening the complaint
     * @param logCatatan audit explanation
     * @return true if reopened successfully (and reopen limit not exceeded)
     */
    public boolean reopenAduan(int id, int idPelaku, String logCatatan) {
        String sqlUpdate = "UPDATE aduan SET status = 'REOPENED', reopen_count = reopen_count + 1, dikemaskini_pada = NOW() WHERE id_aduan = ? AND reopen_count < 2";
        String sqlGetOldStatus = "SELECT status FROM aduan WHERE id_aduan = ?";
        String sqlInsertLog = "INSERT INTO log_aduan (id_aduan, id_pelaku, status_lama, status_baru, catatan, dibuat_pada) VALUES (?, ?, ?, 'REOPENED', ?, NOW())";

        Connection conn = null;
        PreparedStatement psGet = null;
        PreparedStatement psUpdate = null;
        PreparedStatement psLog = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Read current status WITHIN the transaction to prevent TOCTOU race conditions
            String oldStatus = "RESOLVED";
            psGet = conn.prepareStatement(sqlGetOldStatus);
            psGet.setInt(1, id);
            rs = psGet.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            }

            // Step 2: Apply status change and increment reopen count
            psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, id);
            int affected = psUpdate.executeUpdate();

            if (affected > 0) {
                // Step 3: Insert log record
                psLog = conn.prepareStatement(sqlInsertLog);
                psLog.setInt(1, id);
                psLog.setInt(2, idPelaku);
                psLog.setString(3, oldStatus != null ? oldStatus : "RESOLVED");
                psLog.setString(4, logCatatan);
                psLog.executeUpdate();

                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (psGet != null) psGet.close(); } catch (SQLException e) {}
            try { if (psUpdate != null) psUpdate.close(); } catch (SQLException e) {}
            try { if (psLog != null) psLog.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return false;
    }

    /**
     * Updates the filename of the uploaded resolution proof (bukti selesai).
     * 
     * @param idAduan the complaint ID
     * @param fileName resolution proof filename
     * @return true if updated successfully
     */
    public boolean updateBuktiSelesai(int idAduan, String fileName) {
        String sql = "UPDATE aduan SET bukti_selesai = ? WHERE id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fileName);
            ps.setInt(2, idAduan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Manually assigns an AJK handler (pengendali) to a complaint.
     * 
     * @param idAduan the complaint ID
     * @param idAJK user ID of the AJK member
     * @return true if updated successfully
     */
    public boolean assignPengendali(int idAduan, int idAJK) {
        String sql = "UPDATE aduan SET id_pengendali = ? WHERE id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAJK);
            ps.setInt(2, idAduan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Maps a single row from a ResultSet into an Aduan model object.
     */
    private Aduan mapRow(ResultSet rs) throws SQLException {
        Aduan a = new Aduan();
        a.setId_aduan(rs.getInt("id_aduan"));
        a.setId_pengguna(rs.getInt("id_pengguna"));
        a.setId_kategori_aduan(rs.getInt("id_kategori_aduan"));
        int pengendali = rs.getInt("id_pengendali");
        a.setId_pengendali(rs.wasNull() ? null : pengendali);
        a.setTajuk(rs.getString("tajuk"));
        a.setKeterangan(rs.getString("keterangan"));
        a.setStatus(rs.getString("status"));
        a.setKeutamaan(rs.getString("keutamaan"));
        a.setGambar_aduan(rs.getString("gambar_aduan"));
        a.setBukti_selesai(rs.getString("bukti_selesai"));
        a.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
        a.setCatatan_ajk(rs.getString("catatan_ajk"));
        a.setCatatan_ketua(rs.getString("catatan_ketua"));
        a.setReopen_count(rs.getInt("reopen_count"));
        a.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        a.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
        a.setDipadam_pada(rs.getTimestamp("dipadam_pada"));
        
        a.setNama_penuh(rs.getString("nama_penuh"));
        a.setNama_kategori(rs.getString("nama_kategori"));
        a.setNama_pengendali(rs.getString("nama_pengendali"));
        return a;
    }

    /**
     * Gathers counts of complaints grouped by their status.
     * Used for building analytics reports.
     * 
     * @return map of status strings to counts
     */
    public java.util.Map<String, Integer> getAduanSummaryStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        stats.put("SUBMITTED", 0);
        stats.put("UNDER_REVIEW_AJK", 0);
        stats.put("IN_PROGRESS_AJK", 0);
        stats.put("RESOLVED", 0);
        stats.put("REJECTED", 0);
        stats.put("CLOSED", 0);
        stats.put("REOPENED", 0);
        
        String sql = "SELECT status, COUNT(*) as count FROM aduan WHERE dipadam_pada IS NULL GROUP BY status";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                if (status != null) {
                    stats.put(status.toUpperCase(), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Gathers counts of complaints grouped by their category.
     * 
     * @return map of category names to counts
     */
    public java.util.Map<String, Integer> getAduanCategoryStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        String sql = "SELECT k.nama_kategori, COUNT(*) as count " +
                     "FROM aduan a " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "WHERE a.dipadam_pada IS NULL " +
                     "GROUP BY k.nama_kategori";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("nama_kategori"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Gathers counts of complaints grouped by their priority level.
     * 
     * @return map of priority levels to counts
     */
    public java.util.Map<String, Integer> getAduanPriorityStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        stats.put("RENDAH", 0);
        stats.put("SEDERHANA", 0);
        stats.put("TINGGI", 0);
        stats.put("KRITIKAL", 0);
        
        String sql = "SELECT keutamaan, COUNT(*) as count FROM aduan WHERE dipadam_pada IS NULL GROUP BY keutamaan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String p = rs.getString("keutamaan");
                if (p != null) {
                    stats.put(p.toUpperCase(), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Counts the total number of active/pending complaints.
     * Active means status is NOT in (RESOLVED, REJECTED, CLOSED).
     * 
     * @return total count of active complaints
     */
    public int countActiveAduan() {
        String sql = "SELECT COUNT(*) FROM aduan WHERE dipadam_pada IS NULL "
                   + "AND status NOT IN ('RESOLVED','REJECTED','CLOSED')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
