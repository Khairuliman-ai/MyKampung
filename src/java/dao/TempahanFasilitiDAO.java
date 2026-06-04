package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.TempahanFasiliti;
import util.DBUtil;
import util.StatusConstant;

/**
 * TempahanFasilitiDAO handles database CRUD operations for facility bookings.
 * This includes saving new bookings, retrieving booking histories, checking for slot conflicts,
 * validating active quotas, and aggregating booking statistics.
 */
public class TempahanFasilitiDAO {

    /**
     * Saves a new facility booking record in the database.
     * Sets the creation timestamp automatically to CURRENT_TIMESTAMP.
     * 
     * @param t the facility booking model containing booking details
     * @return true if the booking was saved successfully, false otherwise
     */
    public boolean simpanTempahanBaru(TempahanFasiliti t) {
        // Mengikut struktur gambar DB: tarikh_tempah, masa_mula, masa_tamat, status, dibuat_pada
        String sql = "INSERT INTO tempahan_fasiliti (id_pengguna, id_fasiliti, tarikh_tempah, masa_mula, masa_tamat, status, catatan_pemohon, dibuat_pada) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        boolean status = false;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, t.getId_pengguna());
            ps.setInt(2, t.getId_fasiliti());
            
            // Menggunakan method baru dari Model yang telah dibaiki
            ps.setDate(3, t.getTarikh_tempah());
            ps.setTime(4, t.getMasa_mula());
            ps.setTime(5, t.getMasa_tamat());
            ps.setString(6, t.getStatus());
            ps.setString(7, t.getCatatan_pemohon());
            
            int rowAffected = ps.executeUpdate();
            if (rowAffected > 0) {
                status = true;
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (simpanTempahan): " + e.getMessage());
            e.printStackTrace();
        }
        return status;
    }

