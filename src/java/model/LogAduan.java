package model;

import java.sql.Timestamp;

public class LogAduan {
    private int id_log_aduan;
    private int id_aduan;
    private int id_pelaku;
    private String status_lama;
    private String status_baru;
    private String catatan;
    private Timestamp dibuat_pada;

    // Join field
    private String nama_pelaku;

    public LogAduan() {}

    public int getId_log_aduan() { return id_log_aduan; }
    public void setId_log_aduan(int id_log_aduan) { this.id_log_aduan = id_log_aduan; }

    public int getId_aduan() { return id_aduan; }
    public void setId_aduan(int id_aduan) { this.id_aduan = id_aduan; }

    public int getId_pelaku() { return id_pelaku; }
    public void setId_pelaku(int id_pelaku) { this.id_pelaku = id_pelaku; }

    public String getStatus_lama() { return status_lama; }
    public void setStatus_lama(String status_lama) { this.status_lama = status_lama; }

    public String getStatus_baru() { return status_baru; }
    public void setStatus_baru(String status_baru) { this.status_baru = status_baru; }

    public String getCatatan() { return catatan; }
    public void setCatatan(String catatan) { this.catatan = catatan; }

    public Timestamp getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Timestamp dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public String getNama_pelaku() { return nama_pelaku; }
    public void setNama_pelaku(String nama_pelaku) { this.nama_pelaku = nama_pelaku; }
}
