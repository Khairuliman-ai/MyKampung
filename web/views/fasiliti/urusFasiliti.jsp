<%@ page import="java.util.*, model.*, util.StatusConstant" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<!-- Leaflet Control Geocoder -->
<link rel='stylesheet' href='https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css' />
<script src='https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js'></script>

<!-- Cropper.js CSS & JS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>

<%
    List<Fasiliti> senaraiFasiliti = (List<Fasiliti>) request.getAttribute("senaraiFasiliti");
    List<TempahanFasiliti> senaraiTempahan = (List<TempahanFasiliti>) request.getAttribute("senaraiTempahan");
    int pendingCount = 0;
    if (senaraiTempahan != null) {
        for (TempahanFasiliti t : senaraiTempahan) {
            if (StatusConstant.TEMPAHAN_MENUNGGU.equals(t.getStatus())) {
                pendingCount++;
            }
        }
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9] min-w-0">
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

    <!-- Tabs -->
    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('inventory')" id="tab-inventory" class="pb-4 px-2 text-sm font-bold border-b-2 border-brand-purple text-brand-purple transition-all">Inventori Fasiliti</button>
            <button onclick="switchTab('requests')" id="tab-requests" class="pb-4 px-2 text-sm font-bold border-b-2 border-transparent text-gray-400 hover:text-gray-600 transition-all flex items-center gap-2">
                Menunggu Kelulusan
                <% if(pendingCount > 0) { %>
                    <span class="bg-red-500 text-white text-[10px] px-2 py-0.5 rounded-full"><%= pendingCount %></span>
                <% } %>
            </button>
            <button onclick="switchTab('history')" id="tab-history" class="pb-4 px-2 text-sm font-bold border-b-2 border-transparent text-gray-400 hover:text-gray-600 transition-all flex items-center gap-2">
                Sejarah Tempahan
            </button>
        </nav>
    </div>

    <!-- Tab 1: Inventory -->
    <div id="content-inventory" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16 text-center">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Fasiliti</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Lokasi</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (senaraiFasiliti != null && !senaraiFasiliti.isEmpty()) { 
                            int noInv = 1;
                            for (Fasiliti f : senaraiFasiliti) { %>
                            <tr class="hover:bg-purple-50/50 transition cursor-pointer group">
                                <td class="p-4 text-sm text-gray-400 font-medium text-center"><%= noInv++ %></td>
                                <td class="p-4">
                                    <div class="flex items-center gap-4">
                                        <div class="w-12 h-12 rounded-xl overflow-hidden bg-gray-100 flex-shrink-0">
                                            <% if (f.getGambar_fasiliti() != null) { %>
                                                <img src="${pageContext.request.contextPath}/file/fasiliti/<%= f.getGambar_fasiliti() %>" class="w-full h-full object-cover">
                                            <% } else { %>
                                                <div class="w-full h-full flex items-center justify-center text-brand-purple">
                                                    <i class="fas fa-building text-sm"></i>
                                                </div>
                                            <% } %>
                                        </div>
                                        <p class="text-sm font-bold text-gray-800 group-hover:text-brand-purple"><%= f.getNama_fasiliti() %></p>
                                    </div>
                                </td>
                                <td class="p-4 text-sm text-gray-500"><%= f.getLokasi() %></td>
                                <td class="p-4 text-center">
                                    <% if (StatusConstant.FASILITI_AKTIF.equalsIgnoreCase(f.getStatus())) { %>
                                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Aktif</span>
                                    <% } else { %>
                                        <span class="px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Tidak Aktif</span>
                                    <% } %>
                                </td>
                                <td class="p-4">
                                    <div class="flex justify-center gap-2" onclick="event.stopPropagation()">
                                        <% if (StatusConstant.ROLE_KETUA_KAMPUNG.equalsIgnoreCase(role) || "Setiausaha".equals(biro)) {
                                            if (f.getLatitude() != null && f.getLongitude() != null) { %>
                                            <a href="https://www.google.com/maps/dir/?api=1&destination=<%= f.getLatitude() %>,<%= f.getLongitude() %>"
                                               target="_blank"
                                               class="w-8 h-8 flex items-center justify-center text-green-600 hover:bg-green-100 rounded-lg transition"
                                               title="Navigasi GPS">
                                                <i class="fas fa-route text-xs"></i>
                                            </a>
                                        <% } } %>
                                        
                                        <button onclick="openEditModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', '<%= f.getLokasi() %>', '<%= f.getStatus() %>', '<%= f.getLatitude() != null ? f.getLatitude() : "" %>', '<%= f.getLongitude() != null ? f.getLongitude() : "" %>', <%= f.isRequiresApproval() %>, '<%= f.getGambar_fasiliti() != null ? f.getGambar_fasiliti() : "" %>', '<%= f.getWaktu_buka() != null ? f.getWaktu_buka().toString().substring(0,5) : "08:00" %>', '<%= f.getWaktu_tutup() != null ? f.getWaktu_tutup().toString().substring(0,5) : "22:00" %>', <%= f.getDurasi_slot_minit() > 0 ? f.getDurasi_slot_minit() : 120 %>)" 
                                                class="w-8 h-8 flex items-center justify-center text-blue-600 hover:bg-blue-100 rounded-lg transition" title="Kemaskini">
                                            <i class="fas fa-pen text-xs"></i>
                                        </button>
                                        <a href="<%= contextPath %>/fasiliti/padam?id=<%= f.getId_fasiliti() %>" 
                                           onclick="confirmPadamFasiliti(event, this.href)"
                                           class="w-8 h-8 flex items-center justify-center text-red-600 hover:bg-red-100 rounded-lg transition" title="Padam">
                                            <i class="fas fa-trash text-xs"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="5" class="p-12 text-center text-gray-400 italic">Tiada data fasiliti.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    <!-- Tab 2: Pending Requests -->
    <div id="content-requests" class="hidden">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16 text-center">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Fasiliti</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh & Masa</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Sebab Tempahan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (senaraiTempahan != null) { 
                            boolean hasPending = false;
                            int noReq = 1;
                            for (TempahanFasiliti t : senaraiTempahan) { 
                                if (StatusConstant.TEMPAHAN_MENUNGGU.equals(t.getStatus())) {
                                    hasPending = true; %>
                            <tr class="hover:bg-purple-50/50 transition cursor-pointer group">
                                <td class="p-4 text-sm text-gray-400 font-medium text-center"><%= noReq++ %></td>
                                <td class="p-4">
                                    <p class="text-sm font-bold text-gray-800 group-hover:text-brand-purple"><%= t.getNama_pengguna() %></p>
                                    <p class="text-[10px] text-gray-400">ID: #<%= t.getId_tempahan() %></p>
                                </td>
                                <td class="p-4 text-sm text-gray-600 font-medium"><%= t.getNama_fasiliti() %></td>
                                <td class="p-4">
                                    <p class="text-xs font-bold text-gray-700"><%= t.getTarikh_tempah() %></p>
                                    <p class="text-[10px] text-gray-400"><%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %></p>
                                </td>
                                <td class="p-4">
                                    <p class="text-[10px] text-gray-500 italic max-w-[200px]">
                                        <%= (t.getCatatan_pemohon() != null && !t.getCatatan_pemohon().isEmpty()) ? t.getCatatan_pemohon() : "-" %>
                                    </p>
                                </td>
                                <td class="p-4 text-center">
                                    <div class="flex justify-center gap-2" onclick="event.stopPropagation()">
                                        <form action="<%= contextPath %>/fasiliti/approve" method="post" class="inline" onsubmit="confirmApproveBooking(event, this)">
                                            <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                                            <input type="hidden" name="idTempahan" value="<%= t.getId_tempahan() %>">
                                            <button type="submit" class="bg-green-100 text-green-600 px-4 py-2 rounded-xl text-[10px] font-bold hover:bg-green-200 transition uppercase tracking-wider shadow-sm border border-green-200">Lulus</button>
                                        </form>
                                        <button onclick="openRejectModal('<%= t.getId_tempahan() %>')" class="bg-red-100 text-red-600 px-4 py-2 rounded-xl text-[10px] font-bold hover:bg-red-200 transition uppercase tracking-wider shadow-sm border border-red-200">Tolak</button>
                                    </div>
                                </td>
                            </tr>
                        <% } } if(!hasPending) { %>
                            <tr><td colspan="6" class="p-12 text-center text-gray-400 italic">Tiada permohonan menunggu kelulusan.</td></tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Tab 3: Unified Sejarah Tempahan -->
    <div id="content-history" class="hidden">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16 text-center">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Fasiliti</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh & Masa</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Catatan/Alasan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (senaraiTempahan != null) { 
                            boolean hasHistory = false;
                            int noHist = 1;
                            for (TempahanFasiliti t : senaraiTempahan) { 
                                if (StatusConstant.TEMPAHAN_LULUS.equals(t.getStatus()) || 
                                    StatusConstant.TEMPAHAN_TOLAK.equals(t.getStatus()) || 
                                    StatusConstant.TEMPAHAN_DIBATAL.equals(t.getStatus())) {
                                    hasHistory = true; %>
                            <tr class="hover:bg-purple-50/50 transition cursor-pointer group">
                                <td class="p-4 text-sm text-gray-400 font-medium text-center"><%= noHist++ %></td>
                                <td class="p-4">
                                    <p class="text-sm font-bold text-gray-800 group-hover:text-brand-purple"><%= t.getNama_pengguna() %></p>
                                    <p class="text-[10px] text-gray-400">ID: #<%= t.getId_tempahan() %></p>
                                </td>
                                <td class="p-4 text-sm text-gray-600 font-medium"><%= t.getNama_fasiliti() %></td>
                                <td class="p-4">
                                    <p class="text-xs font-bold text-gray-700"><%= t.getTarikh_tempah() %></p>
                                    <p class="text-[10px] text-gray-400"><%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %></p>
                                </td>
                                <td class="p-4">
                                    <p class="text-[10px] text-gray-500 italic max-w-[200px]">
                                        <% if (StatusConstant.TEMPAHAN_LULUS.equals(t.getStatus())) { %>
                                            Catatan: <%= (t.getCatatan_pemohon() != null && !t.getCatatan_pemohon().isEmpty()) ? t.getCatatan_pemohon() : "-" %>
                                        <% } else if (StatusConstant.TEMPAHAN_TOLAK.equals(t.getStatus())) { %>
                                            Alasan: <%= (t.getAlasanPenolakan() != null && !t.getAlasanPenolakan().isEmpty()) ? t.getAlasanPenolakan() : "-" %>
                                        <% } else { %>
                                            Dibatalkan oleh penduduk
                                        <% } %>
                                    </p>
                                </td>
                                <td class="p-4 text-center">
                                    <% if (StatusConstant.TEMPAHAN_LULUS.equals(t.getStatus())) { %>
                                        <span class="px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Lulus</span>
                                    <% } else if (StatusConstant.TEMPAHAN_TOLAK.equals(t.getStatus())) { %>
                                        <span class="px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Ditolak</span>
                                    <% } else { %>
                                        <span class="px-3 py-1 bg-gray-50 text-gray-400 rounded-full text-[10px] font-bold uppercase tracking-wider">Dibatalkan</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } if(!hasHistory) { %>
                            <tr><td colspan="6" class="p-12 text-center text-gray-400 italic">Tiada sejarah tempahan.</td></tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
    
    <!-- Right Aside Bar (Admin) -->
    <aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar flex-shrink-0">
        <!-- Stats Section -->
        <div class="flex justify-between items-center mb-6">
            <h3 class="font-black text-lg text-gray-800 tracking-tight">Statistik Fasiliti</h3>
            <div class="w-8 h-8 bg-indigo-50 rounded-xl flex items-center justify-center text-brand-purple">
                <i class="fas fa-chart-simple text-xs"></i>
            </div>
        </div>

        <div class="space-y-4 mb-8">
            <!-- Jumlah Fasiliti Card -->
            <div class="bg-slate-50/50 p-5 rounded-[2rem] border border-slate-100 flex items-center gap-4 hover:bg-slate-50 transition duration-300">
                <div class="w-11 h-11 rounded-2xl bg-indigo-50 text-brand-purple flex items-center justify-center text-base flex-shrink-0">
                    <i class="fas fa-warehouse"></i>
                </div>
                <div>
                    <p class="text-[9px] text-slate-400 font-extrabold uppercase tracking-wider">Jumlah Fasiliti</p>
                    <h4 class="text-xl font-black text-slate-800 mt-0.5"><%= (senaraiFasiliti != null) ? senaraiFasiliti.size() : 0 %></h4>
                </div>
            </div>

            <!-- Permohonan Menunggu Card -->
            <div class="bg-slate-50/50 p-5 rounded-[2rem] border border-slate-100 flex items-center gap-4 hover:bg-slate-50 transition duration-300">
                <div class="w-11 h-11 rounded-2xl bg-blue-50 text-blue-500 flex items-center justify-center text-base flex-shrink-0">
                    <i class="fas fa-clock-rotate-left"></i>
                </div>
                <div>
                    <p class="text-[9px] text-slate-400 font-extrabold uppercase tracking-wider">Permohonan Menunggu</p>
                    <h4 class="text-xl font-black text-slate-800 mt-0.5"><%= pendingCount %></h4>
                </div>
            </div>
        </div>

        <div class="flex justify-between items-start mb-6">
            <h3 class="font-bold text-lg text-gray-800">Garis Panduan</h3>
        </div>

        <div class="space-y-8">
            <!-- Tip 1 -->
            <div class="flex gap-4">
                <div class="w-10 h-10 rounded-full bg-blue-50 text-blue-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">
                    <i class="fas fa-check-double"></i>
                </div>
                <div>
                    <h4 class="font-bold text-sm text-gray-800">Semakan Berkala</h4>
                    <p class="text-xs text-gray-500 mt-1 leading-relaxed">Sila semak permohonan baru setiap hari untuk memastikan penduduk mendapat maklum balas segera.</p>
                </div>
            </div>

            <!-- Tip 2 -->
            <div class="flex gap-4">
                <div class="w-10 h-10 rounded-full bg-purple-50 text-brand-purple flex-shrink-0 flex items-center justify-center font-bold text-lg">
                    <i class="fas fa-tools"></i>
                </div>
                <div>
                    <h4 class="font-bold text-sm text-gray-800">Penyelenggaraan</h4>
                    <p class="text-xs text-gray-500 mt-1 leading-relaxed">Gunakan fungsi 'Edit Status' untuk menukar fasiliti kepada <strong>Tidak Aktif</strong> jika terdapat kerja penyelenggaraan.</p>
                </div>
            </div>
            
            <!-- Tip 3 -->
            <div class="flex gap-4">
                <div class="w-10 h-10 rounded-full bg-green-50 text-green-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">
                    <i class="fas fa-file-export"></i>
                </div>
                <div>
                    <h4 class="font-bold text-sm text-gray-800">Laporan Bulanan</h4>
                    <p class="text-xs text-gray-500 mt-1 leading-relaxed">Data tempahan boleh digunakan untuk laporan aktiviti biro sukan kepada Ketua Kampung.</p>
                </div>
            </div>
        </div>

        <!-- Contact Box -->
        <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
            <h4 class="font-bold text-gray-700 mb-2 text-sm">Bantuan Sistem?</h4>
            <p class="text-xs text-gray-500 mb-4">Jika terdapat ralat pada sistem tempahan atau slot masa, sila hubungi unit teknikal Kampung Danan.</p>
            <button class="w-full bg-white border border-gray-200 text-gray-700 py-3 rounded-xl text-xs font-bold hover:bg-gray-100 transition shadow-sm">Hubungi Teknikal</button>
        </div>
    </aside>


<!-- Modal: Tambah/Edit Fasiliti -->
<div id="modalFasiliti" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeModal('modalFasiliti')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[2.5rem] shadow-2xl p-8 transform transition-all">
            <header class="flex justify-between items-center mb-8">
                <h3 class="text-xl font-bold text-gray-800" id="modalTitle">Tambah Fasiliti Baru</h3>
                <button onclick="closeModal('modalFasiliti')" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form action="<%= contextPath %>/fasiliti/tambah" method="post" id="formFasiliti" class="space-y-6" enctype="multipart/form-data">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
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
                        <option value="<%= StatusConstant.FASILITI_AKTIF %>">AKTIF</option>
                        <option value="<%= StatusConstant.FASILITI_TIDAK_AKTIF %>">TIDAK AKTIF</option>
                    </select>
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Gambar Fasiliti</label>
                    <input type="file" name="gambar_fasiliti" id="fasilitiGambar" accept="image/*" onchange="handleImageSelection(this)"
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                    <p class="text-[9px] text-gray-400 mt-1 px-2">Muat naik gambar baharu untuk menukar gambar sedia ada.</p>
                </div>

                <!-- Preview Card (Resident View) -->
                <div class="space-y-3">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Pratinjau (Paparan Penduduk)</label>
                    <div id="residentPreviewCard" class="w-full max-w-sm mx-auto bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden pointer-events-none opacity-80 scale-95 origin-top">
                        <div class="h-40 bg-gray-100 overflow-hidden relative">
                            <img id="cardPreviewImg" src="${pageContext.request.contextPath}/assets/img/placeholder.png" class="w-full h-full object-cover">
                            <div class="absolute top-3 right-3">
                                <span class="bg-green-500 text-white text-[8px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider shadow-sm">Tersedia</span>
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="text-sm font-bold text-gray-800 mb-1" id="cardPreviewNama">Nama Fasiliti</h3>
                            <div class="flex items-center gap-1 text-gray-400 text-[10px]">
                                <i class="fas fa-location-dot"></i>
                                <span id="cardPreviewLokasi">Lokasi</span>
                            </div>
                            <div class="mt-4 flex flex-col gap-2">
                                <div class="w-full h-8 bg-brand-purple/10 rounded-xl"></div>
                                <div class="w-full h-6 bg-gray-50 rounded-xl"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex items-center gap-3 px-2">
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" name="requires_approval" id="fasilitiRequiresApproval" class="sr-only peer" value="1">
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-brand-purple"></div>
                    </label>
                    <span class="text-xs font-bold text-gray-500 uppercase tracking-widest">Perlu Kelulusan Manual</span>
                </div>

                <!-- Operating Hours & Slot Duration -->
                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Waktu Operasi</label>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[9px] font-medium text-gray-400 px-2 mb-1">Waktu Buka</label>
                            <input type="time" name="waktu_buka" id="fasilitiWaktuBuka" value="08:00"
                                   class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        </div>
                        <div>
                            <label class="block text-[9px] font-medium text-gray-400 px-2 mb-1">Waktu Tutup</label>
                            <input type="time" name="waktu_tutup" id="fasilitiWaktuTutup" value="22:00"
                                   class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        </div>
                    </div>
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Durasi Setiap Slot Tempahan</label>
                    <select name="durasi_slot_minit" id="fasilitiDurasiSlot"
                            class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium appearance-none">
                        <option value="60">1 Jam</option>
                        <option value="90">1 Jam 30 Minit</option>
                        <option value="120" selected>2 Jam</option>
                        <option value="180">3 Jam</option>
                        <option value="240">4 Jam</option>
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

<!-- Modal: Rejection Reason -->
<div id="modalReject" class="fixed inset-0 z-[60] hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeRejectModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-md bg-white rounded-[2.5rem] shadow-2xl p-8 transform transition-all">
            <header class="flex justify-between items-center mb-6">
                <h3 class="text-xl font-bold text-gray-800">Tolak Tempahan</h3>
                <button onclick="closeRejectModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form id="rejectTempahanForm" action="<%= contextPath %>/fasiliti/reject" method="post" class="space-y-6">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="idTempahan" id="rejectIdTempahan">
                
                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Alasan Penolakan</label>
                    <textarea name="catatan" required placeholder="Nyatakan sebab tempahan ditolak..." rows="4"
                              class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium"></textarea>
                </div>

                <button type="submit" class="w-full py-5 bg-red-500 text-white rounded-2xl font-bold text-sm shadow-xl shadow-red-100 hover:bg-red-600 mt-4 transition-all">
                    Sahkan Penolakan
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Image Cropper -->
<div id="modalCrop" class="fixed inset-0 z-[70] hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900 bg-opacity-75 transition-opacity backdrop-blur-md" onclick="closeCropModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden transform transition-all">
            <header class="flex justify-between items-center p-8 border-b border-gray-100">
                <div>
                    <h3 class="text-xl font-bold text-gray-800">Laraskan Gambar</h3>
                    <p class="text-xs text-gray-400 mt-1">Sila potong gambar mengikut bingkai yang disediakan untuk paparan penduduk yang kemas.</p>
                </div>
                <button onclick="closeCropModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>
            
            <div class="p-8">
                <div class="max-h-[500px] bg-gray-900 rounded-2xl overflow-hidden flex items-center justify-center">
                    <img id="cropperImage" class="max-w-full block">
                </div>
                
                <div class="flex justify-between items-center mt-8">
                    <div class="flex gap-2">
                        <button onclick="cropper.rotate(-90)" class="w-12 h-12 flex items-center justify-center bg-gray-50 text-gray-600 rounded-xl hover:bg-gray-100 transition shadow-sm">
                            <i class="fas fa-rotate-left"></i>
                        </button>
                        <button onclick="cropper.rotate(90)" class="w-12 h-12 flex items-center justify-center bg-gray-50 text-gray-600 rounded-xl hover:bg-gray-100 transition shadow-sm">
                            <i class="fas fa-rotate-right"></i>
                        </button>
                        <button onclick="cropper.setDragMode('move')" class="w-12 h-12 flex items-center justify-center bg-gray-50 text-gray-600 rounded-xl hover:bg-gray-100 transition shadow-sm" title="Alih">
                            <i class="fas fa-arrows-alt"></i>
                        </button>
                        <button onclick="cropper.setDragMode('crop')" class="w-12 h-12 flex items-center justify-center bg-brand-purple text-white rounded-xl shadow-lg shadow-indigo-100 transition" title="Potong">
                            <i class="fas fa-crop-alt"></i>
                        </button>
                    </div>
                    
                    <div class="flex gap-4">
                        <button onclick="closeCropModal()" class="px-6 py-3 text-gray-400 font-bold text-sm hover:text-gray-600 transition">Batal</button>
                        <button onclick="applyCrop()" class="px-10 py-4 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-xl shadow-indigo-100 hover:bg-opacity-90 transition-all">Sahkan & Gunakan</button>
                    </div>
                </div>
            </div>
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
        document.getElementById('content-history').classList.add('hidden');
        document.getElementById('content-' + tabId).classList.remove('hidden');
    }

    function openRejectModal(id) {
        document.getElementById('rejectIdTempahan').value = id;
        document.getElementById('modalReject').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function closeRejectModal() {
        document.getElementById('modalReject').classList.add('hidden');
        document.body.style.overflow = 'auto';
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
            maxZoom: 19, attribution: 'Â© OpenStreetMap'
        }).addTo(fasilitiMap);
        
        fasilitiMarker = L.marker([lat, lon], { draggable: true }).addTo(fasilitiMap);

        L.Control.geocoder({ defaultMarkGeocode: false, placeholder: 'Cari lokasi/alamat...', errorMessage: 'Lokasi tidak dijumpai.' }).on('markgeocode', function(e) { var latlng = e.geocode.center; fasilitiMarker.setLatLng(latlng); fasilitiMap.setView(latlng, 17); updateF(latlng); }).addTo(fasilitiMap);
        
        function updateF(ll) {
            document.getElementById('fasilitiLat').value = ll.lat.toFixed(8);
            document.getElementById('fasilitiLon').value = ll.lng.toFixed(8);
        }
        
        fasilitiMarker.on('dragend', function(e) { updateF(e.target.getLatLng()); });
        fasilitiMap.on('click', function(e) { fasilitiMarker.setLatLng(e.latlng); updateF(e.latlng); });
        updateF(fasilitiMarker.getLatLng());
        
        setTimeout(function() { fasilitiMap.invalidateSize(); }, 300);
    }

    // Image Cropping & Preview Logic
    let cropper;
    let croppedBlob;
    const cropModal = document.getElementById('modalCrop');
    const cropperImage = document.getElementById('cropperImage');
    const cardPreviewImg = document.getElementById('cardPreviewImg');

    function handleImageSelection(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                cropperImage.src = e.target.result;
                openCropModal();
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function openCropModal() {
        cropModal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        
        if (cropper) {
            cropper.destroy();
        }
        
        setTimeout(() => {
            cropper = new Cropper(cropperImage, {
                aspectRatio: 16 / 9,
                viewMode: 1,
                dragMode: 'crop',
                autoCropArea: 1,
                restore: false,
                guides: true,
                center: true,
                highlight: false,
                cropBoxMovable: true,
                cropBoxResizable: true,
                toggleDragModeOnDblclick: false,
            });
        }, 100);
    }

    function closeCropModal() {
        cropModal.classList.add('hidden');
        document.body.style.overflow = 'auto';
        if (cropper) {
            cropper.destroy();
        }
    }

    function applyCrop() {
        const canvas = cropper.getCroppedCanvas({
            width: 800,
            height: 450, // 16:9 ratio
        });
        
        canvas.toBlob((blob) => {
            croppedBlob = blob;
            cardPreviewImg.src = canvas.toDataURL('image/jpeg');
            closeCropModal();
        }, 'image/jpeg', 0.9);
    }

    // Override Form Submission to include Cropped Image
    document.getElementById('formFasiliti').onsubmit = function(e) {
        e.preventDefault();
        const form = this;
        const isEdit = form.action.includes('edit');
        const title = isEdit ? 'Simpan Perubahan?' : 'Tambah Fasiliti Baru?';
        const text = isEdit 
            ? 'Adakah anda pasti mahu mengemaskini maklumat fasiliti ini?' 
            : 'Adakah anda pasti mahu menambah fasiliti baharu ini?';
        const confirmBtnText = isEdit ? 'Ya, Simpan' : 'Ya, Tambah';

        Swal.fire({
            title: title,
            text: text,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#4F46E5',
            cancelButtonColor: '#6B7280',
            confirmButtonText: confirmBtnText,
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                if (croppedBlob) {
                    const formData = new FormData(form);
                    formData.set('gambar_fasiliti', croppedBlob, 'fasiliti_cropped.jpg');
                    
                    fetch(form.action, {
                        method: 'POST',
                        body: formData
                    }).then(response => {
                        if (response.redirected) {
                            window.location.href = response.url;
                        } else {
                            window.location.reload();
                        }
                    }).catch(err => {
                        console.error('Error submitting form:', err);
                        Swal.fire('Ralat!', 'Gagal menyimpan fasiliti. Sila cuba lagi.', 'error');
                    });
                } else {
                    const origOnsubmit = form.onsubmit;
                    form.onsubmit = null;
                    form.submit();
                    form.onsubmit = origOnsubmit;
                }
            }
        });
        return false;
    };

    function confirmPadamFasiliti(event, url) {
        event.preventDefault();
        Swal.fire({
            title: 'Padam Fasiliti?',
            text: "Adakah anda pasti mahu memadam fasiliti ini? Semua rekod tempahan berkaitan akan dipadamkan secara kekal.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#EF4444',
            cancelButtonColor: '#6B7280',
            confirmButtonText: 'Ya, Padam',
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }

    function confirmApproveBooking(event, form) {
        event.preventDefault();
        Swal.fire({
            title: 'Luluskan Tempahan?',
            text: "Adakah anda pasti mahu meluluskan tempahan fasiliti ini?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#10B981',
            cancelButtonColor: '#6B7280',
            confirmButtonText: 'Ya, Luluskan',
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const rejectForm = document.getElementById('rejectTempahanForm');
        if (rejectForm) {
            rejectForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const form = this;
                Swal.fire({
                    title: 'Tolak Tempahan?',
                    text: "Adakah anda pasti mahu menolak tempahan fasiliti ini?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#EF4444',
                    cancelButtonColor: '#6B7280',
                    confirmButtonText: 'Ya, Tolak',
                    cancelButtonText: 'Batal',
                    customClass: {
                        popup: 'rounded-[2rem]',
                        confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                        cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });
        }
    });

    function openAddModal() {
        document.getElementById('modalTitle').innerText = "Tambah Fasiliti Baru";
        document.getElementById('formFasiliti').action = "<%= contextPath %>/fasiliti/tambah";
        document.getElementById('fasilitiId').value = "";
        document.getElementById('fasilitiNama').value = "";
        document.getElementById('fasilitiLokasi').value = "";
        document.getElementById('fasilitiStatus').value = "<%= StatusConstant.FASILITI_AKTIF %>";
        document.getElementById('cardPreviewNama').innerText = "Nama Fasiliti";
        document.getElementById('cardPreviewLokasi').innerText = "Lokasi";
        document.getElementById('cardPreviewImg').src = "${pageContext.request.contextPath}/assets/img/placeholder.png";
        document.getElementById('fasilitiWaktuBuka').value = "08:00";
        document.getElementById('fasilitiWaktuTutup').value = "22:00";
        document.getElementById('fasilitiDurasiSlot').value = "120";
        croppedBlob = null;
        openModal('modalFasiliti');
        setTimeout(function(){ initFasilitiMap(); }, 100);
    }

    function openEditModal(id, nama, lokasi, status, lat, lon, requiresApproval, currentImage, waktuBuka, waktuTutup, durasiSlot) {
        document.getElementById('modalTitle').innerText = "Kemaskini Fasiliti";
        document.getElementById('formFasiliti').action = "<%= contextPath %>/fasiliti/edit";
        document.getElementById('fasilitiId').value = id;
        document.getElementById('fasilitiNama').value = nama;
        document.getElementById('fasilitiLokasi').value = lokasi;
        document.getElementById('fasilitiStatus').value = status;
        document.getElementById('fasilitiRequiresApproval').checked = requiresApproval;
        document.getElementById('fasilitiWaktuBuka').value = waktuBuka || '08:00';
        document.getElementById('fasilitiWaktuTutup').value = waktuTutup || '22:00';
        document.getElementById('fasilitiDurasiSlot').value = durasiSlot || '120';
        
        document.getElementById('cardPreviewNama').innerText = nama;
        document.getElementById('cardPreviewLokasi').innerText = lokasi;
        if (currentImage) {
            document.getElementById('cardPreviewImg').src = "${pageContext.request.contextPath}/file/fasiliti/" + currentImage;
        } else {
            document.getElementById('cardPreviewImg').src = "${pageContext.request.contextPath}/assets/img/placeholder.png";
        }
        
        croppedBlob = null;
        openModal('modalFasiliti');
        setTimeout(function(){ initFasilitiMap(lat, lon); }, 100);
    }

    // Live update preview text
    document.getElementById('fasilitiNama').addEventListener('input', function() {
        document.getElementById('cardPreviewNama').innerText = this.value || "Nama Fasiliti";
    });
    document.getElementById('fasilitiLokasi').addEventListener('input', function() {
        document.getElementById('cardPreviewLokasi').innerText = this.value || "Lokasi";
    });

    // closeModal centralized in footer.jsp

</script>

<%@ include file="/views/common/footer.jsp" %>

