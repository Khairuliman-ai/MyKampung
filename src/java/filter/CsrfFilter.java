package filter;

import java.io.IOException;
import java.util.UUID;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * CsrfFilter implements the Synchronizer Token Pattern to prevent Cross-Site Request Forgery (CSRF) attacks.
 * It automatically generates a secure, random CSRF token on GET requests and associates it with the HTTP session.
 * For POST requests, it verifies that the incoming request contains a matching token parameter (_csrf).
 */
public class CsrfFilter implements Filter {
    private static final String TOKEN_KEY = "csrf_token";

    /**
     * Intercepts incoming requests to generate or validate CSRF tokens.
     * Whitelists specific AJAX, stats, API, and password reset endpoints to bypass validation checks.
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
        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();

        // Skip AJAX/API and unauthenticated recovery endpoints
        if (uri.contains("/notifikasi/") || uri.contains("/chatbot/")
                || uri.contains("/getSlots") || uri.contains("/getLogs") || uri.contains("/getBookingConfig")
                || uri.contains("/stats/")
                || uri.contains("ForgotPass") || uri.contains("VerifyOTP")
                || uri.contains("UpdatePassword")) {
            chain.doFilter(req, res);
            return;
        }

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            // Generate token on GET (ensure session exists)
            HttpSession activeSession = request.getSession(true);
            String token = (String) activeSession.getAttribute(TOKEN_KEY);
            if (token == null) {
                token = UUID.randomUUID().toString();
                activeSession.setAttribute(TOKEN_KEY, token);
            }
            chain.doFilter(req, res);
        } else if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Validate token on POST
            if (session == null) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No session");
                return;
            }
            String sessionToken = (String) session.getAttribute(TOKEN_KEY);
            String formToken = request.getParameter("_csrf");
            if (sessionToken == null || !sessionToken.equals(formToken)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
            chain.doFilter(req, res);
        } else {
            chain.doFilter(req, res);
        }
    }

    /**
     * Initializes the filter configuration.
     * 
     * @param fc the filter configuration
     */
    @Override public void init(FilterConfig fc) {}

    /**
     * Cleans up filter resources on shutdown.
     */
    @Override public void destroy() {}
}
