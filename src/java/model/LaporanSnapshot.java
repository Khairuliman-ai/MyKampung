package model;

import java.sql.Timestamp;

/**
 * Represents a monthly demographic and activity snapshot (LaporanSnapshot).
 * Aggregates village-wide stats (residents, welfare, complaints, facility bookings, average incomes)
 * captured at the end of each calendar month.
 */
public class LaporanSnapshot {
    private int id_snapshot;
    private int tahun;
    private int bulan;
    private int total_penduduk;
    private int total_bantuan_dipohon;
    private int total_bantuan_diluluskan;
    private int total_aduan_diterima;
    private int total_aduan_selesai;
    private int total_tempahan_fasiliti;
    private double purata_pendapatan;
    private Timestamp snapshot_pada;
    private String ai_executive_summary;

    // Getters and Setters
    public int getId_snapshot() { return id_snapshot; }
    public void setId_snapshot(int id_snapshot) { this.id_snapshot = id_snapshot; }

    public int getTahun() { return tahun; }
    public void setTahun(int tahun) { this.tahun = tahun; }

    public int getBulan() { return bulan; }
    public void setBulan(int bulan) { this.bulan = bulan; }

    public int getTotal_penduduk() { return total_penduduk; }
    public void setTotal_penduduk(int total_penduduk) { this.total_penduduk = total_penduduk; }

    public int getTotal_bantuan_dipohon() { return total_bantuan_dipohon; }
    public void setTotal_bantuan_dipohon(int total_bantuan_dipohon) { this.total_bantuan_dipohon = total_bantuan_dipohon; }

    public int getTotal_bantuan_diluluskan() { return total_bantuan_diluluskan; }
    public void setTotal_bantuan_diluluskan(int total_bantuan_diluluskan) { this.total_bantuan_diluluskan = total_bantuan_diluluskan; }

    public int getTotal_aduan_diterima() { return total_aduan_diterima; }
    public void setTotal_aduan_diterima(int total_aduan_diterima) { this.total_aduan_diterima = total_aduan_diterima; }

    public int getTotal_aduan_selesai() { return total_aduan_selesai; }
    public void setTotal_aduan_selesai(int total_aduan_selesai) { this.total_aduan_selesai = total_aduan_selesai; }

    public int getTotal_tempahan_fasiliti() { return total_tempahan_fasiliti; }
    public void setTotal_tempahan_fasiliti(int total_tempahan_fasiliti) { this.total_tempahan_fasiliti = total_tempahan_fasiliti; }

    public double getPurata_pendapatan() { return purata_pendapatan; }
    public void setPurata_pendapatan(double purata_pendapatan) { this.purata_pendapatan = purata_pendapatan; }

    public Timestamp getSnapshot_pada() { return snapshot_pada; }
    public void setSnapshot_pada(Timestamp snapshot_pada) { this.snapshot_pada = snapshot_pada; }

    public String getAi_executive_summary() { return ai_executive_summary; }
    public void setAi_executive_summary(String ai_executive_summary) { this.ai_executive_summary = ai_executive_summary; }
}
