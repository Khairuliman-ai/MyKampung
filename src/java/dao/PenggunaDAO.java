package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Pengguna;
import util.DBUtil; // Menggunakan DBUtil anda

public class PenggunaDAO {

    // 1. DAFTAR PENGGUNA BARU (Status = 0)
    public boolean daftarPengguna(Pengguna p) {
        boolean success = false;
        String sql = "INSERT INTO Pengguna (nama_penuh, nombor_kp, nombor_telefon, kata_laluan, status, dibuat_pada) VALUES (?, ?, ?, ?, 0, NOW())";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getNama_penuh());
            ps.setString(2, p.getNombor_kp());
            ps.setString(3, p.getNombor_telefon());
            ps.setString(4, p.getKata_laluan());
            
            success = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // 2. LOGIN (Semak No KP & Password)
    public Pengguna login(String noKP, String password) {
        Pengguna p = null;
        String sql = "SELECT * FROM Pengguna WHERE nombor_kp = ? AND kata_laluan = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, noKP);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                p = mapResultSetToPengguna(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    // 3. KEMASKINI PROFIL (Alamat & Maklumat Peribadi)
    public boolean kemaskiniProfil(Pengguna p) {
        String sql = "UPDATE Pengguna SET nama_penuh=?, nombor_telefon=?, status_keluarga=?, pekerjaan=?, pendapatan=?, " +
                     "nama_jalan=?, nombor_poskod=?, bandar=?, negeri=?, dikemaskini_pada=NOW() " +
                     "WHERE id_pengguna=?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getNama_penuh());
            ps.setString(2, p.getNombor_telefon());
            ps.setString(3, p.getStatus_keluarga());
            ps.setString(4, p.getPekerjaan());
            ps.setBigDecimal(5, p.getPendapatan());
            ps.setString(6, p.getNama_jalan());
            ps.setString(7, p.getNombor_poskod());
            ps.setString(8, p.getBandar());
            ps.setString(9, p.getNegeri());
            ps.setInt(10, p.getId_pengguna());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. SAHKAN PENDUDUK (Ketua Kampung tukar Status 0 -> 1)
    public boolean sahkanPengguna(int id_pengguna) {
        String sql = "UPDATE Pengguna SET status = 1, dikemaskini_pada = NOW() WHERE id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 5. AMBIL SEMUA PENDUDUK (Untuk paparan senarai)
    public List<Pengguna> getAllPengguna() {
        List<Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT * FROM Pengguna WHERE dipadam_pada IS NULL";
        
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            
            while (rs.next()) {
                senarai.add(mapResultSetToPengguna(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    // --- HELPER UNTUK MAPPING RESULTSET (Supaya kod lebih bersih) ---
    private Pengguna mapResultSetToPengguna(ResultSet rs) throws SQLException {
        Pengguna p = new Pengguna();
        p.setId_pengguna(rs.getInt("id_pengguna"));
        p.setNama_penuh(rs.getString("nama_penuh"));
        p.setNombor_kp(rs.getString("nombor_kp"));
        p.setNombor_telefon(rs.getString("nombor_telefon"));
        p.setStatus_keluarga(rs.getString("status_keluarga"));
        p.setPekerjaan(rs.getString("pekerjaan"));
        p.setPendapatan(rs.getBigDecimal("pendapatan"));
        p.setNama_jalan(rs.getString("nama_jalan"));
        p.setNombor_poskod(rs.getString("nombor_poskod"));
        p.setBandar(rs.getString("bandar"));
        p.setNegeri(rs.getString("negeri"));
        p.setStatus(rs.getInt("status"));
        p.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        return p;
    }
}