    /**
     * Retrieves the booking history for a specific resident by their user ID.
     * Joins with the facility table to fetch facility details (name, coordinates, image).
     * Sorted by creation date descending.
     * 
     * @param idPengguna the resident's user ID
     * @return list of facility booking records
     */
    public List<TempahanFasiliti> dapatkanSejarahTempahanPenduduk(int idPengguna) {
        List<TempahanFasiliti> senarai = new ArrayList<>();
        String sql = "SELECT t.*, f.nama_fasiliti, f.latitude, f.longitude, f.gambar_fasiliti FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "WHERE t.id_pengguna = ? ORDER BY t.dibuat_pada DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idPengguna);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TempahanFasiliti t = mapRowBase(rs);
                    t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    t.setLatitude(rs.getObject("latitude") != null ? rs.getDouble("latitude") : null);
                    t.setLongitude(rs.getObject("longitude") != null ? rs.getDouble("longitude") : null);
                    t.setGambar_fasiliti(rs.getString("gambar_fasiliti"));
                    senarai.add(t);
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (dapatkanSejarah): " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Retrieves all facility bookings in the database.
     * Joins with facility and pengguna tables to resolve facility name and user full name.
     * Ordered by creation date descending.
     * 
     * @return list of all facility bookings
     */
    public List<TempahanFasiliti> dapatkanSemuaTempahan() {
        List<TempahanFasiliti> senarai = new ArrayList<>();
        String sql = "SELECT t.*, f.nama_fasiliti, p.nama_penuh FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "JOIN pengguna p ON t.id_pengguna = p.id_pengguna " +
                     "ORDER BY t.dibuat_pada DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TempahanFasiliti t = mapRowBase(rs);
                t.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
                t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                t.setNama_pengguna(rs.getString("nama_penuh"));
                senarai.add(t);
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (dapatkanSemua): " + e.getMessage());
        }
        return senarai;
    }

    /**
     * Retrieves a single facility booking by its unique identifier.
     * 
     * @param id the booking ID
     * @return the populated facility booking model, or null if not found
     */
    public TempahanFasiliti dapatkanTempahanById(int id) {
        TempahanFasiliti t = null;
        String sql = "SELECT t.*, f.nama_fasiliti, p.nama_penuh FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "JOIN pengguna p ON t.id_pengguna = p.id_pengguna " +
                     "WHERE t.id_tempahan = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    t = mapRowBase(rs);
                    t.setCatatan_pentadbir(rs.getString("catatan_pentadbir"));
                    t.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    t.setNama_pengguna(rs.getString("nama_penuh"));
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (getById): " + e.getMessage());
        }
        return t;
    }

    /**
     * Updates the status and administrator notes/catatan for a facility booking.
     * 
     * @param id the booking ID
     * @param status the new status string (e.g., LULUS, TOLAK)
     * @param catatan administrative remarks
     * @return true if updated successfully, false otherwise
     */
    public boolean kemaskiniStatus(int id, String status, String catatan) {
        String sql = "UPDATE tempahan_fasiliti SET status=?, catatan_pentadbir=?, dikemaskini_pada=NOW() WHERE id_tempahan=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, catatan);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("RALAT SQL (kemaskiniStatus): " + e.getMessage());
            return false;
        }
    }

    /**
     * Cancels a booking by changing its status to 'DIBATALKAN'.
     * Validates that the requesting user owns the booking, the booking is current/future,
     * and the status is currently either 'MENUNGGU' or 'LULUS'.
     * 
     * @param idTempahan the booking ID
     * @param idPengguna the ID of the user requesting the cancellation
     * @return true if the booking was successfully cancelled, false otherwise
     */
    public boolean batalTempahan(int idTempahan, int idPengguna) {
        String sql = "UPDATE tempahan_fasiliti SET status='" + StatusConstant.TEMPAHAN_DIBATAL + "', dikemaskini_pada=NOW() " +
                     "WHERE id_tempahan=? AND id_pengguna=? " +
                     "AND status IN ('" + StatusConstant.TEMPAHAN_MENUNGGU + "', '" + StatusConstant.TEMPAHAN_LULUS + "') " +
                     "AND (tarikh_tempah > CURRENT_DATE OR (tarikh_tempah = CURRENT_DATE AND masa_tamat > CURRENT_TIME))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTempahan);
            ps.setInt(2, idPengguna);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("RALAT SQL (batal): " + e.getMessage());
            return false;
        }
    }

    /**
     * Checks for any time conflicts for a given facility on a specific date.
     * A conflict occurs if there is an overlapping slot that is not rejected (TOLAK) or cancelled (DIBATAL).
     * 
     * @param idFasiliti the facility ID
     * @param tarikh the date of booking
     * @param mula the start time of the booking
     * @param tamat the end time of the booking
     * @return true if a conflict exists, false otherwise
     */
    public boolean semakKonflikMasa(int idFasiliti, java.sql.Date tarikh, java.sql.Time mula, java.sql.Time tamat) {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti " +
                     "WHERE id_fasiliti = ? AND tarikh_tempah = ? " +
                     "AND status NOT IN ('" + StatusConstant.TEMPAHAN_TOLAK + "', '" + StatusConstant.TEMPAHAN_DIBATAL + "') " +
                     "AND ((masa_mula < ? AND masa_tamat > ?) " +
                     "OR (masa_mula < ? AND masa_tamat > ?) " +
                     "OR (masa_mula >= ? AND masa_tamat <= ?))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setDate(2, tarikh);
            ps.setTime(3, tamat);
            ps.setTime(4, mula);
            ps.setTime(5, tamat);
            ps.setTime(6, mula);
            ps.setTime(7, mula);
            ps.setTime(8, tamat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("RALAT SQL (konflik): " + e.getMessage());
        }
        return false;
    }

    /**
     * Counts the total number of facility bookings in the database.
     * 
     * @return total booking count
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Retrieves the count of active bookings (approved or pending) scheduled in the future for a specific user and facility.
     * Used to enforce fair usage quotas.
     * 
     * @param idPengguna the resident's user ID
     * @param idFasiliti the facility ID
     * @return count of active future bookings
     */
    public int checkUserQuotaActive(int idPengguna, int idFasiliti) {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti " +
                     "WHERE id_pengguna = ? AND id_fasiliti = ? " +
                     "AND status IN ('" + StatusConstant.TEMPAHAN_MENUNGGU + "', '" + StatusConstant.TEMPAHAN_LULUS + "') " +
                     "AND (tarikh_tempah > CURRENT_DATE OR (tarikh_tempah = CURRENT_DATE AND masa_tamat > CURRENT_TIME))";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPengguna);
            ps.setInt(2, idFasiliti);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Updates the status and rejection reason (alasan penolakan) for a booking.
     * 
     * @param id the booking ID
     * @param status the new booking status
     * @param alasan the rejection reason
     * @return true if updated successfully, false otherwise
     */
    public boolean updateStatusTempahan(int id, String status, String alasan) {
        String sql = "UPDATE tempahan_fasiliti SET status=?, alasan_penolakan=?, dikemaskini_pada=NOW() WHERE id_tempahan=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, alasan);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Maps a database result set row to a TempahanFasiliti domain model.
     * 
     * @param rs the database ResultSet
     * @return the populated TempahanFasiliti model
     * @throws SQLException if a database error occurs during mapping
     */
    private TempahanFasiliti mapRowBase(ResultSet rs) throws SQLException {
        TempahanFasiliti t = new TempahanFasiliti();
        t.setId_tempahan(rs.getInt("id_tempahan"));
        t.setId_pengguna(rs.getInt("id_pengguna"));
        t.setId_fasiliti(rs.getInt("id_fasiliti"));
        t.setTarikh_tempah(rs.getDate("tarikh_tempah"));
        t.setMasa_mula(rs.getTime("masa_mula"));
        t.setMasa_tamat(rs.getTime("masa_tamat"));
        t.setStatus(rs.getString("status"));
        t.setCatatan_pemohon(rs.getString("catatan_pemohon"));
        t.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
        t.setAlasanPenolakan(rs.getString("alasan_penolakan"));
        return t;
    }

    /**
     * Retrieves approved booking counts grouped by facility name.
     * 
     * @return a map linking facility names to approved booking counts
     */
    public java.util.Map<String, Integer> getFasilitiUsageStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        String sql = "SELECT f.nama_fasiliti, COUNT(*) as count " +
                     "FROM tempahan_fasiliti t " +
                     "JOIN fasiliti f ON t.id_fasiliti = f.id_fasiliti " +
                     "WHERE t.status = ? " +
                     "GROUP BY f.nama_fasiliti";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, StatusConstant.TEMPAHAN_LULUS);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    stats.put(rs.getString("nama_fasiliti"), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Retrieves bookings status distributions, initializing keys with 0.
     * 
     * @return a map linking status names to booking counts
     */
    public java.util.Map<String, Integer> getFasilitiStatusStats() {
        java.util.Map<String, Integer> stats = new java.util.LinkedHashMap<>();
        stats.put("LULUS", 0);
        stats.put("MENUNGGU_KELULUSAN", 0);
        stats.put("TOLAK", 0);
        stats.put("DIBATALKAN", 0);
        
        String sql = "SELECT status, COUNT(*) as count FROM tempahan_fasiliti GROUP BY status";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                if (status != null) {
                    stats.put(status.toUpperCase(), rs.getInt("count"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Counts the number of bookings that match a specific status string.
     * 
     * @param status the status string
     * @return the count of bookings
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM tempahan_fasiliti WHERE status = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

