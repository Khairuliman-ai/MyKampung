package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import dao.ActivityLogDAO;
import model.Pengguna;
import model.ActivityLog;
import util.DBUtil;
import java.sql.Connection;
import java.math.BigDecimal;

@WebServlet(name = "UrusPendudukServlet", urlPatterns = {
    "/penduduk/urus", "/penduduk/approve", "/penduduk/reject", "/penduduk/update",
    "/ketua/urus", "/ketua/lantik", "/ketua/update", "/ketua/gugurkan", "/ketua/tambahJawatan"
})
public class UrusPendudukServlet extends HttpServlet {

    private PenggunaDAO penggunaDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try (Connection conn = DBUtil.getConnection()) {
            penggunaDAO = new PenggunaDAO(conn);
            dao.JawatanDAO jawatanDAO = new dao.JawatanDAO();

            if ("/penduduk/urus".equals(action)) {
                List<Pengguna> activeList = penggunaDAO.getAllActivePenduduk();
                List<Pengguna> pendingList = penggunaDAO.getPendingPenduduk();
                request.setAttribute("pendingList", pendingList);
                request.setAttribute("activeList", activeList);
                request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukJKKK.jsp").forward(request, response);
            } 
            else if ("/ketua/urus".equals(action)) {
                List<Pengguna> listAJK = penggunaDAO.getAllAJK();
                List<Pengguna> listPenduduk = penggunaDAO.getAllActivePenduduk();
                List<Pengguna> listJawatan = jawatanDAO.getJawatanHolders();

                request.setAttribute("listAJK", listAJK);
                request.setAttribute("listPenduduk", listPenduduk);
                request.setAttribute("listJawatan", listJawatan);
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
            dao.JawatanDAO jawatanDAO = new dao.JawatanDAO();

            // 1. LOGIC LANTIK AJK
            if ("/ketua/lantik".equals(action)) {
                int idPengguna = Integer.parseInt(request.getParameter("idPengguna"));
                int idJawatan = Integer.parseInt(request.getParameter("idJawatan"));
                
                // Logic: Ketua Kampung must drop existing title holder before appointing new one
                // We check if jawatan is already occupied (optional check if JSP already filters)
                boolean success = jawatanDAO.lantikAJK(idPengguna, idJawatan);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=lantikSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=error");
                }
            }
            
            // 2. LOGIC GUGURKAN JAWATAN
            else if ("/ketua/gugurkan".equals(action)) {
                int idPengguna = Integer.parseInt(request.getParameter("idPengguna"));
                int idJawatan = Integer.parseInt(request.getParameter("idJawatan"));
                
                boolean success = jawatanDAO.gugurkanJawatan(idPengguna, idJawatan);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=dropSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=error");
                }
            }
            
