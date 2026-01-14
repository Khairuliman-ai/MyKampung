<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
    <title>Bantuan Saya | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        /* Gaya CSS asas (boleh copy dari fail asal) */
        body { background-color: #f0f2f5; font-family: sans-serif; }
        .status-badge { padding: 5px 10px; border-radius: 6px; font-weight: 600; font-size: 0.8rem; }
        .bg-status-0 { background: #e2e8f0; color: #475569; } /* Baharu - Kelabu */
        .bg-status-1 { background: #dcfce7; color: #166534; } /* Lulus - Hijau */
        .bg-status-2 { background: #fee2e2; color: #991b1b; } /* Ditolak - Merah */
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold">Rekod Bantuan Saya</h4>
                <p class="text-muted">Semak status permohonan bantuan anda di sini.</p>
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
                            <th>Dokumen Saya</th>
                            <th>Status</th>
                            <th>Catatan Ketua Kampung</th>
                            <th>Dokumen Balas</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
                            if (list != null && !list.isEmpty()) {
                                for (PermohonanBantuan pb : list) {
                                    String statusClass = pb.getStatus() == 0 ? "bg-status-0" : (pb.getStatus() == 1 ? "bg-status-1" : "bg-status-2");
                                    String statusText = pb.getStatus() == 0 ? "Dalam Proses" : (pb.getStatus() == 1 ? "Lulus" : "Ditolak");
                        %>
                        <tr>
                            <td class="ps-4"><%= pb.getTarikhMohon() %></td>
                            <td class="fw-bold">Bantuan <%= pb.getIdBantuan() %></td>
                            <td>
                                <% if (pb.getDokumen() != null) { %>
                                    <a href="#" class="text-decoration-none small"><i class="bi bi-paperclip"></i> Lihat Fail</a>
                                <% } else { %> - <% } %>
                            </td>
                            <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                            
                            <td class="text-muted small">
                                <%= (pb.getCatatan() != null) ? pb.getCatatan() : "Tiada catatan" %>
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
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                            <tr><td colspan="6" class="text-center py-5 text-muted">Anda belum membuat sebarang permohonan.</td></tr>
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
                                <option value="B01">Bantuan Sara Hidup</option>
                                <option value="B02">Bantuan Bencana</option>
                                <option value="B03">Bantuan Persekolahan</option>
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