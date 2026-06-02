package controller;

import dao.AduanDAO;
import dao.KategoriAduanDAO;
import dao.LogAduanDAO;
import dao.PenggunaDAO;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Aduan;
import model.KategoriAduan;
import model.LogAduan;
import model.Pengguna;
import model.StatusAduan;
import util.AppConfig;
import util.FileUploadUtil;
import util.DBUtil;
import util.InputSanitizer;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class AduanServlet extends HttpServlet {

    private static final String SAVE_DIR = AppConfig.DIR_GAMBAR_ADUAN;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * =========================
         * 1. SESSION & AUTH CHECK
         * =========================
         */
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        /*
         * =========================
         * 2. INITIALIZE DAOS
         * =========================
         */
        String pathInfo = request.getPathInfo();
        AduanDAO aduanDAO = new AduanDAO();
        KategoriAduanDAO kategoriDAO = new KategoriAduanDAO();

        try {
            /*
             * =========================
             * 3. ROUTE: LIST COMPLAINTS
             * =========================
             */
            if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
                String role = user.getNama_peranan();
                List<Aduan> list;

                if ("Penduduk".equalsIgnoreCase(role)) {
                    list = aduanDAO.getByPenduduk(user.getId_pengguna());
                    List<KategoriAduan> kategoriList = kategoriDAO.getAll();
                    request.setAttribute("aduanList", list);
                    request.setAttribute("kategoriList", kategoriList);
                    request.getRequestDispatcher("/views/aduan/aduanPenduduk.jsp").forward(request, response);
                } else if ("AJK Kampung".equalsIgnoreCase(role)) {
                    list = aduanDAO.getByPengendali(user.getId_pengguna());
                    request.setAttribute("aduanList", list);
                    request.getRequestDispatcher("/views/aduan/urusAduanAJK.jsp").forward(request, response);
                } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
                    list = aduanDAO.getAll();
                    // Alihkan data AJK Keselamatan (Biro Keselamatan) ke JSP sebagai parameter
                    String[] ajkKeselamatan = aduanDAO.getAJKDetailsByJawatan(6);
                    request.setAttribute("namaAJKKeselamatan", ajkKeselamatan[0]);
                    request.setAttribute("telAJKKeselamatan", ajkKeselamatan[1]);
                    request.setAttribute("aduanList", list);
                    request.getRequestDispatcher("/views/aduan/urusAduanKetua.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
            } 
            else if ("/penduduk".equals(pathInfo)) {
                List<Aduan> list = aduanDAO.getByPenduduk(user.getId_pengguna());
                List<KategoriAduan> kategoriList = kategoriDAO.getAll();
                request.setAttribute("aduanList", list);
                request.setAttribute("kategoriList", kategoriList);
                request.getRequestDispatcher("/views/aduan/aduanPenduduk.jsp").forward(request, response);
            } 
            /*
             * =========================
             * 4. ROUTE: COMPLAINT DETAIL
             * =========================
             */
            else if ("/detail".equals(pathInfo)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Aduan aduan = aduanDAO.getById(id);
                LogAduanDAO logDAO = new LogAduanDAO();
                List<LogAduan> logList = logDAO.getByAduan(id);

                request.setAttribute("aduan", aduan);
                request.setAttribute("logList", logList);
                request.getRequestDispatcher("/views/aduan/detailAduan.jsp").forward(request, response);
            }
            else if ("/getLogs".equals(pathInfo)) {
                int id = Integer.parseInt(request.getParameter("id"));
                LogAduanDAO logDAO = new LogAduanDAO();
                List<LogAduan> logList = logDAO.getByAduan(id);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder("[");
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                for (int i = 0; i < logList.size(); i++) {
                    LogAduan l = logList.get(i);
                    String tarikhStr = (l.getDibuat_pada() != null) ? sdf.format(l.getDibuat_pada()) : "-";
                    String namaPelaku = (l.getNama_pelaku() != null) ? l.getNama_pelaku() : "Sistem";
                    
                    // Simple JSON escape for strings
                    String catatan = (l.getCatatan() != null) ? l.getCatatan() : "";
                    catatan = catatan.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                    String namaP = namaPelaku.replace("\\", "\\\\").replace("\"", "\\\"");
                    String statusB = (l.getStatus_baru() != null ? l.getStatus_baru() : "").replace("\\", "\\\\").replace("\"", "\\\"");

                    json.append("{")
                        .append("\"id\":").append(l.getId_log_aduan()).append(",")
                        .append("\"status_baru\":\"").append(statusB).append("\",")
                        .append("\"catatan\":\"").append(catatan).append("\",")
                        .append("\"nama_pelaku\":\"").append(namaP).append("\",")
                        .append("\"tarikh\":\"").append(tarikhStr).append("\"")
                        .append("}");
                    if (i < logList.size() - 1) json.append(",");
                }
                json.append("]");
                response.getWriter().write(json.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * =========================
         * 1. SESSION & AUTH CHECK
         * =========================
         */
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        /*
         * =========================
         * 2. INITIALIZE DAOS
         * =========================
         */
        String pathInfo = request.getPathInfo();
        AduanDAO aduanDAO = new AduanDAO();
        LogAduanDAO logDAO = new LogAduanDAO();

        try {
            /*
             * =========================
             * 3. ACTION: SUBMIT COMPLAINT
             * =========================
             */
            if ("/submit".equals(pathInfo)) {
                String tajuk = request.getParameter("tajuk");
                int idKategori = Integer.parseInt(request.getParameter("id_kategori"));
                String keterangan = request.getParameter("keterangan");
                String keutamaan = request.getParameter("keutamaan");

                String fileName = FileUploadUtil.saveFile(
                    request.getPart("gambar_aduan"), SAVE_DIR, "aduan_" + user.getId_pengguna() + "_");

                Aduan aduan = new Aduan();
                aduan.setId_pengguna(user.getId_pengguna());
                aduan.setId_kategori_aduan(idKategori);
                // Sanitasi input tajuk & keterangan ringkas bagi mencegah XSS
                aduan.setTajuk(InputSanitizer.sanitize(tajuk));
                aduan.setKeterangan(InputSanitizer.sanitize(keterangan));
                aduan.setKeutamaan(keutamaan);
                aduan.setGambar_aduan(fileName);

                // Auto-assign to Biro Keselamatan (id_jawatan = 6)
                Integer ajkId = aduanDAO.getAJKIdByJawatan(6);
                aduan.setId_pengendali(ajkId);

                if (aduanDAO.insertAduan(aduan)) {
                    // Trigger Notifikasi ke AJK Biro Keselamatan
                    service.NotificationService.notifyByJawatan("Biro Keselamatan", "ADUAN", "Aduan Baru Diterima",
                        "Aduan '" + aduan.getTajuk() + "' telah dihantar oleh " + user.getNama_penuh(), "/aduan/list");
                    response.sendRedirect(request.getContextPath() + "/aduan/list?status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?status=error");
                }
            } 
            /*
             * =========================
             * 4. ACTION: UPDATE STATUS
             * =========================
             */
            else if ("/updateStatus".equals(pathInfo)) {
                int idAduan = Integer.parseInt(request.getParameter("id_aduan"));
                String nextStatus = request.getParameter("next_status");
                String catatan = request.getParameter("catatan");
                String role = user.getNama_peranan();

                // Dapatkan rekod aduan semasa
                Aduan aduan = aduanDAO.getById(idAduan);
                if (aduan == null) {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=not_found");
                    return;
                }

                // Sekuriti & Keizinan: Hanya AJK Kampung & Ketua Kampung sahaja
                if (!"AJK Kampung".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak");
                    return;
                }

                // Validasi Server-Side State Transition menggunakan StatusAduan enum
                try {
                    StatusAduan currentEnum = StatusAduan.valueOf(aduan.getStatus() != null ? aduan.getStatus() : "SUBMITTED");
                    StatusAduan nextEnum = StatusAduan.valueOf(nextStatus);

                    if (!currentEnum.canTransitionTo(nextEnum, role, aduan.getReopen_count())) {
                        response.sendRedirect(request.getContextPath() + "/aduan/list?error=invalid_transition");
                        return;
                    }
                } catch (IllegalArgumentException e) {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=invalid_status");
                    return;
                }

                // Menguruskan Bukti Selesai bagi status RESOLVED
                String buktiSelesaiFileName = aduan.getBukti_selesai();
                if ("RESOLVED".equals(nextStatus)) {
                    String contentType = request.getContentType();
                    if (contentType != null && contentType.startsWith("multipart/")) {
                        try {
                            Part part = request.getPart("bukti_selesai_file");
                            if (part != null && part.getSize() > 0) {
                                String uploadedFile = FileUploadUtil.saveFile(part, SAVE_DIR, "bukti_" + idAduan + "_");
                                if (uploadedFile != null) {
                                    buktiSelesaiFileName = uploadedFile;
                                    aduanDAO.updateBuktiSelesai(idAduan, uploadedFile);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    // AJK Kampung (Biro Keselamatan) & Ketua Kampung diwajibkan untuk muat naik bukti
                    if ("AJK Kampung".equalsIgnoreCase(role) || "Ketua Kampung".equalsIgnoreCase(role)) {
                        if (buktiSelesaiFileName == null || buktiSelesaiFileName.trim().isEmpty()) {
                            response.sendRedirect(request.getContextPath() + "/aduan/list?error=missing_bukti");
                            return;
                        }
                    }
                }

                // Tentukan kolum catatan berdasarkan peranan
                String catatanField = "catatan_ajk";
                if ("Ketua Kampung".equalsIgnoreCase(role)) {
                    catatanField = "catatan_ketua";
                }

                // Sanitasi catatan
                String sanitisedCatatan = InputSanitizer.sanitize(catatan);
                String logCatatan = (sanitisedCatatan != null && !sanitisedCatatan.trim().isEmpty()) ? sanitisedCatatan : "Status dikemaskini oleh " + role;

                // Kemaskini status dan log secara atomik (transaksi pangkalan data)
                if (aduanDAO.updateStatusWithLog(idAduan, nextStatus, catatanField, sanitisedCatatan, user.getId_pengguna(), logCatatan)) {
                    // Trigger Notifikasi
                    service.NotificationService.notifyUser(aduan.getId_pengguna(), "ADUAN", "Status Aduan Dikemaskini",
                        "Aduan '" + aduan.getTajuk() + "' -> " + nextStatus, "/aduan/list");

                    // Jika di-escalate ke Ketua Kampung, hantar notifikasi ke Ketua Kampung
                    if ("ESCALATED_TO_KETUA".equals(nextStatus) || "UNDER_REVIEW_KETUA".equals(nextStatus)) {
                        service.NotificationService.notifyByPeranan("Ketua Kampung", "ADUAN", "Aduan Telah Diserahkan",
                            "Aduan '" + aduan.getTajuk() + "' memerlukan tindakan Ketua Kampung", "/aduan/list");
                    }
                    response.sendRedirect(request.getContextPath() + "/aduan/list?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=db");
                }
            }
            /*
             * =========================
             * 5. ACTION: REOPEN COMPLAINT
             * =========================
             */
            else if ("/reopen".equals(pathInfo)) {
                int idAduan = Integer.parseInt(request.getParameter("id_aduan"));
                String catatan = request.getParameter("catatan");
                String role = user.getNama_peranan();

                Aduan aduan = aduanDAO.getById(idAduan);
                if (aduan == null) {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=not_found");
                    return;
                }

                // Keizinan: Hanya penduduk (pemilik asal aduan) sahaja dibenarkan
                if (!"Penduduk".equalsIgnoreCase(role) || aduan.getId_pengguna() != user.getId_pengguna()) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak");
                    return;
                }

                // Validasi status aduan (mesti RESOLVED, REJECTED, atau CLOSED)
                String currentStatus = aduan.getStatus();
                if (!"RESOLVED".equalsIgnoreCase(currentStatus) && !"REJECTED".equalsIgnoreCase(currentStatus) && !"CLOSED".equalsIgnoreCase(currentStatus)) {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=cannot_reopen");
                    return;
                }

                // Validasi had kekerapan reopen (max 2 kali)
                if (aduan.getReopen_count() >= 2) {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=reopen_limit");
                    return;
                }

                String sanitisedCatatan = InputSanitizer.sanitize(catatan);
                String logCatatan = "Aduan dibuka semula oleh Pengadu. Sebab: " + (sanitisedCatatan != null && !sanitisedCatatan.trim().isEmpty() ? sanitisedCatatan : "Tiada catatan.");

                // Jalankan proses reopen secara atomik
                if (aduanDAO.reopenAduan(idAduan, user.getId_pengguna(), logCatatan)) {
                    // Trigger Notifikasi ke AJK Biro Keselamatan
                    service.NotificationService.notifyByJawatan("Biro Keselamatan", "ADUAN", "Aduan Dibuka Semula",
                        "Aduan '" + aduan.getTajuk() + "' telah dibuka semula oleh " + user.getNama_penuh(), "/aduan/list");
                    response.sendRedirect(request.getContextPath() + "/aduan/list?msg=reopened");
                } else {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=db");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tindakan tidak sah");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
