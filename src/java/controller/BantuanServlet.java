package controller;

import model.Bantuan;
import dao.BantuanDAO;
import model.PermohonanBantuan;
import dao.PermohonanBantuanDAO;
import model.Pengguna;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class BantuanServlet extends HttpServlet {

    private static final String SAVE_DIR =
        "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\lampiranBantuan";

    // ======================= GET =======================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        String action = request.getPathInfo();

        try {
            if (action == null || "/".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
                return;
            }

            // ================== LIST ==================
            if ("/list".equals(action)) {
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> list;

                if ("Penduduk".equals(user.getJawatan())) {
                    list = pbDao.getByPenduduk(user.getIdPengguna());
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/jenisBantuan.jsp")
                           .forward(request, response);
                } else {
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/bantuanKetua.jsp")
                           .forward(request, response);
                }
            }

            // ================== EDIT ==================
            else if ("/edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(id);

                if (pb != null && pb.getIdPenduduk() == user.getIdPengguna()) {
                    request.setAttribute("pb", pb);
                    request.getRequestDispatcher("/views/bantuan/bantuanEdit.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=access");
                }
            }

            // ================== RASMI ==================
            else if ("/rasmi".equals(action)) {

                if (!"Penduduk".equals(user.getJawatan())) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list");
                    return;
                }

                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> list =
                        pbDao.getByPenduduk(user.getIdPengguna());

                request.setAttribute("permohonanList", list);
                request.getRequestDispatcher("/views/bantuan/bantuanRas.jsp")
                       .forward(request, response);
            }
            
            // ================== TAMBAH INI (DELETE) ==================
            else if ("/delete".equals(action)) {
                // Pastikan hanya PENDUDUK boleh delete (Security Check)
                if ("Penduduk".equals(user.getJawatan())) {
                    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                    int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                    
                    // Delete dari database
                    pbDao.deleteByIdAndPenduduk(idPermohonan, user.getIdPengguna());
                    
                    // Redirect balik ke page list dengan mesej berjaya
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=deleted");
                } else {
                    // Kalau bukan penduduk cuba delete, tendang balik
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?error=denied");
                }
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ======================= POST =======================
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        // Security Check
        if (user == null) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        String action = request.getPathInfo();

        // Setup Folder Upload
        File fileSaveDir = new File(SAVE_DIR);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        try {
            PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();

            // ===================== 1. APPLY (PENDUDUK) =====================
            if ("/apply".equals(action) && "Penduduk".equals(user.getJawatan())) {

                // 1. Handle File Upload
                Part filePart = request.getPart("dokumenSokongan");
                String fileName = null;

                if (filePart != null && filePart.getSize() > 0) {
                    String submitted = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submitted;
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                // 2. Ambil Data Form
                String jenisBantuan = request.getParameter("jenisBantuan");
                String jenisBantuanLain = request.getParameter("jenisBantuanLain"); // Input text khas
                String keterangan = request.getParameter("keterangan"); // Textarea biasa

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setIdPenduduk(user.getIdPengguna());
                pb.setDokumen(fileName);

                // --- LOGIC PENENTU ID & CATATAN (UPDATED ID 999) ---
                if ("999".equals(jenisBantuan)) { 
                    pb.setIdBantuan(999); // Set ID 999
                    
                    // Format: "LAIN-LAIN: [Nama Bantuan] | [Keterangan]"
                    // Simbol '|' ini PENTING supaya JSP boleh pisahkan nanti
                    String catatanSimpan = "LAIN-LAIN: " + (jenisBantuanLain != null ? jenisBantuanLain : "Lain-lain");
                    
                    if (keterangan != null && !keterangan.trim().isEmpty()) {
                        catatanSimpan += " | " + keterangan;
                    }
                    
                    pb.setCatatan(catatanSimpan); 
                    
                } else {
                    // Bantuan Biasa (ID 6 - 20)
                    pb.setIdBantuan(Integer.parseInt(jenisBantuan));
                    pb.setCatatan(keterangan); // Simpan keterangan biasa sahaja
                }
                // ----------------------------------------------------

                pbDao.insert(pb);
                response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=success");
            }

            // ===================== 2. APPROVE / REJECT =====================
            else if ("/approve".equals(action) || "/reject".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                int status = "/approve".equals(action) ? 1 : 2;

                pbDao.updateStatus(idPermohonan, status, request.getParameter("catatan"));
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }

            // ===================== 3. UPDATE INFO (KETUA) =====================
            else if ("/update".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String catatan = request.getParameter("catatan");

                Part filePart = request.getPart("dokumenBalik");
                String fileName = null;

                if (filePart != null && filePart.getSize() > 0) {
                    String submitted = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = "BALAS_" + System.currentTimeMillis() + "_" + submitted;
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                pbDao.updateInfo(idPermohonan, catatan, fileName);
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }



            // ===================== 5. UPDATE MY REQUEST (EDIT) =====================
            else if ("/updateMyRequest".equals(action) && "Penduduk".equals(user.getJawatan())) {

                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String oldDokumen = request.getParameter("oldDokumen");

                Part filePart = request.getPart("dokumenSokongan");
                String fileName = oldDokumen;

                if (filePart != null && filePart.getSize() > 0) {
                    String submitted = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submitted;
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                String jenisBantuan = request.getParameter("jenisBantuan");
                String jenisBantuanLain = request.getParameter("jenisBantuanLain");
                String keterangan = request.getParameter("keterangan");

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setIdPermohonan(idPermohonan);
                pb.setDokumen(fileName);

                // --- LOGIC SAMA DI SINI (ID 999) ---
                if ("999".equals(jenisBantuan)) {
                    pb.setIdBantuan(999);
                    
                    String catatanSimpan = "LAIN-LAIN: " + (jenisBantuanLain != null ? jenisBantuanLain : "Lain-lain");
                    if (keterangan != null && !keterangan.trim().isEmpty()) {
                        catatanSimpan += " | " + keterangan;
                    }
                    pb.setCatatan(catatanSimpan);
                    
                } else {
                    pb.setIdBantuan(Integer.parseInt(jenisBantuan));
                    pb.setCatatan(keterangan);
                }
                // -----------------------------------

                pbDao.updateByPenduduk(pb);
                response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=updated");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
