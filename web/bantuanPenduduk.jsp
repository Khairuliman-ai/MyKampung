<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
    <title>Bantuan Saya | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f0f2f5; font-family: sans-serif; }
        .status-badge { padding: 5px 10px; border-radius: 6px; font-weight: 600; font-size: 0.8rem; }
        .bg-status-0 { background: #e2e8f0; color: #475569; } /* Dalam Proses - Kelabu */
        .bg-status-1 { background: #dcfce7; color: #166534; } /* Lulus - Hijau */
        .bg-status-2 { background: #fee2e2; color: #991b1b; } /* Ditolak - Merah */
    </style>
</head>
<body>
    <div class="container py-5">
        
        <% if (request.getParameter("status") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Berjaya!</strong> Rekod telah dikemaskini.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold">Rekod Bantuan Saya</h4>
                <p class="text-muted">Senarai permohonan yang telah anda buat.</p>
            </div>
            <button class="btn btn-primary fw-bold" data-bs-toggle="modal" data-bs-target="#modalMohon">
                <i class="bi bi-plus-lg me-2"></i>Mohon Bantuan Baru
            </button>
        </div>

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th class="ps-4">Tarikh</th>
                            <th>Jenis Bantuan</th>
                            <th>Dokumen</th>
                            <th>Status</th>
                            <th>Catatan Admin</th>
                            <th>Dokumen Balas</th>
                            <th class="text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
                            if (list != null && !list.isEmpty()) {
                                for (PermohonanBantuan pb : list) {
                                    // Logic Warna Status
                                    String statusClass = pb.getStatus() == 0 ? "bg-status-0" : (pb.getStatus() == 1 ? "bg-status-1" : "bg-status-2");
                                    String statusText = pb.getStatus() == 0 ? "Dalam Proses" : (pb.getStatus() == 1 ? "Lulus" : "Ditolak");
                                    
                                    // Logic Nama Bantuan (UPDATED: ID 6 - 20)
                                    String namaBantuan = "Lain-lain / Tidak Diketahui";
                                    int idB = pb.getIdBantuan();
                                    
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
                        %>
                        <tr>
                            <td class="ps-4"><%= pb.getTarikhMohon() %></td>
                            <td class="fw-bold"><%= namaBantuan %></td>
                            
                            <td>
                                <% if (pb.getDokumen() != null) { 
                                     String encodedFile = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20");
                                %>
                                    <a href="<%= request.getContextPath() %>/uploads/<%= encodedFile %>" target="_blank" class="text-decoration-none small">
                                        <i class="bi bi-paperclip"></i> Lihat
                                    </a>
                                <% } else { %> - <% } %>
                            </td>

                            <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                            
                            <td class="text-muted small" style="max-width: 200px;">
                                <%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %>
                            </td>

                            <td>
                                <% if (pb.getDokumenBalik() != null && !pb.getDokumenBalik().isEmpty()) { 
                                     String encodedFile = URLEncoder.encode(pb.getDokumenBalik(), "UTF-8").replace("+", "%20");
                                %>
                                    <a href="<%= request.getContextPath() %>/uploads/<%= encodedFile %>" class="btn btn-sm btn-outline-success fw-bold" target="_blank">
                                        <i class="bi bi-download me-1"></i> Surat
                                    </a>
                                <% } else { %>
                                    <span class="text-muted small">-</span>
                                <% } %>
                            </td>

                            <td class="text-center">
                                <% if (pb.getStatus() == 0) { // Hanya boleh edit jika 'Dalam Proses' %>
                                    
                                    <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" 
                                       class="btn btn-sm btn-warning text-dark fw-bold me-1"
                                       title="Kemaskini">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>

                                    <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getIdPermohonan() %>" 
                                       class="btn btn-sm btn-danger text-white"
                                       onclick="return confirm('Adakah anda pasti ingin memadam permohonan ini?');"
                                       title="Padam">
                                        <i class="bi bi-trash"></i>
                                    </a>

                                <% } else { %>
                                    <span class="text-muted small"><i class="bi bi-lock-fill"></i> Selesai</span>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                            <tr><td colspan="7" class="text-center py-5 text-muted">Anda belum membuat sebarang permohonan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalMohon" tabindex="-1">
        <div class="modal-dialog">
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Permohonan Bantuan Baru</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Jenis Bantuan</label>
                            <select name="jenisBantuan" class="form-select" required>
                                <option value="" disabled selected>-- Sila Pilih Bantuan --</option>
                                <option value="6">BANTUAN AM</option>
                                <option value="7">BANTUAN HARI RAYA</option>
                                <option value="8">BANTUAN KEPADA GHARIMIN</option>
                                <option value="9">BANTUAN MELANJUT PELAJARAN KE IPT</option>
                                <option value="10">BANTUAN PEMBANGUNAN ASNAF</option>
                                <option value="11">BANTUAN PEMULIHAN RUMAH KEDIAMAN</option>
                                <option value="12">BANTUAN RAWATAN PERUBATAN</option>
                                <option value="13">BANTUAN SEWA RUMAH</option>
                                <option value="14">BANTUAN TETAP BULANAN</option>
                                <option value="15">BIASISWA PENDIDIKAN DALAM NEGARA (BPDN) MAIK</option>
                                <option value="16">BIASISWA PENDIDIKAN LUAR NEGARA (BPLN) MAIK</option>
                                <option value="17">BIASISWA PROFESIONAL PERAKAUNAN (BPP) MAIK</option>
                                <option value="18">PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP) MAIK</option>
                                <option value="19">PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP) MAIK</option>
                                <option value="20">SUMBANGAN MELANJUTKAN PENGAJIAN KE IPT - FISABILILLAH</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Muat Naik Dokumen Sokongan (PDF)</label>
                            <input type="file" name="dokumenSokongan" class="form-control" accept="application/pdf" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Keterangan Ringkas</label>
                            <textarea name="keterangan" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-primary">Hantar Permohonan</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>