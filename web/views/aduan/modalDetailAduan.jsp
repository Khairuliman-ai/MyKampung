<%@ page import="model.Pengguna" %>
<%
    Pengguna modalUser = (Pengguna) session.getAttribute("currentUser");
    String modalRole = (modalUser != null) ? modalUser.getNama_peranan() : "";
%>
<!-- Modal Detail Aduan -->
<div id="modalAduanDetail" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanDetail')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-4xl border border-gray-100">
            <!-- Header -->
            <div id="det-header-bg" class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white px-8 py-6 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-white/10 text-white flex items-center justify-center backdrop-blur-md">
                        <i class="fas fa-file-invoice text-lg"></i>
                    </div>
                    <div>
                        <h3 class="text-lg font-extrabold" id="det-id-label">Butiran Aduan #000</h3>
                        <p class="text-xs text-white/80 font-medium">Maklumat terperinci, gambar bukti dan sejarah kronologi tindakan aduan.</p>
                    </div>
                </div>
                <button type="button" onclick="closeModal('modalAduanDetail')" class="text-white/60 hover:text-white hover:scale-110 transition p-2">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <!-- Content Area -->
            <div class="p-8 max-h-[75vh] overflow-y-auto custom-scrollbar">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Column 1: Main Info & Images (2/3 width) -->
                    <div class="lg:col-span-2 space-y-6">
                        <!-- Badges -->
                        <div class="flex flex-wrap gap-3">
                            <span id="det-status-badge" class="px-3.5 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider border shadow-sm">
                                STATUS
                            </span>
                            <span id="det-priority-badge" class="px-3.5 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider border shadow-sm">
                                KEUTAMAAN
                            </span>
                            <span id="det-reopen-badge" class="hidden px-3.5 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider bg-amber-50 text-amber-800 border border-amber-200 animate-pulse">
                                DIBUKA SEMULA
                            </span>
                        </div>

                        <!-- Title and Meta -->
                        <div>
                            <h2 id="det-tajuk" class="text-xl font-extrabold text-gray-900 leading-tight mb-3">Tajuk Aduan</h2>
                            <div class="flex flex-wrap gap-4 text-[10px] text-gray-400 font-bold uppercase tracking-wider">
                                <div class="flex items-center gap-2"><i class="far fa-calendar-alt text-indigo-500"></i> <span id="det-tarikh">-</span></div>
                                <div class="flex items-center gap-2"><i class="fas fa-tag text-indigo-500"></i> <span id="det-kategori">-</span></div>
                                <div class="flex items-center gap-2"><i class="fas fa-user text-indigo-500"></i> <span id="det-pengadu">-</span></div>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="bg-slate-50/80 rounded-2xl p-5 border border-slate-100">
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-wider mb-2">Keterangan Aduan</p>
                            <p id="det-keterangan" class="text-sm text-gray-700 leading-relaxed whitespace-pre-line"></p>
                        </div>

                        <!-- Images Section (Side-by-side or Stacked Comparison) -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <!-- Complaint Image -->
                            <div id="det-gambar-container" class="hidden">
                                <p class="text-[10px] text-gray-400 font-black uppercase tracking-wider mb-2">Gambar Lampiran Aduan</p>
                                <div class="relative group rounded-2xl overflow-hidden border border-gray-100 shadow-sm bg-gray-50/5 aspect-video md:aspect-square">
                                    <img id="det-gambar" src="" class="w-full h-full object-cover">
                                    <a id="det-gambar-link" href="" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
                                        <span class="bg-white px-4 py-2 rounded-xl text-xs font-bold text-gray-900 shadow-lg">Lihat Gambar Asal</span>
                                    </a>
                                </div>
                            </div>

                            <!-- Resolution Image -->
                            <div id="det-bukti-container" class="hidden">
                                <p class="text-[10px] text-emerald-500 font-black uppercase tracking-wider mb-2">Gambar Bukti Penyelesaian</p>
                                <div class="relative group rounded-2xl overflow-hidden border border-emerald-100 shadow-sm bg-emerald-50/10 aspect-video md:aspect-square">
                                    <img id="det-bukti" src="" class="w-full h-full object-cover">
                                    <a id="det-bukti-link" href="" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
                                        <span class="bg-white px-4 py-2 rounded-xl text-xs font-bold text-gray-900 shadow-lg border border-emerald-50">Lihat Gambar Bukti</span>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Notes from AJK and Ketua -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="bg-indigo-50/30 p-5 rounded-2xl border border-indigo-100/50">
                                <p class="text-[10px] text-indigo-500 font-black uppercase tracking-wider mb-2">Catatan AJK Biro Keselamatan</p>
                                <p id="det-catatan-ajk" class="text-xs text-indigo-900 font-medium italic leading-relaxed"></p>
                            </div>
                            <div class="bg-purple-50/30 p-5 rounded-2xl border border-purple-100/50">
                                <p class="text-[10px] text-purple-500 font-black uppercase tracking-wider mb-2">Catatan Ketua Kampung</p>
                                <p id="det-catatan-ketua" class="text-xs text-purple-900 font-medium italic leading-relaxed"></p>
                            </div>
                        </div>
                    </div>

                    <!-- Column 2: Chronological Timeline Log (1/3 width) -->
                    <div class="bg-slate-50/50 rounded-3xl p-6 border border-slate-100 flex flex-col max-h-[450px] lg:max-h-[60vh] flex-shrink-0">
                        <h4 class="text-xs font-black text-slate-800 uppercase tracking-widest mb-6 flex items-center gap-2 flex-shrink-0">
                            <i class="fas fa-history text-indigo-600"></i> Sejarah & Log Tindakan
                        </h4>
                        
                        <div id="det-logs" class="relative space-y-6 before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-0.5 before:bg-slate-200 overflow-y-auto pr-2 flex-1 custom-scrollbar">
                            <!-- Logs populated dynamically by AJAX -->
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <div class="bg-slate-50 px-8 py-5 flex justify-between items-center border-t border-slate-100 rounded-b-3xl">
                <div id="det-actions" class="flex gap-2">
                    <!-- Dynamic Action Buttons (e.g. Reopen) -->
                </div>
                <div class="flex gap-3 items-center">
                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider hidden sm:block">Dikendalikan oleh Biro Keselamatan</p>
                    <button type="button" onclick="closeModal('modalAduanDetail')" class="bg-white hover:bg-gray-50 text-gray-700 px-6 py-2.5 rounded-xl font-bold text-xs border border-slate-200 shadow-sm transition hover:scale-105 active:scale-95">Tutup</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Reopen Aduan -->
