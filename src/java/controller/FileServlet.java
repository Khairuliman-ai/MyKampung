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
        if (parts.length < 3) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String type = parts[1];      // "pengguna"
        String filename = parts[2];  // "bukti_xxx.pdf"

        String subFolder = "";
        if ("pengguna".equals(type)) {
            subFolder = "lampiranPengguna";
        } else if ("bantuan".equals(type)) {
            subFolder = "lampiranBantuan";
        } else if ("profil".equals(type)) {
            subFolder = "fotoProfil";
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
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