package model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class PermohonanBantuan {
    private int id_permohonan;
    private int id_pengguna;
    private int id_bantuan;
    private String status; // 'BARU', 'MENUNGGU', 'LULUS', 'TOLAK'
    private String catatan_pemohon;
    private String catatan_pentadbir;
    private String dokumen_pentadbir;
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    // Bank Information
    private String nama_bank;
    private String nombor_akaun;
    private String penyata_bank;
    
    // Custom properties for UI and joins
    private String nama_bantuan;
    private String jenis_bantuan; // 'RASMI' or 'KOMUNITI'
    private String nama_penuh;

    // Multiple Lampiran Support
    private List<BantuanLampiran> senaraiLampiran = new ArrayList<>();

    public List<BantuanLampiran> getSenaraiLampiran() { return senaraiLampiran; }
    public void setSenaraiLampiran(List<BantuanLampiran> senaraiLampiran) { this.senaraiLampiran = senaraiLampiran; }

    // --- Helper Method ---
    public String getStatusBadge() {
        if ("LULUS".equals(status)) return "label-success";
        if ("TOLAK".equals(status)) return "label-danger";
        if ("BARU".equals(status)) return "label-warning";
        return "label-default"; // MENUNGGU
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
    
    public String getDokumen_pentadbir() { return dokumen_pentadbir; }
    public void setDokumen_pentadbir(String dokumen_pentadbir) { this.dokumen_pentadbir = dokumen_pentadbir; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public Date getDikemaskini_pada() { return dikemaskini_pada; }
    public void setDikemaskini_pada(Date dikemaskini_pada) { this.dikemaskini_pada = dikemaskini_pada; }

    public Date getDipadam_pada() { return dipadam_pada; }
    public void setDipadam_pada(Date dipadam_pada) { this.dipadam_pada = dipadam_pada; }

    public String getNama_bank() { return nama_bank; }
    public void setNama_bank(String nama_bank) { this.nama_bank = nama_bank; }

    public String getNombor_akaun() { return nombor_akaun; }
    public void setNombor_akaun(String nombor_akaun) { this.nombor_akaun = nombor_akaun; }

    public String getPenyata_bank() { return penyata_bank; }
    public void setPenyata_bank(String penyata_bank) { this.penyata_bank = penyata_bank; }

    public String getNama_bantuan() { return nama_bantuan; }
    public void setNama_bantuan(String nama_bantuan) { this.nama_bantuan = nama_bantuan; }
    
    public String getJenis_bantuan() { return jenis_bantuan; }
    public void setJenis_bantuan(String jenis_bantuan) { this.jenis_bantuan = jenis_bantuan; }
    
    public String getNama_penuh() { return nama_penuh; }
    public void setNama_penuh(String nama) { this.nama_penuh = nama; }
    
    // For backwards compatibility mapping
    public int getId_permohonan_bantuan() { return id_permohonan; }
    public void setId_permohonan_bantuan(int id_permohonan_bantuan) { this.id_permohonan = id_permohonan_bantuan; }
    public Date getTarikh_permohonan() { return dibuat_pada; }
    public void setTarikh_permohonan(Date tarikh_permohonan) { this.dibuat_pada = tarikh_permohonan; }
    public String getCatatan() { return catatan_pemohon; }
}