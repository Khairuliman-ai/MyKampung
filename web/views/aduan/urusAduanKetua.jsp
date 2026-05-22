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
    
    List<Aduan> listDimajukan = new ArrayList<>();
    List<Aduan> listTindakan = new ArrayList<>();
    List<Aduan> listSemua = new ArrayList<>();
    
    if (allList != null) {
        for (Aduan a : allList) {
            String status = a.getStatus();
            if ("ESCALATED_TO_KETUA".equals(status)) {
                listDimajukan.add(a);
            } else if ("UNDER_REVIEW_KETUA".equals(status) || "IN_PROGRESS_HIGH_LEVEL".equals(status)) {
                listTindakan.add(a);
            }
            listSemua.add(a);
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Urus Aduan (Ketua Kampung)</h2>
        <p class="text-gray-500 text-sm">Pantau dan beri keputusan untuk aduan yang dimajukan.</p>
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
            <button onclick="switchTab('dimajukan')" id="tab-dimajukan" class="py-4 px-1 border-b-2 font-bold text-sm border-brand-purple text-brand-purple">
                Aduan Dimajukan (<%= listDimajukan.size() %>)
            </button>
            <button onclick="switchTab('tindakan')" id="tab-tindakan" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Dalam Tindakan (<%= listTindakan.size() %>)
            </button>
            <button onclick="switchTab('semua')" id="tab-semua" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Semua Aduan
            </button>
        </nav>
    </div>

    <!-- Tab Dimajukan -->
    <div id="content-dimajukan" class="space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pengadu / Tajuk</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Pengendali AJK</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listDimajukan.isEmpty()) { 
                            for (Aduan a : listDimajukan) { 
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
                                <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% 
                                String s1 = a.getStatus();
                                if ("ESCALATED_TO_KETUA".equals(s1) || "UNDER_REVIEW_KETUA".equals(s1) || "IN_PROGRESS_HIGH_LEVEL".equals(s1) || "RESOLVED".equals(s1) || "REJECTED".equals(s1)) { 
                                %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-tasks group-hover:scale-110 transition-transform"></i> Tindakan
                                </button>
                                <% } else { %>
                                <span class="text-gray-300 text-xs flex items-center justify-center gap-1"><i class="fas fa-lock"></i> Kunci</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada aduan dimajukan.</td></tr>
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Pengendali AJK</th>
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
                                <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% 
                                String s2 = a.getStatus();
                                if ("ESCALATED_TO_KETUA".equals(s2) || "UNDER_REVIEW_KETUA".equals(s2) || "IN_PROGRESS_HIGH_LEVEL".equals(s2) || "RESOLVED".equals(s2) || "REJECTED".equals(s2)) { 
                                %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-tasks group-hover:scale-110 transition-transform"></i> Tindakan
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

    <!-- Tab Semua -->
    <div id="content-semua" class="hidden space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pengadu / Tajuk</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Pengendali AJK</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSemua.isEmpty()) { 
                            for (Aduan a : listSemua) { 
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
                                <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                            </td>
                            <td class="p-4 whitespace-nowrap search-col">
                                <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                    <%= a.getStatusLabel() %>
                                </span>
                            </td>
                            <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                                <% 
                                String s3 = a.getStatus();
                                if ("ESCALATED_TO_KETUA".equals(s3) || "UNDER_REVIEW_KETUA".equals(s3) || "IN_PROGRESS_HIGH_LEVEL".equals(s3) || "RESOLVED".equals(s3) || "REJECTED".equals(s3)) { 
                                %>
                                <button onclick="openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" 
                                        class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 hover:text-purple-700 transition text-xs font-bold">
                                    <i class="fas fa-tasks group-hover:scale-110 transition-transform"></i> Tindakan
                                </button>
                                <% } else { %>
                                <span class="text-gray-300 text-xs flex items-center justify-center gap-1"><i class="fas fa-lock"></i> Kunci</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada rekod aduan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<%
    // Ambil maklumat Biro Keselamatan (id_jawatan = 6)
    String namaAJKKeselamatan = "Tiada AJK";
    String telAJKKeselamatan = "";
    
    try (java.sql.Connection conn = util.DBUtil.getConnection();
         java.sql.PreparedStatement ps = conn.prepareStatement(
             "SELECT p.nama_penuh, p.nombor_telefon " +
             "FROM pengguna p " +
             "JOIN ajk_jawatan aj ON p.id_pengguna = aj.id_pengguna " +
             "WHERE aj.id_jawatan = 6 LIMIT 1"
         )) {
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                namaAJKKeselamatan = rs.getString("nama_penuh");
                telAJKKeselamatan = rs.getString("nombor_telefon");
            }
        }
    } catch (Exception e) {
        // Safe fallback
    }

    String waNumber = telAJKKeselamatan != null ? telAJKKeselamatan.replaceAll("\\D", "") : "";
    if (waNumber.startsWith("0")) {
        waNumber = "6" + waNumber;
    } else if (waNumber.startsWith("1") || waNumber.startsWith("11")) {
        waNumber = "60" + waNumber;
    }
    
    // Live complaint breakdown stats
    int totalAduan = listSemua.size();
    int pendingAduan = listDimajukan.size();
    int tindakanAduan = listTindakan.size();
    int resolvedAduan = 0;
    
    for (Aduan a : listSemua) {
        if ("RESOLVED".equals(a.getStatus()) || "CLOSED".equals(a.getStatus())) {
            resolvedAduan++;
        }
    }
    
    double resolutionRate = totalAduan > 0 ? ((double) resolvedAduan / totalAduan) * 100 : 0.0;
%>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white/80 border-l border-slate-100 backdrop-blur-md hidden xl:flex flex-col p-8 overflow-y-auto h-full shrink-0">
    <div class="mb-8">
        <h3 class="font-black text-lg text-gray-900 tracking-tight">Rumusan Aduan</h3>
        <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1">Prestasi Penyelesaian Masalah</p>
    </div>

    <!-- Live Stats Grid -->
    <div class="space-y-4 mb-6">
        <!-- Perlu Keputusan -->
        <div class="bg-indigo-50/50 p-5 rounded-[2rem] border border-indigo-100/50 flex items-center justify-between group hover:bg-indigo-50 transition-colors">
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Perlu Keputusan</p>
                <h4 class="font-black text-2xl text-gray-900"><%= pendingAduan %></h4>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-indigo-100 text-indigo-600 flex items-center justify-center shadow-sm group-hover:scale-105 transition-transform">
                <i class="fas fa-gavel text-lg"></i>
            </div>
        </div>

        <!-- Dalam Tindakan -->
        <div class="bg-amber-50/50 p-5 rounded-[2rem] border border-amber-100/50 flex items-center justify-between group hover:bg-amber-50 transition-colors">
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Dalam Tindakan</p>
                <h4 class="font-black text-2xl text-gray-900"><%= tindakanAduan %></h4>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-amber-100 text-amber-600 flex items-center justify-center shadow-sm group-hover:scale-105 transition-transform">
                <i class="fas fa-spinner text-lg animate-spin" style="animation-duration: 4s;"></i>
            </div>
        </div>

        <!-- Selesai -->
        <div class="bg-emerald-50/50 p-5 rounded-[2rem] border border-emerald-100/50 flex items-center justify-between group hover:bg-emerald-50 transition-colors">
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Aduan Selesai</p>
                <h4 class="font-black text-2xl text-gray-900"><%= resolvedAduan %></h4>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-600 flex items-center justify-center shadow-sm group-hover:scale-105 transition-transform">
                <i class="fas fa-check-circle text-lg"></i>
            </div>
        </div>
    </div>

    <!-- Resolution Rate Gauge -->
    <div class="p-5 bg-slate-50 border border-slate-100 rounded-[2rem] mb-6 flex flex-col gap-2">
        <div class="flex justify-between items-center text-xs">
            <span class="font-bold text-gray-700">Kadar Penyelesaian Kes</span>
            <span class="font-black text-indigo-600"><%= String.format("%.1f", resolutionRate) %>%</span>
        </div>
        <div class="w-full bg-slate-200 h-2.5 rounded-full overflow-hidden">
            <div class="bg-gradient-to-r from-indigo-500 to-brand-purple h-full rounded-full" style="width: <%= resolutionRate %>%;"></div>
        </div>
        <span class="text-[9px] font-bold text-slate-400 uppercase tracking-wide">Jumlah Keseluruhan: <%= totalAduan %> aduan berdaftar</span>
    </div>

    <!-- WhatsApp Quick Action Card (Safety Biro) -->
    <div class="p-6 bg-emerald-50/50 border border-emerald-100/50 rounded-[2rem] mb-6 group hover:bg-emerald-50 transition-all">
        <h4 class="text-[11px] font-black text-emerald-700 uppercase tracking-widest mb-2 flex items-center gap-2">
            <span class="flex h-2 w-2 rounded-full bg-emerald-500 animate-ping"></span>
            Eskalasi Biro Keselamatan
        </h4>
        <p class="text-xs text-slate-500 leading-relaxed font-medium mb-4">
            Hubungi AJK Biro Keselamatan secara terus untuk siasatan lanjut bagi kes kritikal.
        </p>
        
        <div class="bg-white/60 border border-slate-100 rounded-2xl p-4 mb-4 flex flex-col gap-1">
            <span class="text-[9px] text-slate-400 font-bold uppercase tracking-wider">Nama AJK</span>
            <span class="text-xs font-bold text-slate-700"><%= namaAJKKeselamatan %></span>
            <% if (!telAJKKeselamatan.isEmpty()) { %>
                <span class="text-[10px] text-slate-500 font-medium"><i class="fas fa-phone-alt text-[9px] text-emerald-500 mr-1"></i> <%= telAJKKeselamatan %></span>
            <% } %>
        </div>

        <% if (!telAJKKeselamatan.isEmpty() && !waNumber.isEmpty()) { %>
            <a href="https://wa.me/<%= waNumber %>" target="_blank" class="w-full py-3 bg-[#25D366] hover:bg-[#20ba5a] text-white font-bold rounded-2xl flex items-center justify-center gap-2 transition-all shadow-md shadow-emerald-100/50 cursor-pointer">
                <i class="fab fa-whatsapp text-lg"></i>
                Hubungi WhatsApp
            </a>
        <% } else { %>
            <button disabled class="w-full py-3 bg-slate-100 text-slate-400 font-bold rounded-2xl flex items-center justify-center gap-2 cursor-not-allowed">
                <i class="fas fa-phone-slash"></i>
                Tiada Nombor AJK
            </button>
        <% } %>
    </div>

    <!-- Kuasa Ketua Timeline -->
    <div class="mt-4 pt-6 border-t border-gray-150">
        <h3 class="font-black text-[11px] text-gray-400 mb-4 uppercase tracking-widest">Kuasa Ketua Kampung</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-indigo-600 flex items-center justify-center font-black text-xs border-2 border-indigo-100 z-10 shadow-sm">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase tracking-tight">Keputusan Akhir</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Berikan ulasan dan keputusan rasmi untuk meluluskan, menolak, atau memajukan kes ke pihak atasan.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-slate-400 flex items-center justify-center font-black text-xs border-2 border-gray-100 z-10 shadow-sm">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase tracking-tight">Pemantauan & Eskalasi</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Semak log aduan untuk menjejak sejarah tindakan AJK atau pengendali bagi setiap isu yang dilaporkan.</p>
            </div>
        </div>
    </div>
</aside>


<!-- Modal Update Status (Ketua) -->
<div id="modalStatus" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalStatus')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md">
            <div class="bg-brand-purple px-6 py-4">
                <h3 class="text-lg font-bold text-white">Keputusan Ketua Kampung</h3>
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
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Keputusan Baru</label>
                        <select name="next_status" id="modal-next" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm">
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Ulasan Ketua</label>
                        <textarea name="catatan" rows="3" required placeholder="Sila berikan arahan atau sebab..." class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm"></textarea>
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-brand-purple hover:bg-brand-purpleHover text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Sahkan Keputusan</button>
                    <button type="button" onclick="closeModal('modalStatus')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/views/aduan/modalDetailAduan.jsp" %>

<script>
    function switchTab(name) {
        ['dimajukan', 'tindakan', 'semua'].forEach(t => {
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
            'ESCALATED_TO_KETUA': [
                {v: 'UNDER_REVIEW_KETUA', t: 'Terima untuk Semakan (Ketua)'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'UNDER_REVIEW_KETUA': [
                {v: 'IN_PROGRESS_HIGH_LEVEL', t: 'Mula Tindakan (Pihak Luar/External)'},
                {v: 'RESOLVED', t: 'Tandakan SELESAI'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'IN_PROGRESS_HIGH_LEVEL': [
                {v: 'RESOLVED', t: 'Tandakan SELESAI'}
            ],
            'RESOLVED': [
                {v: 'CLOSED', t: 'Tutup Kes Secara Rasmi'}
            ],
            'REJECTED': [
                {v: 'CLOSED', t: 'Tutup Kes Secara Rasmi'}
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
