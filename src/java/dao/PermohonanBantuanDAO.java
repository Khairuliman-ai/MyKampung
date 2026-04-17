package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PermohonanBantuan;

public class PermohonanBantuanDAO {

    public List<PermohonanBantuan> getByPenduduk(int idPenduduk) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenduduk);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PermohonanBantuan> getAll() {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, p.nama_penuh FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan JOIN pengguna p ON pb.id_pengguna = p.id_pengguna";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PermohonanBantuan pb = mapRow(rs);
                pb.setNama_penuh(rs.getString("nama_penuh"));
                list.add(pb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PermohonanBantuan getById(int idPermohonan) {
        String sql = "SELECT pb.*, b.nama_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_permohonan_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteByIdAndPenduduk(int idPermohonan, int idPenduduk) {
        String sql = "DELETE FROM permohonan_bantuan WHERE id_permohonan_bantuan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            ps.setInt(2, idPenduduk);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean insertPermohonan(PermohonanBantuan pb) {
        String sql = "INSERT INTO permohonan_bantuan (id_pengguna, id_bantuan, tarikh_permohonan, status) VALUES (?, ?, NOW(), 'BARU')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pb.getId_pengguna());
            ps.setInt(2, pb.getId_bantuan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePermohonan(PermohonanBantuan pb) {
        String sql = "UPDATE permohonan_bantuan SET id_bantuan = ? WHERE id_permohonan_bantuan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pb.getId_bantuan());
            ps.setInt(2, pb.getId_permohonan_bantuan());
            ps.setInt(3, pb.getId_pengguna());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int idPermohonan, int statusInt, String ulasanAdmin, String dokumenSokongan) {
        // Map int to Enum String
        String statusStr = "MENUNGGU";
        if (statusInt == 1) statusStr = "LULUS";
        else if (statusInt == 4 || statusInt == 2) statusStr = "TOLAK";

        String sql = "UPDATE permohonan_bantuan SET status = ?, catatan_pentadbir = ? WHERE id_permohonan_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusStr);
            ps.setString(2, ulasanAdmin);
            ps.setInt(3, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInfo(int idPermohonan, String catatan, String dokumen) {
        // Schema dropped pemohon columns, fallback to doing nothing or logging
        return true;
    }

    private PermohonanBantuan mapRow(ResultSet rs) throws SQLException {
        PermohonanBantuan pb = new PermohonanBantuan();
        pb.setId_permohonan_bantuan(rs.getInt("id_permohonan_bantuan"));
        pb.setId_pengguna(rs.getInt("id_pengguna"));
        pb.setId_bantuan(rs.getInt("id_bantuan"));
        pb.setTarikh_permohonan(rs.getDate("tarikh_permohonan"));
        pb.setStatus(rs.getString("status"));
        pb.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
        try {
            pb.setNama_bantuan(rs.getString("nama_bantuan"));
        } catch (SQLException e) {
            // Might not be joined
        }
        return pb;
    }
}