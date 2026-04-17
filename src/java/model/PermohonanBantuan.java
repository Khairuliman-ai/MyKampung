package model;

import java.util.Date;

public class PermohonanBantuan {
    private int id_permohonan_bantuan;
    private int id_pengguna;
    private int id_bantuan;
    private Date tarikh_permohonan;
    private String status; // 'BARU', 'MENUNGGU', 'LULUS', 'TOLAK'
    private String catatan_pentadbir;
    
    // Custom properties for UI and joins
    private String nama_bantuan;
    private String nama_penuh;

    // --- Helper Method ---
    public String getStatusBadge() {
        if ("LULUS".equals(status)) return "label-success";
        if ("TOLAK".equals(status)) return "label-danger";
        if ("BARU".equals(status)) return "label-warning";
        return "label-default"; // MENUNGGU
    }

    // --- Getters and Setters ---
    public int getId_permohonan_bantuan() { return id_permohonan_bantuan; }
    public void setId_permohonan_bantuan(int id_permohonan_bantuan) { this.id_permohonan_bantuan = id_permohonan_bantuan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_bantuan() { return id_bantuan; }
    public void setId_bantuan(int id_bantuan) { this.id_bantuan = id_bantuan; }
    
    public Date getTarikh_permohonan() { return tarikh_permohonan; }
    public void setTarikh_permohonan(Date tarikh_permohonan) { this.tarikh_permohonan = tarikh_permohonan; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCatatan_pentadbir() { return catatan_pentadbir; }
    public void setCatatan_pentadbir(String catatan_pentadbir) { this.catatan_pentadbir = catatan_pentadbir; }
    
    public String getNama_bantuan() { return nama_bantuan; }
    public void setNama_bantuan(String nama_bantuan) { this.nama_bantuan = nama_bantuan; }
    
    public String getNama_penuh() { return nama_penuh; }
    public void setNama_penuh(String nama) { this.nama_penuh = nama; }
    
    // Fallback for compiler compatibility with BantuanServlet.java
    public void setDokumen_pemohon(String s) { }
    public void setCatatan_pemohon(String s) { }
}