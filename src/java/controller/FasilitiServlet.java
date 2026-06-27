package controller;

import dao.FasilitiDAO;
import dao.FasilitiSlotDAO;
import dao.FasilitiSekatanDAO;
import dao.TempahanFasilitiDAO;
import model.Fasiliti;
import model.FasilitiSlot;
import model.Pengguna;
import model.TempahanFasiliti;
import model.ActivityLog;
import dao.ActivityLogDAO;
import util.AppConfig;
import util.DBUtil;
import util.StatusConstant;
import util.FileUploadUtil;

import java.sql.Connection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 5 * 1024 * 1024,       // 5MB
    maxRequestSize = 10 * 1024 * 1024    // 10MB
)
/**
 * FasilitiServlet handles facility management and tempahan (bookings) lifecycle.
 * It manages the catalog of village facilities, booking slot allocations,
 * and approval workflows.
 * 
 * <p><strong>Auto-Approval Policy:</strong>
 * Bookings with a duration of 2 hours or less are auto-approved to minimize
 * administrative overhead, while longer bookings (half-day or full-day)
 * require manual review by the Biro Sukan & Riadah.</p>
 * 
 * <h3>GET Routes (via PathInfo switch):</h3>
 * <ul>
 *   <li>/list - Resident catalog and personal booking history.</li>
 *   <li>/urus - AJK/Staff management interface for facilities and bookings.</li>
 *   <li>/slots - JSON endpoint returning available slots for a facility and date.</li>
 *   <li>/tambah - Renders form to add a new facility (Staff only).</li>
 *   <li>/kemaskini - Renders form to update a facility (Staff only).</li>
 * </ul>
 * 
 * <h3>POST Routes:</h3>
 * <ul>
 *   <li>/mohon - Submits a booking request (verifies user booking quotas).</li>
 *   <li>/batal - Allows a resident to cancel their own booking.</li>
 *   <li>/approve - Approves a booking (Staff only).</li>
 *   <li>/reject - Rejects a booking (Staff only).</li>
 *   <li>/insert - Inserts new facility into DB (Staff only).</li>
 *   <li>/update - Updates facility in DB (Staff only).</li>
 *   <li>/delete - Deletes a facility from DB (Staff only).</li>
 * </ul>
 */
public class FasilitiServlet extends HttpServlet {

    private static final String SAVE_DIR = AppConfig.DIR_GAMBAR_FASILITI;

    private FasilitiDAO fasilitiDAO = new FasilitiDAO();
    private TempahanFasilitiDAO tempahanDAO = new TempahanFasilitiDAO();
    private FasilitiSlotDAO slotDAO = new FasilitiSlotDAO();
    private FasilitiSekatanDAO sekatanDAO = new FasilitiSekatanDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        String action = request.getPathInfo();
        if (action == null || action.equals("/")) {
            action = "/list";
        } else {
            // Trim trailing slashes and normalize
            action = action.replaceAll("/$", "");
        }

