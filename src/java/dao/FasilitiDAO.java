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

public class FasilitiDAO {

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
                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return senarai;
    }

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
                }
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (getById): " + e.getMessage());
        }
        return f;
    }

    public boolean tambahFasiliti(Fasiliti f) {
        String sql = "INSERT INTO fasiliti (nama_fasiliti, lokasi, status, latitude, longitude, requires_approval, gambar_fasiliti) VALUES (?, ?, '" + StatusConstant.FASILITI_AKTIF + "', ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            if (f.getLatitude() != null) ps.setDouble(3, f.getLatitude()); else ps.setNull(3, java.sql.Types.DECIMAL);
            if (f.getLongitude() != null) ps.setDouble(4, f.getLongitude()); else ps.setNull(4, java.sql.Types.DECIMAL);
            ps.setBoolean(5, f.isRequiresApproval());
            ps.setString(6, f.getGambar_fasiliti());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (tambah): " + e.getMessage());
            return false;
        }
    }

    public boolean kemaskiniFasiliti(Fasiliti f) {
        String sql = "UPDATE fasiliti SET nama_fasiliti=?, lokasi=?, status=?, latitude=?, longitude=?, requires_approval=?, gambar_fasiliti=?, dikemaskini_pada=NOW() WHERE id_fasiliti=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            ps.setString(3, f.getStatus());
            if (f.getLatitude() != null) ps.setDouble(4, f.getLatitude()); else ps.setNull(4, java.sql.Types.DECIMAL);
            if (f.getLongitude() != null) ps.setDouble(5, f.getLongitude()); else ps.setNull(5, java.sql.Types.DECIMAL);
            ps.setBoolean(6, f.isRequiresApproval());
            ps.setString(7, f.getGambar_fasiliti());
            ps.setInt(8, f.getId_fasiliti());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (kemaskini): " + e.getMessage());
            return false;
        }
    }

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
                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (semua): " + e.getMessage());
        }
        return senarai;
    }
}
