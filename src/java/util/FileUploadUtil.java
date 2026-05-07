package util;

import java.io.File;
import javax.servlet.http.Part;

public final class FileUploadUtil {
    private FileUploadUtil() {}

    /**
     * Simpan fail yang dimuat naik ke direktori yang ditetapkan.
     * @param filePart Part dari request multipart
     * @param saveDir Direktori penyimpanan (gunakan AppConfig constants)
     * @param prefix Awalan nama fail (cth: "aduan_4_")
     * @return nama fail yang disimpan, atau null jika tiada fail
     */
    public static String saveFile(Part filePart, String saveDir, String prefix)
            throws Exception {
        if (filePart == null || filePart.getSize() <= 0) return null;

        File dir = new File(saveDir);
        if (!dir.exists()) dir.mkdirs();

        String original = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
        String fileName = prefix + System.currentTimeMillis() + "_" + original;
        filePart.write(saveDir + File.separator + fileName);
        return fileName;
    }
}
