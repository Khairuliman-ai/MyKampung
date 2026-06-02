package controller;

import dao.HebahanDAO;
import dao.PenggunaDAO;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import model.Hebahan;
import model.Pengguna;
import util.AppConfig;
import util.FileUploadUtil;



@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 5 * 1024 * 1024,       // 5MB
    maxRequestSize = 10 * 1024 * 1024    // 10MB
)
public class HebahanServlet extends HttpServlet {

    private static final String SAVE_DIR = AppConfig.DIR_GAMBAR_HEBAHAN;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        String path = req.getPathInfo();
        HebahanDAO dao = new HebahanDAO();
        String role = user.getNama_peranan();
        String biro = user.getNama_jawatan();

        try {
            if (path == null || "/".equals(path) || "/list".equals(path)) {
                String sort = req.getParameter("sort");
                if (sort == null || sort.isEmpty()) sort = "DESC";
                
                if ("Penduduk".equalsIgnoreCase(role)) {
                    String keyword = req.getParameter("q");
                    List<Hebahan> list;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = dao.searchPublished(keyword.trim(), sort);
                    } else {
                        list = dao.getPublished(sort);
                    }
                    req.setAttribute("hebahanList", list);
                    req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
                } else if ("AJK Kampung".equalsIgnoreCase(role) && "Biro Hebahan".equals(biro)) {
                    List<Hebahan> list = dao.getAll(sort);
                    req.setAttribute("hebahanList", list);
                    req.getRequestDispatcher("/views/hebahan/urusHebahanAJK.jsp").forward(req, resp);
                } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
                    List<Hebahan> list = dao.getAll(sort);
                    req.setAttribute("hebahanList", list);
                    req.getRequestDispatcher("/views/hebahan/urusHebahanAJK.jsp").forward(req, resp);
                } else {
                    List<Hebahan> list = dao.getPublished(sort);
                    req.setAttribute("hebahanList", list);
                    req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
                }
            } else if ("/penduduk".equals(path)) {
                String sort = req.getParameter("sort");
                if (sort == null || sort.isEmpty()) sort = "DESC";
                String keyword = req.getParameter("q");
                List<Hebahan> list;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    list = dao.searchPublished(keyword.trim(), sort);
                } else {
                    list = dao.getPublished(sort);
                }
                req.setAttribute("hebahanList", list);
                req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
            } else if ("/detail".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Hebahan h = dao.getById(id);
                req.setAttribute("hebahan", h);
                req.getRequestDispatcher("/views/hebahan/detailHebahan.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        String path = req.getPathInfo();
        HebahanDAO dao = new HebahanDAO();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        try {

            if ("/create".equals(path)) {
                Hebahan h = new Hebahan();
                h.setId_pengguna(user.getId_pengguna());
                h.setTajuk(req.getParameter("tajuk"));
                h.setKandungan(req.getParameter("kandungan"));
                h.setKategori(req.getParameter("kategori"));
                h.setStatus_hebahan(req.getParameter("status_hebahan"));
                h.setLokasi_acara(req.getParameter("lokasi_acara"));

                String mula = req.getParameter("tarikh_mula_acara");
                String tamat = req.getParameter("tarikh_tamat_acara");
                String tamatHebahan = req.getParameter("tarikh_tamat");
                if (mula != null && !mula.isEmpty()) h.setTarikh_mula_acara(sdf.parse(mula));
                if (tamat != null && !tamat.isEmpty()) h.setTarikh_tamat_acara(sdf.parse(tamat));
                if (tamatHebahan != null && !tamatHebahan.isEmpty()) h.setTarikh_tamat(sdf.parse(tamatHebahan));

                String fileName = FileUploadUtil.saveFile(
                    req.getPart("gambar_poster"), SAVE_DIR, "hebahan_" + user.getId_pengguna() + "_");
                if (fileName != null) h.setGambar_poster(fileName);


                dao.insertHebahan(h);

                // Trigger batch notification if status is Published
                if ("Published".equalsIgnoreCase(h.getStatus_hebahan())) {
                    try {
                        dao.NotificationsDAO notifDao = new dao.NotificationsDAO();
                        PenggunaDAO pDao = new PenggunaDAO(null);
                        List<Integer> semuaIds = pDao.getAllActiveIds();
                        // Exclude creator
                        semuaIds.removeIf(uid -> uid == user.getId_pengguna());
                        
                        // Get latest hebahan ID for link
                        int latestId = 0;
                        try (java.sql.Connection conn = util.DBUtil.getConnection();
                             java.sql.PreparedStatement ps = conn.prepareStatement("SELECT MAX(id_hebahan) FROM hebahan WHERE id_pengguna = ?")) {
                            ps.setInt(1, user.getId_pengguna());
                            try (java.sql.ResultSet rs = ps.executeQuery()) {
                                if (rs.next()) {
                                    latestId = rs.getInt(1);
                                }
                            }
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                        
                        String pautan = latestId > 0 ? "/hebahan/detail?id=" + latestId : "/hebahan/list";
                        String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                            ? h.getKandungan().substring(0, 100) + "..." 
                            : h.getKandungan();
                        
                        notifDao.insertBatch(
                            semuaIds,
                            "HEBAHAN",
                            "Hebahan Baru: " + h.getTajuk(),
                            ringkasan,
                            pautan
                        );
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=created");

            } else if ("/update".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id_hebahan"));
                Hebahan h = dao.getById(id);
                if (h == null) {
                    resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=not_found");
                    return;
                }
                String oldStatus = h.getStatus_hebahan();

                h.setTajuk(req.getParameter("tajuk"));
                h.setKandungan(req.getParameter("kandungan"));
                h.setKategori(req.getParameter("kategori"));
                h.setStatus_hebahan(req.getParameter("status_hebahan"));
                h.setLokasi_acara(req.getParameter("lokasi_acara"));

                String mula = req.getParameter("tarikh_mula_acara");
                String tamat = req.getParameter("tarikh_tamat_acara");
                if (mula != null && !mula.isEmpty()) h.setTarikh_mula_acara(sdf.parse(mula));
                if (tamat != null && !tamat.isEmpty()) h.setTarikh_tamat_acara(sdf.parse(tamat));

                String fileName = FileUploadUtil.saveFile(
                    req.getPart("gambar_poster"), SAVE_DIR, "hebahan_" + user.getId_pengguna() + "_");
                if (fileName != null) h.setGambar_poster(fileName);

                dao.updateHebahan(h);

                // Trigger batch notification if status transitions to Published
                if ("Published".equalsIgnoreCase(h.getStatus_hebahan()) && !"Published".equalsIgnoreCase(oldStatus)) {
                    try {
                        dao.NotificationsDAO notifDao = new dao.NotificationsDAO();
                        PenggunaDAO pDao = new PenggunaDAO(null);
                        List<Integer> semuaIds = pDao.getAllActiveIds();
                        // Exclude creator
                        semuaIds.removeIf(uid -> uid == user.getId_pengguna());
                        
                        String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                            ? h.getKandungan().substring(0, 100) + "..." 
                            : h.getKandungan();

                        notifDao.insertBatch(
                            semuaIds,
                            "HEBAHAN",
                            "Hebahan Baru: " + h.getTajuk(),
                            ringkasan,
                            "/hebahan/detail?id=" + h.getId_hebahan()
                        );
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=updated");

            } else if ("/delete".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id_hebahan"));
                dao.softDelete(id);
                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=deleted");

            } else if ("/updateStatus".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id_hebahan"));
                String status = req.getParameter("status_hebahan");
                dao.updateStatus(id, status);

                // Trigger batch notification if status updated to Published
                if ("Published".equalsIgnoreCase(status)) {
                    try {
                        Hebahan h = dao.getById(id);
                        if (h != null) {
                            dao.NotificationsDAO notifDao = new dao.NotificationsDAO();
                            PenggunaDAO pDao = new PenggunaDAO(null);
                            List<Integer> semuaIds = pDao.getAllActiveIds();
                            // Exclude creator
                            semuaIds.removeIf(uid -> uid == user.getId_pengguna());
                            
                            String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                                ? h.getKandungan().substring(0, 100) + "..." 
                                : h.getKandungan();

                            notifDao.insertBatch(
                                semuaIds,
                                "HEBAHAN",
                                "Hebahan Baru: " + h.getTajuk(),
                                ringkasan,
                                "/hebahan/detail?id=" + h.getId_hebahan()
                            );
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=statusUpdated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
