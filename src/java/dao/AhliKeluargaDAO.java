package dao;

import model.AhliKeluarga;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AhliKeluargaDAO handles database operations for resident family members (ahli_keluarga).
 * Family members are registered under a main user (head of household) for socio-economic tracking.
 */
public class AhliKeluargaDAO {
    private Connection conn;

    /**
     * Constructs an AhliKeluargaDAO with an active database connection.
     * Used within transactional scopes.
     * 
     * @param conn the database connection to use
     */
    public AhliKeluargaDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Inserts a new family member record.
     * 
     * @param a the family member model containing details
     * @return true if the insert succeeded, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean addAhliKeluarga(AhliKeluarga a) throws SQLException {
        String sql = "INSERT INTO ahli_keluarga (id_pengguna, nama_penuh, nombor_kp, nombor_telefon, umur, hubungan, pekerjaan, pendapatan, pengesahan_pendapatan) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, a.getId_pengguna());
            ps.setString(2, a.getNama_penuh());
            ps.setString(3, a.getNombor_kp());
            ps.setString(4, a.getNombor_telefon());
            ps.setInt(5, a.getUmur());
            ps.setString(6, a.getHubungan());
            ps.setString(7, a.getPekerjaan());
            ps.setBigDecimal(8, a.getPendapatan());
            ps.setString(9, a.getPengesahan_pendapatan());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Retrieves all family members registered under a specific user ID.
     * 
     * @param idPengguna the user ID of the household head
     * @return a list of AhliKeluarga records
     */
    public List<AhliKeluarga> getByPenggunaId(int idPengguna) {
        List<AhliKeluarga> senarai = new ArrayList<>();
        String sql = "SELECT * FROM ahli_keluarga WHERE id_pengguna = ? ORDER BY id_ahli ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AhliKeluarga a = new AhliKeluarga();
                    a.setId_ahli(rs.getInt("id_ahli"));
                    a.setId_pengguna(rs.getInt("id_pengguna"));
                    a.setNama_penuh(rs.getString("nama_penuh"));
                    a.setNombor_kp(rs.getString("nombor_kp"));
                    a.setNombor_telefon(rs.getString("nombor_telefon"));
                    a.setUmur(rs.getInt("umur"));
                    a.setHubungan(rs.getString("hubungan"));
                    a.setPekerjaan(rs.getString("pekerjaan"));
                    a.setPendapatan(rs.getBigDecimal("pendapatan"));
                    a.setPengesahan_pendapatan(rs.getString("pengesahan_pendapatan"));
                    a.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    senarai.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Deletes all family member records registered under a specific user ID.
     * 
     * @param idPengguna the user ID of the household head
     * @return true if the delete operation succeeded
     * @throws SQLException if a database error occurs
     */
    public boolean deleteByPenggunaId(int idPengguna) throws SQLException {
        String sql = "DELETE FROM ahli_keluarga WHERE id_pengguna = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            return ps.executeUpdate() >= 0;
        }
    }

    /**
     * Counts family members who are not registered as active individual users in the system.
     * Uses national IC number (nombor_kp) checks to avoid double-counting active residents.
     * 
     * @return count of non-registered family members
     */
    public int countNonRegistered() {
        String sql = "SELECT COUNT(*) FROM ahli_keluarga ak "
                   + "WHERE (ak.nombor_kp IS NULL OR ak.nombor_kp = '' "
                   + "OR ak.nombor_kp NOT IN (SELECT p.nombor_kp FROM pengguna p WHERE p.status = 1))";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves details of all family members who are not registered as active individual users.
     * Joins with the pengguna table to resolve the full name of their household representative.
     * Used by AJK/Ketua for comprehensive census reporting.
     * 
     * @return a list of non-registered AhliKeluarga records
     */
    public List<AhliKeluarga> getAllNonRegistered() {
        List<AhliKeluarga> senarai = new ArrayList<>();
        String sql = "SELECT ak.*, p.nama_penuh AS nama_wakil FROM ahli_keluarga ak "
                   + "JOIN pengguna p ON ak.id_pengguna = p.id_pengguna "
                   + "WHERE p.status = 1 AND (ak.nombor_kp IS NULL OR ak.nombor_kp = '' "
                   + "OR ak.nombor_kp NOT IN (SELECT pg.nombor_kp FROM pengguna pg WHERE pg.status = 1)) "
                   + "ORDER BY p.nama_penuh ASC, ak.nama_penuh ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AhliKeluarga a = new AhliKeluarga();
                a.setId_ahli(rs.getInt("id_ahli"));
                a.setId_pengguna(rs.getInt("id_pengguna"));
                a.setNama_penuh(rs.getString("nama_penuh"));
                a.setNombor_kp(rs.getString("nombor_kp"));
                a.setNombor_telefon(rs.getString("nombor_telefon"));
                a.setUmur(rs.getInt("umur"));
                a.setHubungan(rs.getString("hubungan"));
                a.setPekerjaan(rs.getString("pekerjaan"));
                a.setPendapatan(rs.getBigDecimal("pendapatan"));
                a.setPengesahan_pendapatan(rs.getString("pengesahan_pendapatan"));
                a.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                a.setNamaWakil(rs.getString("nama_wakil"));
                senarai.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return senarai;
    }
}
