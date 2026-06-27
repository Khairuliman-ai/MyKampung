package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.LaporanSnapshot;
import util.DBUtil;

/**
 * LaporanSnapshotDAO handles database operations for monthly statistical snapshots (laporan_snapshot).
 * Aggregates and stores census, welfare, complaint, and facility utilization statistics for monthly reporting.
 */
public class LaporanSnapshotDAO {

    /**
     * Retrieves all monthly snapshots in chronological order.
     * 
     * @return a list of LaporanSnapshot records
     */
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
                s.setAi_executive_summary(rs.getString("ai_executive_summary"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Inserts or updates a monthly snapshot.
     * Uses ON DUPLICATE KEY UPDATE to overwrite existing records for the same month/year key.
     * 
     * @param s the LaporanSnapshot model containing metrics
     * @return true if insertion/upsert succeeded, false otherwise
     */
    public boolean insertSnapshot(LaporanSnapshot s) {
        String sql = "INSERT INTO laporan_snapshot " +
                     "(tahun, bulan, total_penduduk, total_bantuan_dipohon, total_bantuan_diluluskan, " +
                     "total_aduan_diterima, total_aduan_selesai, total_tempahan_fasiliti, purata_pendapatan, ai_executive_summary) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "total_penduduk = VALUES(total_penduduk), " +
                     "total_bantuan_dipohon = VALUES(total_bantuan_dipohon), " +
                     "total_bantuan_diluluskan = VALUES(total_bantuan_diluluskan), " +
                     "total_aduan_diterima = VALUES(total_aduan_diterima), " +
                     "total_aduan_selesai = VALUES(total_aduan_selesai), " +
                     "total_tempahan_fasiliti = VALUES(total_tempahan_fasiliti), " +
                     "purata_pendapatan = VALUES(purata_pendapatan), " +
                     "ai_executive_summary = VALUES(ai_executive_summary)";
                     
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
            ps.setString(10, s.getAi_executive_summary());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
