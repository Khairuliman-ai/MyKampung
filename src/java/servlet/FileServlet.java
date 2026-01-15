package servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/file/*") // URL pattern for accessing files
public class FileServlet extends HttpServlet {

    // Must match the path you set in BantuanServlet
    private static final String UPLOAD_DIR = "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\lampiranBantuan";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the filename from the URL (e.g., /file/myphoto.jpg)
        String filename = request.getPathInfo().substring(1); 
        
        File file = new File(UPLOAD_DIR, filename);

        // 2. Check if file exists
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 404
            return;
        }

        // 3. Set content type (PDF, Image, etc.)
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);

        // 4. Send file content to browser
        Files.copy(file.toPath(), response.getOutputStream());
    }
}