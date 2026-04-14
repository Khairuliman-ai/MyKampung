package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Fasiliti;
import util.DBUtil; // Pastikan package util anda betul

public class FasilitiDAO {

    public List<Fasiliti> dapatkanSemuaFasiliti() {
        List<Fasiliti> senarai = new ArrayList<>();
        
        // PEMBETULAN: Tambah kolum timestamp dalam SQL query atau guna SELECT *
        String sql = "SELECT id_fasiliti, nama_fasiliti, lokasi, status, dibuat_pada, dikemaskini_pada, dipadam_pada " +
                     "FROM fasiliti WHERE status = 'AKTIF'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Fasiliti f = new Fasiliti();
                
                f.setId_fasiliti(rs.getInt("id_fasiliti"));
                f.setNama_fasiliti(rs.getString("nama_fasiliti"));
                f.setLokasi(rs.getString("lokasi"));
                f.setStatus(rs.getString("status"));
                
                // Sekarang kolum ini selamat ditarik kerana sudah ada dalam SELECT di atas
                f.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                f.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
                f.setDipadam_pada(rs.getTimestamp("dipadam_pada"));

                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }
}