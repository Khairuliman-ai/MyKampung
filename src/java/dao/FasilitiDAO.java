package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Fasiliti;
import util.DBUtil;
import util.StatusConstant;

/**
 * FasilitiDAO handles database CRUD operations for village facilities.
 * This includes listing active/inactive facilities, retrieving facility coordinates,
 * updating attributes, soft-deletion, and calculating live occupancy counts.
 */
public class FasilitiDAO {

    /**
     * Retrieves all active facilities from the database.
     * Computes the current occupancy status based on active approved bookings.
     * 
     * @return a list of active Fasiliti objects
     */
    public List<Fasiliti> dapatkanSemuaFasiliti() {
        List<Fasiliti> senarai = new ArrayList<>();
        String sql = "SELECT f.*, " +
                     "(SELECT COUNT(*) FROM tempahan_fasiliti t " +
                     " WHERE t.id_fasiliti = f.id_fasiliti " +
                     " AND t.tarikh_tempah = CURRENT_DATE() " +
                     " AND t.status = '" + StatusConstant.TEMPAHAN_LULUS + "' " +
                     " AND CURRENT_TIME() BETWEEN t.masa_mula AND t.masa_tamat) as occupancy_count, " +
                     "f.requires_approval " +
                     "FROM fasiliti f WHERE f.status = '" + StatusConstant.FASILITI_AKTIF + "'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Fasiliti f = new Fasiliti();
                f.setId_fasiliti(rs.getInt("id_fasiliti"));
                f.setNama_fasiliti(rs.getString("nama_fasiliti"));
                f.setLokasi(rs.getString("lokasi"));
                f.setStatus(rs.getString("status"));
                f.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                f.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
                f.setDipadam_pada(rs.getTimestamp("dipadam_pada"));

                double lat = rs.getDouble("latitude");
                f.setLatitude(rs.wasNull() ? null : lat);
                double lon = rs.getDouble("longitude");
                f.setLongitude(rs.wasNull() ? null : lon);

                f.setOccupied(rs.getInt("occupancy_count") > 0);
                f.setRequiresApproval(rs.getBoolean("requires_approval"));
                f.setGambar_fasiliti(rs.getString("gambar_fasiliti"));
                f.setWaktu_buka(rs.getTime("waktu_buka"));
                f.setWaktu_tutup(rs.getTime("waktu_tutup"));
                f.setDurasi_slot_minit(rs.getInt("durasi_slot_minit"));
                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }

    /**
     * Retrieves a single facility by its unique identifier.
     * 
     * @param id the unique facility ID
     * @return the populated Fasiliti model, or null if not found
     */
    public Fasiliti dapatkanFasilitiById(int id) {
        Fasiliti f = null;
        String sql = "SELECT * FROM fasiliti WHERE id_fasiliti = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    f = new Fasiliti();
                    f.setId_fasiliti(rs.getInt("id_fasiliti"));
                    f.setNama_fasiliti(rs.getString("nama_fasiliti"));
                    f.setLokasi(rs.getString("lokasi"));
                    f.setStatus(rs.getString("status"));
                    f.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                    f.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
                    f.setDipadam_pada(rs.getTimestamp("dipadam_pada"));

                    double lat = rs.getDouble("latitude");
                    f.setLatitude(rs.wasNull() ? null : lat);
                    double lon = rs.getDouble("longitude");
                    f.setLongitude(rs.wasNull() ? null : lon);
                    f.setRequiresApproval(rs.getBoolean("requires_approval"));
                    f.setGambar_fasiliti(rs.getString("gambar_fasiliti"));
                    f.setWaktu_buka(rs.getTime("waktu_buka"));
                    f.setWaktu_tutup(rs.getTime("waktu_tutup"));
                    f.setDurasi_slot_minit(rs.getInt("durasi_slot_minit"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (getById): " + e.getMessage());
        }
        return f;
    }

    /**
     * Inserts a new facility record into the database, setting its initial status to active.
     * 
     * @param f the facility model to insert
     * @return true if the insert succeeded, false otherwise
     */
    public boolean tambahFasiliti(Fasiliti f) {
        String sql = "INSERT INTO fasiliti (nama_fasiliti, lokasi, status, latitude, longitude, requires_approval, gambar_fasiliti, waktu_buka, waktu_tutup, durasi_slot_minit) VALUES (?, ?, '" + StatusConstant.FASILITI_AKTIF + "', ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            if (f.getLatitude() != null) ps.setDouble(3, f.getLatitude()); else ps.setNull(3, java.sql.Types.DECIMAL);
            if (f.getLongitude() != null) ps.setDouble(4, f.getLongitude()); else ps.setNull(4, java.sql.Types.DECIMAL);
            ps.setBoolean(5, f.isRequiresApproval());
            ps.setString(6, f.getGambar_fasiliti());
            ps.setTime(7, f.getWaktu_buka() != null ? f.getWaktu_buka() : java.sql.Time.valueOf("08:00:00"));
            ps.setTime(8, f.getWaktu_tutup() != null ? f.getWaktu_tutup() : java.sql.Time.valueOf("22:00:00"));
            ps.setInt(9, f.getDurasi_slot_minit() > 0 ? f.getDurasi_slot_minit() : 120);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (tambah): " + e.getMessage());
            return false;
        }
    }

