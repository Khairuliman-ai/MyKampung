<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Bantuan" %>
<%@ page import="model.Pengguna" %>
<html>
<head>
    <title>Mohon Bantuan | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; color: #334155; }
        
        /* Sidebar Styling (Konsisten dengan Dashboard) */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            background: #ffffff;
            border-right: 1px solid #e2e8f0;
            padding: 24px 0;
        }
        .sidebar-brand { padding: 0 24px 32px; display: flex; align-items: center; gap: 12px; }
        .brand-logo { background: #10b981; color: white; padding: 8px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        
        .nav-link { 
            padding: 12px 24px; 
            color: #64748b; 
            display: flex; 
            align-items: center;
            font-weight: 500;
            margin: 4px 16px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .nav-link i { margin-right: 14px; font-size: 1.2rem; }
        .nav-link:hover { background-color: #f1f5f9; color: #10b981; }
        .nav-link.active { background: #ecfdf5; color: #10b981; }

        /* Main Content */
        .main-content { margin-left: 260px; min-height: 100vh; }
        
        /* Top Bar */
        .top-bar { 
            background: #ffffff; 
            padding: 16px 40px; 
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* Form Styling */
        .page-header-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 30px;
            border: none;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            border: none;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            max-width: 900px;
        }
        
        .form-label { font-weight: 600; color: #1e293b; margin-bottom: 8px; font-size: 0.9rem; }
        
        .form-control, .form-select {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 12px 15px;
            transition: 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            background: #fff;
            border-color: #10b981;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }
        
        .btn-submit {
            background: #10b981;
            color: #fff;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            border: none;
            transition: 0.3s;
        }
        .btn-submit:hover { background: #059669; color: white; transform: translateY(-2px); }
        
        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .btn-cancel:hover { background: #e2e8f0; color: #1e293b; }

        .helper-text { font-size: 0.8rem; color: #64748b; margin-top: 6px; }
        .icon-header { background: #f0fdf4; color: #10b981; width: 60px; height: 60px; border-radius: 15px; display: flex; align-items: center; justify-content: center; }
    </style>
</head>
<body>
    <%
        HttpSession sess = request.getSession();
        Pengguna user = (Pengguna) sess.getAttribute("user");
        String role = (user != null) ? user.getJawatan() : "Penduduk";
    %>

    <div class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo"><i class="bi bi-houses-fill"></i></div>
            <div>
                <h6 class="mb-0 fw-bold">Kampung Danan</h6>
                <small class="text-muted" style="font-size: 11px;">Portal Penduduk</small>
            </div>
        </div>
        <nav class="nav flex-column">
            <a class="nav-link" href="../dashboard.jsp"><i class="bi bi-grid"></i> Papan Pemuka</a>
            <a class="nav-link" href="#"><i class="bi bi-person"></i> Profil Saya</a>
            <a class="nav-link active" href="#"><i class="bi bi-hand-index-thumb-fill"></i> Bantuan</a>
            <a class="nav-link" href="#"><i class="bi bi-calendar4-event"></i> Tempahan</a>
            <a class="nav-link" href="#"><i class="bi bi-exclamation-circle"></i> Aduan</a>
            <hr class="mx-3 my-3 text-muted">
            <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-right"></i> Log Keluar</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="top-bar">
            <div class="search-container position-relative" style="width: 300px;">
                <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                <input type="text" class="form-control ps-5 py-2 border-0 bg-light" placeholder="Cari bantuan...">
            </div>
            <div class="d-flex align-items-center">
                <i class="bi bi-bell me-4 fs-5"></i>
                <div class="text-end me-3">
                    <div class="fw-bold small lh-1"><%= (user != null) ? user.getNamaPertama() : "User" %></div>
                    <small class="text-muted" style="font-size: 11px;"><%= role %></small>
                </div>
                <div class="bg-success rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 35px; height: 35px; font-size: 12px;">
                    <%= (user != null) ? user.getNamaPertama().substring(0,1).toUpperCase() : "U" %>
                </div>
            </div>
        </div>

        <div class="p-5">
            <div class="page-header-card">
                <div>
                    <h4 class="fw-bold mb-1">MOHON BANTUAN</h4>
                    <p class="text-muted mb-0 small">Lengkapkan borang di bawah untuk menghantar permohonan bantuan asnaf/kebajikan.</p>
                </div>
                <div class="icon-header">
                    <i class="bi bi-hand-index-thumb fs-2"></i>
                </div>
            </div>

            <div class="form-container mx-auto">
                <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data">
                    <div class="mb-4">
                        <label for="idBantuan" class="form-label">Jenis Bantuan yang Dimohon</label>
                        <select class="form-select" id="idBantuan" name="idBantuan" required>
                            <option value="" selected disabled>Pilih salah satu bantuan...</option>
                            <% 
                                List<Bantuan> bantuanList = (List<Bantuan>) request.getAttribute("bantuanList");
                                if(bantuanList != null) {
                                    for (Bantuan b : bantuanList) { 
                            %>
                                <option value="<%= b.getIdBantuan() %>">
                                    <%= b.getNamaBantuan() %>
                                </option>
                            <% 
                                    }
                                } 
                            %>
                        </select>
                        <div class="helper-text"><i class="bi bi-info-circle me-1"></i> Pilih kategori bantuan yang paling sesuai dengan situasi anda.</div>
                    </div>

                    <div class="mb-4">
                        <label for="catatan" class="form-label">Alasan / Catatan Tambahan</label>
                        <textarea class="form-control" id="catatan" name="catatan" rows="5" placeholder="Sila jelaskan keadaan anda secara ringkas untuk memudahkan penilaian..." required></textarea>
                    </div>

                    <div class="mb-4">
                        <label for="dokumen" class="form-label">Dokumen Sokongan</label>
                        <div class="p-4 border border-dashed rounded-3 text-center bg-light">
                            <i class="bi bi-file-earmark-pdf fs-1 text-danger mb-2 d-block"></i>
                            <input type="file" class="form-control mt-2" id="dokumen" name="dokumen" accept="application/pdf" required>
                            <p class="helper-text text-danger fw-bold mb-0 mt-3">
                                <i class="bi bi-exclamation-circle"></i> Pastikan format PDF sahaja (Salinan IC, Penyata Gaji, atau Surat Perakuan).
                            </p>
                        </div>
                    </div>

                    <div class="mt-5 d-flex gap-3">
                        <button type="submit" class="btn btn-submit shadow-sm">
                            <i class="bi bi-send me-2"></i>Hantar Permohonan
                        </button>
                        <a href="list" class="btn btn-cancel">
                            Batal
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>