package util;

/**
 * AppConfig contains static configuration constants for directory paths and routing redirects.
 * 
 * > [!WARNING]
 * > **Hardcoded Paths**: The directory paths (DATA_DIR) are currently hardcoded to a local path
 * > for development. These should be externalized to web.xml context parameters or retrieved via
 * > JNDI environment lookups for production packaging and cross-platform compatibility.
 */
public final class AppConfig {
    private AppConfig() {}

    // A. Local Windows DIR
    public static final String DATA_DIR = "C:/Users/khayx/OneDrive/Documents/SEM5_UMT/PITA1/MyKampungData";

    // B. Server Linux DIR
    // public static final String DATA_DIR = "/home/s71383/MyKampungData";

    public static final String DIR_LAMPIRAN_BANTUAN  = DATA_DIR + "/lampiranBantuan";
    public static final String DIR_GAMBAR_ADUAN      = DATA_DIR + "/gambarAduan";
    public static final String DIR_GAMBAR_HEBAHAN    = DATA_DIR + "/gambarHebahan";
    public static final String DIR_GAMBAR_FASILITI   = DATA_DIR + "/gambarFasiliti";
    public static final String DIR_FOTO_PROFIL       = DATA_DIR + "/fotoProfil";
    public static final String DIR_LAMPIRAN_PENGGUNA = DATA_DIR + "/lampiranPengguna";
    public static final String DIR_DOKUMEN_PENDAPATAN = DATA_DIR + "/dokumenPendapatan";

    public static final String AUTH_REDIRECT = "/views/auth/auth.jsp";
}
