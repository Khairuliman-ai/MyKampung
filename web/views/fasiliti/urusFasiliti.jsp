<%@ page import="java.util.List" %>
<%@ page import="model.Fasiliti" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<Fasiliti> senaraiFasiliti = (List<Fasiliti>) request.getAttribute("senaraiFasiliti");
    List<TempahanFasiliti> senaraiTempahan = (List<TempahanFasiliti>) request.getAttribute("senaraiTempahan");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <!-- Header -->
    <header class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pengurusan Fasiliti</h2>
            <p class="text-gray-500 text-sm">Urus inventori kemudahan kampung, slot masa, dan semak permohonan tempahan.</p>
        </div>
        <div class="flex gap-4">
            <button onclick="openAddModal()" class="px-6 py-3 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-lg shadow-indigo-100 flex items-center gap-2 hover:bg-opacity-90 transition-all">
                <i class="fas fa-plus"></i>
                Tambah Fasiliti
            </button>
        </div>
    </header>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5">
            <div class="w-14 h-14 bg-indigo-50 text-brand-purple rounded-2xl flex items-center justify-center text-xl">
                <i class="fas fa-warehouse"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Jumlah Fasiliti</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= (senaraiFasiliti != null) ? senaraiFasiliti.size() : 0 %></h3>
            </div>
        </div>
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5">
            <div class="w-14 h-14 bg-blue-50 text-blue-500 rounded-2xl flex items-center justify-center text-xl">
                <i class="fas fa-clock-rotate-left"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Permohonan Menunggu</p>
                <% 
                    int pendingCount = 0;
                    if (senaraiTempahan != null) {
                        for (TempahanFasiliti t : senaraiTempahan) if ("MENUNGGU".equals(t.getStatus())) pendingCount++;
                    }
                %>
                <h3 class="text-2xl font-bold text-gray-800"><%= pendingCount %></h3>
            </div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('inventory')" id="tab-inventory" class="pb-4 px-2 text-sm font-bold border-b-2 border-brand-purple text-brand-purple transition-all">Inventori Fasiliti</button>
            <button onclick="switchTab('requests')" id="tab-requests" class="pb-4 px-2 text-sm font-bold border-b-2 border-transparent text-gray-400 hover:text-gray-600 transition-all flex items-center gap-2">
                Permohonan Tempahan
                <% if(pendingCount > 0) { %>
                    <span class="bg-red-500 text-white text-[10px] px-2 py-0.5 rounded-full"><%= pendingCount %></span>
                <% } %>
            </button>
        </nav>
    </div>

    <!-- Tab 1: Inventory -->
    <div id="content-inventory" class="block">
        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Fasiliti</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Lokasi</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                        <% if (senaraiFasiliti != null && !senaraiFasiliti.isEmpty()) { 
                            for (Fasiliti f : senaraiFasiliti) { %>
                            <tr class="hover:bg-gray-50/50 transition-colors">
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-4">
                                        <div class="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center text-brand-purple">
                                            <i class="fas fa-building text-sm"></i>
                                        </div>
                                        <p class="text-sm font-bold text-gray-800"><%= f.getNama_fasiliti() %></p>
                                    </div>
                                </td>
                                <td class="px-8 py-6 text-sm text-gray-500"><%= f.getLokasi() %></td>
                                <td class="px-8 py-6">
                                    <% if ("AKTIF".equalsIgnoreCase(f.getStatus())) { %>
                                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Aktif</span>
                                    <% } else { %>
                                        <span class="px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Tidak Aktif</span>
                                    <% } %>
                                </td>
                                <td class="px-8 py-6">
                                    <div class="flex justify-center gap-3">
                                        <% if ("Ketua Kampung".equalsIgnoreCase(role) || "Setiausaha".equals(biro)) {
                                            if (f.getLatitude() != null && f.getLongitude() != null) { %>
                                            <a href="https://www.google.com/maps/dir/?api=1&destination=<%= f.getLatitude() %>,<%= f.getLongitude() %>"
                                               target="_blank"
                                               class="w-9 h-9 flex items-center justify-center bg-gray-50 text-green-500 hover:text-green-600 hover:bg-green-50 rounded-xl transition-all"
                                               title="Navigasi GPS">
                                                <i class="fas fa-route text-xs"></i>
                                            </a>
                                        <% } } %>
                                        <button onclick="openEditModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', '<%= f.getLokasi() %>', '<%= f.getStatus() %>', '<%= f.getLatitude() != null ? f.getLatitude() : "" %>', '<%= f.getLongitude() != null ? f.getLongitude() : "" %>')" 
                                                class="w-9 h-9 flex items-center justify-center bg-gray-50 text-gray-400 hover:text-brand-purple hover:bg-indigo-50 rounded-xl transition-all">
                                            <i class="fas fa-pen text-xs"></i>
                                        </button>
                                        <a href="<%= contextPath %>/fasiliti/padam?id=<%= f.getId_fasiliti() %>" 
                                           onclick="return confirm('Adakah anda pasti mahu memadam fasiliti ini?')"
                                           class="w-9 h-9 flex items-center justify-center bg-gray-50 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all">
                                            <i class="fas fa-trash text-xs"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="4" class="px-8 py-10 text-center text-gray-400 text-sm italic">Tiada data fasiliti.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    <!-- Tab 2: Booking Requests -->
    <div id="content-requests" class="hidden">
        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Pemohon</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Fasiliti</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tarikh & Masa</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Sebab/Catatan</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                        <% if (senaraiTempahan != null && !senaraiTempahan.isEmpty()) { 
                            for (TempahanFasiliti t : senaraiTempahan) { %>
                            <tr class="hover:bg-gray-50/50 transition-colors">
                                <td class="px-8 py-6">
                                    <p class="text-sm font-bold text-gray-800"><%= t.getNama_pengguna() %></p>
                                    <p class="text-[10px] text-gray-400">ID: #<%= t.getId_tempahan() %></p>
                                </td>
                                <td class="px-8 py-6 text-sm text-gray-500 font-medium"><%= t.getNama_fasiliti() %></td>
                                <td class="px-8 py-6">
                                    <p class="text-xs font-bold text-gray-700"><%= t.getTarikh_tempah() %></p>
                                    <p class="text-[10px] text-gray-400"><%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %></p>
                                </td>
                                <td class="px-8 py-6">
                                    <p class="text-[10px] text-gray-500 max-w-[150px] truncate" title="<%= t.getCatatan_pemohon() != null ? t.getCatatan_pemohon() : "-" %>">
                                        <%= t.getCatatan_pemohon() != null ? t.getCatatan_pemohon() : "-" %>
                                    </p>
                                </td>
                                <td class="px-8 py-6">
                                    <% if ("MENUNGGU".equals(t.getStatus())) { %>
                                        <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Menunggu</span>
                                    <% } else if ("LULUS".equals(t.getStatus())) { %>
                                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Lulus</span>
                                    <% } else { %>
                                        <span class="px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold uppercase tracking-wider"><%= t.getStatus() %></span>
                                    <% } %>
                                </td>
                                <td class="px-8 py-6">
                                    <% if ("MENUNGGU".equals(t.getStatus())) { %>
                                        <div class="flex justify-center gap-2">
                                            <form action="<%= contextPath %>/fasiliti/approve" method="post" class="inline">
                                                <input type="hidden" name="idTempahan" value="<%= t.getId_tempahan() %>">
                                                <button type="submit" class="bg-green-100 text-green-600 px-3 py-1.5 rounded-xl text-[10px] font-bold hover:bg-green-200 transition">Lulus</button>
                                            </form>
                                            <form action="<%= contextPath %>/fasiliti/reject" method="post" class="inline">
                                                <input type="hidden" name="idTempahan" value="<%= t.getId_tempahan() %>">
                                                <button type="submit" class="bg-red-100 text-red-600 px-3 py-1.5 rounded-xl text-[10px] font-bold hover:bg-red-200 transition">Tolak</button>
                                            </form>
                                        </div>
                                    <% } else { %>
                                        <div class="text-center text-xs text-gray-300 italic">Selesai</div>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="6" class="px-8 py-10 text-center text-gray-400 text-sm italic">Tiada permohonan tempahan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<!-- Modal: Tambah/Edit Fasiliti -->
<div id="modalFasiliti" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[2.5rem] shadow-2xl p-8 transform transition-all">
            <header class="flex justify-between items-center mb-8">
                <h3 class="text-xl font-bold text-gray-800" id="modalTitle">Tambah Fasiliti Baru</h3>
                <button onclick="closeModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form action="<%= contextPath %>/fasiliti/tambah" method="post" id="formFasiliti" class="space-y-6">
                <input type="hidden" name="id" id="fasilitiId">
                
                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Nama Fasiliti</label>
                    <input type="text" name="nama" id="fasilitiNama" required placeholder="Contoh: Dewan Orang Ramai"
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Lokasi</label>
                    <input type="text" name="lokasi" id="fasilitiLokasi" required placeholder="Contoh: Blok A, Jalan Danan 1"
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Status</label>
                    <select name="status" id="fasilitiStatus" class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium appearance-none">
                        <option value="AKTIF">AKTIF</option>
                        <option value="TIDAK AKTIF">TIDAK AKTIF</option>
                    </select>
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Lokasi Pada Peta</label>
                    <div id="mapFasiliti" style="height: 250px; border-radius: 1rem; z-index: 0;" class="border-2 border-dashed border-gray-100"></div>
                    <input type="hidden" name="latitude" id="fasilitiLat">
                    <input type="hidden" name="longitude" id="fasilitiLon">
                </div>

                <button type="submit" class="w-full py-5 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-xl shadow-indigo-100 hover:bg-opacity-90 mt-8 transition-all">
                    Simpan Fasiliti
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(tabId) {
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-brand-purple', 'text-brand-purple');
            btn.classList.add('border-transparent', 'text-gray-400');
        });
        document.getElementById('tab-' + tabId).classList.add('border-brand-purple', 'text-brand-purple');
        document.getElementById('tab-' + tabId).classList.remove('border-transparent', 'text-gray-400');

        document.getElementById('content-inventory').classList.add('hidden');
        document.getElementById('content-requests').classList.add('hidden');
        document.getElementById('content-' + tabId).classList.remove('hidden');
    }

    function closeSlotModal() {
        document.getElementById('modalSlot').classList.add('hidden');
    }

    var fasilitiMap, fasilitiMarker;
    function initFasilitiMap(lat, lon) {
        var defaultLat = 6.0289, defaultLon = 102.2935;
        lat = (lat && lat !== '') ? parseFloat(lat) : defaultLat;
        lon = (lon && lon !== '') ? parseFloat(lon) : defaultLon;
        
        if (fasilitiMap) { fasilitiMap.remove(); }
        
        fasilitiMap = L.map('mapFasiliti').setView([lat, lon], 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19, attribution: '© OpenStreetMap'
        }).addTo(fasilitiMap);
        
        fasilitiMarker = L.marker([lat, lon], { draggable: true }).addTo(fasilitiMap);
        
        function updateF(ll) {
            document.getElementById('fasilitiLat').value = ll.lat.toFixed(8);
            document.getElementById('fasilitiLon').value = ll.lng.toFixed(8);
        }
        
        fasilitiMarker.on('dragend', function(e) { updateF(e.target.getLatLng()); });
        fasilitiMap.on('click', function(e) { fasilitiMarker.setLatLng(e.latlng); updateF(e.latlng); });
        updateF(fasilitiMarker.getLatLng());
        
        setTimeout(function() { fasilitiMap.invalidateSize(); }, 300);
    }

    function openAddModal() {
        document.getElementById('modalTitle').innerText = "Tambah Fasiliti Baru";
        document.getElementById('formFasiliti').action = "<%= contextPath %>/fasiliti/tambah";
        document.getElementById('fasilitiId').value = "";
        document.getElementById('fasilitiNama').value = "";
        document.getElementById('fasilitiLokasi').value = "";
        document.getElementById('fasilitiStatus').value = "AKTIF";
        document.getElementById('modalFasiliti').classList.remove('hidden');
        setTimeout(function(){ initFasilitiMap(); }, 100);
    }

    function openEditModal(id, nama, lokasi, status, lat, lon) {
        document.getElementById('modalTitle').innerText = "Kemaskini Fasiliti";
        document.getElementById('formFasiliti').action = "<%= contextPath %>/fasiliti/edit";
        document.getElementById('fasilitiId').value = id;
        document.getElementById('fasilitiNama').value = nama;
        document.getElementById('fasilitiLokasi').value = lokasi;
        document.getElementById('fasilitiStatus').value = status;
        document.getElementById('modalFasiliti').classList.remove('hidden');
        setTimeout(function(){ initFasilitiMap(lat, lon); }, 100);
    }

    function closeModal() {
        document.getElementById('modalFasiliti').classList.add('hidden');
    }

</script>

<%@ include file="/views/common/footer.jsp" %>
