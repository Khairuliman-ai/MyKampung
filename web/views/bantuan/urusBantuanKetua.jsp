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

    <header class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Pengesahan Ketua Kampung</h2>
        <p class="text-gray-500 text-sm">Semak dan luluskan permohonan yang telah disahkan oleh AJK.</p>
    </header>

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
        
        <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Carian Pantas</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                        <input type="text" id="searchPending" onkeyup="filterData('pending')" placeholder="Nama pemohon, jenis bantuan..." 
                               class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-orange-500 text-gray-800 text-sm transition-all">
                    </div>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Tarikh Mohon</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="far fa-calendar-alt"></i></span>
                        <input type="date" id="datePending" onchange="filterData('pending')"
                               class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-orange-500 text-gray-800 text-sm transition-all">
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Semakan AJK</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Keputusan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                         <% if(!listPending.isEmpty()) { 
                            for(PermohonanBantuan pb : listPending) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                                String dateFilter = (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "";
                                String namaBantuan = pb.getNama_bantuan();
                                if(pb.getId_bantuan() == 6) namaBantuan = "Bantuan Am";
                                else if(pb.getId_bantuan() == 20) namaBantuan = "Sumbangan IPT";
                                else if(pb.getId_bantuan() == 999) namaBantuan = "Lain-lain";
                        %>
                        <tr class="hover:bg-orange-50/30 transition-colors data-row-pending" data-date="<%= dateFilter %>">
                            <td class="p-4 text-sm font-medium text-gray-500 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center font-bold text-xs">
                                        <%= (pb.getNama_penuh() != null) ? pb.getNama_penuh().substring(0,1) : "U" %>
                                    </div>
                                    <span class="text-sm font-bold text-gray-800 search-col"><%= (pb.getNama_penuh() != null) ? pb.getNama_penuh() : "Unknown" %></span>
                                </div>
                            </td>
                            <td class="p-4 text-sm text-gray-600"><span class="bg-gray-100 px-2 py-1 rounded text-xs border border-gray-200 search-col"><%= namaBantuan %></span></td>
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
                                <% if(pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/bantuan/<%= enc %>" target="_blank" class="text-red-500 hover:text-red-700 font-bold text-xs flex items-center gap-1">
                                        <i class="fas fa-file-pdf"></i> PDF
                                    </a>
                                <% } else { %> - <% } %>
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
                        <tr><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-check-double text-3xl mb-2 block opacity-50"></i>Tiada permohonan tertunggak.</td></tr>
                        <% } %>
                    </tbody>
                </table>
        </div>
    </div>
</div>

<div id="content-sejarah" class="hidden">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-gray-400 rounded-full"></div>
            Rekod Sejarah Keputusan <span class="bg-gray-100 text-gray-400 text-xs px-2 py-1 rounded-lg ml-2 font-normal"><%= listSejarah.size() %></span>
        </h3>
        
        <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Carian Pantas</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                        <input type="text" id="searchHistory" onkeyup="filterData('history')" placeholder="Nama pemohon, jenis bantuan..." 
                               class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-gray-400 text-gray-800 text-sm transition-all">
                    </div>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Tarikh Keputusan</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="far fa-calendar-alt"></i></span>
                        <input type="date" id="dateHistory" onchange="filterData('history')"
                               class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-gray-400 text-gray-800 text-sm transition-all">
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Keputusan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Catatan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                         <% if(!listSejarah.isEmpty()) { 
                            for(PermohonanBantuan pb : listSejarah) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                                String dateFilter = (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "";
                        %>
                        <tr class="text-gray-500 data-row-history" data-date="<%= dateFilter %>">
                            <td class="p-4 text-sm whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-700 search-col"><%= pb.getNama_penuh() %></td>
                            <td class="p-4 text-sm search-col"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4">
                                <% if(pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/bantuan/<%= enc %>" target="_blank" class="text-blue-500 hover:text-blue-700 text-xs font-bold underline">Lihat PDF</a>
                                <% } else { %> - <% } %>
                            </td>
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
                        <tr><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada rekod sejarah.</td></tr>
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
                        <input type="file" name="dokumenBalas" accept="application/pdf"
                               class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-purple-50 file:text-[#6C5DD3] hover:file:bg-purple-100" required>
                    </div>

                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" id="btnSubmit" class="inline-flex w-full justify-center rounded-xl px-3 py-2 text-sm font-semibold text-white shadow-sm sm:ml-3 sm:w-auto transition">Sahkan</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-5 sm:mt-0 sm:w-auto" onclick="closeModal('modalKeputusan')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(tabName) {
        // Reset Tabs Style
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });

        // Active Tab Style
        const activeTab = document.getElementById('tab-' + tabName);
        activeTab.classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        activeTab.classList.remove('border-transparent', 'text-gray-500', 'font-medium');

        // Toggle Content
        document.getElementById('content-pending').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        
        document.getElementById('content-' + tabName).classList.remove('hidden');
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

    // Filter Logic
    function filterData(type) {
        const searchInput = (type === 'pending') ? document.getElementById("searchPending") : document.getElementById("searchHistory");
        const dateInput = (type === 'pending') ? document.getElementById("datePending") : document.getElementById("dateHistory");
        const rows = document.querySelectorAll(type === 'pending' ? ".data-row-pending" : ".data-row-history");
        
        const searchVal = searchInput.value.toLowerCase();
        const dateVal = dateInput.value;

        rows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => {
                textContent += col.innerText.toLowerCase() + " ";
            });

            let showRow = true;
            if (dateVal !== "" && rowDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;

            row.style.display = showRow ? "" : "none";
        });
    }
</script>

<%@ include file="/views/common/footer.jsp" %>