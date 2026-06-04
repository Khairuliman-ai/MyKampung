package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.JawatanAJK;
import util.DBUtil;

/**
 * JawatanDAO handles database operations for managing AJK committee roles/titles (jawatan_ajk).
 * Enforces transaction safety when appointing or dismissing AJK members, ensuring
 * that role mappings in pengguna_peranan stay synchronized with ajk_jawatan.
 */
public class JawatanDAO {

    /**
     * Retrieves all available committee positions (jawatan_ajk) and their current holders.
     * Temporary piggybacks the jawatan ID into the status field of the returned Pengguna model for UI mapping.
     * 
     * @return a list of Pengguna objects representing position holders and vacant titles
     */
    public List<model.Pengguna> getJawatanHolders() {
        List<model.Pengguna> senarai = new ArrayList<>();
        String sql = "SELECT j.id_jawatan, j.nama_jawatan, p.id_pengguna, p.nama_penuh " +
                     "FROM jawatan_ajk j " +
                     "LEFT JOIN ajk_jawatan aj ON j.id_jawatan = aj.id_jawatan " +
                     "LEFT JOIN pengguna p ON aj.id_pengguna = p.id_pengguna";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                model.Pengguna p = new model.Pengguna();
                p.setId_pengguna(rs.getInt("id_pengguna"));
                p.setNama_penuh(rs.getString("nama_penuh")); // Holder name
                p.setNama_jawatan(rs.getString("nama_jawatan")); // Title name
                // We reuse id_pengguna as a flag; if 0, jawatan is vacant
                // But it's better to store id_jawatan somewhere
                p.setStatus(rs.getInt("id_jawatan")); // Store jawatan ID in status temporarily for UI
                senarai.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return senarai;
    }

    /**
     * Appoints a resident to a committee position.
     * Runs inside a database transaction: inserts a record into ajk_jawatan
     * and updates the user's role to AJK (role ID 3) in pengguna_peranan.
     * 
     * @param id_pengguna the user ID of the resident being appointed
     * @param id_jawatan the jawatan ID to assign
     * @return true if the appointment transaction committed successfully, false otherwise
     */
    public boolean lantikAJK(int id_pengguna, int id_jawatan) {
        String sqlInsert = "INSERT INTO ajk_jawatan (id_pengguna, id_jawatan) VALUES (?, ?)";
        String sqlUpdateRole = "UPDATE pengguna_peranan SET id_peranan = 3 WHERE id_pengguna = ?";
        
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlInsert);
                 PreparedStatement ps2 = conn.prepareStatement(sqlUpdateRole)) {
                
                ps1.setInt(1, id_pengguna);
                ps1.setInt(2, id_jawatan);
                ps1.executeUpdate();
                
                ps2.setInt(1, id_pengguna);
                ps2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * Dismisses an AJK member from their committee position.
     * Runs inside a database transaction: deletes their assignment from ajk_jawatan
     * and reverts their role back to Penduduk (role ID 4) in pengguna_peranan.
     * 
     * @param id_pengguna the user ID of the AJK member being dismissed
     * @param id_jawatan the jawatan ID to remove
     * @return true if the dismissal transaction committed successfully, false otherwise
     */
    public boolean gugurkanJawatan(int id_pengguna, int id_jawatan) {
        String sqlDelete = "DELETE FROM ajk_jawatan WHERE id_pengguna = ? AND id_jawatan = ?";
        String sqlUpdateRole = "UPDATE pengguna_peranan SET id_peranan = 4 WHERE id_pengguna = ?";
        
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(sqlDelete);
                 PreparedStatement ps2 = conn.prepareStatement(sqlUpdateRole)) {
                
                ps1.setInt(1, id_pengguna);
                ps1.setInt(2, id_jawatan);
                ps1.executeUpdate();
                
                // Check if user still has other AJK roles before reverting to Penduduk
                // (Optional: for now we assume 1 jawatan per person)
                ps2.setInt(1, id_pengguna);
                ps2.executeUpdate();
                
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * Retrieves the committee title name held by a specific user.
     * Returns "Penduduk Biasa" if the user has no assigned committee role.
     * 
     * @param id_pengguna the user ID
     * @return the name of the jawatan, or "Penduduk Biasa" if none
     */
    public String getNamaJawatanPengguna(int id_pengguna) {
        String jawatan = "Penduduk Biasa";
        String sql = "SELECT j.nama_jawatan FROM jawatan_ajk j " +
                     "JOIN ajk_jawatan aj ON j.id_jawatan = aj.id_jawatan " +
                     "WHERE aj.id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                jawatan = rs.getString("nama_jawatan");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return jawatan;
    }

    /**
     * Inserts a new committee position title into the database.
     * 
     * @param namaJawatan the name of the new position
     * @return true if insertion succeeded, false otherwise
     */
    public boolean tambahJawatan(String namaJawatan) {
        String sql = "INSERT INTO jawatan_ajk (nama_jawatan) VALUES (?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, namaJawatan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
