package servlet;

import model.Bantuan;
import model.BantuanDAO;
import model.PermohonanBantuan;
import model.PermohonanBantuanDAO;
import model.Pengguna;
// import util.DBUtil; // Tidak digunakan secara direct di sini, tapi okay jika ada

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class BantuanServlet extends HttpServlet {

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
            // Jika akses root /bantuan, kita redirect terus ke list
            if (action == null || "/".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
                return;
            }

            // ================== UBAH DI SINI (ROUTING JSP) ==================
            if ("/list".equals(action)) {
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> list;

                if ("Penduduk".equals(user.getJawatan())) {
                    // 1. Penduduk: Tengok list sendiri
                    int idPenduduk = user.getIdPengguna(); 
                    list = pbDao.getByPenduduk(idPenduduk);
                    request.setAttribute("permohonanList", list);
                    
                    // Hantar ke JSP Penduduk yang baru
                    request.getRequestDispatcher("/bantuanPenduduk.jsp").forward(request, response);
                
                } else {
                    // 2. Ketua Kampung: Tengok semua list
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);
                    
                    // Hantar ke JSP Ketua Kampung yang baru
                    request.getRequestDispatcher("/bantuanKetua.jsp").forward(request, response);
                }
            }
            // ================================================================

            // ... inside doGet method ...
// Add this AFTER if ("/list".equals(action)) block

// ================== NEW: SHOW EDIT FORM ==================
if ("/edit".equals(action)) {
    int id = Integer.parseInt(request.getParameter("id"));
    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    PermohonanBantuan pb = pbDao.getById(id);

    // Security check: Ensure user owns this record (optional but recommended)
    if (pb != null && pb.getIdPenduduk() == user.getIdPengguna()) {
        request.setAttribute("pb", pb);
        request.getRequestDispatcher("/bantuanEdit.jsp").forward(request, response);
    } else {
        response.sendRedirect(request.getContextPath() + "/bantuan/list?error=access");
    }
    return; // Important to return here
}
// =========================================================
            
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

        try {
            PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();

            // ===================== 1. APPLY (PENDUDUK) =====================
            if ("/apply".equals(action) && "Penduduk".equals(user.getJawatan())) {
                Part filePart = request.getPart("dokumenSokongan"); // Pastikan nama input di form ialah 'dokumenSokongan'
                
                String fileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submittedFileName;
                    
                    String uploadPath = getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + fileName);
                }

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setIdPenduduk(user.getIdPengguna());
                // Pastikan input name="jenisBantuan" di form menghantar ID Bantuan (contoh: 1, 2, 3)
                // Jika value="B01", anda kena convert string 'B01' ke int ID atau ubah database structure.
                // Di sini saya anggap user hantar int ID.
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

            // ===================== 3. UPDATE / UPLOAD DOKUMEN BALAS (KETUA KAMPUNG) =====================
            } else if ("/update".equals(action)) {
                
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String catatan = request.getParameter("catatan");
                
                // Proses upload 'dokumenBalik'
                Part filePart = request.getPart("dokumenBalik");
                String fileName = null;
                
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = "BALAS_" + System.currentTimeMillis() + "_" + submittedFileName;
                    
                    String uploadPath = getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    filePart.write(uploadPath + File.separator + fileName);
                }

                // Panggil method update tambahan di DAO (Anda perlu buat method ini di DAO jika belum ada)
                // updateInfo(int id, String catatan, String dokumenBalik)
                pbDao.updateInfo(idPermohonan, catatan, fileName);
                
                response.sendRedirect(request.getContextPath() + "/bantuan/list");

            // ===================== 4. DELETE (PENDUDUK) =====================
            } else if ("/delete".equals(action) && "Penduduk".equals(user.getJawatan())) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                pbDao.deleteByIdAndPenduduk(idPermohonan, user.getIdPengguna());
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }
            
            // ... inside doPost method ...

// ================== NEW: PROCESS UPDATE (PENDUDUK) ==================
if ("/updateMyRequest".equals(action) && "Penduduk".equals(user.getJawatan())) {
    
    int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
    String oldDokumen = request.getParameter("oldDokumen"); // Hidden field in JSP
    
    // 1. Handle File Upload (Similar to /apply)
    Part filePart = request.getPart("dokumenSokongan");
    String fileName = oldDokumen; // Default to old file

    if (filePart != null && filePart.getSize() > 0) {
        String submittedFileName = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
        fileName = System.currentTimeMillis() + "_" + submittedFileName;
        
        String uploadPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(uploadPath + File.separator + fileName);
    }

    // 2. Setup Object
    PermohonanBantuan pb = new PermohonanBantuan();
    pb.setIdPermohonan(idPermohonan);
    pb.setIdBantuan(Integer.parseInt(request.getParameter("jenisBantuan")));
    pb.setCatatan(request.getParameter("keterangan"));
    pb.setDokumen(fileName); // New file or Old file

    // 3. Update DB
    pbDao.updateByPenduduk(pb);
    
    response.sendRedirect(request.getContextPath() + "/bantuan/list?status=updated");
}
// ====================================================================

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}