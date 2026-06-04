package filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * AuthFilter acts as a session guard, blocking unauthenticated users from accessing protected JSP pages.
 * Whitelists authentication screens, landing pages, and public resource folders.
 * Redirects unauthorized users to the login screen with a session_expired warning parameter.
 */
public class AuthFilter implements Filter {

    /**
     * Filters requests to ensure the resident/admin session exists.
     * Checks if the "currentUser" session attribute is set.
     * 
     * @param req the servlet request
     * @param res the servlet response
     * @param chain the filter chain
     * @throws IOException if an I/O error occurs
     * @throws ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String uri = request.getRequestURI();

        // Whitelist: allow auth pages, landing, static resources
        if (uri.contains("/views/auth/") || uri.contains("/views/landing/")
                || uri.contains("/views/error/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp?error=session_expired");
            return;
        }
        chain.doFilter(req, res);
    }

    /**
     * Initializes the filter configuration.
     * 
     * @param filterConfig the filter configuration
     */
    @Override public void init(FilterConfig filterConfig) {}

    /**
     * Cleans up filter resources on shutdown.
     */
    @Override public void destroy() {}
}
