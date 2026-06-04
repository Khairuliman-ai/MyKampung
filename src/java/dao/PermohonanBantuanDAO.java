package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PermohonanBantuan;

/**
 * PermohonanBantuanDAO handles database CRUD operations for the welfare assistance (Bantuan) system.
 * Manages the multi-stage application lifecycle (BARU -> MENUNGGU_AJK -> MENUNGGU_KETUA -> LULUS/DITOLAK),
 * along with eligibility score retrieval and analytics stats on welfare distribution.
 */
public class PermohonanBantuanDAO {
    private BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();

    /**
     * Retrieves all applications submitted by a specific resident.
     * 
     * @param idPenduduk user ID of the resident
     * @return list of assistance applications with populated attachments
     */
    public List<PermohonanBantuan> getByPenduduk(int idPenduduk) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenduduk);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        populateAttachments(list);
        return list;
    }

    /**
     * Retrieves applications submitted by a resident filtered by aid category.
     * 
     * @param idPenduduk user ID of the resident
     * @param kategori aid category (e.g. 'RASMI', 'KOMUNITI')
     * @return list of matching applications
     */
    public List<PermohonanBantuan> getByPendudukAndKategori(int idPenduduk, String kategori) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "WHERE pb.id_pengguna = ? AND b.jenis_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenduduk);
            ps.setString(2, kategori);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        populateAttachments(list);
        return list;
    }

    /**
     * Retrieves all applications in the system.
     * 
     * @return list of all applications
     */
    public List<PermohonanBantuan> getAll() {
        return getAllPaginated(0, Integer.MAX_VALUE);
    }

    /**
     * Retrieves paginated applications in the system. Includes complainant details.
     * 
     * @param offset database pagination offset
     * @param limit maximum records to retrieve
     * @return list of paginated applications
     */
    public List<PermohonanBantuan> getAllPaginated(int offset, int limit) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "ORDER BY pb.dibuat_pada DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    try {
                        pb.setNama_penuh(rs.getString("nama_penuh"));
                        pb.setNombor_kp(rs.getString("nombor_kp"));
                        pb.setNombor_telefon(rs.getString("nombor_telefon"));
                        pb.setStatus_keluarga(rs.getString("status_keluarga"));
                        pb.setPekerjaan(rs.getString("pekerjaan"));
                        pb.setPendapatan(rs.getDouble("pendapatan"));
                    } catch (SQLException e) {
                        // Expected: column not present when called from getByPenduduk() which doesn't JOIN pengguna
                    }
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        populateAttachments(list);
        return list;
    }

    /**
     * Retrieves applications matching a specific status. Includes user profile details.
     * 
     * @param status aid application status string
     * @return list of matching applications
     */
    public List<PermohonanBantuan> getByStatus(String status) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "WHERE pb.status = ? " +
                     "ORDER BY pb.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setNama_penuh(rs.getString("nama_penuh"));
                    pb.setNombor_kp(rs.getString("nombor_kp"));
                    pb.setNombor_telefon(rs.getString("nombor_telefon"));
                    pb.setStatus_keluarga(rs.getString("status_keluarga"));
                    pb.setPekerjaan(rs.getString("pekerjaan"));
                    pb.setPendapatan(rs.getDouble("pendapatan"));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        populateAttachments(list);
        return list;
    }

    /**
     * Retrieves historically processed applications (status != 'BARU') in a paginated manner.
     * 
     * @param offset pagination offset
     * @param limit maximum records
     * @return list of historical applications
     */
    public List<PermohonanBantuan> getSejarahPaginated(int offset, int limit) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "WHERE pb.status != 'BARU' " +
                     "ORDER BY pb.dibuat_pada DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setNama_penuh(rs.getString("nama_penuh"));
                    pb.setNombor_kp(rs.getString("nombor_kp"));
                    pb.setNombor_telefon(rs.getString("nombor_telefon"));
                    pb.setStatus_keluarga(rs.getString("status_keluarga"));
                    pb.setPekerjaan(rs.getString("pekerjaan"));
                    pb.setPendapatan(rs.getDouble("pendapatan"));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        populateAttachments(list);
        return list;
    }

    /**
     * Counts the total number of historically processed applications.
     * 
     * @return total count
     */
    public int getSejarahCount() {
        String sql = "SELECT COUNT(*) FROM permohonan_bantuan WHERE status != 'BARU'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves a single application by its ID.
     * 
     * @param idPermohonan the application ID
     * @return populated assistance application object, or null if not found
     */
    public PermohonanBantuan getById(int idPermohonan) {
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(idPermohonan));
                    return pb;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Deletes an application, but only if it belongs to the requesting resident.
     * 
     * @param idPermohonan the application ID
     * @param idPenduduk the resident's user ID
     * @return true if deletion succeeded
     */
    public boolean deleteByIdAndPenduduk(int idPermohonan, int idPenduduk) {
        String sql = "DELETE FROM permohonan_bantuan WHERE id_permohonan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            ps.setInt(2, idPenduduk);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Inserts a new assistance application with pre-calculated eligibility scores.
     * 
     * @param pb the application model containing request and eligibility details
     * @return the auto-generated database ID of the inserted application, or -1 if failed
     */
    public int insertPermohonan(PermohonanBantuan pb) {
        String flagsStr = "[]";
        if (pb.getEligibilityFlags() != null && !pb.getEligibilityFlags().isEmpty()) {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < pb.getEligibilityFlags().size(); i++) {
                sb.append("\"").append(pb.getEligibilityFlags().get(i)).append("\"");
                if (i < pb.getEligibilityFlags().size() - 1) sb.append(",");
            }
            sb.append("]");
            flagsStr = sb.toString();
        }
        String sql = "INSERT INTO permohonan_bantuan (id_pengguna, id_bantuan, catatan_pemohon, nama_bank, nombor_akaun, penyata_bank, dibuat_pada, status, eligibility_score, eligibility_tier, eligibility_flags) VALUES (?, ?, ?, ?, ?, ?, NOW(), 'BARU', ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pb.getId_pengguna());
            ps.setInt(2, pb.getId_bantuan());
            ps.setString(3, pb.getCatatan_pemohon());
            ps.setString(4, pb.getNama_bank());
            ps.setString(5, pb.getNombor_akaun());
            ps.setString(6, pb.getPenyata_bank());
            ps.setDouble(7, pb.getEligibilityScore() != null ? pb.getEligibilityScore() : 0.0);
            ps.setString(8, pb.getEligibilityTier() != null ? pb.getEligibilityTier() : "RENDAH");
            ps.setString(9, flagsStr);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Updates an existing application request, resetting its status back to 'BARU' for re-evaluation.
     * 
     * @param pb the application details
     * @return true if updated successfully
     */
    public boolean updatePermohonan(PermohonanBantuan pb) {
        String flagsStr = "[]";
        if (pb.getEligibilityFlags() != null && !pb.getEligibilityFlags().isEmpty()) {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < pb.getEligibilityFlags().size(); i++) {
                sb.append("\"").append(pb.getEligibilityFlags().get(i)).append("\"");
                if (i < pb.getEligibilityFlags().size() - 1) sb.append(",");
            }
            sb.append("]");
            flagsStr = sb.toString();
        }
        String sql = "UPDATE permohonan_bantuan SET id_bantuan = ?, catatan_pemohon = ?, nama_bank = ?, nombor_akaun = ?, penyata_bank = ?, status = 'BARU', eligibility_score = ?, eligibility_tier = ?, eligibility_flags = ?, dikemaskini_pada = NOW() WHERE id_permohonan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pb.getId_bantuan());
            ps.setString(2, pb.getCatatan_pemohon());
            ps.setString(3, pb.getNama_bank());
            ps.setString(4, pb.getNombor_akaun());
            ps.setString(5, pb.getPenyata_bank());
            ps.setDouble(6, pb.getEligibilityScore() != null ? pb.getEligibilityScore() : 0.0);
            ps.setString(7, pb.getEligibilityTier() != null ? pb.getEligibilityTier() : "RENDAH");
            ps.setString(8, flagsStr);
            ps.setInt(9, pb.getId_permohonan_bantuan());
            ps.setInt(10, pb.getId_pengguna());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the eligibility scores and reasons on an application.
     * 
     * @param idPermohonan the application ID
     * @param score computed eligibility score
     * @param tier computed eligibility tier label
     * @param flags JSON list of eligibility audit flags/rules triggered
     * @return true if updated successfully
     */
    public boolean updateEligibilityData(int idPermohonan, double score, String tier, List<String> flags) {
        String flagsStr = "[]";
        if (flags != null && !flags.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            for (int i = 0; i < flags.size(); i++) {
                sb.append("\"").append(flags.get(i)).append("\"");
                if (i < flags.size() - 1) sb.append(",");
            }
            sb.append("]");
            flagsStr = sb.toString();
        }
        String sql = "UPDATE permohonan_bantuan SET eligibility_score = ?, eligibility_tier = ?, eligibility_flags = ? WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, score);
            ps.setString(2, tier);
            ps.setString(3, flagsStr);
            ps.setInt(4, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the status of an application.
     * 
     * @param idPermohonan application ID
     * @param statusInt status index code (1=LULUS, 2=DIKEMBALIKAN, 3=MENUNGGU_KETUA, 4=DITOLAK)
     * @param ulasanAdmin evaluation remarks
     * @param dokumenSokongan legacy document attachment path (ignored by sql query)
     * @return true if updated successfully
     */
    public boolean updateStatus(int idPermohonan, int statusInt, String ulasanAdmin, String dokumenSokongan) {
        // Legacy mapping: Early forms submitted status as int codes (1=Approved, 2=Returned, etc.).
        // Retained for backward compatibility with the AJK review and Ketua decision forms.
        // TODO: Refactor forms to submit status strings directly and remove this mapping.
        String statusStr = "BARU";
        if (statusInt == 1) statusStr = "LULUS";
        else if (statusInt == 2) statusStr = "DIKEMBALIKAN";
        else if (statusInt == 3) statusStr = "MENUNGGU_KETUA";
        else if (statusInt == 4) statusStr = "DITOLAK";

        String sql = "UPDATE permohonan_bantuan SET status = ?, catatan_pentadbir = ?, dikemaskini_pada = NOW() WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusStr);
            ps.setString(2, ulasanAdmin);
            ps.setInt(3, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates basic application remarks.
     * 
     * @param idPermohonan application ID
     * @param catatan new remarks
     * @param dokumen legacy document parameter
     * @return true if updated successfully
     */
    public boolean updateInfo(int idPermohonan, String catatan, String dokumen) {
        String sql = "UPDATE permohonan_bantuan SET catatan_pemohon = ?, dikemaskini_pada = NOW() WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, catatan);
            ps.setInt(2, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Maps a ResultSet row to a PermohonanBantuan model object.
     */
    private PermohonanBantuan mapRow(ResultSet rs) throws SQLException {
        PermohonanBantuan pb = new PermohonanBantuan();
        pb.setId_permohonan(rs.getInt("id_permohonan"));
        pb.setId_pengguna(rs.getInt("id_pengguna"));
        pb.setId_bantuan(rs.getInt("id_bantuan"));
        pb.setDibuat_pada(rs.getDate("dibuat_pada"));
        pb.setDikemaskini_pada(rs.getDate("dikemaskini_pada"));
        pb.setDipadam_pada(rs.getDate("dipadam_pada"));
        pb.setStatus(rs.getString("status"));
        pb.setCatatan_pemohon(rs.getString("catatan_pemohon"));
        pb.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
        pb.setDokumen_pentadbir(rs.getString("dokumen_pentadbir"));
        
        try { pb.setNama_bank(rs.getString("nama_bank")); } catch (SQLException e) { /* Expected: Column not in all query contexts */ }
        try { pb.setNombor_akaun(rs.getString("nombor_akaun")); } catch (SQLException e) { /* Expected: Column not in all query contexts */ }
        try { pb.setPenyata_bank(rs.getString("penyata_bank")); } catch (SQLException e) { /* Expected: Column not in all query contexts */ }

        try {
            pb.setNama_bantuan(rs.getString("nama_bantuan"));
        } catch (SQLException e) { /* Expected: Column not in all query contexts */ }
        try {
            pb.setJenis_bantuan(rs.getString("jenis_bantuan"));
        } catch (SQLException e) { /* Expected: Column not in all query contexts */ }

        // Map eligibility fields from DB
        try { pb.setEligibilityScore(rs.getDouble("eligibility_score")); } catch (SQLException e) { /* Expected: Column not in all query contexts */ }
        try { pb.setEligibilityTier(rs.getString("eligibility_tier")); } catch (SQLException e) { /* Expected: Column not in all query contexts */ }
        try {
            String flagsStr = rs.getString("eligibility_flags");
            List<String> flags = new ArrayList<>();
            if (flagsStr != null && !flagsStr.isEmpty()) {
                flagsStr = flagsStr.replace("[", "").replace("]", "").replace("\"", "");
                for (String f : flagsStr.split(",")) {
                    String trimmed = f.trim();
                    if (!trimmed.isEmpty()) {
                        flags.add(trimmed);
                    }
                }
            }
            pb.setEligibilityFlags(flags);
        } catch (SQLException e) { /* Expected: Column not in all query contexts */ }

        return pb;
    }

    /**
     * Counts all assistance applications in the system.
     * 
     * @return total count
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM permohonan_bantuan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Gathers counts of assistance applications grouped by their status.
     * 
     * @return map of status names to counts
     */
    public java.util.Map<String, Integer> getBantuanSummaryStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        stats.put("BARU", 0);
        stats.put("MENUNGGU_KETUA", 0);
        stats.put("LULUS", 0);
        stats.put("DITOLAK", 0);
        stats.put("DIKEMBALIKAN", 0);
        
        String sql = "SELECT status, COUNT(*) as count FROM permohonan_bantuan GROUP BY status";
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
     * Gathers counts of assistance applications grouped by aid category.
     * 
     * @return map of aid types to counts
     */
    public java.util.Map<String, Integer> getBantuanTypeRatio() {
        java.util.Map<String, Integer> ratio = new java.util.LinkedHashMap<>();
        ratio.put("RASMI", 0);
        ratio.put("KOMUNITI", 0);
        
        String sql = "SELECT b.jenis_bantuan, COUNT(*) as count " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "GROUP BY b.jenis_bantuan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String type = rs.getString("jenis_bantuan");
                if (type != null) {
                    ratio.put(type.toUpperCase(), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ratio;
    }

    /**
     * Gathers counts of applications grouped by eligibility score brackets.
     * 
     * @return map of score range labels to counts
     */
    public java.util.Map<String, Integer> getBantuanScoreDistribution() {
        java.util.Map<String, Integer> dist = new java.util.LinkedHashMap<>();
        dist.put("0-20%", 0);
        dist.put("21-40%", 0);
        dist.put("41-60%", 0);
        dist.put("61-80%", 0);
        dist.put("81-100%", 0);
        
        String sql = "SELECT " +
                     "  SUM(CASE WHEN eligibility_score BETWEEN 0 AND 20 THEN 1 ELSE 0 END) as b1, " +
                     "  SUM(CASE WHEN eligibility_score BETWEEN 21 AND 40 THEN 1 ELSE 0 END) as b2, " +
                     "  SUM(CASE WHEN eligibility_score BETWEEN 41 AND 60 THEN 1 ELSE 0 END) as b3, " +
                     "  SUM(CASE WHEN eligibility_score BETWEEN 61 AND 80 THEN 1 ELSE 0 END) as b4, " +
                     "  SUM(CASE WHEN eligibility_score BETWEEN 81 AND 100 THEN 1 ELSE 0 END) as b5 " +
                     "FROM permohonan_bantuan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                dist.put("0-20%", rs.getInt("b1"));
                dist.put("21-40%", rs.getInt("b2"));
                dist.put("41-60%", rs.getInt("b3"));
                dist.put("61-80%", rs.getInt("b4"));
                dist.put("81-100%", rs.getInt("b5"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dist;
    }

    /**
     * Populates list of assistance applications with their dynamically loaded attachments.
     */
    private void populateAttachments(List<PermohonanBantuan> list) {
        if (list == null || list.isEmpty()) return;
        List<Integer> ids = new ArrayList<>();
        for (PermohonanBantuan pb : list) {
            ids.add(pb.getId_permohonan());
        }
        java.util.Map<Integer, List<model.BantuanLampiran>> map = lampiranDao.getByPermohonanIds(ids);
        for (PermohonanBantuan pb : list) {
            List<model.BantuanLampiran> sub = map.get(pb.getId_permohonan());
            pb.setSenaraiLampiran(sub != null ? sub : new ArrayList<>());
        }
    }
}