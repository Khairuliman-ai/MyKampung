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
            if ("ESCALATED_TO_KETUA".equals(status) || "RESOLVED".equals(status) || "REJECTED".equals(status)) {
                // Aduan yang dimajukan, diselesaikan, atau ditolak memerlukan tindakan keputusan / penutupan Ketua Kampung
                listDimajukan.add(a);
            } else if ("UNDER_REVIEW_KETUA".equals(status) || "IN_PROGRESS_HIGH_LEVEL".equals(status)) {
                listTindakan.add(a);
            }
            listSemua.add(a);
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");

    // Ambil maklumat Biro Keselamatan dari request attribute (menghapuskan JDBC SQL inline)
    String namaAJKKeselamatan = (String) request.getAttribute("namaAJKKeselamatan");
    if (namaAJKKeselamatan == null) namaAJKKeselamatan = "Tiada AJK";
    String telAJKKeselamatan = (String) request.getAttribute("telAJKKeselamatan");
    if (telAJKKeselamatan == null) telAJKKeselamatan = "";

    String waNumber = telAJKKeselamatan != null ? telAJKKeselamatan.replaceAll("\\D", "") : "";
    if (waNumber.startsWith("0")) {
        waNumber = "6" + waNumber;
    } else if (waNumber.startsWith("1") || waNumber.startsWith("11")) {
        waNumber = "60" + waNumber;
    }
    
    // Hitung statistik untuk dashboard Ketua
    int totalAduan = listSemua.size();
    long resolvedCount = listSemua.stream().filter(a -> "RESOLVED".equals(a.getStatus()) || "CLOSED".equals(a.getStatus())).count();
    double resolutionRate = totalAduan > 0 ? ((double) resolvedCount / totalAduan) * 100 : 0.0;
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F8FAFC]">
    
    <!-- Executive Dashboard Header (Hero) -->
    <div class="relative overflow-hidden rounded-3xl bg-gradient-to-r from-slate-800 to-slate-900 text-white p-6 md:p-8 shadow-xl mb-8 border border-slate-700/50">
        <div class="absolute right-0 bottom-0 opacity-5 pointer-events-none transform translate-y-8 translate-x-8">
            <i class="fas fa-landmark text-9xl"></i>
        </div>
        <div class="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
            <div>
                <span class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider bg-indigo-500/20 text-indigo-300 border border-indigo-500/30">Panel Eksekutif Ketua Kampung</span>
                <h2 class="text-xl md:text-3xl font-extrabold tracking-tight mt-2">Urusan & Pemantauan Aduan</h2>
                <p class="text-xs md:text-sm text-slate-300 mt-1 font-medium max-w-xl">Memantau prestasi penyelesaian Biro Keselamatan dan meluluskan penutupan kes secara muktamad.</p>
            </div>
            
            <!-- Resolution Rate Gauge -->
            <div class="flex items-center gap-4 bg-white/5 backdrop-blur-md p-4 rounded-2xl border border-white/10 shadow-inner">
                <div class="relative flex items-center justify-center">
                    <!-- Donut chart via CSS -->
                    <div class="w-16 h-16 rounded-full flex items-center justify-center bg-slate-800 border-4 border-indigo-500/20" style="background: conic-gradient(#6366f1 <%= resolutionRate %>%, transparent 0)">
                        <div class="w-12 h-12 rounded-full bg-slate-800 flex items-center justify-center">
                            <span class="text-xs font-black text-white"><%= String.format("%.0f", resolutionRate) %>%</span>
                        </div>
                    </div>
                </div>
                <div>
                    <h5 class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Kadar Penyelesaian</h5>
                    <p class="text-xs text-white/90 font-medium mt-0.5"><span class="font-extrabold text-indigo-400"><%= resolvedCount %></span> daripada <%= totalAduan %> kes selesai</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Carian & Penapis Card -->
    <div class="bg-white p-6 rounded-3xl border border-slate-100 shadow-sm mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterData()" placeholder="Cari nombor aduan, tajuk, kategori, pengadu..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-slate-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Tapis Mengikut Tarikh</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterData()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-slate-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
        </div>
    </div>

    <!-- Segmented Navigation Tabs -->
    <div class="mb-8 border-b border-slate-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('dimajukan')" id="tab-dimajukan" class="py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-slate-800 text-slate-800 flex items-center gap-2">
                Perlu Keputusan / Penutupan (<%= listDimajukan.size() %>)
                <%
                    long unresolvedEscalated = listDimajukan.stream().filter(a -> !"CLOSED".equals(a.getStatus())).count();
                    if (unresolvedEscalated > 0) {
                %>
                <span class="w-2 h-2 rounded-full bg-rose-500 animate-pulse"></span>
                <% } %>
            </button>
            <button onclick="switchTab('tindakan')" id="tab-tindakan" class="py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition">
                Dalam Tindakan Ketua (<%= listTindakan.size() %>)
            </button>
            <button onclick="switchTab('semua')" id="tab-semua" class="py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition">
                Semua Laporan LENGKAP (<%= listSemua.size() %>)
            </button>
        </nav>
    </div>

    <!-- Reusable Table Template Method -->
    <%!
        private void renderKetuaTable(JspWriter out, List<Aduan> list, String emptyMessage, SimpleDateFormat sdf, SimpleDateFormat sdfFull) throws java.io.IOException {
            out.print("<div class=\"bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden\">");
            out.print("<div class=\"overflow-x-auto\">");
            out.print("<table class=\"w-full text-left border-collapse\">");
            out.print("<thead>");
            out.print("<tr class=\"bg-slate-50 border-b border-slate-100\">");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-12 text-center\">No.</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-36\">Tarikh Laporan</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest\">Pengadu / Isu</th>");
            out.print("<th class=\"p-4 text-[9px] font-black text-slate-400 uppercase tracking-widest w-40\">Pengendali</th>");
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
                    
                    boolean canEdit = "ESCALATED_TO_KETUA".equals(a.getStatus()) || "UNDER_REVIEW_KETUA".equals(a.getStatus()) || "IN_PROGRESS_HIGH_LEVEL".equals(a.getStatus()) || "RESOLVED".equals(a.getStatus()) || "REJECTED".equals(a.getStatus());
                    String pengendaliName = a.getNama_pengendali() != null ? a.getNama_pengendali() : "Biro Keselamatan";
                    
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
                    
                    out.print("<td class=\"p-4 text-xs font-bold text-slate-600 search-col\">" + pengendaliName + "</td>");
                    
                    out.print("<td class=\"p-4 whitespace-nowrap search-col\">");
                    out.print("<span class=\"px-3 py-1.5 rounded-full text-[9px] font-black uppercase " + a.getStatusBadgeClass() + "\">" + a.getStatusLabel() + "</span>");
                    out.print("</td>");
                    
                    out.print("<td class=\"p-4 text-center whitespace-nowrap\" onclick=\"event.stopPropagation()\">");
                    if (canEdit) {
                        out.print("<button onclick=\"openStatusModal('" + a.getId_aduan() + "', '" + a.getStatus() + "', '" + a.getStatusLabel() + "')\" ");
                        out.print("class=\"inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-xl bg-slate-100 text-slate-700 hover:bg-slate-200 hover:scale-105 active:scale-95 transition text-[10px] font-black uppercase tracking-wider shadow-sm border border-slate-200\">");
                        out.print("<i class=\"fas fa-balance-scale\"></i> Keputusan</button>");
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

    <!-- Tab 1: Aduan Dimajukan -->
    <div id="content-dimajukan" class="space-y-6">
        <% renderKetuaTable(out, listDimajukan, "Tiada aduan baharu yang dimajukan untuk keputusan anda.", sdf, sdfFull); %>
    </div>

    <!-- Tab 2: Dalam Tindakan Ketua -->
    <div id="content-tindakan" class="hidden space-y-6">
        <% renderKetuaTable(out, listTindakan, "Tiada aduan yang sedang dalam tindakan eksekutif anda.", sdf, sdfFull); %>
    </div>

    <!-- Tab 3: Semua Aduan -->
    <div id="content-semua" class="hidden space-y-6">
        <% renderKetuaTable(out, listSemua, "Tiada sebarang rekod aduan penduduk.", sdf, sdfFull); %>
    </div>
</div>

<!-- Right Aside Bar (WhatsApp & Contact AJK) -->
<aside class="w-80 bg-white border-l border-slate-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-extrabold text-slate-800 text-lg">Hubungi Biro</h3>
        <p class="text-xs text-slate-400 font-medium">Biro Keselamatan (Pengendali Utama)</p>
    </div>

    <div class="bg-slate-50 p-6 rounded-3xl border border-slate-100 mb-8 space-y-4">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-sm"><i class="fas fa-user-shield"></i></div>
            <div>
                <h5 class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">AJK Ditugaskan</h5>
                <p class="text-xs font-black text-slate-800 mt-0.5"><%= namaAJKKeselamatan %></p>
            </div>
        </div>
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-sm"><i class="fas fa-phone-alt"></i></div>
            <div>
                <h5 class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Nombor Telefon</h5>
                <p class="text-xs font-black text-slate-800 mt-0.5"><%= telAJKKeselamatan != null && !telAJKKeselamatan.isEmpty() ? telAJKKeselamatan : "Tiada" %></p>
            </div>
        </div>
    </div>

    <% if (!waNumber.isEmpty()) { %>
    <div class="mb-8">
        <a href="https://wa.me/<%= waNumber %>" target="_blank"
           class="w-full bg-[#25D366] hover:bg-[#20ba5a] text-white py-3.5 rounded-2xl font-black text-xs uppercase tracking-wider text-center shadow-lg shadow-green-100 flex items-center justify-center gap-2 transition hover:scale-105 active:scale-95">
            <i class="fab fa-whatsapp text-sm"></i> Hantar WhatsApp ke Biro
        </a>
    </div>
    <% } %>

    <div class="bg-indigo-50/30 p-5 rounded-2xl border border-indigo-100/50 mt-auto">
        <h4 class="font-black text-xs text-indigo-900 flex items-center gap-1.5 uppercase"><i class="fas fa-landmark text-indigo-600"></i> Kuasa Muktamad</h4>
        <p class="text-[10px] text-indigo-950/80 leading-relaxed mt-2 font-medium">Berdasarkan keputusan anda, Ketua Kampung bertanggungjawab secara eksklusif untuk meluluskan penutupan kes rasmi (`CLOSED`). Pengadu tidak dapat menutup kes tanpa ulasan bertulis anda.</p>
    </div>
</aside>

<!-- Modal Update Status (Ketua) -->
<div id="modalStatus" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalStatus')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-md border border-slate-100">
            <div class="bg-gradient-to-r from-slate-800 to-slate-900 px-6 py-5 text-white">
                <h3 class="text-sm font-black uppercase tracking-wider flex items-center gap-2"><i class="fas fa-balance-scale"></i> Keputusan Ketua Kampung</h3>
            </div>
            
            <form action="<%= request.getContextPath() %>/aduan/updateStatus" method="post" id="statusForm">
                <input type="hidden" name="id_aduan" id="modal-id">
                <input type="hidden" name="current_status" id="modal-current">
                
                <div class="p-6 space-y-5">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-1">Status Semasa</label>
                        <p id="modal-label" class="text-xs font-black text-slate-800 bg-slate-50 px-4 py-2.5 rounded-xl border border-slate-100 inline-block"></p>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Keputusan Baru</label>
                        <select name="next_status" id="modal-next" class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-slate-500 focus:bg-white text-xs font-bold transition">
                            <!-- Options populated dynamically by JS -->
                        </select>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Ulasan Bertulis Ketua</label>
                        <textarea name="catatan" rows="3" required placeholder="Tulis ulasan, arahan atau alasan keputusan anda di sini..." class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-slate-500 focus:bg-white text-xs transition"></textarea>
                    </div>
                </div>
                
                <div class="bg-slate-50 px-6 py-4 flex flex-row-reverse gap-3 border-t border-slate-100 rounded-b-3xl">
                    <button type="submit" id="btnSubmitStatus" class="bg-slate-800 hover:bg-slate-900 text-white px-6 py-2.5 rounded-xl font-bold text-xs shadow-md transition hover:scale-105 flex items-center gap-1">
                        <i class="fas fa-check-circle text-xs"></i> Sahkan Keputusan
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
        ['dimajukan', 'tindakan', 'semua'].forEach(t => {
            document.getElementById('content-' + t).classList.add('hidden');
            document.getElementById('tab-' + t).className = 'py-4 px-1 border-b-2 border-transparent font-bold text-xs uppercase tracking-wider text-slate-400 hover:text-slate-600 transition';
        });
        document.getElementById('content-' + name).classList.remove('hidden');
        document.getElementById('tab-' + name).className = 'py-4 px-1 border-b-2 font-black text-xs uppercase tracking-wider border-slate-800 text-slate-800 flex items-center gap-2';
    }

    function openStatusModal(id, status, label) {
        document.getElementById('modal-id').value = id;
        document.getElementById('modal-current').value = status;
        document.getElementById('modal-label').innerText = label;
        
        const next = document.getElementById('modal-next');
        next.innerHTML = '';
        
        // Dynamic status transitions for Ketua Kampung
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
                {v: 'CLOSED', t: 'Tutup & Arkibkan Kes (CLOSED)'}
            ],
            'REJECTED': [
                {v: 'CLOSED', t: 'Tutup & Arkibkan Kes (CLOSED)'}
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
