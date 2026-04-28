package model;

import java.sql.Timestamp;

public class Fasiliti {
    private int id_fasiliti;
    private String nama_fasiliti;
    private String lokasi;
    private String status;
    private Double latitude;
    private Double longitude;
    private Timestamp dibuat_pada;
    private Timestamp dikemaskini_pada;
    private Timestamp dipadam_pada;
    private boolean occupied;
    private boolean requiresApproval;
    private String gambar_fasiliti;

    // --- Constructor Kosong ---
    public Fasiliti() {}

    // --- Getters and Setters ---
    public boolean isRequiresApproval() {
        return requiresApproval;
    }

    public void setRequiresApproval(boolean requiresApproval) {
        this.requiresApproval = requiresApproval;
    }
    public boolean isOccupied() {
        return occupied;
    }

    public void setOccupied(boolean occupied) {
        this.occupied = occupied;
    }
    public int getId_fasiliti() {
        return id_fasiliti;
    }

    public void setId_fasiliti(int id_fasiliti) {
        this.id_fasiliti = id_fasiliti;
    }

    public String getNama_fasiliti() {
        return nama_fasiliti;
    }

    public void setNama_fasiliti(String nama_fasiliti) {
        this.nama_fasiliti = nama_fasiliti;
    }

    public String getLokasi() {
        return lokasi;
    }

    public void setLokasi(String lokasi) {
        this.lokasi = lokasi;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getDibuat_pada() {
        return dibuat_pada;
    }

    public void setDibuat_pada(Timestamp dibuat_pada) {
        this.dibuat_pada = dibuat_pada;
    }

    public Timestamp getDikemaskini_pada() {
        return dikemaskini_pada;
    }

    public void setDikemaskini_pada(Timestamp dikemaskini_pada) {
        this.dikemaskini_pada = dikemaskini_pada;
    }

    public Timestamp getDipadam_pada() {
        return dipadam_pada;
    }

    public void setDipadam_pada(Timestamp dipadam_pada) {
        this.dipadam_pada = dipadam_pada;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getGambar_fasiliti() {
        return gambar_fasiliti;
    }

    public void setGambar_fasiliti(String gambar_fasiliti) {
        this.gambar_fasiliti = gambar_fasiliti;
    }
}