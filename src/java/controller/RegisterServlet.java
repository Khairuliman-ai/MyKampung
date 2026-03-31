package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Ambil Data dari Borang (Guna snake_case supaya konsisten dengan ERD)
            String nama_penuh = request.getParameter("nama_penuh");
            String nombor_kp = request.getParameter("nombor_ic"); // Tukar jika name di JSP berbeza
            String nombor_telefon = request.getParameter("nombor_telefon");
            String kata_laluan = request.getParameter("kata_laluan");
            String alamat_raw = request.getParameter("alamat");

            // 2. Set Data ke Model Pengguna
            Pengguna p = new Pengguna();
            p.setNama_penuh(nama_penuh);
            p.setNombor_kp(nombor_kp);
            p.setNombor_telefon(nombor_telefon);
            p.setKata_laluan(kata_laluan);
            p.setNama_jalan(alamat_raw); // Simpan alamat penuh dalam kolum nama_jalan buat sementara
            
            // Default values untuk elak Null Constraint di Database
            p.setBandar("-");
            p.setNegeri("-");
            p.setNombor_poskod("-");

            // A. Auto-Extract Tarikh Lahir dari Nombor IC (Format: YYMMDDxxxxxx)
            if (nombor_kp != null && nombor_kp.length() >= 6) {
                try {
                    String datePart = nombor_kp.substring(0, 6);
                    SimpleDateFormat sdfIC = new SimpleDateFormat("yyMMdd");
                    Date dob = sdfIC.parse(datePart);
                    p.setTarikh_lahir(dob);
                } catch (Exception e) {
                    p.setTarikh_lahir(new Date()); // Fallback jika format IC pelik
                }
            }

            // 3. Simpan ke Database melalui DAO
            PenggunaDAO pDao = new PenggunaDAO();
            boolean isSuccess = pDao.daftarPengguna(p); 

            // 4. Redirect berdasarkan keputusan
            if (isSuccess) {
                // Status automatik 0 dalam DAO, jadi beri mesej tunggu pengesahan
                String msg = "Pendaftaran berjaya. Sila tunggu pengesahan daripada Ketua Kampung.";
                response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?success=" + java.net.URLEncoder.encode(msg, "UTF-8"));
            } else {
                request.setAttribute("error", "Pendaftaran gagal. Sila cuba lagi.");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ralat sistem: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }
}