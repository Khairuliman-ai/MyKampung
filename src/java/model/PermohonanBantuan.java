package model;

import java.util.Date;

public class PermohonanBantuan {

    private int idPermohonan;
    private int idPenduduk;
    private int idBantuan;
    private Date tarikhMohon;
    private int status;  // 0: Baru, 1: Lulus, 2: Tolak
    private String catatan;
    private String ulasanAdmin;
    private String dokumen;      // PDF dari penduduk
    private String dokumenBalik; // PDF dari ketua kampung
    private String namaPemohon;
    private String namaBantuan;

    // Getters & Setters
    public int getIdPermohonan() {
        return idPermohonan;
    }

    public void setIdPermohonan(int idPermohonan) {
        this.idPermohonan = idPermohonan;
    }

    public int getIdPenduduk() {
        return idPenduduk;
    }

    public void setIdPenduduk(int idPenduduk) {
        this.idPenduduk = idPenduduk;
    }

    public int getIdBantuan() {
        return idBantuan;
    }

    public void setIdBantuan(int idBantuan) {
        this.idBantuan = idBantuan;
    }

    public Date getTarikhMohon() {
        return tarikhMohon;
    }

    public void setTarikhMohon(Date tarikhMohon) {
        this.tarikhMohon = tarikhMohon;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCatatan() {
        return catatan;
    }

    public void setCatatan(String catatan) {
        this.catatan = catatan;
    }

    public String getDokumen() {
        return dokumen;
    }

    public void setDokumen(String dokumen) {
        this.dokumen = dokumen;
    }

    public String getDokumenBalik() {
        return dokumenBalik;
    }

    public void setDokumenBalik(String dokumenBalik) {
        this.dokumenBalik = dokumenBalik;
    }
    
    public String getNamaPemohon() {
        return namaPemohon;
    }

    public void setNamaPemohon(String namaPemohon) {
        this.namaPemohon = namaPemohon;
    }
    
    public String getUlasanAdmin() {
        return ulasanAdmin;
    }

    public void setUlasanAdmin(String ulasanAdmin) {
        this.ulasanAdmin = ulasanAdmin;
    }
    
    public String getNamaBantuan() {
        return namaBantuan;
    }

    public void setNamaBantuan(String namaBantuan) {
        this.namaBantuan = namaBantuan;
    }
    
}
