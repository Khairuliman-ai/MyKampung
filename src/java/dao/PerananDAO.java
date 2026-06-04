package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Peranan;
import util.DBUtil;

/**
 * PerananDAO handles database operations for user roles (Peranan) and role mappings (Pengguna_Peranan).
 * Essential for authorization checks and access control lists across the application.
 */
public class PerananDAO {

    /**
     * Retrieves all available role definitions from the database.
     * 
     * @return a list of all Peranan objects
     */
    public List<Peranan> getAllPeranan() {
        List<Peranan> senarai = new ArrayList<>();
        String sql = "SELECT * FROM Peranan";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Peranan p = new Peranan();
                p.setId_peranan(rs.getInt("id_peranan"));
                p.setNama_peranan(rs.getString("nama_peranan"));
                senarai.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return senarai;
    }

    /**
     * Assigns a role to a user.
     * 
     * @param id_pengguna the target user ID
     * @param id_peranan the role ID to assign
     * @return true if the role assignment succeeded, false otherwise
     */
    public boolean tambahPerananPengguna(int id_pengguna, int id_peranan) {
        String sql = "INSERT INTO Pengguna_Peranan (id_pengguna, id_peranan) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            ps.setInt(2, id_peranan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /**
     * Retrieves all role names associated with a specific user.
     * Crucial for security filters and page authorization mapping.
     * 
     * @param id_pengguna the user ID
     * @return list of role name strings assigned to the user
     */
    public List<String> getPerananByPengguna(int id_pengguna) {
        List<String> peranan = new ArrayList<>();
        String sql = "SELECT p.nama_peranan FROM Peranan p " +
                     "JOIN Pengguna_Peranan pp ON p.id_peranan = pp.id_peranan " +
                     "WHERE pp.id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                peranan.add(rs.getString("nama_peranan"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return peranan;
    }
}