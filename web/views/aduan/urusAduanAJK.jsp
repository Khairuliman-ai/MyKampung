<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    List<Aduan> allList = (List<Aduan>) request.getAttribute("aduanList");
    
    List<Aduan> listBaharu = new ArrayList<>();
    List<Aduan> listTindakan = new ArrayList<>();
    List<Aduan> listSejarah = new ArrayList<>();
    
    if (allList != null) {
        for (Aduan a : allList) {
            String status = a.getStatus();
            if (status == null) {
                listSejarah.add(a); // Default to history if status is missing
            } else if ("SUBMITTED".equals(status)) {
                listBaharu.add(a);
            } else if ("UNDER_REVIEW_AJK".equals(status) || "IN_PROGRESS_AJK".equals(status)) {
                listTindakan.add(a);
            } else {
                listSejarah.add(a);
            }
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Urus Aduan (AJK)</h2>
        <p class="text-gray-500 text-sm">Bertindak mengikut status aduan yang diberikan.</p>
    </div>

    <!-- Carian & Penapis Card -->
    <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterData()" placeholder="Cari no. aduan, tajuk, kategori, pengadu..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-brand-purple text-gray-800 text-sm transition-all">
                </div>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Tarikh Aduan</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterData()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-brand-purple text-gray-800 text-sm transition-all">
                </div>
            </div>
        </div>
    </div>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('baharu')" id="tab-baharu" class="py-4 px-1 border-b-2 font-bold text-sm border-brand-purple text-brand-purple">
                Aduan Baharu (<%= listBaharu.size() %>)
            </button>
            <button onclick="switchTab('tindakan')" id="tab-tindakan" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Dalam Tindakan (<%= listTindakan.size() %>)
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Sejarah
            </button>
        </nav>
    </div>

    <!-- Tab Baharu -->
    <div id="content-baharu" class="space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pengadu / Tajuk</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listBaharu.isEmpty()) { 
                            for (Aduan a : listBaharu) { 
                                String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition-colors cursor-pointer" 
                            onclick="showAduanDetail(this)"
                            data-date="<%= filterDate %>"
                            data-id="<%= a.getId_aduan() %>"
                            data-tajuk="<%= a.getTajuk().replace("\"", "&quot;") %>"
                            data-keterangan="<%= a.getKeterangan().replace("\"", "&quot;") %>"
                            data-pengadu="<%= a.getNama_penuh() %>"
                            data-tarikh="<%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %>"
                            data-kategori="<%= a.getNama_kategori() %>"
                            data-status="<%= a.getStatus() %>"
                            data-status-label="<%= a.getStatusLabel() %>"
                            data-status-class="<%= a.getStatusBadgeClass() %>"
                            data-priority="<%= a.getKeutamaan() %>"
                            data-priority-class="<%= a.getKeutamaanBadge() %>"
                            data-catatan-ajk="<%= a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;") : "" %>"
                            data-catatan-ketua="<%= a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;") : "" %>"
                            data-gambar="<%= a.getGambar_aduan() != null ? a.getGambar_aduan() : "" %>"
                            >
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] whitespace-nowrap search-col">#<%= a.getId_aduan() %></td>
                            <td class="p-4 text-sm text-gray-600 whitespace-nowrap"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                            <td class="p-4 search-col">
                                <div class="flex flex-col">
                                    <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                    <span class="text-xs text-gray-400 mt-0.5"><%= a.getTajuk() %></span>
                                </div>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-2 py-0.5 rounded-lg text-xs font-bold border <%= a.getKeutamaanBadge() %>">
                                    <%= a.getNama_kategori() %>
                                </span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% if ("SUBMITTED".equals(a.getStatus()) || "UNDER_REVIEW_AJK".equals(a.getStatus()) || "IN_PROGRESS_AJK".equals(a.getStatus())) { %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-edit group-hover:scale-110 transition-transform"></i> Kemaskini
                                </button>
                                <% } else { %>
                                <span class="text-gray-300 text-xs flex items-center justify-center gap-1"><i class="fas fa-lock"></i> Kunci</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada aduan baharu.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Tab Tindakan -->
    <div id="content-tindakan" class="hidden space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pengadu / Tajuk</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listTindakan.isEmpty()) { 
                            for (Aduan a : listTindakan) { 
                                String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition-colors cursor-pointer" 
                            onclick="showAduanDetail(this)"
                            data-date="<%= filterDate %>"
                            data-id="<%= a.getId_aduan() %>"
                            data-tajuk="<%= a.getTajuk().replace("\"", "&quot;") %>"
                            data-keterangan="<%= a.getKeterangan().replace("\"", "&quot;") %>"
                            data-pengadu="<%= a.getNama_penuh() %>"
                            data-tarikh="<%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %>"
                            data-kategori="<%= a.getNama_kategori() %>"
                            data-status="<%= a.getStatus() %>"
                            data-status-label="<%= a.getStatusLabel() %>"
                            data-status-class="<%= a.getStatusBadgeClass() %>"
                            data-priority="<%= a.getKeutamaan() %>"
                            data-priority-class="<%= a.getKeutamaanBadge() %>"
                            data-catatan-ajk="<%= a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;") : "" %>"
                            data-catatan-ketua="<%= a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;") : "" %>"
                            data-gambar="<%= a.getGambar_aduan() != null ? a.getGambar_aduan() : "" %>"
                            >
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] whitespace-nowrap search-col">#<%= a.getId_aduan() %></td>
                            <td class="p-4 text-sm text-gray-600 whitespace-nowrap"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                            <td class="p-4 search-col">
                                <div class="flex flex-col">
                                    <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                    <span class="text-xs text-gray-400 mt-0.5"><%= a.getTajuk() %></span>
                                </div>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-2 py-0.5 rounded-lg text-xs font-bold border <%= a.getKeutamaanBadge() %>">
                                    <%= a.getNama_kategori() %>
                                </span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% if ("SUBMITTED".equals(a.getStatus()) || "UNDER_REVIEW_AJK".equals(a.getStatus()) || "IN_PROGRESS_AJK".equals(a.getStatus())) { %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-edit group-hover:scale-110 transition-transform"></i> Kemaskini
                                </button>
                                <% } else { %>
                                <span class="text-gray-300 text-xs flex items-center justify-center gap-1"><i class="fas fa-lock"></i> Kunci</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada aduan dalam tindakan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Tab Sejarah -->
    <div id="content-sejarah" class="hidden space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pengadu / Tajuk</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Kategori</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) { 
                            for (Aduan a : listSejarah) { 
                                String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition-colors cursor-pointer" 
                            onclick="showAduanDetail(this)"
                            data-date="<%= filterDate %>"
                            data-id="<%= a.getId_aduan() %>"
                            data-tajuk="<%= a.getTajuk().replace("\"", "&quot;") %>"
                            data-keterangan="<%= a.getKeterangan().replace("\"", "&quot;") %>"
                            data-pengadu="<%= a.getNama_penuh() %>"
                            data-tarikh="<%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %>"
                            data-kategori="<%= a.getNama_kategori() %>"
                            data-status="<%= a.getStatus() %>"
                            data-status-label="<%= a.getStatusLabel() %>"
                            data-status-class="<%= a.getStatusBadgeClass() %>"
                            data-priority="<%= a.getKeutamaan() %>"
                            data-priority-class="<%= a.getKeutamaanBadge() %>"
                            data-catatan-ajk="<%= a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;") : "" %>"
                            data-catatan-ketua="<%= a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;") : "" %>"
                            data-gambar="<%= a.getGambar_aduan() != null ? a.getGambar_aduan() : "" %>"
                            >
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] whitespace-nowrap search-col">#<%= a.getId_aduan() %></td>
                            <td class="p-4 text-sm text-gray-600 whitespace-nowrap"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                            <td class="p-4 search-col">
                                <div class="flex flex-col">
                                    <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                    <span class="text-xs text-gray-400 mt-0.5"><%= a.getTajuk() %></span>
                                </div>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-2 py-0.5 rounded-lg text-xs font-bold border <%= a.getKeutamaanBadge() %>">
                                    <%= a.getNama_kategori() %>
                                </span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% if ("SUBMITTED".equals(a.getStatus()) || "UNDER_REVIEW_AJK".equals(a.getStatus()) || "IN_PROGRESS_AJK".equals(a.getStatus())) { %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-edit group-hover:scale-110 transition-transform"></i> Kemaskini
                                </button>
                                <% } else { %>
                                <span class="text-gray-300 text-xs flex items-center justify-center gap-1"><i class="fas fa-lock"></i> Kunci</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada sejarah aduan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800">Ringkasan Aduan</h3>
        <p class="text-xs text-gray-400 font-medium">Status tugasan biro anda</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Aduan Baharu</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listBaharu.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-red-100 text-red-500 flex items-center justify-center">
                <i class="fas fa-exclamation-circle"></i>
            </div>
        </div>
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Dalam Tindakan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listTindakan.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-blue-100 text-blue-500 flex items-center justify-center">
                <i class="fas fa-spinner"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-xs text-gray-800 mb-4 uppercase tracking-widest">Aliran Kerja</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-xs border-2 border-brand-purple z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Semak Sah</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Tukar status kepada 'Terima untuk Semakan' jika aduan berasas.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Tindakan Lapangan</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Lakukan siasatan atau kerja pembaikan mengikut aduan.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">3</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Selesai & Lapor</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Muat naik ulasan penyelesaian sebelum menutup aduan.</p>
            </div>
        </div>
    </div>
</aside>

<!-- Modal Update Status -->
<div id="modalStatus" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalStatus')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md">
            <div class="bg-brand-purple px-6 py-4">
                <h3 class="text-lg font-bold text-white">Kemaskini Status Aduan</h3>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/updateStatus" method="post">
                <input type="hidden" name="id_aduan" id="modal-id">
                <input type="hidden" name="current_status" id="modal-current">
                <div class="p-8 space-y-6">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Status Semasa</label>
                        <p id="modal-label" class="text-sm font-bold text-gray-800"></p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Status Baru</label>
                        <select name="next_status" id="modal-next" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm">
                            <!-- Options populated by JS -->
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Catatan / Ulasan</label>
                        <textarea name="catatan" rows="3" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm"></textarea>
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-brand-purple hover:bg-brand-purpleHover text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Simpan Perubahan</button>
                    <button type="button" onclick="closeModal('modalStatus')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/views/aduan/modalDetailAduan.jsp" %>

<script>
    function switchTab(name) {
        ['baharu', 'tindakan', 'sejarah'].forEach(t => {
            document.getElementById('content-' + t).classList.add('hidden');
            document.getElementById('tab-' + t).classList.remove('border-brand-purple', 'text-brand-purple', 'font-bold');
            document.getElementById('tab-' + t).classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });
        document.getElementById('content-' + name).classList.remove('hidden');
        document.getElementById('tab-' + name).classList.add('border-brand-purple', 'text-brand-purple', 'font-bold');
        document.getElementById('tab-' + name).classList.remove('border-transparent', 'text-gray-500', 'font-medium');
    }

    function openStatusModal(id, status, label) {
        document.getElementById('modal-id').value = id;
        document.getElementById('modal-current').value = status;
        document.getElementById('modal-label').innerText = label;
        
        const next = document.getElementById('modal-next');
        next.innerHTML = '';
        
        const options = {
            'SUBMITTED': [
                {v: 'UNDER_REVIEW_AJK', t: 'Terima untuk Semakan'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'UNDER_REVIEW_AJK': [
                {v: 'IN_PROGRESS_AJK', t: 'Mula Tindakan (Biro)'},
                {v: 'ESCALATED_TO_KETUA', t: 'Majukan ke Ketua Kampung'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'IN_PROGRESS_AJK': [
                {v: 'RESOLVED', t: 'Tandakan SELESAI'},
                {v: 'ESCALATED_TO_KETUA', t: 'Gagal / Majukan ke Ketua'}
            ]
        };
        
        const possible = options[status] || [];
        possible.forEach(o => {
            const el = document.createElement('option');
            el.value = o.v;
            el.innerText = o.t;
            next.appendChild(el);
        });
        
        document.getElementById('modalStatus').classList.remove('hidden');
    }

    function filterData() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        const rows = document.querySelectorAll(".data-row");
        
        rows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showRow = true;
            if (dateVal !== "" && rowDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
            
            row.style.display = showRow ? "" : "none";
        });
    }

    // closeModal centralized in footer.jsp
</script>

<%@ include file="/views/common/footer.jsp" %>
