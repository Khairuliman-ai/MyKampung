package dao;

import util.DBUtil;
import java.sql.*;
import model.Penduduk;

public class PendudukDAO {
    public void insert(Penduduk pd) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "INSERT INTO Penduduk (idPengguna, statusSemasa, pekerjaan, pendapatan) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, pd.getIdPengguna());
        ps.setString(2, pd.getStatusSemasa());
        ps.setString(3, pd.getPekerjaan());
        ps.setInt(4, pd.getPendapatan());
        ps.executeUpdate();
        ResultSet generatedKeys = ps.getGeneratedKeys();
        if (generatedKeys.next()) {
            pd.setIdPenduduk(generatedKeys.getInt(1));
        }
    }
    
    public void createDefaultProfile(int idPengguna) {
        String sql = "INSERT INTO Penduduk (idPengguna, statusSemasa, pekerjaan, pendapatan) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idPengguna);
            ps.setString(2, "Belum Dikemaskini"); // Default value
            ps.setString(3, "-");                 // Default value
            ps.setInt(4, 0);                      // Default value
            
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Penduduk getByUserId(int idPengguna) {
        String sql = "SELECT * FROM Penduduk WHERE idPengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Penduduk p = new Penduduk();
                p.setIdPenduduk(rs.getInt("idPenduduk"));
                p.setIdPengguna(rs.getInt("idPengguna"));
                p.setStatusSemasa(rs.getString("statusSemasa"));
                p.setPekerjaan(rs.getString("pekerjaan"));
                p.setPendapatan(rs.getInt("pendapatan"));
                return p;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Method update detail Penduduk
    public void updatePenduduk(Penduduk p) {
        String sql = "UPDATE Penduduk SET statusSemasa=?, pekerjaan=?, pendapatan=? WHERE idPengguna=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getStatusSemasa());
            ps.setString(2, p.getPekerjaan());
            ps.setInt(3, p.getPendapatan());
            ps.setInt(4, p.getIdPengguna());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public Penduduk getByIdPengguna(int idPengguna) throws SQLException {
        Connection conn = DBUtil.getConnection();
        String sql = "SELECT * FROM Penduduk WHERE idPengguna = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, idPengguna);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Penduduk pd = new Penduduk();
            pd.setIdPenduduk(rs.getInt("idPenduduk"));
            pd.setIdPengguna(rs.getInt("idPengguna"));
            pd.setStatusSemasa(rs.getString("statusSemasa"));
            pd.setPekerjaan(rs.getString("pekerjaan"));
            pd.setPendapatan(rs.getInt("pendapatan"));
            return pd;
        }
        return null;
    }
}