package controller;

import dao.FasilitiDAO;
import dao.FasilitiSlotDAO;
import dao.TempahanFasilitiDAO;
import model.Fasiliti;
import model.FasilitiSlot;
import model.Pengguna;
import model.TempahanFasiliti;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FasilitiServlet extends HttpServlet {

    private FasilitiDAO fasilitiDAO = new FasilitiDAO();
    private TempahanFasilitiDAO tempahanDAO = new TempahanFasilitiDAO();
    private FasilitiSlotDAO slotDAO = new FasilitiSlotDAO();

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
                case "/deleteSlot":
                    if (isStaff(user)) handleDeleteSlot(request, response);
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
                case "/addSlot":
                    if (isStaff(user)) handleAddSlot(request, response);
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
        
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);
        request.setAttribute("senaraiTempahan", senaraiTempahan);
        request.getRequestDispatcher("/views/fasiliti/tempahanPenduduk.jsp").forward(request, response);
    }

    private void showAdminUrus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaTermasukTidakAktif();
        List<TempahanFasiliti> senaraiSemuaTempahan = tempahanDAO.dapatkanSemuaTempahan();
        
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);
        request.setAttribute("senaraiTempahan", senaraiSemuaTempahan);
        
        // Fetch all slots to display in management
        List<FasilitiSlot> senaraiSlot = new ArrayList<>();
        for(Fasiliti f : senaraiFasiliti) {
            senaraiSlot.addAll(slotDAO.getSlotsByFasiliti(f.getId_fasiliti(), 1));
            senaraiSlot.addAll(slotDAO.getSlotsByFasiliti(f.getId_fasiliti(), 2));
        }
        request.setAttribute("senaraiSlot", senaraiSlot);
        
        request.getRequestDispatcher("/views/fasiliti/urusFasiliti.jsp").forward(request, response);
    }

    private void handleTempah(HttpServletRequest request, HttpServletResponse response, Pengguna user)
            throws IOException {
        int idFasiliti = Integer.parseInt(request.getParameter("id_fasiliti"));
        Date tarikh = Date.valueOf(request.getParameter("tarikh_tempah"));
        Time mula = Time.valueOf(request.getParameter("masa_mula") + ":00");
        Time tamat = Time.valueOf(request.getParameter("masa_tamat") + ":00");
        String catatanPemohon = request.getParameter("catatan_pemohon");

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
        
        if (tempahanDAO.simpanTempahanBaru(t)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/list?success=booked");
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
            throws IOException {
        Fasiliti f = new Fasiliti();
        f.setNama_fasiliti(request.getParameter("nama"));
        f.setLokasi(request.getParameter("lokasi"));

        String latStr = request.getParameter("latitude");
        String lonStr = request.getParameter("longitude");
        if (latStr != null && !latStr.isEmpty()) f.setLatitude(Double.parseDouble(latStr));
        if (lonStr != null && !lonStr.isEmpty()) f.setLongitude(Double.parseDouble(lonStr));
        
        if (fasilitiDAO.tambahFasiliti(f)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=add_failed");
        }
    }

    private void handleEditFasiliti(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Fasiliti f = new Fasiliti();
        f.setId_fasiliti(Integer.parseInt(request.getParameter("id")));
        f.setNama_fasiliti(request.getParameter("nama"));
        f.setLokasi(request.getParameter("lokasi"));
        f.setStatus(request.getParameter("status"));

        String latStr_ = request.getParameter("latitude");
        String lonStr_ = request.getParameter("longitude");
        if (latStr_ != null && !latStr_.isEmpty()) f.setLatitude(Double.parseDouble(latStr_));
        if (lonStr_ != null && !lonStr_.isEmpty()) f.setLongitude(Double.parseDouble(lonStr_));
        
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
        String catatan = request.getParameter("catatan");
        
        if (tempahanDAO.kemaskiniStatus(id, status, catatan)) {
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
        int idFasiliti = Integer.parseInt(request.getParameter("idFasiliti"));
        int durasi = Integer.parseInt(request.getParameter("durasi"));
        List<FasilitiSlot> slots = slotDAO.getSlotsByFasiliti(idFasiliti, durasi);
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("[");
        for (int i = 0; i < slots.size(); i++) {
            FasilitiSlot s = slots.get(i);
            out.print("{\"id\":" + s.getId_slot() + ",\"mula\":\"" + s.getMasa_mula() + "\",\"tamat\":\"" + s.getMasa_tamat() + "\"}");
            if (i < slots.size() - 1) out.print(",");
        }
        out.print("]");
    }

    private void handleAddSlot(HttpServletRequest request, HttpServletResponse response) throws IOException {
        FasilitiSlot s = new FasilitiSlot();
        s.setId_fasiliti(Integer.parseInt(request.getParameter("id_fasiliti")));
        s.setMasa_mula(Time.valueOf(request.getParameter("masa_mula") + ":00"));
        s.setMasa_tamat(Time.valueOf(request.getParameter("masa_tamat") + ":00"));
        s.setDurasi(Integer.parseInt(request.getParameter("durasi")));
        
        if (slotDAO.addSlot(s)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=slot_added");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=slot_failed");
        }
    }

    private void handleDeleteSlot(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (slotDAO.deleteSlot(id)) {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?success=slot_deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/fasiliti/urus?error=slot_delete_failed");
        }
    }
}
