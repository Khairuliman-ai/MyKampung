<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pengesahan Ketua Kampung</h2>
            <p class="text-gray-500 text-sm">Semak dan luluskan permohonan yang telah disahkan oleh AJK.</p>
        </div>

        <!-- Professional Filter Bar -->
        <div class="bg-white p-3 rounded-2xl shadow-sm border border-gray-100 flex flex-wrap items-center gap-3">
            <div class="relative">
                <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                <input type="text" id="searchPemohon" onkeyup="filterData()" placeholder="Cari pemohon/ID..." 
                       class="pl-9 pr-4 py-2 bg-gray-50 border-none rounded-xl text-xs focus:ring-2 focus:ring-[#6C5DD3] w-48">
            </div>
            
            <select id="filterKategori" onchange="filterData()" class="bg-gray-50 border-none rounded-xl text-xs focus:ring-2 focus:ring-[#6C5DD3] py-2 px-3 pr-8">
                <option value="ALL">Semua Kategori</option>
                <option value="RASMI">Bantuan Rasmi</option>
                <option value="KOMUNITI">Bantuan Komuniti</option>
            </select>

            <div class="flex items-center gap-2 bg-gray-50 px-3 py-1.5 rounded-xl border border-transparent focus-within:border-[#6C5DD3]/30 transition">
                <i class="fas fa-calendar-alt text-gray-400 text-[10px]"></i>
                <input type="date" id="filterDateStart" onchange="filterData()" class="bg-transparent border-none p-0 text-[10px] focus:ring-0">
                <span class="text-gray-300">-</span>
                <input type="date" id="filterDateEnd" onchange="filterData()" class="bg-transparent border-none p-0 text-[10px] focus:ring-0">
            </div>

            <button onclick="resetFilters()" class="p-2 text-gray-400 hover:text-red-500 transition tooltip" title="Reset Tapisan">
                <i class="fas fa-sync-alt text-xs"></i>
            </button>
        </div>
    </header>

    <% if (request.getParameter("msg") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Tindakan telah direkodkan.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-exclamation-circle text-lg"></i>
            <div>
                <% String err = request.getParameter("error"); 
                   if(err != null) err = err.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
                %>
                <span class="font-bold">Ralat!</span> <%= (err != null ? err : "") %>
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-red-500 hover:text-red-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <%
        // Logic Pengasingan Data
        List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
        List<PermohonanBantuan> listPending = new ArrayList<>(); // Status 3 (Dari JKKK)
        List<PermohonanBantuan> listSejarah = new ArrayList<>(); // Status 1 (Lulus) atau 4 (Tolak)
        
        if(list != null) {
            for(PermohonanBantuan pb : list) {
                if("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus())) {
                    listPending.add(pb);
                } else if("LULUS".equalsIgnoreCase(pb.getStatus()) || "DITOLAK".equalsIgnoreCase(pb.getStatus())) {
                    listSejarah.add(pb);
                }
            }
        }
    %>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8" aria-label="Tabs">
            <button onclick="switchTab('pending')" id="tab-pending" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-hourglass-half"></i> Menunggu Tindakan
                <% if (listPending != null && !listPending.isEmpty()) { %>
                    <span class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= listPending.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-history"></i> Sejarah Keputusan
            </button>
        </nav>
    </div>

    <div id="content-pending" class="block">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-orange-500 rounded-full"></div>
            Senarai Permohonan
        </h3>
        
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">No. Rujukan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Semakan AJK</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Keputusan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                         <% if(listPending != null && !listPending.isEmpty()) { 
                            for(PermohonanBantuan pb : listPending) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                                String namaBantuan = pb.getNama_bantuan();
                                if(pb.getId_bantuan() == 6) namaBantuan = "Bantuan Am";
                                else if(pb.getId_bantuan() == 20) namaBantuan = "Sumbangan IPT";
                                else if(pb.getId_bantuan() == 999) namaBantuan = "Lain-lain";
                        %>
                        <tr class="hover:bg-purple-50/20 transition data-row-filter"
                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>" 
                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>">
                            <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= pb.getId_permohonan() %></td>
                            <td class="p-4 text-sm text-gray-500 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4">
                                <span class="text-sm font-bold text-gray-800"><%= pb.getNama_penuh() %></span>
                            </td>
                            <td class="p-4">
                                <% if ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan())) { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                                <% } else { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-sm text-gray-600"><%= namaBantuan %></td>
                            <td class="p-4">
                                <div class="flex items-start gap-2">
                                    <i class="fas fa-check-circle text-green-500 mt-0.5"></i>
                                    <div>
                                        <p class="text-xs font-bold text-green-600">Disahkan AJK</p>
                                        <p class="text-[10px] text-gray-400 italic"><%= (pb.getCatatan_pentadbir() != null) ? pb.getCatatan_pentadbir() : "Tiada ulasan" %></p>
                                    </div>
                                </div>
                            </td>
                            <td class="p-4">
                                <div class="flex flex-wrap gap-2">
                                    <% if(pb.getSenaraiLampiran() != null && !pb.getSenaraiLampiran().isEmpty()) { 
                                        for(model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                                            String enc = URLEncoder.encode(bl.getNama_fail(), "UTF-8").replace("+", "%20");
                                    %>
                                        <a href="<%= request.getContextPath() %>/file/bantuan/<%= enc %>" target="_blank" 
                                           class="inline-flex items-center gap-1 px-2 py-1 bg-red-50 text-red-600 rounded text-[10px] font-bold hover:bg-red-100 transition shadow-sm" 
                                           title="<%= bl.getNama_fail() %>">
                                            <i class="fas fa-file-pdf"></i> PDF
                                        </a>
                                    <% } } else { %>
                                        <span class="text-[10px] text-gray-400 italic">Tiada fail</span>
                                    <% } %>
                                </div>
                            </td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <button onclick="openModal('<%= pb.getId_permohonan() %>', '<%= namaBantuan %>', 'lulus')" class="w-8 h-8 rounded-full bg-green-100 text-green-600 hover:bg-green-200 flex items-center justify-center transition shadow-sm" title="Sokong">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button onclick="openModal('<%= pb.getId_permohonan() %>', '<%= namaBantuan %>', 'tolak')" class="w-8 h-8 rounded-full bg-red-100 text-red-600 hover:bg-red-200 flex items-center justify-center transition shadow-sm" title="Tolak">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="8" class="p-8 text-center text-gray-400"><i class="fas fa-check-double text-3xl mb-2 block opacity-50"></i>Tiada permohonan tertunggak.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 2: SEJARAH -->
    <div id="content-sejarah" class="hidden">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-gray-400 rounded-full"></div>
            Rekod Sejarah Keputusan <span class="bg-gray-100 text-gray-400 text-xs px-2 py-1 rounded-lg ml-2 font-normal"><%= listSejarah.size() %></span>
        </h3>
        
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Keputusan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Catatan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                         <% if(!listSejarah.isEmpty()) { 
                            for(PermohonanBantuan pb : listSejarah) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="text-gray-500 data-row-filter" 
                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>" 
                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>">
                            <td class="p-4 text-sm whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-700"><%= pb.getNama_penuh() %></td>
                            <td class="p-4">
                                <% if ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan())) { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-500 border border-blue-100/50">RASMI</span>
                                <% } else { %>
                                    <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-500 border border-teal-100/50">KOMUNITI</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-sm"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4">
                                <% if("LULUS".equalsIgnoreCase(pb.getStatus())) { %> 
                                    <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold w-max flex items-center gap-1"><i class="fas fa-check-circle"></i> Disokong</span>
                                <% } else { %> 
                                    <span class="px-3 py-1 rounded-full bg-red-50 text-red-600 text-xs font-bold w-max flex items-center gap-1"><i class="fas fa-times-circle"></i> Ditolak</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-sm italic max-w-xs truncate"><%= (pb.getCatatan_pentadbir() != null) ? pb.getCatatan_pentadbir() : "-" %></td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada rekod sejarah.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col flex-shrink-0 p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Statistik Semasa</h3>
    </div>

    <div class="space-y-4">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between">
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Menunggu</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listPending.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-full bg-orange-100 text-orange-500 flex items-center justify-center font-bold"><i class="fas fa-clock"></i></div>
        </div>
        
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between">
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Selesai</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listSejarah.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-full bg-green-100 text-green-500 flex items-center justify-center font-bold"><i class="fas fa-check-double"></i></div>
        </div>
    </div>

    <div class="mt-auto bg-purple-50 rounded-2xl p-6 relative overflow-hidden">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-purple-200 rounded-full opacity-50"></div>
        <h4 class="font-bold text-[#6C5DD3] mb-2 relative z-10 text-sm">Panduan Kelulusan</h4>
        <p class="text-xs text-gray-600 leading-relaxed relative z-10 mb-2">
            1. Semak maklumat pemohon.
        </p>
        <p class="text-xs text-gray-600 leading-relaxed relative z-10 mb-2">
            2. Sahkan kelayakan berdasarkan kriteria bantuan.
        </p>
        <p class="text-xs text-gray-600 leading-relaxed relative z-10">
            3. Muat naik memo/surat sokongan jika perlu.
        </p>
    </div>
</aside>

<div id="modalKeputusan" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalKeputusan')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            
            <form action="<%= request.getContextPath() %>/bantuan/keputusanKetua" method="post" enctype="multipart/form-data">
                <input type="hidden" name="idPermohonan" id="modalId">
                <input type="hidden" name="keputusan" id="modalKeputusanValue">

                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    
                    <div id="viewLulus" class="hidden text-center">
                        <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-green-100 mb-4">
                            <i class="fas fa-check text-2xl text-green-600"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 mb-2">Sokong Permohonan?</h3>
                        <p class="text-sm text-gray-500 mb-4">
                            Anda akan menyokong permohonan <span id="modalBantuanNameLulus" class="font-bold text-gray-800"></span>.
                        </p>
                    </div>

                    <div id="viewTolak" class="hidden text-center">
                        <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-red-100 mb-4">
                            <i class="fas fa-times text-2xl text-red-600"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-900 mb-2">Tolak Permohonan?</h3>
                        <p class="text-sm text-gray-500 mb-4">
                            Sila nyatakan sebab penolakan untuk <span id="modalBantuanNameTolak" class="font-bold text-gray-800"></span>.
                        </p>
                        <textarea name="ulasan" id="ulasanBox" rows="3" placeholder="Contoh: Tidak memenuhi syarat pendapatan..."
                                  class="w-full px-4 py-2 rounded-xl bg-gray-50 border border-gray-200 focus:ring-2 focus:ring-red-500 text-sm"></textarea>
                    </div>

                    <div class="mt-4 pt-4 border-t border-gray-100">
                        <label class="block text-xs font-bold text-gray-500 mb-2">Muat Naik Dokumen Sokongan (Pilihan)</label>
                        <input type="file" name="dokumenBalas" accept="application/pdf" id="dokumenBalas"
                               class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-purple-50 file:text-[#6C5DD3] hover:file:bg-purple-100">
                    </div>

                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" id="btnSubmit" class="inline-flex w-full justify-center rounded-xl px-3 py-2 text-sm font-semibold text-white shadow-sm sm:ml-3 sm:w-auto transition">Sahkan</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-false sm:mt-0 sm:w-auto" onclick="closeModal('modalKeputusan')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function resetFilters() {
        document.getElementById('searchPemohon').value = '';
        document.getElementById('filterKategori').value = 'ALL';
        document.getElementById('filterDateStart').value = '';
        document.getElementById('filterDateEnd').value = '';
        filterData();
    }

    function filterData() {
        const search = document.getElementById('searchPemohon').value.toLowerCase();
        const category = document.getElementById('filterKategori').value;
        const dateStart = document.getElementById('filterDateStart').value;
        const dateEnd = document.getElementById('filterDateEnd').value;

        const rows = document.querySelectorAll('.data-row-filter');
        rows.forEach(row => {
            const rowSearch = row.getAttribute('data-search').toLowerCase();
            const rowCategory = row.getAttribute('data-category');
            const rowDate = row.getAttribute('data-date'); // YYYY-MM-DD

            let show = true;

            if (search && !rowSearch.includes(search)) show = false;
            if (category !== 'ALL' && rowCategory !== category) show = false;
            
            if (dateStart && rowDate < dateStart) show = false;
            if (dateEnd && rowDate > dateEnd) show = false;

            row.style.display = show ? '' : 'none';
        });
    }

    function switchTab(name) {
        // Reset Tabs Style
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });

        // Active Tab Style
        const activeTab = document.getElementById('tab-' + name);
        activeTab.classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        activeTab.classList.remove('border-transparent', 'text-gray-500', 'font-medium');

        // Toggle Content
        document.getElementById('content-pending').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        
        document.getElementById('content-' + name).classList.remove('hidden');
    }

    function openModal(id, namaBantuan, jenisKeputusan) {
        document.getElementById('modalId').value = id;
        document.getElementById('modalKeputusanValue').value = jenisKeputusan;
        
        const viewLulus = document.getElementById('viewLulus');
        const viewTolak = document.getElementById('viewTolak');
        const btnSubmit = document.getElementById('btnSubmit');
        const ulasanBox = document.getElementById('ulasanBox');

        if (jenisKeputusan === 'lulus') {
            document.getElementById('modalBantuanNameLulus').innerText = namaBantuan;
            viewLulus.classList.remove('hidden');
            viewTolak.classList.add('hidden');
            
            btnSubmit.classList.remove('bg-red-600', 'hover:bg-red-700');
            btnSubmit.classList.add('bg-green-600', 'hover:bg-green-700');
            btnSubmit.innerText = "Sokong Permohonan";
            ulasanBox.required = false;
        } else {
            document.getElementById('modalBantuanNameTolak').innerText = namaBantuan;
            viewLulus.classList.add('hidden');
            viewTolak.classList.remove('hidden');
            
            btnSubmit.classList.remove('bg-green-600', 'hover:bg-green-700');
            btnSubmit.classList.add('bg-red-600', 'hover:bg-red-700');
            btnSubmit.innerText = "Tolak Permohonan";
            ulasanBox.required = true;
        }

        document.getElementById('modalKeputusan').classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>