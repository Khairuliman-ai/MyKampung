package service;

import dao.*;
import model.*;
import util.DBUtil;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;

public class AnalyticsService {

    public Map<String, Object> getAnalyticsDataForRole(String role, String biro) {
        Map<String, Object> data = new HashMap<>();
        
        try {
            PenggunaDAO penggunaDao = new PenggunaDAO();
            PermohonanBantuanDAO bantuanDao = new PermohonanBantuanDAO();
            AduanDAO aduanDao = new AduanDAO();
            TempahanFasilitiDAO fasilitiDao = new TempahanFasilitiDAO();
            LaporanSnapshotDAO snapshotDao = new LaporanSnapshotDAO();
            
            data.put("role", role);
            data.put("biro", biro);

            boolean isKetua = "Ketua Kampung".equalsIgnoreCase(role);

            // 1. Khas untuk Ketua Kampung atau AJK Setiausaha (Pendaftaran & Data)
            if (isKetua || ("AJK Kampung".equalsIgnoreCase(role) && "Setiausaha".equalsIgnoreCase(biro))) {
                data.put("totalPenduduk", penggunaDao.countAll());
                data.put("ageDistribution", penggunaDao.getAgeDistribution());
                data.put("incomeDistribution", penggunaDao.getIncomeDistribution());
                data.put("familyStatusDistribution", penggunaDao.getFamilyStatusDistribution());
                data.put("averageIncome", penggunaDao.getAverageIncome());
            }

            // 2. Khas untuk Ketua Kampung atau AJK Biro Kebajikan & Sosial (Kebajikan & Bantuan)
            if (isKetua || ("AJK Kampung".equalsIgnoreCase(role) && "Biro Kebajikan & Sosial".equalsIgnoreCase(biro))) {
                data.put("totalBantuan", bantuanDao.countAll());
                data.put("bantuanSummaryStats", bantuanDao.getBantuanSummaryStats());
                data.put("bantuanTypeRatio", bantuanDao.getBantuanTypeRatio());
                data.put("bantuanScoreDistribution", bantuanDao.getBantuanScoreDistribution());
            }

            // 3. Khas untuk Ketua Kampung atau AJK Biro Keselamatan (Aduan Komuniti)
            if (isKetua || ("AJK Kampung".equalsIgnoreCase(role) && "Biro Keselamatan".equalsIgnoreCase(biro))) {
                data.put("totalAduan", aduanDao.getAll().size()); // counting active
                data.put("aduanSummaryStats", aduanDao.getAduanSummaryStats());
                data.put("aduanCategoryStats", aduanDao.getAduanCategoryStats());
                data.put("aduanPriorityStats", aduanDao.getAduanPriorityStats());
            }

            // 4. Khas untuk Ketua Kampung atau AJK Biro Sukan & Riadah (Fasiliti)
            if (isKetua || ("AJK Kampung".equalsIgnoreCase(role) && "Biro Sukan & Riadah".equalsIgnoreCase(biro))) {
                data.put("totalTempahan", fasilitiDao.countAll());
                data.put("fasilitiUsageStats", fasilitiDao.getFasilitiUsageStats());
                data.put("fasilitiStatusStats", fasilitiDao.getFasilitiStatusStats());
            }

            // 5. Sejarah Snapshot Bulanan (Khusus Ketua Kampung sahaja untuk Line Chart Trend)
            if (isKetua) {
                data.put("monthlySnapshots", snapshotDao.getAllSnapshots());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return data;
    }

    public String buildAIPrompt(Map<String, Object> data, String reportType) {
        StringBuilder sb = new StringBuilder();
        sb.append("Anda adalah Antigravity, sistem kecerdasan buatan pembantu Ketua Kampung Danan yang sangat profesional. ");
        sb.append("Sila jana satu LAPORAN BULANAN RASMI yang tersusun, komprehensif, dan formal dalam Bahasa Melayu untuk Ketua Kampung bentangkan kepada Jawatankuasa Kemajuan dan Keselamatan Kampung (JKKK) serta Pejabat Daerah.\n\n");
        
        sb.append("Berikut adalah data statistik semasa kampung kami:\n");
        sb.append("- Jumlah Penduduk Berdaftar: ").append(data.get("totalPenduduk")).append("\n");
        Double avgIncome = (Double) data.get("averageIncome");
        if (avgIncome == null) avgIncome = 0.0;
        sb.append("- Purata Pendapatan Penduduk: RM").append(String.format("%.2f", avgIncome)).append("\n");
        
        sb.append("\nTaburan Umur Penduduk:\n");
        Map<String, Integer> age = (Map<String, Integer>) data.get("ageDistribution");
        if (age != null) {
            for (Map.Entry<String, Integer> entry : age.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" orang\n");
            }
        }
        
        sb.append("\nTaburan Status Keluarga:\n");
        Map<String, Integer> fam = (Map<String, Integer>) data.get("familyStatusDistribution");
        if (fam != null) {
            for (Map.Entry<String, Integer> entry : fam.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" orang\n");
            }
        }

        sb.append("\nTaburan Pendapatan Penduduk:\n");
        Map<String, Integer> inc = (Map<String, Integer>) data.get("incomeDistribution");
        if (inc != null) {
            for (Map.Entry<String, Integer> entry : inc.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" isi rumah\n");
            }
        }

