package model;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BantuanDAO {
    public List<Bantuan> getAll() throws SQLException {
        List<Bantuan> list = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Bantuan";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            Bantuan b = new Bantuan();
            b.setIdBantuan(rs.getInt("idBantuan"));
            b.setNamaBantuan(rs.getString("namaBantuan"));
            b.setPeruntukan(rs.getInt("peruntukan"));
            b.setKriteriaKelayakan(rs.getString("kriteriaKelayakan"));
            list.add(b);
        }
        return list;
    }

    // Tambah method jika perlu, e.g., insert untuk admin tambah jenis bantuan
}