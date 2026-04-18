package model;

public class PenggunaPeranan {
    private int id_pengguna_peranan; // Primary Key dari ERD
    private int id_pengguna;         // Foreign Key
    private int id_peranan;          // Foreign Key

    // Getters and Setters
    public int getId_pengguna_peranan() { return id_pengguna_peranan; }
    public void setId_pengguna_peranan(int id_pengguna_peranan) { this.id_pengguna_peranan = id_pengguna_peranan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_peranan() { return id_peranan; }
    public void setId_peranan(int id_peranan) { this.id_peranan = id_peranan; }
}