package model;

import java.math.BigDecimal;
import java.util.Date;

public class AhliKeluarga {
    private int id_ahli;
    private int id_pengguna;
    private String nama_penuh;
    private String nombor_kp;
    private String nombor_telefon;
    private int umur;
    private String hubungan;
    private String pekerjaan;
    private BigDecimal pendapatan;
    private String pengesahan_pendapatan;
    private Date dibuat_pada;

    // Constructors
    public AhliKeluarga() {}

    // Getters and Setters
    public int getId_ahli() {
        return id_ahli;
    }

    public void setId_ahli(int id_ahli) {
        this.id_ahli = id_ahli;
    }

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

    public int getUmur() {
        return umur;
    }

    public void setUmur(int umur) {
        this.umur = umur;
    }

    public String getHubungan() {
        return hubungan;
    }

    public void setHubungan(String hubungan) {
        this.hubungan = hubungan;
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

    public String getPengesahan_pendapatan() {
        return pengesahan_pendapatan;
    }

    public void setPengesahan_pendapatan(String pengesahan_pendapatan) {
        this.pengesahan_pendapatan = pengesahan_pendapatan;
    }

    public Date getDibuat_pada() {
        return dibuat_pada;
    }

    public void setDibuat_pada(Date dibuat_pada) {
        this.dibuat_pada = dibuat_pada;
    }
}
