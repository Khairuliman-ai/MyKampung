package controller;

import dao.HebahanDAO;
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
import util.InputSanitizer;



@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 10 * 1024 * 1024,      // 10MB
    maxRequestSize = 20 * 1024 * 1024    // 20MB
)
/**
 * HebahanServlet handles community announcements (hebahan).
 * It enables the Biro Hebahan staff to draft, upload banner images for, and publish announcements,
 * and allows residents to search and view published announcements.
 * 
 * <p><strong>Broadcast Notification Trigger:</strong>
 * When an announcement status is transitioned to "Published", it automatically
 * triggers a system-wide broadcast notification to all active residents.</p>
 * 
 * <h3>GET Routes (PathInfo):</h3>
 * <ul>
 *   <li>/list (or default) - Catalog listing. Residents see published only; Biro Hebahan sees all drafts and published.</li>
 *   <li>/detail - Detailed announcement view.</li>
 *   <li>/tambah - Renders form to create a new announcement (Biro Hebahan only).</li>
 *   <li>/kemaskini - Renders edit form for a draft/announcement (Biro Hebahan only).</li>
 * </ul>
 * 
 * <h3>POST Routes:</h3>
 * <ul>
 *   <li>/insert - Saves a new announcement draft or published state (Biro Hebahan only).</li>
 *   <li>/update - Saves edits to an announcement (Biro Hebahan only).</li>
 *   <li>/delete - Deletes an announcement (Biro Hebahan only).</li>
 * </ul>
 */
public class HebahanServlet extends HttpServlet {

    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(HebahanServlet.class.getName());
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
            int page = 1;
            String pageParam = req.getParameter("page");
            if (pageParam != null && pageParam.matches("\\d+")) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
            int pageSize = 10;

            if (path == null || "/".equals(path) || "/list".equals(path)) {
                String sort = req.getParameter("sort");
                if (sort == null || sort.isEmpty()) sort = "DESC";
                
                if ("Penduduk".equalsIgnoreCase(role)) {
                    String keyword = req.getParameter("q");
                    String kategori = req.getParameter("kategori");
                    List<Hebahan> list;
                    int totalItems = 0;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = dao.searchPublished(keyword.trim(), sort, page, pageSize);
                        totalItems = dao.countSearchPublished(keyword.trim());
                    } else if (kategori != null && !kategori.trim().isEmpty()) {
                        list = dao.getPublishedByKategori(kategori.trim(), sort, page, pageSize);
                        totalItems = dao.countPublishedByKategori(kategori.trim());
                    } else {
                        list = dao.getPublished(sort, page, pageSize);
                        totalItems = dao.countPublished();
                    }
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                    if (totalPages < 1) totalPages = 1;

                    req.setAttribute("hebahanList", list);
                    req.setAttribute("currentPage", page);
                    req.setAttribute("totalPages", totalPages);
                    req.setAttribute("totalItems", totalItems);
                    req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
                } else if ("AJK Kampung".equalsIgnoreCase(role) && "Biro Hebahan".equals(biro)) {
                    List<Hebahan> list = dao.getAll(sort, page, pageSize);
                    int totalItems = dao.countAll();
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                    if (totalPages < 1) totalPages = 1;

                    req.setAttribute("hebahanList", list);
                    req.setAttribute("currentPage", page);
                    req.setAttribute("totalPages", totalPages);
                    req.setAttribute("totalItems", totalItems);
                    req.getRequestDispatcher("/views/hebahan/urusHebahanAJK.jsp").forward(req, resp);
                } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
                    List<Hebahan> list = dao.getAll(sort, page, pageSize);
                    int totalItems = dao.countAll();
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                    if (totalPages < 1) totalPages = 1;

