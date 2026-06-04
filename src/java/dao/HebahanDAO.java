package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Hebahan;
import util.DBUtil;

/**
 * HebahanDAO handles database CRUD operations for community announcements (hebahan).
 * This includes listing announcements, filtering by status (e.g., Published/Draft),
 * keyword searching, updating content, soft-deletion, and retrieving announcement metrics.
 */
public class HebahanDAO {

    /**
     * Inserts a new announcement record into the database.
     * The announcement date (tarikh_hebahan) is automatically set to CURDATE().
     * 
     * @param h the announcement model to insert
     * @return true if the insert succeeded, false otherwise
     */
    public boolean insertHebahan(Hebahan h) {
        String sql = "INSERT INTO hebahan (id_pengguna, tajuk, kandungan, kategori, "
            + "gambar_poster, status_hebahan, tarikh_mula_acara, tarikh_tamat_acara, "
            + "lokasi_acara, tarikh_tamat, tarikh_hebahan) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, h.getId_pengguna());
            ps.setString(2, h.getTajuk());
            ps.setString(3, h.getKandungan());
            ps.setString(4, h.getKategori());
            ps.setString(5, h.getGambar_poster());
            ps.setString(6, h.getStatus_hebahan());
            ps.setTimestamp(7, h.getTarikh_mula_acara() != null
                ? new Timestamp(h.getTarikh_mula_acara().getTime()) : null);
            ps.setTimestamp(8, h.getTarikh_tamat_acara() != null
                ? new Timestamp(h.getTarikh_tamat_acara().getTime()) : null);
            ps.setString(9, h.getLokasi_acara());
            ps.setTimestamp(10, h.getTarikh_tamat() != null
                ? new Timestamp(h.getTarikh_tamat().getTime()) : null);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Retrieves all announcements that are not soft-deleted.
     * Joins with the pengguna table to resolve the creator's full name.
     * 
     * @param sortOrder sorting direction ("ASC" or "DESC"), defaults to "DESC" if invalid
     * @return list of announcements sorted by announcement date and creation date
     */
    public List<Hebahan> getAll(String sortOrder) {
        if (sortOrder == null || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "DESC";
        }
        List<Hebahan> list = new ArrayList<>();
        String sql = "SELECT h.*, p.nama_penuh FROM hebahan h "
            + "JOIN pengguna p ON h.id_pengguna = p.id_pengguna "
            + "WHERE h.dipadam_pada IS NULL ORDER BY h.tarikh_hebahan " + sortOrder + ", h.dibuat_pada " + sortOrder;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Overloaded method to retrieve all announcements in descending order.
     * 
     * @return list of announcements sorted descending
     */
    public List<Hebahan> getAll() {
        return getAll("DESC");
    }

    /**
     * Retrieves all published announcements that are current (not expired).
     * Orders them by category priority (Emergency, Activity, General) and announcement date.
     * 
     * @param sortOrder sorting direction ("ASC" or "DESC")
     * @return list of current published announcements
     */
    public List<Hebahan> getPublished(String sortOrder) {
        if (sortOrder == null || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "DESC";
        }
        List<Hebahan> list = new ArrayList<>();
        String sql = "SELECT h.*, p.nama_penuh FROM hebahan h "
            + "JOIN pengguna p ON h.id_pengguna = p.id_pengguna "
            + "WHERE h.status_hebahan = 'Published' "
            + "AND h.dipadam_pada IS NULL "
            + "AND (h.tarikh_tamat IS NULL OR h.tarikh_tamat > NOW()) "
            + "ORDER BY FIELD(h.kategori, 'Kecemasan', 'Aktiviti', 'Umum'), "
            + "h.tarikh_hebahan " + sortOrder;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Overloaded method to retrieve published announcements in descending order.
     * 
     * @return list of published announcements sorted descending
     */
    public List<Hebahan> getPublished() {
        return getPublished("DESC");
    }

    /**
     * Retrieves a single announcement by its unique identifier.
     * 
     * @param id the unique announcement ID
     * @return the populated Hebahan model, or null if not found
     */
    public Hebahan getById(int id) {
        String sql = "SELECT h.*, p.nama_penuh FROM hebahan h "
            + "JOIN pengguna p ON h.id_pengguna = p.id_pengguna "
            + "WHERE h.id_hebahan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Searches current published announcements by title or content matching the keyword.
     * 
     * @param keyword search keyword
     * @param sortOrder sorting direction ("ASC" or "DESC")
     * @return list of matching announcements
     */
    public List<Hebahan> searchPublished(String keyword, String sortOrder) {
        if (sortOrder == null || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "DESC";
        }
        List<Hebahan> list = new ArrayList<>();
        String sql = "SELECT h.*, p.nama_penuh FROM hebahan h "
            + "JOIN pengguna p ON h.id_pengguna = p.id_pengguna "
            + "WHERE h.status_hebahan = 'Published' "
            + "AND h.dipadam_pada IS NULL "
            + "AND (h.tarikh_tamat IS NULL OR h.tarikh_tamat > NOW()) "
            + "AND (h.tajuk LIKE ? OR h.kandungan LIKE ?) "
            + "ORDER BY FIELD(h.kategori, 'Kecemasan', 'Aktiviti', 'Umum'), "
            + "h.tarikh_hebahan " + sortOrder;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String q = "%" + keyword + "%";
            ps.setString(1, q);
            ps.setString(2, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Overloaded method to search published announcements in descending order.
     * 
     * @param keyword search keyword
     * @return list of matching announcements sorted descending
     */
    public List<Hebahan> searchPublished(String keyword) {
        return searchPublished(keyword, "DESC");
    }

    /**
     * Retrieves all non-deleted announcements created by a specific user.
     * 
     * @param idPengguna the creator's user ID
     * @return list of announcements sorted by creation date descending
     */
    public List<Hebahan> getByPengguna(int idPengguna) {
        List<Hebahan> list = new ArrayList<>();
        String sql = "SELECT h.*, p.nama_penuh FROM hebahan h "
            + "JOIN pengguna p ON h.id_pengguna = p.id_pengguna "
            + "WHERE h.id_pengguna = ? AND h.dipadam_pada IS NULL "
            + "ORDER BY h.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Updates an existing announcement's attributes.
     * Coalesces the poster image path to retain the old value if the new path is null.
     * 
     * @param h the announcement model containing updated values
     * @return true if updated successfully, false otherwise
     */
    public boolean updateHebahan(Hebahan h) {
        String sql = "UPDATE hebahan SET tajuk=?, kandungan=?, kategori=?, "
            + "gambar_poster=COALESCE(?,gambar_poster), status_hebahan=?, "
            + "tarikh_mula_acara=?, tarikh_tamat_acara=?, lokasi_acara=?, "
            + "tarikh_tamat=? WHERE id_hebahan=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, h.getTajuk());
            ps.setString(2, h.getKandungan());
            ps.setString(3, h.getKategori());
            ps.setString(4, h.getGambar_poster());
            ps.setString(5, h.getStatus_hebahan());
            ps.setTimestamp(6, h.getTarikh_mula_acara() != null
                ? new Timestamp(h.getTarikh_mula_acara().getTime()) : null);
            ps.setTimestamp(7, h.getTarikh_tamat_acara() != null
                ? new Timestamp(h.getTarikh_tamat_acara().getTime()) : null);
            ps.setString(8, h.getLokasi_acara());
            ps.setTimestamp(9, h.getTarikh_tamat() != null
                ? new Timestamp(h.getTarikh_tamat().getTime()) : null);
            ps.setInt(10, h.getId_hebahan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Performs a soft-delete on an announcement by setting its dipadam_pada timestamp to NOW().
     * 
     * @param id the unique announcement ID
     * @return true if updated successfully, false otherwise
     */
    public boolean softDelete(int id) {
        String sql = "UPDATE hebahan SET dipadam_pada = NOW() WHERE id_hebahan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Updates the status of an announcement (e.g. Draft -> Published).
     * 
     * @param id the unique announcement ID
     * @param status the new status string
     * @return true if updated successfully, false otherwise
     */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE hebahan SET status_hebahan = ? WHERE id_hebahan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * Counts all non-deleted announcements matching a specific status string.
     * 
     * @param status the status string to count
     * @return count of matching announcements
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM hebahan WHERE status_hebahan=? AND dipadam_pada IS NULL";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * Maps a database result set row to a Hebahan domain model.
     * 
     * @param rs the database ResultSet
     * @return the populated Hebahan model
     * @throws SQLException if a database error occurs during mapping
     */
    private Hebahan mapRow(ResultSet rs) throws SQLException {
        Hebahan h = new Hebahan();
        h.setId_hebahan(rs.getInt("id_hebahan"));
        h.setId_pengguna(rs.getInt("id_pengguna"));
        h.setTajuk(rs.getString("tajuk"));
        h.setKandungan(rs.getString("kandungan"));
        h.setKategori(rs.getString("kategori"));
        h.setGambar_poster(rs.getString("gambar_poster"));
        h.setStatus_hebahan(rs.getString("status_hebahan"));
        h.setTarikh_mula_acara(rs.getTimestamp("tarikh_mula_acara"));
        h.setTarikh_tamat_acara(rs.getTimestamp("tarikh_tamat_acara"));
        h.setLokasi_acara(rs.getString("lokasi_acara"));
        h.setTarikh_tamat(rs.getTimestamp("tarikh_tamat"));
        h.setTarikh_hebahan(rs.getDate("tarikh_hebahan"));
        h.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        h.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
        h.setDipadam_pada(rs.getTimestamp("dipadam_pada"));
        h.setNama_penuh(rs.getString("nama_penuh"));
        return h;
    }
}
