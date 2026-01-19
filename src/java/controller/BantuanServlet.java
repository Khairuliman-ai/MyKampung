package controller;

import model.Bantuan;
import dao.BantuanDAO;
import dao.PendudukDAO;
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
import model.Penduduk;

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

                } else if ("JKKK".equals(user.getJawatan())) {
                    // --- TAMBAHAN BARU UNTUK JKKK ---
                    // Pastikan anda dah save kod JSP tadi sebagai 'bantuan_jkkk.jsp' di folder Web Content
                    list = pbDao.getAll(); // Atau getByStatus(0) jika ada method tu
                    request.setAttribute("permohonanList", list);
                    request.getRequestDispatcher("/views/bantuan/urusBantuanJKKK.jsp").forward(request, response);

                } else {
                    // INI UNTUK KETUA KAMPUNG
                    list = pbDao.getAll();
                    request.setAttribute("permohonanList", list);

                    // --- TUKAR BARIS INI ---
                    // Tukar dari "/bantuanKetua.jsp" kepada fail baru kita:
                    request.getRequestDispatcher("/views/bantuan/urusBantuanKetua.jsp").forward(request, response);
                }
            } // ================== EDIT ==================
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
            } // ================== RASMI ==================
            else if ("/rasmi".equals(action)) {

    // 1. Semak Adakah User Itu Penduduk
    if (!"Penduduk".equals(user.getJawatan())) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    // 2. Dapatkan Data Penduduk (Untuk dapatkan idPenduduk yang betul)
    PendudukDAO pendudukDao = new PendudukDAO();
    Penduduk p = pendudukDao.getByIdPengguna(user.getIdPengguna());

    if (p == null) {
        // Jika profil penduduk tak jumpa, logout atau redirect ke profile
        response.sendRedirect(request.getContextPath() + "/logout");
        return;
    }

    // 3. Tarik Semua Permohonan Penduduk Ini
    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    List<PermohonanBantuan> fullList = pbDao.getByPenduduk(p.getIdPenduduk());

    // 4. [FILTER PENTING]: Ambil Bantuan Rasmi Sahaja (ID <= 20)
    // Kita buang bantuan ID 21, 22, 23, 24, 999 dari senarai ini
    List<PermohonanBantuan> listRasmi = new ArrayList<>();

    if (fullList != null) {
        for (PermohonanBantuan pb : fullList) {
            // Logik: Bantuan Rasmi ialah ID 1 hingga 20
            if (pb.getIdBantuan() <= 20) {
                listRasmi.add(pb);
            }
        }
    }

    // 5. Hantar data yang dah ditapis ke JSP
    request.setAttribute("permohonanList", listRasmi);
    request.getRequestDispatcher("/views/bantuan/bantuanRas.jsp")
            .forward(request, response);
} else if ("/komuniti".equals(action)) {

    // 1. Semak Adakah User Itu Penduduk
    if (!"Penduduk".equals(user.getJawatan())) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    // 2. Dapatkan Data Penduduk
    PendudukDAO pendudukDao = new PendudukDAO();
    Penduduk p = pendudukDao.getByIdPengguna(user.getIdPengguna());

    if (p == null) {
        // Jika profil belum lengkap, redirect ke profile atau logout
        response.sendRedirect(request.getContextPath() + "/logout");
        return;
    }

    // 3. Tarik Senarai Permohonan (Sejarah)
    PermohonanBantuanDAO pbDao = new PermohonanBantuanDAO();
    List<PermohonanBantuan> fullList = pbDao.getByPenduduk(p.getIdPenduduk());

    // Filter: Asingkan Bantuan Komuniti Sahaja (ID > 20 atau 999)
    List<PermohonanBantuan> listKomuniti = new ArrayList<>();
    if (fullList != null) {
        for (PermohonanBantuan pb : fullList) {
            if (pb.getIdBantuan() > 20 || pb.getIdBantuan() == 999) {
                listKomuniti.add(pb);
            }
        }
    }

    // 4. [BARU] Tarik Senarai Pilihan Bantuan untuk Dropdown (Dari Database)
    BantuanDAO bantuanDao = new BantuanDAO();
    List<Bantuan> listPilihanBantuan = new ArrayList<>();
    
    try {
        // Pastikan anda sudah buat method getBantuanKomuniti() dalam BantuanDAO
        listPilihanBantuan = bantuanDao.getBantuanKomuniti(); 
    } catch (SQLException e) {
        e.printStackTrace(); // Log error jika ada masalah database
    }

    // 5. Hantar Data ke JSP
    request.setAttribute("permohonanList", listKomuniti);       // Untuk Table Sejarah
    request.setAttribute("senaraiJenisBantuan", listPilihanBantuan); // Untuk Dropdown Modal
    
    request.getRequestDispatcher("/views/bantuan/bantuanKom.jsp").forward(request, response);
}// ================== TAMBAH INI (DELETE) ==================
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
            } // ===================== 5. UPDATE MY REQUEST (EDIT) =====================
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
            } // ===================== 6. JKKK REVIEW (Semakan Dokumen) =====================
            else if ("/reviewJKKK".equals(action)) {

                // 1. Ambil data dari form modal (urusBantuanJKKK.jsp)
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
            
            // ===================== 8. TAMBAH JENIS BANTUAN BARU (ADMIN) =====================
else if ("/tambahJenisBantuan".equals(action)) {
    
    // Security: Pastikan hanya JKKK atau Ketua Kampung boleh akses
    String role = user.getJawatan();
    if (!"JKKK".equals(role) && !"Ketua Kampung".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/dashboard?error=denied");
        return;
    }

    String namaBantuan = request.getParameter("namaBantuanBaru");
    
    if (namaBantuan != null && !namaBantuan.trim().isEmpty()) {
        BantuanDAO bDao = new BantuanDAO();
        Bantuan b = new Bantuan();
        b.setNamaBantuan(namaBantuan);
        
        try {
            bDao.insertBantuan(b);
            // Redirect balik ke page list dengan success message
            response.sendRedirect(request.getContextPath() + "/bantuan/list?msg=added");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/bantuan/list?error=db");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/bantuan/list?error=empty");
    }
}

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
