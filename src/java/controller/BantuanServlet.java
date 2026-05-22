package controller;

import model.Bantuan;
import dao.BantuanDAO;

import model.PermohonanBantuan;
import dao.PermohonanBantuanDAO;
import model.Pengguna;
import model.BantuanLampiran;
import dao.BantuanLampiranDAO;
import util.AppConfig;


import java.util.Collection;
import javax.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
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
public class BantuanServlet extends HttpServlet {

    private static final String SAVE_DIR
            = AppConfig.DIR_LAMPIRAN_BANTUAN;


    // ======================= GET =======================
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
            if (action == null || "/".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
                return;
            }

            // ================== LIST ==================
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

                    // Recalculate and persist scores dynamically to reflect latest rules & profile updates
                    service.EligibilityService eligibilityService = new service.EligibilityService();
                    if (listBaru != null) {
                        for (PermohonanBantuan pb : listBaru) {
                            eligibilityService.calculateEligibilityScore(pb);
                            pbDao.updateEligibilityData(pb.getId_permohonan(), pb.getEligibilityScore(), pb.getEligibilityTier(), pb.getEligibilityFlags());
                        }
                    }
                    if (listSejarah != null) {
                        for (PermohonanBantuan pb : listSejarah) {
                            eligibilityService.calculateEligibilityScore(pb);
                            pbDao.updateEligibilityData(pb.getId_permohonan(), pb.getEligibilityScore(), pb.getEligibilityTier(), pb.getEligibilityFlags());
                        }
                    }

                    int totalSejarahCount = pbDao.getSejarahCount();
                    int totalPagesSejarah = (int) Math.ceil((double) totalSejarahCount / pageSize);

                    BantuanDAO bDao = new BantuanDAO();
                    List<Bantuan> senaraiBantuan = bDao.getAllBantuan();
                    
                    request.setAttribute("listBaru", listBaru);
                    request.setAttribute("listSejarah", listSejarah);
                    request.setAttribute("senaraiBantuan", senaraiBantuan);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPagesSejarah);
                    request.setAttribute("totalCount", totalSejarahCount);
                    
                    request.getRequestDispatcher("/views/bantuan/urusBantuanAJK.jsp").forward(request, response);

                } else if ("Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    list = pbDao.getAll();
                    // Recalculate and persist scores dynamically for Ketua Kampung as well
                    service.EligibilityService eligibilityService = new service.EligibilityService();
                    if (list != null) {
                        for (PermohonanBantuan pb : list) {
                            eligibilityService.calculateEligibilityScore(pb);
                            pbDao.updateEligibilityData(pb.getId_permohonan(), pb.getEligibilityScore(), pb.getEligibilityTier(), pb.getEligibilityFlags());
                        }
                    }
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanKetua.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=invalid_role");
                }
            } // ================== MOHON (ALL ROLES RESIDENT VIEW) ==================
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
            } // ================== EDIT ==================
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
            } // ================== RASMI ==================
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
                String role = user.getNama_peranan();
                if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
                service.EligibilityService es = new service.EligibilityService();
                request.setAttribute("rules", es.getRulesList());
                request.setAttribute("povertyLine", es.getPovertyLine());
                request.getRequestDispatcher("/views/bantuan/urusBantuanConfig.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ======================= POST =======================
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

            // ===================== 1. APPLY (PENDUDUK) =====================
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
                String jenisBantuanLain = request.getParameter("jenisBantuanLain"); 
                String keterangan = request.getParameter("keterangan"); 
                
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
                try (java.sql.Connection conn = util.DBUtil.getConnection()) {
                    dao.PenggunaDAO uDao = new dao.PenggunaDAO(conn);
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
                    // Fallback to existing logic
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
            } // ===================== 2. APPROVE / REJECT =====================
            else if ("/approve".equals(action) || "/reject".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                int status = "/approve".equals(action) ? 1 : 2;

                pbDao.updateStatus(idPermohonan, status, request.getParameter("catatan"), null);
                response.sendRedirect(request.getContextPath() + "/bantuan/list");
            } // ===================== 3. UPDATE INFO (KETUA) =====================
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
                String jenisBantuanLain = request.getParameter("jenisBantuanLain");
                String keterangan = request.getParameter("keterangan");
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
                try (java.sql.Connection conn = util.DBUtil.getConnection()) {
                    dao.PenggunaDAO uDao = new dao.PenggunaDAO(conn);
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
            else if ("/reviewAJK".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan"); 
                String ulasanAJK = request.getParameter("ulasan");   

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
                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=reviewed");
            } else if ("/keputusanKetua".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan");
                String ulasanKetua = request.getParameter("ulasan");

                // State Validation: Enforce that status must be "MENUNGGU_KETUA"
                PermohonanBantuan currentPb = pbDao.getById(idPermohonan);
                if (currentPb == null || !"MENUNGGU_KETUA".equalsIgnoreCase(currentPb.getStatus())) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=invalid_state");
                    return;
                }

                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                Collection<Part> parts = request.getParts();
                String firstFileName = null; // Still keep for backward compatibility in main table if needed

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
                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=decision_made");
            }
            
            // ===================== CONFIG =====================
            else if ("/config".equals(action)) {
                String role = user.getNama_peranan();
                if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
                service.EligibilityService es = new service.EligibilityService();
                request.setAttribute("rules", es.getRulesList());
                request.setAttribute("povertyLine", es.getPovertyLine());
                request.getRequestDispatcher("/views/bantuan/urusBantuanConfig.jsp").forward(request, response);
            }
            
            // ===================== CONFIG SAVE =====================
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
                        response.sendRedirect(request.getContextPath() + "/bantuan/config?error=weight_sum");
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
                        response.sendRedirect(request.getContextPath() + "/bantuan/config?status=success");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/bantuan/config?error=db");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/bantuan/config?error=invalid_input");
                }
            }
            
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
            } else if ("/padamJenisBantuan".equals(action)) {
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
