package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BantuanLampiran;

public class BantuanLampiranDAO {

    public void insert(BantuanLampiran lampiran) {
        String sql = "INSERT INTO bantuan_lampiran (id_permohonan, nama_fail, jenis_lampiran) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lampiran.getId_permohonan());
            ps.setString(2, lampiran.getNama_fail());
            ps.setString(3, lampiran.getJenis_lampiran());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<BantuanLampiran> getByPermohonan(int idPermohonan) {
        List<BantuanLampiran> list = new ArrayList<>();
        String sql = "SELECT * FROM bantuan_lampiran WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BantuanLampiran bl = new BantuanLampiran();
                    bl.setId_lampiran(rs.getInt("id_lampiran"));
                    bl.setId_permohonan(rs.getInt("id_permohonan"));
                    bl.setNama_fail(rs.getString("nama_fail"));
                    bl.setJenis_lampiran(rs.getString("jenis_lampiran"));
                    bl.setDimuat_naik_pada(rs.getTimestamp("dimuat_naik_pada"));
                    list.add(bl);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteByPermohonan(int idPermohonan) {
        String sql = "DELETE FROM bantuan_lampiran WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public void deleteById(int idLampiran) {
        String sql = "DELETE FROM bantuan_lampiran WHERE id_lampiran = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLampiran);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public java.util.Map<Integer, List<BantuanLampiran>> getByPermohonanIds(List<Integer> ids) {
        java.util.Map<Integer, List<BantuanLampiran>> map = new java.util.HashMap<>();
        if (ids == null || ids.isEmpty()) return map;

        StringBuilder sql = new StringBuilder("SELECT * FROM bantuan_lampiran WHERE id_permohonan IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append("?");
            if (i < ids.size() - 1) sql.append(",");
        }
        sql.append(")");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BantuanLampiran bl = new BantuanLampiran();
                    bl.setId_lampiran(rs.getInt("id_lampiran"));
                    bl.setId_permohonan(rs.getInt("id_permohonan"));
                    bl.setNama_fail(rs.getString("nama_fail"));
                    bl.setJenis_lampiran(rs.getString("jenis_lampiran"));
                    bl.setDimuat_naik_pada(rs.getTimestamp("dimuat_naik_pada"));

                    int idPermohonan = bl.getId_permohonan();
                    map.computeIfAbsent(idPermohonan, k -> new ArrayList<>()).add(bl);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}

