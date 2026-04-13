package model;

import java.sql.Timestamp;

public class Fasiliti {
    private int id_fasiliti;
    private String nama_fasiliti;
    private String kategori;
    private Integer kapasiti; // Menggunakan Integer jenis objek supaya boleh menerima nilai null
    private boolean ketersediaan;
    private Timestamp dibuat_pada;

    // --- Constructor Kosong ---
    public Fasiliti() {}

    // --- Getters and Setters ---
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

    public String getKategori() {
        return kategori;
    }

    public void setKategori(String kategori) {
        this.kategori = kategori;
    }

    public Integer getKapasiti() {
        return kapasiti;
    }

    public void setKapasiti(Integer kapasiti) {
        this.kapasiti = kapasiti;
    }

    public boolean isKetersediaan() {
        return ketersediaan;
    }

    public void setKetersediaan(boolean ketersediaan) {
        this.ketersediaan = ketersediaan;
    }

    public Timestamp getDibuat_pada() {
        return dibuat_pada;
    }

    public void setDibuat_pada(Timestamp dibuat_pada) {
        this.dibuat_pada = dibuat_pada;
    }
}