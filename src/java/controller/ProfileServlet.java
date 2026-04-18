package controller;

import java.io.IOException;
import java.sql.Connection;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import model.Pengguna;
import util.DBUtil;

@WebServlet(urlPatterns = {"/profil/view", "/profil/update"})
public class ProfileServlet extends HttpServlet {

    // 1. Method doGet: Untuk paparkan halaman profil
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        // Gunakan 'currentUser' supaya selaras dengan LoginServlet anda
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user != null) {
            // Dalam DB v2, maklumat profil sudah ada dalam objek user di session.
            // Kita cuma perlu forward ke JSP yang betul.
            request.getRequestDispatcher("/views/maklumatPenduduk/kemaskiniProfil.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        }
    }

    // 2. Method doPost: Untuk proses simpan kemaskini profil
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Pengguna currentUser = (Pengguna) session.getAttribute("currentUser");
        
        if (currentUser != null) {
            try (Connection conn = DBUtil.getConnection()) {
                // --- TUKAR KATA LALUAN ---
                String action = request.getParameter("action");
                if ("changePassword".equals(action)) {
                    String oldPass = request.getParameter("oldPassword");
                    String newPass = request.getParameter("newPassword");
                    
                    PenggunaDAO pDao = new PenggunaDAO(conn);
                    boolean isOldPassCorrect = false;
                    try {
                        isOldPassCorrect = org.mindrot.jbcrypt.BCrypt.checkpw(oldPass, currentUser.getKata_laluan());
                    } catch (IllegalArgumentException e) {
                        if (oldPass.equals(currentUser.getKata_laluan())) {
                            isOldPassCorrect = true;
                        }
                    }

                    if (isOldPassCorrect) {
                        String hashedNew = org.mindrot.jbcrypt.BCrypt.hashpw(newPass, org.mindrot.jbcrypt.BCrypt.gensalt(12));
                        boolean passSuccess = pDao.updatePassword(currentUser.getId_pengguna(), hashedNew);
                        if (passSuccess) {
                            currentUser.setKata_laluan(hashedNew);
                            session.setAttribute("currentUser", currentUser);
                            response.sendRedirect(request.getContextPath() + "/profil/view?status=pass_success");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/profil/view?status=pass_error");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/profil/view?status=wrong_old_pass");
                    }
                    return;
                }
                
                // --- KEMASKINI PROFIL BIASA ---
                // A. Ambil data dari form profil.jsp
                String namaPenuh = request.getParameter("nama_penuh");
                String noTel = request.getParameter("nombor_telefon");
                String jalan = request.getParameter("nama_jalan");
                String poskod = request.getParameter("nombor_poskod");
                String bandar = request.getParameter("bandar");
                String negeri = request.getParameter("negeri");
                String email = request.getParameter("email");
                
                // Data Sosio-Ekonomi
                String statusKeluarga = request.getParameter("status_keluarga");
                String pekerjaan = request.getParameter("pekerjaan");
                String pendapatanStr = request.getParameter("pendapatan");

                // B. Update Object currentUser
                currentUser.setNama_penuh(namaPenuh);
                currentUser.setNombor_telefon(noTel);
                currentUser.setEmail(email);
                currentUser.setNama_jalan(jalan);
                currentUser.setNombor_poskod(poskod);
                currentUser.setBandar(bandar);
                currentUser.setNegeri(negeri);
                currentUser.setStatus_keluarga(statusKeluarga);
                currentUser.setPekerjaan(pekerjaan);
                
                if (pendapatanStr != null && !pendapatanStr.isEmpty()) {
                    currentUser.setPendapatan(new BigDecimal(pendapatanStr));
                }

                // C. Simpan ke Database
                PenggunaDAO pDao = new PenggunaDAO(conn);
                
                boolean success = pDao.updateProfil(currentUser); // Anda perlu cipta method ini di DAO
                
                if (success) {
                    // Update session dengan data baru
                    session.setAttribute("currentUser", currentUser);
                    response.sendRedirect(request.getContextPath() + "/profil/view?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/profil/view?status=error");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/profil/view?status=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        }
    }
}