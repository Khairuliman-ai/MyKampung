package model;

import java.math.BigDecimal;

/**
 * Represents a welfare aid program (Bantuan) setup by the village committee.
 * Captures allocations, descriptions, classifications, and documentation requirements.
 */
public class Bantuan {
    private int id_bantuan;
    private String nama_bantuan;
    private String keterangan;
    private BigDecimal jumlah_bantuan;
    private String jenis_bantuan;
    private String syarat_dokumen;

    // --- Helper Method ---
    public String getJumlahBantuanFormatted() {
        return (jumlah_bantuan != null) ? "RM " + jumlah_bantuan.setScale(2).toString() : "RM 0.00";
    }

    // For compatibility with old code
    public BigDecimal getPeruntukan() { return jumlah_bantuan; }
    public void setPeruntukan(BigDecimal peruntukan) { this.jumlah_bantuan = peruntukan; }
    public String getStatus() { return "Aktif"; }

    // --- Getters and Setters ---
    public int getId_bantuan() { return id_bantuan; }
    public void setId_bantuan(int id_bantuan) { this.id_bantuan = id_bantuan; }

    public String getNama_bantuan() { return nama_bantuan; }
    public void setNama_bantuan(String nama_bantuan) { this.nama_bantuan = nama_bantuan; }
    
    public String getKeterangan() { return keterangan; }
    public void setKeterangan(String keterangan) { this.keterangan = keterangan; }

    public BigDecimal getJumlah_bantuan() { return jumlah_bantuan; }
    public void setJumlah_bantuan(BigDecimal jumlah_bantuan) { this.jumlah_bantuan = jumlah_bantuan; }

    public String getJenis_bantuan() { return jenis_bantuan; }
    public void setJenis_bantuan(String jenis_bantuan) { this.jenis_bantuan = jenis_bantuan; }

    public String getSyarat_dokumen() { return syarat_dokumen; }
    public void setSyarat_dokumen(String syarat_dokumen) { this.syarat_dokumen = syarat_dokumen; }
}