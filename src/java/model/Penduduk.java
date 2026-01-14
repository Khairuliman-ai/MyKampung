package model;

public class Penduduk {
    private int idPenduduk;
    private int idPengguna;
    private String statusSemasa;
    private String pekerjaan;
    private int pendapatan;

    // Getters and Setters
    public int getIdPenduduk() { return idPenduduk; }
    public void setIdPenduduk(int idPenduduk) { this.idPenduduk = idPenduduk; }
    public int getIdPengguna() { return idPengguna; }
    public void setIdPengguna(int idPengguna) { this.idPengguna = idPengguna; }
    public String getStatusSemasa() { return statusSemasa; }
    public void setStatusSemasa(String statusSemasa) { this.statusSemasa = statusSemasa; }
    public String getPekerjaan() { return pekerjaan; }
    public void setPekerjaan(String pekerjaan) { this.pekerjaan = pekerjaan; }
    public int getPendapatan() { return pendapatan; }
    public void setPendapatan(int pendapatan) { this.pendapatan = pendapatan; }
}