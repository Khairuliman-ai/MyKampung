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
                listSejarah.add(a);
            } else if ("SUBMITTED".equals(status) || "REOPENED".equals(status)) {
                // Aduan Baharu dan aduan yang dibuka semula (REOPENED) diletakkan di tab pertama
                listBaharu.add(a);
            } else if ("UNDER_REVIEW_AJK".equals(status) || "IN_PROGRESS_AJK".equals(status)) {
                listTindakan.add(a);
            } else {
                listSejarah.add(a);
            }
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F8FAFC]">
    
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
        <div>
            <h2 class="text-xl md:text-2xl font-black text-slate-800">Urus Aduan Penduduk (AJK)</h2>
            <p class="text-xs md:text-sm text-slate-400 font-medium">Biro Keselamatan bertanggungjawab menyemak, mengurus, dan menuntaskan aduan penduduk.</p>
        </div>
    </div>

    <!-- Quick Stats Grid (AJK Dashboard) -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-8">
        <!-- Metric 1: Pending review -->
        <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center text-lg"><i class="fas fa-bell"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Aduan Baharu / Reopened</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= listBaharu.size() %></h4>
            </div>
        </div>
        <!-- Metric 2: Active field actions -->
        <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-lg"><i class="fas fa-tools"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Dalam Tindakan Biro</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= listTindakan.size() %></h4>
            </div>
        </div>
        <!-- Metric 3: History -->
        <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-slate-50 text-slate-500 flex items-center justify-center text-lg"><i class="fas fa-archive"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Sejarah Arkib</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= listSejarah.size() %></h4>
            </div>
        </div>
    </div>

    <!-- Search & Date Filter -->
    <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterData()" placeholder="Cari nombor aduan, tajuk, kategori, pengadu..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-indigo-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Tapis Mengikut Tarikh</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterData()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-indigo-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
        </div>
    </div>

    <!-- Segmented Tabs Navigation -->
    <div class="mb-8 border-b border-slate-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('baharu')" id="tab-baharu" class="py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-indigo-600 text-indigo-600 flex items-center gap-2">
                Aduan Baharu (<%= listBaharu.size() %>)
                <%
                    long hasReopened = listBaharu.stream().filter(a -> "REOPENED".equals(a.getStatus())).count();
                    if (hasReopened > 0) {
                %>
                <span class="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                <% } %>
            </button>
            <button onclick="switchTab('tindakan')" id="tab-tindakan" class="py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition">
                Dalam Tindakan (<%= listTindakan.size() %>)
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" class="py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition">
                Sejarah Arkib (<%= listSejarah.size() %>)
            </button>
        </nav>
    </div>

    <!-- Reusable Table Template Function -->
    <%!
        // We write a helper block directly in the body to avoid duplicate table markup code
        private void renderAduanTable(JspWriter out, List<Aduan> list, String emptyMessage, SimpleDateFormat sdf, SimpleDateFormat sdfFull, String contextPath) throws java.io.IOException {
            out.print("<div class=\"bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden\">");
            out.print("<div class=\"overflow-x-auto\">");
            out.print("<table class=\"w-full text-left border-collapse\">");
            out.print("<thead>");
            out.print("<tr class=\"bg-slate-50 border-b border-slate-100\">");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-12 text-center\">No.</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-36\">Tarikh Laporan</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest\">Pengadu / Isu</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-32\">Keutamaan</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-32\">Status</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest text-center w-36\">Tindakan</th>");
            out.print("</tr>");
            out.print("</thead>");
            out.print("<tbody class=\"divide-y divide-slate-100\">");
            
            if (list != null && !list.isEmpty()) {
                int count = 1;
                for (Aduan a : list) {
                    String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                    String safeTajuk = a.getTajuk() != null ? a.getTajuk().replace("\"", "&quot;").replace("'", "&#39;") : "";
                    String safeKeterangan = a.getKeterangan() != null ? a.getKeterangan().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ").replace("\r", "") : "";
                    String safeAjkCatatan = a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
                    String safeKetuaCatatan = a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
                    String safeGambar = a.getGambar_aduan() != null ? a.getGambar_aduan() : "";
                    String safeBukti = a.getBukti_selesai() != null ? a.getBukti_selesai() : "";
                    
                    boolean canEdit = "SUBMITTED".equals(a.getStatus()) || "UNDER_REVIEW_AJK".equals(a.getStatus()) || "IN_PROGRESS_AJK".equals(a.getStatus()) || "REOPENED".equals(a.getStatus());
                    
                    out.print("<tr class=\"data-row hover:bg-slate-50/50 transition cursor-pointer\" onclick=\"showAduanDetail(this)\" ");
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
                    out.print("<span class=\"text-xs font-black text-slate-800\">" + a.getNama_penuh() + "</span>");
                    out.print("<span class=\"text-[11px] text-slate-400 mt-0.5 line-clamp-1\">" + a.getTajuk() + "</span>");
                    out.print("</div></td>");
                    
                    out.print("<td class=\"p-4 whitespace-nowrap\">");
                    out.print("<span class=\"px-2 py-1 rounded-lg text-[9px] font-extrabold border " + a.getKeutamaanBadge() + "\">" + a.getKeutamaan() + "</span>");
                    out.print("</td>");
                    
                    out.print("<td class=\"p-4 whitespace-nowrap search-col\">");
                    out.print("<span class=\"px-3 py-1.5 rounded-full text-[9px] font-black uppercase " + a.getStatusBadgeClass() + "\">" + a.getStatusLabel() + "</span>");
                    out.print("</td>");
                    
                    out.print("<td class=\"p-4 text-center whitespace-nowrap\" onclick=\"event.stopPropagation()\">");
                    if (canEdit) {
                        out.print("<button onclick=\"openStatusModal('" + a.getId_aduan() + "', '" + a.getStatus() + "', '" + a.getStatusLabel() + "')\" ");
                        out.print("class=\"inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-xl bg-indigo-50 text-indigo-600 hover:bg-indigo-100 hover:scale-105 active:scale-95 transition text-[10px] font-black uppercase tracking-wider shadow-sm border border-indigo-100/50\">");
                        out.print("<i class=\"fas fa-edit\"></i> Kemaskini</button>");
                    } else {
                        out.print("<span class=\"text-slate-300 text-[10px] font-bold inline-flex items-center gap-1 justify-center\"><i class=\"fas fa-lock\"></i> Ditutup</span>");
                    }
                    out.print("</td>");
                    out.print("</tr>");
                }
            } else {
                out.print("<tr class=\"no-data\"><td colspan=\"6\" class=\"p-12 text-center text-slate-400\">");
                out.print("<div class=\"w-12 h-12 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center mx-auto mb-3 text-lg opacity-60\"><i class=\"fas fa-inbox\"></i></div>");
                out.print("<span class=\"font-extrabold text-xs block\">" + emptyMessage + "</span></td></tr>");
            }
            
            out.print("</tbody>");
            out.print("</table>");
            out.print("</div>");
            out.print("</div>");
        }
    %>

    <!-- Tab 1: Aduan Baharu -->
    <div id="content-baharu" class="space-y-6">
        <% renderAduanTable(out, listBaharu, "Tiada aduan baharu yang memerlukan tindakan.", sdf, sdfFull, request.getContextPath()); %>
    </div>

    <!-- Tab 2: Dalam Tindakan -->
    <div id="content-tindakan" class="hidden space-y-6">
        <% renderAduanTable(out, listTindakan, "Tiada aduan yang sedang dalam tindakan lapangan biro anda.", sdf, sdfFull, request.getContextPath()); %>
    </div>

    <!-- Tab 3: Sejarah Arkib -->
    <div id="content-sejarah" class="hidden space-y-6">
        <% renderAduanTable(out, listSejarah, "Tiada rekod sejarah aduan terdahulu.", sdf, sdfFull, request.getContextPath()); %>
    </div>
