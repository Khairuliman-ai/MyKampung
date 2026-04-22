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
        String sql = "INSERT INTO tempahan_fasiliti (id_pengguna, id_fasiliti, tarikh_tempah, masa_mula, masa_tamat, status, catatan_pemohon, dibuat_pada) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        boolean status = false;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, t.getId_pengguna());
            ps.setInt(2, t.getId_fasiliti());
            
            // Menggunakan method baru dari Model yang telah dibaiki
            ps.setDate(3, t.getTarikh_tempah());
            ps.setTime(4, t.getMasa_mula());
            ps.setTime(5, t.getMasa_tamat());
            ps.setString(6, t.getStatus());
            ps.setString(7, t.getCatatan_pemohon());
            
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
                    t.setTarikh_tempah(rs.getDate("tarikh_tempah"));
                    t.setMasa_mula(rs.getTime("masa_mula"));
                    t.setMasa_tamat(rs.getTime("masa_tamat"));
                    t.setStatus(rs.getString("status"));
                    t.setCatatan_pemohon(rs.getString("catatan_pemohon"));
                    t.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    t.setAlasanPenolakan(rs.getString("alasan_penolakan"));
                    senarai.add(t);
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (dapatkanSejarah): " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }

    public List<TempahanFasiliti> dapatkanSemuaTempahan() {
        List<TempahanFasiliti> senarai = new ArrayList<>();
        String sql = "SELECT t.*, f.nama_fasiliti, p.nama_penuh FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "JOIN pengguna p ON t.id_pengguna = p.id_pengguna " +
                     "ORDER BY t.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TempahanFasiliti t = new TempahanFasiliti();
                t.setId_tempahan(rs.getInt("id_tempahan"));
                t.setId_fasiliti(rs.getInt("id_fasiliti"));
                t.setId_pengguna(rs.getInt("id_pengguna"));
                t.setTarikh_tempah(rs.getDate("tarikh_tempah"));
                t.setMasa_mula(rs.getTime("masa_mula"));
                t.setMasa_tamat(rs.getTime("masa_tamat"));
                t.setStatus(rs.getString("status"));
                t.setCatatan_pemohon(rs.getString("catatan_pemohon"));
                t.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
                t.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                t.setNama_pengguna(rs.getString("nama_penuh"));
                t.setAlasanPenolakan(rs.getString("alasan_penolakan"));
                senarai.add(t);
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (dapatkanSemua): " + e.getMessage());
        }
        return senarai;
    }

    public TempahanFasiliti dapatkanTempahanById(int id) {
        TempahanFasiliti t = null;
        String sql = "SELECT t.*, f.nama_fasiliti, p.nama_penuh FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "JOIN pengguna p ON t.id_pengguna = p.id_pengguna " +
                     "WHERE t.id_tempahan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    t = new TempahanFasiliti();
                    t.setId_tempahan(rs.getInt("id_tempahan"));
                    t.setId_fasiliti(rs.getInt("id_fasiliti"));
                    t.setId_pengguna(rs.getInt("id_pengguna"));
                    t.setTarikh_tempah(rs.getDate("tarikh_tempah"));
                    t.setMasa_mula(rs.getTime("masa_mula"));
                    t.setMasa_tamat(rs.getTime("masa_tamat"));
                    t.setStatus(rs.getString("status"));
                    t.setCatatan_pemohon(rs.getString("catatan_pemohon"));
                    t.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
                    t.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    t.setNama_pengguna(rs.getString("nama_penuh"));
                    t.setAlasanPenolakan(rs.getString("alasan_penolakan"));
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (getById): " + e.getMessage());
        }
        return t;
    }

    public boolean kemaskiniStatus(int id, String status, String catatan) {
        String sql = "UPDATE tempahan_fasiliti SET status=?, catatan_pentadbir=?, dikemaskini_pada=NOW() WHERE id_tempahan=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, catatan);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("RALAT SQL (kemaskiniStatus): " + e.getMessage());
            return false;
        }
    }

    public boolean batalTempahan(int idTempahan, int idPengguna) {
        String sql = "UPDATE tempahan_fasiliti SET status='DIBATAL', dikemaskini_pada=NOW() " +
                     "WHERE id_tempahan=? AND id_pengguna=? " +
                     "AND status IN ('MENUNGGU', 'LULUS') " +
                     "AND (tarikh_tempah > CURRENT_DATE OR (tarikh_tempah = CURRENT_DATE AND masa_tamat > CURRENT_TIME))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTempahan);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("RALAT SQL (batal): " + e.getMessage());
            return false;
        }
    }

    public boolean semakKonflikMasa(int idFasiliti, java.sql.Date tarikh, java.sql.Time mula, java.sql.Time tamat) {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti " +
                     "WHERE id_fasiliti = ? AND tarikh_tempah = ? " +
                     "AND status NOT IN ('TOLAK', 'DIBATAL') " +
                     "AND ((masa_mula < ? AND masa_tamat > ?) " +
                     "OR (masa_mula < ? AND masa_tamat > ?) " +
                     "OR (masa_mula >= ? AND masa_tamat <= ?))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setDate(2, tarikh);
            ps.setTime(3, tamat);
            ps.setTime(4, mula);
            ps.setTime(5, tamat);
            ps.setTime(6, mula);
            ps.setTime(7, mula);
            ps.setTime(8, tamat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (konflik): " + e.getMessage());
        }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int checkUserQuotaActive(int idPengguna, int idFasiliti) {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti " +
                     "WHERE id_pengguna = ? AND id_fasiliti = ? " +
                     "AND status IN ('MENUNGGU', 'LULUS') " +
                     "AND (tarikh_tempah > CURRENT_DATE OR (tarikh_tempah = CURRENT_DATE AND masa_tamat > CURRENT_TIME))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            ps.setInt(2, idFasiliti);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateStatusTempahan(int id, String status, String alasan) {
        String sql = "UPDATE tempahan_fasiliti SET status=?, alasan_penolakan=?, dikemaskini_pada=NOW() WHERE id_tempahan=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, alasan);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
