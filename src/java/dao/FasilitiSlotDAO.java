package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.FasilitiSlot;
import util.DBUtil;

public class FasilitiSlotDAO {
    
    public List<FasilitiSlot> getSlotsByFasilitiAndDurasi(int idFasiliti, String durasi) {
        List<FasilitiSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM fasiliti_slot WHERE id_fasiliti = ? AND durasi = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFasiliti);
            ps.setString(2, durasi);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setId_slot(rs.getInt("id_slot"));
                    s.setId_fasiliti(rs.getInt("id_fasiliti"));
                    s.setMasa_mula(rs.getTime("masa_mula"));
                    s.setMasa_tamat(rs.getTime("masa_tamat"));
                    // Note: We'll update the model if needed, but for now we just need start/end
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in FasilitiSlotDAO (getSlots): " + e.getMessage());
        }
        return list;
    }
}
