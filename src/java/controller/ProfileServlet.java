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
import util.AppConfig;
import util.FileUploadUtil;
import util.DBUtil;


import java.util.List;
import javax.servlet.annotation.MultipartConfig;
import java.io.File;
import javax.servlet.http.Part;

@WebServlet(urlPatterns = {"/profil/view", "/profil/update"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileServlet extends HttpServlet {

    // 1. Method doGet: Untuk paparkan halaman profil
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user != null) {
            try (Connection conn = DBUtil.getConnection()) {
                // Fetch Activity Logs
                ActivityLogDAO logDAO = new ActivityLogDAO(conn);
                List<ActivityLog> logs = logDAO.getLogsByResidentId(user.getId_pengguna());
                request.setAttribute("activityLogs", logs);

                // --- FETCH AHLI KELUARGA ---
                dao.AhliKeluargaDAO ahliDao = new dao.AhliKeluargaDAO(conn);
                user.setSenaraiAhliKeluarga(ahliDao.getByPenggunaId(user.getId_pengguna()));
                session.setAttribute("currentUser", user);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
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
                    // ... (password change logic remains unchanged)
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
                String daerah = request.getParameter("daerah");
                
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
                currentUser.setDaerah(daerah);
                currentUser.setStatus_keluarga(statusKeluarga);
                currentUser.setPekerjaan(pekerjaan);
                
                if (pendapatanStr != null && !pendapatanStr.isEmpty()) {
                    currentUser.setPendapatan(new BigDecimal(pendapatanStr));
                }

                // Koordinat GPS dari Leaflet map
                String latStr = request.getParameter("latitude");
                String lonStr = request.getParameter("longitude");
                if (latStr != null && !latStr.isEmpty()) {
                    currentUser.setLatitude(Double.parseDouble(latStr));
                }
                if (lonStr != null && !lonStr.isEmpty()) {
                    currentUser.setLongitude(Double.parseDouble(lonStr));
                }

                // --- PROSES MUAT NAIK FOTO PROFIL ---
                Part fotoPart = request.getPart("foto_profil");
                if (fotoPart != null && fotoPart.getSize() > 0) {
                    String fotoName = FileUploadUtil.saveFile(
                        fotoPart, AppConfig.DIR_FOTO_PROFIL, "profil_" + currentUser.getId_pengguna() + "_");
                    if (fotoName != null) currentUser.setFoto_profil(fotoName);
                }

                // --- PROSES AHLI KELUARGA ---
                String[] fNama = request.getParameterValues("f_nama[]");
                String[] fKp = request.getParameterValues("f_kp[]");
                String[] fTel = request.getParameterValues("f_tel[]");
                String[] fUmur = request.getParameterValues("f_umur[]");
                String[] fHubungan = request.getParameterValues("f_hubungan[]");
                String[] fTanggungan = request.getParameterValues("f_tanggungan[]");

                List<model.AhliKeluarga> senaraiBaru = new java.util.ArrayList<>();
                if (fNama != null) {
                    for (int i = 0; i < fNama.length; i++) {
                        if (fNama[i] == null || fNama[i].trim().isEmpty()) continue;
                        
                        model.AhliKeluarga ak = new model.AhliKeluarga();
                        ak.setId_pengguna(currentUser.getId_pengguna());
                        ak.setNama_penuh(fNama[i]);
                        ak.setNombor_kp(fKp != null && i < fKp.length ? fKp[i] : "");
                        ak.setNombor_telefon(fTel != null && i < fTel.length ? fTel[i] : "");
                        try {
                            ak.setUmur(fUmur != null && i < fUmur.length && !fUmur[i].isEmpty() ? Integer.parseInt(fUmur[i]) : 0);
                        } catch (Exception e) { ak.setUmur(0); }
                        ak.setHubungan(fHubungan != null && i < fHubungan.length ? fHubungan[i] : "");
                        ak.setStatus_tanggungan(fTanggungan != null && i < fTanggungan.length ? fTanggungan[i] : "Tidak");
                        senaraiBaru.add(ak);
                    }
                }

                // C. Simpan ke Database (Gunakan Transaction)
                conn.setAutoCommit(false);
                try {
                    PenggunaDAO pDao = new PenggunaDAO(conn);
                    boolean pSuccess = pDao.updateProfil(currentUser);
                    
                    if (pSuccess) {
                        dao.AhliKeluargaDAO akDao = new dao.AhliKeluargaDAO(conn);
                        akDao.deleteByPenggunaId(currentUser.getId_pengguna());
                        for (model.AhliKeluarga ak : senaraiBaru) {
                            akDao.addAhliKeluarga(ak);
                        }
                        conn.commit();
                        
                        currentUser.setSenaraiAhliKeluarga(senaraiBaru);
                        session.setAttribute("currentUser", currentUser);
                        response.sendRedirect(request.getContextPath() + "/profil/view?status=success");
                    } else {
                        conn.rollback();
                        response.sendRedirect(request.getContextPath() + "/profil/view?status=error");
                    }
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                } finally {
                    conn.setAutoCommit(true);
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