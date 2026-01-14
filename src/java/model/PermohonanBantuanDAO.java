package model;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PermohonanBantuanDAO {

    public void insert(PermohonanBantuan pb) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO Permohonan_Bantuan (idPenduduk, idBantuan, tarikhMohon, status, catatan, dokumen) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, pb.getIdPenduduk());
        ps.setInt(2, pb.getIdBantuan());
        ps.setDate(3, new java.sql.Date(new Date().getTime()));
        ps.setInt(4, 0);
        ps.setString(5, pb.getCatatan());
        ps.setString(6, pb.getDokumen());
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public void updateDokumenBalik(int idPermohonan, String dokumenBalik, String catatan) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "UPDATE Permohonan_Bantuan SET dokumenBalik = ?, catatan = ? WHERE idPermohonan = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, dokumenBalik);
        ps.setString(2, catatan);
        ps.setInt(3, idPermohonan);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public void updateStatus(int idPermohonan, int status, String catatan) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "UPDATE Permohonan_Bantuan SET status = ?, catatan = ? WHERE idPermohonan = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, status);
        ps.setString(2, catatan);
        ps.setInt(3, idPermohonan);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public List<PermohonanBantuan> getAll() throws SQLException {
        List<PermohonanBantuan> list = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM Permohonan_Bantuan");
        while (rs.next()) {
            PermohonanBantuan pb = new PermohonanBantuan();
            pb.setIdPermohonan(rs.getInt("idPermohonan"));
            pb.setIdPenduduk(rs.getInt("idPenduduk"));
            pb.setIdBantuan(rs.getInt("idBantuan"));
            pb.setTarikhMohon(rs.getDate("tarikhMohon"));
            pb.setStatus(rs.getInt("status"));
            pb.setCatatan(rs.getString("catatan"));
            pb.setDokumen(rs.getString("dokumen"));
            pb.setDokumenBalik(rs.getString("dokumenBalik"));
            list.add(pb);
        }
        rs.close();
        stmt.close();
        conn.close();
        return list;
    }

    public List<PermohonanBantuan> getByPenduduk(int idPenduduk) throws SQLException {
        List<PermohonanBantuan> list = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Permohonan_Bantuan WHERE idPenduduk = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, idPenduduk);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            PermohonanBantuan pb = new PermohonanBantuan();
            pb.setIdPermohonan(rs.getInt("idPermohonan"));
            pb.setIdPenduduk(rs.getInt("idPenduduk"));
            pb.setIdBantuan(rs.getInt("idBantuan"));
            pb.setTarikhMohon(rs.getDate("tarikhMohon"));
            pb.setStatus(rs.getInt("status"));
            pb.setCatatan(rs.getString("catatan"));
            pb.setDokumen(rs.getString("dokumen"));
            pb.setDokumenBalik(rs.getString("dokumenBalik"));
            list.add(pb);
        }
        rs.close();
        ps.close();
        conn.close();
        return list;
    }

    public void deleteByIdAndPenduduk(int idPermohonan, int idPenduduk) throws SQLException {
        String sql = "DELETE FROM Permohonan_Bantuan WHERE idPermohonan=? AND idPenduduk=?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            ps.setInt(2, idPenduduk);
            ps.executeUpdate();
        }
    }
    
    // Dalam PermohonanBantuanDAO.java

public void updateInfo(int idPermohonan, String catatan, String dokumenBalik) throws SQLException {
    String sql;
    
    // Jika ada file baru diupload, update column dokumen_balik
    if (dokumenBalik != null) {
        sql = "UPDATE permohonan_bantuan SET catatan = ?, dokumen_balik = ? WHERE id_permohonan = ?";
    } else {
        // Jika tiada file, cuma update catatan sahaja
        sql = "UPDATE permohonan_bantuan SET catatan = ? WHERE id_permohonan = ?";
    }

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, catatan);
        
        if (dokumenBalik != null) {
            ps.setString(2, dokumenBalik);
            ps.setInt(3, idPermohonan);
        } else {
            ps.setInt(2, idPermohonan);
        }
        
        ps.executeUpdate();
    }
}

}
