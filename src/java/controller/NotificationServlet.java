package controller;

import dao.NotificationsDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Notifications;
import model.Pengguna;

/**
 * NotificationServlet handles HTTP JSON API endpoints for user notifications.
 * 
 * <h3>GET Routes (PathInfo):</h3>
 * <ul>
 *   <li>/count - Returns JSON object containing the number of unread notifications for the user.</li>
 *   <li>/list - Returns JSON array of the most recent 20 notifications for the user.</li>
 * </ul>
 * 
 * <h3>POST Routes:</h3>
 * <ul>
 *   <li>/baca - Marks a specific notification as read.</li>
 *   <li>/bacaSemua - Marks all notifications for the current user as read.</li>
 * </ul>
 */
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Not authorized\"}");
            return;
        }

        String path = req.getPathInfo();
        NotificationsDAO dao = new NotificationsDAO();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("/count".equals(path)) {
                int count = dao.countBelumBaca(user.getId_pengguna());
                resp.getWriter().write("{\"count\":" + count + "}");
            } else if ("/list".equals(path)) {
                List<Notifications> list = dao.getByPengguna(user.getId_pengguna(), 20);
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++) {
                    Notifications n = list.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":").append(n.getId_notification()).append(",")
                        .append("\"jenis\":\"").append(escapeJson(n.getJenis())).append("\",")
                        .append("\"tajuk\":\"").append(escapeJson(n.getTajuk())).append("\",")
                        .append("\"mesej\":\"").append(escapeJson(n.getMesej())).append("\",")
                        .append("\"pautan\":\"").append(escapeJson(n.getPautan() != null ? n.getPautan() : "")).append("\",")
                        .append("\"sudahBaca\":").append(n.isSudah_baca()).append(",")
                        .append("\"dibuat\":\"").append(n.getDibuat_pada()).append("\"")
                        .append("}");
                }
                json.append("]");
                resp.getWriter().write(json.toString());
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Invalid endpoint\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Internal server error\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Pengguna user = (Pengguna) session.getAttribute("currentUser");
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\":\"Not authorized\"}");
            return;
        }

        String path = req.getPathInfo();
        NotificationsDAO dao = new NotificationsDAO();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if ("/baca".equals(path)) {
                String idStr = req.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    boolean success = dao.tandaBaca(id, user.getId_pengguna());
                    resp.getWriter().write("{\"success\":" + success + "}");
                } else {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\":\"Missing notification id\"}");
                }
            } else if ("/bacaSemua".equals(path)) {
                boolean success = dao.tandaSemuaBaca(user.getId_pengguna());
                resp.getWriter().write("{\"success\":" + success + "}");
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\":\"Invalid endpoint\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"Internal server error\"}");
        }
    }

    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
