package model;

/**
 * StatusAduan bertindak sebagai pengurus kitaran hayat aduan di MyKampung V2.
 * Ia menyediakan kekunci status rasmi serta peraturan pertukaran status (State Transition Rules).
 */
public enum StatusAduan {
    SUBMITTED,              // Dihantar oleh penduduk
    UNDER_REVIEW_AJK,       // Sedang disemak oleh AJK Biro Keselamatan
    IN_PROGRESS_AJK,        // Dalam tindakan/proses oleh AJK
    ESCALATED_TO_KETUA,     // Diserah kepada Ketua Kampung
    UNDER_REVIEW_KETUA,     // Sedang disemak oleh Ketua Kampung
    IN_PROGRESS_HIGH_LEVEL, // Tindakan peringkat tinggi oleh Ketua Kampung
    RESOLVED,               // Aduan diselesaikan (oleh AJK atau Ketua)
    REJECTED,               // Aduan ditolak (oleh AJK atau Ketua)
    CLOSED,                 // Kes ditutup secara rasmi (hanya oleh Ketua)
    REOPENED;               // Aduan dibuka semula oleh penduduk (max 2 kali)

    /**
     * Memeriksa sama ada peralihan status ini sah mengikut peranan pengguna dan had reopen.
     * 
     * @param next Status destinasi yang dimohon
     * @param role Peranan pengguna semasa ("Penduduk", "AJK Kampung", "Ketua Kampung")
     * @param reopenCount Bilangan aduan telah dibuka semula setakat ini
     * @return true sekiranya peralihan status adalah sah, sebaliknya false
     */
    public boolean canTransitionTo(StatusAduan next, String role, int reopenCount) {
        // Normalisasi role untuk mengelakkan ralat kesaksamaan huruf besar/kecil
        String normRole = (role != null) ? role.trim().toUpperCase() : "";

        switch (this) {
            case SUBMITTED:
                return (next == UNDER_REVIEW_AJK || next == REJECTED) && "AJK KAMPUNG".equals(normRole);

            case UNDER_REVIEW_AJK:
                return (next == IN_PROGRESS_AJK || next == ESCALATED_TO_KETUA || next == REJECTED) && "AJK KAMPUNG".equals(normRole);

            case IN_PROGRESS_AJK:
                return (next == RESOLVED || next == ESCALATED_TO_KETUA) && "AJK KAMPUNG".equals(normRole);

            case ESCALATED_TO_KETUA:
                return (next == UNDER_REVIEW_KETUA || next == REJECTED) && "KETUA KAMPUNG".equals(normRole);

            case UNDER_REVIEW_KETUA:
                return (next == IN_PROGRESS_HIGH_LEVEL || next == RESOLVED || next == REJECTED) && "KETUA KAMPUNG".equals(normRole);

            case IN_PROGRESS_HIGH_LEVEL:
                return (next == RESOLVED) && "KETUA KAMPUNG".equals(normRole);

            case RESOLVED:
            case REJECTED:
                if (next == CLOSED && "KETUA KAMPUNG".equals(normRole)) {
                    return true;
                }
                if (next == REOPENED && "PENDUDUK".equals(normRole) && reopenCount < 2) {
                    return true;
                }
                return false;

            case CLOSED:
                return (next == REOPENED && "PENDUDUK".equals(normRole) && reopenCount < 2);

            case REOPENED:
                // Apabila dibuka semula, aduan diserahkan semula ke semakan AJK atau Ketua
                return (next == UNDER_REVIEW_AJK && "AJK KAMPUNG".equals(normRole))
                    || (next == UNDER_REVIEW_KETUA && "KETUA KAMPUNG".equals(normRole));

            default:
                return false;
        }
    }
}
