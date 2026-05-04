<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>

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
                    isLain = (pb.getId_bantuan() == 999 || pb.getId_bantuan() == 998);
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
                    
                    // DAPATKAN KATEGORI BANTUAN
                    String kategori = "KOMUNITI";
                    List<Bantuan> senaraiBantuan = (List<Bantuan>) request.getAttribute("senaraiJenisBantuan");
                    if (senaraiBantuan != null) {
                        for (Bantuan b : senaraiBantuan) {
                            if (b.getId_bantuan() == pb.getId_bantuan()) {
                                kategori = b.getJenis_bantuan();
                                break;
                            }
                        }
                    }
                    if(pb.getId_bantuan() == 999) kategori = "RASMI";
                    if(pb.getId_bantuan() == 998) kategori = "KOMUNITI";
                    
                    boolean isRasmi = "RASMI".equalsIgnoreCase(kategori);
            %>
            
            <form action="<%= request.getContextPath() %>/bantuan/updateMyRequest" method="post" enctype="multipart/form-data">
                
                <input type="hidden" name="idPermohonan" value="<%= pb.getId_permohonan() %>">

                <input type="hidden" name="jenisBantuan" value="<%= pb.getId_bantuan() %>">
                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-400 mb-2 uppercase tracking-wider flex items-center gap-2">
                        Jenis Bantuan <span class="text-[10px] bg-gray-100 text-gray-400 px-2 py-0.5 rounded italic">Tidak boleh diubah</span>
                    </label>
                    <div class="relative">
                        <select disabled
                                class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm appearance-none font-bold cursor-not-allowed">
                            <option value="" disabled>-- Sila Pilih --</option>
                            <% 
                                if (senaraiBantuan != null) {
                                    for (Bantuan b : senaraiBantuan) {
                            %>
                                <option value="<%= b.getId_bantuan() %>" <%= pb.getId_bantuan() == b.getId_bantuan() ? "selected" : "" %>><%= b.getNama_bantuan() %></option>
                            <% 
                                    }
                                }
                            %>
                            <option value="999" <%= pb.getId_bantuan() == 999 ? "selected" : "" %>>LAIN-LAIN (RASMI)</option>
                            <option value="998" <%= pb.getId_bantuan() == 998 ? "selected" : "" %>>LAIN-LAIN (KOMUNITI)</option>
                        </select>
                        <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-300">
                            <i class="fas fa-lock text-xs"></i>
                        </div>
                    </div>
                </div>

                <div class="mb-6 <%= isLain ? "" : "hidden" %>" id="lainBantuanDiv">
                    <label class="block text-xs font-bold text-gray-400 mb-2 uppercase tracking-wider flex items-center gap-2">
                        Nyatakan Jenis Bantuan <i class="fas fa-lock text-[10px]"></i>
                    </label>
                    <input type="text" name="jenisBantuanLain" id="jenisBantuanLain" value="<%= lainName %>" readonly
                           class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
                </div>

                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-400 mb-2 uppercase tracking-wider flex items-center gap-2">
                        Keterangan / Sebab Permohonan <i class="fas fa-lock text-[10px]"></i>
                    </label>
                    <textarea name="keterangan" rows="4" readonly
                              class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed"><%= keteranganClean %></textarea>
                </div>

                <div class="mb-8">
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Dokumen Sokongan (PDF)</label>
                    
                    <div class="space-y-3 mb-4">
                        <% 
                            if (pb.getSenaraiLampiran() != null && !pb.getSenaraiLampiran().isEmpty()) {
                                for (model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                        %>
                        <div class="flex items-center gap-3 p-3 bg-white border border-gray-100 rounded-2xl shadow-sm hover:border-purple-200 transition group">
                            <div class="w-8 h-8 bg-red-50 text-red-500 rounded-lg flex items-center justify-center">
                                <i class="fas fa-file-pdf"></i>
                            </div>
                            <div class="flex-1 min-w-0 text-xs">
                                <p class="text-gray-400 uppercase font-bold text-[8px]">Fail Terlampir</p>
                                <p class="font-bold text-gray-700 truncate" title="<%= bl.getNama_fail() %>">
                                    <%= bl.getNama_fail().substring(bl.getNama_fail().indexOf("_") + 1) %>
                                </p>
                            </div>
                            <div class="flex gap-2">
                                <a href="<%= request.getContextPath() %>/file/bantuan/<%= URLEncoder.encode(bl.getNama_fail(), "UTF-8") %>" target="_blank" 
                                   class="w-7 h-7 flex items-center justify-center bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition">
                                    <i class="fas fa-eye text-[10px]"></i>
                                </a>
                                <a href="<%= request.getContextPath() %>/bantuan/deleteAttachment?idLampiran=<%= bl.getId_lampiran() %>&idPermohonan=<%= pb.getId_permohonan() %>" 
                                   onclick="return confirm('Padam fail ini?')"
                                   class="w-7 h-7 flex items-center justify-center bg-red-50 text-red-500 rounded-lg hover:bg-red-100 transition">
                                    <i class="fas fa-trash text-[10px]"></i>
                                </a>
                            </div>
                        </div>
                        <% 
                                }
                            } else {
                        %>
                            <p class="text-xs text-gray-400 italic p-4 bg-gray-50 rounded-2xl text-center border border-dashed">Tiada dokumen dilampirkan.</p>
                        <% } %>
                    </div>

                    <div class="bg-purple-50/50 p-4 rounded-2xl border border-purple-100 border-dashed">
                        <label class="block text-[10px] font-bold text-[#6C5DD3] uppercase mb-2">Tambah Dokumen Baru</label>
                        <input type="file" name="dokumenSokongan" accept="application/pdf" multiple
                               class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-bold file:bg-[#6C5DD3] file:text-white hover:file:bg-[#5b4eb8] transition cursor-pointer">
                        <p class="text-[9px] text-gray-400 mt-2 italic">Boleh pilih lebih dari satu fail baru untuk ditambah.</p>
                    </div>
                </div>

                <!-- BANK SECTION UPDATE -->
                <% if (!isRasmi) { %>
                <div class="mt-10 pt-8 border-t border-dashed border-gray-200">
                    <h5 class="text-xs font-bold text-blue-600 uppercase tracking-widest mb-6 flex items-center gap-2">
                        <i class="fas fa-university"></i> Kemaskini Maklumat Bank
                    </h5>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 bg-gray-50/50 p-6 rounded-3xl border border-gray-100 mb-6">
                        <div>
                            <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2">Nama Bank</label>
                            <input type="text" name="namaBank" value="<%= (pb.getNama_bank() != null) ? pb.getNama_bank() : "" %>" required
                                   class="w-full px-4 py-3 rounded-xl bg-white border-none focus:ring-2 focus:ring-blue-400 text-gray-800 text-sm font-bold shadow-sm">
                        </div>
                        <div>
                            <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2">Nombor Akaun</label>
                            <input type="text" name="nomorAkaun" value="<%= (pb.getNombor_akaun() != null) ? pb.getNombor_akaun() : "" %>" required
                                   class="w-full px-4 py-3 rounded-xl bg-white border-none focus:ring-2 focus:ring-blue-400 text-gray-800 text-sm font-bold tracking-wider shadow-sm">
                        </div>
                    </div>

                    <div>
                        <label class="block text-[10px] font-bold text-gray-400 uppercase mb-3">Penyata Bank (PDF)</label>
                        <% if (pb.getPenyata_bank() != null) { %>
                            <div class="flex items-center gap-3 p-3 bg-green-50 rounded-xl mb-3 border border-green-100">
                                <div class="w-8 h-8 bg-green-100 text-green-600 rounded-lg flex items-center justify-center">
                                    <i class="fas fa-file-invoice-dollar"></i>
                                </div>
                                <div class="flex-1 min-w-0 text-xs">
                                    <p class="text-gray-400 uppercase font-bold text-[10px]">Fail Semasa</p>
                                    <p class="font-bold text-gray-800 truncate"><%= pb.getPenyata_bank() %></p>
                                </div>
                            </div>
                        <% } %>
                        <input type="file" name="penyataBank" accept="application/pdf"
                               class="block w-full text-sm text-gray-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-blue-600 file:text-white hover:file:bg-blue-700 transition cursor-pointer bg-gray-50 rounded-xl">
                        <p class="text-[10px] text-gray-400 mt-2 ml-1 italic">Kosongkan jika tiada perubahan pada penyata bank.</p>
                    </div>
                    <input type="hidden" name="oldPenyataBank" value="<%= (pb.getPenyata_bank() != null) ? pb.getPenyata_bank() : "" %>">
                </div>
                <% } %>

                <div class="flex items-center justify-end gap-3 pt-6 border-t border-gray-100">
                    <a href="<%= request.getContextPath() %>/bantuan/list" class="px-6 py-3 rounded-xl bg-gray-100 text-gray-600 font-bold text-sm hover:bg-gray-200 transition">
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