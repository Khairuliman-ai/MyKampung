package model;

import java.util.Date;

public class Pengguna {
    private int idPengguna;
    private String namaPertama;
    private String namaKedua;
    private String nomborKP;
    private String nomborTelefon;
    private Date tarikhLahir;
    private String jawatan;
    private String kataLaluan;
    private Date tarikhKemaskini;
    private String namaJalan;
    private String bandar;
    private String nomborPoskod;
    private String negeri;

    // Getters and Setters
    public int getIdPengguna() { return idPengguna; }
    public void setIdPengguna(int idPengguna) { this.idPengguna = idPengguna; }
    public String getNamaPertama() { return namaPertama; }
    public void setNamaPertama(String namaPertama) { this.namaPertama = namaPertama; }
    public String getNamaKedua() { return namaKedua; }
    public void setNamaKedua(String namaKedua) { this.namaKedua = namaKedua; }
    public String getNomborKP() { return nomborKP; }
    public void setNomborKP(String nomborKP) { this.nomborKP = nomborKP; }
    public String getNomborTelefon() { return nomborTelefon; }
    public void setNomborTelefon(String nomborTelefon) { this.nomborTelefon = nomborTelefon; }
    public Date getTarikhLahir() { return tarikhLahir; }
    public void setTarikhLahir(Date tarikhLahir) { this.tarikhLahir = tarikhLahir; }
    public String getJawatan() { return jawatan; }
    public void setJawatan(String jawatan) { this.jawatan = jawatan; }
    public String getKataLaluan() { return kataLaluan; }
    public void setKataLaluan(String kataLaluan) { this.kataLaluan = kataLaluan; }  // Nota: Hashkan dalam production
    public Date getTarikhKemaskini() { return tarikhKemaskini; }
    public void setTarikhKemaskini(Date tarikhKemaskini) { this.tarikhKemaskini = tarikhKemaskini; }
    public String getNamaJalan() { return namaJalan; }
    public void setNamaJalan(String namaJalan) { this.namaJalan = namaJalan; }
    public String getBandar() { return bandar; }
    public void setBandar(String bandar) { this.bandar = bandar; }
    public String getNomborPoskod() { return nomborPoskod; }
    public void setNomborPoskod(String nomborPoskod) { this.nomborPoskod = nomborPoskod; }
    public String getNegeri() { return negeri; }
    public void setNegeri(String negeri) { this.negeri = negeri; }
}