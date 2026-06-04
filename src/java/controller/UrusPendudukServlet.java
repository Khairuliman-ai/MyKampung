package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.PenggunaDAO;
import dao.ActivityLogDAO;
import model.Pengguna;
import model.AhliKeluarga;
import model.ActivityLog;
import util.DBUtil;
import util.EmailUtil;
import java.sql.Connection;
import java.math.BigDecimal;

@WebServlet(name = "UrusPendudukServlet", urlPatterns = {
    "/penduduk/urus", "/penduduk/approve", "/penduduk/reject", "/penduduk/update",
    "/ketua/urus", "/ketua/lantik", "/ketua/update", "/ketua/gugurkan", "/ketua/tambahJawatan"
})
/**
 * UrusPendudukServlet handles administrative resident management.
 * It manages two distinct sub-namespaces based on role access:
 * <ul>
 *   <li>{@code /penduduk/*} (Setiausaha only) - Handles approving/rejecting new residents and updating resident profile data.</li>
 *   <li>{@code /ketua/*} (Ketua Kampung only) - Handles appointment of AJK members to specific portfolios, dismissing AJK members, and managing jawatan titles.</li>
 * </ul>
 * 
 * <p><strong>Audit Logs:</strong> Actions such as profile updates log audit trails in the {@code activity_log} database table.</p>
 */
public class UrusPendudukServlet extends HttpServlet {

    private PenggunaDAO penggunaDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try (Connection conn = DBUtil.getConnection()) {
            penggunaDAO = new PenggunaDAO();
            dao.JawatanDAO jawatanDAO = new dao.JawatanDAO();
            dao.AhliKeluargaDAO ahliKeluargaDAO = new dao.AhliKeluargaDAO(conn);

            if ("/penduduk/urus".equals(action)) {
                List<Pengguna> activeList = penggunaDAO.getAllActiveUsers();
                if (activeList != null) {
                    for (Pengguna p : activeList) {
                        p.setSenaraiAhliKeluarga(ahliKeluargaDAO.getByPenggunaId(p.getId_pengguna()));
                    }
                }
                List<Pengguna> pendingList = penggunaDAO.getPendingPenduduk();
                if (pendingList != null) {
                    for (Pengguna p : pendingList) {
                        p.setSenaraiAhliKeluarga(ahliKeluargaDAO.getByPenggunaId(p.getId_pengguna()));
                    }
                }
                // Retrieve family members who are not registered as independent accounts.
                // This ensures we can display the complete population of the village, including dependents.
                List<AhliKeluarga> familyOnlyList = ahliKeluargaDAO.getAllNonRegistered();

                request.setAttribute("pendingList", pendingList);
                request.setAttribute("activeList", activeList);
                request.setAttribute("familyOnlyList", familyOnlyList);
                request.getRequestDispatcher("/views/maklumatPenduduk/urusPendudukAJK.jsp").forward(request, response);
            } 
            else if ("/ketua/urus".equals(action)) {
                List<Pengguna> listAJK = penggunaDAO.getAllAJK();
                if (listAJK != null) {
                    for (Pengguna p : listAJK) {
                        p.setSenaraiAhliKeluarga(ahliKeluargaDAO.getByPenggunaId(p.getId_pengguna()));
                    }
                }
                List<Pengguna> listPenduduk = penggunaDAO.getAllActiveUsers();
                if (listPenduduk != null) {
                    for (Pengguna p : listPenduduk) {
                        p.setSenaraiAhliKeluarga(ahliKeluargaDAO.getByPenggunaId(p.getId_pengguna()));
                    }
                }
                List<Pengguna> listJawatan = jawatanDAO.getJawatanHolders();
                List<AhliKeluarga> familyOnlyList = ahliKeluargaDAO.getAllNonRegistered();

                request.setAttribute("listAJK", listAJK);
                request.setAttribute("listPenduduk", listPenduduk);
                request.setAttribute("listJawatan", listJawatan);
                request.setAttribute("familyOnlyList", familyOnlyList);
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
            penggunaDAO = new PenggunaDAO();
            dao.JawatanDAO jawatanDAO = new dao.JawatanDAO();

            // --- Route: /ketua/lantik — Appoint AJK to jawatan ---
            if ("/ketua/lantik".equals(action)) {
                int idPengguna = Integer.parseInt(request.getParameter("idPengguna"));
                int idJawatan = Integer.parseInt(request.getParameter("idJawatan"));
                
                // Appointment exclusivity rule: A specific JKKK biro can only be assigned to one AJK at a time.
                // If a biro is already occupied, the existing holder is automatically demoted.
                boolean success = jawatanDAO.lantikAJK(idPengguna, idJawatan);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=lantikSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=error");
                }
            }
            
            // --- Route: /ketua/gugurkan — Dismiss AJK from jawatan ---
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
            
            // --- Route: /ketua/tambahJawatan — Add new custom jawatan ---
            else if ("/ketua/tambahJawatan".equals(action)) {
                String namaJawatan = request.getParameter("namaJawatan");
                boolean success = jawatanDAO.tambahJawatan(namaJawatan);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=tambahJawatanSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ketua/urus?status=error");
                }
            }

            // --- Route: /penduduk/update or /ketua/update — Admin/Ketua update resident profile ---
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

            // --- Route: /penduduk/approve — Approve pending registration ---
            else if ("/penduduk/approve".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                Pengguna p = penggunaDAO.getPenggunaById(id);
                
                if (penggunaDAO.updateStatus(id, 1)) {
                    // Send status notification email in a background thread to prevent SMTP latency
                    // from blocking the main HTTP request-response cycle.
                    if (p != null && p.getEmail() != null) {
                        new Thread(() -> {
                            EmailUtil.sendRegistrationStatusEmail(p.getEmail(), p.getNama_penuh(), true);
                        }).start();
                    }
                }
                response.sendRedirect(request.getContextPath() + "/penduduk/urus?status=approved");
            }

            // --- Route: /penduduk/reject — Reject pending registration ---
            else if ("/penduduk/reject".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPengguna"));
                Pengguna p = penggunaDAO.getPenggunaById(id);
                
                if (penggunaDAO.updateStatus(id, 0)) {
                    // Send status notification email in a background thread to prevent SMTP latency
                    // from blocking the main HTTP request-response cycle.
                    if (p != null && p.getEmail() != null) {
                        new Thread(() -> {
                            EmailUtil.sendRegistrationStatusEmail(p.getEmail(), p.getNama_penuh(), false);
                        }).start();
                    }
                }
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