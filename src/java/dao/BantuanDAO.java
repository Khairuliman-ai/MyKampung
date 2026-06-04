package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Bantuan;

/**
 * BantuanDAO handles database CRUD operations for welfare assistance funds/programs (bantuan).
 * This includes retrieving aid types, listing individual aid programs, inserting/updating aid rules,
 * and deleting aid programs.
 */
public class BantuanDAO {

    /**
     * Retrieves a list of assistance programs filtered by category.
     * 
     * @param kategori the category string (e.g. KEWANGAN, KOMUNITI)
     * @return list of Bantuan matching the category
     */
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
                    b.setJumlah_bantuan(rs.getBigDecimal("peruntukan"));
                    b.setSyarat_dokumen(rs.getString("syarat_dokumen"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single assistance program by its unique identifier.
     * 
     * @param id the unique assistance program ID
     * @return the populated Bantuan model, or null if not found
     */
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
                    b.setSyarat_dokumen(rs.getString("syarat_dokumen"));
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all assistance programs registered in the database, ordered by ID descending.
     * 
     * @return list of all Bantuan
     */
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
                b.setSyarat_dokumen(rs.getString("syarat_dokumen"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Inserts a new assistance program record.
     * 
     * @param b the Bantuan model to insert
     * @return true if insertion succeeded, false otherwise
     */
    public boolean insertBantuan(Bantuan b) {
        String sql = "INSERT INTO bantuan (nama_bantuan, jenis_bantuan, peruntukan, syarat_dokumen) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getNama_bantuan());
            ps.setString(2, b.getJenis_bantuan() != null ? b.getJenis_bantuan() : "KOMUNITI");
            ps.setBigDecimal(3, b.getJumlah_bantuan());
            ps.setString(4, b.getSyarat_dokumen());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing assistance program's properties.
     * 
     * @param b the Bantuan model containing updated values
     * @return true if updated successfully, false otherwise
     */
    public boolean updateBantuan(Bantuan b) {
        String sql = "UPDATE bantuan SET nama_bantuan = ?, jenis_bantuan = ?, peruntukan = ?, syarat_dokumen = ? WHERE id_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getNama_bantuan());
            ps.setString(2, b.getJenis_bantuan());
            ps.setBigDecimal(3, b.getJumlah_bantuan());
            ps.setString(4, b.getSyarat_dokumen());
            ps.setInt(5, b.getId_bantuan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes an assistance program record from the database.
     * 
     * @param id the unique assistance program ID to delete
     * @return true if deleted successfully, false otherwise
     */
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