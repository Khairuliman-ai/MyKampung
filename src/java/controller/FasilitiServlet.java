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

import java.sql.Connection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
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
                    if (isStaff(user)) handleStatusTempahan(request, response, "LULUS");
                    break;
                case "/reject":
                    if (isStaff(user)) handleStatusTempahan(request, response, "TOLAK");
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
        String catatanPemohon = request.getParameter("catatan_pemohon");

        // 1. Check Blackout Dates
        if (sekatanDAO.checkKetersediaanTarikh(idFasiliti, tarikh)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?error=blackout");
            return;
        }

        // 2. Check User Quota (Max 2 active bookings per facility)
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
        String tempoh = request.getParameter("tempoh_tempahan");
        if ("2".equals(tempoh)) {
            t.setStatus("LULUS");
        } else if ("FullDay".equals(tempoh) || "HalfDay".equals(tempoh)) {
            t.setStatus("MENUNGGU");
        } else {
            // Fallback to facility default
            Fasiliti f = fasilitiDAO.dapatkanFasilitiById(idFasiliti);
            if (f.isRequiresApproval()) {
                t.setStatus("MENUNGGU");
            } else {
                t.setStatus("LULUS");
            }
        }
        
        if (tempahanDAO.simpanTempahanBaru(t)) {
            String msg = t.getStatus().equals("LULUS") ? "booked" : "pending_approval";
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
        File saveDir = new File(SAVE_DIR);
        if (!saveDir.exists()) saveDir.mkdirs();

        Part filePart = request.getPart("gambar_fasiliti");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = "fasiliti_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(SAVE_DIR + File.separator + fileName);
            f.setGambar_fasiliti(fileName);
        }
        
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
            File saveDir = new File(SAVE_DIR);
            if (!saveDir.exists()) saveDir.mkdirs();

            String fileName = "fasiliti_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            filePart.write(SAVE_DIR + File.separator + fileName);
            f.setGambar_fasiliti(fileName);
        } else {
            // Keep old image if no new one uploaded
            Fasiliti old = fasilitiDAO.dapatkanFasilitiById(f.getId_fasiliti());
            if (old != null) f.setGambar_fasiliti(old.getGambar_fasiliti());
        }
        
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
        
        if (tempahanDAO.updateStatusTempahan(id, status, catatan)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=status_failed");
        }
    }

    private boolean isStaff(Pengguna user) {
        String role = user.getNama_peranan();
        return "AJK Kampung".equalsIgnoreCase(role) || "Ketua Kampung".equalsIgnoreCase(role);
    }

    private void handleGetSlots(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idFasilitiStr = request.getParameter("idFasiliti");
        String durasiStr = request.getParameter("durasi");
        String tarikhStr = request.getParameter("tarikh");
        
        System.out.println("DEBUG: getSlots called with id=" + idFasilitiStr + ", durasi=" + durasiStr + ", tarikh=" + tarikhStr);

        if (idFasilitiStr == null || durasiStr == null || tarikhStr == null || tarikhStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            System.out.println("DEBUG: Missing parameters");
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
            System.out.println("DEBUG: Parsed date: " + tarikh);

            List<FasilitiSlot> slots = new ArrayList<>();
            
            if ("2".equals(durasiStr)) {
                // Slot 2 Jam: 08:00 - 00:00 (Every 2 hours)
                int[][] windows = {
                    {8, 10}, {10, 12}, {12, 14}, {14, 16}, 
                    {16, 18}, {18, 20}, {20, 22}, {22, 24}
                };
                for (int[] win : windows) {
                    String startStr = String.format("%02d:00:00", win[0]);
                    String endStr = win[1] == 24 ? "23:59:59" : String.format("%02d:00:00", win[1]);
                    
                    Time mula = Time.valueOf(startStr);
                    Time tamat = Time.valueOf(endStr);
                    if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, tamat)) {
                        FasilitiSlot s = new FasilitiSlot();
                        s.setMasa_mula(mula);
                        s.setMasa_tamat(tamat);
                        slots.add(s);
                    }
                }
            } else if ("HalfDay".equals(durasiStr)) {
                Time mula = Time.valueOf("08:00:00");
                Time tamat = Time.valueOf("14:00:00");
                if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, tamat)) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setMasa_mula(mula);
                    s.setMasa_tamat(tamat);
                    slots.add(s);
                }
            } else if ("FullDay".equals(durasiStr)) {
                Time mula = Time.valueOf("08:00:00");
                Time tamat = Time.valueOf("22:00:00");
                if (!tempahanDAO.semakKonflikMasa(idFasiliti, tarikh, mula, tamat)) {
                    FasilitiSlot s = new FasilitiSlot();
                    s.setMasa_mula(mula);
                    s.setMasa_tamat(tamat);
                    slots.add(s);
                }
            }
            
            System.out.println("DEBUG: Found " + slots.size() + " available slots");

            long nowMillis = System.currentTimeMillis();
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
            System.out.println("DEBUG ERROR in handleGetSlots: " + e.toString());
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                String msg = (e.getMessage() != null) ? e.getMessage() : e.toString();
                response.getWriter().write("{\"error\":\"" + msg.replace("\"", "\\\"") + "\"}");
            }
        }
    }

}
