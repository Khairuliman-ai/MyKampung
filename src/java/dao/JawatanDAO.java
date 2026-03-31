package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Jawatan_AJK;
import util.DBUtil;

public class JawatanDAO {

    // Ambil senarai jawatan (Ketua Kampung, Timbalan, dsb)
    public List<Jawatan_AJK> getAllJawatan() {
        List<Jawatan_AJK> senarai = new ArrayList<>();
        String sql = "SELECT * FROM Jawatan_AJK";
        try (Connection conn = DBUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Jawatan_AJK j = new Jawatan_AJK();
                j.setId_jawatan(rs.getInt("id_jawatan"));
                j.setNama_jawatan(rs.getString("nama_jawatan"));
                senarai.add(j);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return senarai;
    }

    // Lantik Pengguna sebagai AJK (INSERT ke AJK_Jawatan)
    public boolean lantikAJK(int id_pengguna, int id_jawatan) {
        String sql = "INSERT INTO AJK_Jawatan (id_pengguna, id_jawatan) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id_pengguna);
            ps.setInt(2, id_jawatan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // Ambil maklumat jawatan yang dipegang oleh seseorang
    public String getNamaJawatanPengguna(int id_pengguna) {
        String jawatan = "Penduduk Biasa";
        String sql = "SELECT j.nama_jawatan FROM Jawatan_AJK j " +
                     "JOIN AJK_Jawatan aj ON j.id_jawatan = aj.id_jawatan " +
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
}