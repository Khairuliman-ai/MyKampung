<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.KategoriAduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    List<Aduan> aduanList = (List<Aduan>) request.getAttribute("aduanList");
    List<KategoriAduan> kategoriList = (List<KategoriAduan>) request.getAttribute("kategoriList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");

    // Live metrics calculation
    int totalAduan = (aduanList != null) ? aduanList.size() : 0;
    long pendingCount = 0;
    long resolvedCount = 0;
    if (aduanList != null) {
        pendingCount = aduanList.stream().filter(a -> !"RESOLVED".equals(a.getStatus()) && !"REJECTED".equals(a.getStatus()) && !"CLOSED".equals(a.getStatus())).count();
        resolvedCount = aduanList.stream().filter(a -> "RESOLVED".equals(a.getStatus()) || "CLOSED".equals(a.getStatus())).count();
    }

    String statusParam = request.getParameter("status");
    String msgParam = request.getParameter("msg");
    String errorParam = request.getParameter("error");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F8FAFC] min-w-0">
    
    <!-- Hero / Welcome Section -->
    <div class="relative overflow-hidden rounded-3xl bg-gradient-to-r from-emerald-600 to-teal-700 text-white p-6 md:p-8 shadow-xl mb-8 border border-emerald-500/20 xl:hidden">
        <div class="absolute right-0 bottom-0 opacity-10 pointer-events-none transform translate-y-8 translate-x-8">
            <i class="fas fa-bullhorn text-9xl"></i>
        </div>
        <div class="relative z-10">
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-xl md:text-3xl font-extrabold tracking-tight">Hai, <%= user.getNama_penuh() %>! 👋</h2>
                    <p class="text-xs md:text-sm text-emerald-100 mt-1 font-medium max-w-xl">Pusat Laporan & Aduan Kampung Danan. Kongsi sebarang maklum balas, kerosakan infrastruktur, atau masalah keselamatan untuk tindakan Biro Keselamatan.</p>
                </div>
                <div>
                    <button onclick="openModal('modalAduanBaru')" class="w-full md:w-auto bg-white hover:bg-emerald-50 text-emerald-800 px-6 py-3.5 rounded-2xl font-black text-xs uppercase tracking-wider transition hover:scale-105 active:scale-95 shadow-md flex items-center justify-center gap-2">
                        <i class="fas fa-plus-circle text-sm text-emerald-600"></i> Hantar Laporan Baru
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats Grid (Glassmorphism Cards) -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-8 xl:hidden">
        <!-- Card 1: Total -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-lg"><i class="fas fa-folder-open"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Jumlah Laporan Anda</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= totalAduan %></h4>
            </div>
        </div>
        <!-- Card 2: Pending -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-lg"><i class="fas fa-spinner animate-spin-slow"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Sedang Diproses</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= pendingCount %></h4>
            </div>
        </div>
        <!-- Card 3: Resolved -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-lg"><i class="fas fa-check-circle"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Selesai & Ditutup</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= resolvedCount %></h4>
            </div>
        </div>
    </div>

    <!-- Carian & Penapis Section (Professional Redesign) -->
    <div class="flex flex-col md:flex-row gap-4 mb-8">
        <!-- Search Input -->
        <div class="flex-1 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-emerald-600 group-focus-within:scale-110 transition-all duration-300">
                <i class="fas fa-search text-sm"></i>
            </div>
            <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Cari nombor aduan, tajuk, atau kategori..." 
                class="w-full pl-14 pr-6 py-4 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-emerald-50 focus:border-emerald-500 text-xs font-semibold shadow-sm transition-all outline-none placeholder:text-gray-300">
        </div>
        <!-- Date Filter -->
        <div class="w-full md:w-64 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-emerald-600 group-focus-within:scale-110 transition-all duration-300">
                <i class="far fa-calendar-alt text-sm"></i>
            </div>
            <input type="date" id="dateFilter" onchange="filterTable()" 
                class="w-full pl-14 pr-6 py-4 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-emerald-50 focus:border-emerald-500 text-xs font-semibold shadow-sm transition-all outline-none text-gray-700">
        </div>
    </div>

    <!-- Main Content Tabs -->
    <div class="mb-8 border-b border-slate-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('proses')" id="tab-proses" 
                    class="py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-slate-800 text-slate-800 flex items-center gap-2">
                Sedang Diproses
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition">
                Sejarah Aduan
            </button>
        </nav>
    </div>

    <!-- Reusable Table Template Method -->
    <%!
        private void renderPendudukTable(JspWriter out, List<Aduan> list, boolean isHistoryTable, String emptyMessage, SimpleDateFormat sdf, SimpleDateFormat sdfFull) throws java.io.IOException {
            out.print("<div class=\"bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden\">");
            out.print("<div class=\"overflow-x-auto\">");
            out.print("<table class=\"w-full text-left border-collapse\">");
            out.print("<thead>");
            out.print("<tr class=\"bg-slate-50 border-b border-slate-100\">");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-12 text-center\">No.</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-36\">Tarikh Laporan</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest\">Kategori / Tajuk</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-32\">Keutamaan</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-44\">Kemajuan & Status</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest text-center w-36\">Tindakan</th>");
            out.print("</tr>");
            out.print("</thead>");
            out.print("<tbody class=\"divide-y divide-slate-100\">");
            
            boolean hasRows = false;
            if (list != null && !list.isEmpty()) {
                int count = 1;
                for (Aduan a : list) {
                    String statusKey = a.getStatus() != null ? a.getStatus() : "SUBMITTED";
                    boolean isHistory = "RESOLVED".equals(statusKey) || "CLOSED".equals(statusKey) || "REJECTED".equals(statusKey);
                    
                    if (isHistoryTable != isHistory) {
                        continue;
                    }
                    hasRows = true;
                    
                    String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                    String safeTajuk = a.getTajuk() != null ? a.getTajuk().replace("\"", "&quot;").replace("'", "&#39;") : "";
                    String safeKeterangan = a.getKeterangan() != null ? a.getKeterangan().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ").replace("\r", "") : "";
                    String safeAjkCatatan = a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
                    String safeKetuaCatatan = a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
                    String safeGambar = a.getGambar_aduan() != null ? a.getGambar_aduan() : "";
                    String safeBukti = a.getBukti_selesai() != null ? a.getBukti_selesai() : "";
                    
                    int progressWidth = 25;
                    String stepperColor = "bg-emerald-500";
                    if (isHistory) {
                        progressWidth = 100;
                        if ("REJECTED".equals(statusKey)) {
                            stepperColor = "bg-rose-500";
                        }
                    } else {
                        if ("UNDER_REVIEW_AJK".equals(statusKey) || "UNDER_REVIEW_KETUA".equals(statusKey)) {
                            progressWidth = 50;
                        } else if ("IN_PROGRESS_AJK".equals(statusKey) || "IN_PROGRESS_HIGH_LEVEL".equals(statusKey) || "ESCALATED_TO_KETUA".equals(statusKey)) {
                            progressWidth = 75;
                        } else if ("REOPENED".equals(statusKey)) {
                            progressWidth = 40;
                            stepperColor = "bg-amber-500 animate-pulse";
                        }
                    }
                    
                    out.print("<tr class=\"aduan-row hover:bg-slate-50/50 transition cursor-pointer\" onclick=\"showAduanDetail(this)\" ");
                    out.print("data-date=\"" + filterDate + "\" ");
                    out.print("data-id=\"" + a.getId_aduan() + "\" ");
                    out.print("data-tajuk=\"" + safeTajuk + "\" ");
                    out.print("data-keterangan=\"" + safeKeterangan + "\" ");
                    out.print("data-pengadu=\"" + a.getNama_penuh() + "\" ");
                    out.print("data-tarikh=\"" + (a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-") + "\" ");
                    out.print("data-kategori=\"" + a.getNama_kategori() + "\" ");
                    out.print("data-status=\"" + a.getStatus() + "\" ");
                    out.print("data-status-label=\"" + a.getStatusLabel() + "\" ");
                    out.print("data-status-class=\"" + a.getStatusBadgeClass() + "\" ");
                    out.print("data-priority=\"" + a.getKeutamaan() + "\" ");
                    out.print("data-priority-class=\"" + a.getKeutamaanBadge() + "\" ");
                    out.print("data-catatan-ajk=\"" + safeAjkCatatan + "\" ");
                    out.print("data-catatan-ketua=\"" + safeKetuaCatatan + "\" ");
                    out.print("data-gambar=\"" + safeGambar + "\" ");
                    out.print("data-bukti-selesai=\"" + safeBukti + "\" ");
                    out.print("data-reopen-count=\"" + a.getReopen_count() + "\">");
                    
                    out.print("<td class=\"p-4 text-xs font-bold text-slate-500 text-center\">" + (count++) + "</td>");
                    out.print("<td class=\"p-4 text-xs text-slate-500 whitespace-nowrap\">" + (a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-") + "</td>");
                    
                    out.print("<td class=\"p-4 search-col\">");
                    out.print("<div class=\"flex flex-col\">");
                    out.print("<span class=\"text-xs font-black text-slate-800\">" + a.getNama_kategori() + "</span>");
                    out.print("<span class=\"text-[11px] text-slate-400 mt-0.5 line-clamp-1\">" + a.getTajuk() + "</span>");
                    out.print("</div></td>");
                    
                    out.print("<td class=\"p-4 whitespace-nowrap\">");
                    out.print("<span class=\"px-2 py-1 rounded-lg text-[9px] font-extrabold border " + a.getKeutamaanBadge() + "\">" + a.getKeutamaan() + "</span>");
                    out.print("</td>");
                    
                    out.print("<td class=\"p-4\">");
                    out.print("<div class=\"space-y-1 max-w-[150px]\">");
                    out.print("<div class=\"flex justify-between items-center text-[9px] font-bold text-slate-400 uppercase tracking-tight\">");
                    out.print("<span class=\"" + a.getStatusBadgeClass() + " bg-transparent !p-0 !text-current search-col\">" + a.getStatusLabel() + "</span>");
                    out.print("<span>" + progressWidth + "%</span>");
                    out.print("</div>");
                    out.print("<div class=\"w-full bg-slate-100 h-1 rounded-full flex overflow-hidden\">");
                    out.print("<div class=\"" + stepperColor + " h-full rounded-full transition-all duration-500\" style=\"width: " + progressWidth + "%\"></div>");
                    out.print("</div>");
                    out.print("</div></td>");
                    
                    out.print("<td class=\"p-4 text-center whitespace-nowrap\" onclick=\"event.stopPropagation()\">");
                    out.print("<div class=\"flex items-center justify-center gap-2\">");
                    out.print("<button onclick=\"showAduanDetail(this.closest('.aduan-row'))\" ");
                    out.print("class=\"inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-100 text-slate-700 hover:bg-slate-200 hover:scale-105 active:scale-95 transition text-[10px] font-black uppercase tracking-wider shadow-sm border border-slate-200\">");
                    out.print("<i class=\"fas fa-eye text-emerald-600\"></i> Butiran</button>");
                    if (isHistory && a.getReopen_count() < 2) {
                        out.print("<button onclick=\"openReopenModal(" + a.getId_aduan() + ")\" ");
                        out.print("class=\"inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 text-amber-600 hover:bg-amber-100 hover:scale-105 active:scale-95 transition text-[10px] font-black uppercase tracking-wider shadow-sm border border-amber-200\" ");
                        out.print("title=\"Buka Semula Aduan (" + a.getReopen_count() + "/2)\">");
                        out.print("<i class=\"fas fa-undo\"></i> Reopen</button>");
                    }
                    out.print("</div></td>");
                    out.print("</tr>");
                }
            }
            
            if (!hasRows) {
                out.print("<tr><td colspan=\"6\" class=\"p-12 text-center text-slate-400\">");
                out.print("<div class=\"w-12 h-12 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center mx-auto mb-3 text-lg opacity-60\"><i class=\"fas fa-inbox\"></i></div>");
                out.print("<span class=\"font-extrabold text-xs block\">" + emptyMessage + "</span></td></tr>");
            }
            
            // Search empty indicator
            String searchEmptyId = isHistoryTable ? "sejarah-empty" : "proses-empty";
            out.print("<tr id=\"" + searchEmptyId + "\" class=\"hidden\"><td colspan=\"6\" class=\"p-8 text-center text-slate-400\">");
            out.print("<div class=\"w-12 h-12 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center mx-auto mb-3 text-lg opacity-60\"><i class=\"fas fa-search\"></i></div>");
            out.print("<span class=\"font-extrabold text-xs block\">Tiada aduan sepadan dengan carian.</span></td></tr>");
            
            out.print("</tbody>");
            out.print("</table>");
            out.print("</div>");
            out.print("</div>");
        }
    %>

    <!-- Tab 1: Sedang Diproses -->
    <div id="content-proses" class="block animate-fade-in-up">
        <% renderPendudukTable(out, aduanList, false, "Tiada aduan sedang diproses.", sdf, sdfFull); %>
    </div>

    <!-- Tab 2: Sejarah Aduan -->
    <div id="content-sejarah" class="hidden animate-fade-in-up">
        <% renderPendudukTable(out, aduanList, true, "Tiada sejarah aduan ditemui.", sdf, sdfFull); %>
    </div>

</div>

<!-- Right Aside Bar (Aduan) -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar flex-shrink-0 animate-fade-in">
    <!-- Welcome Card -->
    <div class="p-7 rounded-[2.5rem] bg-gradient-to-br from-emerald-600 to-teal-700 text-white relative overflow-hidden group shadow-xl shadow-emerald-100/50 mb-8 flex flex-col justify-between min-h-[220px]">
        <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-white/10 rounded-full blur-2xl group-hover:bg-white/20 transition-colors"></div>
        <div class="absolute right-3 top-3 opacity-10 pointer-events-none">
            <i class="fas fa-bullhorn text-6xl"></i>
        </div>
        <div class="relative z-10">
            <h4 class="font-black text-lg mb-2 tracking-tight">Hai, <%= user.getNama_penuh() %>! 👋</h4>
            <p class="text-[11px] text-emerald-100/90 leading-relaxed font-medium mb-6">Pusat Laporan & Aduan Kampung Danan. Kongsi sebarang maklum balas, kerosakan infrastruktur, atau masalah keselamatan untuk tindakan Biro Keselamatan.</p>
        </div>
        <button onclick="openModal('modalAduanBaru')" class="w-full bg-white hover:bg-emerald-50 text-emerald-800 py-3.5 rounded-2xl text-[11px] font-black uppercase tracking-wider transition hover:scale-[1.02] active:scale-95 shadow-md flex items-center justify-center gap-2 relative z-10">
            <i class="fas fa-plus-circle text-xs text-emerald-600"></i> Hantar Laporan Baru
        </button>
    </div>

    <!-- Stats Section -->
    <div class="flex justify-between items-center mb-6">
        <h3 class="font-black text-lg text-gray-800 tracking-tight">Statistik Aduan</h3>
        <div class="w-8 h-8 bg-emerald-50 rounded-xl flex items-center justify-center text-emerald-600">
            <i class="fas fa-chart-simple text-xs"></i>
        </div>
    </div>

    <div class="space-y-4">
        <!-- Card 1: Total -->
        <div class="bg-slate-50/50 p-5 rounded-[2rem] border border-slate-100 flex items-center gap-4 hover:bg-slate-50 transition duration-300">
            <div class="w-11 h-11 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-base flex-shrink-0"><i class="fas fa-folder-open"></i></div>
            <div>
                <p class="text-[9px] text-slate-400 font-extrabold uppercase tracking-wider">Jumlah Laporan Anda</p>
                <h4 class="text-xl font-black text-slate-800 mt-0.5"><%= totalAduan %></h4>
            </div>
        </div>

        <!-- Card 2: Pending -->
        <div class="bg-slate-50/50 p-5 rounded-[2rem] border border-slate-100 flex items-center gap-4 hover:bg-slate-50 transition duration-300">
            <div class="w-11 h-11 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-base flex-shrink-0"><i class="fas fa-spinner animate-spin-slow"></i></div>
            <div>
                <p class="text-[9px] text-slate-400 font-extrabold uppercase tracking-wider">Sedang Diproses</p>
                <h4 class="text-xl font-black text-slate-800 mt-0.5"><%= pendingCount %></h4>
            </div>
        </div>

        <!-- Card 3: Resolved -->
        <div class="bg-slate-50/50 p-5 rounded-[2rem] border border-slate-100 flex items-center gap-4 hover:bg-slate-50 transition duration-300">
            <div class="w-11 h-11 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-base flex-shrink-0"><i class="fas fa-check-circle"></i></div>
            <div>
                <p class="text-[9px] text-slate-400 font-extrabold uppercase tracking-wider">Selesai & Ditutup</p>
                <h4 class="text-xl font-black text-slate-800 mt-0.5"><%= resolvedCount %></h4>
            </div>
        </div>
    </div>
</aside>

<style>
    .custom-scrollbar::-webkit-scrollbar { width: 4px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #E5E7EB; border-radius: 10px; }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #059669; }
</style>

<!-- Modal Aduan Baru (Redesigned with Previews and counters) -->
<div id="modalAduanBaru" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanBaru')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all w-full sm:my-8 sm:max-w-lg border border-slate-100">
            <div class="bg-gradient-to-r from-emerald-600 to-teal-700 px-6 py-5 flex justify-between items-center text-white">
                <h3 class="text-sm font-black uppercase tracking-wider flex items-center gap-2"><i class="fas fa-pen-nib"></i> Hantar Aduan Baru</h3>
                <button class="text-white/60 hover:text-white" onclick="closeModal('modalAduanBaru')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/submit" method="post" enctype="multipart/form-data" id="aduanForm">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <div class="bg-white px-4 py-6 sm:px-6 space-y-5 max-h-[70vh] overflow-y-auto custom-scrollbar">
                    
                    <!-- Tajuk -->
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Tajuk Aduan / Isu</label>
                        <input type="text" name="tajuk" id="tajukInput" required max="100" placeholder="Contoh: Lampu jalan rosak di simpang lorong 2..." 
                               class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                    </div>

                    <!-- Kategori & Keutamaan -->
                    <div class="flex justify-between items-center mb-1">
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider">Kategori & Keutamaan</label>
                        <button type="button" onclick="getAICategories()" id="btnSuggestAI"
                                class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-emerald-50 text-emerald-700 hover:bg-emerald-100 hover:scale-105 active:scale-95 transition text-[10px] font-extrabold uppercase tracking-wider border border-emerald-100 shadow-sm">
                            <i class="fas fa-magic"></i> Cadangan AI ✨
                        </button>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Kategori Isu</label>
                            <select name="id_kategori" id="kategoriSelect" required class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                                <% if (kategoriList != null) { 
                                    for (KategoriAduan k : kategoriList) { %>
                                    <option value="<%= k.getId_kategori_aduan() %>"><%= k.getNama_kategori() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Tahap Keutamaan</label>
                            <select name="keutamaan" id="keutamaanSelect" required class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                                <option value="RENDAH">RENDAH</option>
                                <option value="SEDERHANA" selected>SEDERHANA</option>
                                <option value="TINGGI">TINGGI</option>
                                <option value="KRITIKAL">KRITIKAL</option>
                            </select>
                        </div>
                    </div>

                    <!-- AI Suggestion Reason -->
                    <div id="aiReasonContainer" class="hidden p-3.5 rounded-2xl bg-emerald-50/50 border border-emerald-100/50 text-[10px] text-emerald-800 font-medium transition-all duration-300">
                        <div class="flex items-center gap-1.5 font-bold mb-1">
                            <i class="fas fa-robot text-emerald-600 text-xs"></i> Ulasan Cadangan AI:
                        </div>
                        <p id="aiReasonText"></p>
                    </div>

                    <!-- Keterangan -->
                    <div>
                        <div class="flex justify-between items-center mb-2">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider">Keterangan Terperinci</label>
                            <span id="charCount" class="text-[9px] text-slate-400 font-bold">0 / 500</span>
                        </div>
                        <textarea name="keterangan" id="keteranganInput" rows="4" required maxlength="500" onkeyup="updateCharCount()"
                                  placeholder="Sila jelaskan butiran masalah secara terperinci (lokasi, waktu kejadian, dll)..." 
                                  class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition"></textarea>
                    </div>

                    <!-- Gambar Bukti & Preview -->
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Gambar Lampiran Bukti (Jika Ada)</label>
                        
                        <!-- Upload Box -->
                        <div id="uploadBox" class="mt-1 flex flex-col justify-center px-6 pt-5 pb-6 border-2 border-slate-100 border-dashed rounded-2xl hover:border-emerald-500 hover:bg-emerald-50/10 transition cursor-pointer text-center" 
                             onclick="document.getElementById('fileInput').click()">
                            <i class="fas fa-image text-slate-300 text-3xl mb-2"></i>
                            <div class="flex text-xs text-slate-500 justify-center">
                                <span class="font-bold text-emerald-600">Klik untuk memuat naik</span>
                                <p class="pl-1">atau seret dan lepas fail</p>
                            </div>
                            <p class="text-[9px] text-slate-400 mt-1">PNG, JPG, JPEG (Had 5MB)</p>
                            <input id="fileInput" name="gambar_aduan" type="file" class="hidden" accept="image/*" onchange="previewImage(this)">
                        </div>

                        <!-- Image Preview Container -->
                        <div id="imagePreviewContainer" class="hidden mt-3 relative rounded-2xl overflow-hidden border border-slate-100 shadow-sm aspect-video">
                            <img id="imagePreview" src="#" class="w-full h-full object-cover">
                            <button type="button" onclick="removePreview()" class="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/60 hover:bg-black/80 text-white flex items-center justify-center transition hover:scale-105">
                                <i class="fas fa-trash-alt text-xs"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Modal Actions -->
                <div class="bg-slate-50 px-8 py-4 flex flex-row-reverse gap-3 border-t border-slate-100 rounded-b-3xl">
                    <button type="submit" id="btnSubmitAduan" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2.5 rounded-xl font-bold text-xs shadow-md transition hover:scale-105 flex items-center gap-1.5">
                        <i class="fas fa-paper-plane text-xs"></i> Hantar Aduan
                    </button>
                    <button type="button" onclick="closeModal('modalAduanBaru')" class="bg-white hover:bg-slate-50 text-slate-500 px-5 py-2.5 rounded-xl font-bold text-xs border border-slate-200 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/views/aduan/modalDetailAduan.jsp" %>

<script>
    // Live Search Filter for Tables & Tabs
    function filterTable() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        
        // Filter rows in "Sedang Diproses" table
        const prosesRows = document.querySelectorAll("#content-proses .aduan-row");
        let activeFound = false;
        
        prosesRows.forEach(row => {
            const cardDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showRow = true;
            if (dateVal !== "" && cardDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
            
            row.style.display = showRow ? "" : "none";
            if (showRow) {
                activeFound = true;
            }
        });
        
        const prosesEmpty = document.getElementById("proses-empty");
        if (prosesEmpty) {
            if (!activeFound && (searchVal !== "" || dateVal !== "")) {
                prosesEmpty.classList.remove("hidden");
            } else {
                prosesEmpty.classList.add("hidden");
            }
        }

        // Filter rows in "Sejarah Aduan" table
        const sejarahRows = document.querySelectorAll("#content-sejarah .aduan-row");
        let sejarahFound = false;
        
        sejarahRows.forEach(row => {
            const cardDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showRow = true;
            if (dateVal !== "" && cardDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
            
            row.style.display = showRow ? "" : "none";
            if (showRow) {
                sejarahFound = true;
            }
        });
        
        const sejarahEmpty = document.getElementById("sejarah-empty");
        if (sejarahEmpty) {
            if (!sejarahFound && (searchVal !== "" || dateVal !== "")) {
                sejarahEmpty.classList.remove("hidden");
            } else {
                sejarahEmpty.classList.add("hidden");
            }
        }
    }

    // Interactive Tab Switching
    function switchTab(tabId) {
        const tabProses = document.getElementById('tab-proses');
        const tabSejarah = document.getElementById('tab-sejarah');
        const contentProses = document.getElementById('content-proses');
        const contentSejarah = document.getElementById('content-sejarah');
        
        if (tabId === 'proses') {
            tabProses.className = "py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-slate-800 text-slate-800 flex items-center gap-2";
            tabSejarah.className = "py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition";
            contentProses.classList.remove('hidden');
            contentProses.classList.add('block');
            contentSejarah.classList.add('hidden');
            contentSejarah.classList.remove('block');
        } else {
            tabSejarah.className = "py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-slate-800 text-slate-800 flex items-center gap-2";
            tabProses.className = "py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition";
            contentSejarah.classList.remove('hidden');
            contentSejarah.classList.add('block');
            contentProses.classList.add('hidden');
            contentProses.classList.remove('block');
        }
        // Run search filter to apply specifically to the current tab
        filterTable();
    }

    // Live character counter
    function updateCharCount() {
        const textarea = document.getElementById("keteranganInput");
        const count = document.getElementById("charCount");
        count.innerText = textarea.value.length + " / 500";
    }

    // Live Upload Image Preview
    function previewImage(input) {
        const previewContainer = document.getElementById("imagePreviewContainer");
        const preview = document.getElementById("imagePreview");
        const uploadBox = document.getElementById("uploadBox");

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                uploadBox.classList.add("hidden");
                previewContainer.classList.remove("hidden");
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Remove Upload Image Preview
    function removePreview() {
        const previewContainer = document.getElementById("imagePreviewContainer");
        const uploadBox = document.getElementById("uploadBox");
        const fileInput = document.getElementById("fileInput");

        fileInput.value = "";
        previewContainer.classList.add("hidden");
        uploadBox.classList.remove("hidden");
    }

    // Loading overlay on form submit
    document.getElementById("aduanForm").addEventListener("submit", function() {
        const btn = document.getElementById("btnSubmitAduan");
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner animate-spin"></i> Menghantar...';
    });

    // SweetAlert2 Toast Notifications
    document.addEventListener("DOMContentLoaded", function() {
        <% if ("success".equals(statusParam)) { %>
            Swal.fire({
                icon: 'success',
                title: 'Aduan Dihantar!',
                text: 'Aduan anda telah berjaya dihantar dan ditugaskan kepada Biro Keselamatan.',
                confirmButtonColor: '#059669',
                customClass: { popup: 'rounded-3xl font-sans' }
            });
        <% } else if ("error".equals(statusParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Ralat Penghantaran!',
                text: 'Sistem gagal menyimpan aduan. Sila semak semula fail lampiran atau cuba lagi.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("reopened".equals(statusParam) || "reopened".equals(msgParam)) { %>
            Swal.fire({
                icon: 'success',
                title: 'Aduan Dibuka Semula!',
                text: 'Aduan anda telah berjaya dibuka semula dan diletakkan di bawah pemantauan sensitif Biro Keselamatan.',
                confirmButtonColor: '#D97706',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("db".equals(errorParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Ralat Pangkalan Data!',
                text: 'Perubahan gagal disimpan. Pangkalan data mengalami masalah sementara.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("reopen_limit".equals(errorParam)) { %>
            Swal.fire({
                icon: 'warning',
                title: 'Had Reopen Dicapai!',
                text: 'Anda hanya dibenarkan membuka semula sesuatu aduan maksimum 2 kali sahaja.',
                confirmButtonColor: '#D97706',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("cannot_reopen".equals(errorParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Tidak Boleh Dibuka Semula!',
                text: 'Aduan hanya boleh dibuka semula sekiranya ia telah diselesaikan atau ditolak oleh pihak pengurusan.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } %>
    });

    async function getAICategories() {
        const tajuk = document.getElementById("tajukInput").value.trim();
        const keterangan = document.getElementById("keteranganInput").value.trim();
        
        if (!tajuk && !keterangan) {
            Swal.fire({
                icon: 'warning',
                title: 'Input Diperlukan',
                text: 'Sila masukkan tajuk atau keterangan aduan terlebih dahulu sebelum menggunakan cadangan AI.',
                confirmButtonColor: '#10B981',
                customClass: { popup: 'rounded-3xl' }
            });
            return;
        }
        
        const btn = document.getElementById("btnSuggestAI");
        const originalHtml = btn.innerHTML;
        
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner animate-spin"></i> Memproses...';
        
        const aiReasonContainer = document.getElementById("aiReasonContainer");
        const aiReasonText = document.getElementById("aiReasonText");
        
        try {
            const url = '<%= request.getContextPath() %>/aduan/suggestAI?tajuk=' + encodeURIComponent(tajuk) + '&keterangan=' + encodeURIComponent(keterangan);
            const response = await fetch(url);
            
            if (!response.ok) {
                throw new Error("HTTP error " + response.status);
            }
            
            const data = await response.json();
            
            if (data.id_kategori && data.keutamaan) {
                // Update dropdown inputs
                document.getElementById("kategoriSelect").value = data.id_kategori;
                document.getElementById("keutamaanSelect").value = data.keutamaan;
                
                // Show reasoning
                aiReasonText.innerText = data.reason || "Kategori dan keutamaan dicadangkan secara automatik oleh AI.";
                aiReasonContainer.classList.remove("hidden");
                
                // Show a nice Toast notification
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    didOpen: (toast) => {
                        toast.addEventListener('mouseenter', Swal.stopTimer)
                        toast.addEventListener('mouseleave', Swal.resumeTimer)
                    }
                });
                Toast.fire({
                    icon: 'success',
                    title: 'Cadangan AI Berjaya Ditambah!'
                });
            } else {
                throw new Error("Format respon AI tidak sah.");
            }
        } catch (error) {
            console.error(error);
            Swal.fire({
                icon: 'error',
                title: 'Gagal Mendapatkan Cadangan AI',
                text: 'Sila cuba sebentar lagi atau pilih kategori secara manual.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        } finally {
            btn.disabled = false;
            btn.innerHTML = originalHtml;
        }
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
