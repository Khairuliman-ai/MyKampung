package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.FasilitiSlot;
import util.DBUtil;

public class FasilitiSlotDAO {

    public List<FasilitiSlot> getSlotsByFasiliti(int idFasiliti, int durasi) {
        List<FasilitiSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM fasiliti_slot WHERE id_fasiliti = ? AND durasi = ? ORDER BY masa_mula";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setInt(2, durasi);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setId_slot(rs.getInt("id_slot"));
                    s.setId_fasiliti(rs.getInt("id_fasiliti"));
                    s.setMasa_mula(rs.getTime("masa_mula"));
                    s.setMasa_tamat(rs.getTime("masa_tamat"));
                    s.setDurasi(rs.getInt("durasi"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addSlot(FasilitiSlot s) {
        String sql = "INSERT INTO fasiliti_slot (id_fasiliti, masa_mula, masa_tamat, durasi) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getId_fasiliti());
            ps.setTime(2, s.getMasa_mula());
            ps.setTime(3, s.getMasa_tamat());
            ps.setInt(4, s.getDurasi());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSlot(int idSlot) {
        String sql = "DELETE FROM fasiliti_slot WHERE id_slot = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSlot);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
