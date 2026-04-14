package controller;

import dao.FasilitiDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Fasiliti;
import model.Pengguna;

@WebServlet(name = "UrusFasilitiServlet", urlPatterns = {"/UrusFasilitiServlet"})
public class UrusFasilitiServlet extends HttpServlet {

    private FasilitiDAO fasilitiDAO = new FasilitiDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Semakan sesi pengguna (hanya pengurusan boleh akses)
        HttpSession session = request.getSession();
        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");

        if (pengguna == null || pengguna.getStatus() == 0) {
            response.sendRedirect("views/auth/auth.jsp");
            return;
        }

        // Panggil DAO yang anda berikan tadi
        List<Fasiliti> senaraiFasiliti = fasilitiDAO.dapatkanSemuaFasiliti();
        request.setAttribute("senaraiFasiliti", senaraiFasiliti);

        // Halakan ke paparan pengurusan fasiliti
        request.getRequestDispatcher("views/fasiliti/urusFasiliti.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");

        String namaFasiliti = request.getParameter("nama_fasiliti");
        String kategori = request.getParameter("kategori");
        String kapasitiStr = request.getParameter("kapasiti");
        String ketersediaanStr = request.getParameter("ketersediaan");

        Fasiliti fasilitiBaru = new Fasiliti();
        fasilitiBaru.setNama_fasiliti(namaFasiliti);
        fasilitiBaru.setKategori(kategori);
        
        // Urus input kapasiti jika ada nilai atau kosong
        if (kapasitiStr != null && !kapasitiStr.trim().isEmpty()) {
            fasilitiBaru.setKapasiti(Integer.parseInt(kapasitiStr));
        } else {
            fasilitiBaru.setKapasiti(null);
        }
        
        fasilitiBaru.setKetersediaan(ketersediaanStr != null && ketersediaanStr.equals("true"));

        // Guna fungsi tambahFasiliti dari FasilitiDAO
        boolean berjaya = fasilitiDAO.tambahFasiliti(fasilitiBaru);

        if (berjaya) {
            request.setAttribute("mesejSukses", "Fasiliti / Aset baharu berjaya didaftarkan.");
        } else {
            request.setAttribute("mesejRalat", "Gagal mendaftar fasiliti. Sila cuba lagi.");
        }

        // Refresh senarai
        doGet(request, response);
    }
}