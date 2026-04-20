package controller;

import java.io.IOException;
import java.sql.Connection;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import dao.ActivityLogDAO;
import model.Pengguna;
import model.ActivityLog;
import util.DBUtil;
import java.util.List;

@WebServlet(urlPatterns = {"/profil/view", "/profil/update"})
@javax.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ProfileServlet extends HttpServlet {

    // 1. Method doGet: Untuk paparkan halaman profil
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        // Gunakan 'currentUser' supaya selaras dengan LoginServlet anda
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user != null) {
            try (Connection conn = DBUtil.getConnection()) {
                ActivityLogDAO logDAO = new ActivityLogDAO(conn);
                List<ActivityLog> logs = logDAO.getLogsByResidentId(user.getId_pengguna());
                request.setAttribute("activityLogs", logs);
            } catch (Exception e) {
                e.printStackTrace();
            }
            // Dalam DB v2, maklumat profil sudah ada dalam objek user di session.
            // Kita cuma perlu forward ke JSP yang betul.
            request.getRequestDispatcher("/views/maklumatPenduduk/kemaskiniProfil.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        }
    }

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
                String statusKeluarga = request.getParameter("status_keluarga");
                String pekerjaan = request.getParameter("pekerjaan");
                String pendapatanStr = request.getParameter("pendapatan");
                String latStr = request.getParameter("latitude");
                String lonStr = request.getParameter("longitude");

                // --- PROSES MUAT NAIK GAMBAR ---
                try {
                    Part filePart = request.getPart("foto_profil");
                    if (filePart != null && filePart.getSize() > 0) {
                        String contentDisp = filePart.getHeader("content-disposition");
                        String fileName = "";
                        for (String token : contentDisp.split(";")) {
                            if (token.trim().startsWith("filename")) {
                                fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                            }
                        }
                        
                        if (!fileName.isEmpty()) {
                            String newFileName = System.currentTimeMillis() + "_" + fileName;
                            String uploadPath = getServletContext().getRealPath("/") + "file/profil";
                            java.io.File uploadDir = new java.io.File(uploadPath);
                            if (!uploadDir.exists()) uploadDir.mkdirs();
                            filePart.write(uploadPath + java.io.File.separator + newFileName);
                            currentUser.setFoto_profil(newFileName);
                        }
                    }
                } catch (Exception e) {
                    System.out.println("No file uploaded or error: " + e.getMessage());
                }

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

                if (latStr != null && !latStr.isEmpty()) {
                    currentUser.setLatitude(Double.parseDouble(latStr));
                }
                if (lonStr != null && !lonStr.isEmpty()) {
                    currentUser.setLongitude(Double.parseDouble(lonStr));
                }

                // C. Simpan ke Database
                PenggunaDAO pDao = new PenggunaDAO(conn);
                boolean success = pDao.updateProfil(currentUser);
                
                if (success) {
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