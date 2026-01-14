package model;

import util.DBUtil;
import java.sql.*;

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