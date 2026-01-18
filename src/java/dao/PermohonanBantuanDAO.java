package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.PermohonanBantuan;

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

    public void updateStatus(int idPermohonan, int status, String ulasanAdmin) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "UPDATE Permohonan_Bantuan SET status = ?, ulasan_admin = ? WHERE idPermohonan = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, status);
        ps.setString(2, ulasanAdmin);
        ps.setInt(3, idPermohonan);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

public List<PermohonanBantuan> getAll() throws SQLException {
    List<PermohonanBantuan> list = new ArrayList<>();
    Connection conn = DBUtil.getConnection();
    
    // --- UPDATE SQL: Tambah JOIN ke table 'bantuan' ---
    String sql = "SELECT pb.*, u.NamaPertama, u.NamaKedua, b.namaBantuan " +
                 "FROM Permohonan_Bantuan pb " +
                 "JOIN Penduduk p ON pb.idPenduduk = p.idPenduduk " +
                 "JOIN Pengguna u ON p.idPengguna = u.idPengguna " + 
                 "JOIN bantuan b ON pb.idBantuan = b.idBantuan " + // JOIN BARU DI SINI
                 "ORDER BY pb.tarikhMohon DESC";
    
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
    
    while (rs.next()) {
        PermohonanBantuan pb = new PermohonanBantuan();
        
        // Data Asal
        pb.setIdPermohonan(rs.getInt("idPermohonan"));
        pb.setIdPenduduk(rs.getInt("idPenduduk"));
        pb.setIdBantuan(rs.getInt("idBantuan"));
        pb.setTarikhMohon(rs.getDate("tarikhMohon"));
        pb.setStatus(rs.getInt("status"));
        pb.setCatatan(rs.getString("catatan"));
        pb.setUlasanAdmin(rs.getString("ulasan_admin"));
        pb.setDokumen(rs.getString("dokumen"));
        pb.setDokumenBalik(rs.getString("dokumenBalik"));
        
        // Data Nama Pemohon
        String n1 = rs.getString("NamaPertama");
        String n2 = rs.getString("NamaKedua");
        if (n1 == null) n1 = "";
        if (n2 == null) n2 = "";
        pb.setNamaPemohon((n1 + " " + n2).trim().toUpperCase());
        
        // --- LOGIC BARU: SET NAMA BANTUAN ---
        String namaDariDB = rs.getString("namaBantuan");
        
        // Logic khas untuk ID 999 (Lain-lain)
        if (pb.getIdBantuan() == 999) {
            String fullCatatan = pb.getCatatan();
            if (fullCatatan != null && fullCatatan.contains("|")) {
                // Ambil teks sebelum tanda '|' sebagai nama bantuan
                String bersih = fullCatatan.replace("LAIN-LAIN: ", "");
                pb.setNamaBantuan(bersih.split("\\|")[0].trim().toUpperCase());
            } else {
                pb.setNamaBantuan("LAIN-LAIN");
            }
        } else {
            // Untuk bantuan biasa, ambil terus dari database
            pb.setNamaBantuan(namaDariDB != null ? namaDariDB.toUpperCase() : "TIDAK DIKETAHUI");
        }
        
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
    
    // SQL JOIN: Kita gabungkan table Permohonan dengan table Bantuan
    // "b.namaBantuan" ialah column dari table Bantuan.java anda
    String sql = "SELECT pb.*, b.namaBantuan " +
                 "FROM Permohonan_Bantuan pb " +
                 "JOIN bantuan b ON pb.idBantuan = b.idBantuan " + 
                 "WHERE pb.idPenduduk = ? " +
                 "ORDER BY pb.tarikhMohon DESC";
                 
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, idPenduduk);
    ResultSet rs = ps.executeQuery();
    
    while (rs.next()) {
        PermohonanBantuan pb = new PermohonanBantuan();
        pb.setIdPermohonan(rs.getInt("idPermohonan"));
        // ... set data lain ...
        pb.setIdBantuan(rs.getInt("idBantuan"));
        
        // --- LOGIC NAMA BANTUAN ---
        // 1. Ambil nama dari DB (hasil JOIN tadi)
        String namaDariDB = rs.getString("namaBantuan"); 
        
        // 2. Check kalau ID 999 (Lain-lain)
        if (pb.getIdBantuan() == 999) {
             String fullCatatan = rs.getString("catatan");
             if (fullCatatan != null && fullCatatan.contains("LAIN-LAIN:")) {
                 String bersih = fullCatatan.replace("LAIN-LAIN: ", "");
                 if (bersih.contains("|")) {
                     pb.setNamaBantuan(bersih.split("\\|")[0].trim().toUpperCase());
                 } else {
                     pb.setNamaBantuan(bersih.toUpperCase());
                 }
             } else {
                 pb.setNamaBantuan("LAIN-LAIN");
             }
        } else {
             // 3. Kalau bukan 999, guna nama dari table Bantuan terus!
             pb.setNamaBantuan(namaDariDB.toUpperCase());
        }
        
        // ... set data lain ...
        pb.setCatatan(rs.getString("catatan"));
        pb.setUlasanAdmin(rs.getString("ulasan_admin"));
        
        list.add(pb);
    }
    // ... close connection ...
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

// 1. Method to get single record for the Edit Form
public PermohonanBantuan getById(int idPermohonan) throws SQLException {
    PermohonanBantuan pb = null;
    Connection conn = DBUtil.getConnection();
    String sql = "SELECT * FROM Permohonan_Bantuan WHERE idPermohonan = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, idPermohonan);
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        pb = new PermohonanBantuan();
        pb.setIdPermohonan(rs.getInt("idPermohonan"));
        pb.setIdPenduduk(rs.getInt("idPenduduk"));
        pb.setIdBantuan(rs.getInt("idBantuan"));
        pb.setTarikhMohon(rs.getDate("tarikhMohon"));
        pb.setStatus(rs.getInt("status"));
        pb.setUlasanAdmin(rs.getString("ulasan_admin"));
        pb.setCatatan(rs.getString("catatan"));
        pb.setDokumen(rs.getString("dokumen")); // Start filename
        pb.setDokumenBalik(rs.getString("dokumenBalik"));
    }
    rs.close();
    ps.close();
    conn.close();
    return pb;
}

// 2. Method for Penduduk to update their own application
public void updateByPenduduk(PermohonanBantuan pb) throws SQLException {
    Connection conn = DBUtil.getConnection();
    
    // --- UBAH SINI: Tambah 'status = 0' ---
    // Ini akan reset status jadi 'Baru' supaya JKKK boleh nampak dan semak semula
    String sql = "UPDATE Permohonan_Bantuan SET idBantuan = ?, catatan = ?, dokumen = ?, status = 0 WHERE idPermohonan = ?";
    
    PreparedStatement ps = conn.prepareStatement(sql);
    
    ps.setInt(1, pb.getIdBantuan());
    ps.setString(2, pb.getCatatan());
    ps.setString(3, pb.getDokumen());
    ps.setInt(4, pb.getIdPermohonan()); // ID Permohonan jadi parameter ke-4 sekarang
    
    ps.executeUpdate();
    ps.close();
    conn.close();
}

}
