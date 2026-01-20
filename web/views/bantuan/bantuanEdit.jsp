<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PermohonanBantuan" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Kemaskini Permohonan</h2>
        <p class="text-gray-500 text-sm">Sila kemaskini maklumat permohonan anda di bawah.</p>
    </div>

    <div class="max-w-3xl mx-auto bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        
        <div class="bg-purple-50 px-8 py-6 border-b border-purple-100 flex items-center gap-3">
            <div class="w-10 h-10 bg-white rounded-full flex items-center justify-center text-[#6C5DD3] shadow-sm">
                <i class="fas fa-edit"></i>
            </div>
            <h3 class="text-lg font-bold text-[#6C5DD3]">Borang Kemaskini</h3>
        </div>

        <div class="p-8">
            <% 
                PermohonanBantuan pb = (PermohonanBantuan) request.getAttribute("pb"); 
                
                // LOGIC PEMISAHAN DATA (PARSING)
                String lainName = "";
                String keteranganClean = "";
                boolean isLain = false;

                if (pb != null) {
                    isLain = (pb.getIdBantuan() == 999);
                    String rawCatatan = (pb.getCatatan() != null) ? pb.getCatatan() : "";

                    if (isLain) {
                        String bersih = rawCatatan.replace("LAIN-LAIN: ", "");
                        if (bersih.contains("|")) {
                            String[] parts = bersih.split("\\|");
                            lainName = parts[0].trim();
                            if (parts.length > 1) {
                                keteranganClean = parts[1].trim();
                            }
                        } else {
                            lainName = bersih;
                        }
                    } else {
                        keteranganClean = rawCatatan;
                    }
            %>
            
            <form action="<%= request.getContextPath() %>/bantuan/updateMyRequest" method="post" enctype="multipart/form-data">
                
                <input type="hidden" name="idPermohonan" value="<%= pb.getIdPermohonan() %>">
                <input type="hidden" name="oldDokumen" value="<%= pb.getDokumen() %>">

                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Jenis Bantuan</label>
                    <div class="relative">
                        <select name="jenisBantuan" id="jenisBantuan" required onchange="toggleLainBantuan()"
                                class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm appearance-none font-bold">
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
                            <option value="15" <%= pb.getIdBantuan() == 15 ? "selected" : "" %>>BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)</option>
                            <option value="16" <%= pb.getIdBantuan() == 16 ? "selected" : "" %>>BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)</option>
                            <option value="17" <%= pb.getIdBantuan() == 17 ? "selected" : "" %>>BIASISWA PROFESIONAL PERAKAUNAN (BPP)</option>
                            <option value="18" <%= pb.getIdBantuan() == 18 ? "selected" : "" %>>PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)</option>
                            <option value="19" <%= pb.getIdBantuan() == 19 ? "selected" : "" %>>PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)</option>
                            <option value="20" <%= pb.getIdBantuan() == 20 ? "selected" : "" %>>SUMBANGAN IPT - FISABILILLAH</option>
                            <option value="999" <%= isLain ? "selected" : "" %>>LAIN-LAIN</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                            <i class="fas fa-chevron-down text-xs"></i>
                        </div>
                    </div>
                </div>

                <div class="mb-6 <%= isLain ? "" : "hidden" %>" id="lainBantuanDiv">
                    <label class="block text-xs font-bold text-[#6C5DD3] mb-2 uppercase tracking-wider">Nyatakan Jenis Bantuan</label>
                    <input type="text" name="jenisBantuanLain" id="jenisBantuanLain" value="<%= lainName %>" placeholder="Sila nyatakan jenis bantuan..."
                           class="w-full px-4 py-3 rounded-xl bg-purple-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all placeholder-gray-400">
                </div>

                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Keterangan / Sebab Permohonan</label>
                    <textarea name="keterangan" rows="4" 
                              class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all placeholder-gray-400"><%= keteranganClean %></textarea>
                </div>

                <div class="mb-8">
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Dokumen Sokongan (PDF)</label>
                    
                    <div class="flex items-center gap-3 p-3 bg-blue-50 rounded-xl mb-3 border border-blue-100">
                        <div class="w-8 h-8 bg-blue-100 text-blue-600 rounded-lg flex items-center justify-center">
                            <i class="fas fa-file-pdf"></i>
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="text-xs text-gray-500 uppercase font-bold">Fail Semasa</p>
                            <p class="text-sm font-bold text-gray-800 truncate"><%= pb.getDokumen() %></p>
                        </div>
                    </div>

                    <input type="file" name="dokumenSokongan" accept="application/pdf"
                           class="block w-full text-sm text-gray-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-[#6C5DD3] file:text-white hover:file:bg-[#5b4eb8] transition cursor-pointer bg-gray-50 rounded-xl">
                    <p class="text-xs text-gray-400 mt-2 ml-1">Biarkan kosong jika tidak mahu menukar fail dokumen.</p>
                </div>

                <div class="flex items-center justify-end gap-3 pt-6 border-t border-gray-100">
                  <a href="<%= request.getContextPath() %>/bantuan/list" class="...">
    Batal
</a>
                    <button type="submit" class="px-6 py-3 rounded-xl bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white font-bold text-sm shadow-md shadow-purple-200 flex items-center gap-2 transition">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
                </div>

            </form>

            <% } else { %>
                <div class="text-center py-10">
                    <div class="w-16 h-16 bg-red-50 text-red-500 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <h3 class="text-lg font-bold text-gray-800">Rekod Tidak Dijumpai</h3>
                    <p class="text-gray-500 text-sm mb-6">Maaf, permohonan yang anda cari tidak wujud atau telah dipadam.</p>
                    <a href="<%= request.getContextPath() %>/bantuan/list" class="px-6 py-2.5 bg-gray-100 text-gray-600 rounded-xl font-bold text-sm hover:bg-gray-200 transition">
                        Kembali
                    </a>
                </div>
            <% } %>

        </div>
    </div>

</div>

<script>
    function toggleLainBantuan() {
        const select = document.getElementById("jenisBantuan");
        const lainDiv = document.getElementById("lainBantuanDiv");
        const lainInput = document.getElementById("jenisBantuanLain");

        if (select.value === "999") {
            lainDiv.classList.remove("hidden");
            lainInput.required = true; 
        } else {
            lainDiv.classList.add("hidden");
            lainInput.required = false; 
        }
    }

    // Jalankan sekali semasa page load
    window.onload = function() {
        toggleLainBantuan();
    };
</script>

<%@ include file="/views/common/footer.jsp" %>