package controller;

import dao.FasilitiDAO;
import dao.TempahanFasilitiDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
        // TUKAR: Guna "currentUser" bukan "pengguna"
        Pengguna pengguna = (Pengguna) session.getAttribute("currentUser");

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaFasiliti();
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);

        List<TempahanFasiliti> senaraiTempahan = tempahanDAO.dapatkanSejarahTempahanPenduduk(pengguna.getId_pengguna());
        request.setAttribute("senaraiTempahan", senaraiTempahan);

        request.getRequestDispatcher("views/fasiliti/tempahanPenduduk.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        HttpSession session = request.getSession();
        // TUKAR: Guna "currentUser" bukan "pengguna"
        Pengguna pengguna = (Pengguna) session.getAttribute("currentUser");

        if (pengguna == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
            return;
        }

        try {
            int idFasiliti = Integer.parseInt(request.getParameter("id_fasiliti"));
            String tujuan = request.getParameter("tujuan");
            
            String formatTarikh = request.getParameter("tarikh_mula").replace("T", " ") + ":00";
            String formatTamat = request.getParameter("tarikh_tamat").replace("T", " ") + ":00";
            
            Timestamp tarikhMula = Timestamp.valueOf(formatTarikh);
            Timestamp tarikhTamat = Timestamp.valueOf(formatTamat);

            TempahanFasiliti tempahan = new TempahanFasiliti();
            tempahan.setId_pengguna(pengguna.getId_pengguna());
            tempahan.setId_fasiliti(idFasiliti);
            tempahan.setTarikh_mula(tarikhMula);
            tempahan.setTarikh_tamat(tarikhTamat);
            tempahan.setTujuan(tujuan);

            boolean berjaya = tempahanDAO.simpanTempahanBaru(tempahan);
            
            if (berjaya) {
                request.setAttribute("mesejSukses", "Tempahan berjaya dihantar.");
            } else {
                request.setAttribute("mesejRalat", "Ralat sistem: Gagal menghantar tempahan.");
            }
            
        } catch (Exception e) { // Gunakan Exception umum untuk tangkap ralat format tarikh/null
            e.printStackTrace();
            request.setAttribute("mesejRalat", "Ralat: Sila pastikan format tarikh dan masa adalah betul.");
        }

        // Muat semula senarai dengan memanggil semula doGet
        doGet(request, response);
    }
}