        try {
            switch (action) {
                case "/list":
                    showPendudukList(request, response, user);
                    break;
                case "/urus":
                    if (isStaff(user)) {
                        showAdminUrus(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?error=access");
                    }
                    break;
                case "/batal":
                    handleBatal(request, response, user);
                    break;
                case "/padam":
                    if (isStaff(user)) {
                        handlePadamFasiliti(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/dashboard?error=access");
                    }
                    break;
                case "/getSlots":
                    handleGetSlots(request, response);
                    break;
                case "/getBookingConfig":
                    handleGetBookingConfig(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/fasiliti/list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        String action = request.getPathInfo();

        try {
            switch (action) {
                case "/tempah":
                    handleTempah(request, response, user);
                    break;
                case "/tambah":
                    if (isStaff(user)) handleTambahFasiliti(request, response);
                    break;
                case "/edit":
                    if (isStaff(user)) handleEditFasiliti(request, response);
                    break;
                case "/approve":
                    if (isStaff(user)) handleStatusTempahan(request, response, StatusConstant.TEMPAHAN_LULUS);
                    break;
                case "/reject":
                    if (isStaff(user)) handleStatusTempahan(request, response, StatusConstant.TEMPAHAN_TOLAK);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/fasiliti/list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void showPendudukList(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws ServletException, IOException {
        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaFasiliti();
        List<TempahanFasiliti> senaraiTempahan = tempahanDAO.dapatkanSejarahTempahanPenduduk(user.getId_pengguna());
        
        // Fetch activity logs for aside bar
        List<ActivityLog> logs = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            ActivityLogDAO logDAO = new ActivityLogDAO(conn);
            logs = logDAO.getLogsByResidentId(user.getId_pengguna());
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);
        request.setAttribute("senaraiTempahan", senaraiTempahan);
        request.setAttribute("activityLogs", logs);
        request.getRequestDispatcher("/views/fasiliti/tempahanPenduduk.jsp").forward(request, response);
    }

    private void showAdminUrus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaTermasukTidakAktif();
        List<TempahanFasiliti> senaraiSemuaTempahan = tempahanDAO.dapatkanSemuaTempahan();
        
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);
        request.setAttribute("senaraiTempahan", senaraiSemuaTempahan);
        
        request.getRequestDispatcher("/views/fasiliti/urusFasiliti.jsp").forward(request, response);
    }

    private void handleTempah(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws IOException {
        int idFasiliti = Integer.parseInt(request.getParameter("id_fasiliti"));
        java.sql.Date tarikh = java.sql.Date.valueOf(request.getParameter("tarikh_tempah"));
        Time mula = Time.valueOf(request.getParameter("masa_mula") + ":00");
        Time tamat = Time.valueOf(request.getParameter("masa_tamat") + ":00");
        if (tamat.toString().equals("00:00:00")) {
            tamat = Time.valueOf("23:59:00");
        }
        String catatanPemohon = request.getParameter("catatan_pemohon");

        // 1. Check Blackout Dates
        if (sekatanDAO.checkKetersediaanTarikh(idFasiliti, tarikh)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=blackout");
            return;
        }

        // Quota: max 2 active bookings per user per facility, to ensure fair access
        // for all kampung residents. Approved/Pending both count toward the quota.
        if (tempahanDAO.checkUserQuotaActive(user.getId_pengguna(), idFasiliti) >= 2) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=quota");
            return;
        }

        if (mula.after(tamat) || mula.equals(tamat)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=time");
            return;
        }

        if (tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, tamat)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=conflict");
            return;
        }

        TempahanFasiliti t = new TempahanFasiliti();
        t.setId_pengguna(user.getId_pengguna());
        t.setId_fasiliti(idFasiliti);
        t.setTarikh_tempah(tarikh);
        t.setMasa_mula(mula);
        t.setMasa_tamat(tamat);
        t.setCatatan_pemohon(catatanPemohon);
        
        // 3. Determine Initial Status
        // Short-slot bookings are auto-approved; HalfDay/FullDay always require manual approval
        String tempoh = request.getParameter("tempoh_tempahan");
        Fasiliti facilityForStatus = fasilitiDAO.dapatkanFasilitiById(idFasiliti);
        if ("FullDay".equals(tempoh) || "HalfDay".equals(tempoh) || facilityForStatus.isRequiresApproval()) {
            t.setStatus(StatusConstant.TEMPAHAN_MENUNGGU);
        } else {
            t.setStatus(StatusConstant.TEMPAHAN_LULUS);
        }
        
        if (tempahanDAO.simpanTempahanBaru(t)) {
            // Trigger Notifikasi ke AJK Biro Sukan & Riadah
            Fasiliti f = fasilitiDAO.dapatkanFasilitiById(idFasiliti);
            String namaF = f != null ? f.getNama_fasiliti() : "Fasiliti";
            service.NotificationService.notifyByJawatan("Biro Sukan & Riadah", "TEMPAHAN", "Tempahan Fasiliti Baru",
                "Tempahan baru untuk " + namaF + " pada " + tarikh + " oleh " + user.getNama_penuh(), "/fasiliti/urus");

            String msg = t.getStatus().equals(StatusConstant.TEMPAHAN_LULUS) ? "booked" : "pending_approval";
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?success=" + msg);
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=db");
        }
    }

    private void handleBatal(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (tempahanDAO.batalTempahan(id, user.getId_pengguna())) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?success=cancelled");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=cancel_failed");
        }
    }

    private void handleTambahFasiliti(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Fasiliti f = new Fasiliti();
        f.setNama_fasiliti(request.getParameter("nama"));
        f.setLokasi(request.getParameter("lokasi"));

        String latStr = request.getParameter("latitude");
        String lonStr = request.getParameter("longitude");
        if (latStr != null && !latStr.isEmpty()) f.setLatitude(Double.parseDouble(latStr));
        if (lonStr != null && !lonStr.isEmpty()) f.setLongitude(Double.parseDouble(lonStr));
        
        String reqApp = request.getParameter("requires_approval");
        f.setRequiresApproval("1".equals(reqApp));

        // Handle Image Upload
        Part filePart = request.getPart("gambar_fasiliti");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                String fileName = FileUploadUtil.saveFile(filePart, SAVE_DIR, "fasiliti_");
                f.setGambar_fasiliti(fileName);
            } catch (Exception e) {
                throw new ServletException("Gagal menyimpan gambar fasiliti", e);
            }
        }

        // Operating hours and slot duration
        String waktuBukaStr = request.getParameter("waktu_buka");
        String waktuTutupStr = request.getParameter("waktu_tutup");
        String durasiSlotStr = request.getParameter("durasi_slot_minit");
        if (waktuBukaStr != null && !waktuBukaStr.isEmpty()) f.setWaktu_buka(Time.valueOf(waktuBukaStr + ":00"));
        if (waktuTutupStr != null && !waktuTutupStr.isEmpty()) f.setWaktu_tutup(Time.valueOf(waktuTutupStr + ":00"));
        if (durasiSlotStr != null && !durasiSlotStr.isEmpty()) f.setDurasi_slot_minit(Integer.parseInt(durasiSlotStr));
        
        if (fasilitiDAO.tambahFasiliti(f)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=add_failed");
        }
    }

