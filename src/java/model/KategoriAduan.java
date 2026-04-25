package model;

import java.util.Date;

public class KategoriAduan {
    private int id_kategori_aduan;
    private String nama_kategori;
    private String contoh_tajuk;
    private String penerangan;
    private Date dibuat_pada;
    private Date dikemaskini_pada;
    private Date dipadam_pada;

    public KategoriAduan() {}

    public int getId_kategori_aduan() { return id_kategori_aduan; }
    public void setId_kategori_aduan(int id_kategori_aduan) { this.id_kategori_aduan = id_kategori_aduan; }

    public String getNama_kategori() { return nama_kategori; }
    public void setNama_kategori(String nama_kategori) { this.nama_kategori = nama_kategori; }

    public String getContoh_tajuk() { return contoh_tajuk; }
    public void setContoh_tajuk(String contoh_tajuk) { this.contoh_tajuk = contoh_tajuk; }

    public String getPenerangan() { return penerangan; }
    public void setPenerangan(String penerangan) { this.penerangan = penerangan; }

    public Date getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Date dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public Date getDikemaskini_pada() { return dikemaskini_pada; }
    public void setDikemaskini_pada(Date dikemaskini_pada) { this.dikemaskini_pada = dikemaskini_pada; }

    public Date getDipadam_pada() { return dipadam_pada; }
    public void setDipadam_pada(Date dipadam_pada) { this.dipadam_pada = dipadam_pada; }
}
