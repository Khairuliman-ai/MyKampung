package model;

/**
 * Represents the mapping relation between a user and a committee portfolio (AJK_Jawatan).
 * Enforces the exclusivity mapping (e.g. one user per active portfolio).
 */
public class AJK_Jawatan {
    private int id_ajk_jawatan; // Primary Key
    private int id_pengguna;    // Foreign Key
    private int id_jawatan;     // Foreign Key

    // Getters and Setters
    public int getId_ajk_jawatan() { return id_ajk_jawatan; }
    public void setId_ajk_jawatan(int id_ajk_jawatan) { this.id_ajk_jawatan = id_ajk_jawatan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_jawatan() { return id_jawatan; }
    public void setId_jawatan(int id_jawatan) { this.id_jawatan = id_jawatan; }
}