<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Semakan Permohonan JKKK | MyKampung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f8fafc; font-family: sans-serif; }
        .card-custom { border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .table thead th { 
            background-color: #f1f5f9; color: #475569; 
            font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; border: none;
            vertical-align: middle;
        }
        .btn-action-group .btn { border-radius: 6px; font-size: 0.85rem; }
    </style>
</head>
<body>

<div class="container py-5">
    
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold text-dark mb-1">Semakan Permohonan JKKK</h4>
        <p class="text-muted small m-0">Senarai permohonan baharu dari penduduk.</p>
    </div>
    
    <div class="d-flex gap-2">
        <button class="btn btn-primary btn-sm shadow-sm" data-bs-toggle="modal" data-bs-target="#modalTambahBantuan">
            <i class="bi bi-plus-circle me-1"></i> Jenis Bantuan Baru
        </button>
        
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-secondary btn-sm">Log Keluar</a>
    </div>
</div>

    <%
        List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    %>

    <div class="card card-custom bg-white mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="py-3">
                        <tr>
                            <th class="ps-3">No. Rujukan</th>
                            <th>Tarikh Mohon</th>
                            <th>Info Pemohon</th>
                            <th>Jenis Bantuan</th>
                            <th style="width: 20%;">Keterangan</th> <th>Dokumen</th>
                            <th class="text-center" style="width: 200px;">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        boolean adaData = false;
                        if (list != null && !list.isEmpty()) { 
                            for (PermohonanBantuan pb : list) {
                                
                                // 1. FILTER: Hanya papar status 0 (Baharu/Pending)
                                if(pb.getStatus() != 0) { continue; }
                                adaData = true;

                                // Logic Nama Bantuan (Hardcoded mapping seperti requested)
                                String namaBantuan = "Tidak Diketahui";
                                if(pb.getIdBantuan() == 6) namaBantuan = "Bantuan Am";
                                else if(pb.getIdBantuan() == 7) namaBantuan = "Bantuan Bencana";
                                else if(pb.getIdBantuan() == 19) namaBantuan = "Bantuan Persekolahan";
                                else if(pb.getIdBantuan() == 20) namaBantuan = "Sumbangan IPT";
                                else namaBantuan = "Lain-lain (" + pb.getIdBantuan() + ")";

                                String dateDisplay = (pb.getTarikhMohon() != null) ? sdf.format(pb.getTarikhMohon()) : "-";
                        %>
                        <tr>
                            <td class="ps-3 fw-bold text-primary">#<%= pb.getIdPermohonan() %></td>

                            <td><%= dateDisplay %></td>

                            <td>
                                <span class="fw-bold text-dark">
                                    <%= (pb.getNamaPemohon() != null) ? pb.getNamaPemohon() : "TIADA REKOD NAMA" %>
                                </span>
                            </td>

                            <td><span class="badge bg-info bg-opacity-10 text-info border border-info"><%= namaBantuan %></span></td>

                            <td>
                                <% 
                                    String infoCatatan = pb.getCatatan();
                                    if (infoCatatan != null && !infoCatatan.trim().isEmpty()) {
                                %>
                                    <span class="text-dark small"><%= infoCatatan %></span>
                                <% } else { %>
                                    <span class="text-muted small fst-italic">- Tiada keterangan -</span>
                                <% } %>
                            </td>

                             <td>
                                    <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                        <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="btn btn-sm btn-light border text-muted"><i class="bi bi-file-earmark-pdf text-danger"></i> PDF</a>
                                    <% } else { %> - <% } %>
                                </td>

                            <td class="text-center">
                                <div class="d-flex gap-2 justify-content-center">
                                    <button class="btn btn-outline-danger btn-sm" 
                                            onclick="openActionModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuan %>', 'tak_lengkap')">
                                        <i class="bi bi-arrow-return-left me-1"></i> Hantar Balik
                                    </button>
                                    
                                    <button class="btn btn-success btn-sm text-white" 
                                            onclick="openActionModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuan %>', 'lengkap')">
                                        <i class="bi bi-check-circle me-1"></i> Lengkap
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% 
                            } 
                        } 
                        
                        if (!adaData) { 
                        %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted bg-light">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    Tiada permohonan baharu untuk disemak.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalTindakan" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0">
                <h5 class="modal-title fw-bold" id="modalTitle">Pengesahan JKKK</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/reviewJKKK" method="post">
                <div class="modal-body">
                    <input type="hidden" name="idPermohonan" id="modalId">
                    
                    <div class="alert alert-light border mb-3">
                        <strong>Bantuan:</strong> <span id="modalBantuanName"></span>
                    </div>

                    <div class="d-none">
                        <input type="radio" name="keputusan" value="lengkap" id="radioLengkap">
                        <input type="radio" name="keputusan" value="tak_lengkap" id="radioTakLengkap">
                    </div>

                    <div id="viewLengkap" class="text-center py-3 d-none">
                        <i class="bi bi-check-circle-fill text-success fs-1 mb-2"></i>
                        <h5>Sahkan Dokumen Lengkap?</h5>
                        <p class="text-muted small">Permohonan ini akan dihantar kepada <strong>Ketua Kampung</strong> untuk kelulusan akhir.</p>
                    </div>

                    <div id="viewTakLengkap" class="d-none">
                        <div class="text-center mb-3">
                            <i class="bi bi-exclamation-circle-fill text-danger fs-1"></i>
                            <h5 class="mt-2">Hantar Balik Permohonan</h5>
                            <p class="text-muted small">Sila nyatakan sebab atau dokumen yang perlu diperbetulkan oleh penduduk.</p>
                        </div>
                        <div class="form-group">
                            <label class="form-label fw-bold">Ulasan / Sebab:</label>
                            <textarea name="ulasan" id="ulasanBox" class="form-control" rows="3" placeholder="Contoh: Salinan IC kabur, sila muat naik semula..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 bg-light">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary" id="btnSubmit">Sahkan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openActionModal(id, namaBantuan, actionType) {
        // Set Data
        document.getElementById('modalId').value = id;
        document.getElementById('modalBantuanName').innerText = namaBantuan;
        
        // Reset Views
        document.getElementById('viewLengkap').classList.add('d-none');
        document.getElementById('viewTakLengkap').classList.add('d-none');
        
        const btnSubmit = document.getElementById('btnSubmit');
        const ulasanBox = document.getElementById('ulasanBox');

        if(actionType === 'lengkap') {
            // Setup UI untuk Lengkap
            document.getElementById('radioLengkap').checked = true;
            document.getElementById('viewLengkap').classList.remove('d-none');
            btnSubmit.className = "btn btn-success text-white";
            btnSubmit.innerText = "Hantar ke Ketua Kampung";
            ulasanBox.required = false;
        } else {
            // Setup UI untuk Hantar Balik
            document.getElementById('radioTakLengkap').checked = true;
            document.getElementById('viewTakLengkap').classList.remove('d-none');
            btnSubmit.className = "btn btn-danger text-white";
            btnSubmit.innerText = "Hantar Balik ke Penduduk";
            ulasanBox.required = true; 
        }

        // Show Modal
        new bootstrap.Modal(document.getElementById('modalTindakan')).show();
    }
</script>

<div class="modal fade" id="modalTambahBantuan" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class="bi bi-collection text-primary me-2"></i>Tambah Jenis Bantuan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/tambahJenisBantuan" method="post">
                <div class="modal-body">
                    <div class="alert alert-info small border-0 bg-opacity-10 bg-info">
                        <i class="bi bi-info-circle me-1"></i> Bantuan baru akan dimasukkan ke dalam senarai "Bantuan Komuniti".
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Nama Bantuan</label>
                        <input type="text" name="namaBantuanBaru" class="form-control" placeholder="Contoh: SUMBANGAN RAMADHAN" required>
                    </div>
                </div>
                <div class="modal-footer bg-light border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary fw-bold">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>