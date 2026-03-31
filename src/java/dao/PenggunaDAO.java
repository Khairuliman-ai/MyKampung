package dao;

import model.Pengguna;
import java.sql.*;
import java.math.BigDecimal;

public class PenggunaDAO {
    private Connection conn;

    public PenggunaDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Mengesahkan pengguna berdasarkan No KP dan Kata Laluan sahaja.
     * Peranan dikesan secara automatik (mengambil peranan tertinggi).
     */
    public Pengguna authenticate(String kp, String password) {
        Pengguna user = null;
        
        // Query dikemaskini untuk membuang filter roleName dan menambah sorting
        String sql = "SELECT p.*, r.nama_peranan, j.nama_jawatan " +
                     "FROM pengguna p " +
                     "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna " +
                     "JOIN peranan r ON pp.id_peranan = r.id_peranan " +
                     "LEFT JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " +
                     "LEFT JOIN jawatan_ajk j ON aj.id_jawatan = j.id_jawatan " +
                     "WHERE p.nombor_kp = ? AND p.kata_laluan = ? AND p.status = 1 " +
                     "ORDER BY r.id_peranan ASC LIMIT 1"; 

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kp);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new Pengguna();
                    
                    // Data Asas (Ejaan lajur diselaraskan dengan DB v2 anda) 
                    user.setId_pengguna(rs.getInt("id_pengguna"));
                    user.setNama_penuh(rs.getString("nama_penuh"));
                    user.setNombor_kp(rs.getString("nombor_kp"));
                    user.setNombor_telefon(rs.getString("nombor_telefon"));
                    user.setTarikh_lahir(rs.getDate("tarikh_lahir"));
                    user.setKata_laluan(rs.getString("kata_laluan"));
                    user.setStatus_keluarga(rs.getString("status_keluarga"));
                    user.setPekerjaan(rs.getString("pekerjaan"));
                    user.setPendapatan(rs.getBigDecimal("pendapatan"));
                    
                    // Alamat 
                    user.setNama_jalan(rs.getString("nama_jalan"));
                    user.setNombor_poskod(rs.getString("nombor_poskod"));
                    user.setBandar(rs.getString("bandar")); // Mengikut data Melor 
                    user.setNegeri(rs.getString("negeri")); // Mengikut data Kelantan 
                    
                    // Audit & Status
                    user.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    user.setStatus(rs.getInt("status"));

                    // Data Tambahan (Automatic Role Detection) [cite: 22, 38]
                    user.setNama_peranan(rs.getString("nama_peranan"));
                    user.setNama_jawatan(rs.getString("nama_jawatan")); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Ralat Login PenggunaDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
}