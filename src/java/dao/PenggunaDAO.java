package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import model.Pengguna;

public class PenggunaDAO {

    // 1. UPDATE: Ambil 'status' dari DB semasa login/carian
    public Pengguna getByNomborKP(String nomborKP) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Pengguna WHERE nomborKP = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, nomborKP);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Pengguna p = new Pengguna();
            p.setIdPengguna(rs.getInt("idPengguna"));
            p.setNamaPertama(rs.getString("NamaPertama"));
            p.setNamaKedua(rs.getString("NamaKedua"));
            p.setNomborKP(rs.getString("nomborKP"));
            p.setNomborTelefon(rs.getString("nomborTelefon"));
            p.setTarikhLahir(rs.getDate("tarikhLahir"));
            p.setJawatan(rs.getString("jawatan"));
            p.setKataLaluan(rs.getString("kataLaluan"));
            p.setTarikhKemaskini(rs.getDate("tarikhKemaskini"));
            p.setNamaJalan(rs.getString("namaJalan"));
            p.setBandar(rs.getString("bandar"));
            p.setNomborPoskod(rs.getString("nomborPoskod"));
            p.setNegeri(rs.getString("negeri"));
            
            // TAMBAHAN: Set status
            p.setStatus(rs.getInt("status")); 
            
            return p;
        }
        return null;
    }

    // 2. UPDATE: Tambah kolum 'status' dalam SQL dan set default '0' (Pending)
    public void insert(Pengguna p) throws SQLException {
        Connection conn = DBUtil.getConnection();
        // SQL dikemaskini untuk masukkan kolum 'status'
        String sql = "INSERT INTO Pengguna (NamaPertama, NamaKedua, nomborKP, nomborTelefon, tarikhLahir, jawatan, kataLaluan, tarikhKemaskini, namaJalan, bandar, nomborPoskod, negeri, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, p.getNamaPertama());
        ps.setString(2, p.getNamaKedua());
        ps.setString(3, p.getNomborKP());
        ps.setString(4, p.getNomborTelefon());
        ps.setDate(5, new java.sql.Date(p.getTarikhLahir().getTime()));
        ps.setString(6, p.getJawatan());
        ps.setString(7, p.getKataLaluan());
        ps.setDate(8, new java.sql.Date(new Date().getTime()));  // Tarikh semasa
        ps.setString(9, p.getNamaJalan());
        ps.setString(10, p.getBandar());
        ps.setString(11, p.getNomborPoskod());
        ps.setString(12, p.getNegeri());
        
        // TAMBAHAN: Set status default 0 (Pending Approval)
        ps.setInt(13, 0); 
        
        ps.executeUpdate();
    }

    // 3. BARU: Method untuk JKKK tarik senarai pendaftaran baru (Pending)
    public List<Pengguna> getPendingRegistrations() {
        List<Pengguna> list = new ArrayList<>();
        // Cari pengguna yang status 0 DAN jawatan adalah 'Penduduk'
        String sql = "SELECT * FROM Pengguna WHERE status = 0 AND jawatan = 'Penduduk'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pengguna p = new Pengguna();
                p.setIdPengguna(rs.getInt("idPengguna"));
                p.setNamaPertama(rs.getString("NamaPertama"));
                p.setNamaKedua(rs.getString("NamaKedua"));
                p.setNomborKP(rs.getString("nomborKP"));
                p.setNomborTelefon(rs.getString("nomborTelefon"));
                p.setNamaJalan(rs.getString("namaJalan")); // Untuk alamat
                p.setBandar(rs.getString("bandar"));
                p.setStatus(rs.getInt("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. BARU: Method untuk JKKK Luluskan (1) atau Tolak (2)
    public void updateStatus(int idPengguna, int status) {
        String sql = "UPDATE Pengguna SET status = ? WHERE idPengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, status);
            ps.setInt(2, idPengguna);
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ... kod sedia ada ...

    // 5. BARU: Dapatkan semua penduduk yang AKTIF (Status = 1) untuk disunting
    public List<Pengguna> getAllActivePenduduk() {
        List<Pengguna> list = new ArrayList<>();
        String sql = "SELECT * FROM Pengguna WHERE jawatan = 'Penduduk' AND status = 1 ORDER BY namaPertama ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pengguna p = new Pengguna();
                p.setIdPengguna(rs.getInt("idPengguna"));
                p.setNamaPertama(rs.getString("NamaPertama"));
                p.setNamaKedua(rs.getString("NamaKedua"));
                p.setNomborKP(rs.getString("nomborKP"));
                p.setNomborTelefon(rs.getString("nomborTelefon"));
                p.setNamaJalan(rs.getString("namaJalan"));
                p.setBandar(rs.getString("bandar"));
                p.setNomborPoskod(rs.getString("nomborPoskod"));
                p.setNegeri(rs.getString("negeri"));
                p.setKataLaluan(rs.getString("kataLaluan")); // Perlu untuk edit password
                p.setStatus(rs.getInt("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. BARU: Update maklumat penduduk (Kecuali ID)
    public void updatePengguna(Pengguna p) {
        String sql = "UPDATE Pengguna SET NamaPertama=?, NamaKedua=?, nomborKP=?, nomborTelefon=?, namaJalan=?, bandar=?, nomborPoskod=?, negeri=?, kataLaluan=? WHERE idPengguna=?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getNamaPertama());
            ps.setString(2, p.getNamaKedua());
            ps.setString(3, p.getNomborKP());
            ps.setString(4, p.getNomborTelefon());
            ps.setString(5, p.getNamaJalan());
            ps.setString(6, p.getBandar());
            ps.setString(7, p.getNomborPoskod());
            ps.setString(8, p.getNegeri());
            ps.setString(9, p.getKataLaluan());
            ps.setInt(10, p.getIdPengguna()); // WHERE clause
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ... kod sedia ada ...

    // 7. BARU: Dapatkan senarai JKKK yang Aktif
    public List<Pengguna> getAllJKKK() {
        List<Pengguna> list = new ArrayList<>();
        String sql = "SELECT * FROM Pengguna WHERE jawatan = 'JKKK' AND status = 1 ORDER BY NamaPertama ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pengguna p = new Pengguna();
                p.setIdPengguna(rs.getInt("idPengguna"));
                p.setNamaPertama(rs.getString("NamaPertama"));
                p.setNamaKedua(rs.getString("NamaKedua"));
                p.setNomborKP(rs.getString("nomborKP"));
                p.setNomborTelefon(rs.getString("nomborTelefon"));
                p.setNamaJalan(rs.getString("namaJalan"));
                p.setBandar(rs.getString("bandar"));
                p.setNomborPoskod(rs.getString("nomborPoskod"));
                p.setNegeri(rs.getString("negeri"));
                p.setKataLaluan(rs.getString("kataLaluan"));
                p.setJawatan(rs.getString("jawatan"));
                p.setStatus(rs.getInt("status"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. BARU: Lantik JKKK (Insert dengan Status 1 - Aktif Terus)
    public void lantikJKKK(Pengguna p) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO Pengguna (NamaPertama, NamaKedua, nomborKP, nomborTelefon, tarikhLahir, jawatan, kataLaluan, tarikhKemaskini, namaJalan, bandar, nomborPoskod, negeri, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, p.getNamaPertama());
        ps.setString(2, p.getNamaKedua());
        ps.setString(3, p.getNomborKP());
        ps.setString(4, p.getNomborTelefon());
        ps.setDate(5, new java.sql.Date(new Date().getTime())); // Tarikh lahir default (boleh update nanti)
        ps.setString(6, "JKKK"); // JAWATAN TETAP JKKK
        ps.setString(7, p.getKataLaluan());
        ps.setDate(8, new java.sql.Date(new Date().getTime()));
        ps.setString(9, p.getNamaJalan());
        ps.setString(10, "-");
        ps.setString(11, "-");
        ps.setString(12, "Kelantan");
        
        // STATUS 1 (AKTIF TERUS)
        ps.setInt(13, 1); 
        
        ps.executeUpdate();
    }
    
}