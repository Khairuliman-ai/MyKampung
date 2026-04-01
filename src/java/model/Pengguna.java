package model;

import java.util.Date;
import java.math.BigDecimal;

public class Pengguna {

    private int id_pengguna;
    private String nama_penuh;
    private String nombor_kp;
    private String nombor_telefon;
    private Date tarikh_lahir;
    private String kata_laluan;
    private String status_keluarga;
    private String pekerjaan;
    private BigDecimal pendapatan;
    private String lampiran_pengesahan;

    // Alamat
    private String nama_jalan;
    private String nombor_poskod;
    private String bandar;
    private String negeri;

    // Audit & Status
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;
    private int status;  // users authentication

    // Variable Tambahan (Untuk Logik Dashboard/Role)
    private String nama_peranan; // Diambil dari table 'peranan'
    private String nama_jawatan; // Diambil dari table 'jawatan_ajk' (khusus untuk AJK)

    // --- HELPER METHODS ---
    public String getAlamatLengkap() {
        return (nama_jalan != null ? nama_jalan : "") + ", "
                + (nombor_poskod != null ? nombor_poskod : "") + " "
                + (bandar != null ? bandar : "") + ", "
                + (negeri != null ? negeri : "");
    }

    public String getPendapatanFormatted() {
        return (pendapatan != null) ? "RM " + pendapatan.setScale(2).toString() : "RM 0.00";
    }

    // --- GETTERS AND SETTERS ---
    public int getId_pengguna() {
        return id_pengguna;
    }

    public void setId_pengguna(int id_pengguna) {
        this.id_pengguna = id_pengguna;
    }

    public String getNama_penuh() {
        return nama_penuh;
    }

    public void setNama_penuh(String nama_penuh) {
        this.nama_penuh = nama_penuh;
    }

    public String getNombor_kp() {
        return nombor_kp;
    }

    public void setNombor_kp(String nombor_kp) {
        this.nombor_kp = nombor_kp;
    }

    public String getNombor_telefon() {
        return nombor_telefon;
    }

    public void setNombor_telefon(String nombor_telefon) {
        this.nombor_telefon = nombor_telefon;
    }

    public Date getTarikh_lahir() {
        return tarikh_lahir;
    }

    public void setTarikh_lahir(Date tarikh_lahir) {
        this.tarikh_lahir = tarikh_lahir;
    }

    public String getKata_laluan() {
        return kata_laluan;
    }

    public void setKata_laluan(String kata_laluan) {
        this.kata_laluan = kata_laluan;
    }

    public String getStatus_keluarga() {
        return status_keluarga;
    }

    public void setStatus_keluarga(String status_keluarga) {
        this.status_keluarga = status_keluarga;
    }

    public String getPekerjaan() {
        return pekerjaan;
    }

    public void setPekerjaan(String pekerjaan) {
        this.pekerjaan = pekerjaan;
    }

    public BigDecimal getPendapatan() {
        return pendapatan;
    }

    public void setPendapatan(BigDecimal pendapatan) {
        this.pendapatan = pendapatan;
    }

    public String getNama_jalan() {
        return nama_jalan;
    }

    public void setNama_jalan(String nama_jalan) {
        this.nama_jalan = nama_jalan;
    }

    public String getNombor_poskod() {
        return nombor_poskod;
    }

    public void setNombor_poskod(String nombor_poskod) {
        this.nombor_poskod = nombor_poskod;
    }

    public String getBandar() {
        return bandar;
    }

    public void setBandar(String bandar) {
        this.bandar = bandar;
    }

    public String getNegeri() {
        return negeri;
    }

    public void setNegeri(String negeri) {
        this.negeri = negeri;
    }

    public Date getDibuat_pada() {
        return dibuat_pada;
    }

    public void setDibuat_pada(Date dibuat_pada) {
        this.dibuat_pada = dibuat_pada;
    }

    public Date getDikemaskini_pada() {
        return dikemaskini_pada;
    }

    public void setDikemaskini_pada(Date dikemaskini_pada) {
        this.dikemaskini_pada = dikemaskini_pada;
    }

    public Date getDipadam_pada() {
        return dipadam_pada;
    }

    public void setDipadam_pada(Date dipadam_pada) {
        this.dipadam_pada = dipadam_pada;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    // --- GETTERS & SETTERS TAMBAHAN ---
    public String getNama_peranan() {
        return nama_peranan;
    }

    public void setNama_peranan(String nama_peranan) {
        this.nama_peranan = nama_peranan;
    }

    public String getNama_jawatan() {
        return nama_jawatan;
    }

    public void setNama_jawatan(String nama_jawatan) {
        this.nama_jawatan = nama_jawatan;
    }

    public String getLampiran_pengesahan() {
        return lampiran_pengesahan;
    }

    public void setLampiran_pengesahan(String lampiran_pengesahan) {
        this.lampiran_pengesahan = lampiran_pengesahan;
    }
    
    
}
