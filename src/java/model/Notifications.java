package model;

import java.util.Date;

public class Notifications {
    private int id_notification;
    private int id_pengguna;
    private String jenis;        // ADUAN, BANTUAN, TEMPAHAN, HEBAHAN, SISTEM
    private String tajuk;
    private String mesej;
    private String pautan;
    private boolean sudah_baca;
    private Date dibuat_pada;

    public Notifications() {}

    // === HELPER METHODS FOR UI ===
    public String getJenisIcon() {
        if (jenis == null) return "fas fa-bell";
        switch (jenis.toUpperCase()) {
            case "ADUAN":    return "fas fa-comment-dots";
            case "BANTUAN":   return "fas fa-hand-holding-heart";
            case "TEMPAHAN":  return "fas fa-calendar-check";
            case "HEBAHAN":   return "fas fa-bullhorn";
            case "SISTEM":    return "fas fa-cog";
            default:          return "fas fa-bell";
        }
    }

    public String getJenisBadgeClass() {
        if (jenis == null) return "bg-gray-100 text-gray-600";
        switch (jenis.toUpperCase()) {
            case "ADUAN":    return "bg-orange-100 text-orange-700";
            case "BANTUAN":   return "bg-emerald-100 text-emerald-700";
            case "TEMPAHAN":  return "bg-blue-100 text-blue-700";
            case "HEBAHAN":   return "bg-purple-100 text-purple-700";
            case "SISTEM":    return "bg-slate-100 text-slate-700";
            default:          return "bg-gray-100 text-gray-700";
        }
    }

    // === GETTERS & SETTERS ===
    public int getId_notification() { return id_notification; }
    public void setId_notification(int id_notification) { this.id_notification = id_notification; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public String getJenis() { return jenis; }
    public void setJenis(String jenis) { this.jenis = jenis; }

    public String getTajuk() { return tajuk; }
    public void setTajuk(String tajuk) { this.tajuk = tajuk; }

    public String getMesej() { return mesej; }
    public void setMesej(String mesej) { this.mesej = mesej; }

    public String getPautan() { return pautan; }
    public void setPautan(String pautan) { this.pautan = pautan; }

    public boolean isSudah_baca() { return sudah_baca; }
    public void setSudah_baca(boolean sudah_baca) { this.sudah_baca = sudah_baca; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }
}
