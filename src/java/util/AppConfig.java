package util;

public final class AppConfig {
    private AppConfig() {}

    public static final String DATA_DIR =
        "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData";

    public static final String DIR_LAMPIRAN_BANTUAN  = DATA_DIR + "\\lampiranBantuan";
    public static final String DIR_GAMBAR_ADUAN      = DATA_DIR + "\\gambarAduan";
    public static final String DIR_GAMBAR_HEBAHAN    = DATA_DIR + "\\gambarHebahan";
    public static final String DIR_GAMBAR_FASILITI   = DATA_DIR + "\\gambarFasiliti";
    public static final String DIR_FOTO_PROFIL       = DATA_DIR + "\\fotoProfil";
    public static final String DIR_LAMPIRAN_PENGGUNA = DATA_DIR + "\\lampiranPengguna";
    public static final String DIR_DOKUMEN_PENDAPATAN = DATA_DIR + "\\dokumenPendapatan";

    public static final String AUTH_REDIRECT = "/views/auth/auth.jsp";
}
