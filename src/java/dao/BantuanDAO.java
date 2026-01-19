package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Bantuan;

public class BantuanDAO {
    
    
    // Tambah method ini untuk INSERT jenis bantuan baru
public void insertBantuan(Bantuan b) throws SQLException {
    Connection conn = DBUtil.getConnection();
    
    // Periksa dulu ID terakhir dalam database supaya tak bertindan
    // Kita cari MAX(idBantuan)
    String sqlMax = "SELECT MAX(idBantuan) AS maxId FROM bantuan WHERE idBantuan < 999"; 
    // (exclude 999 sebab 999 tu selalunya 'Lain-lain')

    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(sqlMax);
    
    int nextId = 25; // Default start kalau table kosong (atau sambung lepas 24)
    if (rs.next()) {
        int max = rs.getInt("maxId");
        if (max >= 25) {
            nextId = max + 1;
        }
    }
    
    // Sekarang baru INSERT
    String sql = "INSERT INTO bantuan (idBantuan, namaBantuan) VALUES (?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, nextId);
    ps.setString(2, b.getNamaBantuan().toUpperCase()); // Simpan huruf besar supaya kemas
    
    ps.executeUpdate();
    
    rs.close();
    stmt.close();
    ps.close();
    conn.close();
}
    
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
    
    // Tambah method ini dalam class BantuanDAO
public List<Bantuan> getBantuanKomuniti() throws SQLException {
    List<Bantuan> list = new ArrayList<>();
    Connection conn = DBUtil.getConnection();
    
    // Kita tarik semua bantuan yang ID dia 21 ke atas (sebab 1-20 tu bantuan kerajaan/rasmi)
    // Kita exclude 999 sebab kita akan letak 'Lain-lain' manual di bawah
    String sql = "SELECT * FROM bantuan WHERE idBantuan >= 21 AND idBantuan != 999 ORDER BY idBantuan ASC";
    
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    
    while (rs.next()) {
        Bantuan b = new Bantuan();
        b.setIdBantuan(rs.getInt("idBantuan"));
        b.setNamaBantuan(rs.getString("namaBantuan"));
        list.add(b);
    }
    
    rs.close();
    ps.close();
    conn.close();
    return list;
}

    // Tambah method jika perlu, e.g., insert untuk admin tambah jenis bantuan
}