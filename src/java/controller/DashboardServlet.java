package controller;

import model.Pengguna;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1️⃣ Check session
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/views/auth/login.jsp");
            return;
        }

        Pengguna user = (Pengguna) session.getAttribute("user");
        String role = user.getJawatan();

        // 2️⃣ Role-based dashboard routing
        if ("Penduduk".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dPenduduk.jsp")
                   .forward(request, response);

        } else if ("Ketua Kampung".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dKetuaKampung.jsp")
                   .forward(request, response);

        } else if ("JKKK".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/views/dashboard/dJKKK.jsp")
                   .forward(request, response);

        } else {
            // fallback if role unknown
            response.sendRedirect("/views/auth/login.jsp");
        }
    }
}
