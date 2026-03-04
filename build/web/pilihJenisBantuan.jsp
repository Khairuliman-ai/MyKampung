<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>

 <%
        HttpSession sess = request.getSession();
        Pengguna user = (Pengguna) sess.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = user.getJawatan();
    %>

<!DOCTYPE html>
<html>
<head>
    <title>Pilih Jenis Bantuan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .bantuan-card {
            transition: transform 0.2s;
        }
        .bantuan-card:hover {
            transform: scale(1.02);
        }
    </style>
</head>

<body>
<div class="container mt-5">
    <h3 class="mb-4">Pilih Jenis Bantuan</h3>

    <div class="row g-4">

        <!-- Bantuan Rasmi -->
        <div class="col-md-6">
            <div class="card bantuan-card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title text-primary">
                        Bantuan Rasmi (Luar Kampung)
                    </h5>

                    <p class="card-text">
                        Bantuan daripada agensi kerajaan seperti JKM, Pejabat Daerah
                        atau kerajaan negeri.
                    </p>

                    <ul>
                        <li>Perlu sokongan Ketua Kampung</li>
                        <li>Kelulusan oleh agensi luar</li>
                        <li>Proses lebih formal</li>
                    </ul>

                    <!-- ✅ Redirect ke BantuanServlet?action=rasmi -->
                    <a href="<%= request.getContextPath() %>/bantuan/rasmi"
                       class="btn btn-primary w-100">
                        Mohon Bantuan Rasmi
                    </a>
                </div>
            </div>
        </div>

        <!-- Bantuan Komuniti -->
        <div class="col-md-6">
            <div class="card bantuan-card shadow-sm h-100">
                <div class="card-body">
                    <h5 class="card-title text-success">
                        Bantuan Komuniti (Dalam Kampung)
                    </h5>

                    <p class="card-text">
                        Bantuan segera yang diuruskan oleh pihak kampung
                        menggunakan dana atau sumbangan komuniti.
                    </p>

                    <ul>
                        <li>Kelulusan oleh Ketua Kampung</li>
                        <li>Jumlah bantuan terhad</li>
                        <li>Sesuai untuk kes kecemasan</li>
                    </ul>

                    <!-- ✅ Redirect ke BantuanServlet?action=komuniti -->
                    <a href="<%= request.getContextPath() %>/bantuan/komuniti"
                       class="btn btn-success w-100">
                        Mohon Bantuan Komuniti
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>
</body>
</html>
