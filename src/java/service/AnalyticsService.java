package service;

import dao.*;
import java.util.*;

/**
 * AnalyticsService aggregates census, complaint, welfare, and facility booking data
 * for role-based analytics dashboards. Construct prompts for monthly AI report generation.
 */
public class AnalyticsService {

    /**
     * Aggregates stats and distribution metrics from various DAOs based on the user's role and assigned biro.
     * Enforces strict data separation so AJK members only see metrics relevant to their biro,
     * while the Ketua Kampung has access to all statistics and historical monthly snapshots.
     * 
     * @param role the user's role name (e.g. Ketua Kampung, AJK Kampung)
     * @param biro the user's assigned biro name (e.g. Setiausaha, Biro Kebajikan & Sosial)
     * @return a map of aggregated statistical data objects
     */
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

    /**
     * Constructs a structured text prompt for the Gemini AI containing aggregated village metrics.
     * Instructs the AI model to generate a formal monthly report in Malay targeted to JKKK committees
     * and district offices. Focuses on the selected report type category (welfare, complaints, facilities, or general summary).
     * 
     * @param data the aggregated village metrics map
     * @param reportType the focus type of the report (e.g., 'kebajikan', 'aduan', 'fasiliti', or general 'ringkasan')
     * @return the constructed AI system prompt string
     */
    @SuppressWarnings("unchecked")
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
        if ("eksekutif_json".equalsIgnoreCase(reportType)) {
            return buildStructuredAIPrompt(data);
        } else if ("kebajikan".equalsIgnoreCase(reportType)) {
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

    /**
     * Constructs a structured text prompt for the Gemini AI containing aggregated village metrics to produce JSON.
     */
    @SuppressWarnings("unchecked")
    public String buildStructuredAIPrompt(Map<String, Object> data) {
        StringBuilder sb = new StringBuilder();
        sb.append("Anda adalah pakar penasihat pentadbiran awam dan penganalisis data rasmi JKKK Kampung Danan.\n");
        sb.append("Tugas anda adalah untuk menganalisis metrik kampung sebenar berikut dan menjana laporan eksekutif berstruktur dalam format JSON.\n\n");
        
        sb.append("### DATA SEBENAR KAMPUNG DANAN:\n");
        sb.append("- Jumlah Penduduk Berdaftar: ").append(data.get("totalPenduduk")).append(" orang\n");
        
        Double avgIncome = (Double) data.get("averageIncome");
        if (avgIncome == null) avgIncome = 0.0;
        sb.append("- Purata Pendapatan Penduduk: RM").append(String.format("%.2f", avgIncome)).append("\n");

        sb.append("- Taburan Pendapatan Penduduk:\n");
        Map<String, Integer> inc = (Map<String, Integer>) data.get("incomeDistribution");
        if (inc != null) {
            for (Map.Entry<String, Integer> entry : inc.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" isi rumah\n");
            }
        }

        sb.append("- Statistik Permohonan Bantuan Kebajikan (Status Permohonan):\n");
        Map<String, Integer> ban = (Map<String, Integer>) data.get("bantuanSummaryStats");
        if (ban != null) {
            for (Map.Entry<String, Integer> entry : ban.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" permohonan\n");
            }
        }

        sb.append("- Statistik Tempahan Fasiliti (Bulan Ini):\n");
        sb.append("  * Jumlah Tempahan Keseluruhan: ").append(data.get("totalTempahan")).append(" tempahan\n");
        Map<String, Integer> fas = (Map<String, Integer>) data.get("fasilitiUsageStats");
        if (fas != null) {
            for (Map.Entry<String, Integer> entry : fas.entrySet()) {
                sb.append("  * ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" tempahan diluluskan\n");
            }
        }

        sb.append("- Statistik Aduan & Isu Komuniti (Aduan Belum Selesai & Ditugaskan):\n");
        Map<String, Integer> adu = (Map<String, Integer>) data.get("aduanSummaryStats");
        if (adu != null) {
            for (Map.Entry<String, Integer> entry : adu.entrySet()) {
                sb.append("  * Status ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" kes aduan\n");
            }
        }
        Map<String, Integer> aduP = (Map<String, Integer>) data.get("aduanPriorityStats");
        if (aduP != null) {
            sb.append("  * Tahap Keutamaan Kes:\n");
            for (Map.Entry<String, Integer> entry : aduP.entrySet()) {
                sb.append("    - Tahap ").append(entry.getKey()).append(": ").append(entry.getValue()).append(" kes\n");
            }
        }

        sb.append("\n### ARAHAN PENJANAAN:\n");
        sb.append("1. Nilai kesihatan ekonomi, kekangan infrastruktur (aduan), dan pengagihan bantuan kebajikan berdasarkan data di atas SAHAJA.\n");
        sb.append("2. Kekalkan nada yang sangat profesional, objektif, dan menyokong pentadbiran kampung (JKKK).\n");
        sb.append("3. Kenal pasti masalah paling kritikal (bottlenecks) (contohnya aduan keutamaan tinggi yang tidak diselesaikan atau lonjakan permohonan bantuan).\n");
        sb.append("4. Berikan syor/tindakan konkrit yang boleh diambil oleh Ketua Kampung secara langkah-demi-langkah (actionable actions).\n");
        sb.append("5. Tindakan dan penerangan mestilah ditulis dalam Bahasa Melayu, tetapi kunci (keys) JSON mestilah menggunakan nama yang ditetapkan di bawah.\n\n");

        sb.append("### FORMAT OUTPUT:\n");
        sb.append("Anda mesti membalas dengan HANYA satu objek JSON yang sah dan mentah. Jangan sertakan tag markdown seperti ```json atau sebarang teks pengenalan/filler perbualan. Gunakan kunci (keys) yang tepat di bawah:\n\n");
        sb.append("{\n");
        sb.append("  \"executive_summary\": \"Satu ringkasan eksekutif profesional sebanyak 3-4 ayat mengenai keadaan semasa Kampung Danan.\",\n");
        sb.append("  \"economic_and_welfare_status\": \"Analisis ringkas mengenai taburan pendapatan berbanding kebergantungan bantuan kebajikan.\",\n");
        sb.append("  \"critical_alerts\": [\n");
        sb.append("    \"Rentetan teks yang memperincikan isu keutamaan 1\",\n");
        sb.append("    \"Rentetan teks yang memperincikan isu keutamaan 2 (jika ada)\"\n");
        sb.append("  ],\n");
        sb.append("  \"recommended_actions\": [\n");
        sb.append("    \"Tindakan konkrit 1 untuk Ketua Kampung\",\n");
        sb.append("    \"Tindakan konkrit 2 untuk Ketua Kampung\",\n");
        sb.append("    \"Tindakan konkrit 3 untuk Ketua Kampung\"\n");
        sb.append("  ]\n");
        sb.append("}\n");

        return sb.toString();
    }
}
