package controller;

import model.Bantuan;
import dao.BantuanDAO;

import model.PermohonanBantuan;
import dao.PermohonanBantuanDAO;
import model.Pengguna;
import model.BantuanLampiran;
import dao.BantuanLampiranDAO;
import util.AppConfig;
import util.InputSanitizer;


import java.util.Collection;
import javax.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;


@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
/**
 * BantuanServlet — Handles all welfare aid (Bantuan) operations.
 * Documents the 3-stage review process (Penduduk → AJK Kebajikan → Ketua).
 *
 * <h3>GET Routes:</h3>
 * <ul>
 *   <li>/list — Role-based application listing (Penduduk, AJK, Ketua)</li>
 *   <li>/mohon — Application form view</li>
 *   <li>/edit — Edit existing application</li>
 *   <li>/rasmi, /komuniti — Category-filtered views</li>
 *   <li>/config — Eligibility rule configuration (staff only)</li>
 * </ul>
 *
 * <h3>POST Routes:</h3>
 * <ul>
 *   <li>/apply — Submit new application</li>
 *   <li>/reviewAJK — AJK document review</li>
 *   <li>/keputusanKetua — Ketua approval/rejection</li>
 *   <li>/config/save — Save eligibility rules</li>
 * </ul>
 */
public class BantuanServlet extends HttpServlet {

    private static final String SAVE_DIR
            = AppConfig.DIR_LAMPIRAN_BANTUAN;



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        String action = request.getPathInfo();

        try {
            // --- Route: / (Default redirect to /list) ---
            if (action == null || "/".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
                return;
            }


            // --- Route: /list — Role-based application listing ---
            if ("/list".equals(action)) {
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> list;

                if ("Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
                    list = pbDao.getByPenduduk(user.getId_pengguna());
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/jenisBantuan.jsp")
                            .forward(request, response);

                } else if ("AJK".equalsIgnoreCase(user.getNama_peranan()) || "AJK Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    int page = 1;
                    int pageSize = 10;
                    try {
                        if (request.getParameter("page") != null) {
                            page = Integer.parseInt(request.getParameter("page"));
                        }
                    } catch (NumberFormatException e) { page = 1; }

                    int offset = (page - 1) * pageSize;
                    
                    // Ambil list baru (penuh) & sejarah (paginated)
                    List<PermohonanBantuan> listBaru = pbDao.getByStatus("BARU");
                    List<PermohonanBantuan> listSejarah = pbDao.getSejarahPaginated(offset, pageSize);



                    int totalSejarahCount = pbDao.getSejarahCount();
                    int totalPagesSejarah = (int) Math.ceil((double) totalSejarahCount / pageSize);

                    BantuanDAO bDao = new BantuanDAO();
                    List<Bantuan> senaraiBantuan = bDao.getAllBantuan();
                    
                    service.EligibilityService es = new service.EligibilityService();
                    request.setAttribute("rules", es.getRulesList());
                    request.setAttribute("povertyLine", es.getPovertyLine());

                    request.setAttribute("listBaru", listBaru);
                    request.setAttribute("listSejarah", listSejarah);
                    request.setAttribute("senaraiBantuan", senaraiBantuan);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPagesSejarah);
                    request.setAttribute("totalCount", totalSejarahCount);
                    
                    request.getRequestDispatcher("/views/bantuan/urusBantuanAJK.jsp").forward(request, response);

                } else if ("Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    list = pbDao.getAll();

                    service.EligibilityService es = new service.EligibilityService();
                    request.setAttribute("rules", es.getRulesList());
                    request.setAttribute("povertyLine", es.getPovertyLine());

                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanKetua.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=invalid_role");
                }
            }
            // --- Route: /mohon — Application form view ---
            else if ("/mohon".equals(action)) {
                if (isPendudukOrStaff(user)) {
                    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                    List<PermohonanBantuan> list = pbDao.getByPenduduk(user.getId_pengguna());
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/jenisBantuan.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=invalid_role");
                }
            }
            // --- Route: /edit — Edit existing application ---
            else if ("/edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(id);

                if (pb != null && pb.getId_pengguna() == user.getId_pengguna()) {
                    BantuanDAO bDao = new BantuanDAO();
                    List<Bantuan> senaraiBantuan = bDao.getAllBantuan();
                    request.setAttribute("pb", pb);
                    request.setAttribute("senaraiJenisBantuan", senaraiBantuan);
                    request.getRequestDispatcher("/views/bantuan/bantuanEdit.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=access");
                }
            }
            // --- Route: /rasmi — Category-filtered (Rasmi) views ---
            else if ("/rasmi".equals(action)) {
                if (!isPendudukOrStaff(user)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }

                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                BantuanDAO bantuanDao = new BantuanDAO();
                List<PermohonanBantuan> listRasmi = pbDao.getByPendudukAndKategori(user.getId_pengguna(), "RASMI");
                List<Bantuan> senaraiRasmiDB = bantuanDao.getBantuanByKategori("RASMI");


                request.setAttribute("permohonanList", listRasmi);
                request.setAttribute("senaraiJenisBantuan", senaraiRasmiDB); 
                request.getRequestDispatcher("/views/bantuan/bantuanRas.jsp")
                        .forward(request, response);
             // --- Route: /komuniti — Category-filtered (Komuniti) views ---
            } else if ("/komuniti".equals(action)) {
                if (!isPendudukOrStaff(user)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }

                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                BantuanDAO bantuanDao = new BantuanDAO();
                List<PermohonanBantuan> listKomuniti = pbDao.getByPendudukAndKategori(user.getId_pengguna(), "KOMUNITI");
                List<Bantuan> senaraiKomunitiDB = bantuanDao.getBantuanByKategori("KOMUNITI");


                request.setAttribute("permohonanList", listKomuniti);       
                request.setAttribute("senaraiJenisBantuan", senaraiKomunitiDB); 
                request.setAttribute("currentUser", user);
                
                request.getRequestDispatcher("/views/bantuan/bantuanKom.jsp").forward(request, response);
             // --- Route: /delete — Delete application ---
            } else if ("/delete".equals(action)) {
                if (isPendudukOrStaff(user)) {
                    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                    int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));

