package model;

import java.util.Date;

public class Permohonan_Bantuan {
    private int id_permohonan;
    private int id_pengguna;      // Foreign Key (Pemohon)
    private int id_bantuan;       // Foreign Key (Jenis Bantuan)
    private String status;         // Contoh: "Dihantar", "Disokong", "Berjaya", "Gagal"
    private String catatan_pemohon;
    private String catatan_pentadbir;
    private String dokumen_pemohon;    // Path ke fail (PDF/Imej) sokongan
    private String dokumen_pentadbir;  // Path ke fail pengesahan
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    // --- Helper Method ---
    public String getStatusBadge() {
        if ("Berjaya".equals(status)) return "label-success";
        if ("Gagal".equals(status)) return "label-danger";
        if ("Dihantar".equals(status)) return "label-warning";
        return "label-default";
    }

    // --- Getters and Setters ---
    public int getId_permohonan() { return id_permohonan; }
    public void setId_permohonan(int id_permohonan) { this.id_permohonan = id_permohonan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_bantuan() { return id_bantuan; }
    public void setId_bantuan(int id_bantuan) { this.id_bantuan = id_bantuan; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCatatan_pemohon() { return catatan_pemohon; }
    public void setCatatan_pemohon(String catatan_pemohon) { this.catatan_pemohon = catatan_pemohon; }

    public String getCatatan_pentadbir() { return catatan_pentadbir; }
    public void setCatatan_pentadbir(String catatan_pentadbir) { this.catatan_pentadbir = catatan_pentadbir; }

    public String getDokumen_pemohon() { return dokumen_pemohon; }
    public void setDokumen_pemohon(String dokumen_pemohon) { this.dokumen_pemohon = dokumen_pemohon; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }
}