package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import dao.PendudukDAO;
import model.Pengguna;
import model.Penduduk;

// 1. KEMASKINI URL PATTERNS: Tambah /profil/view
@WebServlet(urlPatterns = {"/profil/view", "/profil/update"})
public class ProfileServlet extends HttpServlet {

    // 2. TAMBAH METHOD doGet UNTUK PAPARAN (Bila tekan Navbar)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("user");

        if (user != null) {
            // Dapatkan maklumat detail Penduduk dari DB
            PendudukDAO pDao = new PendudukDAO();
            Penduduk detail = pDao.getByUserId(user.getIdPengguna());

            // Hantar data ke JSP melalui request attribute
            request.setAttribute("pendudukDetail", detail);

            // Forward ke halaman JSP
            request.getRequestDispatcher("/views/maklumatPenduduk/kemaskiniProfil.jsp").forward(request, response);
        } else {
            // Jika tiada session, tendang ke login
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }

    // 3. METHOD doPost UNTUK SIMPAN DATA (Kekal seperti sebelum ini)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna currentUser = (Pengguna) session.getAttribute("user");
        
        if (currentUser != null) {
            try {
                // Update Object Pengguna
                currentUser.setNamaPertama(request.getParameter("namaPertama"));
                currentUser.setNamaKedua(request.getParameter("namaKedua"));
                currentUser.setNomborTelefon(request.getParameter("nomborTelefon"));
                
                // Hanya update password jika user isi (tidak kosong)
                String newPass = request.getParameter("kataLaluan");
                if(newPass != null && !newPass.trim().isEmpty()){
                    currentUser.setKataLaluan(newPass);
                }

                currentUser.setNamaJalan(request.getParameter("namaJalan"));
                currentUser.setBandar(request.getParameter("bandar"));
                currentUser.setNomborPoskod(request.getParameter("nomborPoskod"));
                currentUser.setNegeri(request.getParameter("negeri"));
                
                // Simpan ke DB Pengguna
                PenggunaDAO penggunaDAO = new PenggunaDAO();
                penggunaDAO.updatePengguna(currentUser);
                
                // Update Object Penduduk (Jika role penduduk)
                if ("Penduduk".equals(currentUser.getJawatan())) {
                    Penduduk p = new Penduduk();
                    p.setIdPengguna(currentUser.getIdPengguna());
                    p.setStatusSemasa(request.getParameter("statusSemasa"));
                    p.setPekerjaan(request.getParameter("pekerjaan"));
                    p.setPendapatan(Integer.parseInt(request.getParameter("pendapatan")));
                    
                    PendudukDAO pendudukDAO = new PendudukDAO();
                    pendudukDAO.updatePenduduk(p);
                }
                
                // Kemaskini session
                session.setAttribute("user", currentUser);
                
                // Redirect balik ke View (GET) dengan mesej sukses
                response.sendRedirect(request.getContextPath() + "/profil/view?status=success");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/profil/view?status=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
    }
}