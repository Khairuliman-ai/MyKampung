package dao;

import model.Pengguna;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PenggunaDAO {

    private Connection conn;

    public PenggunaDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Mendaftar pengguna baru (Penduduk) dengan status Pending (2). Menggunakan
     * Transaction untuk insert ke table pengguna & pengguna_peranan.
     */
    public boolean daftarPengguna(Pengguna u) throws SQLException {
    boolean success = false;
    String sqlUser = "INSERT INTO pengguna (nama_penuh, nombor_kp, nombor_telefon, kata_laluan, "
            + "nama_jalan, daerah, nombor_poskod, bandar, negeri, tarikh_lahir, "
            + "lampiran_pengesahan, status, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    String sqlRole = "INSERT INTO pengguna_peranan (id_pengguna, id_peranan) VALUES (?, ?)";

    // Mulakan Transaction - sangat penting supaya jika ps2 gagal, ps1 tidak akan disimpan
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
                // Ambil ID pengguna yang baru dicipta oleh database (Auto Increment)
                ResultSet rs = ps1.getGeneratedKeys();
                if (rs.next()) {
                    int newUserId = rs.getInt(1);

                    try (PreparedStatement ps2 = conn.prepareStatement(sqlRole)) {
                        ps2.setInt(1, newUserId);
                        // KEMASKINI: Tukar kepada 4 mengikut table 'peranan' anda (ID 4 = Penduduk)
                        ps2.setInt(2, 4); 
                        ps2.executeUpdate();
                    }
                }
                
                // Jika sampai ke sini tanpa ralat, barulah simpan data secara kekal
                conn.commit(); 
                success = true;
            }
        } catch (SQLException e) {
            // Jika ps1 atau ps2 gagal, batalkan kemasukan data pengguna
            conn.rollback(); 
            throw e;
        } finally {
            // Sentiasa set semula auto-commit supaya tidak mengganggu method lain
            conn.setAutoCommit(true);
        }
    return success;
}

    /**
     * Authenticate pengguna (Hanya status 1/Aktif dibenarkan masuk).
     */
/**
 * Mencari pengguna berdasarkan No KP (Digunakan untuk Login dengan BCrypt)
 * Mengambil maklumat peranan dan jawatan sekali.
 */
    public Pengguna findByKP(String kp) {
        Pengguna user = null;
        // KEMASKINI: Buang "p.kata_laluan = ?" dari SQL
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan "
                + "FROM pengguna p "
                + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                + "WHERE p.nombor_kp = ? " // Cari guna KP sahaja
                + "ORDER BY r.id_peranan ASC LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public Pengguna getPenggunaById(int id) {
        Pengguna user = null;
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan "
                + "FROM pengguna p "
                + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                + "WHERE p.id_pengguna = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public boolean updateProfil(Pengguna u) {
        String sql = "UPDATE pengguna SET nama_penuh=?, nombor_telefon=?, email=?, nama_jalan=?, daerah=?, "
                + "nombor_poskod=?, bandar=?, negeri=?, status_keluarga=?, pekerjaan=?, pendapatan=?, "
                + "latitude=?, longitude=?, foto_profil=?, pengesahan_pendapatan=? WHERE id_pengguna=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public boolean updatePengguna(Pengguna u) {
        String sql = "UPDATE pengguna SET nombor_telefon=?, nama_jalan=?, bandar=?, "
                + "nombor_poskod=?, negeri=?, status_keluarga=? WHERE id_pengguna=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public boolean updatePassword(int idPengguna, String hashedNewPassword) {
        String sql = "UPDATE pengguna SET kata_laluan=? WHERE id_pengguna=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedNewPassword);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Pengguna> getAllActivePenduduk() {
        List<Pengguna> senarai = new ArrayList<>();
       String sql = "SELECT p.*, r.nama_peranan FROM pengguna p "
           + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
           + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
           + "WHERE p.status = 1 AND r.id_peranan = 4"; // Guna status 0 ikut data DB anda

        // JANGAN panggil DBUtil.getConnection() di sini
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Mengambil SEMUA pengguna yang aktif (status = 1) tanpa menapis peranan.
     * Digunakan untuk paparan Senarai Penduduk yang lengkap di dashboard AJK/Ketua.
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

        try (PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    public List<Pengguna> getAllAJK() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan, aj.id_jawatan FROM pengguna p "
           + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
           + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
           + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " 
           + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "   
           + "WHERE r.id_peranan = 3 AND p.status = 1";

        // JANGAN panggil DBUtil.getConnection() di sini
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    // Helper Method (Pastikan nama method dalam model Pengguna.java sepadan)
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
        }

        double lat = rs.getDouble("latitude");
        p.setLatitude(rs.wasNull() ? null : lat);
        double lon = rs.getDouble("longitude");
        p.setLongitude(rs.wasNull() ? null : lon);

        return p;
    }
    
    public List<Pengguna> getPendingPenduduk() {
    List<Pengguna> senarai = new ArrayList<>();
    // Query untuk mencari pengguna status 2 yang mempunyai peranan Penduduk (ID 4)
    String sql = "SELECT p.*, r.nama_peranan FROM pengguna p "
               + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
               + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
               + "WHERE p.status = 2 AND r.id_peranan = 4";

    try (PreparedStatement ps = conn.prepareStatement(sql); 
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            // Menggunakan helper method mapResultSetToPengguna yang anda sudah ada
            senarai.add(mapResultSetToPengguna(rs));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return senarai;
}
    
public boolean updateStatus(int idPengguna, int statusBaru) {
    // Query untuk mengemaskini status berdasarkan ID pengguna 
    String sql = "UPDATE pengguna SET status = ?, dikemaskini_pada = CURRENT_TIMESTAMP WHERE id_pengguna = ?";
    
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, statusBaru);
        ps.setInt(2, idPengguna);
        
        // Memulangkan true jika baris berjaya dikemaskini
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

public int countAll() {
    String sql = "SELECT COUNT(*) FROM pengguna";
    try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

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
        try (PreparedStatement ps = conn.prepareStatement(sql);
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
        try (PreparedStatement ps = conn.prepareStatement(sql);
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

    public java.util.Map<String, Integer> getFamilyStatusDistribution() {
        java.util.Map<String, Integer> dist = new java.util.LinkedHashMap<>();
        String sql = "SELECT status_keluarga, COUNT(*) as count " +
                     "FROM pengguna WHERE status = 1 AND status_keluarga IS NOT NULL AND status_keluarga != '' " +
                     "GROUP BY status_keluarga";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                dist.put(rs.getString("status_keluarga"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dist;
    }

    public double getAverageIncome() {
        String sql = "SELECT AVG(pendapatan) FROM pengguna WHERE status = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
