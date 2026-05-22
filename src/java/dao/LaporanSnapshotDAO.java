package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.LaporanSnapshot;
import util.DBUtil;

public class LaporanSnapshotDAO {

    public List<LaporanSnapshot> getAllSnapshots() {
        List<LaporanSnapshot> list = new ArrayList<>();
        String sql = "SELECT * FROM laporan_snapshot ORDER BY tahun ASC, bulan ASC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                LaporanSnapshot s = new LaporanSnapshot();
                s.setId_snapshot(rs.getInt("id_snapshot"));
                s.setTahun(rs.getInt("tahun"));
                s.setBulan(rs.getInt("bulan"));
                s.setTotal_penduduk(rs.getInt("total_penduduk"));
                s.setTotal_bantuan_dipohon(rs.getInt("total_bantuan_dipohon"));
                s.setTotal_bantuan_diluluskan(rs.getInt("total_bantuan_diluluskan"));
                s.setTotal_aduan_diterima(rs.getInt("total_aduan_diterima"));
                s.setTotal_aduan_selesai(rs.getInt("total_aduan_selesai"));
                s.setTotal_tempahan_fasiliti(rs.getInt("total_tempahan_fasiliti"));
                s.setPurata_pendapatan(rs.getDouble("purata_pendapatan"));
                s.setSnapshot_pada(rs.getTimestamp("snapshot_pada"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertSnapshot(LaporanSnapshot s) {
        String sql = "INSERT INTO laporan_snapshot " +
                     "(tahun, bulan, total_penduduk, total_bantuan_dipohon, total_bantuan_diluluskan, " +
                     "total_aduan_diterima, total_aduan_selesai, total_tempahan_fasiliti, purata_pendapatan) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "total_penduduk = VALUES(total_penduduk), " +
                     "total_bantuan_dipohon = VALUES(total_bantuan_dipohon), " +
                     "total_bantuan_diluluskan = VALUES(total_bantuan_diluluskan), " +
                     "total_aduan_diterima = VALUES(total_aduan_diterima), " +
                     "total_aduan_selesai = VALUES(total_aduan_selesai), " +
                     "total_tempahan_fasiliti = VALUES(total_tempahan_fasiliti), " +
                     "purata_pendapatan = VALUES(purata_pendapatan)";
                     
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, s.getTahun());
            ps.setInt(2, s.getBulan());
            ps.setInt(3, s.getTotal_penduduk());
            ps.setInt(4, s.getTotal_bantuan_dipohon());
            ps.setInt(5, s.getTotal_bantuan_diluluskan());
            ps.setInt(6, s.getTotal_aduan_diterima());
            ps.setInt(7, s.getTotal_aduan_selesai());
            ps.setInt(8, s.getTotal_tempahan_fasiliti());
            ps.setDouble(9, s.getPurata_pendapatan());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