    /**
     * Updates an existing facility's details and sets the dikemaskini_pada field to NOW().
     * 
     * @param f the facility model containing updated values
     * @return true if the update was successful, false otherwise
     */
    public boolean kemaskiniFasiliti(Fasiliti f) {
        String sql = "UPDATE fasiliti SET nama_fasiliti=?, lokasi=?, status=?, latitude=?, longitude=?, requires_approval=?, gambar_fasiliti=?, waktu_buka=?, waktu_tutup=?, durasi_slot_minit=?, dikemaskini_pada=NOW() WHERE id_fasiliti=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            ps.setString(3, f.getStatus());
            if (f.getLatitude() != null) ps.setDouble(4, f.getLatitude()); else ps.setNull(4, java.sql.Types.DECIMAL);
            if (f.getLongitude() != null) ps.setDouble(5, f.getLongitude()); else ps.setNull(5, java.sql.Types.DECIMAL);
            ps.setBoolean(6, f.isRequiresApproval());
            ps.setString(7, f.getGambar_fasiliti());
            ps.setTime(8, f.getWaktu_buka() != null ? f.getWaktu_buka() : java.sql.Time.valueOf("08:00:00"));
            ps.setTime(9, f.getWaktu_tutup() != null ? f.getWaktu_tutup() : java.sql.Time.valueOf("22:00:00"));
            ps.setInt(10, f.getDurasi_slot_minit() > 0 ? f.getDurasi_slot_minit() : 120);
            ps.setInt(11, f.getId_fasiliti());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (kemaskini): " + e.getMessage());
            return false;
        }
    }

    /**
     * Soft-deletes a facility by setting its status to inactive and dipadam_pada to NOW().
     * 
     * @param id the facility ID to deactivate
     * @return true if the status update succeeded, false otherwise
     */
    public boolean padamFasiliti(int id) {
        String sql = "UPDATE fasiliti SET status='" + StatusConstant.FASILITI_TIDAK_AKTIF + "', dipadam_pada=NOW() WHERE id_fasiliti=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (padam): " + e.getMessage());
            return false;
        }
    }

    /**
     * Retrieves all facilities in the database, including inactive/soft-deleted ones.
     * Computes occupancy stats based on current time.
     * 
     * @return a list of all facilities
     */
    public List<Fasiliti> dapatkanSemuaTermasukTidakAktif() {
        List<Fasiliti> senarai = new ArrayList<>();
        String sql = "SELECT f.*, " +
                     "(SELECT COUNT(*) FROM tempahan_fasiliti t " +
                     " WHERE t.id_fasiliti = f.id_fasiliti " +
                     " AND t.tarikh_tempah = CURRENT_DATE() " +
                     " AND t.status = '" + StatusConstant.TEMPAHAN_LULUS + "' " +
                     " AND CURRENT_TIME() BETWEEN t.masa_mula AND t.masa_tamat) as occupancy_count, " +
                     "f.requires_approval " +
                     "FROM fasiliti f ORDER BY f.status DESC, f.nama_fasiliti";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Fasiliti f = new Fasiliti();
                f.setId_fasiliti(rs.getInt("id_fasiliti"));
                f.setNama_fasiliti(rs.getString("nama_fasiliti"));
                f.setLokasi(rs.getString("lokasi"));
                f.setStatus(rs.getString("status"));
                f.setDibuat_pada(rs.getTimestamp("dibuat_pada"));
                f.setDikemaskini_pada(rs.getTimestamp("dikemaskini_pada"));
                f.setDipadam_pada(rs.getTimestamp("dipadam_pada"));

                double lat_ = rs.getDouble("latitude");
                f.setLatitude(rs.wasNull() ? null : lat_);
                double lon_ = rs.getDouble("longitude");
                f.setLongitude(rs.wasNull() ? null : lon_);
                f.setOccupied(rs.getInt("occupancy_count") > 0);
                f.setRequiresApproval(rs.getBoolean("requires_approval"));
                f.setGambar_fasiliti(rs.getString("gambar_fasiliti"));
                f.setWaktu_buka(rs.getTime("waktu_buka"));
                f.setWaktu_tutup(rs.getTime("waktu_tutup"));
                f.setDurasi_slot_minit(rs.getInt("durasi_slot_minit"));
                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (semua): " + e.getMessage());
        }
        return senarai;
    }
}
