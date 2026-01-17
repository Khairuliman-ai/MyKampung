package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import model.Penduduk;
import dao.PendudukDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Pengguna p = new Pengguna();
        p.setNamaPertama(request.getParameter("namaPertama"));
        p.setNamaKedua(request.getParameter("namaKedua"));
        p.setNomborKP(request.getParameter("nomborKP"));
        p.setNomborTelefon(request.getParameter("nomborTelefon"));
        try {
            p.setTarikhLahir(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("tarikhLahir")));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        p.setJawatan("Penduduk");  // Default untuk daftar
        p.setKataLaluan(request.getParameter("kataLaluan"));
        p.setNamaJalan(request.getParameter("namaJalan"));
        p.setBandar(request.getParameter("bandar"));
        p.setNomborPoskod(request.getParameter("nomborPoskod"));
        p.setNegeri(request.getParameter("negeri"));

        try {
            PenggunaDAO pDao = new PenggunaDAO();
            pDao.insert(p);

            // Dapatkan ID baru dari DB (asumsi auto-increment, tapi untuk simple, query balik)
            Pengguna inserted = pDao.getByNomborKP(p.getNomborKP());

            Penduduk pd = new Penduduk();
            pd.setIdPengguna(inserted.getIdPengguna());
            pd.setStatusSemasa(request.getParameter("statusSemasa"));
            pd.setPekerjaan(request.getParameter("pekerjaan"));
            pd.setPendapatan(Integer.parseInt(request.getParameter("pendapatan")));

            PendudukDAO pdDao = new PendudukDAO();
            pdDao.insert(pd);

            response.sendRedirect("login.jsp?success=Daftar berjaya. Sila log masuk.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Ralat daftar.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}