                    req.setAttribute("hebahanList", list);
                    req.setAttribute("currentPage", page);
                    req.setAttribute("totalPages", totalPages);
                    req.setAttribute("totalItems", totalItems);
                    req.setAttribute("totalPublished", dao.countByStatus("Published"));
                    req.setAttribute("totalDraft", dao.countByStatus("Draft"));
                    req.setAttribute("totalArchived", dao.countByStatus("Archived"));
                    req.getRequestDispatcher("/views/hebahan/urusHebahanKetua.jsp").forward(req, resp);
                } else {
                    List<Hebahan> list = dao.getPublished(sort, page, pageSize);
                    int totalItems = dao.countPublished();
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                    if (totalPages < 1) totalPages = 1;

                    req.setAttribute("hebahanList", list);
                    req.setAttribute("currentPage", page);
                    req.setAttribute("totalPages", totalPages);
                    req.setAttribute("totalItems", totalItems);
                    req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
                }
            } else if ("/penduduk".equals(path)) {
                String sort = req.getParameter("sort");
                if (sort == null || sort.isEmpty()) sort = "DESC";
                String keyword = req.getParameter("q");
                String kategori = req.getParameter("kategori");
                List<Hebahan> list;
                int totalItems = 0;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    list = dao.searchPublished(keyword.trim(), sort, page, pageSize);
                    totalItems = dao.countSearchPublished(keyword.trim());
                } else if (kategori != null && !kategori.trim().isEmpty()) {
                    list = dao.getPublishedByKategori(kategori.trim(), sort, page, pageSize);
                    totalItems = dao.countPublishedByKategori(kategori.trim());
                } else {
                    list = dao.getPublished(sort, page, pageSize);
                    totalItems = dao.countPublished();
                }
                int totalPages = (int) Math.ceil((double) totalItems / pageSize);
                if (totalPages < 1) totalPages = 1;

                req.setAttribute("hebahanList", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalItems", totalItems);
                req.getRequestDispatcher("/views/hebahan/hebahanPenduduk.jsp").forward(req, resp);
            } else if ("/detail".equals(path)) {
                String idParam = req.getParameter("id");
                if (idParam == null || !idParam.matches("\\d+")) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak sah");
                    return;
                }
                int id = Integer.parseInt(idParam);
                Hebahan h = dao.getById(id);
                req.setAttribute("hebahan", h);
                req.getRequestDispatcher("/views/hebahan/detailHebahan.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Ralat dalam doGet hebahan", e);
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

        // Force parsing of multipart requests in Tomcat to populate parameter map
        String contentType = req.getContentType();
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/form-data")) {
            try {
                req.getParts();
            } catch (Exception e) {
                // Catch FileSizeLimitExceededException or generic file size issues
                Throwable t = e;
                while (t != null) {
                    if (t.getClass().getName().contains("SizeLimitExceededException")) {
                        resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=file_too_large");
                        return;
                    }
                    t = t.getCause();
                }
                throw new ServletException("Gagal menganalisis fail lampiran", e);
            }
        }

        String path = req.getPathInfo();
        HebahanDAO dao = new HebahanDAO();

        String role = user.getNama_peranan();
        String biro = user.getNama_jawatan();
        boolean isBiroHebahan = "AJK Kampung".equalsIgnoreCase(role) && "Biro Hebahan".equals(biro);
        boolean isKetua = "Ketua Kampung".equalsIgnoreCase(role);

        if ("/create".equals(path) || "/update".equals(path) || "/updateStatus".equals(path)) {
            if (!isBiroHebahan) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses ditolak: Biro Hebahan sahaja");
                return;
            }
        }
        if ("/delete".equals(path)) {
            if (!isBiroHebahan && !isKetua) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses ditolak: Biro Hebahan atau Ketua Kampung sahaja");
                return;
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        try {

            if ("/create".equals(path)) {
                Hebahan h = new Hebahan();
                h.setId_pengguna(user.getId_pengguna());
                h.setTajuk(InputSanitizer.sanitize(req.getParameter("tajuk")));
                h.setKandungan(InputSanitizer.sanitize(req.getParameter("kandungan")));
                h.setKategori(req.getParameter("kategori"));
                h.setStatus_hebahan(req.getParameter("status_hebahan"));
                h.setLokasi_acara(InputSanitizer.sanitize(req.getParameter("lokasi_acara")));

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
                        LOGGER.log(java.util.logging.Level.SEVERE, "Ralat mendapatkan ID hebahan terkini", ex);
                    }
                    
                    String pautan = latestId > 0 ? "/hebahan/detail?id=" + latestId : "/hebahan/list";
                    String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                        ? h.getKandungan().substring(0, 100) + "..." 
                        : h.getKandungan();
                    
                    service.NotificationService.broadcast(user.getId_pengguna(), "HEBAHAN", "Hebahan Baru: " + h.getTajuk(), ringkasan, pautan);
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=created");

            } else if ("/update".equals(path)) {
                String idParam = req.getParameter("id_hebahan");
                if (idParam == null || !idParam.matches("\\d+")) {
                    resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=invalid_id");
                    return;
                }
                int id = Integer.parseInt(idParam);
                Hebahan h = dao.getById(id);
                if (h == null) {
                    resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=not_found");
                    return;
                }
                String oldStatus = h.getStatus_hebahan();

                h.setTajuk(InputSanitizer.sanitize(req.getParameter("tajuk")));
                h.setKandungan(InputSanitizer.sanitize(req.getParameter("kandungan")));
                h.setKategori(req.getParameter("kategori"));
                h.setStatus_hebahan(req.getParameter("status_hebahan"));
                h.setLokasi_acara(InputSanitizer.sanitize(req.getParameter("lokasi_acara")));

                String mula = req.getParameter("tarikh_mula_acara");
                String tamat = req.getParameter("tarikh_tamat_acara");
                String tamatHebahan = req.getParameter("tarikh_tamat");
                if (mula != null && !mula.isEmpty()) h.setTarikh_mula_acara(sdf.parse(mula));
                else h.setTarikh_mula_acara(null);
                if (tamat != null && !tamat.isEmpty()) h.setTarikh_tamat_acara(sdf.parse(tamat));
                else h.setTarikh_tamat_acara(null);
                if (tamatHebahan != null && !tamatHebahan.isEmpty()) h.setTarikh_tamat(sdf.parse(tamatHebahan));
                else h.setTarikh_tamat(null);

                String fileName = FileUploadUtil.saveFile(
                    req.getPart("gambar_poster"), SAVE_DIR, "hebahan_" + user.getId_pengguna() + "_");
                if (fileName != null) h.setGambar_poster(fileName);

                dao.updateHebahan(h);

                // Trigger batch notification if status transitions to Published
                if ("Published".equalsIgnoreCase(h.getStatus_hebahan()) && !"Published".equalsIgnoreCase(oldStatus)) {
                    String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                        ? h.getKandungan().substring(0, 100) + "..." 
                        : h.getKandungan();

                    service.NotificationService.broadcast(user.getId_pengguna(), "HEBAHAN", "Hebahan Baru: " + h.getTajuk(), ringkasan, "/hebahan/detail?id=" + h.getId_hebahan());
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=updated");

            } else if ("/delete".equals(path)) {
                String idParam = req.getParameter("id_hebahan");
                if (idParam == null || !idParam.matches("\\d+")) {
                    resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=invalid_id");
                    return;
                }
                int id = Integer.parseInt(idParam);
                dao.softDelete(id);
                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=deleted");

            } else if ("/updateStatus".equals(path)) {
                String idParam = req.getParameter("id_hebahan");
                if (idParam == null || !idParam.matches("\\d+")) {
                    resp.sendRedirect(req.getContextPath() + "/hebahan/list?error=invalid_id");
                    return;
                }
                int id = Integer.parseInt(idParam);
                String status = req.getParameter("status_hebahan");
                dao.updateStatus(id, status);

                // Trigger batch notification if status updated to Published
                if ("Published".equalsIgnoreCase(status)) {
                    Hebahan h = dao.getById(id);
                    if (h != null) {
                        String ringkasan = h.getKandungan() != null && h.getKandungan().length() > 100 
                            ? h.getKandungan().substring(0, 100) + "..." 
                            : h.getKandungan();

                        service.NotificationService.broadcast(user.getId_pengguna(), "HEBAHAN", "Hebahan Baru: " + h.getTajuk(), ringkasan, "/hebahan/detail?id=" + h.getId_hebahan());
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/hebahan/list?msg=statusUpdated");
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Ralat dalam doPost hebahan", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
