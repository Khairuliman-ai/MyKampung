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

    private PenggunaDAO penggunaDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try (Connection conn = DBUtil.getConnection()) {
            penggunaDAO = new PenggunaDAO(conn);

            if ("/penduduk/urus".equals(action)) {
                // Mengambil senarai penduduk aktif (status 1)
                List<Pengguna> activeList = penggunaDAO.getAllActivePenduduk();
                // Mengambil senarai permohonan baru (status 2)
                List<Pengguna> pendingList = penggunaDAO.getPendingPenduduk();

                request.setAttribute("pendingList", pendingList);
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
                
                penggunaDAO.lantikJKKK(p); 
                response.sendRedirect(request.getContextPath() + "/ketua/urus?status=lantikSuccess");
            }

            // 2. LOGIC UPDATE
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

                penggunaDAO.updatePengguna(p);

                String redirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
                response.sendRedirect(request.getContextPath() + redirect + "?status=updated");
            }

            // 3. LOGIC APPROVE (Ubah status 2 -> 1)
            else if ("/penduduk/approve".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                // Menggunakan method updateStatus yang kita buat dalam DAO sebelum ini
                penggunaDAO.updateStatus(id, 1); 
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=approved");
            }

            // 4. LOGIC REJECT (Ubah status 2 -> 0)
            else if ("/penduduk/reject".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                // Set status ke 0 supaya ia hilang dari senarai pending dan tidak masuk senarai aktif
                penggunaDAO.updateStatus(id, 0); 
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=rejected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorRedirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
            response.sendRedirect(request.getContextPath() + errorRedirect + "?error=systemError");
        }
    }
}