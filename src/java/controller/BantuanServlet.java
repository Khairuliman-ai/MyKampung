package controller;

import model.Bantuan;
import dao.BantuanDAO;

import model.PermohonanBantuan;
import dao.PermohonanBantuanDAO;
import model.Pengguna;
import model.BantuanLampiran;
import dao.BantuanLampiranDAO;

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
            = "C:\\Users\\khayx\\OneDrive\\Documents\\SEM5_UMT\\PITA1\\MyKampungData\\lampiranBantuan";

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

                } else if ("JKKK".equalsIgnoreCase(user.getNama_peranan()) || "AJK".equalsIgnoreCase(user.getNama_peranan()) || "AJK Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    list = pbDao.getAll();
                    BantuanDAO bDao = new BantuanDAO();
                    List<Bantuan> senaraiBantuan = bDao.getAllBantuan();
                    
                    request.setAttribute("permohonanList", list);
                    request.setAttribute("senaraiBantuan", senaraiBantuan);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanAJK.jsp").forward(request, response);

                } else if ("Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanKetua.jsp").forward(request, response);
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
                if (!"Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }

                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> fullList = pbDao.getByPenduduk(user.getId_pengguna());

                List<PermohonanBantuan> listRasmi = new ArrayList<>();
                BantuanDAO bantuanDao = new BantuanDAO();
                List<Bantuan> senaraiRasmiDB = bantuanDao.getBantuanByKategori("RASMI");

                if (fullList != null) {
                    for (PermohonanBantuan pb : fullList) {
                        boolean isRasmi = false;
                        for (Bantuan b : senaraiRasmiDB) {
                            if (b.getId_bantuan() == pb.getId_bantuan()) {
                                isRasmi = true;
                                break;
                            }
                        }
                        if (isRasmi) {
                            listRasmi.add(pb);
                        }
                    }
                }

                request.setAttribute("permohonanList", listRasmi);
                request.setAttribute("senaraiJenisBantuan", senaraiRasmiDB); 
                request.getRequestDispatcher("/views/bantuan/bantuanRas.jsp")
                        .forward(request, response);
            } else if ("/komuniti".equals(action)) {
                if (!"Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    return;
                }

                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                List<PermohonanBantuan> fullList = pbDao.getByPenduduk(user.getId_pengguna());

                BantuanDAO bantuanDao = new BantuanDAO();
                List<Bantuan> senaraiKomunitiDB = bantuanDao.getBantuanByKategori("KOMUNITI");
                
                List<PermohonanBantuan> listKomuniti = new ArrayList<>();
                if (fullList != null) {
                    for (PermohonanBantuan pb : fullList) {
                        boolean isKomuniti = false;
                        for (Bantuan b : senaraiKomunitiDB) {
                            if (b.getId_bantuan() == pb.getId_bantuan()) {
                                isKomuniti = true;
                                break;
                            }
                        }
                        if (isKomuniti) {
                            listKomuniti.add(pb);
                        }
                    }
                }

                request.setAttribute("permohonanList", listKomuniti);       
                request.setAttribute("senaraiJenisBantuan", senaraiKomunitiDB); 
                request.setAttribute("currentUser", user);
                
                request.getRequestDispatcher("/views/bantuan/bantuanKom.jsp").forward(request, response);
            } else if ("/delete".equals(action)) {
                if ("Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
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
            } else if ("/deleteAttachment".equals(action) && "Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
                int idLampiran = Integer.parseInt(request.getParameter("idLampiran"));
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                
                BantuanLampiranDAO lampiranDao = new BantuanLampiranDAO();
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(idPermohonan);
                
                if (pb != null && pb.getId_pengguna() == user.getId_pengguna()) {
                    lampiranDao.deleteById(idLampiran);
                }
                
                response.sendRedirect(request.getContextPath() + "/bantuan/edit?id=" + idPermohonan + "&status=doc_deleted");
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
            if ("/apply".equals(action) && "Penduduk".equalsIgnoreCase(user.getNama_peranan())) {

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
            else if ("/updateMyRequest".equals(action) && "Penduduk".equalsIgnoreCase(user.getNama_peranan())) {

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
            else if ("/reviewJKKK".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan"); 
                String ulasanJKKK = request.getParameter("ulasan");   

                int statusBaru;
                String catatanSimpan;

                if ("lengkap".equals(keputusan)) {
                    statusBaru = 3;
                    catatanSimpan = "Disemak oleh JKKK: Dokumen Lengkap.";
                } else {
                    statusBaru = 2;
                    catatanSimpan = (ulasanJKKK != null && !ulasanJKKK.trim().isEmpty())
                            ? ulasanJKKK
                            : "Dokumen tidak lengkap. Sila hubungi JKKK.";
                }

                pbDao.updateStatus(idPermohonan, statusBaru, catatanSimpan, null);
                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=reviewed");
            } else if ("/keputusanKetua".equals(action)) {
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan");
                String ulasanKetua = request.getParameter("ulasan");

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
            
            else if ("/tambahJenisBantuan".equals(action) || "/kemaskiniJenisBantuan".equals(action)) {
                String role = user.getNama_peranan();
                if (!"JKKK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
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
}
