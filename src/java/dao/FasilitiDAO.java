package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Fasiliti;
import util.DBUtil;

public class FasilitiDAO {

    public List<Fasiliti> dapatkanSemuaFasiliti() {
        List<Fasiliti> senarai = new ArrayList<>();
        String sql = "SELECT id_fasiliti, nama_fasiliti, lokasi, status, dibuat_pada, dikemaskini_pada, dipadam_pada " +
                     "FROM fasiliti WHERE status = 'AKTIF'";

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
                }
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (getById): " + e.getMessage());
        }
        return f;
    }

    public boolean tambahFasiliti(Fasiliti f) {
        String sql = "INSERT INTO fasiliti (nama_fasiliti, lokasi, status) VALUES (?, ?, 'AKTIF')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (tambah): " + e.getMessage());
            return false;
        }
    }

    public boolean kemaskiniFasiliti(Fasiliti f) {
        String sql = "UPDATE fasiliti SET nama_fasiliti=?, lokasi=?, status=?, dikemaskini_pada=NOW() WHERE id_fasiliti=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNama_fasiliti());
            ps.setString(2, f.getLokasi());
            ps.setString(3, f.getStatus());
            ps.setInt(4, f.getId_fasiliti());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (kemaskini): " + e.getMessage());
            return false;
        }
    }

    public boolean padamFasiliti(int id) {
        String sql = "UPDATE fasiliti SET status='TIDAK_AKTIF', dipadam_pada=NOW() WHERE id_fasiliti=?";
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
        String sql = "SELECT * FROM fasiliti ORDER BY status DESC, nama_fasiliti";
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
                senarai.add(f);
            }
        } catch (SQLException e) {
            System.out.println("Ralat pada FasilitiDAO (semua): " + e.getMessage());
        }
        return senarai;
    }
}
