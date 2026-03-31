package model;

import java.util.Date;
import java.math.BigDecimal;

public class Bantuan {
    private int id_bantuan;
    private String nama_bantuan;
    private BigDecimal peruntukan; // Nilai bajet untuk bantuan ini
    private String status;         // Contoh: "Aktif", "Tamat", "Penuh"
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    // --- Helper Method ---
    public String getPeruntukanFormatted() {
        return (peruntukan != null) ? "RM " + peruntukan.setScale(2).toString() : "RM 0.00";
    }

    // --- Getters and Setters ---
    public int getId_bantuan() { return id_bantuan; }
    public void setId_bantuan(int id_bantuan) { this.id_bantuan = id_bantuan; }

    public String getNama_bantuan() { return nama_bantuan; }
    public void setNama_bantuan(String nama_bantuan) { this.nama_bantuan = nama_bantuan; }

    public BigDecimal getPeruntukan() { return peruntukan; }
    public void setPeruntukan(BigDecimal peruntukan) { this.peruntukan = peruntukan; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }
}