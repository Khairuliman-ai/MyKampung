<!-- Modal Detail Aduan -->
<div id="modalAduanDetail" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanDetail')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-4xl">
            <!-- Header -->
            <div class="bg-white border-b border-gray-100 px-8 py-5 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-purple-50 text-[#6C5DD3] flex items-center justify-center">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div>
                        <h3 class="text-lg font-bold text-gray-900" id="det-id-label">Butiran Aduan #000</h3>
                        <p class="text-xs text-gray-500 font-medium">Maklumat terperinci dan sejarah tindakan aduan.</p>
                    </div>
                </div>
                <button type="button" onclick="closeModal('modalAduanDetail')" class="text-gray-400 hover:text-gray-600 transition p-2">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <div class="p-8 max-h-[80vh] overflow-y-auto custom-scrollbar">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <!-- Column 1: Main Info & Image -->
                    <div class="lg:col-span-2 space-y-6">
                        <div class="flex flex-wrap gap-3 mb-2">
                            <span id="det-status-badge" class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border">
                                STATUS
                            </span>
                            <span id="det-priority-badge" class="px-3 py-1 rounded-lg text-[10px] font-black uppercase tracking-widest border">
                                KEUTAMAAN
                            </span>
                        </div>

                        <div>
                            <h2 id="det-tajuk" class="text-2xl font-black text-gray-900 leading-tight mb-4">Tajuk Aduan</h2>
                            <div class="flex flex-wrap gap-4 text-[11px] text-gray-400 font-bold uppercase tracking-wider">
                                <div class="flex items-center gap-2"><i class="far fa-calendar-alt text-[#6C5DD3]"></i> <span id="det-tarikh">-</span></div>
                                <div class="flex items-center gap-2"><i class="fas fa-tag text-[#6C5DD3]"></i> <span id="det-kategori">-</span></div>
                                <div class="flex items-center gap-2"><i class="fas fa-user text-[#6C5DD3]"></i> <span id="det-pengadu">-</span></div>
                            </div>
                        </div>

                        <div class="bg-gray-50 rounded-2xl p-6 border border-gray-100">
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-3">Keterangan Aduan</p>
                            <p id="det-keterangan" class="text-sm text-gray-700 leading-relaxed whitespace-pre-line"></p>
                        </div>

                        <div id="det-gambar-container" class="hidden">
                            <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest mb-3">Gambar Lampiran</p>
                            <div class="relative group rounded-2xl overflow-hidden border border-gray-100 shadow-sm">
                                <img id="det-gambar" src="" class="w-full h-64 object-cover">
                                <a id="det-gambar-link" href="" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
                                    <span class="bg-white px-4 py-2 rounded-xl text-xs font-bold text-gray-900 shadow-lg">Lihat Gambar Penuh</span>
                                </a>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="bg-indigo-50/50 p-5 rounded-2xl border border-indigo-100/50">
                                <p class="text-[10px] text-indigo-400 font-black uppercase tracking-widest mb-2">Catatan AJK</p>
                                <p id="det-catatan-ajk" class="text-xs text-indigo-900 font-medium italic"></p>
                            </div>
                            <div class="bg-amber-50/50 p-5 rounded-2xl border border-amber-100/50">
                                <p class="text-[10px] text-amber-400 font-black uppercase tracking-widest mb-2">Catatan Ketua</p>
                                <p id="det-catatan-ketua" class="text-xs text-amber-900 font-medium italic"></p>
                            </div>
                        </div>
                    </div>

                    <!-- Column 2: Timeline -->
                    <div class="bg-gray-50/50 rounded-3xl p-6 border border-gray-100">
                        <h4 class="text-sm font-black text-gray-900 mb-6 flex items-center gap-2">
                            <i class="fas fa-history text-[#6C5DD3]"></i> Log Aktiviti
                        </h4>
                        
                        <div id="det-logs" class="relative space-y-6 before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-0.5 before:bg-gray-200">
                            <!-- Logs populated by JS -->
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="bg-gray-50 px-8 py-4 flex justify-between items-center">
                <p class="text-[10px] text-gray-400 font-medium">Sila pastikan semua maklumat disemak sebelum membuat keputusan.</p>
                <button type="button" onclick="closeModal('modalAduanDetail')" class="bg-white hover:bg-gray-50 text-gray-700 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-200 transition">Tutup</button>
            </div>
        </div>
    </div>
