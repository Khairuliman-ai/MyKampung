package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import util.AppConfig;
import util.FileUploadUtil;
import util.DBUtil;


import org.mindrot.jbcrypt.BCrypt; // 1. IMPORT PENTING
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
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Ambil Data Teks
            String nama_penuh = request.getParameter("nama_penuh");
            String nombor_kp = request.getParameter("nombor_kp");
            String nombor_telefon = request.getParameter("nombor_telefon");
            String email = request.getParameter("email");
            String kata_laluan_mentah = request.getParameter("kata_laluan"); // Password asal
            String nama_jalan = request.getParameter("nama_jalan");
            String daerah = request.getParameter("daerah");
            String nombor_poskod = request.getParameter("nombor_poskod");
            String bandar = request.getParameter("bandar");
            String negeri = request.getParameter("negeri");

            // 2. PROSES BCRYPT: Tukar password mentah kepada Hash
            // Kod ini akan menghasilkan string panjang bermula dengan $2a$
            String hashedPassword = BCrypt.hashpw(kata_laluan_mentah, BCrypt.gensalt());

            // 3. Proses Muat Naik Fail PDF (Kekalkan kod sedia ada)
            String fileName = FileUploadUtil.saveFile(
                request.getPart("bukti_pdf"), AppConfig.DIR_LAMPIRAN_PENGGUNA, "bukti_" + nombor_kp + "_");
            if (fileName == null) fileName = "";


            // 4. Set Data ke Model Pengguna
            Pengguna p = new Pengguna();
            p.setNama_penuh(nama_penuh);
            p.setNombor_kp(nombor_kp);
            p.setNombor_telefon(nombor_telefon);
            p.setEmail(email);
            p.setKata_laluan(hashedPassword); // SIMPAN HASH, BUKAN MENTAH
            p.setNama_jalan(nama_jalan);
            p.setDaerah(daerah);
            p.setNombor_poskod(nombor_poskod);
            p.setBandar(bandar);
            p.setNegeri(negeri);
            p.setLampiran_pengesahan(fileName);
            p.setStatus(2); // Pending

            // Extract Tarikh Lahir (Kekalkan kod sedia ada)
            if (nombor_kp != null && nombor_kp.length() >= 6) {
                try {
                    String datePart = nombor_kp.substring(0, 6);
                    SimpleDateFormat sdfIC = new SimpleDateFormat("yyMMdd");
                    p.setTarikh_lahir(sdfIC.parse(datePart));
                } catch (Exception e) {
                    p.setTarikh_lahir(new Date());
                }
            }

            // 5. Simpan ke Database
            try (Connection conn = DBUtil.getConnection()) {
                PenggunaDAO pDao = new PenggunaDAO(conn);
                boolean isSuccess = pDao.daftarPengguna(p);

                if (isSuccess) {
                    String msg = "Pendaftaran berjaya dihantar. Sila tunggu pengesahan daripada Ketua Kampung.";
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