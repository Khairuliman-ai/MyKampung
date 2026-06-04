package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.KategoriAduan;
import util.DBUtil;

/**
 * KategoriAduanDAO handles database CRUD operations for complaint categories (kategori_aduan).
 * Used to classify complaints (e.g. facility repairs, security hazards, general complaints) and provide title suggestions.
 */
public class KategoriAduanDAO {
    
    /**
     * Retrieves all active, non-deleted complaint categories.
     * 
     * @return a list of KategoriAduan objects
     */
    public List<KategoriAduan> getAll() {
        List<KategoriAduan> list = new ArrayList<>();
        String sql = "SELECT * FROM kategori_aduan WHERE dipadam_pada IS NULL";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                KategoriAduan k = new KategoriAduan();
                k.setId_kategori_aduan(rs.getInt("id_kategori_aduan"));
                k.setNama_kategori(rs.getString("nama_kategori"));
                k.setContoh_tajuk(rs.getString("contoh_tajuk"));
                k.setPenerangan(rs.getString("penerangan"));
                list.add(k);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Retrieves a single complaint category by its unique ID.
     * 
     * @param id the unique category ID
     * @return the populated KategoriAduan model, or null if not found
     */
    public KategoriAduan getById(int id) {
        String sql = "SELECT * FROM kategori_aduan WHERE id_kategori_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    KategoriAduan k = new KategoriAduan();
                    k.setId_kategori_aduan(rs.getInt("id_kategori_aduan"));
                    k.setNama_kategori(rs.getString("nama_kategori"));
                    k.setContoh_tajuk(rs.getString("contoh_tajuk"));
                    k.setPenerangan(rs.getString("penerangan"));
                    return k;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
