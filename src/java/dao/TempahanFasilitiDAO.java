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

    // Menyimpan rekod tempahan baru ke dalam pangkalan data
    public boolean simpanTempahanBaru(TempahanFasiliti t) {
        String sql = "INSERT INTO tempahan_fasiliti (id_pengguna, id_fasiliti, tarikh_mula, tarikh_tamat, tujuan, status_tempahan) VALUES (?, ?, ?, ?, ?, 'Menunggu')";
        boolean status = false;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, t.getId_pengguna());
            ps.setInt(2, t.getId_fasiliti());
            ps.setTimestamp(3, t.getTarikh_mula());
            ps.setTimestamp(4, t.getTarikh_tamat());
            ps.setString(5, t.getTujuan());
            
            if (ps.executeUpdate() > 0) {
                status = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    // Mendapatkan sejarah tempahan berdasarkan ID pengguna
    public List<TempahanFasiliti> dapatkanSejarahTempahanPenduduk(int idPengguna) {
        List<TempahanFasiliti> senarai = new ArrayList<>();
        // Menggunakan JOIN untuk mendapatkan nama fasiliti
        String sql = "SELECT t.*, f.nama_fasiliti FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "WHERE t.id_pengguna = ? ORDER BY t.tarikh_mohon DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TempahanFasiliti t = new TempahanFasiliti();
                    t.setId_tempahan(rs.getInt("id_tempahan"));
                    t.setId_pengguna(rs.getInt("id_pengguna"));
                    t.setId_fasiliti(rs.getInt("id_fasiliti"));
                    t.setTarikh_mula(rs.getTimestamp("tarikh_mula"));
                    t.setTarikh_tamat(rs.getTimestamp("tarikh_tamat"));
                    t.setTujuan(rs.getString("tujuan"));
                    t.setStatus_tempahan(rs.getString("status_tempahan"));
                    t.setTarikh_mohon(rs.getTimestamp("tarikh_mohon"));
                    t.setNama_fasiliti(rs.getString("nama_fasiliti")); // Dari jadual fasiliti
                    
                    senarai.add(t);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }
}