        sb.append("\nStatistik Permohonan Bantuan Kebajikan:\n");
        Map<String, Integer> ban = (Map<String, Integer>) data.get("bantuanSummaryStats");
        if (ban != null) {
            for (Map.Entry<String, Integer> entry : ban.entrySet()) {
                sb.append("  * Status ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" permohonan\n");
            }
        }

        sb.append("\nStatistik Aduan & Isu Komuniti:\n");
        Map<String, Integer> adu = (Map<String, Integer>) data.get("aduanSummaryStats");
        if (adu != null) {
            for (Map.Entry<String, Integer> entry : adu.entrySet()) {
                sb.append("  * Status ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" kes\n");
            }
        }
        
        sb.append("\nTahap Keutamaan Kes Aduan Komuniti:\n");
        Map<String, Integer> aduP = (Map<String, Integer>) data.get("aduanPriorityStats");
        if (aduP != null) {
            for (Map.Entry<String, Integer> entry : aduP.entrySet()) {
                sb.append("  * Tahap ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" kes\n");
            }
        }

        sb.append("\nStatistik Penggunaan Fasiliti Kampung (Disahkan):\n");
        Map<String, Integer> fas = (Map<String, Integer>) data.get("fasilitiUsageStats");
        if (fas != null) {
            for (Map.Entry<String, Integer> entry : fas.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" kali tempahan diluluskan\n");
            }
        }

        sb.append("\nSila fokuskan laporan anda kepada jenis laporan berikut: ");
        if ("kebajikan".equalsIgnoreCase(reportType)) {
            sb.append("LAPORAN KEBAJIKAN & BANTUAN KAMPUNG. Berikan ulasan mendalam mengenai taburan pendapatan penduduk (kemiskinan), profil pemohon bantuan, dan analisa skor kelayakan. Berikan cadangan tindakan kebajikan.");
        } else if ("aduan".equalsIgnoreCase(reportType)) {
            sb.append("LAPORAN ADUAN & ISU KOMUNITI KAMPUNG. Berikan ulasan mendalam mengenai jenis-jenis aduan utama (terutama infrastruktur/keselamatan) dan isu kritikal yang memerlukan penyelesaian segera dari JKKK.");
        } else if ("fasiliti".equalsIgnoreCase(reportType)) {
            sb.append("LAPORAN PENGGUNAAN & TEMPAHAN FASILITI. Berikan ulasan mendalam mengenai kadar penggunaan dewan/padang, waktu puncak, serta cadangan penyelenggaraan kemudahan awam.");
        } else {
            sb.append("LAPORAN RINGKASAN EKSEKUTIF KOMPREHENSIF BULANAN. Berikan ulasan menyeluruh merangkumi status demografi, kebajikan asnaf, isu aduan komuniti, dan aktiviti fasiliti serta cadangan perancangan strategik kampung.");
        }

        sb.append("\n\nFormat Laporan:\n");
        sb.append("1. Tajuk Laporan yang kemas (Bahasa Melayu).\n");
        sb.append("2. Ringkasan Eksekutif (Ulasan ringkas berasaskan angka data).\n");
        sb.append("3. Analisis Terperinci (Menganalisis punca/trend berdasarkan statistik di atas secara mendalam).\n");
        sb.append("4. Syor & Cadangan Tindakan Susulan untuk Ketua Kampung & AJK (Berikan cadangan konkrit, pragmatik, dan berimpak tinggi).\n");
        sb.append("Sila gunakan markdown formatting (bold, senarai, dll.) supaya laporan kelihatan amat professional dan mudah dibaca.");

        return sb.toString();
    }
}
