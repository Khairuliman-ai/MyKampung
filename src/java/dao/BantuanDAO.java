package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Bantuan;

public class BantuanDAO {

    public List<Bantuan> getBantuanByKategori(String kategori) {
        List<Bantuan> list = new ArrayList<>();
        String sql = "SELECT * FROM bantuan WHERE jenis_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, kategori);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bantuan b = new Bantuan();
                    b.setId_bantuan(rs.getInt("id_bantuan"));
                    b.setNama_bantuan(rs.getString("nama_bantuan"));
                    b.setJenis_bantuan(rs.getString("jenis_bantuan"));
                    // Map database 'peruntukan' to model 'jumlah_bantuan'
                    b.setJumlah_bantuan(rs.getBigDecimal("peruntukan"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Bantuan getBantuanById(int id) {
        String sql = "SELECT * FROM bantuan WHERE id_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Bantuan b = new Bantuan();
                    b.setId_bantuan(rs.getInt("id_bantuan"));
                    b.setNama_bantuan(rs.getString("nama_bantuan"));
                    b.setJenis_bantuan(rs.getString("jenis_bantuan"));
                    b.setJumlah_bantuan(rs.getBigDecimal("peruntukan"));
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Bantuan> getAllBantuan() {
        List<Bantuan> list = new ArrayList<>();
        String sql = "SELECT * FROM bantuan ORDER BY id_bantuan DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bantuan b = new Bantuan();
                b.setId_bantuan(rs.getInt("id_bantuan"));
                b.setNama_bantuan(rs.getString("nama_bantuan"));
                b.setJenis_bantuan(rs.getString("jenis_bantuan"));
                b.setJumlah_bantuan(rs.getBigDecimal("peruntukan"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertBantuan(Bantuan b) {
        String sql = "INSERT INTO bantuan (nama_bantuan, jenis_bantuan, peruntukan) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getNama_bantuan());
            ps.setString(2, b.getJenis_bantuan() != null ? b.getJenis_bantuan() : "KOMUNITI");
            ps.setBigDecimal(3, b.getJumlah_bantuan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBantuan(Bantuan b) {
        String sql = "UPDATE bantuan SET nama_bantuan = ?, jenis_bantuan = ?, peruntukan = ? WHERE id_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getNama_bantuan());
            ps.setString(2, b.getJenis_bantuan());
            ps.setBigDecimal(3, b.getJumlah_bantuan());
            ps.setInt(4, b.getId_bantuan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBantuan(int id) {
        String sql = "DELETE FROM bantuan WHERE id_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}