package controller;

import model.Bantuan;
import dao.BantuanDAO;

import model.PermohonanBantuan;
import dao.PermohonanBantuanDAO;
import model.Pengguna;

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
                    // --- TAMBAHAN BARU UNTUK JKKK ---
                    list = pbDao.getAll();
                    BantuanDAO bDao = new BantuanDAO();
                    List<Bantuan> senaraiBantuan = bDao.getAllBantuan();
                    
                    request.setAttribute("permohonanList", list);
                    request.setAttribute("senaraiBantuan", senaraiBantuan);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanAJK.jsp").forward(request, response);

                } else if ("Ketua Kampung".equalsIgnoreCase(user.getNama_peranan())) {
                    // INI UNTUK KETUA KAMPUNG
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);

                    // --- TUKAR BARIS INI ---
                    // Tukar dari "/bantuanKetua.jsp" kepada fail baru kita:
                    request.getRequestDispatcher("/views/bantuan/urusBantuanKetua.jsp").forward(request, response);
                } else {
                    // Fallback jika peranan tidak dikenali
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=invalid_role");
                }
            } // ================== EDIT ==================
            else if ("/edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                PermohonanBantuan pb = pbDao.getById(id);

                if (pb != null && pb.getId_pengguna() == user.getId_pengguna()) {
                    request.setAttribute("pb", pb);
                    request.getRequestDispatcher("/views/bantuan/bantuanEdit.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/bantuan/list?error=access");
                }
            } // ================== RASMI ==================
            else if ("/rasmi".equals(action)) {

    // 1. Semak Adakah User Itu Penduduk
    if (!"Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    // 2. Dapatkan Data Penduduk (Untuk dapatkan idPenduduk yang betul)
    
    

    if (false) {
        // Jika profil penduduk tak jumpa, logout atau redirect ke profile
        response.sendRedirect(request.getContextPath() + "/logout");
        return;
    }

    // 3. Tarik Semua Permohonan Penduduk Ini
    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    List<PermohonanBantuan> fullList = pbDao.getByPenduduk(user.getId_pengguna());

    // 4. [PENTING]: Tapis Bantuan Berdasarkan Kategori RASMI dari DB
    List<PermohonanBantuan> listRasmi = new ArrayList<>();
    BantuanDAO bantuanDao = new BantuanDAO();
    List<Bantuan> senaraiRasmiDB = bantuanDao.getBantuanByKategori("RASMI");

    if (fullList != null) {
        for (PermohonanBantuan pb : fullList) {
            // Semak jika ID permohonan ini ada dalam senarai RASMI dari database
            boolean isRasmi = false;
            for (Bantuan b : senaraiRasmiDB) {
                if (b.getId_bantuan() == pb.getId_bantuan()) {
                    isRasmi = true;
                    break;
                }
            }
            // ID 999 biasanya diletakkan di Komuniti, tetapi jika mahu di Rasmi juga boleh disesuaikan
            if (isRasmi) {
                listRasmi.add(pb);
            }
        }
    }

    // 5. Hantar data ke JSP
    request.setAttribute("permohonanList", listRasmi);
    request.setAttribute("senaraiJenisBantuan", senaraiRasmiDB); // Untuk dropdown Mohon Baru
    request.getRequestDispatcher("/views/bantuan/bantuanRas.jsp")
            .forward(request, response);
} else if ("/komuniti".equals(action)) {

    // 1. Semak Adakah User Itu Penduduk
    if (!"Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    // 2. Dapatkan Data Penduduk
    
    

    if (false) {
        // Jika profil belum lengkap, redirect ke profile atau logout
        response.sendRedirect(request.getContextPath() + "/logout");
        return;
    }

    // 3. Tarik Senarai Permohonan (Sejarah)
    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    List<PermohonanBantuan> fullList = pbDao.getByPenduduk(user.getId_pengguna());

    // 4. Tarik Senarai Pilihan Bantuan Komuniti dari DB
    BantuanDAO bantuanDao = new BantuanDAO();
    List<Bantuan> senaraiKomunitiDB = bantuanDao.getBantuanByKategori("KOMUNITI");
    
    // Filter: Asingkan Bantuan Komuniti Sahaja
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
            // ID 999 dikira sebagai Komuniti (Lain-lain)
            if (isKomuniti || pb.getId_bantuan() == 999) {
                listKomuniti.add(pb);
            }
        }
    }

    // 5. Hantar Data ke JSP
    request.setAttribute("permohonanList", listKomuniti);       // Untuk Table Sejarah
    request.setAttribute("senaraiJenisBantuan", senaraiKomunitiDB); // Untuk Dropdown Modal
    
    request.getRequestDispatcher("/views/bantuan/bantuanKom.jsp").forward(request, response);
}

// ... (kod sedia ada)

