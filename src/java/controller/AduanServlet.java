package controller;

import dao.AduanDAO;
import dao.KategoriAduanDAO;
import dao.LogAduanDAO;
import dao.PenggunaDAO;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
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
import util.AppConfig;
import util.FileUploadUtil;
import util.DBUtil;



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
                    // Filter by Biro Keselamatan if needed, but normally AJK sees assigned ones
                    list = aduanDAO.getByPengendali(user.getId_pengguna());
                    request.setAttribute("aduanList", list);
                    request.getRequestDispatcher("/views/aduan/urusAduanAJK.jsp").forward(request, response);
                } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
                    list = aduanDAO.getAll();
                    request.setAttribute("aduanList", list);
                    request.getRequestDispatcher("/views/aduan/urusAduanKetua.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                }
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
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM, hh:mm a");
                for (int i = 0; i < logList.size(); i++) {
                    model.LogAduan l = logList.get(i);
                    json.append("{")
                        .append("\"id\":").append(l.getId_log_aduan()).append(",")
                        .append("\"status_baru\":\"").append(l.getStatus_baru()).append("\",")
                        .append("\"catatan\":\"").append(l.getCatatan() != null ? l.getCatatan().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "").append("\",")
                        .append("\"nama_pelaku\":\"").append(l.getNama_pelaku()).append("\",")
                        .append("\"tarikh\":\"").append(sdf.format(l.getDibuat_pada())).append("\"")
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
                aduan.setTajuk(tajuk);
                aduan.setKeterangan(keterangan);
                aduan.setKeutamaan(keutamaan);
                aduan.setGambar_aduan(fileName);

                // Rule 1: Auto-assign to Biro Keselamatan (id_jawatan = 6)
                Integer ajkId = aduanDAO.getAJKIdByJawatan(6);
                aduan.setId_pengendali(ajkId);

                if (aduanDAO.insertAduan(aduan)) {
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
                String currentStatus = request.getParameter("current_status");
                String nextStatus = request.getParameter("next_status");
                String catatan = request.getParameter("catatan");
                String role = user.getNama_peranan();

                // Determine which catatan field to update based on status/role
                String catatanField = "catatan_ajk";
                if ("Ketua Kampung".equals(role))
                    catatanField = "catatan_ketua";

                if (aduanDAO.updateStatus(idAduan, nextStatus, catatanField, catatan)) {
                    LogAduan log = new LogAduan();
                    log.setId_aduan(idAduan);
                    log.setId_pelaku(user.getId_pengguna());
                    log.setStatus_lama(currentStatus);
                    log.setStatus_baru(nextStatus);
                    log.setCatatan(catatan);
                    logDAO.insertLog(log);

                    response.sendRedirect(request.getContextPath() + "/aduan/list?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/aduan/list?error=db");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
