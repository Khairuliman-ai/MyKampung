package service;

import util.DBUtil;
import model.PermohonanBantuan;
import model.BantuanRule;
import model.AhliKeluarga;
import dao.AhliKeluargaDAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * EligibilityService evaluates welfare assistance applications.
 * Calculates eligibility scores using a configurable, weighted scoring model
 * that rates household income, dependent counts, family status (e.g. single parents/disabled),
 * and employment type. Categorizes applications into high, medium, or low priority tiers.
 */
public class EligibilityService {

    /**
     * Default poverty line income threshold (MYR) if none is configured in the database.
     */
    private static final double DEFAULT_POVERTY_LINE = 2500.00;

    /**
     * Retrieves the poverty line threshold from dynamic system settings (bantuan_rule table).
     * Falls back to a default value if not configured.
     * 
     * @return the poverty line threshold
     */
    public double getPovertyLine() {
        String sql = "SELECT weight FROM bantuan_rule WHERE rule_key = 'POVERTY_LINE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("weight");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return DEFAULT_POVERTY_LINE;
    }

    /**
     * Updates the poverty line threshold in the database.
     * Uses ON DUPLICATE KEY UPDATE to overwrite the configuration rule.
     * 
     * @param newPovertyLine the new poverty line threshold
     * @return true if updated successfully, false otherwise
     */
    public boolean updatePovertyLine(double newPovertyLine) {
        String sql = "INSERT INTO bantuan_rule (rule_key, rule_name, weight) VALUES ('POVERTY_LINE', 'Had Pendapatan Paras Kemiskinan', ?) " +
                     "ON DUPLICATE KEY UPDATE weight = VALUES(weight)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, newPovertyLine);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves all scoring factor weights and config rules from the database.
     * Initialized with hardcoded defaults in case database retrieval fails.
     * 
     * @return a map linking rule keys to their respective weights
     */
    public Map<String, Double> getRuleWeights() {
        Map<String, Double> weights = new HashMap<>();
        // Set default values in case DB query fails or has no entries
        weights.put("INCOME_FACTOR", 40.0);
        weights.put("DEPENDENT_FACTOR", 25.0);
        weights.put("FAMILY_STATUS_FACTOR", 20.0);
        weights.put("EMPLOYMENT_STATUS_FACTOR", 15.0);

        String sql = "SELECT rule_key, weight FROM bantuan_rule WHERE rule_key != 'POVERTY_LINE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                weights.put(rs.getString("rule_key"), rs.getDouble("weight"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return weights;
    }

    /**
     * Updates all rule weights in the database in a batch.
     * Enforces database transaction safety by using batch updates and manual commit/rollback control.
     * 
     * @param newWeights a map linking rule keys to new weights
     * @return true if all updates committed successfully, false otherwise
     */
    public boolean updateRuleWeights(Map<String, Double> newWeights) {
        String sql = "INSERT INTO bantuan_rule (rule_key, rule_name, weight) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE weight = VALUES(weight)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            try {
                for (Map.Entry<String, Double> entry : newWeights.entrySet()) {
                    String name = "Faktor Kelayakan";
                    if ("INCOME_FACTOR".equals(entry.getKey())) name = "Faktor Pendapatan Rendah";
                    else if ("DEPENDENT_FACTOR".equals(entry.getKey())) name = "Faktor Bilangan Tanggungan";
                    else if ("FAMILY_STATUS_FACTOR".equals(entry.getKey())) name = "Faktor Status Ibu Tunggal/OKU";
                    else if ("EMPLOYMENT_STATUS_FACTOR".equals(entry.getKey())) name = "Faktor Pengangguran";

                    ps.setString(1, entry.getKey());
                    ps.setString(2, name);
                    ps.setDouble(3, entry.getValue());
                    ps.addBatch();
                }
                ps.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Evaluates a welfare application and updates its eligibility score, tier, and warning flags.
     * Scoring weights are retrieved dynamically from getRuleWeights().
     * Points are allocated across 4 dimensions:
     * 1. Income Factor (40% weight): Scored relative to poverty line multipliers (B40 thresholds).
     * 2. Dependent Factor (25% weight): Scored by family size (from AhliKeluarga database census).
     * 3. Family Status (20% weight): Single parents/OKU receive maximum points.
     * 4. Employment (15% weight): Informal sectors or unemployed receive higher scores.
     * 
     * @param pb the assistance application model to evaluate
     * @return the updated assistance application model with calculated score, tier, and flags
     */
    public PermohonanBantuan calculateEligibilityScore(PermohonanBantuan pb) {
        if (pb == null) return null;

        Map<String, Double> weights = getRuleWeights();
        double wIncome = weights.getOrDefault("INCOME_FACTOR", 40.0);
        double wDependent = weights.getOrDefault("DEPENDENT_FACTOR", 25.0);
        double wFamily = weights.getOrDefault("FAMILY_STATUS_FACTOR", 20.0);
        double wEmployment = weights.getOrDefault("EMPLOYMENT_STATUS_FACTOR", 15.0);

        List<String> flags = new ArrayList<>();

        // 1. Income Factor Scoring
        double incomeScore = 0.0;
        Double pendapatan = pb.getPendapatan();
        double povertyLine = getPovertyLine();

        if (pendapatan == null || pendapatan <= 0) {
            incomeScore = 100.0;
            flags.add("TIADA_PENDAPATAN");
        } else if (pendapatan <= povertyLine * 0.6) { // Extreme Poverty (e.g. <= 1500)
            incomeScore = 100.0;
            flags.add("PENDAPATAN_SANGAT_RENDAH");
        } else if (pendapatan <= povertyLine) { // Under poverty threshold (e.g. <= 2500)
            incomeScore = 80.0;
            flags.add("PENDAPATAN_RENDAH");
        } else if (pendapatan <= povertyLine * 1.6) { // Low-middle income (e.g. <= 4000)
            incomeScore = 40.0;
        } else {
            incomeScore = 10.0;
        }

        // 2. Dependent Factor Scoring
        double dependentScore = 0.0;
        int dependentCount = 0;
        try (Connection conn = DBUtil.getConnection()) {
            AhliKeluargaDAO familyDao = new AhliKeluargaDAO(conn);
            List<AhliKeluarga> family = familyDao.getByPenggunaId(pb.getId_pengguna());
            if (family != null) {
                dependentCount = family.size();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (dependentCount >= 5) {
            dependentScore = 100.0;
            flags.add("TANGGUNGAN_SANGAT_RAMAI");
        } else if (dependentCount >= 3) {
            dependentScore = 80.0;
            flags.add("TANGGUNGAN_RAMAI");
        } else if (dependentCount >= 1) {
            dependentScore = 50.0;
        } else {
            dependentScore = 0.0;
        }

        // 3. Family Status Factor Scoring
        double familyScore = 0.0;
        String statusKeluarga = pb.getStatus_keluarga();
        if (statusKeluarga == null) {
            statusKeluarga = "Bujang";
        }
        statusKeluarga = statusKeluarga.trim().toUpperCase();

        if (statusKeluarga.contains("IBU TUNGGAL") || statusKeluarga.contains("BAPA TUNGGAL")) {
            familyScore = 100.0;
            flags.add("IBU_BAPA_TUNGGAL");
        } else if (statusKeluarga.contains("OKU")) {
            familyScore = 100.0;
            flags.add("OKU");
        } else if (statusKeluarga.contains("BERKAHWIN")) {
            familyScore = 60.0;
        } else if (statusKeluarga.contains("BUJANG")) {
            familyScore = 20.0;
        } else {
            familyScore = 30.0;
        }

        // 4. Employment Status Factor Scoring
        double employmentScore = 0.0;
        String pekerjaan = pb.getPekerjaan();
        if (pekerjaan == null) {
            pekerjaan = "";
        }
        pekerjaan = pekerjaan.trim().toUpperCase();

        if (pekerjaan.isEmpty() || pekerjaan.contains("TIDAK BEKERJA") || pekerjaan.contains("PENGANGGUR") || pekerjaan.contains("TIADA")) {
            employmentScore = 100.0;
            flags.add("TIADA_KERJA");
        } else if (pekerjaan.contains("PETANI") || pekerjaan.contains("NELAYAN") || pekerjaan.contains("BURUH") || pekerjaan.contains("SURI RUMAH") || pekerjaan.contains("PESARA")) {
            employmentScore = 70.0;
            flags.add("KERJA_SEKTOR_TIDAK_FORMAL");
        } else {
            employmentScore = 20.0;
        }

        // Calculate weighted score
        double finalScore = (incomeScore * wIncome + dependentScore * wDependent + familyScore * wFamily + employmentScore * wEmployment) / 100.0;
        
        // Safety bound
        if (finalScore > 100.0) finalScore = 100.0;
        if (finalScore < 0.0) finalScore = 0.0;

        // Assign tier
        String tier = "RENDAH";
        if (finalScore >= 80.0) {
            tier = "TINGGI";
        } else if (finalScore >= 40.0) {
            tier = "SEDERHANA";
        }

        pb.setEligibilityScore(finalScore);
        pb.setEligibilityTier(tier);
        pb.setEligibilityFlags(flags);

        return pb;
    }

    /**
     * Retrieves a list of all active welfare eligibility rules and weights from the database.
     * 
     * @return list of BantuanRule objects sorted by key
     */
    public List<BantuanRule> getRulesList() {
        List<BantuanRule> rules = new ArrayList<>();
        String sql = "SELECT * FROM bantuan_rule ORDER BY rule_key ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rules.add(new BantuanRule(
                    rs.getString("rule_key"),
                    rs.getString("rule_name"),
                    rs.getDouble("weight")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rules;
    }
}
