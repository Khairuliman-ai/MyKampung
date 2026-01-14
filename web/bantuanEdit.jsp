<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PermohonanBantuan" %>
<html>
<head>
    <title>Kemaskini Bantuan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow rounded-4 border-0">
                    <div class="card-header bg-warning-subtle p-4">
                        <h4 class="fw-bold mb-0">Kemaskini Permohonan</h4>
                    </div>
                    <div class="card-body p-4">
                        <% 
                            PermohonanBantuan pb = (PermohonanBantuan) request.getAttribute("pb"); 
                            if (pb != null) {
                        %>
                        <form action="<%= request.getContextPath() %>/bantuan/updateMyRequest" method="post" enctype="multipart/form-data">
                            
                            <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                            <input type="hidden" name="oldDokumen" value="<%= pb.getDokumen() %>">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Jenis Bantuan</label>
                                <select name="jenisBantuan" class="form-select" required>
                                    <option value="" disabled>-- Sila Pilih --</option>
                                    <option value="6" <%= pb.getIdBantuan() == 6 ? "selected" : "" %>>BANTUAN AM</option>
                                    <option value="7" <%= pb.getIdBantuan() == 7 ? "selected" : "" %>>BANTUAN HARI RAYA</option>
                                    <option value="8" <%= pb.getIdBantuan() == 8 ? "selected" : "" %>>BANTUAN KEPADA GHARIMIN</option>
                                    <option value="9" <%= pb.getIdBantuan() == 9 ? "selected" : "" %>>BANTUAN MELANJUT PELAJARAN KE IPT</option>
                                    <option value="10" <%= pb.getIdBantuan() == 10 ? "selected" : "" %>>BANTUAN PEMBANGUNAN ASNAF</option>
                                    <option value="11" <%= pb.getIdBantuan() == 11 ? "selected" : "" %>>BANTUAN PEMULIHAN RUMAH KEDIAMAN</option>
                                    <option value="12" <%= pb.getIdBantuan() == 12 ? "selected" : "" %>>BANTUAN RAWATAN PERUBATAN</option>
                                    <option value="13" <%= pb.getIdBantuan() == 13 ? "selected" : "" %>>BANTUAN SEWA RUMAH</option>
                                    <option value="14" <%= pb.getIdBantuan() == 14 ? "selected" : "" %>>BANTUAN TETAP BULANAN</option>
                                    <option value="15" <%= pb.getIdBantuan() == 15 ? "selected" : "" %>>BIASISWA PENDIDIKAN DALAM NEGARA (BPDN) MAIK</option>
                                    <option value="16" <%= pb.getIdBantuan() == 16 ? "selected" : "" %>>BIASISWA PENDIDIKAN LUAR NEGARA (BPLN) MAIK</option>
                                    <option value="17" <%= pb.getIdBantuan() == 17 ? "selected" : "" %>>BIASISWA PROFESIONAL PERAKAUNAN (BPP) MAIK</option>
                                    <option value="18" <%= pb.getIdBantuan() == 18 ? "selected" : "" %>>PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP) MAIK</option>
                                    <option value="19" <%= pb.getIdBantuan() == 19 ? "selected" : "" %>>PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP) MAIK</option>
                                    <option value="20" <%= pb.getIdBantuan() == 20 ? "selected" : "" %>>SUMBANGAN MELANJUTKAN PENGAJIAN KE IPT - FISABILILLAH</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Keterangan</label>
                                <textarea name="keterangan" class="form-control" rows="3"><%= pb.getCatatan() %></textarea>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Dokumen Sokongan</label>
                                <div class="p-2 border rounded bg-light mb-2">
                                    <small class="text-muted">Fail Semasa: <%= pb.getDokumen() %></small>
                                </div>
                                <input type="file" name="dokumenSokongan" class="form-control" accept="application/pdf">
                                <div class="form-text">Biarkan kosong jika tidak mahu menukar fail.</div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/bantuan/list" class="btn btn-light">Batal</a>
                                <button type="submit" class="btn btn-primary fw-bold">Simpan Perubahan</button>
                            </div>
                        </form>
                        <% } else { %>
                            <div class="alert alert-danger">Rekod tidak dijumpai.</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>