</div>

<!-- Right Aside Bar (Workflows Summary) -->
<aside class="w-80 bg-white border-l border-slate-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-extrabold text-slate-800 text-lg">Aliran Semakan</h3>
        <p class="text-xs text-slate-400 font-medium">Langkah pengendalian Biro Keselamatan</p>
    </div>

    <!-- Steps -->
    <div class="space-y-6 relative mb-8">
        <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-slate-100"></div>
        
        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-indigo-600 flex items-center justify-center font-black text-xs border-2 border-indigo-600 z-10">1</div>
            <h4 class="font-black text-xs text-slate-800 uppercase">Sahkan Laporan</h4>
            <p class="text-[10px] text-slate-400 mt-1 leading-relaxed">Tukar status aduan kepada 'Dalam Semakan' untuk mengesahkan penerimaan laporan.</p>
        </div>

        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-slate-300 flex items-center justify-center font-black text-xs border-2 border-slate-200 z-10">2</div>
            <h4 class="font-black text-xs text-slate-800 uppercase">Tindakan Lapangan</h4>
            <p class="text-[10px] text-slate-400 mt-1 leading-relaxed">Mula tindakan lapangan. Tukar status kepada 'Tindakan Biro' semasa kerja dijalankan.</p>
        </div>

        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-slate-300 flex items-center justify-center font-black text-xs border-2 border-slate-200 z-10">3</div>
            <h4 class="font-black text-xs text-slate-800 uppercase">Selesai & Lampir Bukti</h4>
            <p class="text-[10px] text-slate-400 mt-1 leading-relaxed">Tukar kepada 'Selesai'. Anda **wajib** memuat naik foto bukti kerja pembaikan yang telah disiapkan.</p>
        </div>
    </div>

    <div class="bg-indigo-50/30 p-5 rounded-2xl border border-indigo-100/50 mt-auto">
        <h4 class="font-black text-xs text-indigo-900 flex items-center gap-1.5 uppercase"><i class="fas fa-shield-alt text-indigo-600"></i> Biro Keselamatan</h4>
        <p class="text-[10px] text-indigo-950/80 leading-relaxed mt-2 font-medium">Biro Keselamatan merupakan pengendali berpusat bagi kesemua aduan penduduk Kampung Danan bagi memastikan gerak kerja efisien dan terselaras.</p>
    </div>
