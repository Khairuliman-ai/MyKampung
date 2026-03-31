package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Peranan;
import util.DBUtil;

public class PerananDAO {

    // Ambil semua jenis peranan yang ada (Penduduk, Admin, dsb)
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

    // Beri peranan kepada pengguna (INSERT ke Pengguna_Peranan)
    public boolean tambahPerananPengguna(int id_pengguna, int id_peranan) {
        String sql = "INSERT INTO Pengguna_Peranan (id_pengguna, id_peranan) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            ps.setInt(2, id_peranan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Semak peranan pengguna (Sangat penting untuk Filter/Security)
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