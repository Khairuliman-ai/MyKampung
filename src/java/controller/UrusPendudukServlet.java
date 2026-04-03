package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import model.Pengguna;
import util.DBUtil;
import java.sql.Connection;

@WebServlet(name = "UrusPendudukServlet", urlPatterns = {
    "/penduduk/urus", "/penduduk/approve", "/penduduk/reject", "/penduduk/update",
    "/ketua/urus", "/ketua/lantik", "/ketua/update"
})
public class UrusPendudukServlet extends HttpServlet {

    // Kita tidak initialize di sini kerana DAO memerlukan Connection
    private PenggunaDAO penggunaDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        // Menggunakan try-with-resources untuk mendapatkan Connection
        try (Connection conn = DBUtil.getConnection()) {
            penggunaDAO = new PenggunaDAO(conn);

            if ("/penduduk/urus".equals(action)) {
                // Aktifkan getPendingRegistrations jika sudah ada di DAO
                // List<Pengguna> pendingList = penggunaDAO.getPendingRegistrations();
                List<Pengguna> activeList = penggunaDAO.getAllActivePenduduk();

                // request.setAttribute("pendingList", pendingList);
                request.setAttribute("activeList", activeList);
                request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukJKKK.jsp").forward(request, response);
            } 
            else if ("/ketua/urus".equals(action)) {
                List<Pengguna> listAJK = penggunaDAO.getAllAJK();
                List<Pengguna> listPenduduk = penggunaDAO.getAllActivePenduduk();

                request.setAttribute("listAJK", listAJK);
                request.setAttribute("listPenduduk", listPenduduk);
                request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukKetua.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Ralat pangkalan data.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();
        request.setCharacterEncoding("UTF-8");

        try (Connection conn = DBUtil.getConnection()) {
            penggunaDAO = new PenggunaDAO(conn);

            // 1. LOGIC LANTIK JKKK (OLEH KETUA KAMPUNG)
            if ("/ketua/lantik".equals(action)) {
                Pengguna p = new Pengguna();
                p.setNombor_kp(request.getParameter("nomborKP"));
                p.setNama_penuh(request.getParameter("namaLengkap"));
                p.setNombor_telefon(request.getParameter("nomborTelefon"));
                p.setNama_jalan(request.getParameter("alamat"));

                //penggunaDAO.lantikJKKK(p); 
                response.sendRedirect(request.getContextPath() + "/ketua/urus?status=lantikSuccess");
            }

            // 2. LOGIC UPDATE (UNTUK JKKK & KETUA KAMPUNG)
            else if ("/penduduk/update".equals(action) || "/ketua/update".equals(action)) {
                Pengguna p = new Pengguna();
                p.setId_pengguna(Integer.parseInt(request.getParameter("idPengguna")));
                p.setNombor_kp(request.getParameter("nomborKP"));
                p.setNama_penuh(request.getParameter("namaLengkap"));
                p.setNombor_telefon(request.getParameter("nomborTelefon"));
                p.setNama_jalan(request.getParameter("namaJalan"));
                p.setBandar(request.getParameter("bandar"));
                p.setNombor_poskod(request.getParameter("nomborPoskod"));
                p.setNegeri(request.getParameter("negeri"));

               // penggunaDAO.updatePengguna(p);

                String redirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
                response.sendRedirect(request.getContextPath() + redirect + "?status=updated");
            }

            // 3. LOGIC APPROVE (STATUS = 1)
            else if ("/penduduk/approve".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
             //   penggunaDAO.updateStatus(id, 1);
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=approved");
            }

            // 4. LOGIC REJECT (STATUS = 2)
            else if ("/penduduk/reject".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
             //   penggunaDAO.updateStatus(id, 2);
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=rejected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorRedirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
            response.sendRedirect(request.getContextPath() + errorRedirect + "?error=systemError");
        }
    }
}