<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Daftar Penduduk | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { 
            background: linear-gradient(135deg, #f0f2f5 0%, #e2e8f0 100%); 
            font-family: 'Inter', sans-serif; 
            min-height: 100vh;
            padding: 40px 0;
        }
        
        .register-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 700px;
            border: none;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        .brand-logo { 
            background: #10b981; 
            color: white; 
            width: 50px;
            height: 50px;
            border-radius: 12px; 
            display: flex; 
            align-items: center; 
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.5rem;
        }

        .header-text h3 { font-weight: 700; color: #1e293b; margin-bottom: 5px; }
        .header-text p { color: #64748b; font-size: 0.9rem; margin-bottom: 30px; }

        .section-title {
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            color: #10b981;
            letter-spacing: 1px;
            margin-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 8px;
        }

        .form-label { font-weight: 600; color: #475569; font-size: 0.85rem; }
        
        .form-control {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 10px 15px;
            transition: 0.3s;
        }
        
        .form-control:focus {
            background: #fff;
            border-color: #10b981;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }

        .btn-register {
            background: #10b981;
            color: white;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            margin-top: 20px;
            transition: 0.3s;
        }

        .btn-register:hover {
            background: #059669;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }

        .login-link { font-size: 0.9rem; color: #64748b; margin-top: 25px; }
        .login-link a { color: #10b981; text-decoration: none; font-weight: 600; }
        
        .input-group-text {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px 0 0 10px;
            color: #94a3b8;
        }
    </style>
</head>
<body>

    <div class="container d-flex justify-content-center">
        <div class="register-card shadow-lg">
            <div class="header-text text-center">
                <div class="brand-logo shadow-sm">
                    <i class="bi bi-person-plus-fill"></i>
                </div>
                <h3>Daftar Akaun</h3>
                <p>Sila lengkapkan maklumat penduduk di bawah</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger border-0 small mb-4" role="alert">
                    <i class="bi bi-exclamation-circle-fill me-2"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="register" method="post">
                <div class="section-title"><i class="bi bi-person me-2"></i>Maklumat Peribadi</div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="namaPertama" class="form-label">Nama Pertama</label>
                        <input type="text" class="form-control" id="namaPertama" name="namaPertama" placeholder="Contoh: Ahmad" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="namaKedua" class="form-label">Nama Kedua (Bapa)</label>
                        <input type="text" class="form-control" id="namaKedua" name="namaKedua" placeholder="Contoh: Bin Ali" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="nomborKP" class="form-label">Nombor Kad Pengenalan</label>
                        <input type="text" class="form-control" id="nomborKP" name="nomborKP" placeholder="900101035544" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="nomborTelefon" class="form-label">Nombor Telefon</label>
                        <input type="text" class="form-control" id="nomborTelefon" name="nomborTelefon" placeholder="0123456789">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="tarikhLahir" class="form-label">Tarikh Lahir</label>
                        <input type="date" class="form-control" id="tarikhLahir" name="tarikhLahir">
                    </div>
                    <div class="col-md-6 mb-4">
                        <label for="kataLaluan" class="form-label">Kata Laluan</label>
                        <input type="password" class="form-control" id="kataLaluan" name="kataLaluan" placeholder="Minima 8 aksara" required>
                    </div>
                </div>

                <div class="section-title"><i class="bi bi-geo-alt me-2"></i>Maklumat Alamat</div>
                <div class="mb-3">
                    <label for="namaJalan" class="form-label">Alamat Rumah / Nama Jalan</label>
                    <input type="text" class="form-control" id="namaJalan" name="namaJalan" placeholder="No. 123, Jalan Melati">
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="nomborPoskod" class="form-label">Poskod</label>
                        <input type="text" class="form-control" id="nomborPoskod" name="nomborPoskod" placeholder="16450">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="bandar" class="form-label">Bandar</label>
                        <input type="text" class="form-control" id="bandar" name="bandar" placeholder="Melor">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="negeri" class="form-label">Negeri</label>
                        <input type="text" class="form-control" id="negeri" name="negeri" value="Kelantan">
                    </div>
                </div>

                <div class="section-title mt-2"><i class="bi bi-briefcase me-2"></i>Sosio-Ekonomi</div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="statusSemasa" class="form-label">Status Semasa</label>
                        <input type="text" class="form-control" id="statusSemasa" name="statusSemasa" placeholder="Berkahwin/Bujang">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="pekerjaan" class="form-label">Pekerjaan</label>
                        <input type="text" class="form-control" id="pekerjaan" name="pekerjaan" placeholder="Buruh/Suri Rumah">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="pendapatan" class="form-label">Pendapatan (RM)</label>
                        <div class="input-group">
                            <span class="input-group-text small">RM</span>
                            <input type="number" class="form-control" id="pendapatan" name="pendapatan" placeholder="0.00">
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-register w-100 shadow-sm">
                    Daftar Akaun Penduduk <i class="bi bi-check2-circle ms-1"></i>
                </button>
            </form>

            <p class="text-center login-link">
                Sudah mempunyai akaun? <a href="login.jsp">Log Masuk Sekarang</a>
            </p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>