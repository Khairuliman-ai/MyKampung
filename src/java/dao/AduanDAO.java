package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Aduan;
import util.DBUtil;

public class AduanDAO {

    public boolean insertAduan(Aduan aduan) {
        String sql = "INSERT INTO aduan (id_pengguna, id_kategori_aduan, tajuk, keterangan, status, keutamaan, gambar_aduan, id_pengendali) VALUES (?, ?, ?, ?, 'SUBMITTED', ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, aduan.getId_pengguna());
            ps.setInt(2, aduan.getId_kategori_aduan());
            ps.setString(3, aduan.getTajuk());
            ps.setString(4, aduan.getKeterangan());
            ps.setString(5, aduan.getKeutamaan() != null ? aduan.getKeutamaan() : "SEDERHANA");
            ps.setString(6, aduan.getGambar_aduan());
            if (aduan.getId_pengendali() != null) ps.setInt(7, aduan.getId_pengendali());
            else ps.setNull(7, Types.INTEGER);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Aduan getById(int id) {
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Aduan> getByPenduduk(int idPengguna) {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.id_pengguna = ? AND a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Aduan> getByPengendali(int idAJK) {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE (a.id_pengendali = ? OR (a.id_pengendali IS NULL AND a.status = 'SUBMITTED')) " +
                     "AND a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAJK);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Integer getAJKIdByJawatan(int idJawatan) {
        String sql = "SELECT id_pengguna FROM ajk_jawatan WHERE id_jawatan = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idJawatan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id_pengguna");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Aduan> getAll() {
        List<Aduan> list = new ArrayList<>();
        String sql = "SELECT a.*, p.nama_penuh, k.nama_kategori, p2.nama_penuh as nama_pengendali " +
                     "FROM aduan a " +
                     "JOIN pengguna p ON a.id_pengguna = p.id_pengguna " +
                     "JOIN kategori_aduan k ON a.id_kategori_aduan = k.id_kategori_aduan " +
                     "LEFT JOIN pengguna p2 ON a.id_pengendali = p2.id_pengguna " +
                     "WHERE a.dipadam_pada IS NULL " +
                     "ORDER BY a.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status, String catatanField, String catatanValue) {
        if (!"catatan_ajk".equals(catatanField) && !"catatan_ketua".equals(catatanField) && !"catatan_pentadbir".equals(catatanField)) {
            throw new IllegalArgumentException("Nama medan catatan tidak sah: " + catatanField);
        }
        String sql = "UPDATE aduan SET status = ?, " + catatanField + " = ?, dikemaskini_pada = NOW() WHERE id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, catatanValue);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignPengendali(int idAduan, int idAJK) {
        String sql = "UPDATE aduan SET id_pengendali = ? WHERE id_aduan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAJK);
            ps.setInt(2, idAduan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Aduan mapRow(ResultSet rs) throws SQLException {
        Aduan a = new Aduan();
        a.setId_aduan(rs.getInt("id_aduan"));
        a.setId_pengguna(rs.getInt("id_pengguna"));
        a.setId_kategori_aduan(rs.getInt("id_kategori_aduan"));
        int pengendali = rs.getInt("id_pengendali");
        a.setId_pengendali(rs.wasNull() ? null : pengendali);
        a.setTajuk(rs.getString("tajuk"));
        a.setKeterangan(rs.getString("keterangan"));
        a.setStatus(rs.getString("status"));
        a.setKeutamaan(rs.getString("keutamaan"));
        a.setGambar_aduan(rs.getString("gambar_aduan"));
        a.setBukti_selesai(rs.getString("bukti_selesai"));
        a.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
        a.setCatatan_ajk(rs.getString("catatan_ajk"));
        a.setCatatan_ketua(rs.getString("catatan_ketua"));
        a.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        a.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
        a.setDipadam_pada(rs.getTimestamp("dipadam_pada"));
        
        a.setNama_penuh(rs.getString("nama_penuh"));
        a.setNama_kategori(rs.getString("nama_kategori"));
        a.setNama_pengendali(rs.getString("nama_pengendali"));
        return a;
    }
}
