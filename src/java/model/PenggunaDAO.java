package model;

import util.DBUtil;
import java.sql.*;
import java.util.Date;

public class PenggunaDAO {
    public Pengguna getByNomborKP(String nomborKP) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Pengguna WHERE nomborKP = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, nomborKP);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Pengguna p = new Pengguna();
            p.setIdPengguna(rs.getInt("idPengguna"));
            p.setNamaPertama(rs.getString("NamaPertama"));
            p.setNamaKedua(rs.getString("NamaKedua"));
            p.setNomborKP(rs.getString("nomborKP"));
            p.setNomborTelefon(rs.getString("nomborTelefon"));
            p.setTarikhLahir(rs.getDate("tarikhLahir"));
            p.setJawatan(rs.getString("jawatan"));
            p.setKataLaluan(rs.getString("kataLaluan"));
            p.setTarikhKemaskini(rs.getDate("tarikhKemaskini"));
            p.setNamaJalan(rs.getString("namaJalan"));
            p.setBandar(rs.getString("bandar"));
            p.setNomborPoskod(rs.getString("nomborPoskod"));
            p.setNegeri(rs.getString("negeri"));
            return p;
        }
        return null;
    }

    public void insert(Pengguna p) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO Pengguna (NamaPertama, NamaKedua, nomborKP, nomborTelefon, tarikhLahir, jawatan, kataLaluan, tarikhKemaskini, namaJalan, bandar, nomborPoskod, negeri) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, p.getNamaPertama());
        ps.setString(2, p.getNamaKedua());
        ps.setString(3, p.getNomborKP());
        ps.setString(4, p.getNomborTelefon());
        ps.setDate(5, new java.sql.Date(p.getTarikhLahir().getTime()));
        ps.setString(6, p.getJawatan());
        ps.setString(7, p.getKataLaluan());
        ps.setDate(8, new java.sql.Date(new Date().getTime()));  // Tarikh semasa
        ps.setString(9, p.getNamaJalan());
        ps.setString(10, p.getBandar());
        ps.setString(11, p.getNomborPoskod());
        ps.setString(12, p.getNegeri());
        ps.executeUpdate();
    }

    // Method lain jika perlu, e.g., update
}