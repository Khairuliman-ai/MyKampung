package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import dao.PendudukDAO;
import model.Pengguna;

// KEMASKINI URL PATTERNS: Tambah /ketua/urus, /ketua/lantik, /ketua/update
@WebServlet(name = "UrusPendudukServlet", urlPatterns = {
    "/penduduk/urus", "/penduduk/approve", "/penduduk/reject", "/penduduk/update",
    "/ketua/urus", "/ketua/lantik", "/ketua/update"
})
public class UrusPendudukServlet extends HttpServlet {

    private PenggunaDAO penggunaDAO = new PenggunaDAO();
    private PendudukDAO pendudukDAO = new PendudukDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        // VIEW JKKK (Sedia ada)
        if ("/penduduk/urus".equals(action)) {
            List<Pengguna> pendingList = penggunaDAO.getPendingRegistrations();
            List<Pengguna> activeList = penggunaDAO.getAllActivePenduduk();
            request.setAttribute("pendingList", pendingList);
            request.setAttribute("activeList", activeList);
            request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukJKKK.jsp").forward(request, response);
        }
        
        // VIEW KETUA KAMPUNG (Baru)
        else if ("/ketua/urus".equals(action)) {
            // 1. Senarai JKKK
            List<Pengguna> listJKKK = penggunaDAO.getAllJKKK();
            // 2. Senarai Penduduk
            List<Pengguna> listPenduduk = penggunaDAO.getAllActivePenduduk();
            
            request.setAttribute("listJKKK", listJKKK);
            request.setAttribute("listPenduduk", listPenduduk);
            
            // Forward ke JSP Ketua Kampung
            request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukKetua.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        // LOGIC LANTIK JKKK (KETUA KAMPUNG)
        if ("/ketua/lantik".equals(action)) {
            try {
                Pengguna p = new Pengguna();
                p.setNomborKP(request.getParameter("nomborKP"));
                p.setNomborTelefon(request.getParameter("nomborTelefon"));
                p.setKataLaluan(request.getParameter("kataLaluan"));
                p.setNamaJalan(request.getParameter("alamat")); // Alamat ringkas
                
                String namaLengkap = request.getParameter("namaLengkap");
                if (namaLengkap != null && namaLengkap.contains(" ")) {
                    String[] parts = namaLengkap.split(" ", 2);
                    p.setNamaPertama(parts[0]);
                    p.setNamaKedua(parts[1]);
                } else {
                    p.setNamaPertama(namaLengkap);
                    p.setNamaKedua("");
                }
                
                penggunaDAO.lantikJKKK(p);
                response.sendRedirect(request.getContextPath() + "/ketua/urus?status=lantikSuccess");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/ketua/urus?error=gagalLantik");
            }
        }
        
        // LOGIC UPDATE (Guna semula untuk Ketua Kampung juga)
        else if ("/penduduk/update".equals(action) || "/ketua/update".equals(action)) {
            try {
                Pengguna p = new Pengguna();
                p.setIdPengguna(Integer.parseInt(request.getParameter("idPengguna")));
                p.setNomborKP(request.getParameter("nomborKP"));
                p.setNomborTelefon(request.getParameter("nomborTelefon"));
                p.setKataLaluan(request.getParameter("kataLaluan"));
                
                String namaLengkap = request.getParameter("namaLengkap");
                if (namaLengkap != null && namaLengkap.contains(" ")) {
                    String[] parts = namaLengkap.split(" ", 2);
                    p.setNamaPertama(parts[0]);
                    p.setNamaKedua(parts[1]);
                } else {
                    p.setNamaPertama(namaLengkap);
                    p.setNamaKedua("");
                }
                
                p.setNamaJalan(request.getParameter("namaJalan"));
                p.setBandar(request.getParameter("bandar"));
                p.setNomborPoskod(request.getParameter("nomborPoskod"));
                p.setNegeri(request.getParameter("negeri"));
                
                penggunaDAO.updatePengguna(p);
                
                // Redirect ikut siapa yang buat update
                if (action.contains("ketua")) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=updated");
                }
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/ketua/urus?error=gagalUpdate");
            }
        }
        
        // LOGIC APPROVE/REJECT (Kekal sama untuk JKKK)
        else if ("/penduduk/approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("idPengguna"));
            penggunaDAO.updateStatus(id, 1);
            pendudukDAO.createDefaultProfile(id);
            response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=processed");
        } 
        else if ("/penduduk/reject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("idPengguna"));
            penggunaDAO.updateStatus(id, 2);
            response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=processed");
        }
    }
}