package controller;

import model.Pengguna;
import service.EligibilityService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "BantuanConfigServlet", urlPatterns = {"/bantuan/config", "/bantuan/config/save"})
public class BantuanConfigServlet extends HttpServlet {

    private final EligibilityService eligibilityService = new EligibilityService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String role = user.getNama_peranan();
        if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
            return;
        }

        request.setAttribute("rules", eligibilityService.getRulesList());
        request.setAttribute("povertyLine", eligibilityService.getPovertyLine());
        
        request.getRequestDispatcher("/views/bantuan/urusBantuanConfig.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String role = user.getNama_peranan();
        if (!"AJK".equalsIgnoreCase(role) && !"Ketua Kampung".equalsIgnoreCase(role) && !"AJK Kampung".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
            return;
        }

        try {
            double povertyLine = Double.parseDouble(request.getParameter("povertyLine"));
            double wIncome = Double.parseDouble(request.getParameter("weightIncome"));
            double wDependent = Double.parseDouble(request.getParameter("weightDependent"));
            double wFamily = Double.parseDouble(request.getParameter("weightFamily"));
            double wEmployment = Double.parseDouble(request.getParameter("weightEmployment"));

            // Total weight must equal 100
            double total = wIncome + wDependent + wFamily + wEmployment;
            if (Math.abs(total - 100.0) > 0.001) {
                response.sendRedirect(request.getContextPath() + "/bantuan/config?error=weight_sum");
                return;
            }

            eligibilityService.updatePovertyLine(povertyLine);

            Map<String, Double> weights = new HashMap<>();
            weights.put("INCOME_FACTOR", wIncome);
            weights.put("DEPENDENT_FACTOR", wDependent);
            weights.put("FAMILY_STATUS_FACTOR", wFamily);
            weights.put("EMPLOYMENT_STATUS_FACTOR", wEmployment);

            boolean success = eligibilityService.updateRuleWeights(weights);

            if (success) {
                // Recalculate all pending applications with new rules
                dao.PermohonanBantuanDAO pbDao = new dao.PermohonanBantuanDAO();
                java.util.List<model.PermohonanBantuan> pendingList = pbDao.getByStatus("BARU");
                if (pendingList != null) {
                    for (model.PermohonanBantuan pb : pendingList) {
                        eligibilityService.calculateEligibilityScore(pb);
                        pbDao.updateEligibilityData(pb.getId_permohonan(), pb.getEligibilityScore(),
                            pb.getEligibilityTier(), pb.getEligibilityFlags());
                    }
                }
                response.sendRedirect(request.getContextPath() + "/bantuan/config?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/bantuan/config?error=db");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bantuan/config?error=invalid_input");
        }
    }
}
