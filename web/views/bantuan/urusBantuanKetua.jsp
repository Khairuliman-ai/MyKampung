<%@ include file="/views/common/header.jsp" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Kelulusan Ketua Kampung | MyKampung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Warna Tema Ketua Kampung (Sedikit lebih gelap/formal dari penduduk) */
            --primary-gradient: linear-gradient(135deg, #0f766e 0%, #115e59 100%); 
            --secondary-bg: #f3f4f6;
            --card-bg: #ffffff;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
        }

        body {
            background-color: var(--secondary-bg);
            font-family: 'Poppins', sans-serif;
            color: var(--text-dark);
        }

        .fade-in-up { animation: fadeInUp 0.8s ease-out; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .ecstatic-card {
            background: var(--card-bg);
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            margin-bottom: 2rem;
        }

        /* Table Styling */
        .table thead th {
            background-color: #f0fdfa; /* Teal muda */
            color: #115e59;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
            border: none;
            padding: 15px;
        }
        .table td { vertical-align: middle; padding: 15px; border-bottom: 1px solid #f3f4f6; }
        
        .btn-action { border-radius: 8px; padding: 8px 16px; font-size: 0.85rem; font-weight: 500; transition: 0.2s; }
        .btn-lulus { background-color: #10b981; color: white; border: none; }
        .btn-lulus:hover { background-color: #059669; transform: translateY(-2px); }
        
        .btn-tolak { background-color: #ef4444; color: white; border: none; }
        .btn-tolak:hover { background-color: #dc2626; transform: translateY(-2px); }

        .badge-status-3 { background-color: #ffedd5; color: #9a3412; border: 1px solid #fed7aa; } /* Pending Ketua */
        .badge-status-1 { background-color: #dcfce7; color: #166534; border: 1px solid #bbf7d0; } /* Lulus */
        .badge-status-4 { background-color: #fee2e2; color: #991b1b; border: 1px solid #fecaca; } /* Ditolak Ketua */

        .empty-state { padding: 50px; text-align: center; color: #9ca3af; }
        .empty-state i { font-size: 3rem; display: block; margin-bottom: 15px; opacity: 0.5; }
    </style>
</head>
<body>

<div class="container py-5 fade-in-up">

    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h4 class="fw-bold text-dark mb-1">Pengesahan Ketua Kampung</h4>
            <p class="text-muted m-0 small">Semak dan luluskan permohonan yang telah disahkan oleh JKKK.</p>
        </div>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-secondary btn-sm px-4 rounded-pill">Log Keluar</a>
    </div>

    <%
        // Logic Pengasingan Data
        List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
        List<PermohonanBantuan> listPending = new ArrayList<>(); // Status 3 (Dari JKKK)
        List<PermohonanBantuan> listSejarah = new ArrayList<>(); // Status 1 (Lulus) atau 4 (Tolak)
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        if(list != null) {
            for(PermohonanBantuan pb : list) {
                // Status 3: Disahkan JKKK, Menunggu Ketua Kampung
                if(pb.getStatus() == 3) {
                    listPending.add(pb);
                } 
                // Status 1 (Lulus) atau 4 (Tolak - Jika ada status 4)
                else if(pb.getStatus() == 1 || pb.getStatus() == 4) {
                    listSejarah.add(pb);
                }
            }
        }
    %>

    <div class="ecstatic-card">
        <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
            <h5 class="fw-bold text-dark"><i class="bi bi-patch-check-fill text-warning me-2"></i>Menunggu Kelulusan</h5>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Tarikh</th>
                            <th>Pemohon</th>
                            <th>Jenis Bantuan</th>
                            <th>Semakan JKKK</th>
                            <th>Dokumen</th>
                         
                            <th class="text-center" style="width: 200px;">Keputusan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(!listPending.isEmpty()) { 
                            for(PermohonanBantuan pb : listPending) {
                                String displayDate = (pb.getTarikhMohon() != null) ? sdf.format(pb.getTarikhMohon()) : "-";
                                
                                // Logic Nama Bantuan (Simple)
                                String namaBantuan = "Bantuan ID: " + pb.getIdBantuan();
                                if(pb.getIdBantuan() == 6) namaBantuan = "Bantuan Am";
                                else if(pb.getIdBantuan() == 20) namaBantuan = "Sumbangan IPT";
                                else if(pb.getIdBantuan() == 999) namaBantuan = "Lain-lain";
                        %>
                        <tr>
                            <td class="text-muted small"><%= displayDate %></td>
                            <td>
                                <span class="fw-bold text-dark"><%= (pb.getNamaPemohon() != null) ? pb.getNamaPemohon() : "Nama Tidak Dijumpai" %></span><br>
                            
                            </td>
       <td>
    <span>
        <%= pb.getNamaBantuan() %>
    </span>
</td>
                            
                            <td>
                                <div class="d-flex align-items-start">
                                    <i class="bi bi-check-circle-fill text-success mt-1 me-2"></i>
                                    <div>
                                        <small class="fw-bold text-success d-block">Disahkan JKKK</small>
                                        <small class="text-muted fst-italic"><%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "Dokumen Lengkap" %></small>
                                    </div>
                                </div>
                            </td>

                            <td>
                                <% if(pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="btn btn-sm btn-light border text-danger">
                                        <i class="bi bi-file-pdf-fill"></i> PDF
                                    </a>
                                <% } else { %> - <% } %>
                            </td>

                            <td class="text-center">
                                <div class="d-flex gap-2 justify-content-center">
                                    <button class="btn btn-lulus btn-action w-100" onclick="openModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuan %>', 'lulus')">
                                        <i class="bi bi-check-lg"></i> Sokong
                                    </button>
                                    <button class="btn btn-outline-danger btn-action" onclick="openModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuan %>', 'tolak')">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                            <tr><td colspan="6" class="empty-state"><i class="bi bi-check2-all"></i>Tiada permohonan tertunggak.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="ecstatic-card mt-5">
        <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
            <h5 class="fw-bold text-secondary"><i class="bi bi-clock-history me-2"></i>Sejarah Keputusan</h5>
        </div>
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Tarikh</th>
                            <th>Pemohon</th>
                            <th>Jenis Bantuan</th>
                            <th>Keputusan Akhir</th>
                            <th>Catatan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(!listSejarah.isEmpty()) { 
                            for(PermohonanBantuan pb : listSejarah) {
                                String displayDate = (pb.getTarikhMohon() != null) ? sdf.format(pb.getTarikhMohon()) : "-";
                                
                                String statusBadge = "";
                                if(pb.getStatus() == 1) statusBadge = "<span class='badge badge-status-1 px-3 py-2'>Disokong</span>";
                                else if(pb.getStatus() == 4) statusBadge = "<span class='badge badge-status-4 px-3 py-2'>Ditolak</span>";
                        %>
                        <tr>
                            <td class="text-muted small"><%= displayDate %></td>
                            <td class="fw-bold text-dark"><%= pb.getNamaPemohon() %></td>
                            <td>
    <span >
        <%= pb.getNamaBantuan() %>
    </span>
</td>
                            <td><%= statusBadge %></td>
                            <td class="small text-muted"><%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "-" %></td>
                        </tr>
                        <% } } else { %>
                            <tr><td colspan="5" class="text-center py-4 text-muted">Tiada rekod sejarah.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<div class="modal fade" id="modalKeputusan" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="modalTitle">Pengesahan Akhir</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/keputusanKetua" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="idPermohonan" id="modalId">
                    <input type="hidden" name="keputusan" id="modalKeputusanValue">
                    
                    <div class="alert alert-light border mb-3">
                        <strong>Bantuan:</strong> <span id="modalBantuanName"></span>
                    </div>

                    <div id="viewLulus" class="text-center py-3 d-none">
                        <i class="bi bi-patch-check-fill text-success fs-1 mb-2"></i>
                        <h4 class="text-success fw-bold">Sokong Permohonan?</h4>
                        <p class="text-muted small">Permohonan ini akan diluluskan secara rasmi.</p>
                    </div>

                    <div id="viewTolak" class="d-none">
                        <div class="text-center mb-3">
                            <i class="bi bi-x-circle-fill text-danger fs-1"></i>
                            <h5 class="mt-2 text-danger fw-bold">Tolak Permohonan</h5>
                            <p class="text-muted small">Sila nyatakan sebab penolakan.</p>
                        </div>
                        <div class="form-group">
                            <label class="form-label fw-bold small">Sebab Penolakan:</label>
                            <textarea name="ulasan" id="ulasanBox" class="form-control" rows="3" placeholder="Contoh: Tidak menetap di kampung ini..."></textarea>
                        </div>
                    </div>
                    
                    <div class="mb-3">
    <label class="form-label fw-bold small text-primary">Muat Naik Dokumen (Pilihan):</label>
    <input type="file" name="dokumenBalas" class="form-control" accept="application/pdf">
    <div class="form-text small text-muted">Contoh: Surat Kelulusan Rasmi / Memo</div>
</div>
                    
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary" id="btnSubmit">Sahkan Keputusan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openModal(id, namaBantuan, jenisKeputusan) {
        document.getElementById('modalId').value = id;
        document.getElementById('modalBantuanName').innerText = namaBantuan;
        document.getElementById('modalKeputusanValue').value = jenisKeputusan;

        const viewLulus = document.getElementById('viewLulus');
        const viewTolak = document.getElementById('viewTolak');
        const btnSubmit = document.getElementById('btnSubmit');
        const ulasanBox = document.getElementById('ulasanBox');

        if (jenisKeputusan === 'lulus') {
            viewLulus.classList.remove('d-none');
            viewTolak.classList.add('d-none');
            btnSubmit.className = "btn btn-success fw-bold w-100";
            btnSubmit.innerText = "LULUSKAN / SOKONG";
            ulasanBox.required = false;
        } else {
            viewLulus.classList.add('d-none');
            viewTolak.classList.remove('d-none');
            btnSubmit.className = "btn btn-danger fw-bold w-100";
            btnSubmit.innerText = "TOLAK PERMOHONAN";
            ulasanBox.required = true;
        }

        new bootstrap.Modal(document.getElementById('modalKeputusan')).show();
    }
</script>

</body>
</html>