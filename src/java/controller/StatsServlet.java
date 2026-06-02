package controller;

import dao.PenggunaDAO;
import dao.PermohonanBantuanDAO;
import dao.TempahanFasilitiDAO;
import util.DBUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * StatsServlet provides live statistics in JSON format for the landing page.
 */
@WebServlet("/StatsServlet")
public class StatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            PenggunaDAO pDao = new PenggunaDAO();
            TempahanFasilitiDAO tDao = new TempahanFasilitiDAO();
            PermohonanBantuanDAO bDao = new PermohonanBantuanDAO();
            
            int totalPengguna = pDao.countAll();
            int totalTempahan = tDao.countAll();
            int totalBantuan = bDao.countAll();
            
            // Return simple JSON
            out.print("{");
            out.print("\"totalPengguna\":" + totalPengguna + ",");
            out.print("\"totalTempahan\":" + totalTempahan + ",");
            out.print("\"totalBantuan\":" + totalBantuan);
            out.print("}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"Database error\"}");
        }
    }
}
