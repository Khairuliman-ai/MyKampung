package model;

public class Bantuan {
    private int idBantuan;
    private String namaBantuan;
    private int peruntukan;
    private String kriteriaKelayakan;

    // Getters and Setters
    public int getIdBantuan() { return idBantuan; }
    public void setIdBantuan(int idBantuan) { this.idBantuan = idBantuan; }
    public String getNamaBantuan() { return namaBantuan; }
    public void setNamaBantuan(String namaBantuan) { this.namaBantuan = namaBantuan; }
    public int getPeruntukan() { return peruntukan; }
    public void setPeruntukan(int peruntukan) { this.peruntukan = peruntukan; }
    public String getKriteriaKelayakan() { return kriteriaKelayakan; }
    public void setKriteriaKelayakan(String kriteriaKelayakan) { this.kriteriaKelayakan = kriteriaKelayakan; }
}