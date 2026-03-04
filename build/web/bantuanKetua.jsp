<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
    <title>Pengurusan Bantuan | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; color: #334155; }
        
        /* Sidebar Styling (Konsisten) */
        .sidebar { width: 260px; height: 100vh; position: fixed; background: #fff; border-right: 1px solid #e2e8f0; padding: 24px 0; z-index: 1000; }
        .sidebar-brand { padding: 0 24px 32px; display: flex; align-items: center; gap: 12px; }
        .brand-logo { background: #10b981; color: white; padding: 8px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        .nav-link { padding: 12px 24px; color: #64748b; display: flex; align-items: center; font-weight: 500; margin: 4px 16px; border-radius: 8px; transition: 0.2s; text-decoration: none; }
        .nav-link i { margin-right: 14px; font-size: 1.2rem; }
        .nav-link:hover { background-color: #f1f5f9; color: #10b981; }
        .nav-link.active { background: #ecfdf5; color: #10b981; }

        /* Main Content */
        .main-content { margin-left: 260px; min-height: 100vh; padding-bottom: 50px; }
        .top-bar { background: #fff; padding: 16px 40px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
        
        /* Header & Action Bar */
        .page-header-card { background: #fff; border-radius: 16px; padding: 24px 32px; margin-bottom: 24px; border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center; }
        
        /* Table Styling */
        .table-container { background: #fff; border-radius: 16px; border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.05); overflow: hidden; }
        .table { margin-bottom: 0; }
        .table thead th { background-color: #f8fafc; text-transform: uppercase; font-size: 0.7rem; font-weight: 700; letter-spacing: 0.05em; padding: 16px 24px; border-bottom: 1px solid #e2e8f0; color: #64748b; }
        .table td { padding: 18px 24px; vertical-align: middle; border-bottom: 1px solid #f1f5f9; font-size: 0.875rem; color: #1e293b; }
        
        /* Badges */
        .badge-status { padding: 6px 12px; border-radius: 6px; font-weight: 600; font-size: 0.75rem; display: inline-block; }
        .bg-baru { background-color: #fef9c3; color: #854d0e; }
        .bg-lulus { background-color: #dcfce7; color: #15803d; }
        .bg-tolak { background-color: #fee2e2; color: #b91c1c; }
        
        /* Buttons */
        .btn-add { background: #10b981; color: #fff; border-radius: 10px; padding: 10px 20px; font-weight: 600; border: none; transition: 0.3s; }
        .btn-add:hover { background: #059669; color: white; transform: translateY(-2px); }
        
        .action-btn { width: 32px; height: 32px; border-radius: 8px; border: 1px solid #e2e8f0; display: inline-flex; align-items: center; justify-content: center; background: #fff; color: #64748b; transition: 0.2s; }
        .action-btn:hover { background: #f8fafc; border-color: #cbd5e1; color: #1e293b; }
        .btn-view-pdf { color: #3b82f6; text-decoration: none; font-weight: 600; display: flex; align-items: center; gap: 6px; }
        .btn-view-pdf:hover { color: #2563eb; }
    </style>
</head>
<body>
    <%
        HttpSession sess = request.getSession();
        Pengguna user = (Pengguna) sess.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String role = user.getJawatan();
        boolean isKetua = "Ketua Kampung".equalsIgnoreCase(role);
    %>

    <div class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-logo"><i class="bi bi-houses-fill"></i></div>
            <div>
                <h6 class="mb-0 fw-bold">Kampung Danan</h6>
                <small class="text-muted" style="font-size: 11px;">Portal <%= role %></small>
            </div>
        </div>
        <nav class="nav flex-column">
            <a class="nav-link" href="<%= request.getContextPath() %>/dashboard.jsp"><i class="bi bi-grid"></i> Papan Pemuka</a>
            <% if(isKetua) { %><a class="nav-link" href="#"><i class="bi bi-people"></i> Penduduk</a><% } %>
            <a class="nav-link active" href="#"><i class="bi bi-hand-index-thumb-fill"></i> Bantuan</a>
            <a class="nav-link" href="#"><i class="bi bi-calendar4-event"></i> Tempahan</a>
            <a class="nav-link" href="#"><i class="bi bi-exclamation-circle"></i> Aduan</a>
            <hr class="mx-3 my-3 text-muted">
            <a class="nav-link text-danger" href="<%= request.getContextPath() %>/logout"><i class="bi bi-box-arrow-right"></i> Log Keluar</a>
        </nav>
    </div>

    <div class="main-content">
        <div class="top-bar">
            <div class="position-relative" style="width: 350px;">
                <i class="bi bi-search position-absolute top-50 start-0 translate-middle-y ms-3 text-muted"></i>
                <input type="text" class="form-control ps-5 border-0 bg-light py-2" placeholder="Cari permohonan...">
            </div>
            <div class="d-flex align-items-center">
                <i class="bi bi-bell me-4 fs-5 text-muted"></i>
                <div class="text-end me-3">
                    <div class="fw-bold small lh-1"><%= user.getNamaPertama() %></div>
                    <small class="text-muted" style="font-size: 11px;"><%= role %></small>
                </div>
                <div class="bg-success rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 38px; height: 38px; font-size: 14px;">
                    <%= user.getNamaPertama().substring(0,1).toUpperCase() %>
                </div>
            </div>
        </div>

        <div class="p-4 px-5">
            <div class="page-header-card shadow-sm">
                <div>
                    <h4 class="fw-bold mb-1"><%= isKetua ? "Pengurusan Bantuan" : "Senarai Permohonan Saya" %></h4>
                    <p class="text-muted mb-0 small"><%= isKetua ? "Semak dan sahkan permohonan bantuan penduduk kampung." : "Semak permohonan tandatangan di sini. " %></p>
                </div>
                <% if(!isKetua) { %>
                    <a href="<%= request.getContextPath() %>/bantuan" class="btn btn-add shadow-sm">
                        <i class="bi bi-plus-lg me-2"></i>PERMOHONAN BAHARU
                    </a>
                <% } %>
            </div>

            <div class="table-container">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th><%= isKetua ? "Pemohon (ID)" : "Jenis Bantuan" %></th>
                            <th>Tarikh Mohon</th>
                            <th>Status</th>
                            <th>Dokumen</th>
                            <th class="text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
                            if (list != null && !list.isEmpty()) {
                                for (PermohonanBantuan pb : list) {
                                    String statusClass = pb.getStatus() == 0 ? "bg-baru" : (pb.getStatus() == 1 ? "bg-lulus" : "bg-tolak");
                                    String statusLabel = pb.getStatus() == 0 ? "Baharu" : (pb.getStatus() == 1 ? "Lulus" : "Ditolak");
                        %>
                            <tr>
                                <td class="fw-bold text-muted">#<%= pb.getIdPermohonan() %></td>
                                <td>
                                    <div class="fw-semibold"><%= isKetua ? "ID Penduduk: " + pb.getIdPenduduk() : "ID Bantuan: " + pb.getIdBantuan() %></div>
                                </td>
                                <td><%= pb.getTarikhMohon() %></td>
                                <td><span class="badge-status <%= statusClass %>"><%= statusLabel %></span></td>
                                <td>
                                    <% if (pb.getDokumen() != null && !pb.getDokumen().trim().isEmpty()) { 
                                        String encodedFileName = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/uploads/<%= encodedFileName %>" target="_blank" class="btn-view-pdf">
                                            <i class="bi bi-file-earmark-pdf-fill text-danger"></i> Lihat PDF
                                        </a>
                                    <% } else { %>
                                        <span class="text-muted small italic">Tiada fail</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <div class="d-flex justify-content-center gap-2">
                                    <% if(isKetua) { %>
                                        <form action="<%= request.getContextPath() %>/bantuan/approve" method="POST" class="m-0">
                                            <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                                            <button type="submit" class="action-btn text-success" title="Luluskan"><i class="bi bi-check-circle-fill"></i></button>
                                        </form>
                                        <form action="<%= request.getContextPath() %>/bantuan/reject" method="POST" class="m-0">
                                            <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                                            <button type="submit" class="action-btn text-danger" title="Tolak"><i class="bi bi-x-circle-fill"></i></button>
                                        </form>
                                    <% } else if (pb.getStatus() == 0) { %>
                                        <form action="<%= request.getContextPath() %>/bantuan/delete" method="POST" onsubmit="return confirm('Padam permohonan ini?');" class="m-0">
                                            <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger px-3"><i class="bi bi-trash me-1"></i> Batal</button>
                                        </form>
                                    <% } else { %>
                                        <span class="text-muted small">-</span>
                                    <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="6" class="text-center p-5 text-muted"><i class="bi bi-inbox fs-2 d-block mb-2"></i>Tiada permohonan ditemui.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>