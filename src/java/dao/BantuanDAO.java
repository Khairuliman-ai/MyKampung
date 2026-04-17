package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Bantuan;

public class BantuanDAO {

    public List<Bantuan> getBantuanKomuniti() {
        List<Bantuan> list = new ArrayList<>();
        String sql = "SELECT * FROM bantuan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bantuan b = new Bantuan();
                b.setId_bantuan(rs.getInt("id_bantuan"));
                b.setNama_bantuan(rs.getString("nama_bantuan"));
                b.setKeterangan(rs.getString("keterangan"));
                b.setJumlah_bantuan(rs.getBigDecimal("jumlah_bantuan"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertBantuan(Bantuan b) {
        String sql = "INSERT INTO bantuan (nama_bantuan, keterangan, jumlah_bantuan) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getNama_bantuan());
            ps.setString(2, b.getKeterangan());
            ps.setBigDecimal(3, b.getJumlah_bantuan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}