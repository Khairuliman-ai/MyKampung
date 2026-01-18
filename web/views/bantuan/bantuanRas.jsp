<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Bantuan Saya | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #059669 0%, #10b981 100%); /* Emerald Green */
            --secondary-bg: #f3f4f6;
            --card-bg: #ffffff;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
        }

        body {
            background-color: var(--secondary-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* Animation Entry */
        .fade-in-up {
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Modern Cards */
        .ecstatic-card {
            background: var(--card-bg);
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }

        .ecstatic-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        /* Header Styling */
        .page-header h4 {
            font-weight: 700;
            background: -webkit-linear-gradient(45deg, #059669, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
        }

        /* Button Styling */
        .btn-ecstatic {
            background: var(--primary-gradient);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 10px 24px;
            font-weight: 600;
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.4);
            transition: all 0.3s ease;
        }

        .btn-ecstatic:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.5);
            color: white;
        }

        /* Filter Bar */
        .filter-input {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 10px 15px;
            transition: border-color 0.3s;
        }
        .filter-input:focus {
            border-color: #10b981;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }
        .input-group-text {
            background: white;
            border: 2px solid #e5e7eb;
            border-right: none;
            border-radius: 12px 0 0 12px;
            color: #10b981;
        }
        .form-control.border-start-0, .form-select {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }

        /* Table Styling */
        .table {
            margin-bottom: 0;
            border-collapse: separate; 
            border-spacing: 0 5px; /* Space between rows */
        }
        
        .table thead th {
            border: none;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            color: var(--text-muted);
            font-weight: 600;
            padding: 15px 20px;
            background: #f9fafb;
        }

        .table tbody tr {
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            transition: all 0.2s;
        }

        .table tbody tr:hover {
            background: #f0fdf4; /* Light Green Tint */
            transform: scale(1.005);
        }

        .table td {
            border: none;
            vertical-align: middle;
            padding: 15px 20px;
            font-size: 0.9rem;
        }

        .table tbody tr td:first-child { border-radius: 10px 0 0 10px; }
        .table tbody tr td:last-child { border-radius: 0 10px 10px 0; }

        /* Badges */
        .status-badge {
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .bg-status-0 { background-color: #e0f2fe; color: #0284c7; } /* Blue - Process */
        .bg-status-1 { background-color: #dcfce7; color: #166534; } /* Green - Success */
        .bg-status-2 { background-color: #fee2e2; color: #991b1b; } /* Red - Rejected */

        /* Empty State */
        .empty-state {
            padding: 40px;
            text-align: center;
            color: #9ca3af;
        }
        .empty-state i { font-size: 3rem; margin-bottom: 10px; display: block; opacity: 0.5; }

        /* Modal Beautification */
        .modal-content { border-radius: 20px; border: none; overflow: hidden; }
        .modal-header { background: #f9fafb; border-bottom: 1px solid #e5e7eb; padding: 20px; }
        .modal-footer { border-top: none; padding: 20px; background: #f9fafb; }
    </style>
</head>
<body>
    <div class="container py-5 fade-in-up">
        
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-4 mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Berjaya!</strong> Rekod telah dikemaskini dengan jayanya.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-4 mb-4" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <strong>Ralat!</strong> <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-end mb-5 page-header">
            <div>
                <h4 class="mb-1">Rekod Bantuan Saya</h4>
                <p class="text-muted m-0 small">Pantau status permohonan terkini dan sejarah lampau anda.</p>
            </div>
            <button class="btn btn-ecstatic" data-bs-toggle="modal" data-bs-target="#modalMohon">
                <i class="bi bi-plus-lg me-2"></i> Mohon Baru
            </button>
        </div>

        <%
            // --- DATA PROCESSING LOGIC (SAME AS BEFORE) ---
            List<PermohonanBantuan> mainList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
            List<PermohonanBantuan> listProses = new ArrayList<>();
            List<PermohonanBantuan> listSejarah = new ArrayList<>();
            SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd"); // For Input Type Date
            SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd MMM yyyy"); // For Display (Pretty)
            
            if (mainList != null) {
                Collections.sort(mainList, (o1, o2) -> Integer.compare(o2.getIdPermohonan(), o1.getIdPermohonan()));
                for (PermohonanBantuan pb : mainList) {
                   // Status 0 (Baru), 2 (Hantar Balik), 3 (Pending Ketua) -> Masuk list PROSES
if (pb.getStatus() == 0 || pb.getStatus() == 2 || pb.getStatus() == 3) {
    listProses.add(pb);
} else {
    // Status 1 (Lulus) atau Reject Muktamad -> Masuk SEJARAH
    listSejarah.add(pb);
}
                }
            }
        %>

        <div class="ecstatic-card p-4 mb-5">
            <div class="row g-3 align-items-end">
                <div class="col-md-5">
                    <label class="form-label fw-bold small text-muted text-uppercase">Carian Pantas</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="text" id="searchInput" class="form-control border-start-0 filter-input" placeholder="Nama bantuan, keterangan..." onkeyup="filterData()">
                    </div>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted text-uppercase">Tarikh Mohon</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-calendar4-week"></i></span>
                        <input type="date" id="dateFilter" class="form-control border-start-0 filter-input" onchange="filterData()">
                    </div>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-bold small text-muted text-uppercase">Status Sejarah</label>
                    <select id="statusFilter" class="form-select filter-input" onchange="filterData()">
                        <option value="all">Semua Status</option>
                        <option value="1">Lulus (Disokong)</option>
                        <option value="2">Ditolak</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="mb-5">
            <h5 class="fw-bold mb-3 text-dark"><i class="bi bi-hourglass-split text-primary me-2"></i>Sedang Diproses</h5>
            <div class="ecstatic-card">
                <div class="table-responsive p-2">
                    <table class="table" id="tableProses">
                        <thead>
                            <tr>
                                <th class="ps-4">Tarikh</th>
                                <th>Jenis Bantuan</th>
                                <th>Dokumen</th>
                                <th>Keterangan</th>
                                <th>Ulasan JKKK</th>
                                <th>Status</th>
                                <th class="text-center">Tindakan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (!listProses.isEmpty()) { 
                                for (PermohonanBantuan pb : listProses) {
                                    String namaBantuan = "Tidak Diketahui";
                                    String keteranganDisplay = (pb.getCatatan() != null && !pb.getCatatan().isEmpty()) ? pb.getCatatan() : "-";
                                    int idB = pb.getIdBantuan();

                                    if (idB != 999) {
                                        if (idB == 6) namaBantuan = "BANTUAN AM";
                                        else if (idB == 7) namaBantuan = "BANTUAN HARI RAYA";
                                        else if (idB == 8) namaBantuan = "BANTUAN KEPADA GHARIMIN";
                                        else if (idB == 9) namaBantuan = "BANTUAN MELANJUT PELAJARAN KE IPT";
                                        else if (idB == 10) namaBantuan = "BANTUAN PEMBANGUNAN ASNAF";
                                        else if (idB == 11) namaBantuan = "BANTUAN PEMULIHAN RUMAH KEDIAMAN";
                                        else if (idB == 12) namaBantuan = "BANTUAN RAWATAN PERUBATAN";
                                        else if (idB == 13) namaBantuan = "BANTUAN SEWA RUMAH";
                                        else if (idB == 14) namaBantuan = "BANTUAN TETAP BULANAN";
                                        else if (idB == 15) namaBantuan = "BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)";
                                        else if (idB == 16) namaBantuan = "BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)";
                                        else if (idB == 17) namaBantuan = "BIASISWA PROFESIONAL PERAKAUNAN (BPP)";
                                        else if (idB == 18) namaBantuan = "PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)";
                                        else if (idB == 19) namaBantuan = "PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)";
                                        else if (idB == 20) namaBantuan = "SUMBANGAN IPT - FISABILILLAH";
                                    } else {
                                        String fullCatatan = pb.getCatatan();
                                        if (fullCatatan != null && !fullCatatan.isEmpty()) {
                                            String bersih = fullCatatan.replace("LAIN-LAIN: ", "");
                                            if (bersih.contains("|")) {
                                                String[] parts = bersih.split("\\|");
                                                namaBantuan = parts[0].trim();
                                                if (parts.length > 1) keteranganDisplay = parts[1].trim();
                                            } else {
                                                namaBantuan = bersih;
                                            }
                                        } else {
                                            namaBantuan = "LAIN-LAIN";
                                        }
                                    }
                                    String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                    String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                            %>
                            <tr class="data-row" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                                <td class="ps-4 text-nowrap fw-medium"><%= displayDate %></td>
                                <td class="fw-bold text-success search-col"><%= namaBantuan %></td>
                                <td>
                                    <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="btn btn-sm btn-light border text-muted"><i class="bi bi-file-earmark-pdf text-danger"></i> PDF</a>
                                    <% } else { %> - <% } %>
                                </td>
<td class="small text-muted" style="max-width: 200px;">
    <%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %>
</td>
                                <td class="small">
    <% if (pb.getStatus() == 2) { %>
        <span class="text-danger fw-bold">
            <i class="bi bi-exclamation-circle-fill me-1"></i>
            <%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "Sila kemaskini permohonan." %>
        </span>
    <% } else { %>
        <span class="text-muted">-</span>
    <% } %>
</td>
                                <td>
    <% if (pb.getStatus() == 0) { %>
        <span class="status-badge bg-status-0">
            <i class="bi bi-arrow-repeat me-1"></i> Dalam Proses
        </span>
        
    <% } else if (pb.getStatus() == 2) { %>
        <span class="status-badge bg-status-2">
            <i class="bi bi-exclamation-triangle-fill me-1"></i> Tidak Lengkap
        </span>
        
    <% } else if (pb.getStatus() == 3) { %>
        <span class="status-badge bg-status-3">
            <i class="bi bi-check-circle me-1"></i> Disemak JKKK
        </span>
    <% } %>
</td>
                               <td class="text-center">
    <% if (pb.getStatus() == 2) { %>
        <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" 
           class="btn btn-sm btn-warning fw-bold text-dark shadow-sm">
           <i class="bi bi-pencil-square"></i> Betulkan
        </a>
        
    <% } else if (pb.getStatus() == 0) { %>
        <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" class="btn btn-sm btn-outline-warning border-0 rounded-circle"><i class="bi bi-pencil-fill"></i></a>
        <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getIdPermohonan() %>" class="btn btn-sm btn-outline-danger border-0 rounded-circle" onclick="return confirm('Padam?');"><i class="bi bi-trash-fill"></i></a>
        
    <% } else { %>
        <span class="text-muted small"><i class="bi bi-lock-fill"></i></span>
    <% } %>
</td>
                            </tr>
                            <% } } else { %>
                                <tr class="no-data"><td colspan="7" class="empty-state"><i class="bi bi-inbox"></i>Tiada permohonan sedang diproses.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="mb-5">
            <h5 class="fw-bold mb-3 text-secondary"><i class="bi bi-clock-history me-2"></i>Sejarah Terdahulu</h5>
            <div class="ecstatic-card">
                <div class="table-responsive p-2">
                    <table class="table" id="tableSejarah">
                        <thead>
                            <tr>
                                <th class="ps-4">Tarikh</th>
                                <th>Jenis Bantuan</th>
                                <th>Dokumen</th>
                                <th>Keterangan</th>
                                <th>Ulasan Admin</th>
                                <th>Status</th>
                                <th>Surat</th>
                                <th class="text-center">Info</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (!listSejarah.isEmpty()) { 
                                for (PermohonanBantuan pb : listSejarah) {
                                    String statusClass = (pb.getStatus() == 1) ? "bg-status-1" : "bg-status-2";
                                    String statusText = (pb.getStatus() == 1) ? "Disokong" : "Ditolak";
                                    String iconStatus = (pb.getStatus() == 1) ? "bi-check-circle-fill" : "bi-x-circle-fill";

                                    String namaBantuan = "Tidak Diketahui";
                                    String keteranganDisplay = (pb.getCatatan() != null && !pb.getCatatan().isEmpty()) ? pb.getCatatan() : "-";
                                    int idB = pb.getIdBantuan();

                                    if (idB != 999) {
                                        if (idB == 6) namaBantuan = "BANTUAN AM";
                                        else if (idB == 7) namaBantuan = "BANTUAN HARI RAYA";
                                        else if (idB == 8) namaBantuan = "BANTUAN KEPADA GHARIMIN";
                                        else if (idB == 9) namaBantuan = "BANTUAN MELANJUT PELAJARAN KE IPT";
                                        else if (idB == 10) namaBantuan = "BANTUAN PEMBANGUNAN ASNAF";
                                        else if (idB == 11) namaBantuan = "BANTUAN PEMULIHAN RUMAH KEDIAMAN";
                                        else if (idB == 12) namaBantuan = "BANTUAN RAWATAN PERUBATAN";
                                        else if (idB == 13) namaBantuan = "BANTUAN SEWA RUMAH";
                                        else if (idB == 14) namaBantuan = "BANTUAN TETAP BULANAN";
                                        else if (idB == 15) namaBantuan = "BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)";
                                        else if (idB == 16) namaBantuan = "BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)";
                                        else if (idB == 17) namaBantuan = "BIASISWA PROFESIONAL PERAKAUNAN (BPP)";
                                        else if (idB == 18) namaBantuan = "PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)";
                                        else if (idB == 19) namaBantuan = "PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)";
                                        else if (idB == 20) namaBantuan = "SUMBANGAN IPT - FISABILILLAH";
                                    } else {
                                        String fullCatatan = pb.getCatatan();
                                        if (fullCatatan != null && !fullCatatan.isEmpty()) {
                                            String bersih = fullCatatan.replace("LAIN-LAIN: ", "");
                                            if (bersih.contains("|")) {
                                                String[] parts = bersih.split("\\|");
                                                namaBantuan = parts[0].trim();
                                                if (parts.length > 1) keteranganDisplay = parts[1].trim();
                                            } else {
                                                namaBantuan = bersih;
                                            }
                                        } else {
                                            namaBantuan = "LAIN-LAIN";
                                        }
                                    }
                                    String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                    String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                            %>
                            <tr class="data-row text-muted" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                                <td class="ps-4 text-nowrap"><%= displayDate %></td>
                                <td class="fw-bold search-col text-dark"><%= namaBantuan %></td>
                                <td>
                                    <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="text-decoration-none small text-muted"><i class="bi bi-paperclip"></i> Lihat</a>
                                    <% } else { %> - <% } %>
                                </td>
                                <td class="small search-col"><%= keteranganDisplay %></td>
                                <td class="small">-</td>
                                <td><span class="status-badge <%= statusClass %>"><i class="bi <%= iconStatus %> me-1"></i><%= statusText %></span></td>
                                <td>
                                    <% if (pb.getDokumenBalik() != null && !pb.getDokumenBalik().isEmpty()) { String enc = URLEncoder.encode(pb.getDokumenBalik(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/uploads/<%= enc %>" class="btn btn-sm btn-outline-success rounded-pill fw-bold" target="_blank"><i class="bi bi-download me-1"></i> Surat</a>
                                    <% } else { %> <span class="small text-muted">-</span> <% } %>
                                </td>
                                <td class="text-center"><span class="small text-muted"><i class="bi bi-lock-fill"></i> Selesai</span></td>
                            </tr>
                            <% } } else { %>
                                <tr class="no-data"><td colspan="8" class="empty-state"><i class="bi bi-archive"></i>Tiada sejarah permohonan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalMohon" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data">
                <div class="modal-content shadow-lg">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-file-earmark-plus-fill text-success me-2"></i>Permohonan Baru</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="alert alert-light border-0 shadow-sm mb-4">
                            <small class="text-muted"><i class="bi bi-info-circle me-1"></i> Sila pastikan semua maklumat adalah benar. Dokumen sokongan wajib dalam format <strong>PDF</strong>.</small>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-uppercase small text-muted">Jenis Bantuan</label>
                            <select name="jenisBantuan" id="jenisBantuan" class="form-select filter-input bg-light" required onchange="toggleLainBantuan()">
                                <option value="" disabled selected>-- Sila Pilih --</option>
                                <option value="6">BANTUAN AM</option>
                                <option value="7">BANTUAN HARI RAYA</option>
                                <option value="8">BANTUAN KEPADA GHARIMIN</option>
                                <option value="9">BANTUAN MELANJUT PELAJARAN KE IPT</option>
                                <option value="10">BANTUAN PEMBANGUNAN ASNAF</option>
                                <option value="11">BANTUAN PEMULIHAN RUMAH KEDIAMAN</option>
                                <option value="12">BANTUAN RAWATAN PERUBATAN</option>
                                <option value="13">BANTUAN SEWA RUMAH</option>
                                <option value="14">BANTUAN TETAP BULANAN</option>
                                <option value="15">BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)</option>
                                <option value="16">BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)</option>
                                <option value="17">BIASISWA PROFESIONAL PERAKAUNAN (BPP)</option>
                                <option value="18">PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)</option>
                                <option value="19">PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)</option>
                                <option value="20">SUMBANGAN IPT - FISABILILLAH</option>
                                <option value="999">LAIN-LAIN</option>
                            </select>
                        </div>
                        
                        <div class="mb-4 d-none animate__animated animate__fadeIn" id="lainBantuanDiv">
                            <label class="form-label fw-bold text-uppercase small text-muted text-primary">Nyatakan Jenis Bantuan</label>
                            <input type="text" name="jenisBantuanLain" class="form-control filter-input" placeholder="Contoh: Bantuan Bencana Alam">
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-uppercase small text-muted">Dokumen Sokongan (PDF)</label>
                                <input type="file" name="dokumenSokongan" class="form-control filter-input" accept="application/pdf" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-uppercase small text-muted">Keterangan / Sebab</label>
                                <textarea name="keterangan" class="form-control filter-input" rows="1" placeholder="Ringkasan permohonan..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light text-muted fw-bold" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-ecstatic">Hantar Permohonan</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function toggleLainBantuan() {
            const select = document.getElementById("jenisBantuan");
            const lainDiv = document.getElementById("lainBantuanDiv");
            const lainInput = lainDiv.querySelector("input");

            if (select.value === "999") {
                lainDiv.classList.remove("d-none");
                lainInput.required = true;
            } else {
                lainDiv.classList.add("d-none");
                lainInput.required = false;
                lainInput.value = "";
            }
        }

        function filterData() {
            const searchVal = document.getElementById("searchInput").value.toLowerCase();
            const dateVal = document.getElementById("dateFilter").value;
            const statusVal = document.getElementById("statusFilter").value;

            const rows = document.querySelectorAll(".data-row");

            rows.forEach(row => {
                const rowDate = row.getAttribute("data-date");
                const status = row.getAttribute("data-status");
                
                let textContent = "";
                row.querySelectorAll(".search-col").forEach(col => {
                    textContent += col.innerText.toLowerCase() + " ";
                });

                let showRow = true;

                // 1. Tapis Tarikh (Match Tepat)
                if (dateVal !== "" && rowDate !== dateVal) showRow = false;

                // 2. Tapis Status (Hanya untuk table sejarah)
                if (statusVal !== "all" && status !== "0") {
                    if (status !== statusVal) showRow = false;
                }

                // 3. Tapis Teks
                if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;

                row.style.display = showRow ? "" : "none";
            });
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>