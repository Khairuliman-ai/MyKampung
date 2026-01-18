<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PermohonanBantuan" %>
<html>
<head>
    <title>Kemaskini Bantuan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                            
                            // --- LOGIC PEMISAHAN DATA (PARSING) ---
                            String lainName = "";
                            String keteranganClean = "";
                            boolean isLain = false;

                            if (pb != null) {
                                isLain = (pb.getIdBantuan() == 999);
                                String rawCatatan = (pb.getCatatan() != null) ? pb.getCatatan() : "";

                                if (isLain) {
                                    // Format dalam DB: "LAIN-LAIN: [Nama Bantuan] | [Keterangan]"
                                    // Kita perlu pecahkan balik kepada dua bahagian
                                    String bersih = rawCatatan.replace("LAIN-LAIN: ", "");
                                    
                                    if (bersih.contains("|")) {
                                        String[] parts = bersih.split("\\|");
                                        lainName = parts[0].trim(); // Masuk ke input text
                                        if (parts.length > 1) {
                                            keteranganClean = parts[1].trim(); // Masuk ke textarea
                                        }
                                    } else {
                                        lainName = bersih; // Jika tiada keterangan
                                    }
                                } else {
                                    // Jika bantuan biasa, semua catatan masuk ke textarea
                                    keteranganClean = rawCatatan;
                                }
                        %>
                        
                        <form action="<%= request.getContextPath() %>/bantuan/updateMyRequest" method="post" enctype="multipart/form-data">
                            
                            <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                            <input type="hidden" name="oldDokumen" value="<%= pb.getDokumen() %>">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Jenis Bantuan</label>
                                <select name="jenisBantuan" id="jenisBantuan" class="form-select" required onchange="toggleLainBantuan()">
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
                                    
                                    <option value="999" <%= isLain ? "selected" : "" %>>LAIN-LAIN</option>
                                </select>
                            </div>

                            <div class="mb-3 <%= isLain ? "" : "d-none" %>" id="lainBantuanDiv">
                                <label class="form-label fw-bold text-primary">Nyatakan Jenis Bantuan</label>
                                <input type="text" name="jenisBantuanLain" id="jenisBantuanLain" 
                                       class="form-control" 
                                       value="<%= lainName %>" 
                                       placeholder="Sila nyatakan jenis bantuan...">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Keterangan / Sebab Permohonan</label>
                                <textarea name="keterangan" class="form-control" rows="3"><%= keteranganClean %></textarea>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Dokumen Sokongan</label>
                                <div class="p-2 border rounded bg-light mb-2 d-flex justify-content-between align-items-center">
                                    <small class="text-muted text-truncate" style="max-width: 80%;">
                                        <i class="bi bi-file-earmark-check"></i> Fail Semasa: <%= pb.getDokumen() %>
                                    </small>
                                </div>
                                <input type="file" name="dokumenSokongan" class="form-control" accept="application/pdf">
                                <div class="form-text">Biarkan kosong jika tidak mahu menukar fail.</div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="<%= request.getContextPath() %>/bantuan/list" class="btn btn-light border">Batal</a>
                                <button type="submit" class="btn btn-warning fw-bold text-dark">
                                    <i class="bi bi-save me-1"></i> Simpan Perubahan
                                </button>
                            </div>
                        </form>
                        <% } else { %>
                            <div class="alert alert-danger">Rekod tidak dijumpai.</div>
                            <div class="text-center mt-3">
                                <a href="<%= request.getContextPath() %>/bantuan/list" class="btn btn-secondary">Kembali</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleLainBantuan() {
            const select = document.getElementById("jenisBantuan");
            const lainDiv = document.getElementById("lainBantuanDiv");
            const lainInput = document.getElementById("jenisBantuanLain");

            if (select.value === "999") {
                lainDiv.classList.remove("d-none");
                lainInput.required = true; // Wajib isi jika pilih Lain-lain
            } else {
                lainDiv.classList.add("d-none");
                lainInput.required = false; // Tak wajib jika bukan Lain-lain
                // Optional: Kosongkan value jika tukar pilihan
                // lainInput.value = ""; 
            }
        }

        // Jalankan sekali semasa page load untuk pastikan state betul
        window.onload = function() {
            toggleLainBantuan();
        };
    </script>
</body>
</html>