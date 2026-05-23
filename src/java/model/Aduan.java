package model;

import java.util.Date;

public class Aduan {
    private int id_aduan;
    private int id_pengguna;
    private int id_kategori_aduan;
    private Integer id_pengendali;
    private String tajuk;
    private String keterangan;
    private String status;
    private String keutamaan;
    private String gambar_aduan;
    private String bukti_selesai;
    private String catatan_pentadbir;
    private String catatan_ajk;
    private String catatan_ketua;
    private int reopen_count;
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    // Join fields
    private String nama_penuh;      // Pengadu
    private String nama_kategori;   // Kategori aduan
    private String nama_pengendali; // AJK name

    public Aduan() {}

    // Helper for UI
    public String getStatusBadgeClass() {
        if (status == null) return "bg-gray-100 text-gray-600";
        switch (status) {
            case "SUBMITTED": return "bg-blue-100 text-blue-700 border border-blue-200";
            case "UNDER_REVIEW_AJK": return "bg-yellow-100 text-yellow-700 border border-yellow-200";
            case "IN_PROGRESS_AJK": return "bg-orange-100 text-orange-700 border border-orange-200";
            case "ESCALATED_TO_KETUA": return "bg-purple-100 text-purple-700 border border-purple-200";
            case "UNDER_REVIEW_KETUA": return "bg-indigo-100 text-indigo-700 border border-indigo-200";
            case "IN_PROGRESS_HIGH_LEVEL": return "bg-cyan-100 text-cyan-700 border border-cyan-200";
            case "RESOLVED": return "bg-green-100 text-green-700 border border-green-200";
            case "REJECTED": return "bg-red-100 text-red-700 border border-red-200";
            case "CLOSED": return "bg-gray-100 text-gray-500 border border-gray-200";
            case "REOPENED": return "bg-amber-100 text-amber-800 border border-amber-200 animate-pulse";
            default: return "bg-gray-100 text-gray-600";
        }
    }

    public String getStatusLabel() {
        if (status == null) return "N/A";
        switch (status) {
            case "SUBMITTED": return "Dihantar";
            case "UNDER_REVIEW_AJK": return "Dalam Semakan Biro";
            case "IN_PROGRESS_AJK": return "Tindakan Biro";
            case "ESCALATED_TO_KETUA": return "Diserah ke Ketua";
            case "UNDER_REVIEW_KETUA": return "Dalam Semakan Ketua";
            case "IN_PROGRESS_HIGH_LEVEL": return "Tindakan Khas Ketua";
            case "RESOLVED": return "Selesai";
            case "REJECTED": return "Ditolak";
            case "CLOSED": return "Ditutup";
            case "REOPENED": return "Dibuka Semula";
            default: return status;
        }
    }

    public String getKeutamaanBadge() {
        if (keutamaan == null) return "bg-gray-100 text-gray-600";
        switch (keutamaan) {
            case "TINGGI":
            case "KRITIKAL": return "bg-red-100 text-red-700 border border-red-200";
            case "SEDERHANA": return "bg-blue-100 text-blue-700 border border-blue-200";
            case "RENDAH": return "bg-green-100 text-green-700 border border-green-200";
            default: return "bg-gray-100 text-gray-600";
        }
    }

    // Getters and Setters
    public int getId_aduan() { return id_aduan; }
    public void setId_aduan(int id_aduan) { this.id_aduan = id_aduan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_kategori_aduan() { return id_kategori_aduan; }
    public void setId_kategori_aduan(int id_kategori_aduan) { this.id_kategori_aduan = id_kategori_aduan; }

    public Integer getId_pengendali() { return id_pengendali; }
    public void setId_pengendali(Integer id_pengendali) { this.id_pengendali = id_pengendali; }

    public String getTajuk() { return tajuk; }
    public void setTajuk(String tajuk) { this.tajuk = tajuk; }

    public String getKeterangan() { return keterangan; }
    public void setKeterangan(String keterangan) { this.keterangan = keterangan; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getKeutamaan() { return keutamaan; }
    public void setKeutamaan(String keutamaan) { this.keutamaan = keutamaan; }

    public String getGambar_aduan() { return gambar_aduan; }
    public void setGambar_aduan(String gambar_aduan) { this.gambar_aduan = gambar_aduan; }

    public String getBukti_selesai() { return bukti_selesai; }
    public void setBukti_selesai(String bukti_selesai) { this.bukti_selesai = bukti_selesai; }

    public String getCatatan_pentadbir() { return catatan_pentadbir; }
    public void setCatatan_pentadbir(String catatan_pentadbir) { this.catatan_pentadbir = catatan_pentadbir; }

    public String getCatatan_ajk() { return catatan_ajk; }
    public void setCatatan_ajk(String catatan_ajk) { this.catatan_ajk = catatan_ajk; }

    public String getCatatan_ketua() { return catatan_ketua; }
    public void setCatatan_ketua(String catatan_ketua) { this.catatan_ketua = catatan_ketua; }

    public int getReopen_count() { return reopen_count; }
    public void setReopen_count(int reopen_count) { this.reopen_count = reopen_count; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public Date getDikemaskini_pada() { return dikemaskini_pada; }
    public void setDikemaskini_pada(Date dikemaskini_pada) { this.dikemaskini_pada = dikemaskini_pada; }

    public Date getDipadam_pada() { return dipadam_pada; }
    public void setDipadam_pada(Date dipadam_pada) { this.dipadam_pada = dipadam_pada; }

    public String getNama_penuh() { return nama_penuh; }
    public void setNama_penuh(String nama_penuh) { this.nama_penuh = nama_penuh; }

    public String getNama_kategori() { return nama_kategori; }
    public void setNama_kategori(String nama_kategori) { this.nama_kategori = nama_kategori; }

    public String getNama_pengendali() { return nama_pengendali; }
    public void setNama_pengendali(String nama_pengendali) { this.nama_pengendali = nama_pengendali; }
}

