package dao;

import model.Pengguna;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;

/**
 * PenggunaDAO handles database CRUD operations for the user (Pengguna) domain.
 * This includes user registration, authentication, profile updates, role/jawatan assignments,
 * and retrieving socio-economic statistical distributions for analytics.
 */
public class PenggunaDAO {

    /**
     * Default constructor.
     */
    public PenggunaDAO() {}

    /**
     * Registers a new resident (Penduduk) in a pending status (2).
     * Enforces database transaction integrity: inserts the user record, retrieves
     * the auto-generated user ID, and assigns the default 'Penduduk' role (ID 4).
     * 
     * @param u the Pengguna model to register
     * @return true if both user and role mappings were inserted successfully
     * @throws SQLException if a database error occurs during insertion or rollback
     */
    public boolean daftarPengguna(Pengguna u) throws SQLException {
        boolean success = false;
        String sqlUser = "INSERT INTO pengguna (nama_penuh, nombor_kp, nombor_telefon, kata_laluan, "
                + "nama_jalan, daerah, nombor_poskod, bandar, negeri, tarikh_lahir, "
                + "lampiran_pengesahan, status, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlRole = "INSERT INTO pengguna_peranan (id_pengguna, id_peranan) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                ps1.setString(1, u.getNama_penuh());
                ps1.setString(2, u.getNombor_kp());
                ps1.setString(3, u.getNombor_telefon());
                ps1.setString(4, u.getKata_laluan());
                ps1.setString(5, u.getNama_jalan());
                ps1.setString(6, u.getDaerah());
                ps1.setString(7, u.getNombor_poskod());
                ps1.setString(8, u.getBandar());
                ps1.setString(9, u.getNegeri());
                ps1.setDate(10, new java.sql.Date(u.getTarikh_lahir().getTime()));
                ps1.setString(11, u.getLampiran_pengesahan());
                ps1.setInt(12, u.getStatus()); // Nilai 2 (Pending) dari Servlet
                ps1.setString(13, u.getEmail() != null ? u.getEmail() : u.getNombor_kp() + "@mykampung.com");

                int rows = ps1.executeUpdate();

                if (rows > 0) {
                    ResultSet rs = ps1.getGeneratedKeys();
                    if (rs.next()) {
                        int newUserId = rs.getInt(1);

                        try (PreparedStatement ps2 = conn.prepareStatement(sqlRole)) {
                            ps2.setInt(1, newUserId);
                            ps2.setInt(2, 4); // ID 4 = Penduduk
                            ps2.executeUpdate();
                        }
                    }
                    conn.commit();
                    success = true;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
        return success;
    }

    /**
     * Finds a user by their identity card number (nombor_kp).
     * Retrieves their associated role name and jawatan title in a single query.
     * Used primary for login authentication.
     * 
     * @param kp identity card number (cleaned)
     * @return populated Pengguna object, or null if not found
     */
    public Pengguna findByKP(String kp) {
        Pengguna user = null;
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan "
                + "FROM pengguna p "
                + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                + "WHERE p.nombor_kp = ? "
                + "ORDER BY r.id_peranan ASC LIMIT 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kp);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToPengguna(rs);
                    user.setKata_laluan(rs.getString("kata_laluan")); // Need for password check
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Retrieves a user by their ID, including their role and biro jawatan.
     * 
     * @param id the user ID
     * @return the populated user object, or null if not found
     */
    public Pengguna getPenggunaById(int id) {
        Pengguna user = null;
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan "
                + "FROM pengguna p "
                + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                + "WHERE p.id_pengguna = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToPengguna(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Updates a resident's own profile data, including socio-economic fields,
     * GPS coordinates, profile photo, and income verification proof.
     * 
     * @param u the user model containing updated data
     * @return true if update succeeded, false otherwise
     */
    public boolean updateProfil(Pengguna u) {
        String sql = "UPDATE pengguna SET nama_penuh=?, nombor_telefon=?, email=?, nama_jalan=?, daerah=?, "
                + "nombor_poskod=?, bandar=?, negeri=?, status_keluarga=?, pekerjaan=?, pendapatan=?, "
                + "latitude=?, longitude=?, foto_profil=?, pengesahan_pendapatan=? WHERE id_pengguna=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getNama_penuh());
            ps.setString(2, u.getNombor_telefon());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getNama_jalan());
            ps.setString(5, u.getDaerah());
            ps.setString(6, u.getNombor_poskod());
            ps.setString(7, u.getBandar());
            ps.setString(8, u.getNegeri());
            ps.setString(9, u.getStatus_keluarga());
            ps.setString(10, u.getPekerjaan());
            ps.setBigDecimal(11, u.getPendapatan());
            if (u.getLatitude() != null) ps.setDouble(12, u.getLatitude()); else ps.setNull(12, java.sql.Types.DECIMAL);
            if (u.getLongitude() != null) ps.setDouble(13, u.getLongitude()); else ps.setNull(13, java.sql.Types.DECIMAL);
            ps.setString(14, u.getFoto_profil());
            ps.setString(15, u.getPengesahan_pendapatan());
            ps.setInt(16, u.getId_pengguna());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates a subset of resident fields. Used by administrative users (AJK/Ketua)
     * when editing another resident's basic details.
     * 
     * @param u the user model containing updated details
     * @return true if updated successfully
     */
    public boolean updatePengguna(Pengguna u) {
        String sql = "UPDATE pengguna SET nombor_telefon=?, nama_jalan=?, bandar=?, "
                + "nombor_poskod=?, negeri=?, status_keluarga=? WHERE id_pengguna=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getNombor_telefon());
            ps.setString(2, u.getNama_jalan());
            ps.setString(3, u.getBandar());
            ps.setString(4, u.getNombor_poskod());
            ps.setString(5, u.getNegeri());
            ps.setString(6, u.getStatus_keluarga());
            ps.setInt(7, u.getId_pengguna());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates a user's password hash.
     * 
     * @param idPengguna the user ID
     * @param hashedNewPassword BCrypt hashed password
     * @return true if updated successfully
     */
    public boolean updatePassword(int idPengguna, String hashedNewPassword) {
        String sql = "UPDATE pengguna SET kata_laluan=? WHERE id_pengguna=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedNewPassword);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all active users who hold the default 'Penduduk' role.
     * 
     * @return list of active residents
     */
    public List<Pengguna> getAllActivePenduduk() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan FROM pengguna p "
            + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
            + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
            + "WHERE p.status = 1 AND r.id_peranan = 4";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Retrieves all active users in the system sorted by role hierarchy and name.
     * 
     * @return list of all active users
     */
    public List<Pengguna> getAllActiveUsers() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan, aj.id_jawatan FROM pengguna p "
                   + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                   + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                   + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                   + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                   + "WHERE p.status = 1 "
                   + "ORDER BY r.id_peranan ASC, p.nama_penuh ASC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Retrieves all active users holding the 'AJK Kampung' role.
     * 
     * @return list of active AJK members
     */
    public List<Pengguna> getAllAJK() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan, aj.id_jawatan FROM pengguna p "
            + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
            + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
            + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " 
            + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "   
            + "WHERE r.id_peranan = 3 AND p.status = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Maps a ResultSet row to a Pengguna domain model object.
     */
    private Pengguna mapResultSetToPengguna(ResultSet rs) throws SQLException {
        Pengguna p = new Pengguna();
        p.setId_pengguna(rs.getInt("id_pengguna"));
        p.setNombor_kp(rs.getString("nombor_kp"));
        p.setNama_penuh(rs.getString("nama_penuh"));
        p.setNombor_telefon(rs.getString("nombor_telefon"));
        p.setTarikh_lahir(rs.getDate("tarikh_lahir"));
        p.setStatus_keluarga(rs.getString("status_keluarga"));
        p.setPekerjaan(rs.getString("pekerjaan"));
        p.setPendapatan(rs.getBigDecimal("pendapatan"));
        p.setEmail(rs.getString("email"));
        p.setFoto_profil(rs.getString("foto_profil"));
        p.setNama_jalan(rs.getString("nama_jalan"));
        p.setDaerah(rs.getString("daerah"));
        p.setBandar(rs.getString("bandar"));
        p.setNombor_poskod(rs.getString("nombor_poskod"));
        p.setNegeri(rs.getString("negeri"));
        p.setStatus(rs.getInt("status"));
        p.setLampiran_pengesahan(rs.getString("lampiran_pengesahan"));
        p.setPengesahan_pendapatan(rs.getString("pengesahan_pendapatan"));

        try {
            p.setNama_peranan(rs.getString("nama_peranan"));
            p.setNama_jawatan(rs.getString("nama_jawatan"));
            p.setId_jawatan(rs.getInt("id_jawatan"));
        } catch (SQLException e) {
            // Intentionally swallowed: not all callers JOIN peranan/jawatan tables.
            // e.g., getAllActivePenduduk() only selects nama_peranan, not nama_jawatan.
            // These fields remain null in that context, which is the expected behavior.
        }

        double lat = rs.getDouble("latitude");
        p.setLatitude(rs.wasNull() ? null : lat);
        double lon = rs.getDouble("longitude");
        p.setLongitude(rs.wasNull() ? null : lon);

        return p;
    }
    
    /**
     * Retrieves all residents with status = 2 (Pending approval).
     * 
     * @return list of pending residents
     */
    public List<Pengguna> getPendingPenduduk() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan FROM pengguna p "
                   + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                   + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                   + "WHERE p.status = 2 AND r.id_peranan = 4";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }
    
    /**
     * Updates account status for a user.
     * 
     * @param idPengguna the user ID
     * @param statusBaru the new status value (0=Rejected, 1=Active, 2=Pending)
     * @return true if updated successfully
     */
    public boolean updateStatus(int idPengguna, int statusBaru) {
        String sql = "UPDATE pengguna SET status = ?, dikemaskini_pada = CURRENT_TIMESTAMP WHERE id_pengguna = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, statusBaru);
            ps.setInt(2, idPengguna);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Counts all active residents, including both registered users and un-registered family members.
     * 
     * @return total count of residents
     */
    public int countAll() {
        String sql = "SELECT "
                   + "(SELECT COUNT(*) FROM pengguna WHERE status = 1) + "
                   + "(SELECT COUNT(*) FROM ahli_keluarga ak "
                   + " WHERE (ak.nombor_kp IS NULL OR ak.nombor_kp = '' "
                   + "  OR ak.nombor_kp NOT IN (SELECT p.nombor_kp FROM pengguna p WHERE p.status = 1))) "
                   + "AS total";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Calculates the age distribution of all active users.
     * Groupings: Kanak-kanak (0-17), Belia (18-30), Dewasa (31-45), Pertengahan (46-60), Warga Emas (60+).
     * 
     * @return map of age group names to counts
     */
    public java.util.Map<String, Integer> getAgeDistribution() {
        java.util.Map<String, Integer> dist = new java.util.LinkedHashMap<>();
        dist.put("Kanak-kanak (0-17)", 0);
        dist.put("Belia (18-30)", 0);
        dist.put("Dewasa (31-45)", 0);
        dist.put("Pertengahan (46-60)", 0);
        dist.put("Warga Emas (60+)", 0);
        
        String sql = "SELECT " +
                     "  SUM(CASE WHEN age BETWEEN 0 AND 17 THEN 1 ELSE 0 END) as child, " +
                     "  SUM(CASE WHEN age BETWEEN 18 AND 30 THEN 1 ELSE 0 END) as youth, " +
                     "  SUM(CASE WHEN age BETWEEN 31 AND 45 THEN 1 ELSE 0 END) as adult, " +
                     "  SUM(CASE WHEN age BETWEEN 46 AND 60 THEN 1 ELSE 0 END) as mid, " +
                     "  SUM(CASE WHEN age > 60 THEN 1 ELSE 0 END) as senior " +
                     "FROM (" +
                     "  SELECT TIMESTAMPDIFF(YEAR, tarikh_lahir, CURDATE()) as age " +
                     "  FROM pengguna WHERE status = 1" +
                     ") as temp";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                dist.put("Kanak-kanak (0-17)", rs.getInt("child"));
                dist.put("Belia (18-30)", rs.getInt("youth"));
                dist.put("Dewasa (31-45)", rs.getInt("adult"));
                dist.put("Pertengahan (46-60)", rs.getInt("mid"));
                dist.put("Warga Emas (60+)", rs.getInt("senior"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dist;
    }

    /**
     * Calculates the monthly income distribution of all active users.
     * Groupings: < RM1,000, RM1,000 - RM2,500, RM2,500 - RM4,000, RM4,000 - RM6,000, > RM6,000.
     * 
     * @return map of income ranges to counts
     */
    public java.util.Map<String, Integer> getIncomeDistribution() {
        java.util.Map<String, Integer> dist = new java.util.LinkedHashMap<>();
        dist.put("< RM1,000", 0);
        dist.put("RM1,000 - RM2,500", 0);
        dist.put("RM2,500 - RM4,000", 0);
        dist.put("RM4,000 - RM6,000", 0);
        dist.put("> RM6,000", 0);
        
        String sql = "SELECT " +
                     "  SUM(CASE WHEN pendapatan < 1000 THEN 1 ELSE 0 END) as r1, " +
                     "  SUM(CASE WHEN pendapatan BETWEEN 1000 AND 2500 THEN 1 ELSE 0 END) as r2, " +
                     "  SUM(CASE WHEN pendapatan BETWEEN 2500 AND 4000 THEN 1 ELSE 0 END) as r3, " +
                     "  SUM(CASE WHEN pendapatan BETWEEN 4000 AND 6000 THEN 1 ELSE 0 END) as r4, " +
                     "  SUM(CASE WHEN pendapatan > 6000 THEN 1 ELSE 0 END) as r5 " +
                     "FROM pengguna WHERE status = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                dist.put("< RM1,000", rs.getInt("r1"));
                dist.put("RM1,000 - RM2,500", rs.getInt("r2"));
                dist.put("RM2,500 - RM4,000", rs.getInt("r3"));
                dist.put("RM4,000 - RM6,000", rs.getInt("r4"));
                dist.put("> RM6,000", rs.getInt("r5"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dist;
    }

    /**
     * Calculates the family status distribution of all active users.
     * Groupings (e.g. Single, Married, Widow, Divorced).
     * 
     * @return map of family status names to counts
     */
    public java.util.Map<String, Integer> getFamilyStatusDistribution() {
        java.util.Map<String, Integer> dist = new java.util.LinkedHashMap<>();
        String sql = "SELECT status_keluarga, COUNT(*) as count " +
                     "FROM pengguna WHERE status = 1 AND status_keluarga IS NOT NULL AND status_keluarga != '' " +
                     "GROUP BY status_keluarga";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                dist.put(rs.getString("status_keluarga"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dist;
    }

    /**
     * Calculates the average monthly income of all active users.
     * 
     * @return average income double value
     */
    public double getAverageIncome() {
        String sql = "SELECT AVG(pendapatan) FROM pengguna WHERE status = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Retrieves active user IDs belonging to a specific system role.
     * Used for routing targeted notifications.
     * 
     * @param namaPeranan role name (e.g., 'Ketua Kampung', 'AJK Kampung')
     * @return list of user IDs
     */
    public List<Integer> getIdsByPeranan(String namaPeranan) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT p.id_pengguna FROM pengguna p "
                   + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                   + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                   + "WHERE r.nama_peranan = ? AND p.status = 1 AND p.dipadam_pada IS NULL";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, namaPeranan);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("id_pengguna"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves active user IDs belonging to a specific JKKK biro jawatan.
     * Used for routing targeted notifications.
     * 
     * @param namaJawatan jawatan name (e.g., 'Biro Keselamatan', 'Biro Kebajikan & Sosial')
     * @return list of user IDs
     */
    public List<Integer> getIdsByJawatan(String namaJawatan) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT aj.id_pengguna FROM ajk_jawatan aj "
                   + "JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                   + "JOIN pengguna p ON aj.id_pengguna = p.id_pengguna "
                   + "WHERE j.nama_jawatan = ? AND p.status = 1 AND p.dipadam_pada IS NULL";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, namaJawatan);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("id_pengguna"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves all active, non-deleted user IDs in the system.
     * Used for broad notification dispatches.
     * 
     * @return list of user IDs
     */
    public List<Integer> getAllActiveIds() {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT id_pengguna FROM pengguna WHERE status = 1 AND dipadam_pada IS NULL";
        try (Connection connection = DBUtil.getConnection();
              PreparedStatement ps = connection.prepareStatement(sql);
              ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("id_pengguna"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
