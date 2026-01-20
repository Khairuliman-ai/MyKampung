package controller;

import model.Pengguna;
import dao.PenggunaDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Ambil Data dari Borang (Nama input mesti sama dengan register.jsp)
            String nomborKP = request.getParameter("nomborKP");
            String namaLengkap = request.getParameter("namaLengkap");
            String noTelefon = request.getParameter("noTelefon");
            String alamat = request.getParameter("alamat");
            String kataLaluan = request.getParameter("kataLaluan");

            // 2. Set Data ke Model Pengguna
            Pengguna p = new Pengguna();
            p.setNomborKP(nomborKP);
            p.setNomborTelefon(noTelefon);
            p.setKataLaluan(kataLaluan);
            p.setJawatan("Penduduk"); // Default Role
            
            // A. Pecahkan Nama Lengkap kepada NamaPertama & NamaKedua (Untuk DB)
            if (namaLengkap != null && namaLengkap.contains(" ")) {
                String[] parts = namaLengkap.split(" ", 2); // Pecah dua sahaja
                p.setNamaPertama(parts[0]);
                p.setNamaKedua(parts[1]);
            } else {
                p.setNamaPertama(namaLengkap);
                p.setNamaKedua(""); 
            }

            // B. Auto-Extract Tarikh Lahir dari Nombor KP (Format IC: YYMMDDxxxxxx)
            // Ini mengelakkan NullPointerException
            try {
                if (nomborKP != null && nomborKP.length() >= 6) {
                    String datePart = nomborKP.substring(0, 6); // Ambil 6 digit pertama
                    SimpleDateFormat sdfIC = new SimpleDateFormat("yyMMdd");
                    Date dob = sdfIC.parse(datePart);
                    p.setTarikhLahir(dob);
                } else {
                    p.setTarikhLahir(new Date()); // Fallback date jika IC format salah
                }
            } catch (Exception e) {
                p.setTarikhLahir(new Date()); // Fallback date
            }

            // C. Mapping Alamat (Simpan semua dalam namaJalan sementara waktu)
            p.setNamaJalan(alamat);
            p.setBandar("-");       // Default value untuk elak error DB
            p.setNomborPoskod("-"); 
            p.setNegeri("-");       

            // 3. Simpan ke Database
            PenggunaDAO pDao = new PenggunaDAO();
            pDao.insert(p); // Status akan automatik jadi 0 (Pending) dalam DAO

            // NOTA: Kita abaikan insert ke table 'Penduduk' buat masa ini 
            // kerana borang register.jsp ringkas dan tidak minta info gaji/pekerjaan.
            // Maklumat ini boleh dikemaskini kemudian dalam profil.

            // 4. Redirect dengan mesej berjaya
            // Pastikan path ini betul ikut struktur folder web anda
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?success=Pendaftaran berjaya. Sila tunggu kelulusan JKKK.");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Pendaftaran gagal. Nombor KP mungkin telah wujud.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Ralat sistem: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }
}