<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%
    // 1. DAPATKAN DATA DARI REQUEST (SERVER-SIDE PAGINATION)
    List<PermohonanBantuan> listBaru = (List<PermohonanBantuan>) request.getAttribute("listBaru");
    List<PermohonanBantuan> listSejarah = (List<PermohonanBantuan>) request.getAttribute("listSejarah");
    List<Bantuan> senaraiBantuan = (List<Bantuan>) request.getAttribute("senaraiBantuan");
    
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalCount = (Integer) request.getAttribute("totalCount");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Semakan Permohonan AJK</h2>
            <p class="text-gray-500 text-sm">Uruskan permohonan baharu, semak sejarah, dan urus jenis bantuan.</p>
        </div>
        
        <div class="flex items-center gap-3">
            <a href="<%= request.getContextPath() %>/bantuan/config" 
               class="inline-flex items-center gap-2 px-5 py-3.5 rounded-2xl bg-white border border-gray-100 text-gray-700 hover:text-brand-purple hover:border-purple-200 shadow-sm transition-all text-xs font-black uppercase tracking-wider">
                <i class="fas fa-sliders-h text-brand-purple"></i>
                Konfigurasi Kelayakan
            </a>
        </div>
    </div>

    <!-- Carian & Penapis Section -->
    <div class="flex flex-col md:flex-row gap-4 mb-8">
        <!-- Search Input -->
        <div class="flex-1 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-brand-purple group-focus-within:scale-110 transition-all duration-300 pointer-events-none">
                <i class="fas fa-search text-sm"></i>
            </div>
            <input type="text" id="searchPemohon" onkeyup="filterData()" placeholder="Cari pemohon atau ID permohonan..." 
                   class="w-full pl-14 pr-6 py-4 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-purple-50 focus:border-brand-purple text-xs font-semibold shadow-sm transition-all outline-none placeholder:text-gray-300">
        </div>
        
        <!-- Category Filter -->
        <div class="w-full md:w-64 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-brand-purple group-focus-within:scale-110 transition-all duration-300 pointer-events-none">
                <i class="fas fa-tags text-sm"></i>
            </div>
            <select id="filterKategori" onchange="filterData()" class="w-full pl-14 pr-10 py-4 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-purple-50 focus:border-brand-purple text-xs font-semibold shadow-sm transition-all outline-none text-gray-700 appearance-none">
                <option value="ALL">Semua Kategori</option>
                <option value="RASMI">Bantuan Rasmi</option>
                <option value="KOMUNITI">Bantuan Komuniti</option>
            </select>
            <div class="absolute right-6 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none">
                <i class="fas fa-chevron-down text-xs"></i>
            </div>
        </div>

        <!-- Date Filter -->
        <div class="w-full md:w-64 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-brand-purple group-focus-within:scale-110 transition-all duration-300 pointer-events-none">
                <i class="far fa-calendar-alt text-sm"></i>
            </div>
            <input type="date" id="filterDate" onchange="filterData()" class="w-full pl-14 pr-6 py-4 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-purple-50 focus:border-brand-purple text-xs font-semibold shadow-sm transition-all outline-none text-gray-700">
        </div>

        <!-- Reset Button -->
        <button onclick="resetFilters()" class="px-6 py-4 rounded-[2rem] bg-white border border-gray-100 text-gray-400 hover:text-red-500 hover:border-red-100 focus:ring-4 focus:ring-red-50 text-xs font-bold shadow-sm transition-all flex items-center justify-center gap-2" title="Reset Tapisan">
            <i class="fas fa-sync-alt text-xs"></i>
            <span>Reset</span>
        </button>
    </div>

    <% if (request.getParameter("msg") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Rekod telah dikemaskini.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8" aria-label="Tabs">
            <button onclick="switchTab('baru')" id="tab-baru" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-brand-purple text-brand-purple">
                <i class="fas fa-clipboard-list"></i> Permohonan Baharu
                <% if (!listBaru.isEmpty()) { %>
                    <span class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= listBaru.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-history"></i> Sejarah Tindakan
            </button>
            <button onclick="switchTab('jenis')" id="tab-jenis" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-cog"></i> Pengurusan Jenis Bantuan
            </button>
        </nav>
    </div>

    <!-- TAB 1: PERMOHONAN BARU -->
    <div id="content-baru" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableBaru">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Kategori</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listBaru.isEmpty()) { 
                            int noBaru = 1;
                            for (PermohonanBantuan pb : listBaru) {
                                String namaBantuanDisplay = (pb.getNama_bantuan() != null) ? pb.getNama_bantuan() : "Lain-lain";
                                String dateDisplay = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="hover:bg-gray-50/50 transition data-row-filter cursor-pointer group" 
                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>" 
                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>"
                            <% 
                                StringBuilder sbDocs = new StringBuilder();
                                StringBuilder sbDocsAdmin = new StringBuilder();
                                if(pb.getSenaraiLampiran() != null) {
                                    for(model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                                        if("PEMOHON".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                            if(sbDocs.length() > 0) sbDocs.append(",");
                                            sbDocs.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                        } else if("PENTADBIR".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                            if(sbDocsAdmin.length() > 0) sbDocsAdmin.append(",");
                                            sbDocsAdmin.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                        }
                                    }
                                }
                                String jsDokumen = sbDocs.toString();
                                String jsDokumenAdmin = sbDocsAdmin.toString();
                            %>
                            data-id="<%= pb.getId_permohonan() %>"
                            data-bantuan="<%= (pb.getNama_bantuan() != null ? pb.getNama_bantuan().replace("\"", "&quot;") : "Lain-lain") %>"
                            data-pemohon="<%= pb.getNama_penuh().replace("\"", "&quot;") %>"
                            data-ket="<%= (pb.getCatatan_pemohon() != null ? pb.getCatatan_pemohon().replace("\"", "&quot;") : "") %>"
                            data-dok="<%= jsDokumen %>"
                            data-bank="<%= (pb.getNama_bank() != null ? pb.getNama_bank().replace("\"", "&quot;") : "") %>"
                            data-akaun="<%= (pb.getNombor_akaun() != null ? pb.getNombor_akaun().replace("\"", "&quot;") : "") %>"
                            data-penbank="<%= (pb.getPenyata_bank() != null ? pb.getPenyata_bank() : "") %>"
                            data-showaction="true"
                            data-ic="<%= (pb.getNombor_kp() != null ? pb.getNombor_kp() : "") %>"
                            data-phone="<%= (pb.getNombor_telefon() != null ? pb.getNombor_telefon() : "") %>"
                            data-statusk="<%= (pb.getStatus_keluarga() != null ? pb.getStatus_keluarga() : "") %>"
                            data-kerja="<%= (pb.getPekerjaan() != null ? pb.getPekerjaan() : "") %>"
                            data-gaji="<%= pb.getPendapatanFormatted() %>"
                            data-kategori="<%= pb.getJenis_bantuan() %>"
                            data-ulasan="<%= (pb.getCatatan_pentadbir() != null ? pb.getCatatan_pentadbir().replace("\"", "&quot;") : "") %>"
                            data-dokadmin="<%= jsDokumenAdmin %>"
                            data-score="<%= pb.getEligibilityScore() != null ? pb.getEligibilityScore() : 0.0 %>"
                            data-tier="<%= pb.getEligibilityTier() != null ? pb.getEligibilityTier() : "" %>"
                            data-flags="<%= pb.getEligibilityFlags() != null ? String.join(",", pb.getEligibilityFlags()) : "" %>"
                            onclick="viewDetail(this)">
                            <td class="p-4 text-sm text-gray-400 font-medium"><%= noBaru++ %></td>
                            <td class="p-4 text-sm text-gray-500"><%= dateDisplay %></td>
                            <td class="p-4 text-sm font-bold text-gray-800 group-hover:text-brand-purple transition-colors"><%= (pb.getNama_penuh() != null) ? pb.getNama_penuh() : "TIADA NAMA" %></td>
                            <td class="p-4 text-sm text-gray-600"><%= namaBantuanDisplay %></td>
                            <td class="p-4 text-center">
                                <% if ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan())) { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                                <% } else { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                        <tr id="tableBaru-empty" class="<%= !listBaru.isEmpty() ? "hidden" : "" %> empty-state-row">
                            <td colspan="5" class="p-12 text-center text-gray-400">
                                <i class="fas fa-inbox text-4xl mb-4 block opacity-20"></i>Tiada permohonan baharu.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination Footer for Permohonan Baharu -->
            <div id="footerBaru" class="p-6 bg-white border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
                <!-- Will be populated dynamically by JS -->
            </div>
        </div>
    </div>

    <!-- TAB 2: SEJARAH -->
    <div id="content-sejarah" class="hidden">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableSejarah">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) { 
                            int noSejarah = (currentPage - 1) * 10 + 1;
                            for (PermohonanBantuan pb : listSejarah) { %>
                        <tr class="hover:bg-gray-50/50 transition data-row-filter cursor-pointer group"
                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>" 
                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>"
                            <% 
                                StringBuilder sbDocsH = new StringBuilder();
                                StringBuilder sbDocsAdminH = new StringBuilder();
                                if(pb.getSenaraiLampiran() != null) {
                                    for(model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                                        if("PEMOHON".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                            if(sbDocsH.length() > 0) sbDocsH.append(",");
                                            sbDocsH.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                        } else if("PENTADBIR".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                            if(sbDocsAdminH.length() > 0) sbDocsAdminH.append(",");
                                            sbDocsAdminH.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                        }
                                    }
                                }
                                String jsDokumenH = sbDocsH.toString();
                                String jsDokumenAdminH = sbDocsAdminH.toString();
                            %>
                            data-id="<%= pb.getId_permohonan() %>"
                            data-bantuan="<%= (pb.getNama_bantuan() != null ? pb.getNama_bantuan().replace("\"", "&quot;") : "Lain-lain") %>"
                            data-pemohon="<%= pb.getNama_penuh().replace("\"", "&quot;") %>"
                            data-ket="<%= (pb.getCatatan_pemohon() != null ? pb.getCatatan_pemohon().replace("\"", "&quot;") : "") %>"
                            data-dok="<%= jsDokumenH %>"
                            data-bank="<%= (pb.getNama_bank() != null ? pb.getNama_bank().replace("\"", "&quot;") : "") %>"
                            data-akaun="<%= (pb.getNombor_akaun() != null ? pb.getNombor_akaun().replace("\"", "&quot;") : "") %>"
                            data-penbank="<%= (pb.getPenyata_bank() != null ? pb.getPenyata_bank() : "") %>"
                            data-showaction="false"
                            data-ic="<%= (pb.getNombor_kp() != null ? pb.getNombor_kp() : "") %>"
                            data-phone="<%= (pb.getNombor_telefon() != null ? pb.getNombor_telefon() : "") %>"
                            data-statusk="<%= (pb.getStatus_keluarga() != null ? pb.getStatus_keluarga() : "") %>"
                            data-kerja="<%= (pb.getPekerjaan() != null ? pb.getPekerjaan() : "") %>"
                            data-gaji="<%= pb.getPendapatanFormatted() %>"
                            data-kategori="<%= pb.getJenis_bantuan() %>"
                            data-ulasan="<%= (pb.getCatatan_pentadbir() != null ? pb.getCatatan_pentadbir().replace("\"", "&quot;") : "") %>"
                            data-dokadmin="<%= jsDokumenAdminH %>"
                            data-score="<%= pb.getEligibilityScore() != null ? pb.getEligibilityScore() : 0.0 %>"
                            data-tier="<%= pb.getEligibilityTier() != null ? pb.getEligibilityTier() : "" %>"
                            data-flags="<%= pb.getEligibilityFlags() != null ? String.join(",", pb.getEligibilityFlags()) : "" %>"
                            onclick="viewDetail(this)">
                            <td class="p-4 text-sm text-gray-400 font-medium"><%= noSejarah++ %></td>
                            <td class="p-4 text-sm text-gray-500"><%= sdf.format(pb.getDibuat_pada()) %></td>
                            <td class="p-4 text-sm font-bold text-gray-700 group-hover:text-brand-purple transition-colors"><%= pb.getNama_penuh() %></td>
                            <td class="p-4 text-sm text-gray-600"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4 text-center">
                                <% if ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan())) { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                                <% } else { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <% if ("LULUS".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-green-500 text-white uppercase shadow-sm">LULUS</span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-purple-500 text-white uppercase shadow-sm">DIMAJUKAN</span>
                                <% } else if ("DIKEMBALIKAN".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-orange-500 text-white uppercase shadow-sm">KEMBALI</span>
                                <% } else { %>
                                    <span class="px-3 py-1 rounded-full text-[10px] font-bold bg-red-500 text-white uppercase shadow-sm">DITOLAK</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } %>
                        <tr id="tableSejarah-empty" class="<%= !listSejarah.isEmpty() ? "hidden" : "" %> empty-state-row">
                            <td colspan="6" class="p-12 text-center text-gray-400">
                                <i class="fas fa-history text-4xl mb-4 block opacity-20"></i>Tiada sejarah rekod.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination Footer for Sejarah -->
            <div class="p-6 bg-white border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
                <div class="text-xs text-gray-500 font-medium">
                    Menunjukkan halaman <span class="text-gray-900 font-bold"><%= currentPage %></span> daripada <span class="text-gray-900 font-bold"><%= totalPages %></span> 
                    (<%= totalCount %> rekod keseluruhan)
                </div>
                
                <div class="flex items-center gap-2">
                    <% if(currentPage > 1) { %>
                        <a href="?page=<%= currentPage - 1 %>" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">
                            <i class="fas fa-chevron-left"></i> Sebelumnya
                        </a>
                    <% } else { %>
                        <button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">
                            <i class="fas fa-chevron-left"></i> Sebelumnya
                        </button>
                    <% } %>

                    <div class="flex items-center gap-1">
                        <% 
                            int startPage = Math.max(1, currentPage - 2);
                            int endPage = Math.min(totalPages, startPage + 4);
                            if (endPage - startPage < 4) startPage = Math.max(1, endPage - 4);
                            
                            for(int i = startPage; i <= endPage; i++) { 
                        %>
                            <a href="?page=<%= i %>" 
                               class="w-9 h-9 flex items-center justify-center rounded-xl text-xs font-bold transition-all
                                      <%= (i == currentPage) ? "bg-brand-purple text-white shadow-lg shadow-purple-100" : "bg-white text-gray-500 hover:bg-gray-50 border border-gray-100" %>">
                                <%= i %>
                            </a>
                        <% } %>
                    </div>

                    <% if(currentPage < totalPages) { %>
                        <a href="?page=<%= currentPage + 1 %>" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">
                            Seterusnya <i class="fas fa-chevron-right"></i>
                        </a>
                    <% } else { %>
                        <button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">
                            Seterusnya <i class="fas fa-chevron-right"></i>
                        </button>
                    <% } %>

                    <!-- Lompat Ke Page Selector -->
                    <div class="flex items-center gap-1.5 text-xs text-gray-500 font-medium border-l border-gray-200 pl-4 ml-2">
                        <span>Lompat ke:</span>
                        <input type="number" min="1" max="<%= totalPages %>" value="<%= currentPage %>" 
                               onkeypress="if(event.key === 'Enter') { const p = parseInt(this.value); if(p >= 1 && p <= <%= totalPages %>) { window.location.href = '?page=' + p; } }"
                               class="w-12 h-9 px-2 text-center bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-700 outline-none focus:ring-2 focus:ring-brand-purple focus:border-brand-purple [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TAB 3: JENIS BANTUAN -->
    <div id="content-jenis" class="hidden">
        <div class="flex justify-between items-center mb-6">
            <h3 class="font-bold text-lg text-gray-800">Senarai Konfigurasi Bantuan</h3>
            <button onclick="openModal('modalTambahBantuan')" class="inline-flex items-center gap-2 px-5 py-3.5 rounded-2xl bg-brand-purple text-white hover:bg-opacity-90 shadow-md transition-all text-xs font-black uppercase tracking-wider">
                <i class="fas fa-plus"></i> Tambah Bantuan
            </button>
        </div>
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse" id="tableJenis">
                <thead>
                    <tr class="bg-gray-50 border-b border-gray-100">
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-16">No.</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Nama Bantuan</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Kategori</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Peruntukan</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Syarat Dokumen</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (senaraiBantuan != null && !senaraiBantuan.isEmpty()) { 
                        int noJenis = 1;
                        for (Bantuan b : senaraiBantuan) { %>
                    <tr class="hover:bg-gray-50/50 transition group data-jenis-row" data-category="<%= b.getJenis_bantuan() %>">
                        <td class="p-4 text-sm text-gray-400 font-medium"><%= noJenis++ %></td>
                        <td class="p-4 text-sm font-bold text-gray-800 group-hover:text-brand-purple transition-colors"><%= b.getNama_bantuan() %></td>
                        <td class="p-4 text-center">
                            <% if ("RASMI".equalsIgnoreCase(b.getJenis_bantuan())) { %>
                                <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                            <% } else { %>
                                <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                            <% } %>
                        </td>
                        <td class="p-4 text-sm text-gray-600 font-medium"><%= b.getJumlahBantuanFormatted() %></td>
                        <td class="p-4 text-sm text-gray-600 max-w-xs truncate" title="<%= (b.getSyarat_dokumen() != null) ? b.getSyarat_dokumen() : "" %>">
                            <%= (b.getSyarat_dokumen() != null) ? b.getSyarat_dokumen() : "Tiada syarat khusus" %>
                        </td>
                        <td class="p-4 text-center">
                            <div class="flex justify-center gap-2">
                                <button onclick="openEditBantuanModal('<%= b.getId_bantuan() %>', '<%= b.getNama_bantuan().replace("'", "\\'") %>', '<%= b.getJenis_bantuan() %>', '<%= b.getJumlah_bantuan() %>', '<%= (b.getSyarat_dokumen() != null ? b.getSyarat_dokumen().replace("'", "\\'") : "") %>')" 
                                        class="w-9 h-9 flex items-center justify-center rounded-xl text-blue-600 hover:bg-blue-50/80 border border-transparent hover:border-blue-100 shadow-sm transition-all" title="Edit">
                                    <i class="fas fa-edit text-xs"></i>
                                </button>
                                <form action="<%= request.getContextPath() %>/bantuan/padamJenisBantuan" method="post" class="inline" onsubmit="return confirm('Padam jenis bantuan ini?')">
                                    <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                                    <input type="hidden" name="id" value="<%= b.getId_bantuan() %>">
                                    <button type="submit" class="w-9 h-9 flex items-center justify-center rounded-xl text-red-600 hover:bg-red-50/80 border border-transparent hover:border-red-100 shadow-sm transition-all" title="Padam">
                                        <i class="fas fa-trash text-xs"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                    <tr id="tableJenis-empty" class="<%= (senaraiBantuan != null && !senaraiBantuan.isEmpty()) ? "hidden" : "" %> empty-state-row">
                        <td colspan="6" class="p-12 text-center text-gray-400">
                            <i class="fas fa-cog text-4xl mb-4 block opacity-20"></i>Tiada jenis bantuan dikonfigurasi.
                        </td>
                    </tr>
                </tbody>
            </table>
            
            <!-- Pagination Footer for Jenis Bantuan -->
            <div id="footerJenis" class="p-6 bg-white border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
                <!-- Will be populated dynamically by JS -->
            </div>
        </div>
    </div>
</div>

<!-- Right Aside Bar (Summary) -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800">Rumusan Bantuan</h3>
        <p class="text-xs text-gray-400 font-medium">Status permohonan semasa</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100 shadow-sm">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Perlu Semakan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listBaru.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-purple-100 text-brand-purple flex items-center justify-center">
                <i class="fas fa-clipboard-check"></i>
            </div>
        </div>
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100 shadow-sm">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Jumlah Sejarah</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listSejarah.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-gray-100 text-gray-500 flex items-center justify-center">
                <i class="fas fa-history"></i>
            </div>
        </div>
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100 shadow-sm">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Jenis Bantuan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= (senaraiBantuan != null) ? senaraiBantuan.size() : 0 %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-600 flex items-center justify-center">
                <i class="fas fa-cog"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Panduan AJK</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-xs border-2 border-brand-purple z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Semak Dokumen</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Pastikan semua lampiran PDF yang dihantar oleh penduduk adalah lengkap dan sahih.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Majukan Kes</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Permohonan yang lengkap akan dimajukan kepada Ketua Kampung untuk kelulusan akhir.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">3</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Maklum Balas</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Gunakan fungsi 'Kembali' jika terdapat dokumen yang kurang lengkap untuk penduduk kemaskini.</p>
            </div>
        </div>
    </div>

    <div class="p-6 bg-brand-purple/5 rounded-3xl border border-brand-purple/10">
        <div class="flex items-center gap-3 mb-3">
            <div class="w-8 h-8 rounded-lg bg-brand-purple text-white flex items-center justify-center">
                <i class="fas fa-info-circle"></i>
            </div>
            <h4 class="font-bold text-xs text-gray-800">Nota Integriti</h4>
        </div>
        <p class="text-[10px] text-gray-500 leading-relaxed italic">
            "Bantuan yang tepat kepada mereka yang layak adalah tanggungjawab bersama."
</p>
    </div>
</aside>

<!-- MODAL: DETAIL PERMOHONAN (INCLUDING BANK) -->
<div id="modalDetail" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeModal('modalDetail')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-3xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-white/20 flex flex-col max-h-[90vh]">
            <!-- Modal Header with Gradient (Fixed) -->
            <div class="bg-gradient-to-r from-brand-purple to-brand-secondary px-8 py-6 text-white relative shrink-0">
                <div class="absolute top-0 right-0 p-6 opacity-10">
                    <i class="fas fa-file-invoice text-8xl rotate-12"></i>
                </div>
                <div class="flex justify-between items-start relative z-10">
                    <div>
                        <span id="detId" class="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase border border-white/20">#000</span>
                        <h3 class="text-2xl font-bold mt-2" id="detBantuan">-</h3>
                    </div>
                    <button onclick="closeModal('modalDetail')" class="w-10 h-10 flex items-center justify-center rounded-full bg-white/10 hover:bg-white/20 transition-all">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>

            <!-- Scrollable Content Area -->
            <div class="p-8 overflow-y-auto custom-scrollbar flex-1">
                <div class="space-y-8">
                    <!-- Profile Section -->
                    <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-gray-100 pb-6">
                        <div class="space-y-1">
                            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Maklumat Pemohon</p>
                            <h4 id="detPemohon" class="text-2xl font-extrabold text-gray-800">-</h4>
                            <div class="flex flex-wrap gap-4 mt-2">
                                <div class="flex items-center gap-2 text-sm text-gray-500">
                                    <i class="far fa-id-card text-brand-purple"></i>
                                    <span id="detIC" class="font-medium">-</span>
                                </div>
                                <div class="flex items-center gap-2 text-sm text-gray-500">
                                    <i class="fas fa-phone-alt text-brand-purple"></i>
                                    <span id="detPhone" class="font-medium">-</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Eligibility Score Panel -->
                    <div class="bg-gradient-to-r from-slate-50 to-slate-100/50 p-6 rounded-[2rem] border border-slate-200/60 shadow-sm mb-6 flex flex-col md:flex-row items-center gap-6">
                        <!-- Score Circle -->
                        <div class="relative flex items-center justify-center shrink-0">
                            <div id="detScoreBadge" class="w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 shadow-inner bg-white">
                                <span id="detScoreValue" class="text-3xl font-black text-slate-800">0</span>
                                <span class="text-[9px] font-bold text-gray-400 uppercase tracking-widest">SKOR</span>
                            </div>
                        </div>
                        <!-- Score Info & Bar -->
                        <div class="flex-1 w-full space-y-2">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h5 class="text-sm font-black text-gray-800">Keputusan Skor Kelayakan</h5>
                                    <p class="text-[10px] text-gray-400 font-medium">Berdasarkan data sosio-ekonomi penduduk semasa.</p>
                                </div>
                                <span id="detTierBadge" class="px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider"></span>
                            </div>
                            <!-- Progress Bar -->
                            <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                                <div id="detScoreProgress" class="h-full rounded-full transition-all duration-500" style="width: 0%"></div>
                            </div>
                            <!-- Indicator flags -->
                            <div id="detFlagsContainer" class="flex flex-wrap gap-2 pt-1">
                                <!-- Dynamic Flags -->
                            </div>
                        </div>
                    </div>

                    <!-- Main Content Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <!-- Socio-Economic Card -->
                        <div class="space-y-4">
                            <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-chart-pie text-indigo-400"></i> Profil Sosio-Ekonomi
                            </h5>
                            <div class="grid grid-cols-1 gap-3">
                                <div class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                    <span class="text-xs text-slate-500 font-medium">Status Keluarga</span>
                                    <span id="detStatusK" class="text-sm font-bold text-slate-700">-</span>
                                </div>
                                <div class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                    <span class="text-xs text-slate-500 font-medium">Pekerjaan</span>
                                    <span id="detPekerjaan" class="text-sm font-bold text-slate-700">-</span>
                                </div>
                                <div class="flex items-center justify-between p-4 bg-indigo-50/50 rounded-2xl border border-indigo-100">
                                    <span class="text-xs text-indigo-600 font-bold">Pendapatan Bulanan</span>
                                    <span id="detPendapatan" class="text-sm font-black text-indigo-700">-</span>
                                </div>
                            </div>
                        </div>

                        <!-- Bank Information Card -->
                        <div class="space-y-4">
                            <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-university text-blue-400"></i> Maklumat Perbankan
                            </h5>
                            <div id="bankCard" class="bg-blue-50/50 p-6 rounded-[2rem] border border-blue-100 relative overflow-hidden h-full">
                                <div class="absolute -right-4 -bottom-4 opacity-5">
                                    <i class="fas fa-credit-card text-7xl"></i>
                                </div>
                                <div class="space-y-4 relative z-10">
                                    <div>
                                        <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nama Bank</p>
                                        <p id="detBank" class="font-bold text-blue-900 uppercase tracking-wide text-lg">-</p>
                                    </div>
                                    <div>
                                        <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nombor Akaun</p>
                                        <p id="detAkaun" class="font-bold text-blue-900 text-xl tracking-widest">-</p>
                                    </div>
                                    <div class="pt-2">
                                        <a id="detDokBank" href="#" target="_blank" class="inline-flex items-center gap-2 px-4 py-2.5 bg-white text-blue-600 rounded-xl text-xs font-bold shadow-sm border border-blue-100 hover:shadow-md transition-all">
                                            <i class="fas fa-file-invoice-dollar"></i> Lihat Penyata Bank
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- AI Decision Support and Recommendation Box -->
                    <div id="aiSupportDiv" class="space-y-4 pt-6 border-t border-gray-100">
                        <h5 class="text-[11px] font-bold text-brand-purple uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-robot"></i> Sokongan Keputusan AI & Had Kelayakan
                        </h5>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <!-- Syor Automatik -->
                            <div class="md:col-span-2 p-6 rounded-3xl border flex flex-col justify-between" id="aiRecommendCard">
                                <div>
                                    <div class="flex items-center justify-between mb-3">
                                        <span class="text-xs font-bold text-gray-400 uppercase tracking-wide">Pengesyoran Sistem</span>
                                        <span id="aiRecommendBadge" class="px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider"></span>
                                    </div>
                                    <h4 class="text-lg font-black text-gray-800" id="aiRecommendTitle">-</h4>
                                    <p class="text-xs text-gray-500 leading-relaxed mt-2" id="aiRecommendDesc">-</p>
                                </div>
                                <div class="mt-4 pt-3 border-t border-gray-100/60 hidden" id="aiAutoRejectionInfo">
                                    <p class="text-[10px] text-rose-500 font-bold"><i class="fas fa-magic"></i> Templat sebab penolakan automatik telah sedia dijana.</p>
                                </div>
                            </div>
                            <!-- Senarai Semak Manual -->
                            <div class="p-6 rounded-3xl border border-slate-200/80 bg-slate-50 flex flex-col justify-between" id="manualChecklistCard">
                                <div>
                                    <h5 class="text-xs font-bold text-slate-700 uppercase tracking-wide mb-3 flex items-center gap-1.5">
                                        <i class="fas fa-tasks text-slate-500"></i> Semakan Manual AJK
                                    </h5>
                                    <div class="space-y-2.5" id="checklistContainer">
                                        <!-- Dynamic Checkboxes -->
                                    </div>
                                </div>
                                <div class="mt-4 pt-2 text-[10px] text-gray-400 font-medium">
                                    *Sahkan semua kriteria untuk menyokong.
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Feedback Section (Admin Feedback) -->
                    <div id="ulasanDiv" class="space-y-4 pt-4 border-t border-gray-100 hidden">
                        <h5 class="text-[11px] font-bold text-orange-400 uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-comment-dots"></i> Maklum Balas Semasa
                        </h5>
                        <div class="bg-orange-50/50 p-6 rounded-[2rem] border border-orange-100 relative">
                            <i class="fas fa-quote-left absolute top-4 left-4 text-orange-100 text-3xl"></i>
                            <div class="relative z-10 pl-8">
                                <p id="detUlasan" class="text-sm text-gray-700 leading-relaxed font-medium italic">-</p>
                            </div>
                        </div>
                    </div>

                    <!-- Bottom Section: Keterangan & Documents -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 pt-4">
                        <div class="space-y-3">
                            <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-align-left text-gray-400"></i> Keterangan Permohonan
                            </h5>
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 relative">
                                <i class="fas fa-quote-left absolute top-4 left-4 text-gray-200 text-xl"></i>
                                <p id="detKeterangan" class="text-sm text-gray-600 leading-relaxed pl-6 italic">
                                    -
                                </p>
                            </div>
                        </div>
                        <div class="space-y-3">
                            <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-folder-open text-gray-400"></i> Dokumen Sokongan
                            </h5>
                        <div id="dokumenList" class="flex flex-wrap gap-2">
                            <!-- Dynamic Documents -->
                        </div>
                        <%-- Template hidden separate from the list to prevent destruction --%>
                        <div class="hidden">
                            <a id="detDokMain" href="#" target="_blank" class="inline-flex items-center gap-2 px-4 py-2.5 bg-red-50 text-red-600 rounded-xl text-xs font-bold hover:bg-red-100 transition shadow-sm border border-red-100">
                                <i class="fas fa-file-pdf"></i> PDF
                            </a>
                        </div>
                    </div>
                </div>

                    <!-- Admin Documents Section -->
                    <div id="detAdminDokSection" class="space-y-4 pt-4 border-t border-gray-100 hidden">
                        <label class="block text-[10px] font-bold text-brand-purple uppercase tracking-widest mb-2">Dokumen Maklum Balas (Ketua Kampung)</label>
                        <div id="dokumenAdminList" class="flex flex-wrap gap-2">
                            <!-- Dynamic Admin Files -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- Enhanced Footer / Action Bar (Fixed) -->
            <div class="bg-slate-50 p-8 flex flex-col sm:flex-row justify-between items-center gap-4 border-t border-slate-100 shrink-0">
                <button onclick="closeModal('modalDetail')" class="order-2 sm:order-1 text-sm font-bold text-slate-400 hover:text-slate-600 transition-colors px-4 py-2">
                    Kembali ke Senarai
                </button>
                
                <div id="detActionBox" class="order-1 sm:order-2 flex gap-4 hidden">
                    <button id="btnDetReject" class="px-8 py-3 rounded-2xl border border-rose-200 text-rose-600 font-bold text-sm hover:bg-rose-50 transition-all active:scale-95">
                        <i class="fas fa-undo mr-2"></i> Kembalikan
                    </button>
                    <button id="btnDetApprove" class="px-8 py-3 rounded-2xl bg-gradient-to-r from-emerald-500 to-teal-600 text-white font-bold text-sm hover:shadow-lg hover:shadow-emerald-200 transition-all active:scale-95 shadow-md">
                        <i class="fas fa-check mr-2"></i> Sahkan & Hantar
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: TAMBAH JENIS BANTUAN -->
<div id="modalTambahBantuan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalTambahBantuan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-lg overflow-hidden">
            <div class="bg-brand-purple p-4 text-white font-bold flex justify-between items-center">
                <span>Tambah Jenis Bantuan</span>
                <button onclick="closeModal('modalTambahBantuan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/tambahJenisBantuan" method="post" class="p-6 space-y-4">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Nama Bantuan</label>
                    <input type="text" name="namaBantuan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-brand-purple outline-none transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Kategori</label>
                    <select name="jenisBantuan" class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-brand-purple outline-none transition">
                        <option value="KOMUNITI">KOMUNITI</option>
                        <option value="RASMI">RASMI</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Peruntukan (RM)</label>
                    <input type="number" step="0.01" name="peruntukan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-brand-purple outline-none transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Syarat Dokumen Wajib</label>
                    <textarea name="syaratDokumen" rows="3" placeholder="Contoh: Salinan IC, Penyata Gaji, Sijil Kematian..." class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-brand-purple outline-none transition text-sm"></textarea>
                    <p class="text-[10px] text-gray-400 mt-1 italic">Pisahkan setiap syarat dengan koma (,).</p>
                </div>
                <div class="flex justify-end gap-2 pt-4">
                    <button type="button" onclick="closeModal('modalTambahBantuan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" class="px-6 py-2 bg-brand-purple text-white rounded-xl font-bold shadow-md hover:bg-brand-purpleHover transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: EDIT JENIS BANTUAN -->
<div id="modalEditBantuan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalEditBantuan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-lg overflow-hidden">
            <div class="bg-brand-purple p-4 text-white font-bold flex justify-between items-center">
                <span>Kemaskini Jenis Bantuan</span>
                <button onclick="closeModal('modalEditBantuan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/kemaskiniJenisBantuan" method="post" class="p-6 space-y-4">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="idBantuan" id="editId">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Nama Bantuan</label>
                    <input type="text" name="namaBantuan" id="editNama" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Kategori</label>
                    <select name="jenisBantuan" id="editJenis" class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                        <option value="KOMUNITI">KOMUNITI</option>
                        <option value="RASMI">RASMI</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Peruntukan (RM)</label>
                    <input type="number" step="0.01" name="peruntukan" id="editPeruntukan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Syarat Dokumen Wajib</label>
                    <textarea name="syaratDokumen" id="editSyarat" rows="3" class="w-full px-4 py-2 bg-gray-50 border rounded-xl text-sm"></textarea>
                </div>
                <div class="flex justify-end gap-2 pt-4">
                    <button type="button" onclick="closeModal('modalEditBantuan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" class="px-6 py-2 bg-brand-purple text-white rounded-xl font-bold shadow-md transition">Kemaskini</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: TINDAKAN (LENGKAP/TAK LENGKAP) -->
<div id="modalTindakan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalTindakan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-md overflow-hidden">
            <div class="bg-gray-50 p-4 font-bold border-b flex justify-between items-center">
                <span id="actTitle">Tindakan AJK</span>
                <button onclick="closeModal('modalTindakan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/reviewAJK" method="post" class="p-6">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="idPermohonan" id="actId">
                <input type="hidden" name="keputusan" id="actDecision">
                <div id="boxLengkap" class="hidden text-center py-4">
                    <div class="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl"><i class="fas fa-check"></i></div>
                    <p class="font-bold text-gray-800">Sahkan Dokumen Lengkap?</p>
                    <p class="text-xs text-gray-500 mt-2">Permohonan ini akan dihantar ke Ketua Kampung.</p>
                </div>
                <div id="boxTakLengkap" class="hidden py-2">
                    <div class="w-12 h-12 bg-red-100 text-red-600 rounded-full flex items-center justify-center mb-4 text-xl"><i class="fas fa-exclamation-triangle"></i></div>
                    <p class="font-bold text-gray-800 mb-2">Nyatakan Sebab (Tidak Lengkap)</p>
                    <textarea name="ulasan" id="actUlasan" rows="3" class="w-full px-4 py-2 bg-gray-50 border rounded-xl text-sm" placeholder="Contoh: Lampiran PDF tidak boleh dibuka..."></textarea>
                </div>
                <div class="flex justify-end gap-2 mt-6">
                    <button type="button" onclick="closeModal('modalTindakan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" id="actSubmitBtn" class="px-6 py-2 rounded-xl font-bold text-white transition shadow-md"></button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    const clientPaginators = {};

    function initClientPagination(tableId, footerId, itemsPerPage = 10) {
        clientPaginators[tableId] = {
            footerId: footerId,
            itemsPerPage: itemsPerPage,
            currentPage: 1
        };
        updateClientPagination(tableId);
    }

    function updateClientPagination(tableId) {
        const paginator = clientPaginators[tableId];
        if (!paginator) return;

        const table = document.getElementById(tableId);
        const footer = document.getElementById(paginator.footerId);
        if (!table || !footer) return;

        const tbody = table.querySelector('tbody');
        const allRows = Array.from(tbody.querySelectorAll('tr:not(.empty-state-row)'));
        const visibleRows = allRows.filter(row => row.getAttribute('data-search-hidden') !== 'true');

        const totalItems = visibleRows.length;
        const totalPages = Math.ceil(totalItems / paginator.itemsPerPage) || 1;

        if (paginator.currentPage > totalPages) {
            paginator.currentPage = totalPages;
        }
        if (paginator.currentPage < 1) {
            paginator.currentPage = 1;
        }

        allRows.forEach(row => {
            row.style.display = 'none';
        });

        const startIndex = (paginator.currentPage - 1) * paginator.itemsPerPage;
        const endIndex = startIndex + paginator.itemsPerPage;

        visibleRows.forEach((row, index) => {
            if (index >= startIndex && index < endIndex) {
                row.style.display = '';
            }
        });

        // Show/hide empty state
        const emptyRow = document.getElementById(tableId + '-empty');
        if (emptyRow) {
            if (totalItems === 0) {
                emptyRow.classList.remove('hidden');
            } else {
                emptyRow.classList.add('hidden');
            }
        }

        renderClientFooter(tableId, footer, paginator.currentPage, totalPages, totalItems);
    }

    function renderClientFooter(tableId, footer, currentPage, totalPages, totalItems) {
        let pagesHtml = '';
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, startPage + 4);
        
        for (let i = startPage; i <= endPage; i++) {
            if (i === currentPage) {
                pagesHtml += `
                    <button type="button" class="w-9 h-9 flex items-center justify-center rounded-xl text-xs font-bold bg-brand-purple text-white shadow-lg shadow-purple-100">
                        \${i}
                    </button>
                `;
            } else {
                pagesHtml += `
                    <button type="button" onclick="setClientPage('\${tableId}', \${i})" class="w-9 h-9 flex items-center justify-center rounded-xl text-xs font-bold bg-white text-gray-500 hover:bg-gray-50 border border-gray-100 transition">
                        \${i}
                    </button>
                `;
            }
        }

        footer.innerHTML = `
            <div class="text-xs text-gray-500 font-medium">
                Menunjukkan halaman <span class="text-gray-900 font-bold">\${currentPage}</span> daripada <span class="text-gray-900 font-bold">\${totalPages}</span> 
                (\${totalItems} rekod keseluruhan)
            </div>
            
            <div class="flex items-center gap-2">
                \${currentPage > 1 ? `
                    <button type="button" onclick="setClientPage('\${tableId}', \${currentPage - 1})" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">
                        <i class="fas fa-chevron-left"></i> Sebelumnya
                    </button>
                ` : `
                    <button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">
                        <i class="fas fa-chevron-left"></i> Sebelumnya
                    </button>
                `}

                <div class="flex items-center gap-1">
                    \${pagesHtml}
                </div>

                \${currentPage < totalPages ? `
                    <button type="button" onclick="setClientPage('\${tableId}', \${currentPage + 1})" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">
                        Seterusnya <i class="fas fa-chevron-right"></i>
                    </button>
                ` : `
                    <button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">
                        Seterusnya <i class="fas fa-chevron-right"></i>
                    </button>
                `}

                <!-- Lompat Ke Page Selector -->
                <div class="flex items-center gap-1.5 text-xs text-gray-500 font-medium border-l border-gray-200 pl-4 ml-2">
                    <span>Lompat ke:</span>
                    <input type="number" min="1" max="\${totalPages}" value="\${currentPage}" 
                           onkeypress="if(event.key === 'Enter') { const p = parseInt(this.value); if(p >= 1 && p <= \${totalPages}) { setClientPage('\${tableId}', p); } }"
                           class="w-12 h-9 px-2 text-center bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-700 outline-none focus:ring-2 focus:ring-brand-purple focus:border-brand-purple [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none">
                </div>
            </div>
        `;
    }

    function setClientPage(tableId, page) {
        if (clientPaginators[tableId]) {
            clientPaginators[tableId].currentPage = page;
            updateClientPagination(tableId);
        }
    }

    function resetFilters() {
        document.getElementById('searchPemohon').value = '';
        document.getElementById('filterKategori').value = 'ALL';
        document.getElementById('filterDate').value = '';
        filterData();
    }

    function filterData() {
        const search = document.getElementById('searchPemohon').value.toLowerCase();
        const category = document.getElementById('filterKategori').value;
        const dateVal = document.getElementById('filterDate').value;

        // Filter tableBaru rows
        const baruRows = document.querySelectorAll('#tableBaru tbody tr:not(.empty-state-row)');
        baruRows.forEach(row => {
            const rowSearch = row.getAttribute('data-search').toLowerCase();
            const rowCategory = row.getAttribute('data-category');
            const rowDate = row.getAttribute('data-date');

            let show = true;

            if (search && !rowSearch.includes(search)) show = false;
            if (category !== 'ALL' && rowCategory !== category) show = false;
            if (dateVal && rowDate !== dateVal) show = false;

            row.setAttribute('data-search-hidden', show ? 'false' : 'true');
        });
        updateClientPagination('tableBaru');

        // Filter tableSejarah rows
        const sejarahRows = document.querySelectorAll('#tableSejarah tbody tr:not(.empty-state-row)');
        let sejarahVisibleCount = 0;
        sejarahRows.forEach(row => {
            const rowSearch = row.getAttribute('data-search').toLowerCase();
            const rowCategory = row.getAttribute('data-category');
            const rowDate = row.getAttribute('data-date');

            let show = true;

            if (search && !rowSearch.includes(search)) show = false;
            if (category !== 'ALL' && rowCategory !== category) show = false;
            if (dateVal && rowDate !== dateVal) show = false;

            if (show) {
                row.style.display = '';
                sejarahVisibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        const sejarahEmpty = document.getElementById('tableSejarah-empty');
        if (sejarahEmpty) {
            if (sejarahVisibleCount === 0) {
                sejarahEmpty.classList.remove('hidden');
            } else {
                sejarahEmpty.classList.add('hidden');
            }
        }

        // Filter tableJenis rows
        const jenisRows = document.querySelectorAll('.data-jenis-row');
        jenisRows.forEach(row => {
            const rowCategory = row.getAttribute('data-category');
            let show = true;
            if (category !== 'ALL' && rowCategory !== category) show = false;
            
            row.setAttribute('data-search-hidden', show ? 'false' : 'true');
        });
        updateClientPagination('tableJenis');
    }

    function switchTab(tabName) {
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-brand-purple', 'text-brand-purple', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });
        document.getElementById('tab-' + tabName).classList.add('border-brand-purple', 'text-brand-purple', 'font-bold');
        document.getElementById('content-baru').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        document.getElementById('content-jenis').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    // Auto-switch to sejarah tab if page param exists, and init client pagination
    window.addEventListener('DOMContentLoaded', function() {
        initClientPagination('tableBaru', 'footerBaru', 10);
        initClientPagination('tableJenis', 'footerJenis', 10);

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('page')) {
            switchTab('sejarah');
        }
    });

    // Functions centralized in footer.jsp

    let currentScore = 0;

    function getFlagBadge(flag) {
        switch (flag) {
            case 'TIADA_PENDAPATAN':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-hand-holding-usd"></i> Tiada Pendapatan</span>';
            case 'PENDAPATAN_SANGAT_RENDAH':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-arrow-down"></i> Pendapatan Sangat Rendah</span>';
            case 'PENDAPATAN_RENDAH':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-600 text-xs font-bold"><i class="fas fa-arrow-down text-[10px]"></i> Pendapatan Rendah</span>';
            case 'TANGGUNGAN_SANGAT_RAMAI':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-users"></i> Tanggungan Sangat Ramai</span>';
            case 'TANGGUNGAN_RAMAI':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-600 text-xs font-bold"><i class="fas fa-user-friends"></i> Tanggungan Ramai</span>';
            case 'IBU_BAPA_TUNGGAL':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-purple-50 border border-purple-200 text-purple-600 text-xs font-bold"><i class="fas fa-child"></i> Ibu/Bapa Tunggal</span>';
            case 'OKU':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-indigo-50 border border-indigo-200 text-indigo-600 text-xs font-bold"><i class="fas fa-wheelchair"></i> OKU</span>';
            case 'TIADA_KERJA':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-user-slash"></i> Tiada Pekerjaan</span>';
            case 'KERJA_SEKTOR_TIDAK_FORMAL':
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-blue-50 border border-blue-200 text-blue-600 text-xs font-bold"><i class="fas fa-tools"></i> Sektor Tidak Formal</span>';
            default:
                return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-50 border border-gray-200 text-gray-600 text-xs font-bold">' + flag + '</span>';
        }
    }

    function populateDecisionSupport(scoreVal, tier, flagsStr, statusK, kerja, bank, akaun, gaji, kategori, showAction) {
        const flags = flagsStr ? flagsStr.split(',') : [];
        
        // 1. Eligibility Score Panel values
        const detScoreValue = document.getElementById('detScoreValue');
        const detScoreProgress = document.getElementById('detScoreProgress');
        const detTierBadge = document.getElementById('detTierBadge');
        const detScoreBadge = document.getElementById('detScoreBadge');
        
        if (detScoreValue && detScoreProgress && detTierBadge && detScoreBadge) {
            detScoreValue.innerText = scoreVal.toFixed(0);
            detScoreProgress.style.width = scoreVal + '%';
            detTierBadge.innerText = tier || 'RENDAH';
            
            if (scoreVal >= 80) {
                detScoreProgress.className = "h-full rounded-full bg-emerald-500 transition-all duration-500";
                detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-emerald-50 text-emerald-600 border border-emerald-200";
                detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-emerald-500 shadow-inner bg-white";
            } else if (scoreVal >= 40) {
                detScoreProgress.className = "h-full rounded-full bg-amber-500 transition-all duration-500";
                detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-amber-50 text-amber-600 border border-amber-200";
                detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-amber-500 shadow-inner bg-white";
            } else {
                detScoreProgress.className = "h-full rounded-full bg-rose-500 transition-all duration-500";
                detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-rose-50 text-rose-600 border border-rose-200";
                detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-rose-500 shadow-inner bg-white";
            }
        }
        
        // 2. Flags Container
        const detFlagsContainer = document.getElementById('detFlagsContainer');
        if (detFlagsContainer) {
            detFlagsContainer.innerHTML = '';
            if (flags.length > 0 && flags[0] !== "") {
                flags.forEach(f => {
                    detFlagsContainer.innerHTML += getFlagBadge(f);
                });
            } else {
                detFlagsContainer.innerHTML = '<span class="text-xs text-gray-400 italic">Tiada indikator kelayakan dikesan.</span>';
            }
        }
        
        // 3. AI Recommendation & Checklist
        const aiRecommendCard = document.getElementById('aiRecommendCard');
        const aiRecommendBadge = document.getElementById('aiRecommendBadge');
        const aiRecommendTitle = document.getElementById('aiRecommendTitle');
        const aiRecommendDesc = document.getElementById('aiRecommendDesc');
        const aiAutoRejectionInfo = document.getElementById('aiAutoRejectionInfo');
        const checklistContainer = document.getElementById('checklistContainer');
        
        if (aiRecommendCard && aiRecommendBadge && aiRecommendTitle && aiRecommendDesc && checklistContainer) {
            checklistContainer.innerHTML = '';
            
            let syorTitle = '';
            let syorDesc = '';
            let syorBadgeText = '';
            let cardClass = '';
            let badgeClass = '';
            
            if (scoreVal >= 80) {
                syorBadgeText = 'Cadangan Lulus';
                syorTitle = 'Sangat Layak Disokong';
                syorDesc = 'Pemohon mempunyai skor kelayakan yang sangat tinggi (' + scoreVal.toFixed(0) + '%). Status sosio-ekonomi pemohon berada dalam kumpulan keutamaan tinggi untuk menerima bantuan ini.';
                cardClass = 'bg-emerald-50/40 border-emerald-100 p-6 rounded-3xl border flex flex-col justify-between';
                badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-emerald-100 text-emerald-700';
                if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
            } else if (scoreVal >= 40) {
                syorBadgeText = 'Semakan Mendalam';
                syorTitle = 'Kelayakan Sederhana';
                syorDesc = 'Pemohon mempunyai skor kelayakan sederhana (' + scoreVal.toFixed(0) + '%). Sosio-ekonominya layak tetapi memerlukan semakan rapi oleh AJK Kampung. Pastikan penyata pendapatan dan bilangan tanggungan disahkan secara manual.';
                cardClass = 'bg-amber-50/40 border-amber-100 p-6 rounded-3xl border flex flex-col justify-between';
                badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-amber-100 text-amber-700';
                if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
            } else {
                syorBadgeText = 'Cadangan Tolak';
                syorTitle = 'Tidak Menepati Kriteria';
                syorDesc = 'Pemohon mempunyai skor kelayakan yang rendah (' + scoreVal.toFixed(0) + '%). Berdasarkan penilaian, status pendapatan berada di atas paras kemiskinan dan pemohon mempunyai keupayaan sara diri yang mencukupi.';
                cardClass = 'bg-rose-50/40 border-rose-100 p-6 rounded-3xl border flex flex-col justify-between';
                badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-rose-100 text-rose-700';
                
                if (scoreVal < 35) {
                    if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.remove('hidden');
                } else {
                    if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
                }
            }
            
            aiRecommendCard.className = cardClass;
            aiRecommendBadge.className = badgeClass;
            aiRecommendBadge.innerText = syorBadgeText;
            aiRecommendTitle.innerText = syorTitle;
            aiRecommendDesc.innerText = syorDesc;
            
            // Add Checklist Items
            let checklistHtml = '';
            
            if (kategori !== 'RASMI') {
                checklistHtml += `
                    <label class="flex items-start gap-2.5 cursor-pointer group text-xs text-slate-600 font-medium">
                        <input type="checkbox" class="mt-0.5 rounded text-brand-purple focus:ring-brand-purple">
                        <span>Sahkan akaun perbankan: <strong class="text-slate-800">` + (bank || "-") + ` (` + (akaun || "-") + `)</strong></span>
                    </label>
                `;
            } else {
                checklistHtml += `
                    <label class="flex items-start gap-2.5 cursor-pointer group text-xs text-slate-600 font-medium">
                        <input type="checkbox" class="mt-0.5 rounded text-brand-purple focus:ring-brand-purple">
                        <span>Sahkan bukti pendapatan kasar bulanan: <strong class="text-indigo-600">` + (gaji || 'RM 0.00') + `</strong></span>
                    </label>
                `;
            }
            
            checklistHtml += `
                <label class="flex items-start gap-2.5 cursor-pointer group text-xs text-slate-600 font-medium">
                    <input type="checkbox" class="mt-0.5 rounded text-brand-purple focus:ring-brand-purple">
                    <span>Sahkan status keluarga: <strong class="text-slate-800">` + (statusK || "-") + `</strong></span>
                </label>
            `;
            
            checklistHtml += `
                <label class="flex items-start gap-2.5 cursor-pointer group text-xs text-slate-600 font-medium">
                    <input type="checkbox" class="mt-0.5 rounded text-brand-purple focus:ring-brand-purple">
                    <span>Verifikasi status pekerjaan: <strong class="text-slate-800">` + (kerja || "-") + `</strong></span>
                </label>
            `;
            
            checklistHtml += `
                <label class="flex items-start gap-2.5 cursor-pointer group text-xs text-slate-600 font-medium">
                    <input type="checkbox" class="mt-0.5 rounded text-brand-purple focus:ring-brand-purple">
                    <span>Sahkan kesahihan dokumen lampiran PDF</span>
                </label>
            `;
            
            checklistContainer.innerHTML = checklistHtml;
            
            // Checklist change listener to enforce completion for approval
            const approveBtn = document.getElementById('btnDetApprove');
            if (approveBtn && showAction) {
                approveBtn.disabled = true;
                approveBtn.classList.add('opacity-50', 'cursor-not-allowed');
                approveBtn.title = "Sila lengkapkan semakan manual di atas terlebih dahulu.";
                
                checklistContainer.addEventListener('change', function() {
                    const checkboxes = checklistContainer.querySelectorAll('input[type="checkbox"]');
                    let allChecked = true;
                    checkboxes.forEach(cb => {
                        if (!cb.checked) allChecked = false;
                    });
                    
                    if (allChecked) {
                        approveBtn.disabled = false;
                        approveBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                        approveBtn.title = "";
                    } else {
                        approveBtn.disabled = true;
                        approveBtn.classList.add('opacity-50', 'cursor-not-allowed');
                        approveBtn.title = "Sila lengkapkan semakan manual di atas terlebih dahulu.";
                    }
                });
            } else if (approveBtn) {
                approveBtn.disabled = false;
                approveBtn.classList.remove('opacity-50', 'cursor-not-allowed');
                approveBtn.title = "";
            }
        }
    }

    function openActionModal(id, name, type) {
        document.getElementById('actId').value = id;
        document.getElementById('actDecision').value = type;
        const btn = document.getElementById('actSubmitBtn');
        const boxL = document.getElementById('boxLengkap');
        const boxTL = document.getElementById('boxTakLengkap');
        const ulasan = document.getElementById('actUlasan');

        boxL.classList.add('hidden');
        boxTL.classList.add('hidden');

        if(type === 'lengkap') {
            boxL.classList.remove('hidden');
            btn.innerText = "Sahkan & Hantar";
            btn.className = "px-6 py-2 bg-green-500 text-white rounded-xl font-bold shadow-md hover:bg-green-600";
            ulasan.required = false;
        } else {
            boxTL.classList.remove('hidden');
            btn.innerText = "Hantar Semula";
            btn.className = "px-6 py-2 bg-red-500 text-white rounded-xl font-bold shadow-md hover:bg-red-600";
            ulasan.required = true;
            if (currentScore < 35) {
                ulasan.value = "DITOLAK/DIKEMBALIKAN: Skor kelayakan permohonan (" + currentScore.toFixed(0) + "%) adalah di bawah paras minima kelayakan. Sila hubungi AJK jika maklumat sosio-ekonomi (pendapatan/pekerjaan/ahli keluarga) perlu dikemaskini.";
            } else {
                ulasan.value = "";
            }
        }
        openModal('modalTindakan');
    }

    function openEditBantuanModal(id, name, type, amount, syarat) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = name;
        document.getElementById('editJenis').value = type;
        document.getElementById('editPeruntukan').value = amount;
        document.getElementById('editSyarat').value = syarat;
        openModal('modalEditBantuan');
    }

    function viewDetail(row) {
        const d = row.dataset;
        const id = d.id;
        const bantuan = d.bantuan;
        const showAction = (d.showaction === "true");
        const kategori = d.kategori;

        currentScore = parseFloat(d.score || 0);
        
        // Populate eligibility score and dynamic checklist
        populateDecisionSupport(currentScore, d.tier, d.flags, d.statusk, d.kerja, d.bank, d.akaun, d.gaji, d.kategori, showAction);

        document.getElementById('detId').innerText = "#" + id;
        document.getElementById('detBantuan').innerText = bantuan;
        document.getElementById('detPemohon').innerText = d.pemohon;
        document.getElementById('detIC').innerText = (d.ic && d.ic !== "null") ? d.ic : "-";
        document.getElementById('detPhone').innerText = (d.phone && d.phone !== "null") ? d.phone : "-";
        document.getElementById('detStatusK').innerText = (d.statusk && d.statusk !== "null") ? d.statusk : "-";
        document.getElementById('detPekerjaan').innerText = (d.kerja && d.kerja !== "null") ? d.kerja : "-";
        document.getElementById('detPendapatan').innerText = (d.gaji && d.gaji !== "null") ? d.gaji : "RM 0.00";
        document.getElementById('detKeterangan').innerText = (d.ket && d.ket !== "null") ? d.ket : "Tiada keterangan tambahan.";
        
        // Handle Ulasan Display
        const ulasanDiv = document.getElementById('ulasanDiv');
        const detUlasan = document.getElementById('detUlasan');
        if (ulasanDiv && detUlasan) {
            if (d.ulasan && d.ulasan !== "" && d.ulasan !== "null") {
                ulasanDiv.classList.remove('hidden');
                detUlasan.innerText = d.ulasan;
            } else {
                ulasanDiv.classList.add('hidden');
            }
        }
        
        const bank = d.bank;
        const akaun = d.akaun;
        const penBank = d.penbank;
        const dok = d.dok;
        const dokAdmin = d.dokadmin;
        const ctx = '<%= request.getContextPath() %>';

        // Bank Section Logic
        const bankCard = document.getElementById('bankCard');
        if (bankCard) {
            if (kategori === "RASMI") {
                bankCard.innerHTML = `
                    <div class="flex flex-col items-center justify-center h-full text-center p-4">
                        <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center text-blue-500 mb-3">
                            <i class="fas fa-info-circle text-xl"></i>
                        </div>
                        <p class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">Bantuan Rasmi</p>
                        <p class="text-xs text-blue-600 font-medium mt-1 italic leading-relaxed">Maklumat perbankan tidak diperlukan atau dikendalikan oleh agensi luar.</p>
                    </div>
                `;
            } else {
                const pbUrl = (penBank && penBank !== "null") ? ctx + '/file/bantuan/' + penBank : '#';
                const pbClass = (penBank && penBank !== "null") ? '' : 'opacity-50 pointer-events-none';
                
                bankCard.innerHTML = `
                    <div class="absolute -right-4 -bottom-4 opacity-5">
                        <i class="fas fa-credit-card text-7xl"></i>
                    </div>
                    <div class="space-y-4 relative z-10">
                        <div>
                            <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nama Bank</p>
                            <p class="font-bold text-blue-900 uppercase tracking-wide text-lg">\${(bank && bank !== "null") ? bank : "-"}</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nombor Akaun</p>
                            <p class="font-bold text-blue-900 text-xl tracking-widest">\${(akaun && akaun !== "null") ? akaun : "-"}</p>
                        </div>
                        <div class="pt-2">
                            <a href="\${pbUrl}" target="_blank" class="inline-flex items-center gap-2 px-4 py-2.5 bg-white text-blue-600 rounded-xl text-xs font-bold shadow-sm border border-blue-100 hover:shadow-md transition-all \${pbClass}">
                                <i class="fas fa-file-invoice-dollar"></i> Lihat Penyata Bank
                            </a>
                        </div>
                    </div>
                `;
            }
        }
        
        // Handle Action Buttons
        const actionBox = document.getElementById('detActionBox');
        if(actionBox) {
            if(showAction) {
                actionBox.classList.remove('hidden');
                document.getElementById('btnDetReject').onclick = () => { closeModal('modalDetail'); openActionModal(id, bantuan, 'tak_lengkap'); };
                document.getElementById('btnDetApprove').onclick = () => { closeModal('modalDetail'); openActionModal(id, bantuan, 'lengkap'); };
            } else {
                actionBox.classList.add('hidden');
            }
        }

        // Handle Multiple Documents
        const dokumenList = document.getElementById('dokumenList');
        const template = document.getElementById('detDokMain');
        
        if (dokumenList) {
            dokumenList.innerHTML = '';
            if(dok && template) {
                const files = dok.split(',');
                files.forEach(f => {
                    const newLink = template.cloneNode(true);
                    newLink.id = "";
                    newLink.classList.remove('hidden');
                    newLink.href = ctx + "/file/bantuan/" + f;
                    newLink.innerHTML = '<i class="fas fa-file-pdf"></i> PDF';
                    dokumenList.appendChild(newLink);
                });
            }
        }

        // Handle Admin Documents
        const adminDokList = document.getElementById('dokumenAdminList');
        const adminDokSection = document.getElementById('detAdminDokSection');
        if (adminDokList) {
            adminDokList.innerHTML = '';
            if(dokAdmin && dokAdmin !== "" && template) {
                if(adminDokSection) adminDokSection.classList.remove('hidden');
                const filesA = dokAdmin.split(',');
                filesA.forEach(f => {
                    const newLink = template.cloneNode(true);
                    newLink.id = "";
                    newLink.classList.remove('hidden');
                    newLink.classList.replace('bg-red-50', 'bg-purple-50');
                    newLink.classList.replace('text-red-600', 'text-brand-purple');
                    newLink.classList.replace('border-red-100', 'border-purple-100');
                    newLink.href = ctx + "/file/bantuan/" + f;
                    newLink.innerHTML = '<i class="fas fa-check-circle"></i> ' + decodeURIComponent(f).split('_').slice(2).join('_');
                    adminDokList.appendChild(newLink);
                });
            } else {
                if(adminDokSection) adminDokSection.classList.add('hidden');
            }
        }

        openModal('modalDetail');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>