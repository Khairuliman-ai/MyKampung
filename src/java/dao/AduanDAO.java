package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Aduan;
import util.DBUtil;

public class AduanDAO {

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

    public Aduan getById(int id) {
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.id_aduan = ?";
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

    public List<Aduan> getByPenduduk(int idPengguna) {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.id_pengguna = ? AND a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
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

    public List<Aduan> getByPengendali(int idAJK) {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE (a.id_pengendali = ? OR (a.id_pengendali IS NULL AND a.status = 'SUBMITTED')) " +
                     "AND a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
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

    public List<Aduan> getAll() {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
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
     * Mengemaskini status aduan beserta rekod log aduan dalam satu transaksi atomik.
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

            // 1. Dapatkan status lama
            String oldStatus = "SUBMITTED";
            psGet = conn.prepareStatement(sqlGetOldStatus);
            psGet.setInt(1, id);
            rs = psGet.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            }

            // 2. Kemaskini status aduan
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
                // 3. Masukkan ke log aduan
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
     * Membuka semula (Reopen) aduan yang selesai/ditolak. Menambah kaunter reopen_count secara atomik.
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

            // 1. Dapatkan status lama
            String oldStatus = "RESOLVED";
            psGet = conn.prepareStatement(sqlGetOldStatus);
            psGet.setInt(1, id);
            rs = psGet.executeQuery();
            if (rs.next()) {
                oldStatus = rs.getString("status");
            }

            // 2. Kemaskini status dan tambah kaunter reopen
            psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, id);
            int affected = psUpdate.executeUpdate();

            if (affected > 0) {
                // 3. Masukkan ke log aduan
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
     * Mengemaskini fail bukti penyelesaian aduan
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
}

