package controller;

import dao.FasilitiDAO;
import dao.TempahanFasilitiDAO;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Fasiliti;
import model.Pengguna;
import model.TempahanFasiliti;

@WebServlet(name = "TempahanServlet", urlPatterns = {"/TempahanServlet"})
public class TempahanServlet extends HttpServlet {

    private FasilitiDAO fasilitiDAO = new FasilitiDAO();
    private TempahanFasilitiDAO tempahanDAO = new TempahanFasilitiDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        Pengguna pengguna = (Pengguna) session.getAttribute("currentUser");

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        // 1. Tarik senarai fasiliti
        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaFasiliti();
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);

        // 2. Tarik sejarah tempahan
        List<TempahanFasiliti> senaraiTempahan = tempahanDAO.dapatkanSejarahTempahanPenduduk(pengguna.getId_pengguna());
        request.setAttribute("senaraiTempahan", senaraiTempahan);

        request.getRequestDispatcher("views/fasiliti/tempahanPenduduk.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        Pengguna pengguna = (Pengguna) session.getAttribute("currentUser");

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        try {
            int idFasiliti = Integer.parseInt(request.getParameter("id_fasiliti"));
            
            // Ambil input datetime-local (Format: yyyy-MM-ddTHH:mm)
            String rawMula = request.getParameter("tarikh_mula");
            String rawTamat = request.getParameter("tarikh_tamat");
            
            // Tukar ke Timestamp sementara untuk memudahkan pembahagian Date/Time
            Timestamp tsMula = Timestamp.valueOf(rawMula.replace("T", " ") + ":00");
            Timestamp tsTamat = Timestamp.valueOf(rawTamat.replace("T", " ") + ":00");

            TempahanFasiliti tempahan = new TempahanFasiliti();
            tempahan.setId_pengguna(pengguna.getId_pengguna());
            tempahan.setId_fasiliti(idFasiliti);
            
            // --- PEMBETULAN: Guna method baru mengikut model dan DB anda ---
            tempahan.setTarikh_tempah(new Date(tsMula.getTime()));
            tempahan.setMasa_mula(new Time(tsMula.getTime()));
            tempahan.setMasa_tamat(new Time(tsTamat.getTime()));
            tempahan.setStatus("MENUNGGU"); // Gunakan huruf besar ikut DB
            
            // Jika anda ingin simpan tujuan, pastikan jadual ada kolum 'catatan_pentadbir' atau 'tujuan'
            // tempahan.setCatatan_pentadbir(request.getParameter("tujuan")); 

            boolean berjaya = tempahanDAO.simpanTempahanBaru(tempahan);
            
            if (berjaya) {
                request.setAttribute("mesejSukses", "Tempahan berjaya dihantar.");
            } else {
                request.setAttribute("mesejRalat", "Ralat sistem: Gagal menghantar tempahan ke pangkalan data.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mesejRalat", "Ralat: Format tarikh atau data tidak sah.");
        }

        // Muat semula halaman
        doGet(request, response);
    }
}