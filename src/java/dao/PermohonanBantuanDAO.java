package dao;

import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PermohonanBantuan;

public class PermohonanBantuanDAO {
    private BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();

    public List<PermohonanBantuan> getByPenduduk(int idPenduduk) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenduduk);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(pb.getId_permohonan()));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PermohonanBantuan> getByPendudukAndKategori(int idPenduduk, String kategori) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "WHERE pb.id_pengguna = ? AND b.jenis_bantuan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPenduduk);
            ps.setString(2, kategori);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(pb.getId_permohonan()));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PermohonanBantuan> getAll() {
        return getAllPaginated(0, Integer.MAX_VALUE);
    }

    public List<PermohonanBantuan> getAllPaginated(int offset, int limit) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "ORDER BY pb.dibuat_pada DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    try {
                        pb.setNama_penuh(rs.getString("nama_penuh"));
                        pb.setNombor_kp(rs.getString("nombor_kp"));
                        pb.setNombor_telefon(rs.getString("nombor_telefon"));
                        pb.setStatus_keluarga(rs.getString("status_keluarga"));
                        pb.setPekerjaan(rs.getString("pekerjaan"));
                        pb.setPendapatan(rs.getDouble("pendapatan"));
                    } catch (SQLException e) {}
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(pb.getId_permohonan()));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PermohonanBantuan> getByStatus(String status) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "WHERE pb.status = ? " +
                     "ORDER BY pb.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setNama_penuh(rs.getString("nama_penuh"));
                    pb.setNombor_kp(rs.getString("nombor_kp"));
                    pb.setNombor_telefon(rs.getString("nombor_telefon"));
                    pb.setStatus_keluarga(rs.getString("status_keluarga"));
                    pb.setPekerjaan(rs.getString("pekerjaan"));
                    pb.setPendapatan(rs.getDouble("pendapatan"));
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(pb.getId_permohonan()));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PermohonanBantuan> getSejarahPaginated(int offset, int limit) {
        List<PermohonanBantuan> list = new ArrayList<>();
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan, p.nama_penuh, p.nombor_kp, p.nombor_telefon, p.status_keluarga, p.pekerjaan, p.pendapatan " +
                     "FROM permohonan_bantuan pb " +
                     "JOIN bantuan b ON pb.id_bantuan = b.id_bantuan " +
                     "JOIN pengguna p ON pb.id_pengguna = p.id_pengguna " +
                     "WHERE pb.status != 'BARU' " +
                     "ORDER BY pb.dibuat_pada DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setNama_penuh(rs.getString("nama_penuh"));
                    pb.setNombor_kp(rs.getString("nombor_kp"));
                    pb.setNombor_telefon(rs.getString("nombor_telefon"));
                    pb.setStatus_keluarga(rs.getString("status_keluarga"));
                    pb.setPekerjaan(rs.getString("pekerjaan"));
                    pb.setPendapatan(rs.getDouble("pendapatan"));
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(pb.getId_permohonan()));
                    list.add(pb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getSejarahCount() {
        String sql = "SELECT COUNT(*) FROM permohonan_bantuan WHERE status != 'BARU'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public PermohonanBantuan getById(int idPermohonan) {
        String sql = "SELECT pb.*, b.nama_bantuan, b.jenis_bantuan FROM permohonan_bantuan pb JOIN bantuan b ON pb.id_bantuan = b.id_bantuan WHERE pb.id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PermohonanBantuan pb = mapRow(rs);
                    pb.setSenaraiLampiran(lampiranDao.getByPermohonan(idPermohonan));
                    return pb;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteByIdAndPenduduk(int idPermohonan, int idPenduduk) {
        String sql = "DELETE FROM permohonan_bantuan WHERE id_permohonan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPermohonan);
            ps.setInt(2, idPenduduk);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int insertPermohonan(PermohonanBantuan pb) {
        String sql = "INSERT INTO permohonan_bantuan (id_pengguna, id_bantuan, catatan_pemohon, nama_bank, nombor_akaun, penyata_bank, dibuat_pada, status) VALUES (?, ?, ?, ?, ?, ?, NOW(), 'BARU')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, pb.getId_pengguna());
            ps.setInt(2, pb.getId_bantuan());
            ps.setString(3, pb.getCatatan_pemohon());
            ps.setString(4, pb.getNama_bank());
            ps.setString(5, pb.getNombor_akaun());
            ps.setString(6, pb.getPenyata_bank());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updatePermohonan(PermohonanBantuan pb) {
        String sql = "UPDATE permohonan_bantuan SET id_bantuan = ?, catatan_pemohon = ?, nama_bank = ?, nombor_akaun = ?, penyata_bank = ?, status = 'BARU', dikemaskini_pada = NOW() WHERE id_permohonan = ? AND id_pengguna = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pb.getId_bantuan());
            ps.setString(2, pb.getCatatan_pemohon());
            ps.setString(3, pb.getNama_bank());
            ps.setString(4, pb.getNombor_akaun());
            ps.setString(5, pb.getPenyata_bank());
            ps.setInt(6, pb.getId_permohonan_bantuan());
            ps.setInt(7, pb.getId_pengguna());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int idPermohonan, int statusInt, String ulasanAdmin, String dokumenSokongan) {
        // Map int to Enum String
        String statusStr = "BARU";
        if (statusInt == 1) statusStr = "LULUS";
        else if (statusInt == 2) statusStr = "DIKEMBALIKAN";
        else if (statusInt == 3) statusStr = "MENUNGGU_KETUA";
        else if (statusInt == 4) statusStr = "DITOLAK";

        String sql = "UPDATE permohonan_bantuan SET status = ?, catatan_pentadbir = ?, dikemaskini_pada = NOW() WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, statusStr);
            ps.setString(2, ulasanAdmin);
            ps.setInt(3, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInfo(int idPermohonan, String catatan, String dokumen) {
        String sql = "UPDATE permohonan_bantuan SET catatan_pemohon = ?, dikemaskini_pada = NOW() WHERE id_permohonan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, catatan);
            ps.setInt(2, idPermohonan);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private PermohonanBantuan mapRow(ResultSet rs) throws SQLException {
        PermohonanBantuan pb = new PermohonanBantuan();
        pb.setId_permohonan(rs.getInt("id_permohonan"));
        pb.setId_pengguna(rs.getInt("id_pengguna"));
        pb.setId_bantuan(rs.getInt("id_bantuan"));
        pb.setDibuat_pada(rs.getDate("dibuat_pada"));
        pb.setDikemaskini_pada(rs.getDate("dikemaskini_pada"));
        pb.setDipadam_pada(rs.getDate("dipadam_pada"));
        pb.setStatus(rs.getString("status"));
        pb.setCatatan_pemohon(rs.getString("catatan_pemohon"));
        pb.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
        pb.setDokumen_pentadbir(rs.getString("dokumen_pentadbir"));
        
        try { pb.setNama_bank(rs.getString("nama_bank")); } catch (SQLException e) {}
        try { pb.setNombor_akaun(rs.getString("nombor_akaun")); } catch (SQLException e) {}
        try { pb.setPenyata_bank(rs.getString("penyata_bank")); } catch (SQLException e) {}

        try {
            pb.setNama_bantuan(rs.getString("nama_bantuan"));
        } catch (SQLException e) {}
        try {
            pb.setJenis_bantuan(rs.getString("jenis_bantuan"));
        } catch (SQLException e) {}
        return pb;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM permohonan_bantuan";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}