                    PermohonanBantuan pb = pbDao.getById(idPermohonan);
                    
                    String redirectPage = "/bantuan/rasmi"; 

                    if (pb != null) {
                        if (pb.getId_bantuan() == 999) {
                            redirectPage = "/bantuan/komuniti";
                        } else {
                            BantuanDAO bDao = new BantuanDAO();
                            Bantuan bDetails = bDao.getBantuanById(pb.getId_bantuan());
                            if (bDetails != null && !"RASMI".equalsIgnoreCase(bDetails.getJenis_bantuan())) {
                                redirectPage = "/bantuan/komuniti";
                            }
                        }
                        pbDao.deleteByIdAndPenduduk(idPermohonan, user.getId_pengguna());
                    }

                    response.sendRedirect(request.getContextPath() + redirectPage + "?status=deleted");
                    
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?error=denied");
                }
             // --- Route: /deleteAttachment — Delete attachment ---
            } else if ("/deleteAttachment".equals(action) && isPendudukOrStaff(user)) {
                int idLampiran = Integer.parseInt(request.getParameter("idLampiran"));
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                
                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(idPermohonan);
                
                if (pb != null && pb.getId_pengguna() == user.getId_pengguna()) {
                    lampiranDao.deleteById(idLampiran);
                }
                
                response.sendRedirect(request.getContextPath() + "/bantuan/edit?id=" + idPermohonan + "&status=doc_deleted");
            } else if ("/config".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath());
            return;
        }

        String action = request.getPathInfo();

        File fileSaveDir = new File(SAVE_DIR);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        try {
            PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();


            // --- Route: /apply — Submit new application ---
            if ("/apply".equals(action) && isPendudukOrStaff(user)) {

                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                Collection<Part> parts = request.getParts();
                List<String> savedFiles = new ArrayList<>();

                for (Part part : parts) {
                    if ("dokumenSokongan".equals(part.getName()) && part.getSize() > 0) {
                        String submitted = part.getSubmittedFileName().replaceAll("\\s+", "_");
                        String fileName = System.currentTimeMillis() + "_" + submitted;
                        File saveFile = new File(SAVE_DIR, fileName);
                        part.write(saveFile.getAbsolutePath());
                        savedFiles.add(fileName);
                    }
                }

                String jenisBantuan = request.getParameter("jenisBantuan");
                String jenisBantuanLain = InputSanitizer.sanitize(request.getParameter("jenisBantuanLain")); 
                String keterangan = InputSanitizer.sanitize(request.getParameter("keterangan")); 
                
                String namaBank = request.getParameter("namaBank");
                String nomorAkaun = request.getParameter("nomorAkaun");

                Part penyataPart = request.getPart("penyataBank");
                String penyataFileName = null;
                if (penyataPart != null && penyataPart.getSize() > 0) {
                    String submitted = penyataPart.getSubmittedFileName().replaceAll("\\s+", "_");
                    penyataFileName = "BANK_" + System.currentTimeMillis() + "_" + submitted;
                    penyataPart.write(SAVE_DIR + File.separator + penyataFileName);
                }

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setId_pengguna(user.getId_pengguna());
                pb.setNama_bank(namaBank);
                pb.setNombor_akaun(nomorAkaun);
                pb.setPenyata_bank(penyataFileName);

                if ("999".equals(jenisBantuan) || "998".equals(jenisBantuan)) {
                    pb.setId_bantuan(Integer.parseInt(jenisBantuan)); 
                    String catatanSimpan = "LAIN-LAIN: " + (jenisBantuanLain != null ? jenisBantuanLain : "Lain-lain");
                    if (keterangan != null && !keterangan.trim().isEmpty()) {
                        catatanSimpan += " | " + keterangan;
                    }
                    pb.setCatatan_pemohon(catatanSimpan);
                } else {
                    pb.setId_bantuan(Integer.parseInt(jenisBantuan));
                    pb.setCatatan_pemohon(keterangan); 
                }

                // Fetch fresh socioeconomic data of current user for eligibility scoring
                try {
                    dao.PenggunaDAO uDao = new dao.PenggunaDAO();
                    Pengguna freshUser = uDao.getPenggunaById(user.getId_pengguna());
                    if (freshUser != null) {
                        pb.setPendapatan(freshUser.getPendapatan() != null ? freshUser.getPendapatan().doubleValue() : null);
                        pb.setStatus_keluarga(freshUser.getStatus_keluarga());
                        pb.setPekerjaan(freshUser.getPekerjaan());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Calculate eligibility score automatically
                service.EligibilityService eligibilityService = new service.EligibilityService();
                eligibilityService.calculateEligibilityScore(pb);

                int newId = pbDao.insertPermohonan(pb);
                
                // Save additional attachments
                if (newId != -1) {
                    // Trigger Notifikasi ke AJK Biro Kebajikan & Sosial
                    service.NotificationService.notifyByJawatan("Biro Kebajikan & Sosial", "BANTUAN", "Permohonan Bantuan Baru",
                        "Permohonan bantuan baru oleh " + user.getNama_penuh(), "/bantuan/list");

                    for (String fName : savedFiles) {
                        BantuanLampiran bl = new BantuanLampiran(newId, fName, "PEMOHON");
                        lampiranDao.insert(bl);
                    }
                }

                String source = request.getParameter("bantuanSource");
                BantuanDAO bDao = new BantuanDAO();
                
                if ("rasmi".equalsIgnoreCase(source)) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=success");
                } else if ("komuniti".equalsIgnoreCase(source)) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=success");
                } else {
                    // No explicit source parameter — infer redirect target from bantuan category.
                    // id_bantuan=999 is the sentinel for "Komuniti/Lain-lain" custom requests.
                    if (pb.getId_bantuan() == 999) {
                        response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=success");
                    } else {
                        Bantuan bDetails = bDao.getBantuanById(pb.getId_bantuan());
                        if (bDetails != null && "RASMI".equalsIgnoreCase(bDetails.getJenis_bantuan())) {
                            response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=success");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=success");
                        }
                    }
                }
            }
            // --- Route: /approve or /reject — Review action ---
            else if ("/approve".equals(action) || "/reject".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                int status = "/approve".equals(action) ? 1 : 2;

                pbDao.updateStatus(idPermohonan, status, request.getParameter("catatan"), null);
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }
            // --- Route: /update — Update assistance info ---
            else if ("/update".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String catatan = InputSanitizer.sanitize(request.getParameter("catatan"));

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
            // --- Route: /updateMyRequest — Resident edits pending request ---
            else if ("/updateMyRequest".equals(action) && isPendudukOrStaff(user)) {

                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String oldPenyata = request.getParameter("oldPenyataBank");

                // Handle Multiple Documents (New ones)
                Collection<Part> parts = request.getParts();
                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                
                for (Part part : parts) {
                    if ("dokumenSokongan".equals(part.getName()) && part.getSize() > 0) {
                        String submitted = part.getSubmittedFileName().replaceAll("\\s+", "_");
                        String newFileName = System.currentTimeMillis() + "_" + submitted;
                        File saveFile = new File(SAVE_DIR, newFileName);
                        part.write(saveFile.getAbsolutePath());
                        
                        BantuanLampiran bl = new BantuanLampiran(idPermohonan, newFileName, "PEMOHON");
                        lampiranDao.insert(bl);
                    }
                }
                
                Part penyataPart = request.getPart("penyataBank");
                String penyataFileName = oldPenyata;
                if (penyataPart != null && penyataPart.getSize() > 0) {
                    String submitted = penyataPart.getSubmittedFileName().replaceAll("\\s+", "_");
                    penyataFileName = "BANK_" + System.currentTimeMillis() + "_" + submitted;
                    penyataPart.write(SAVE_DIR + File.separator + penyataFileName);
                }

                String jenisBantuan = request.getParameter("jenisBantuan");
                String jenisBantuanLain = InputSanitizer.sanitize(request.getParameter("jenisBantuanLain"));
                String keterangan = InputSanitizer.sanitize(request.getParameter("keterangan"));
                String namaBank = request.getParameter("namaBank");
                String nomorAkaun = request.getParameter("nomorAkaun");

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setId_permohonan_bantuan(idPermohonan);
                pb.setId_pengguna(user.getId_pengguna());
                pb.setNama_bank(namaBank);
                pb.setNombor_akaun(nomorAkaun);
                pb.setPenyata_bank(penyataFileName);

                if ("999".equals(jenisBantuan)) {
                    pb.setId_bantuan(999);
                    String catatanSimpan = "LAIN-LAIN: " + (jenisBantuanLain != null ? jenisBantuanLain : "Lain-lain");
                    if (keterangan != null && !keterangan.trim().isEmpty()) {
                        catatanSimpan += " | " + keterangan;
                    }
                    pb.setCatatan_pemohon(catatanSimpan);
                } else {
                    pb.setId_bantuan(Integer.parseInt(jenisBantuan));
                    pb.setCatatan_pemohon(keterangan);
                }

                // Fetch fresh socioeconomic data for recalculation on edit
                try {
                    dao.PenggunaDAO uDao = new dao.PenggunaDAO();
                    Pengguna freshUser = uDao.getPenggunaById(user.getId_pengguna());
                    if (freshUser != null) {
                        pb.setPendapatan(freshUser.getPendapatan() != null ? freshUser.getPendapatan().doubleValue() : null);
                        pb.setStatus_keluarga(freshUser.getStatus_keluarga());
                        pb.setPekerjaan(freshUser.getPekerjaan());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Recalculate scoring
                service.EligibilityService eligibilityService = new service.EligibilityService();
                eligibilityService.calculateEligibilityScore(pb);
                
                pbDao.updatePermohonan(pb);

                BantuanDAO bDao = new BantuanDAO();
                if (pb.getId_bantuan() == 999) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=updated");
                } else {
                    Bantuan bDetails = bDao.getBantuanById(pb.getId_bantuan());
                    if (bDetails != null && "RASMI".equalsIgnoreCase(bDetails.getJenis_bantuan())) {
                        response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=updated");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=updated");
                    }
                }
            }
            // --- Route: /reviewAJK — AJK document review ---
            else if ("/reviewAJK".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan"); 
                String ulasanAJK = InputSanitizer.sanitize(request.getParameter("ulasan"));   

                // State Validation: Enforce that status must be "BARU"
                PermohonanBantuan currentPb = pbDao.getById(idPermohonan);
                if (currentPb == null || !"BARU".equalsIgnoreCase(currentPb.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=invalid_state");
                    return;
                }

                int statusBaru;
                String catatanSimpan;

                if ("lengkap".equals(keputusan)) {
                    statusBaru = 3;
                    catatanSimpan = "Disemak oleh AJK: Dokumen Lengkap.";
                } else {
                    statusBaru = 2;
                    catatanSimpan = (ulasanAJK != null && !ulasanAJK.trim().isEmpty())
                            ? ulasanAJK
                            : "Dokumen tidak lengkap. Sila hubungi AJK.";
                }

                pbDao.updateStatus(idPermohonan, statusBaru, catatanSimpan, null);

                // Trigger Notifikasi selepas review AJK
                if ("lengkap".equals(keputusan)) {
                    // 1. Notifikasi ke Ketua Kampung
                    service.NotificationService.notifyByPeranan("Ketua Kampung", "BANTUAN", "Permohonan Menunggu Kelulusan",
                        "Permohonan bantuan #" + idPermohonan + " telah disemak oleh AJK and menunggu kelulusan anda.", "/bantuan/list");

                    // 2. Notifikasi ke Penduduk (pemohon)
                    service.NotificationService.notifyUser(currentPb.getId_pengguna(), "BANTUAN", "Permohonan Sedang Diproses",
                        "Permohonan bantuan anda sedang dihantar ke Ketua Kampung untuk kelulusan.", "/bantuan/list");
                } else {
                    // Notifikasi ke Penduduk (pemohon) - Dokumen Tidak Lengkap
                    service.NotificationService.notifyUser(currentPb.getId_pengguna(), "BANTUAN", "Dokumen Tidak Lengkap",
                        "Permohonan bantuan anda memerlukan tindakan: " + catatanSimpan, "/bantuan/list");
                }

                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=reviewed");
            }
             // --- Route: /keputusanKetua — Ketua final approval decision ---
            else if ("/keputusanKetua".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan");
                String ulasanKetua = InputSanitizer.sanitize(request.getParameter("ulasan"));

                // State Validation: Enforce that status must be "MENUNGGU_KETUA"
                PermohonanBantuan currentPb = pbDao.getById(idPermohonan);
                if (currentPb == null || !"MENUNGGU_KETUA".equalsIgnoreCase(currentPb.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=invalid_state");
                    return;
                }

                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                Collection<Part> parts = request.getParts();
                // FIXME: firstFileName is passed to updateStatus() but the DAO ignores the dokumen parameter.
                // Remove this variable after confirming no other code path depends on it.
                String firstFileName = null;

                for (Part part : parts) {
                    if ("dokumenBalas".equals(part.getName()) && part.getSize() > 0) {
                        String submitted = part.getSubmittedFileName().replaceAll("\\s+", "_");
                        String fileName = "KETUA_" + System.currentTimeMillis() + "_" + submitted;
                        part.write(SAVE_DIR + File.separator + fileName);
                        
                        // Insert into bantuan_lampiran table
                        model.BantuanLampiran bl = new model.BantuanLampiran(idPermohonan, fileName, "PENTADBIR");
                        lampiranDao.insert(bl);
                        
                        if (firstFileName == null) firstFileName = fileName;
                    }
                }

                int statusBaru;
                String ulasanAdmin;

                if ("LULUS".equalsIgnoreCase(keputusan)) {
                    statusBaru = 1;
                    ulasanAdmin = (ulasanKetua != null && !ulasanKetua.trim().isEmpty()) 
                                 ? ulasanKetua : "DILULUSKAN: Permohonan disokong oleh Ketua Kampung.";
                } else {
                    statusBaru = 4;
                    ulasanAdmin = "DITOLAK oleh Ketua Kampung: " + (ulasanKetua != null ? ulasanKetua : "Tidak menepati syarat.");
                }

                pbDao.updateStatus(idPermohonan, statusBaru, ulasanAdmin, firstFileName);

                // Trigger Notifikasi selepas keputusan Ketua Kampung
                if ("LULUS".equalsIgnoreCase(keputusan)) {
                    service.NotificationService.notifyUser(currentPb.getId_pengguna(), "BANTUAN", "Permohonan Diluluskan! 🎉",
                        "Tahniah! Permohonan bantuan #" + idPermohonan + " telah diluluskan.", "/bantuan/list");
                } else {
                    service.NotificationService.notifyUser(currentPb.getId_pengguna(), "BANTUAN", "Permohonan Ditolak",
                        "Permohonan bantuan #" + idPermohonan + " ditolak: " + ulasanAdmin, "/bantuan/list");
                }

                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=decision_made");
            }
            

            // --- Route: /config — Eligibility rule configuration view ---
            else if ("/config".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            }
            

            // --- Route: /config/save — Save eligibility configurations ---
            else if ("/config/save".equals(action)) {
                String role = user.getNama_peranan();
                if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
                try {
                    double povertyLine = Double.parseDouble(request.getParameter("povertyLine"));
                    double wIncome = Double.parseDouble(request.getParameter("weightIncome"));
                    double wDependent = Double.parseDouble(request.getParameter("weightDependent"));
                    double wFamily = Double.parseDouble(request.getParameter("weightFamily"));
                    double wEmployment = Double.parseDouble(request.getParameter("weightEmployment"));

                    // Total weight must equal 100
                    double total = wIncome + wDependent + wFamily + wEmployment;
                    if (Math.abs(total - 100.0) > 0.001) {
                        response.sendRedirect(request.getContextPath() + "/bantuan/list?config_error=weight_sum");
                        return;
                    }

                    service.EligibilityService es = new service.EligibilityService();
                    es.updatePovertyLine(povertyLine);

                    java.util.Map<String, Double> weights = new java.util.HashMap<>();
                    weights.put("INCOME_FACTOR", wIncome);
                    weights.put("DEPENDENT_FACTOR", wDependent);
                    weights.put("FAMILY_STATUS_FACTOR", wFamily);
                    weights.put("EMPLOYMENT_STATUS_FACTOR", wEmployment);

                    boolean success = es.updateRuleWeights(weights);

                    if (success) {
                        // Recalculate all pending applications with new rules
                        java.util.List<model.PermohonanBantuan> pendingList = pbDao.getByStatus("BARU");
                        if (pendingList != null) {
                            for (model.PermohonanBantuan pb : pendingList) {
                                es.calculateEligibilityScore(pb);
                                pbDao.updateEligibilityData(pb.getId_permohonan(), pb.getEligibilityScore(),
                                    pb.getEligibilityTier(), pb.getEligibilityFlags());
                            }
                        }
                        response.sendRedirect(request.getContextPath() + "/bantuan/list?status=config_success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/bantuan/list?config_error=db");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?config_error=invalid_input");
                }
            }
            
            // --- Route: /tambahJenisBantuan or /kemaskiniJenisBantuan — Add/update aid types ---
            else if ("/tambahJenisBantuan".equals(action) || "/kemaskiniJenisBantuan".equals(action)) {
                String role = user.getNama_peranan();
                if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=denied");
                    return;
                }

                String idBantuanStr = request.getParameter("idBantuan");
                String namaBantuan = request.getParameter("namaBantuan");
                String jenisBantuan = request.getParameter("jenisBantuan");
                String peruntukanStr = request.getParameter("peruntukan");
                String syaratDokumen = request.getParameter("syaratDokumen");

                Bantuan b = new Bantuan();
                b.setNama_bantuan(namaBantuan);
                b.setJenis_bantuan(jenisBantuan);
                b.setSyarat_dokumen(syaratDokumen);
                try {
                    b.setJumlah_bantuan(new java.math.BigDecimal(peruntukanStr));
                } catch (Exception e) {
                    b.setJumlah_bantuan(java.math.BigDecimal.ZERO);
                }

                BantuanDAO bDao = new BantuanDAO();
                boolean success;

                if ("/tambahJenisBantuan".equals(action)) {
                    success = bDao.insertBantuan(b);
                } else {
                    b.setId_bantuan(Integer.parseInt(idBantuanStr));
                    success = bDao.updateBantuan(b);
                }

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=db");
                }
            }
             // --- Route: /padamJenisBantuan — Delete aid type ---
            else if ("/padamJenisBantuan".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    BantuanDAO bDao = new BantuanDAO();
                    bDao.deleteBantuan(Integer.parseInt(idStr));
                }
                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=deleted");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private boolean isPendudukOrStaff(Pengguna user) {
        if (user == null) return false;
        String role = user.getNama_peranan();
        return "Penduduk".equalsIgnoreCase(role) 
            || "AJK".equalsIgnoreCase(role) 
            || "AJK Kampung".equalsIgnoreCase(role) 
            || "Ketua Kampung".equalsIgnoreCase(role);
    }
}
