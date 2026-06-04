package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BantuanLampiran;

/**
 * BantuanLampiranDAO handles database CRUD operations for welfare application attachments (bantuan_lampiran).
 * This includes uploading file paths, deleting files by application ID or attachment ID,
 * and bulk retrieving attachments for a list of application IDs.
 */
public class BantuanLampiranDAO {

    /**
     * Inserts a new assistance application attachment record.
     * 
     * @param lampiran the attachment model containing file details and application ID
     */
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

    /**
     * Retrieves all attachments uploaded for a specific welfare application.
     * 
     * @param idPermohonan the welfare application ID
     * @return a list of BantuanLampiran objects
     */
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

    /**
     * Deletes all attachment records belonging to a specific welfare application.
     * 
     * @param idPermohonan the welfare application ID
     */
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
    /**
     * Deletes a specific attachment record by its unique identifier.
     * 
     * @param idLampiran the unique attachment ID to delete
     */
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

    /**
     * Bulk retrieves attachments for a collection of welfare application IDs.
     * Maps each application ID to its list of uploaded attachments to minimize database roundtrips.
     * 
     * @param ids a list of welfare application IDs
     * @return a map linking application IDs to their respective lists of attachments
     */
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

