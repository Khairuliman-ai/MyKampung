package model;

import java.sql.Timestamp;

public class TempahanFasiliti {
    private int id_tempahan;
    private int id_pengguna;
    private int id_fasiliti;
    private Timestamp tarikh_mula;
    private Timestamp tarikh_tamat;
    private String tujuan;
    private String status_tempahan;
    private Timestamp tarikh_mohon;
    
    // Bantuan untuk paparan UI (Join dari jadual Fasiliti)
    private String nama_fasiliti; 

    public TempahanFasiliti() {}

    public int getId_tempahan() { return id_tempahan; }
    public void setId_tempahan(int id_tempahan) { this.id_tempahan = id_tempahan; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public int getId_fasiliti() { return id_fasiliti; }
    public void setId_fasiliti(int id_fasiliti) { this.id_fasiliti = id_fasiliti; }

    public Timestamp getTarikh_mula() { return tarikh_mula; }
    public void setTarikh_mula(Timestamp tarikh_mula) { this.tarikh_mula = tarikh_mula; }

    public Timestamp getTarikh_tamat() { return tarikh_tamat; }
    public void setTarikh_tamat(Timestamp tarikh_tamat) { this.tarikh_tamat = tarikh_tamat; }

    public String getTujuan() { return tujuan; }
    public void setTujuan(String tujuan) { this.tujuan = tujuan; }

    public String getStatus_tempahan() { return status_tempahan; }
    public void setStatus_tempahan(String status_tempahan) { this.status_tempahan = status_tempahan; }

    public Timestamp getTarikh_mohon() { return tarikh_mohon; }
    public void setTarikh_mohon(Timestamp tarikh_mohon) { this.tarikh_mohon = tarikh_mohon; }

    public String getNama_fasiliti() { return nama_fasiliti; }
    public void setNama_fasiliti(String nama_fasiliti) { this.nama_fasiliti = nama_fasiliti; }
}