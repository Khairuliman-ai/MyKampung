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
    public boolean daftarPengguna(Pengguna u) {
        boolean success = false;
        String sqlUser = "INSERT INTO pengguna (nama_penuh, nombor_kp, nombor_telefon, kata_laluan, "
                + "nama_jalan, nombor_poskod, bandar, negeri, tarikh_lahir, "
                + "lampiran_pengesahan, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlRole = "INSERT INTO pengguna_peranan (id_pengguna, id_peranan) VALUES (?, ?)";

        try {
            // Mulakan Transaction
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                ps1.setString(1, u.getNama_penuh());
                ps1.setString(2, u.getNombor_kp());
                ps1.setString(3, u.getNombor_telefon());
                ps1.setString(4, u.getKata_laluan());
                ps1.setString(5, u.getNama_jalan());
                ps1.setString(6, u.getNombor_poskod());
                ps1.setString(7, u.getBandar());
                ps1.setString(8, u.getNegeri());
                ps1.setDate(9, new java.sql.Date(u.getTarikh_lahir().getTime()));
                ps1.setString(10, u.getLampiran_pengesahan());
                ps1.setInt(11, u.getStatus()); // Nilai 2 (Pending) dari Servlet

                int rows = ps1.executeUpdate();

                if (rows > 0) {
                    // Dapatkan ID pengguna yang baru di-generate
                    ResultSet rs = ps1.getGeneratedKeys();
                    if (rs.next()) {
                        int newUserId = rs.getInt(1);

                        try (PreparedStatement ps2 = conn.prepareStatement(sqlRole)) {
                            ps2.setInt(1, newUserId);
                            ps2.setInt(2, 3); // ID 3 biasanya untuk peranan Penduduk
                            ps2.executeUpdate();
                        }
                    }
                    conn.commit(); // Simpan semua perubahan
                    success = true;
                }
            } catch (SQLException e) {
                conn.rollback(); // Batalkan jika ada ralat
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    /**
     * Authenticate pengguna (Hanya status 1/Aktif dibenarkan masuk).
     */
    public Pengguna authenticate(String kp, String password) {
        Pengguna user = null;
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan "
                + "FROM pengguna p "
                + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
                + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
                + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna "
                + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "
                + "WHERE p.nombor_kp = ? AND p.kata_laluan = ? AND p.status = 1 "
                + "ORDER BY r.id_peranan ASC LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kp);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new Pengguna();
                    user.setId_pengguna(rs.getInt("id_pengguna"));
                    user.setNama_penuh(rs.getString("nama_penuh"));
                    user.setNombor_kp(rs.getString("nombor_kp"));
                    user.setNombor_telefon(rs.getString("nombor_telefon"));
                    user.setTarikh_lahir(rs.getDate("tarikh_lahir"));
                    user.setPekerjaan(rs.getString("pekerjaan"));
                    user.setPendapatan(rs.getBigDecimal("pendapatan"));
                    user.setKata_laluan(rs.getString("kata_laluan"));
                    user.setNama_jalan(rs.getString("nama_jalan"));
                    user.setNombor_poskod(rs.getString("nombor_poskod"));
                    user.setBandar(rs.getString("bandar"));
                    user.setNegeri(rs.getString("negeri"));
                    user.setStatus(rs.getInt("status"));
                    user.setLampiran_pengesahan(rs.getString("lampiran_pengesahan"));
                    user.setNama_peranan(rs.getString("nama_peranan"));
                    user.setNama_jawatan(rs.getString("nama_jawatan"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateProfil(Pengguna u) {
        String sql = "UPDATE pengguna SET nama_penuh=?, nombor_telefon=?, nama_jalan=?, "
                + "nombor_poskod=?, bandar=?, negeri=?, status_keluarga=?, pekerjaan=?, pendapatan=? "
                + "WHERE id_pengguna=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getNama_penuh());
            ps.setString(2, u.getNombor_telefon());
            ps.setString(3, u.getNama_jalan());
            ps.setString(4, u.getNombor_poskod());
            ps.setString(5, u.getBandar());
            ps.setString(6, u.getNegeri());
            ps.setString(7, u.getStatus_keluarga());
            ps.setString(8, u.getPekerjaan());
            ps.setBigDecimal(9, u.getPendapatan());
            ps.setInt(10, u.getId_pengguna());

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

    public List<Pengguna> getAllAJK() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan FROM pengguna p "
           + "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna "
           + "JOIN peranan r ON pp.id_peranan = r.id_peranan "
           + "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " // Table ajk_jawatan di page 2
           + "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan "   // Table jawatan_ajk di page 6
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
        // Guna nama method yang ada dalam Pengguna.java anda (id_pengguna vs idPengguna)
        p.setId_pengguna(rs.getInt("id_pengguna"));
        p.setNombor_kp(rs.getString("nombor_kp"));
        p.setNama_penuh(rs.getString("nama_penuh"));
        p.setNombor_telefon(rs.getString("nombor_telefon"));
        p.setNama_jalan(rs.getString("nama_jalan"));
        p.setBandar(rs.getString("bandar"));
        p.setNombor_poskod(rs.getString("nombor_poskod"));
        p.setNegeri(rs.getString("negeri"));
        p.setStatus(rs.getInt("status"));

        try {
            p.setNama_peranan(rs.getString("nama_peranan"));
            p.setNama_jawatan(rs.getString("nama_jawatan"));
        } catch (SQLException e) {
        }

        return p;
    }
}
