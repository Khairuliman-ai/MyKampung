<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %> 
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Bantuan Komuniti | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Warna tema Biru/Indigo untuk Bantuan Komuniti */
            --primary-gradient: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            --secondary-bg: #f3f4f6;
            --card-bg: #ffffff;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
        }

        body { background-color: var(--secondary-bg); font-family: 'Poppins', sans-serif; color: var(--text-dark); overflow-x: hidden; }
        .fade-in-up { animation: fadeInUp 0.8s ease-out; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .ecstatic-card {
            background: var(--card-bg); border: none; border-radius: 20px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            transition: transform 0.3s ease, box-shadow 0.3s ease; overflow: hidden;
        }
        .ecstatic-card:hover { transform: translateY(-2px); box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); }

        .page-header h4 {
            font-weight: 700;
            background: -webkit-linear-gradient(45deg, #3b82f6, #8b5cf6);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        .btn-ecstatic {
            background: var(--primary-gradient); border: none; color: white;
            border-radius: 12px; padding: 10px 24px; font-weight: 600;
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.4); transition: all 0.3s ease;
        }
        .btn-ecstatic:hover { transform: scale(1.05); box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.5); color: white; }

        .filter-input { border: 2px solid #e5e7eb; border-radius: 12px; padding: 10px 15px; }
        .filter-input:focus { border-color: #3b82f6; box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1); }
        .input-group-text { background: white; border: 2px solid #e5e7eb; border-right: none; border-radius: 12px 0 0 12px; color: #3b82f6; }

        /* Table Styling */
        .table { margin-bottom: 0; border-collapse: separate; border-spacing: 0 5px; }
        .table thead th { border: none; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; color: var(--text-muted); font-weight: 600; padding: 15px 20px; background: #f9fafb; }
        .table tbody tr { background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: all 0.2s; }
        .table tbody tr:hover { background: #eff6ff; transform: scale(1.005); }
        .table td { border: none; vertical-align: middle; padding: 15px 20px; font-size: 0.9rem; }
        .table tbody tr td:first-child { border-radius: 10px 0 0 10px; }
        .table tbody tr td:last-child { border-radius: 0 10px 10px 0; }

        .status-badge { padding: 6px 12px; border-radius: 50px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }
        .bg-status-0 { background-color: #e0f2fe; color: #0284c7; }
        .bg-status-1 { background-color: #dcfce7; color: #166534; }
        .bg-status-2 { background-color: #fee2e2; color: #991b1b; }
        .bg-status-3 { background-color: #ffedd5; color: #9a3412; }

        .empty-state { padding: 40px; text-align: center; color: #9ca3af; }
        .empty-state i { font-size: 3rem; margin-bottom: 10px; display: block; opacity: 0.5; }
    </style>
</head>
<body>
    <div class="container py-5 fade-in-up">
        
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-4 mb-4">
                <i class="bi bi-check-circle-fill me-2"></i> <strong>Berjaya!</strong> Permohonan dihantar.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-end mb-5 page-header">
            <div>
                <h4 class="mb-1">Bantuan Komuniti</h4>
                <p class="text-muted m-0 small">Mohon bantuan kebajikan, khairat kematian, atau sumbangan tabung kampung.</p>
            </div>
            <button class="btn btn-ecstatic" data-bs-toggle="modal" data-bs-target="#modalMohon">
                <i class="bi bi-plus-lg me-2"></i> Mohon Baru
            </button>
        </div>

        <%
            // 1. Ambil List Permohonan (Table)
            List<PermohonanBantuan> mainList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
            
            // 2. Ambil List Jenis Bantuan (Dropdown)
            List<Bantuan> senaraiJenis = (List<Bantuan>) request.getAttribute("senaraiJenisBantuan");

            List<PermohonanBantuan> listProses = new ArrayList<>();
            List<PermohonanBantuan> listSejarah = new ArrayList<>();
            SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd MMM yyyy");
            
            if (mainList != null) {
                Collections.sort(mainList, (o1, o2) -> Integer.compare(o2.getIdPermohonan(), o1.getIdPermohonan()));
                for (PermohonanBantuan pb : mainList) {
                    // Logic pengasingan Proses vs Sejarah
                    if (pb.getStatus() == 0 || pb.getStatus() == 2 || pb.getStatus() == 3) {
                        listProses.add(pb);
                    } else {
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
                                    String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                    String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                            %>
                            <tr class="data-row" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                                <td class="ps-4 fw-medium"><%= displayDate %></td>
                                <td class="fw-bold text-primary search-col"><%= pb.getNamaBantuan() %></td>
                                <td>
                                    <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="btn btn-sm btn-light border text-muted"><i class="bi bi-file-earmark-pdf text-danger"></i> PDF</a>
                                    <% } else { %> - <% } %>
                                </td>
                                <td class="small text-muted search-col"><%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %></td>
                                <td class="small">
                                    <% if (pb.getStatus() == 2) { %>
                                        <span class="text-danger fw-bold"><i class="bi bi-exclamation-circle-fill me-1"></i> <%= pb.getUlasanAdmin() %></span>
                                    <% } else { %> <span class="text-muted">-</span> <% } %>
                                </td>
                                <td>
                                    <% if (pb.getStatus() == 0) { %> <span class="status-badge bg-status-0">Dalam Proses</span>
                                    <% } else if (pb.getStatus() == 2) { %> <span class="status-badge bg-status-2">Tidak Lengkap</span>
                                    <% } else if (pb.getStatus() == 3) { %> <span class="status-badge bg-status-3">Disemak JKKK</span> <% } %>
                                </td>
                                <td class="text-center">
                                    <% if (pb.getStatus() == 2) { %>
                                        <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" class="btn btn-sm btn-warning fw-bold text-dark shadow-sm"><i class="bi bi-pencil-square"></i> Betulkan</a>
                                    <% } else if (pb.getStatus() == 0) { %>
                                        <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getIdPermohonan() %>" class="btn btn-sm btn-outline-danger border-0 rounded-circle" onclick="return confirm('Padam?');"><i class="bi bi-trash-fill"></i></a>
                                    <% } else { %> <span class="text-muted small"><i class="bi bi-lock-fill"></i></span> <% } %>
                                </td>
                            </tr>
                            <% } } else { %>
                                <tr class="no-data"><td colspan="7" class="empty-state"><i class="bi bi-inbox"></i>Tiada permohonan aktif.</td></tr>
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
                                <th>Ulasan Ketua Kampung</th>
                                <th>Status</th>
                                <th class="text-center">Info</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (!listSejarah.isEmpty()) { 
                                for (PermohonanBantuan pb : listSejarah) {
                                    String statusClass = (pb.getStatus() == 1) ? "bg-status-1" : "bg-status-2";
                                    String statusText = (pb.getStatus() == 1) ? "Diluluskan" : "Ditolak";
                                    String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                    String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                            %>
                            <tr class="data-row text-muted" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                                <td class="ps-4 text-nowrap"><%= displayDate %></td>
                                <td class="fw-bold search-col text-dark"><%= pb.getNamaBantuan() %></td>
                                <td>
                                    <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="text-decoration-none small text-muted"><i class="bi bi-paperclip"></i> Lihat</a>
                                    <% } else { %> - <% } %>
                                </td>
                                <td class="small search-col"><%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %></td>
                                <td class="small"><%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "-" %></td>
                                <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                                <td class="text-center"><span class="small text-muted"><i class="bi bi-check-all"></i> Selesai</span></td>
                            </tr>
                            <% } } else { %>
                                <tr class="no-data"><td colspan="7" class="empty-state"><i class="bi bi-archive"></i>Tiada sejarah rekod.</td></tr>
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
                <div class="modal-content shadow-lg border-0 rounded-4">
                    <div class="modal-header border-bottom-0 bg-light">
                        <h5 class="modal-title fw-bold text-dark"><i class="bi bi-people-fill text-primary me-2"></i>Permohonan Komuniti</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-4">
                            <label class="form-label fw-bold text-uppercase small text-muted">Jenis Bantuan</label>
                            
                            <select name="jenisBantuan" id="jenisBantuan" class="form-select filter-input bg-light" required onchange="toggleLainBantuan()">
                                <option value="" disabled selected>-- Sila Pilih Jenis Bantuan --</option>
                                
                                <% 
                                if (senaraiJenis != null) {
                                    for (Bantuan b : senaraiJenis) { 
                                %>
                                    <option value="<%= b.getIdBantuan() %>"><%= b.getNamaBantuan() %></option>
                                <% 
                                    } 
                                } 
                                %>
                                
                                <option value="999" class="fw-bold">LAIN-LAIN (Nyatakan)</option>
                            </select>
                        </div>
                        
                        <div class="mb-4 d-none" id="lainBantuanDiv">
                            <label class="form-label fw-bold small text-primary">Nyatakan Jenis Bantuan</label>
                            <input type="text" name="jenisBantuanLain" class="form-control filter-input">
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold small text-muted">Dokumen Sokongan (PDF)</label>
                                <input type="file" name="dokumenSokongan" class="form-control filter-input" accept="application/pdf" required>
                                <div class="form-text small text-primary">Cth: Sijil Kematian / Laporan Polis / Slip Keputusan.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small text-muted">Keterangan / Tarikh Diperlukan</label>
                                <textarea name="keterangan" class="form-control filter-input" rows="1" placeholder="Tarikh majlis atau keterangan lanjut..."></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-primary fw-bold px-4">Hantar Permohonan</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            }
        }
        function filterData() {
            const searchVal = document.getElementById("searchInput").value.toLowerCase();
            const dateVal = document.getElementById("dateFilter").value;
            const rows = document.querySelectorAll(".data-row");
            rows.forEach(row => {
                const rowDate = row.getAttribute("data-date");
                let textContent = "";
                row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
                let showRow = true;
                if (dateVal !== "" && rowDate !== dateVal) showRow = false;
                if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
                row.style.display = showRow ? "" : "none";
            });
        }
    </script>
</body>
</html>