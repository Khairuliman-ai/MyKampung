package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import util.AppConfig;
import util.FileUploadUtil;


import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
/**
 * RegisterServlet handles new resident registrations.
 * 
 * <p><strong>Registration Flow:</strong></p>
 * <ol>
 *   <li>The resident submits registration details via the form in {@code auth.jsp}.</li>
 *   <li>Password is securely hashed using BCrypt.</li>
 *   <li>Verification PDF is uploaded to the server directory.</li>
 *   <li>The resident account is created with status = 2 (Pending approval).</li>
 *   <li>Account awaits manual verification and status activation by the Setiausaha.</li>
 * </ol>
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {

            
            String nama_penuh = request.getParameter("nama_penuh");
            String nombor_kp = request.getParameter("nombor_kp");
            if (nombor_kp != null) {
                nombor_kp = nombor_kp.replaceAll("[^0-9]", "");
            }
            String nombor_telefon = request.getParameter("nombor_telefon");
            String email = request.getParameter("email");
            String kata_laluan_mentah = request.getParameter("kata_laluan");
            String nama_jalan = request.getParameter("nama_jalan");
            String daerah = request.getParameter("daerah");
            String nombor_poskod = request.getParameter("nombor_poskod");
            String bandar = request.getParameter("bandar");
            String negeri = request.getParameter("negeri");

            String hashedPassword = BCrypt.hashpw(kata_laluan_mentah, BCrypt.gensalt());

            String fileName = FileUploadUtil.saveFile(
                request.getPart("bukti_pdf"), AppConfig.DIR_LAMPIRAN_PENGGUNA, "bukti_" + nombor_kp + "_");
            if (fileName == null) fileName = "";

            Pengguna p = new Pengguna();
            p.setNama_penuh(nama_penuh);
            p.setNombor_kp(nombor_kp);
            p.setNombor_telefon(nombor_telefon);
            p.setEmail(email);
            p.setKata_laluan(hashedPassword); 
            p.setNama_jalan(nama_jalan);
            p.setDaerah(daerah);
            p.setNombor_poskod(nombor_poskod);
            p.setBandar(bandar);
            p.setNegeri(negeri);
            p.setLampiran_pengesahan(fileName);
            // Initial account status set to 2 (Pending approval). Setiausaha must review
            // and activate the account before the resident can log in.
            p.setStatus(2);


            // Parse date of birth from Malaysian IC (first 6 digits in format yyMMdd).
            // Example: "960512-11-2032" -> "960512" -> May 12, 1996.
            if (nombor_kp != null && nombor_kp.length() >= 6) {
                try {
                    String datePart = nombor_kp.substring(0, 6);
                    SimpleDateFormat sdfIC = new SimpleDateFormat("yyMMdd");
                    p.setTarikh_lahir(sdfIC.parse(datePart));
                } catch (Exception e) {
                    p.setTarikh_lahir(new Date());
                }
            }

            PenggunaDAO pDao = new PenggunaDAO();
            boolean isSuccess = pDao.daftarPengguna(p);

            if (isSuccess) {
                String msg = "Pendaftaran berjaya dihantar. Sila tunggu pengesahan daripada Ketua Kampung.";
                response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp?success=" + java.net.URLEncoder.encode(msg, "UTF-8"));
            } else {
                request.setAttribute("authMode", "signup");
                request.setAttribute("errorMessage", "Pendaftaran gagal. Nombor KP mungkin sudah berdaftar.");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String rawMessage = e.getMessage() != null ? e.getMessage() : "";
            String friendlyMessage;
            if (rawMessage.contains("Duplicate entry") || rawMessage.contains("Duplicate") || rawMessage.contains("constraint")) {
                friendlyMessage = "Pendaftaran gagal. Nombor KP atau Emel mungkin sudah berdaftar.";
            } else {
                friendlyMessage = "Ralat sistem: " + rawMessage.replace("'", "\\'");
            }
            request.setAttribute("authMode", "signup");
            request.setAttribute("errorMessage", friendlyMessage);
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }
}