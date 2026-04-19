package model;

import java.sql.Timestamp;

public class ActivityLog {
    private int id_log;
    private int id_pengguna;
    private int id_admin;
    private String jenis_tindakan;
    private String keterangan_tindakan;
    private Timestamp dibuat_pada;
    
    // Additional field for UI display
    private String adminName;

    // Constructors
    public ActivityLog() {}
    
    public ActivityLog(int id_pengguna, int id_admin, String jenis_tindakan, String keterangan_tindakan) {
        this.id_pengguna = id_pengguna;
        this.id_admin = id_admin;
        this.jenis_tindakan = jenis_tindakan;
        this.keterangan_tindakan = keterangan_tindakan;
    }

    // Getters and Setters
    public int getId_log() {
        return id_log;
    }

    public void setId_log(int id_log) {
        this.id_log = id_log;
    }

    public int getId_pengguna() {
        return id_pengguna;
    }

    public void setId_pengguna(int id_pengguna) {
        this.id_pengguna = id_pengguna;
    }

    public int getId_admin() {
        return id_admin;
    }

    public void setId_admin(int id_admin) {
        this.id_admin = id_admin;
    }

    public String getJenis_tindakan() {
        return jenis_tindakan;
    }

    public void setJenis_tindakan(String jenis_tindakan) {
        this.jenis_tindakan = jenis_tindakan;
    }

    public String getKeterangan_tindakan() {
        return keterangan_tindakan;
    }

    public void setKeterangan_tindakan(String keterangan_tindakan) {
        this.keterangan_tindakan = keterangan_tindakan;
    }

    public Timestamp getDibuat_pada() {
        return dibuat_pada;
    }

    public void setDibuat_pada(Timestamp dibuat_pada) {
        this.dibuat_pada = dibuat_pada;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
}
