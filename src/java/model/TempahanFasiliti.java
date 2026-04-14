package model;

import java.sql.Timestamp;
import java.sql.Date;
import java.sql.Time;

public class TempahanFasiliti {
    private int id_tempahan;
    private int id_fasiliti;
    private int id_pengguna;
    private Date tarikh_tempah; // Berdasarkan kolum DATE di DB
    private Time masa_mula;     // Berdasarkan kolum TIME di DB
    private Time masa_tamat;    // Berdasarkan kolum TIME di DB
    private String status;      // DB anda guna 'status', bukan 'status_tempahan'
    private String catatan_pentadbir;
    private Timestamp dibuat_pada;
    private Timestamp dikemaskini_pada;
    private Timestamp dipadam_pada;
    
    // Untuk paparan UI (Join jadual Fasiliti)
    private String nama_fasiliti; 

    public TempahanFasiliti() {}

    // --- Getters and Setters ---

    public int getId_tempahan() { return id_tempahan; }
    public void setId_tempahan(int id_tempahan) { this.id_tempahan = id_tempahan; }

    public int getId_fasiliti() { return id_fasiliti; }
    public void setId_fasiliti(int id_fasiliti) { this.id_fasiliti = id_fasiliti; }

    public int getId_pengguna() { return id_pengguna; }
    public void setId_pengguna(int id_pengguna) { this.id_pengguna = id_pengguna; }

    public Date getTarikh_tempah() { return tarikh_tempah; }
    public void setTarikh_tempah(Date tarikh_tempah) { this.tarikh_tempah = tarikh_tempah; }

    public Time getMasa_mula() { return masa_mula; }
    public void setMasa_mula(Time masa_mula) { this.masa_mula = masa_mula; }

    public Time getMasa_tamat() { return masa_tamat; }
    public void setMasa_tamat(Time masa_tamat) { this.masa_tamat = masa_tamat; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCatatan_pentadbir() { return catatan_pentadbir; }
    public void setCatatan_pentadbir(String catatan_pentadbir) { this.catatan_pentadbir = catatan_pentadbir; }

    public Timestamp getDibuat_pada() { return dibuat_pada; }
    public void setDibuat_pada(Timestamp dibuat_pada) { this.dibuat_pada = dibuat_pada; }

    public Timestamp getDikemaskini_pada() { return dikemaskini_pada; }
    public void setDikemaskini_pada(Timestamp dikemaskini_pada) { this.dikemaskini_pada = dikemaskini_pada; }

    public Timestamp getDipadam_pada() { return dipadam_pada; }
    public void setDipadam_pada(Timestamp dipadam_pada) { this.dipadam_pada = dipadam_pada; }

    public String getNama_fasiliti() { return nama_fasiliti; }
    public void setNama_fasiliti(String nama_fasiliti) { this.nama_fasiliti = nama_fasiliti; }
}