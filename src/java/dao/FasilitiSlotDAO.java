package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.FasilitiSlot;
import util.DBUtil;

/**
 * FasilitiSlotDAO handles database operations for pre-defined booking slots (fasiliti_slot).
 * Used to fetch standardized timing slot options for different booking durations (e.g. hourly, half-day).
 */
public class FasilitiSlotDAO {
    
    /**
     * Retrieves pre-defined timing slots for a facility filtered by the booking duration class.
     * 
     * @param idFasiliti the unique facility ID
     * @param durasi the duration classification string (e.g., '1_JAM', 'SEPARUH_HARI')
     * @return a list of pre-defined FasilitiSlot timings
     */
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
