<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<html>
<head>
    <title>Papan Pemuka - Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; color: #334155; }
        
        /* Sidebar Styling */
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
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .search-container { position: relative; width: 350px; }
        .search-container i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
        .search-input { background: #f8fafc; border: 1px solid #e2e8f0; padding: 8px 15px 8px 40px; border-radius: 10px; width: 100%; outline: none; transition: 0.3s; }
        .search-input:focus { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }
        
        /* Stat Cards */
        .stat-card {
            border: none;
            border-radius: 16px;
            padding: 24px;
            background: #ffffff;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 16px; }
        
        /* Colors for icons */
        .bg-penduduk { background: #ecfdf5; color: #10b981; }
        .bg-acara { background: #eff6ff; color: #3b82f6; }
        .bg-kemudahan { background: #f5f3ff; color: #8b5cf6; }
        .bg-aduan { background: #fff7ed; color: #f97316; }
        
        .trend-up { color: #10b981; font-size: 0.85rem; font-weight: 600; }
        .trend-down { color: #ef4444; font-size: 0.85rem; font-weight: 600; }

        .card-title { color: #64748b; font-size: 0.9rem; font-weight: 500; margin-bottom: 4px; }
        .card-value { font-size: 1.75rem; font-weight: 700; color: #1e293b; }

        /* Badge Styling */
        .badge-soft-success { background: #dcfce7; color: #15803d; }
        .badge-soft-warning { background: #fef9c3; color: #854d0e; }
        
        .section-card { background: #fff; border-radius: 16px; border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
    <%
        HttpSession sess = request.getSession();
        Pengguna user = (Pengguna) sess.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = user.getJawatan();
    %>

    <div class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo"><i class="bi bi-houses-fill"></i></div>
            <div>
                <h6 class="mb-0 fw-bold">Kampung Danan</h6>
                <small class="text-muted" style="font-size: 11px;">Portal Pengurusan</small>
            </div>
        </div>
        <nav class="nav flex-column">
            <a class="nav-link active" href="dashboard.jsp"><i class="bi bi-grid"></i> Papan Pemuka</a>
            
            <% if ("Penduduk".equals(role)) { %>
                <a class="nav-link" href="#"><i class="bi bi-person"></i> Profil Saya</a>
                <a class="nav-link" href="bantuan/list"><i class="bi bi-hand-index-thumb"></i> Bantuan</a>
            <% } else { %>
                <a class="nav-link" href="#"><i class="bi bi-people"></i> Penduduk</a>
                <a class="nav-link" href="bantuan/list"><i class="bi bi-hand-index-thumb"></i> Bantuan</a>
                <a class="nav-link" href="#"><i class="bi bi-building"></i> Kemudahan</a>
            <% } %>
            
            <a class="nav-link" href="#"><i class="bi bi-calendar4-event"></i> Tempahan</a>
            <a class="nav-link" href="#"><i class="bi bi-exclamation-circle"></i> Aduan</a>
            <a class="nav-link" href="#"><i class="bi bi-megaphone"></i> Hebahan</a>
            <a class="nav-link" href="#"><i class="bi bi-file-earmark-text"></i> Laporan</a>
            <hr class="mx-3 my-3 text-muted">
            <a class="nav-link" href="#"><i class="bi bi-gear"></i> Tetapan</a>
            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/logout">
    <i class="bi bi-box-arrow-right"></i> Log Keluar
</a>

        </nav>
    </div>

    <div class="main-content">
        <div class="top-bar">
            <div class="search-container">
                <i class="bi bi-search"></i>
                <input type="text" class="search-input" placeholder="Cari...">
            </div>
            <div class="d-flex align-items-center">
                <div class="position-relative me-4">
                    <i class="bi bi-bell fs-5"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge border border-light rounded-circle bg-danger p-1"><span class="visually-hidden">unread messages</span></span>
                </div>
                <div class="text-end me-3">
                    <div class="fw-bold small lh-1"><%= user.getNamaPertama() %> bin Abdullah</div>
                    <small class="text-muted" style="font-size: 11px;"><%= role %></small>
                </div>
                <div class="bg-success rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 40px; height: 40px; font-size: 14px;">
                    <%= user.getNamaPertama().substring(0,1).toUpperCase() %>
                </div>
            </div>
        </div>

        <div class="p-4 px-5">
            <div class="mb-4">
                <h4 class="fw-bold mb-1">Papan Pemuka</h4>
                <p class="text-muted">Selamat datang! Berikut adalah maklumat terkini kampung anda.</p>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="icon-box bg-penduduk"><i class="bi bi-people"></i></div>
                            <span class="trend-up"><i class="bi bi-arrow-up-short"></i> +2.3%</span>
                        </div>
                        <div class="card-title">Jumlah Penduduk</div>
                        <div class="card-value">1,247</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="icon-box bg-acara"><i class="bi bi-calendar-event"></i></div>
                            <span class="trend-up"><i class="bi bi-arrow-up-short"></i> +1</span>
                        </div>
                        <div class="card-title">Acara Bulan Ini</div>
                        <div class="card-value">8</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="icon-box bg-kemudahan"><i class="bi bi-building"></i></div>
                            <span class="text-muted small">0%</span>
                        </div>
                        <div class="card-title">Kemudahan Awam</div>
                        <div class="card-value">15</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="icon-box bg-aduan"><i class="bi bi-exclamation-triangle"></i></div>
                            <span class="trend-down"><i class="bi bi-arrow-down-short"></i> -4</span>
                        </div>
                        <div class="card-title">Aduan Aktif</div>
                        <div class="card-value">12</div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-8">
                    <div class="card section-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold mb-0">Aktiviti Terkini</h5>
                            <button class="btn btn-sm btn-outline-secondary">Lihat Semua</button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="border-0">Aktiviti</th>
                                        <th class="border-0">Tarikh</th>
                                        <th class="border-0">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="fw-bold">Permohonan Bantuan Bakul Makanan</div>
                                            <small class="text-muted">Ahmad bin Ali</small>
                                        </td>
                                        <td>02 Jan 2026</td>
                                        <td><span class="badge badge-soft-warning px-3 py-2">Dalam Proses</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="fw-bold">Tempahan Dewan Orang Ramai</div>
                                            <small class="text-muted">Siti Aminah</small>
                                        </td>
                                        <td>31 Dis 2025</td>
                                        <td><span class="badge badge-soft-success px-3 py-2">Berjaya</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card section-card p-4">
                        <h5 class="fw-bold mb-3">Tindakan Segera</h5>
                        <% if (!"Penduduk".equals(role)) { %>
                            <div class="p-3 bg-light rounded-3 mb-3">
                                <p class="small text-muted mb-2">Kelulusan Bantuan Baru</p>
                                <div class="fw-bold mb-3">Mohd Zaki (Zakat)</div>
                                <div class="d-grid gap-2 d-md-flex">
                                    <button class="btn btn-success btn-sm flex-grow-1">Lulus</button>
                                    <button class="btn btn-outline-danger btn-sm flex-grow-1">Tolak</button>
                                </div>
                            </div>
                        <% } %>
                        <div class="alert alert-info border-0 small">
                            <i class="bi bi-info-circle me-2"></i> Anda mempunyai 3 mesyuarat jawatankuasa minggu ini.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>