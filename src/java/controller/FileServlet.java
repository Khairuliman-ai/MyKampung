package controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/file/*")
public class FileServlet extends HttpServlet {

    private static final String BASE_PATH = "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo(); 
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        String[] parts = pathInfo.split("/");
        String type = "";
        String filename = "";

        if (parts.length >= 3) {
            type = parts[1];      // "bantuan", "pengguna", "profil"
            filename = parts[2];  // "fail.pdf"
        } else if (parts.length == 2) {
            type = "bantuan";     // Default ke bantuan jika hanya ada nama fail
            filename = parts[1];
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String subFolder = "";
        if ("pengguna".equals(type)) {
            subFolder = "lampiranPengguna";
        } else if ("bantuan".equals(type)) {
            subFolder = "lampiranBantuan";
        } else if ("profil".equals(type)) {
            subFolder = "fotoProfil";
        } else if ("aduan".equals(type)) {
            subFolder = "gambarAduan";
        } else if ("hebahan".equals(type)) {
            subFolder = "gambarHebahan";
        } else if ("fasiliti".equals(type)) {
            subFolder = "gambarFasiliti";
        } else {
            // Jika 'type' bukan kategori yang dikenali, mungkin ia sebenarnya adalah nama fail
            // Cuba cari dalam lampiranBantuan sebagai fallback
            subFolder = "lampiranBantuan";
            filename = type; 
        }

        File file = new File(BASE_PATH + subFolder, filename);

        // --- SEMAK CONSOLE NETBEANS ANDA ---
        System.out.println("=== LOG FILE SERVLET ===");
        System.out.println("Mencari di: " + file.getAbsolutePath());
        System.out.println("Wujud?: " + file.exists());
        System.out.println("========================");

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(file.getName());
        response.setContentType(contentType != null ? contentType : "application/octet-stream");
        Files.copy(file.toPath(), response.getOutputStream());
    }
}