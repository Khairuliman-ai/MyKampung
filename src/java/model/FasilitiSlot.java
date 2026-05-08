package model;

import java.sql.Time;

public class FasilitiSlot {
    private int id_slot;
    private int id_fasiliti;
    private Time masa_mula;
    private Time masa_tamat;
    private String durasi;

    public FasilitiSlot() {}

    public int getId_slot() { return id_slot; }
    public void setId_slot(int id_slot) { this.id_slot = id_slot; }

    public int getId_fasiliti() { return id_fasiliti; }
    public void setId_fasiliti(int id_fasiliti) { this.id_fasiliti = id_fasiliti; }

    public Time getMasa_mula() { return masa_mula; }
    public void setMasa_mula(Time masa_mula) { this.masa_mula = masa_mula; }

    public Time getMasa_tamat() { return masa_tamat; }
    public void setMasa_tamat(Time masa_tamat) { this.masa_tamat = masa_tamat; }

    public String getDurasi() { return durasi; }
    public void setDurasi(String durasi) { this.durasi = durasi; }
}