// ================== BORANG DIGITAL (TAMBAHAN BARU) ==================
else if ("/borangDigital.jsp".equals(action)) {
    // Forward request ke lokasi sebenar fail JSP dalam folder views
    request.getRequestDispatcher("/views/bantuan/borangDigital.jsp").forward(request, response);
}

// ... (kod sedia ada seterusnya, contohnya /delete atau /rasmi)// ================== TAMBAH INI (DELETE) ==================
// ================== DELETE (KEMASKINI) ==================
            else if ("/delete".equals(action)) {
                // Pastikan hanya PENDUDUK boleh delete (Security Check)
                if ("Penduduk".equalsIgnoreCase(user.getNama_peranan())) {
                    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
                    int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));

                    // LANGKAH 1: Dapatkan info permohonan DAHULU sebelum delete
                    // Tujuannya untuk tahu ID Bantuan (Rasmi atau Komuniti)
                    PermohonanBantuan pb = pbDao.getById(idPermohonan);
                    
                    String redirectPage = "/bantuan/rasmi"; // Default ke rasmi

                    if (pb != null) {
                        // Semak jenis bantuan
                        if (pb.getId_bantuan() > 20 || pb.getId_bantuan() == 999) {
                            redirectPage = "/bantuan/komuniti";
                        }
                        
                        // LANGKAH 2: Delete dari database selepas semakan
                        pbDao.deleteByIdAndPenduduk(idPermohonan, user.getId_pengguna());
                    }

                    // LANGKAH 3: Redirect ke page yang betul berdasarkan semakan tadi
                    response.sendRedirect(request.getContextPath() + redirectPage + "?status=deleted");
                    
                } else {
                    // Kalau bukan penduduk cuba delete, tendang balik
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?error=denied");
                }
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
            if ("/apply".equals(action) && "Penduduk".equalsIgnoreCase(user.getNama_peranan())) {

                // 1. Handle File Upload
                Part filePart = request.getPart("dokumenSokongan");
                String fileName = null;

                System.out.println("=== DEBUG UPLOAD ===");
                System.out.println("Part null?: " + (filePart == null));
                if (filePart != null) {
                    System.out.println("Size: " + filePart.getSize());
                    System.out.println("Submitted Name: " + filePart.getSubmittedFileName());
                }

                if (filePart != null && filePart.getSize() > 0) {
                    String submitted = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = System.currentTimeMillis() + "_" + submitted;
                    
                    File saveFile = new File(SAVE_DIR, fileName);
                    System.out.println("Writing to: " + saveFile.getAbsolutePath());
                    
                    filePart.write(saveFile.getAbsolutePath());
                    System.out.println("Write complete!");
                }
                System.out.println("====================");

                // 2. Ambil Data Form
                String jenisBantuan = request.getParameter("jenisBantuan");
                String jenisBantuanLain = request.getParameter("jenisBantuanLain"); // Input text khas
                String keterangan = request.getParameter("keterangan"); // Textarea biasa

                PermohonanBantuan pb = new PermohonanBantuan();
                pb.setId_pengguna(user.getId_pengguna());
                pb.setDokumen_pemohon(fileName);

                // --- LOGIC PENENTU ID & CATATAN (UPDATED ID 999) ---
                if ("999".equals(jenisBantuan)) {
                    pb.setId_bantuan(999); // Set ID 999

                    // Format: "LAIN-LAIN: [Nama Bantuan] | [Keterangan]"
                    // Simbol '|' ini PENTING supaya JSP boleh pisahkan nanti
                    String catatanSimpan = "LAIN-LAIN: " + (jenisBantuanLain != null ? jenisBantuanLain : "Lain-lain");

                    if (keterangan != null && !keterangan.trim().isEmpty()) {
                        catatanSimpan += " | " + keterangan;
                    }

                    pb.setCatatan_pemohon(catatanSimpan);

                } else {
                    // Bantuan Biasa (ID 6 - 20)
                    pb.setId_bantuan(Integer.parseInt(jenisBantuan));
                    pb.setCatatan_pemohon(keterangan); // Simpan keterangan biasa sahaja
                }
                // ----------------------------------------------------

               pbDao.insertPermohonan(pb);

                // --- LOGIK REDIRECT PINTAR (DINAMIK BERDASARKAN KATEGORI) ---
                BantuanDAO bDao = new BantuanDAO();
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

// ===================== 5. UPDATE MY REQUEST (EDIT) =====================
            else if ("/updateMyRequest".equals(action) && "Penduduk".equalsIgnoreCase(user.getNama_peranan())) {

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
                pb.setId_permohonan_bantuan(idPermohonan);
                pb.setDokumen_pemohon(fileName);

                // --- LOGIC PENENTUAN ID BANTUAN ---
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
                
                // Simpan ke database
                pbDao.updatePermohonan(pb);

                // --- LOGIK REDIRECT PINTAR (UPDATE DI SINI) ---
                // Kita semak ID bantuan yang baru dikemaskini.
                // Jika ID > 20 atau 999, ia adalah kategori Komuniti.
                int idCheck = pb.getId_bantuan();
                
                if (idCheck > 20 || idCheck == 999) {
                    // Redirect ke Tab Komuniti
                    response.sendRedirect(request.getContextPath() + "/bantuan/komuniti?status=updated");
                } else {
                    // Redirect ke Tab Rasmi
                    response.sendRedirect(request.getContextPath() + "/bantuan/rasmi?status=updated");
                }
            }

// ===================== 6. JKKK REVIEW (Semakan Dokumen) =====================
            else if ("/reviewJKKK".equals(action)) {

                // 1. Ambil data dari form modal (urusBantuanAJK.jsp)
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan"); // Value: "lengkap" atau "tak_lengkap"
                String ulasanJKKK = request.getParameter("ulasan");   // Value: Apa yang ditaip dalam textarea

                int statusBaru;
                String catatanSimpan;

                if ("lengkap".equals(keputusan)) {
                    // KES 1: Dokumen LENGKAP
                    // Status 3: Bermaksud "Disemak oleh JKKK, menunggu kelulusan Ketua Kampung"
                    // (Pastikan Status 3 ini wujud dalam logic database/JSP anda sebagai 'Pending Ketua')
                    statusBaru = 3;
                    catatanSimpan = "Disemak oleh JKKK: Dokumen Lengkap.";
                } else {
                    // KES 2: HANTAR BALIK (Tidak Lengkap)
                    // Status 2: Bermaksud "Perlu Pembetulan / Returned"
                    statusBaru = 2;

                    // Simpan ulasan JKKK terus ke database. 
                    // Contoh: "Salinan IC kabur, sila upload semula."
                    // Kita simpan 'ulasanJKKK' supaya pemohon nampak arahan yang jelas.
                    catatanSimpan = (ulasanJKKK != null && !ulasanJKKK.trim().isEmpty())
                            ? ulasanJKKK
                            : "Dokumen tidak lengkap. Sila hubungi JKKK.";
                }

                // 2. Update database (Status & Catatan)
                pbDao.updateStatus(idPermohonan, statusBaru, catatanSimpan, null);

                // 3. Redirect balik ke dashboard JKKK dengan mesej kejayaan
                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=reviewed");
            } // ===================== 7. KEPUTUSAN KETUA KAMPUNG (Lulus / Tolak) =====================
            else if ("/keputusanKetua".equals(action)) {

                // 1. Ambil data Form
                int idPermohonan = Integer.parseInt(request.getParameter("idPermohonan"));
                String keputusan = request.getParameter("keputusan");
                String ulasanKetua = request.getParameter("ulasan");

                // 2. Handle File Upload (Dokumen Balas dari Ketua)
                Part filePart = request.getPart("dokumenBalas"); // Pastikan nama ni sama dengan name="" di JSP
                String fileName = null;

                if (filePart != null && filePart.getSize() > 0) {
                    String submitted = filePart.getSubmittedFileName().replaceAll("\\s+", "_");
                    fileName = "KETUA_" + System.currentTimeMillis() + "_" + submitted;
                    filePart.write(SAVE_DIR + File.separator + fileName);
                }

                // 3. Tentukan Status & Ulasan
                int statusBaru;
                String ulasanAdmin;

                if ("lulus".equals(keputusan)) {
                    statusBaru = 1;
                    ulasanAdmin = "DILULUSKAN: Permohonan disokong oleh Ketua Kampung.";
                } else {
                    statusBaru = 4;
                    ulasanAdmin = "DITOLAK oleh Ketua Kampung: " + (ulasanKetua != null ? ulasanKetua : "Tidak menepati syarat.");
                }

                // 4. Update Database (Panggil method baru tadi)
                pbDao.updateStatus(idPermohonan, statusBaru, ulasanAdmin, fileName);

                response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=decision_made");
            }
            
            // ===================== 8. PENGURUSAN JENIS BANTUAN (ADMIN) =====================
            else if ("/tambahJenisBantuan".equals(action) || "/kemaskiniJenisBantuan".equals(action)) {
                // Security: Pastikan hanya JKKK/AJK atau Ketua Kampung boleh akses
                String role = user.getNama_peranan();
                if (!"JKKK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=denied");
                    return;
                }

                String idBantuanStr = request.getParameter("idBantuan");
                String namaBantuan = request.getParameter("namaBantuan");
                String jenisBantuan = request.getParameter("jenisBantuan");
                String peruntukanStr = request.getParameter("peruntukan");

                Bantuan b = new Bantuan();
                b.setNama_bantuan(namaBantuan);
                b.setJenis_bantuan(jenisBantuan);
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
