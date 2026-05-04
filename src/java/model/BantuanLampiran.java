package model;

import java.sql.Timestamp;

public class BantuanLampiran {
    private int id_lampiran;
    private int id_permohonan;
    private String nama_fail;
    private String jenis_lampiran; // PEMOHON or PENTADBIR
    private Timestamp dimuat_naik_pada;

    public BantuanLampiran() {}

    public BantuanLampiran(int id_permohonan, String nama_fail, String jenis_lampiran) {
        this.id_permohonan = id_permohonan;
        this.nama_fail = nama_fail;
        this.jenis_lampiran = jenis_lampiran;
    }

    public int getId_lampiran() { return id_lampiran; }
    public void setId_lampiran(int id_lampiran) { this.id_lampiran = id_lampiran; }

    public int getId_permohonan() { return id_permohonan; }
    public void setId_permohonan(int id_permohonan) { this.id_permohonan = id_permohonan; }

    public String getNama_fail() { return nama_fail; }
    public void setNama_fail(String nama_fail) { this.nama_fail = nama_fail; }

    public String getJenis_lampiran() { return jenis_lampiran; }
    public void setJenis_lampiran(String jenis_lampiran) { this.jenis_lampiran = jenis_lampiran; }

    public Timestamp getDimuat_naik_pada() { return dimuat_naik_pada; }
    public void setDimuat_naik_pada(Timestamp dimuat_naik_pada) { this.dimuat_naik_pada = dimuat_naik_pada; }
}
