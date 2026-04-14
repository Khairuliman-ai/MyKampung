package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TempahanFasiliti;
import util.DBUtil;

public class TempahanFasilitiDAO {

    // 1. Menyimpan rekod tempahan baru
    public boolean simpanTempahanBaru(TempahanFasiliti t) {
        // Mengikut struktur gambar DB: tarikh_tempah, masa_mula, masa_tamat, status, dibuat_pada
        String sql = "INSERT INTO tempahan_fasiliti (id_pengguna, id_fasiliti, tarikh_tempah, masa_mula, masa_tamat, status, dibuat_pada) " +
                     "VALUES (?, ?, ?, ?, ?, 'MENUNGGU', CURRENT_TIMESTAMP)";
        boolean status = false;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, t.getId_pengguna());
            ps.setInt(2, t.getId_fasiliti());
            
            // Menggunakan method baru dari Model yang telah dibaiki
            ps.setDate(3, t.getTarikh_tempah());
            ps.setTime(4, t.getMasa_mula());
            ps.setTime(5, t.getMasa_tamat());
            
            int rowAffected = ps.executeUpdate();
            if (rowAffected > 0) {
                status = true;
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (simpanTempahan): " + e.getMessage());
            e.printStackTrace();
        }
        return status;
    }

    // 2. Mendapatkan sejarah tempahan berdasarkan ID pengguna
    public List<TempahanFasiliti> dapatkanSejarahTempahanPenduduk(int idPengguna) {
        List<TempahanFasiliti> senarai = new ArrayList<>();
        
        // PEMBETULAN: tarikh_mohon ditukar kepada dibuat_pada
        String sql = "SELECT t.*, f.nama_fasiliti FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "WHERE t.id_pengguna = ? ORDER BY t.dibuat_pada DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TempahanFasiliti t = new TempahanFasiliti();
                    t.setId_tempahan(rs.getInt("id_tempahan"));
                    t.setId_pengguna(rs.getInt("id_pengguna"));
                    t.setId_fasiliti(rs.getInt("id_fasiliti"));
                    
                    // PEMBETULAN: Menggunakan nama kolum yang wujud di DB
                    t.setTarikh_tempah(rs.getDate("tarikh_tempah"));
                    t.setMasa_mula(rs.getTime("masa_mula"));
                    t.setMasa_tamat(rs.getTime("masa_tamat"));
                    t.setStatus(rs.getString("status"));
                    t.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    
                    // Maklumat tambahan dari JOIN
                    t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    
                    senarai.add(t);
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (dapatkanSejarah): " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }
}