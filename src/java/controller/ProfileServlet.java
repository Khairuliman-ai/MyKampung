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
import javax.servlet.http.Part;

@WebServlet(urlPatterns = {"/profil/view", "/profil/update"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
/**
 * ProfileServlet manages the user profile area.
 * It handles the retrieval and display of the resident's profile (including activity logs
 * and family members), and processes updates such as password changes, general contact updates,
 * profile photo uploads, family member registration, and income verification document submissions.
 */
public class ProfileServlet extends HttpServlet {


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
                    
                    PenggunaDAO pDao = new PenggunaDAO();
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

                // --- PROSES MUAT NAIK PENGESAHAN PENDAPATAN PENDUDUK ---
                Part pengesahanPart = request.getPart("pengesahan_pendapatan");
                if (pengesahanPart != null && pengesahanPart.getSize() > 0) {
                    String fileName = FileUploadUtil.saveFile(
                        pengesahanPart, AppConfig.DIR_DOKUMEN_PENDAPATAN, "verify_" + currentUser.getId_pengguna() + "_");
                    if (fileName != null) currentUser.setPengesahan_pendapatan(fileName);
                }

                // --- PROSES AHLI KELUARGA ---
                String[] fIndices = request.getParameterValues("f_index[]");
                String[] fNama = request.getParameterValues("f_nama[]");
                String[] fKp = request.getParameterValues("f_kp[]");
                String[] fTel = request.getParameterValues("f_tel[]");
                String[] fUmur = request.getParameterValues("f_umur[]");
                String[] fHubungan = request.getParameterValues("f_hubungan[]");
                String[] fPekerjaan = request.getParameterValues("f_pekerjaan[]");
                String[] fPendapatan = request.getParameterValues("f_pendapatan[]");
                String[] fPengesahanExisting = request.getParameterValues("f_pengesahan_existing[]");

                List<model.AhliKeluarga> senaraiBaru = new java.util.ArrayList<>();
                if (fIndices != null) {
                    for (int i = 0; i < fIndices.length; i++) {
                        String idx = fIndices[i];
                        String name = fNama != null && i < fNama.length ? fNama[i] : "";
                        if (name == null || name.trim().isEmpty()) continue;
                        
                        model.AhliKeluarga ak = new model.AhliKeluarga();
                        ak.setId_pengguna(currentUser.getId_pengguna());
                        ak.setNama_penuh(name);
                        ak.setNombor_kp(fKp != null && i < fKp.length ? fKp[i] : "");
                        ak.setNombor_telefon(fTel != null && i < fTel.length ? fTel[i] : "");
                        try {
                            ak.setUmur(fUmur != null && i < fUmur.length && !fUmur[i].isEmpty() ? Integer.parseInt(fUmur[i]) : 0);
                        } catch (Exception e) { ak.setUmur(0); }
                        ak.setHubungan(fHubungan != null && i < fHubungan.length ? fHubungan[i] : "");
                        ak.setPekerjaan(fPekerjaan != null && i < fPekerjaan.length ? fPekerjaan[i] : "");
                        try {
                            ak.setPendapatan(fPendapatan != null && i < fPendapatan.length && !fPendapatan[i].isEmpty() ? new BigDecimal(fPendapatan[i]) : BigDecimal.ZERO);
                        } catch (Exception e) {
                            ak.setPendapatan(BigDecimal.ZERO);
                        }

                        // Urus muat naik fail pengesahan pendapatan ahli keluarga secara dinamik menggunakan indeks
                        Part fPart = request.getPart("f_pengesahan_pendapatan_" + idx);
                        String fName = null;
                        if (fPart != null && fPart.getSize() > 0) {
                            fName = FileUploadUtil.saveFile(
                                fPart, AppConfig.DIR_DOKUMEN_PENDAPATAN, "verify_fam_" + currentUser.getId_pengguna() + "_");
                        } else {
                            fName = (fPengesahanExisting != null && i < fPengesahanExisting.length) ? fPengesahanExisting[i] : "";
                        }
                        ak.setPengesahan_pendapatan(fName);

                        senaraiBaru.add(ak);
                    }
                }

                // C. Simpan ke Database (Gunakan Transaction)
                conn.setAutoCommit(false);
                try {
                    PenggunaDAO pDao = new PenggunaDAO();
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