    private void handleEditFasiliti(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Fasiliti f = new Fasiliti();
        f.setId_fasiliti(Integer.parseInt(request.getParameter("id")));
        f.setNama_fasiliti(request.getParameter("nama"));
        f.setLokasi(request.getParameter("lokasi"));
        f.setStatus(request.getParameter("status"));

        String latStr_ = request.getParameter("latitude");
        String lonStr_ = request.getParameter("longitude");
        if (latStr_ != null && !latStr_.isEmpty()) f.setLatitude(Double.parseDouble(latStr_));
        if (lonStr_ != null && !lonStr_.isEmpty()) f.setLongitude(Double.parseDouble(lonStr_));
        
        String reqAppEdit = request.getParameter("requires_approval");
        f.setRequiresApproval("1".equals(reqAppEdit));

        // Handle Image Upload
        Part filePart = request.getPart("gambar_fasiliti");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                String fileName = FileUploadUtil.saveFile(filePart, SAVE_DIR, "fasiliti_");
                f.setGambar_fasiliti(fileName);
            } catch (Exception e) {
                throw new ServletException("Gagal menyimpan gambar fasiliti", e);
            }
        } else {
            // Keep old image if no new one uploaded
            Fasiliti old = fasilitiDAO.dapatkanFasilitiById(f.getId_fasiliti());
            if (old != null) f.setGambar_fasiliti(old.getGambar_fasiliti());
        }

        // Operating hours and slot duration
        String waktuBukaStr_ = request.getParameter("waktu_buka");
        String waktuTutupStr_ = request.getParameter("waktu_tutup");
        String durasiSlotStr_ = request.getParameter("durasi_slot_minit");
        if (waktuBukaStr_ != null && !waktuBukaStr_.isEmpty()) f.setWaktu_buka(Time.valueOf(waktuBukaStr_ + ":00"));
        if (waktuTutupStr_ != null && !waktuTutupStr_.isEmpty()) f.setWaktu_tutup(Time.valueOf(waktuTutupStr_ + ":00"));
        if (durasiSlotStr_ != null && !durasiSlotStr_.isEmpty()) f.setDurasi_slot_minit(Integer.parseInt(durasiSlotStr_));
        
        if (fasilitiDAO.kemaskiniFasiliti(f)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=update_failed");
        }
    }

    private void handlePadamFasiliti(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (fasilitiDAO.padamFasiliti(id)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=delete_failed");
        }
    }

    private void handleStatusTempahan(HttpServletRequest request, HttpServletResponse response, String status)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("idTempahan"));
        String catatan = request.getParameter("catatan"); // This will be the reason for rejection
        
        // Dapatkan rekod tempahan untuk hantar notifikasi
        TempahanFasiliti tempahan = tempahanDAO.dapatkanTempahanById(id);

        if (tempahanDAO.updateStatusTempahan(id, status, catatan)) {
            // Trigger Notifikasi ke Penduduk (pemohon)
            if (tempahan != null) {
                if (StatusConstant.TEMPAHAN_LULUS.equals(status)) {
                    service.NotificationService.notifyUser(tempahan.getId_pengguna(), "TEMPAHAN", "Tempahan Diluluskan",
                        "Tempahan anda untuk " + tempahan.getNama_fasiliti() + " pada " + tempahan.getTarikh_tempah() + " telah diluluskan.", "/fasiliti/list");
                } else {
                    String ulasan = (catatan != null && !catatan.trim().isEmpty()) ? catatan : "Tidak menepati syarat.";
                    service.NotificationService.notifyUser(tempahan.getId_pengguna(), "TEMPAHAN", "Tempahan Ditolak",
                        "Tempahan anda untuk " + tempahan.getNama_fasiliti() + " pada " + tempahan.getTarikh_tempah() + " ditolak: " + ulasan, "/fasiliti/list");
                }
            }
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=status_failed");
        }
    }

    private boolean isStaff(Pengguna user) {
        String role = user.getNama_peranan();
        return StatusConstant.ROLE_AJK_KAMPUNG.equalsIgnoreCase(role) || StatusConstant.ROLE_KETUA_KAMPUNG.equalsIgnoreCase(role);
    }

    private void handleGetSlots(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idFasilitiStr = request.getParameter("idFasiliti");
        String durasiStr = request.getParameter("durasi");
        String tarikhStr = request.getParameter("tarikh");
        
        if (idFasilitiStr == null || durasiStr == null || tarikhStr == null || tarikhStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int idFasiliti = Integer.parseInt(idFasilitiStr);
            
            java.sql.Date tarikh;
            try {
                tarikh = java.sql.Date.valueOf(tarikhStr);
            } catch (Exception e) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    java.util.Date parsedDate = sdf.parse(tarikhStr);
                    tarikh = new java.sql.Date(parsedDate.getTime());
                } catch (ParseException e2) {
                    throw new Exception("Format tarikh tidak sah: " + tarikhStr);
                }
            }

            // Load facility config from database
            Fasiliti fasiliti = fasilitiDAO.dapatkanFasilitiById(idFasiliti);
            if (fasiliti == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Fasiliti tidak dijumpai\"}");
                return;
            }

            Time waktuBuka = fasiliti.getWaktu_buka() != null ? fasiliti.getWaktu_buka() : Time.valueOf("08:00:00");
            Time waktuTutup = fasiliti.getWaktu_tutup() != null ? fasiliti.getWaktu_tutup() : Time.valueOf("22:00:00");
            int durasiMinit = fasiliti.getDurasi_slot_minit() > 0 ? fasiliti.getDurasi_slot_minit() : 120;

            int waktuBukaMinutes = waktuBuka.toLocalTime().getHour() * 60 + waktuBuka.toLocalTime().getMinute();
            int waktuTutupMinutes = waktuTutup.toLocalTime().getHour() * 60 + waktuTutup.toLocalTime().getMinute();
            if (waktuTutupMinutes <= waktuBukaMinutes) {
                waktuTutupMinutes += 1440;
            }

            List<FasilitiSlot> slots = new ArrayList<>();

            if ("slot".equals(durasiStr)) {
                int cursor = waktuBukaMinutes;
                int endLimit = waktuTutupMinutes;
                
                while (cursor + durasiMinit <= endLimit) {
                    int startMins = cursor;
                    int endMins = cursor + durasiMinit;
                    
                    LocalTime slotMulaLT = LocalTime.of((startMins / 60) % 24, startMins % 60);
                    LocalTime slotTamatLT = LocalTime.of((endMins / 60) % 24, endMins % 60);
                    
                    Time mula = Time.valueOf(slotMulaLT);
                    Time tamat = Time.valueOf(slotTamatLT);
                    Time checkTamat = tamat.toString().equals("00:00:00") ? Time.valueOf("23:59:00") : tamat;
                    
                    if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, checkTamat)) {
                        FasilitiSlot s = new FasilitiSlot();
                        s.setMasa_mula(mula);
                        s.setMasa_tamat(tamat);
                        slots.add(s);
                    }
                    cursor += durasiMinit;
                }
            } else if ("HalfDay".equals(durasiStr)) {
                int totalMins = waktuTutupMinutes - waktuBukaMinutes;
                int midpointMins = waktuBukaMinutes + (totalMins / 2);
                
                LocalTime slotMulaLT = waktuBuka.toLocalTime();
                LocalTime slotTamatLT = LocalTime.of((midpointMins / 60) % 24, midpointMins % 60);
                
                Time mula = Time.valueOf(slotMulaLT);
                Time tamat = Time.valueOf(slotTamatLT);
                Time checkTamat = tamat.toString().equals("00:00:00") ? Time.valueOf("23:59:00") : tamat;
                
                if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, checkTamat)) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setMasa_mula(mula);
                    s.setMasa_tamat(tamat);
                    slots.add(s);
                }
            } else if ("FullDay".equals(durasiStr)) {
                Time mula = waktuBuka;
                Time tamat = waktuTutup;
                Time checkTamat = tamat.toString().equals("00:00:00") ? Time.valueOf("23:59:00") : tamat;
                
                if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, checkTamat)) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setMasa_mula(mula);
                    s.setMasa_tamat(tamat);
                    slots.add(s);
                }
            }

            java.time.LocalDate todayLD = java.time.LocalDate.now(java.time.ZoneId.of("Asia/Kuala_Lumpur"));
            java.time.LocalTime nowLT = java.time.LocalTime.now(java.time.ZoneId.of("Asia/Kuala_Lumpur"));
            java.time.LocalDate requestedLD = tarikh.toLocalDate();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("[");
            for (int i = 0; i < slots.size(); i++) {
                FasilitiSlot s = slots.get(i);
                java.time.LocalTime slotMulaLT = s.getMasa_mula().toLocalTime();
                
                boolean isPast = requestedLD.equals(todayLD) && slotMulaLT.isBefore(nowLT);
                
                out.print("{");
                out.print("\"mula\":\"" + s.getMasa_mula() + "\",");
                out.print("\"tamat\":\"" + s.getMasa_tamat() + "\",");
                out.print("\"isPast\":" + isPast);
                out.print("}");
                
                if (i < slots.size() - 1) out.print(",");
            }
            out.print("]");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                String msg = (e.getMessage() != null) ? e.getMessage() : e.toString();
                response.getWriter().write("{\"error\":\"" + msg.replace("\"", "\\\"") + "\"}");
            }
        }
    }

    /**
     * Returns per-facility booking configuration as JSON for the frontend to build
     * dynamic dropdown options instead of hardcoding duration choices.
     */
    private void handleGetBookingConfig(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int idFasiliti = Integer.parseInt(idStr);
            Fasiliti f = fasilitiDAO.dapatkanFasilitiById(idFasiliti);
            if (f == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String waktuBuka = f.getWaktu_buka() != null ? f.getWaktu_buka().toString() : "08:00:00";
            String waktuTutup = f.getWaktu_tutup() != null ? f.getWaktu_tutup().toString() : "22:00:00";
            int durasiSlotMinit = f.getDurasi_slot_minit() > 0 ? f.getDurasi_slot_minit() : 120;

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{");
            out.print("\"waktuBuka\":\"" + waktuBuka + "\",");
            out.print("\"waktuTutup\":\"" + waktuTutup + "\",");
            out.print("\"durasiSlotMinit\":" + durasiSlotMinit + ",");
            out.print("\"requiresApproval\":" + f.isRequiresApproval());
            out.print("}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