            // 3. LOGIC TAMBAH JAWATAN BARU
            else if ("/ketua/tambahJawatan".equals(action)) {
                String namaJawatan = request.getParameter("namaJawatan");
                boolean success = jawatanDAO.tambahJawatan(namaJawatan);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=tambahJawatanSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=error");
                }
            }

            // 3. LOGIC UPDATE PROFIL (Oleh Admin/Ketua)
            else if ("/penduduk/update".equals(action) || "/ketua/update".equals(action)) {
                // ... (Existing update logic kept)
                int idPengguna = Integer.parseInt(request.getParameter("idPengguna"));
                Pengguna pendudukLama = penggunaDAO.getPenggunaById(idPengguna);
                String nomborTelefon = request.getParameter("nomborTelefon");
                String namaJalan = request.getParameter("namaJalan");
                String bandar = request.getParameter("bandar");
                String nomborPoskod = request.getParameter("nomborPoskod");
                String negeri = request.getParameter("negeri");
                String statusKeluarga = request.getParameter("statusKeluarga");

                Pengguna p = new Pengguna();
                p.setId_pengguna(idPengguna);
                p.setNombor_telefon(nomborTelefon);
                p.setNama_jalan(namaJalan);
                p.setBandar(bandar);
                p.setNombor_poskod(nomborPoskod);
                p.setNegeri(negeri != null ? negeri : (pendudukLama != null ? pendudukLama.getNegeri() : null));
                p.setStatus_keluarga(statusKeluarga);

                boolean success = penggunaDAO.updatePengguna(p);

                if (success && pendudukLama != null) {
                    StringBuilder desc = new StringBuilder("Admin mengemaskini: ");
                    boolean changed = false;

                    if (isChanged(nomborTelefon, pendudukLama.getNombor_telefon())) {
                        String oldV = (pendudukLama.getNombor_telefon() == null || pendudukLama.getNombor_telefon().isEmpty()) ? "-" : pendudukLama.getNombor_telefon();
                        desc.append("No. Telefon (" + oldV + " -> " + nomborTelefon + "). ");
                        changed = true;
                    }

                    boolean addressChanged = false;
                    StringBuilder addrDesc = new StringBuilder("Alamat (");
                    if (isChanged(namaJalan, pendudukLama.getNama_jalan())) {
                        addrDesc.append("Jalan: " + (pendudukLama.getNama_jalan()==null?"-":pendudukLama.getNama_jalan()) + " -> " + namaJalan + "; ");
                        addressChanged = true;
                    }
                    if (isChanged(bandar, pendudukLama.getBandar())) {
                        addrDesc.append("Bandar: " + (pendudukLama.getBandar()==null?"-":pendudukLama.getBandar()) + " -> " + bandar + "; ");
                        addressChanged = true;
                    }
                    if (isChanged(nomborPoskod, pendudukLama.getNombor_poskod())) {
                        addrDesc.append("Poskod: " + (pendudukLama.getNombor_poskod()==null?"-":pendudukLama.getNombor_poskod()) + " -> " + nomborPoskod + "; ");
                        addressChanged = true;
                    }
                    if (isChanged(negeri, pendudukLama.getNegeri())) {
                        addrDesc.append("Negeri: " + (pendudukLama.getNegeri()==null?"-":pendudukLama.getNegeri()) + " -> " + negeri + "; ");
                        addressChanged = true;
                    }
                    addrDesc.append("). ");

                    if (addressChanged) {
                        desc.append(addrDesc.toString());
                        changed = true;
                    }

                    if (isChanged(statusKeluarga, pendudukLama.getStatus_keluarga())) {
                        String oldS = (pendudukLama.getStatus_keluarga() == null) ? "N/A" : pendudukLama.getStatus_keluarga();
                        desc.append("Status Keluarga (" + oldS + " -> " + statusKeluarga + "). ");
                        changed = true;
                    }

                    if (changed) {
                        ActivityLogDAO logDAO = new ActivityLogDAO(conn);
                        Pengguna admin = (Pengguna) request.getSession().getAttribute("currentUser");
                        if (admin != null) {
                            logDAO.insertLog(new ActivityLog(idPengguna, admin.getId_pengguna(), "KEMASKINI_PROFIL", desc.toString()));
                        }
                    }
                }

                String redirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
                response.sendRedirect(request.getContextPath() + redirect + "?status=updated");
            }

            // 4. LOGIC APPROVE
            else if ("/penduduk/approve".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                penggunaDAO.updateStatus(id, 1); 
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=approved");
            }

            // 5. LOGIC REJECT
            else if ("/penduduk/reject".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                penggunaDAO.updateStatus(id, 0); 
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=rejected");
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorRedirect = action.contains("ketua") ? "/ketua/urus" : "/penduduk/urus";
            response.sendRedirect(request.getContextPath() + errorRedirect + "?error=systemError");
        }
    }

    private boolean isChanged(String newVal, String oldVal) {
        String n = (newVal == null) ? "" : newVal.trim();
        String o = (oldVal == null) ? "" : oldVal.trim();
        return !n.equals(o);
    }
}