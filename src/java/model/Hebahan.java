package model;

import java.util.Date;

public class Hebahan {
    private int id_hebahan;
    private int id_pengguna;
    private String tajuk;
    private String kandungan;
    private String kategori;        // Kecemasan, Aktiviti, Umum
    private String gambar_poster;
    private String status_hebahan;   // Draft, Published, Archived
    private Date tarikh_mula_acara;
    private Date tarikh_tamat_acara;
    private String lokasi_acara;
    private Date tarikh_tamat;       // Auto-archive
    private Date tarikh_hebahan;
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    // JOIN fields
    private String nama_penuh;       // Nama pencipta dari table pengguna

    public Hebahan() {}

    // === HELPER METHODS ===
    public String getStatusBadgeClass() {
        if (status_hebahan == null) return "bg-gray-100 text-gray-600";
        switch (status_hebahan) {
            case "Draft":     return "bg-yellow-100 text-yellow-700";
            case "Published": return "bg-green-100 text-green-700";
            case "Archived":  return "bg-gray-100 text-gray-600";
            default:          return "bg-gray-100 text-gray-600";
        }
    }

    public String getKategoriBadgeClass() {
        if (kategori == null) return "bg-gray-100 text-gray-600";
        switch (kategori) {
            case "Kecemasan": return "bg-red-100 text-red-700";
            case "Aktiviti":  return "bg-blue-100 text-blue-700";
            case "Umum":      return "bg-green-100 text-green-700";
            default:          return "bg-gray-100 text-gray-600";
        }
    }

    public String getKategoriIcon() {
        if (kategori == null) return "fas fa-info-circle";
        switch (kategori) {
            case "Kecemasan": return "fas fa-exclamation-triangle";
            case "Aktiviti":  return "fas fa-calendar-alt";
            case "Umum":      return "fas fa-bullhorn";
            default:          return "fas fa-info-circle";
        }
    }

    // === ALL GETTERS & SETTERS ===
    public int getId_hebahan() { return id_hebahan; }
    public void setId_hebahan(int id_hebahan) { this.id_hebahan = id_hebahan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public String getTajuk() { return tajuk; }
    public void setTajuk(String tajuk) { this.tajuk = tajuk; }

    public String getKandungan() { return kandungan; }
    public void setKandungan(String kandungan) { this.kandungan = kandungan; }

    public String getKategori() { return kategori; }
    public void setKategori(String kategori) { this.kategori = kategori; }

    public String getGambar_poster() { return gambar_poster; }
    public void setGambar_poster(String gambar_poster) { this.gambar_poster = gambar_poster; }

    public String getStatus_hebahan() { return status_hebahan; }
    public void setStatus_hebahan(String status_hebahan) { this.status_hebahan = status_hebahan; }

    public Date getTarikh_mula_acara() { return tarikh_mula_acara; }
    public void setTarikh_mula_acara(Date tarikh_mula_acara) { this.tarikh_mula_acara = tarikh_mula_acara; }

    public Date getTarikh_tamat_acara() { return tarikh_tamat_acara; }
    public void setTarikh_tamat_acara(Date tarikh_tamat_acara) { this.tarikh_tamat_acara = tarikh_tamat_acara; }

    public String getLokasi_acara() { return lokasi_acara; }
    public void setLokasi_acara(String lokasi_acara) { this.lokasi_acara = lokasi_acara; }

    public Date getTarikh_tamat() { return tarikh_tamat; }
    public void setTarikh_tamat(Date tarikh_tamat) { this.tarikh_tamat = tarikh_tamat; }

    public Date getTarikh_hebahan() { return tarikh_hebahan; }
    public void setTarikh_hebahan(Date tarikh_hebahan) { this.tarikh_hebahan = tarikh_hebahan; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public Date getDikemaskini_pada() { return dikemaskini_pada; }
    public void setDikemaskini_pada(Date dikemaskini_pada) { this.dikemaskini_pada = dikemaskini_pada; }

    public Date getDipadam_pada() { return dipadam_pada; }
    public void setDipadam_pada(Date dipadam_pada) { this.dipadam_pada = dipadam_pada; }

    public String getNama_penuh() { return nama_penuh; }
    public void setNama_penuh(String nama_penuh) { this.nama_penuh = nama_penuh; }
}
