package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import util.DBUtil; // Pastikan import DBUtil anda betul
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/RegisterServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set encoding untuk elak ralat tulisan/simbol
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Ambil Data Teks
            String nama_penuh = request.getParameter("nama_penuh");
            String nombor_kp = request.getParameter("nombor_kp");
            String nombor_telefon = request.getParameter("nombor_telefon");
            String kata_laluan = request.getParameter("kata_laluan");

            String nama_jalan = request.getParameter("nama_jalan");
            String nombor_poskod = request.getParameter("nombor_poskod");
            String bandar = request.getParameter("bandar");
            String negeri = request.getParameter("negeri");

// 2. Proses Muat Naik Fail PDF
            Part filePart = request.getPart("bukti_pdf");
            String fileName = "";

            if (filePart != null && filePart.getSize() > 0) {
                fileName = "bukti_" + nombor_kp + "_" + System.currentTimeMillis() + ".pdf";

                // TUKAR: Gunakan path yang sama dengan FileServlet anda
                String uploadPath = "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\lampiranPengguna";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Simpan fail terus ke folder OneDrive
                filePart.write(uploadPath + File.separator + fileName);
            }

            // 3. Set Data ke Model Pengguna
            Pengguna p = new Pengguna();
            p.setNama_penuh(nama_penuh);
            p.setNombor_kp(nombor_kp);
            p.setNombor_telefon(nombor_telefon);
            p.setKata_laluan(kata_laluan);
            p.setNama_jalan(nama_jalan);
            p.setNombor_poskod(nombor_poskod);
            p.setBandar(bandar);
            p.setNegeri(negeri);
            p.setLampiran_pengesahan(fileName);
            p.setStatus(2); // Pending

            // Extract Tarikh Lahir
            if (nombor_kp != null && nombor_kp.length() >= 6) {
                try {
                    String datePart = nombor_kp.substring(0, 6);
                    SimpleDateFormat sdfIC = new SimpleDateFormat("yyMMdd");
                    p.setTarikh_lahir(sdfIC.parse(datePart));
                } catch (Exception e) {
                    p.setTarikh_lahir(new Date());
                }
            }

            // 4. Simpan ke Database
            // Guna DBUtil untuk dapatkan connection (Pastikan class DBUtil anda wujud)
            try (Connection conn = DBUtil.getConnection()) {
                PenggunaDAO pDao = new PenggunaDAO(conn); // Pass connection ke constructor
                boolean isSuccess = pDao.daftarPengguna(p);

                if (isSuccess) {
                    String msg = "Pendaftaran berjaya dihantar. Sila tunggu pengesahan daripada Ketua Kampung.";
                    // Redirect ke auth.jsp atau login.jsp mengikut struktur folder anda
                    response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp?success=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                } else {
                    request.setAttribute("errorMessage", "Pendaftaran gagal. Nombor KP mungkin sudah berdaftar.");
                    request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Ralat sistem: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }
}
