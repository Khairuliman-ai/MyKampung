package util;

import java.io.File;
import javax.servlet.http.Part;

/**
 * FileUploadUtil provides helper methods for storing multipart file uploads.
 * Ensures the target storage directory exists before writing, and sanitizes/prefixes filenames
 * to prevent duplicates and directory traversal.
 */
public final class FileUploadUtil {
    private FileUploadUtil() {}

    /**
     * Saves a uploaded file part to a specified target directory.
     * Enforces folder creation if it does not exist, replaces spaces in the original filename with underscores,
     * and prefixes it with the provided prefix and current timestamp to guarantee uniqueness.
     * 
     * @param filePart the multipart Part from the servlet request
     * @param saveDir the target storage directory (refer to AppConfig constants)
     * @param prefix the prefix to prepend to the filename
     * @return the unique filename of the saved file, or null if the part is empty
     * @throws Exception if an I/O error or writing failure occurs
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