</div>

<script>
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
        const catatanAjk = row.getAttribute('data-catatan-ajk') || "Tiada catatan.";
        const catatanKetua = row.getAttribute('data-catatan-ketua') || "Tiada catatan.";
        const gambar = row.getAttribute('data-gambar');

        // Populate fields
        document.getElementById('det-id-label').innerText = 'Butiran Aduan #' + id;
        document.getElementById('det-tajuk').innerText = tajuk;
        document.getElementById('det-keterangan').innerText = keterangan;
        document.getElementById('det-pengadu').innerText = pengadu;
        document.getElementById('det-tarikh').innerText = tarikh;
        document.getElementById('det-kategori').innerText = kategori;
        document.getElementById('det-catatan-ajk').innerText = catatanAjk;
        document.getElementById('det-catatan-ketua').innerText = catatanKetua;

        // Status & Priority Badges
        const sBadge = document.getElementById('det-status-badge');
        sBadge.innerText = statusLabel;
        sBadge.className = "px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border " + statusClass;

        const pBadge = document.getElementById('det-priority-badge');
        pBadge.innerText = 'Keutamaan: ' + priority;
        pBadge.className = "px-3 py-1 rounded-lg text-[10px] font-black uppercase tracking-widest border " + priorityClass;

        // Image
        const imgContainer = document.getElementById('det-gambar-container');
        if (gambar && gambar !== "null" && gambar !== "") {
            const contextPath = '<%= request.getContextPath() %>';
            document.getElementById('det-gambar').src = contextPath + '/file/aduan/' + encodeURIComponent(gambar);
            document.getElementById('det-gambar-link').href = contextPath + '/file/aduan/' + encodeURIComponent(gambar);
            imgContainer.classList.remove('hidden');
        } else {
            imgContainer.classList.add('hidden');
        }

        // Fetch Logs via AJAX
        fetchLogs(id);

        document.getElementById('modalAduanDetail').classList.remove('hidden');
    }

    async function fetchLogs(id) {
        const container = document.getElementById('det-logs');
        container.innerHTML = '<p class="text-xs text-gray-400 italic pl-8">Memuatkan log...</p>';
        
        try {
            const response = await fetch('<%= request.getContextPath() %>/aduan/getLogs?id=' + id);
            const logs = await response.json();
            
            container.innerHTML = '';
            if (logs.length === 0) {
                container.innerHTML = '<p class="text-xs text-gray-400 italic pl-8">Tiada log direkodkan.</p>';
            } else {
                logs.forEach(l => {
                    const logEl = document.createElement('div');
                    logEl.className = 'relative pl-8';
                    logEl.innerHTML = `
                        <div class="absolute left-0 top-1 w-6 h-6 rounded-full bg-white border-4 border-[#6C5DD3] z-10"></div>
                        <div class="flex flex-col">
                            <span class="text-[10px] font-black text-gray-400 uppercase tracking-tighter">\${l.tarikh}</span>
                            <span class="text-xs font-black text-gray-900 mt-0.5">\${l.status_baru}</span>
                            <span class="text-[10px] text-gray-500">Oleh: <span class="font-bold">\${l.nama_pelaku}</span></span>
                            \${l.catatan ? `<p class="text-[11px] text-gray-600 mt-2 bg-white p-3 rounded-xl border border-gray-100 shadow-sm">\${l.catatan}</p>` : ''}
                        </div>
                    `;
                    container.appendChild(logEl);
                });
            }
        } catch (error) {
            container.innerHTML = '<p class="text-xs text-red-500 italic pl-8">Gagal memuatkan log.</p>';
        }
    }
</script>