</aside>

<!-- Modal Update Status (Redesigned for proof uploading) -->
<div id="modalStatus" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalStatus')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all w-full sm:my-8 sm:max-w-md border border-slate-100">
            <div class="bg-gradient-to-r from-indigo-600 to-purple-700 px-6 py-5 text-white">
                <h3 class="text-sm font-black uppercase tracking-wider flex items-center gap-2"><i class="fas fa-edit"></i> Kemaskini Status Aduan</h3>
            </div>
            
            <form action="<%= request.getContextPath() %>/aduan/updateStatus?_csrf=<%= session.getAttribute("csrf_token") %>" method="post" enctype="multipart/form-data" id="statusForm">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="id_aduan" id="modal-id">
                <input type="hidden" name="current_status" id="modal-current">
                
                <div class="p-6 space-y-5">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-1">Status Semasa</label>
                        <p id="modal-label" class="text-xs font-black text-slate-800 bg-slate-50 px-4 py-2.5 rounded-xl border border-slate-100 inline-block"></p>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Tindakan / Status Baru</label>
                        <select name="next_status" id="modal-next" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-indigo-500 focus:bg-white text-xs font-bold transition">
                            <!-- Options populated dynamically by JS -->
                        </select>
                    </div>
                    
                    <!-- Upload Bukti Selesai (Dynamic Section, mandatory for RESOLVED) -->
                    <div id="bukti-upload-container" class="hidden space-y-2">
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider">Gambar Bukti Penyelesaian (Wajib)</label>
                        <input type="file" name="bukti_selesai_file" id="bukti-file-input" accept="image/*" 
                               class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-indigo-500 focus:bg-white text-xs transition">
                        <p class="text-[9px] text-slate-400">Sila muat naik foto bukti fizikal bahawa aduan ini telah diselesaikan dengan memuaskan.</p>
                    </div>

                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Catatan Tindakan Biro</label>
                        <textarea name="catatan" rows="3" required placeholder="Jelaskan tindakan yang telah diambil atau ulasan berkenaan laporan ini..." class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-indigo-500 focus:bg-white text-xs transition"></textarea>
                    </div>
                </div>
                
                <div class="bg-slate-50 px-6 py-4 flex flex-row-reverse gap-3 border-t border-slate-100 rounded-b-3xl">
                    <button type="submit" id="btnSubmitStatus" class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2.5 rounded-xl font-bold text-xs shadow-md transition hover:scale-105 flex items-center gap-1">
                        <i class="fas fa-save text-xs"></i> Simpan
                    </button>
                    <button type="button" onclick="closeModal('modalStatus')" class="bg-white hover:bg-slate-50 text-slate-500 px-5 py-2.5 rounded-xl font-bold text-xs border border-slate-200 transition">Batal</button>
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
            document.getElementById('tab-' + t).className = 'py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition';
        });
        document.getElementById('content-' + name).classList.remove('hidden');
        document.getElementById('tab-' + name).className = 'py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-indigo-600 text-indigo-600 flex items-center gap-2';
    }

    function openStatusModal(id, status, label) {
        document.getElementById('modal-id').value = id;
        document.getElementById('modal-current').value = status;
        document.getElementById('modal-label').innerText = label;
        
        // Reset file input & hide container by default
        document.getElementById('bukti-file-input').value = '';
        document.getElementById('bukti-file-input').required = false;
        document.getElementById('bukti-upload-container').classList.add('hidden');

        const next = document.getElementById('modal-next');
        next.innerHTML = '';
        
        // Dynamic status transitions for Biro AJK
        const options = {
            'SUBMITTED': [
                {v: 'UNDER_REVIEW_AJK', t: 'Terima & Semak Aduan'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'UNDER_REVIEW_AJK': [
                {v: 'IN_PROGRESS_AJK', t: 'Mulakan Tindakan Lapangan'},
                {v: 'ESCALATED_TO_KETUA', t: 'Serah Tindakan ke Ketua Kampung'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'IN_PROGRESS_AJK': [
                {v: 'RESOLVED', t: 'Selesaikan Aduan (RESOLVED)'},
                {v: 'ESCALATED_TO_KETUA', t: 'Majukan ke Ketua Kampung'}
            ],
            'REOPENED': [
                {v: 'UNDER_REVIEW_AJK', t: 'Terima Semakan Semula'},
                {v: 'REJECTED', t: 'Tolak & Tutup Kes'}
            ]
        };
        
        const possible = options[status] || [];
        possible.forEach(o => {
            const el = document.createElement('option');
            el.value = o.v;
            el.innerText = o.t;
            next.appendChild(el);
        });
        
        // If the first option is RESOLVED, make sure upload shows up
        if (possible.length > 0 && possible[0].v === 'RESOLVED') {
            document.getElementById('bukti-upload-container').classList.remove('hidden');
            document.getElementById('bukti-file-input').required = true;
        }

        document.getElementById('modalStatus').classList.remove('hidden');
    }

    // Dynamic show/hide upload box when next_status changes
    document.getElementById('modal-next').addEventListener('change', function() {
        const container = document.getElementById('bukti-upload-container');
        const fileInput = document.getElementById('bukti-file-input');
        if (this.value === 'RESOLVED') {
            container.classList.remove('hidden');
            fileInput.required = true;
        } else {
            container.classList.add('hidden');
            fileInput.required = false;
        }
    });

    // Loading overlay on form submit
    document.getElementById("statusForm").addEventListener("submit", function() {
        const btn = document.getElementById("btnSubmitStatus");
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner animate-spin"></i> Menyimpan...';
    });

    // Carian & Penapis
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
</script>

<%@ include file="/views/common/footer.jsp" %>
