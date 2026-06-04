package util;

/**
 * StatusConstant defines application-wide constant values for status strings and user role names.
 * Serves as the single source of truth to ensure consistency across controllers, filters, services, and DAOs.
 */
public class StatusConstant {
    
    // Generic Status
    public static final String BARU = "BARU";
    
    // Fasiliti Status
    public static final String FASILITI_AKTIF = "AKTIF";
    public static final String FASILITI_TIDAK_AKTIF = "TIDAK_AKTIF";
    
    // Tempahan Status
    public static final String TEMPAHAN_MENUNGGU = "MENUNGGU";
    public static final String TEMPAHAN_LULUS = "LULUS";
    public static final String TEMPAHAN_TOLAK = "TOLAK";
    public static final String TEMPAHAN_DIBATAL = "DIBATAL";
    
    // Role Names
    public static final String ROLE_KETUA_KAMPUNG = "Ketua Kampung";
    public static final String ROLE_AJK_KAMPUNG = "AJK Kampung";
    public static final String ROLE_PENDUDUK = "Penduduk Kampung";
}
