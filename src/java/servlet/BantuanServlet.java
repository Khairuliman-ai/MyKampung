package servlet;

import model.Bantuan;
import model.BantuanDAO;
import model.PermohonanBantuan;
import model.PermohonanBantuanDAO;
import model.Pengguna;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet; // Added this in case you need it, usually mapped in web.xml
import javax.servlet.http.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class BantuanServlet extends HttpServlet {

    // === CONSTANT PATH (So you only change it once!) ===
    // Note: Java needs double backslashes (\\) for Windows paths.
    private static final String SAVE_DIR = "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\lampiranBantuan";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getPathInfo();

        try {
            if (action == null || "/".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
                return;
            }

            // ================== SHOW LIST ==================
            if ("/list".equals(action)) {
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> list;

                if ("Penduduk".equals(user.getJawatan())) {
                    int idPenduduk = user.getIdPengguna(); 
                    list = pbDao.getByPenduduk(idPenduduk);
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/bantuanPenduduk.jsp").forward(request, response);
                } else {
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/bantuanKetua.jsp").forward(request, response);
                }
            }
            
            // ================== SHOW EDIT FORM ==================
            else if ("/edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(id);

                if (pb != null && pb.getIdPenduduk() == user.getIdPengguna()) {
                    request.setAttribute("pb", pb);
                    request.getRequestDispatcher("/bantuanEdit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=access");
                }
            }
            
            
            // ===== STEP 2: PAPAR BANTUAN RASMI (MINIMUM) =====
else if ("/rasmi".equals(action)) {

    if (!"Penduduk".equals(user.getJawatan())) {
        response.sendRedirect(request.getContextPath() + "/bantuan/list");
        return;
    }

    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    List<PermohonanBantuan> list = pbDao.getByPenduduk(user.getIdPengguna());

    request.setAttribute("permohonanList", list);

    // 👉 GUNA JSP AWAK TERUS (JANGAN DUPLICATE)
    request.getRequestDispatcher("/bantuanPenduduk.jsp")
           .forward(request, response);
}


        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getPathInfo();

        // Ensure the directory exists
        File fileSaveDir = new File(SAVE_DIR);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        try {
            PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();

            // ===================== 1. APPLY (PENDUDUK) =====================
            if ("/apply".equals(action) && "Penduduk".equals(user.getJawatan())) {
                Part filePart = request.getPart("dokumenSokongan");
                
                String fileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    
                    // SAVE TO ONEDRIVE PATH
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setIdPenduduk(user.getIdPengguna());
                pb.setIdBantuan(Integer.parseInt(request.getParameter("jenisBantuan"))); 
                pb.setCatatan(request.getParameter("keterangan"));
                pb.setDokumen(fileName);

                pbDao.insert(pb);
                response.sendRedirect(request.getContextPath() + "/bantuan/list");

            // ===================== 2. APPROVE / REJECT (KETUA KAMPUNG) =====================
            } else if ("/approve".equals(action) || "/reject".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                int newStatus = "/approve".equals(action) ? 1 : 2;
                
                pbDao.updateStatus(idPermohonan, newStatus, request.getParameter("catatan"));
                response.sendRedirect(request.getContextPath() + "/bantuan/list");

            // ===================== 3. UPDATE INFO / REPLY DOC (KETUA KAMPUNG) =====================
            } else if ("/update".equals(action)) {
                
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String catatan = request.getParameter("catatan");
                
                Part filePart = request.getPart("dokumenBalik");
                String fileName = null;
                
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = "BALAS_" + System.currentTimeMillis() + "_" + submittedFileName;
                    
                    // SAVE TO ONEDRIVE PATH
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                pbDao.updateInfo(idPermohonan, catatan, fileName);
                response.sendRedirect(request.getContextPath() + "/bantuan/list");

            // ===================== 4. DELETE (PENDUDUK) =====================
            } else if ("/delete".equals(action) && "Penduduk".equals(user.getJawatan())) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                pbDao.deleteByIdAndPenduduk(idPermohonan, user.getIdPengguna());
                response.sendRedirect(request.getContextPath() + "/bantuan/list");

            // ===================== 5. EDIT REQUEST (PENDUDUK) =====================
            } else if ("/updateMyRequest".equals(action) && "Penduduk".equals(user.getJawatan())) {
                
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String oldDokumen = request.getParameter("oldDokumen");
                
                Part filePart = request.getPart("dokumenSokongan");
                String fileName = oldDokumen; // Default to old file if no new upload

                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    
                    // SAVE TO ONEDRIVE PATH
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setIdPermohonan(idPermohonan);
                pb.setIdBantuan(Integer.parseInt(request.getParameter("jenisBantuan")));
                pb.setCatatan(request.getParameter("keterangan"));
                pb.setDokumen(fileName);

                pbDao.updateByPenduduk(pb);
                
                response.sendRedirect(request.getContextPath() + "/bantuan/list?status=updated");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}