<div id="modalAduanReopen" class="fixed inset-0 z-[70] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanReopen')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-md border border-gray-100">
            <div class="bg-gradient-to-r from-amber-500 to-orange-600 text-white px-6 py-4 flex justify-between items-center">
                <h3 class="text-xs font-black uppercase tracking-wider flex items-center gap-2"><i class="fas fa-undo"></i> Buka Semula Aduan</h3>
                <button class="text-white/60 hover:text-white" onclick="closeModal('modalAduanReopen')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/reopen" method="post">
                <input type="hidden" name="id_aduan" id="reopen-id-aduan">
                <div class="bg-white px-6 py-6 space-y-4">
                    <p class="text-xs text-slate-500 leading-relaxed">Sila jelaskan sebab anda ingin membuka semula aduan ini. Pihak Biro Keselamatan akan meneliti semula laporan anda.</p>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Sebab / Catatan Pengadu</label>
                        <textarea name="catatan" id="reopen-catatan" rows="4" required placeholder="Contoh: Isu jalan berlubang masih belum ditampal dengan sempurna..." class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-amber-500 text-xs transition"></textarea>
                    </div>
                </div>
                <div class="bg-slate-50 px-6 py-4 flex flex-row-reverse gap-3 border-t border-slate-100 rounded-b-3xl">
                    <button type="submit" class="bg-amber-500 hover:bg-amber-600 text-white px-6 py-2 rounded-xl font-bold text-xs shadow-sm transition hover:scale-105 active:scale-95">Hantar</button>
                    <button type="button" onclick="closeModal('modalAduanReopen')" class="bg-white hover:bg-slate-50 text-slate-500 px-5 py-2 rounded-xl font-bold text-xs border border-slate-200 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function getFriendlyStatusLabel(status) {
        if (!status) return "N/A";
        switch (status.toUpperCase()) {
            case "SUBMITTED": return "Aduan Dihantar";
            case "UNDER_REVIEW_AJK": return "Dalam Semakan Biro";
            case "IN_PROGRESS_AJK": return "Tindakan Biro";
            case "ESCALATED_TO_KETUA": return "Diserah ke Ketua Kampung";
            case "UNDER_REVIEW_KETUA": return "Dalam Semakan Ketua";
            case "IN_PROGRESS_HIGH_LEVEL": return "Tindakan Khas Ketua";
            case "RESOLVED": return "Aduan Selesai";
            case "REJECTED": return "Aduan Ditolak";
            case "CLOSED": return "Kes Ditutup";
            case "REOPENED": return "Dibuka Semula";
            default: return status;
        }
    }

    function getFriendlyStatusColorClass(status) {
        if (!status) return "bg-slate-500";
        switch (status.toUpperCase()) {
            case "SUBMITTED": return "bg-blue-500";
            case "UNDER_REVIEW_AJK": return "bg-yellow-500";
            case "IN_PROGRESS_AJK": return "bg-orange-500";
            case "ESCALATED_TO_KETUA": return "bg-purple-500";
            case "UNDER_REVIEW_KETUA": return "bg-indigo-500";
            case "IN_PROGRESS_HIGH_LEVEL": return "bg-cyan-500";
            case "RESOLVED": return "bg-green-500";
            case "REJECTED": return "bg-red-500";
            case "CLOSED": return "bg-slate-400";
            case "REOPENED": return "bg-amber-500 animate-pulse";
            default: return "bg-slate-500";
        }
    }

    function openReopenModal(id) {
        document.getElementById('reopen-id-aduan').value = id;
        document.getElementById('reopen-catatan').value = '';
        document.getElementById('modalAduanReopen').classList.remove('hidden');
    }

    function showAduanDetail(row) {
        const id = row.getAttribute('data-id');
        const tajuk = row.getAttribute('data-tajuk');
        const keterangan = row.getAttribute('data-keterangan');
        const pengadu = row.getAttribute('data-pengadu');
        const tarikh = row.getAttribute('data-tarikh');
        const kategori = row.getAttribute('data-kategori');
        const status = row.getAttribute('data-status');
        const statusLabel = row.getAttribute('data-status-label');
        const statusClass = row.getAttribute('data-status-class');
        const priority = row.getAttribute('data-priority');
        const priorityClass = row.getAttribute('data-priority-class');
        const catatanAjk = row.getAttribute('data-catatan-ajk') || "Tiada catatan tindakan.";
        const catatanKetua = row.getAttribute('data-catatan-ketua') || "Tiada ulasan rasmi.";
        const gambar = row.getAttribute('data-gambar');
        const buktiSelesai = row.getAttribute('data-bukti-selesai');
        const reopenCount = parseInt(row.getAttribute('data-reopen-count') || "0");

        // Populate fields
        document.getElementById('det-id-label').innerText = 'Butiran Aduan #' + id;
        document.getElementById('det-tajuk').innerText = tajuk;
        document.getElementById('det-keterangan').innerText = keterangan;
        document.getElementById('det-pengadu').innerText = pengadu;
        document.getElementById('det-tarikh').innerText = tarikh;
        document.getElementById('det-kategori').innerText = kategori;
        document.getElementById('det-catatan-ajk').innerText = catatanAjk;
        document.getElementById('det-catatan-ketua').innerText = catatanKetua;

        // Header Background Gradient based on status
        const headerBg = document.getElementById('det-header-bg');
        if (status === 'RESOLVED' || status === 'CLOSED') {
            headerBg.className = "bg-gradient-to-r from-emerald-600 to-teal-700 text-white px-8 py-6 flex justify-between items-center";
        } else if (status === 'REJECTED') {
            headerBg.className = "bg-gradient-to-r from-rose-600 to-red-700 text-white px-8 py-6 flex justify-between items-center";
        } else if (status === 'REOPENED') {
            headerBg.className = "bg-gradient-to-r from-amber-500 to-orange-600 text-white px-8 py-6 flex justify-between items-center";
        } else {
            headerBg.className = "bg-gradient-to-r from-blue-600 to-indigo-700 text-white px-8 py-6 flex justify-between items-center";
        }

        // Status & Priority Badges
        const sBadge = document.getElementById('det-status-badge');
        sBadge.innerText = statusLabel;
        sBadge.className = "px-3.5 py-1.5 rounded-full text-[10px] font-black uppercase tracking-wider border shadow-sm " + statusClass;

        const pBadge = document.getElementById('det-priority-badge');
        pBadge.innerText = 'Keutamaan: ' + priority;
        pBadge.className = "px-3.5 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider border shadow-sm " + priorityClass;

        // Reopen Indicator
        const rBadge = document.getElementById('det-reopen-badge');
        if (reopenCount > 0) {
            rBadge.innerText = 'Dibuka Semula (Kali ke-' + reopenCount + ')';
            rBadge.classList.remove('hidden');
        } else {
            rBadge.classList.add('hidden');
        }

        // Complaint Image
        const imgContainer = document.getElementById('det-gambar-container');
        if (gambar && gambar !== "null" && gambar !== "") {
            const contextPath = '<%= request.getContextPath() %>';
            document.getElementById('det-gambar').src = contextPath + '/file/aduan/' + encodeURIComponent(gambar);
            document.getElementById('det-gambar-link').href = contextPath + '/file/aduan/' + encodeURIComponent(gambar);
            imgContainer.classList.remove('hidden');
        } else {
            imgContainer.classList.add('hidden');
        }

        // Resolution Proof Image
        const buktiContainer = document.getElementById('det-bukti-container');
        if (buktiSelesai && buktiSelesai !== "null" && buktiSelesai !== "") {
            const contextPath = '<%= request.getContextPath() %>';
            document.getElementById('det-bukti').src = contextPath + '/file/aduan/' + encodeURIComponent(buktiSelesai);
            document.getElementById('det-bukti-link').href = contextPath + '/file/aduan/' + encodeURIComponent(buktiSelesai);
            buktiContainer.classList.remove('hidden');
        } else {
            buktiContainer.classList.add('hidden');
        }

        // Inject Dynamic Actions (Reopen Button for Penduduk)
        const actionsContainer = document.getElementById('det-actions');
        actionsContainer.innerHTML = '';
        if ("<%= modalRole %>" === "Penduduk") {
            if ((status === 'RESOLVED' || status === 'REJECTED' || status === 'CLOSED') && reopenCount < 2) {
                actionsContainer.innerHTML = 
                    '<button type="button" onclick="closeModal(\'modalAduanDetail\'); openReopenModal(' + id + ');" class="bg-amber-500 hover:bg-amber-600 text-white px-5 py-2.5 rounded-xl font-bold text-xs shadow-sm transition hover:scale-105 active:scale-95 flex items-center gap-1.5">' +
                        '<i class="fas fa-undo"></i> Buka Semula Aduan' +
                    '</button>';
            }
        }

        // Fetch Logs via AJAX
        fetchLogs(id);

        document.getElementById('modalAduanDetail').classList.remove('hidden');
    }

    async function fetchLogs(id) {
        const container = document.getElementById('det-logs');
        container.innerHTML = '<p class="text-xs text-slate-400 italic pl-8">Memuatkan log...</p>';
        
        try {
            const response = await fetch('<%= request.getContextPath() %>/aduan/getLogs?id=' + id);
            if (!response.ok) throw new Error('HTTP status ' + response.status);
            const logs = await response.json();
            
            container.innerHTML = '';
            if (logs.length === 0) {
                container.innerHTML = '<p class="text-xs text-slate-400 italic pl-8">Tiada log direkodkan.</p>';
            } else {
                logs.forEach(l => {
                    const logEl = document.createElement('div');
                    logEl.className = 'relative pl-8';
                    const friendlyStatus = getFriendlyStatusLabel(l.status_baru);
                    const statusDotColor = getFriendlyStatusColorClass(l.status_baru);
                    
                    logEl.innerHTML = 
                        '<div class="absolute left-0 top-1 w-6 h-6 rounded-full bg-white border-4 border-slate-200 shadow-sm flex items-center justify-center z-10">' +
                            '<div class="w-1.5 h-1.5 rounded-full ' + statusDotColor + '"></div>' +
                        '</div>' +
                        '<div class="flex flex-col">' +
                            '<span class="text-[9px] font-black text-slate-400 uppercase tracking-wider">' + l.tarikh + '</span>' +
                            '<span class="text-xs font-extrabold text-slate-800 mt-0.5">' + friendlyStatus + '</span>' +
                            '<span class="text-[10px] text-slate-500">Oleh: <span class="font-bold text-slate-700">' + l.nama_pelaku + '</span></span>' +
                            (l.catatan ? '<p class="text-[11px] text-slate-600 mt-2 bg-white p-3 rounded-xl border border-slate-100 shadow-sm leading-relaxed">' + l.catatan + '</p>' : '') +
                        '</div>';
                    container.appendChild(logEl);
                });
            }
        } catch (error) {
            console.error('Error fetching logs:', error);
            container.innerHTML = '<div class="text-center py-4">' +
                '<p class="text-[10px] text-red-500 font-bold uppercase tracking-wider">Ralat Teknikal</p>' +
                '<p class="text-[9px] text-slate-400 mt-1 italic">' + error.message + '</p>' +
            '</div>';
        }
    }
</script>
