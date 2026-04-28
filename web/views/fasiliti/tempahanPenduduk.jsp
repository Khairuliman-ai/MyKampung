<%@ page import="java.util.List" %>
<%@ page import="model.Fasiliti" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="model.ActivityLog" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.ZoneId" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<Fasiliti> senaraiFasiliti = (List<Fasiliti>) request.getAttribute("senaraiFasiliti");
    List<TempahanFasiliti> senaraiTempahan = (List<TempahanFasiliti>) request.getAttribute("senaraiTempahan");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9] min-w-0">
    <!-- Header -->
    <header class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Fasiliti Kampung</h2>
            <p class="text-gray-500 text-sm">Tempah kemudahan kampung secara dalam talian dengan mudah.</p>
        </div>
    </header>

    <!-- Alerts -->
    <% if (request.getParameter("success") != null) { %>
        <div class="bg-green-50 border border-green-100 text-green-700 px-6 py-4 rounded-3xl mb-8 flex items-center gap-4 animate-fade-in shadow-sm">
            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center text-green-600">
                <i class="fas fa-check-circle"></i>
            </div>
            <p class="font-bold text-sm">Berjaya! Permohonan tempahan anda telah dihantar untuk semakan.</p>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="bg-red-50 border border-red-100 text-red-700 px-6 py-4 rounded-3xl mb-8 flex items-center gap-4 animate-fade-in shadow-sm">
            <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center text-red-600">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <p class="font-bold text-sm">Ralat! Sila pastikan masa tempahan tidak bertindih dengan tempahan lain.</p>
        </div>
    <% } %>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5 group hover:shadow-md transition-all duration-300">
            <div class="w-14 h-14 bg-indigo-50 text-brand-purple rounded-2xl flex items-center justify-center text-xl group-hover:scale-110 transition-transform">
                <i class="fas fa-building-circle-check"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Fasiliti Aktif</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= (senaraiFasiliti != null) ? senaraiFasiliti.size() : 0 %></h3>
            </div>
        </div>
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5 group hover:shadow-md transition-all duration-300">
            <div class="w-14 h-14 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center text-xl group-hover:scale-110 transition-transform">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Tempahan Saya</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= (senaraiTempahan != null) ? senaraiTempahan.size() : 0 %></h3>
            </div>
        </div>
    </div>

    <!-- Main Content Tabs -->
    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('senarai')" id="tab-senarai" class="pb-4 px-2 text-sm font-bold border-b-2 border-brand-purple text-brand-purple transition-all">Senarai Fasiliti</button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" class="pb-4 px-2 text-sm font-bold border-b-2 border-transparent text-gray-400 hover:text-gray-600 transition-all">Sejarah Tempahan</button>
        </nav>
    </div>

    <!-- Tab 1: Senarai Fasiliti -->
    <div id="content-senarai" class="block">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if (senaraiFasiliti != null && !senaraiFasiliti.isEmpty()) { 
                for (Fasiliti f : senaraiFasiliti) { %>
                <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group">
                    <!-- Facility Image -->
                    <% if (f.getGambar_fasiliti() != null) { %>
                        <div class="h-48 bg-gray-100 overflow-hidden relative">
                            <img src="${pageContext.request.contextPath}/file/fasiliti/<%= f.getGambar_fasiliti() %>"
                                 class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                            <div class="absolute top-4 right-4">
                                <% if (f.isOccupied()) { %>
                                    <span class="bg-orange-500 text-white text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider shadow-lg animate-pulse">
                                        <i class="fas fa-user-clock mr-1"></i> Penuh
                                    </span>
                                <% } else { %>
                                    <span class="bg-green-500 text-white text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider shadow-lg">
                                        Tersedia
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="h-48 bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center relative">
                            <i class="fas fa-building text-white text-4xl opacity-30"></i>
                            <div class="absolute top-4 right-4">
                                <% if (f.isOccupied()) { %>
                                    <span class="bg-orange-500 text-white text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider shadow-lg animate-pulse">
                                        <i class="fas fa-user-clock mr-1"></i> Penuh
                                    </span>
                                <% } else { %>
                                    <span class="bg-green-500 text-white text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider shadow-lg">
                                        Tersedia
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    <% } %>

                    <div class="p-6">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="text-lg font-bold text-gray-800"><%= f.getNama_fasiliti() %></h3>
                            <% if (f.isRequiresApproval()) { %>
                                <span class="bg-indigo-50 text-brand-purple text-[9px] font-bold px-2 py-0.5 rounded border border-indigo-100" title="Memerlukan kelulusan AJK">
                                    <i class="fas fa-shield-halved"></i>
                                </span>
                            <% } %>
                        </div>
                        
                        <div class="flex items-center gap-2 text-gray-400 text-xs mb-6">
                            <i class="fas fa-location-dot"></i>
                            <span><%= f.getLokasi() %></span>
                        </div>

                        <div class="flex flex-col gap-3">
                            <button onclick="openBookingModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', <%= f.isRequiresApproval() %>)" 
                                    <%= f.isOccupied() ? "disabled title='Fasiliti sedang digunakan'" : "" %>
                                    class="w-full py-3.5 <%= f.isOccupied() ? "bg-gray-100 text-gray-400 cursor-not-allowed" : "bg-brand-purple text-white shadow-lg shadow-indigo-100 hover:bg-opacity-90" %> rounded-2xl font-bold text-sm transition-all">
                                <%= f.isOccupied() ? "Tidak Tersedia" : "Tempah Sekarang" %>
                            </button>
                            <button onclick="openDetailsModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', '<%= f.getLokasi() %>', '<%= f.getLatitude() %>', '<%= f.getLongitude() %>', <%= f.isOccupied() %>)"
                                    class="w-full py-2.5 bg-white text-gray-500 border border-gray-100 rounded-2xl font-bold text-[10px] hover:bg-gray-50 transition-all flex items-center justify-center gap-2">
                                <i class="fas fa-info-circle"></i> Lihat Butiran
                            </button>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="col-span-full py-20 text-center bg-white rounded-[2.5rem] border border-dashed border-gray-300">
                    <i class="fas fa-building-circle-exclamation text-4xl text-gray-200 mb-4"></i>
                    <p class="text-gray-400 font-medium">Tiada fasiliti tersedia buat masa ini.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Tab 2: Sejarah Tempahan -->
    <div id="content-sejarah" class="hidden">
        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Fasiliti</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tarikh & Masa</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                        <% 
                            LocalDate today = LocalDate.now(ZoneId.of("Asia/Kuala_Lumpur"));
                            LocalTime nowTime = LocalTime.now(ZoneId.of("Asia/Kuala_Lumpur"));
                            
                            if (senaraiTempahan != null && !senaraiTempahan.isEmpty()) { 
                            for (TempahanFasiliti t : senaraiTempahan) { 
                                LocalDate bookingDate = t.getTarikh_tempah().toLocalDate();
                                LocalTime endTime = t.getMasa_tamat().toLocalTime();
                                boolean isFuture = bookingDate.isAfter(today) || (bookingDate.isEqual(today) && endTime.isAfter(nowTime));
                        %>
                            <tr class="hover:bg-gray-50/50 transition-colors">
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-4">
                                        <div class="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center text-brand-purple">
                                            <i class="fas fa-building text-sm"></i>
                                        </div>
                                        <div>
                                            <p class="text-sm font-bold text-gray-800"><%= t.getNama_fasiliti() %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <p class="text-sm font-bold text-gray-700 mb-1"><%= t.getTarikh_tempah() %></p>
                                    <p class="text-xs text-gray-400 font-medium"><%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %></p>
                                </td>
                                <td class="px-8 py-6">
                                    <% if ("LULUS".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-check-circle text-[8px]"></i> LULUS
                                        </span>
                                    <% } else if ("TOLAK".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-times-circle text-[8px]"></i> TOLAK
                                        </span>
                                    <% } else if ("DIBATAL".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 text-gray-500 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-ban text-[8px]"></i> BATAL
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-clock text-[8px]"></i> MENUNGGU
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-8 py-6">
                                    <% if (isFuture && ("MENUNGGU".equals(t.getStatus()) || "LULUS".equals(t.getStatus()))) { %>
                                        <a href="<%= contextPath %>/fasiliti/batal?id=<%= t.getId_tempahan() %>" 
                                           onclick="return confirm('Adakah anda pasti mahu membatalkan tempahan ini?')"
                                           class="text-xs font-bold text-red-400 hover:text-red-600 transition-colors">Batal Tempahan</a>
                                    <% } else { %>
                                        <span class="text-xs text-gray-300 italic">-</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="4" class="px-8 py-10 text-center text-gray-400 text-sm italic">Tiada sejarah tempahan ditemui.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
    
    <style>
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #E5E7EB; border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6C5DD3; }
    </style>

<!-- Right Aside Bar (Resident) -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar flex-shrink-0">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Info Penting</h3>
    </div>

    <div class="space-y-8">
        <!-- Rule 1 -->
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-purple-50 text-brand-purple flex-shrink-0 flex items-center justify-center font-bold text-lg">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Had Tempahan</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Setiap penduduk hanya dibenarkan mempunyai maksimum <strong>2 tempahan aktif</strong> pada satu-satu masa.</p>
            </div>
        </div>

        <!-- Rule 2 -->
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-blue-50 text-blue-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">
                <i class="fas fa-user-shield"></i>
            </div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Kelulusan Manual</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Fasiliti seperti <strong>Dewan</strong> memerlukan kelulusan AJK. Sila semak status secara berkala.</p>
            </div>
        </div>
        
        <!-- Rule 3 -->
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-orange-50 text-orange-600 flex-shrink-0 flex items-center justify-center font-bold text-lg">
                <i class="fas fa-clock"></i>
            </div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Slot Masa</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Sila pastikan anda hadir mengikut slot yang ditempah. Slot yang telah tamat tidak boleh diubah.</p>
            </div>
        </div>
    </div>

    <!-- Contact Box -->
    <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
        <h4 class="font-bold text-gray-700 mb-2 text-sm">Masalah Tempahan?</h4>
        <p class="text-xs text-gray-500 mb-4">Hubungi Biro Sukan & Riadah jika anda mempunyai masalah teknikal atau ingin membatalkan tempahan saat akhir.</p>
        <button class="w-full bg-white border border-gray-200 text-gray-700 py-3 rounded-xl text-xs font-bold hover:bg-gray-100 transition shadow-sm">Hubungi Biro Sukan</button>
    </div>
</aside>

<!-- Modal Tempahan -->
<div id="modalTempah" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[2.5rem] shadow-2xl p-8 transform transition-all">
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h3 class="text-xl font-bold text-gray-800">Borang Tempahan</h3>
                    <p class="text-xs text-gray-400 mt-1" id="modalFasilitiName"></p>
                </div>
                <button onclick="closeModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form action="<%= contextPath %>/fasiliti/tempah" method="post" class="space-y-6" id="formTempah">
                <input type="hidden" name="id_fasiliti" id="modalIdFasiliti">
                
                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Tarikh Tempahan</label>
                    <input type="date" name="tarikh_tempah" id="tarikh_tempah" required onchange="loadSlots()"
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Tempoh Tempahan</label>
                    <select name="tempoh_tempahan" id="tempoh_tempahan" onchange="toggleDuration()"
                            class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        <option value="1">1 Jam</option>
                        <option value="2">2 Jam</option>
                        <option value="specific">Masa Spesifik</option>
                    </select>
                </div>

                <div class="space-y-2" id="slot_container">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Pilih Slot Masa</label>
                    <select id="slot_select" onchange="applySlot()"
                            class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        <option value="">Sila pilih tarikh & tempoh dahulu...</option>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4 hidden" id="manual_time_container">
                    <div class="space-y-2">
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Waktu Mula</label>
                        <input type="time" name="masa_mula" id="masa_mula" 
                               class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                    </div>
                    <div class="space-y-2">
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Waktu Tamat</label>
                        <input type="time" name="masa_tamat" id="masa_tamat" 
                               class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                    </div>
                </div>

                <!-- Hidden inputs to hold the actual values for form submission when using slots -->
                <input type="hidden" name="masa_mula_hidden" id="masa_mula_hidden">
                <input type="hidden" name="masa_tamat_hidden" id="masa_tamat_hidden">

                <div class="space-y-2 hidden" id="catatan_container">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Sebab / Catatan</label>
                    <textarea name="catatan_pemohon" id="catatan_pemohon" rows="3"
                              class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium"
                              placeholder="Nyatakan sebab tempahan (Wajib untuk Seharian Penuh / Separuh Hari)..."></textarea>
                </div>

                <button type="submit" class="w-full py-5 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-xl shadow-indigo-100 hover:bg-opacity-90 mt-8 transition-all">
                    Sahkan Tempahan
                </button>
            </form>
        </div>
    </div>
</div>

<!-- Modal Butiran Fasiliti -->
<div id="modalButiran" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeDetailsModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-[2.5rem] bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-lg p-8">
            <header class="flex justify-between items-start mb-6">
                <div>
                    <h3 class="text-xl font-bold text-gray-800" id="detNama">Nama Fasiliti</h3>
                    <p class="text-xs text-gray-400 mt-1 flex items-center gap-1">
                        <i class="fas fa-location-dot"></i> <span id="detLokasi">Lokasi</span>
                    </p>
                </div>
                <button onclick="closeDetailsModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <div class="space-y-6">
                <div class="bg-gray-50 rounded-3xl p-6 border border-gray-100">
                    <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3">Status Semasa</h4>
                    <div id="detStatusBadge"></div>
                </div>

                <div class="space-y-3">
                    <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Lokasi Peta</h4>
                    <div id="mapDetails" style="height: 250px; border-radius: 1.5rem; z-index: 0;" class="border-2 border-dashed border-gray-100 bg-gray-50"></div>
                </div>

                <div class="flex gap-4">
                    <button id="detBtnNav" class="flex-1 py-4 bg-green-500 text-white rounded-2xl font-bold text-sm shadow-lg shadow-green-100 hover:bg-green-600 transition-all flex items-center justify-center gap-2">
                        <i class="fas fa-route"></i> Navigasi Google Maps
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleDuration() {
        const tempoh = document.getElementById('tempoh_tempahan').value;
        const slotContainer = document.getElementById('slot_container');
        const catatanContainer = document.getElementById('catatan_container');
        
        // Hidden inputs
        const mulaHidden = document.getElementById('masa_mula_hidden');
        const tamatHidden = document.getElementById('masa_tamat_hidden');
        const catatanInput = document.getElementById('catatan_pemohon');

        // Reset
        mulaHidden.value = "";
        tamatHidden.value = "";
        catatanInput.value = "";

        if (tempoh === '2') {
            // Show Slot Picker, Hide Sebab
            slotContainer.classList.remove('hidden');
            catatanContainer.classList.add('hidden');
            catatanInput.required = false;
            loadSlots();
        } else if (tempoh === 'HalfDay' || tempoh === 'FullDay') {
            // Hide Slot Picker, Show Sebab
            slotContainer.classList.add('hidden');
            catatanContainer.classList.remove('hidden');
            catatanInput.required = true;
            loadSlots(); // Still call to verify availability and set hidden values
        }
    }

    function loadSlots() {
        const idFasiliti = document.getElementById('modalIdFasiliti').value;
        const tempoh = document.getElementById('tempoh_tempahan').value;
        const tarikh = document.getElementById('tarikh_tempah').value;
        const slotSelect = document.getElementById('slot_select');

        console.log('DEBUG loadSlots:', {idFasiliti, tempoh, tarikh});

        if (!idFasiliti || !tarikh) {
            console.log('Aborting loadSlots: missing id or date');
            return;
        }

        const url = '<%= contextPath %>/fasiliti/getSlots?idFasiliti=' + encodeURIComponent(idFasiliti) + '&durasi=' + encodeURIComponent(tempoh) + '&tarikh=' + encodeURIComponent(tarikh);
        console.log('Fetching slots from:', url);

        fetch(url)
            .then(async response => {
                if (!response.ok) {
                    const errorText = await response.text();
                    console.error('Server error response:', errorText);
                    try {
                        const errorJson = JSON.parse(errorText);
                        throw new Error(errorJson.error || ('HTTP ' + response.status + ': ' + response.statusText));
                    } catch(e) {
                        throw new Error(errorText || ('HTTP ' + response.status + ': ' + response.statusText));
                    }
                }
                return response.json();
            })
            .then(data => {
                console.log('Slots received:', data);
                if (tempoh === '2') {
                    slotSelect.innerHTML = '<option value="">Pilih Slot Masa</option>';
                    if (data.length === 0) {
                        slotSelect.innerHTML = '<option value="">Tiada slot tersedia untuk tarikh ini</option>';
                    } else {
                        data.forEach(slot => {
                            const option = document.createElement('option');
                            option.value = JSON.stringify({mula: slot.mula, tamat: slot.tamat});
                            
                            let text = slot.mula.substring(0,5) + ' - ' + slot.tamat.substring(0,5);
                            if (slot.isPast) {
                                option.disabled = true;
                                text += ' (Tamat)';
                                option.style.color = '#9CA3AF'; // Gray text
                            }
                            
                            option.textContent = text;
                            slotSelect.appendChild(option);
                        });
                    }
                } else if (tempoh === 'HalfDay' || tempoh === 'FullDay') {
                    if (data.length > 0) {
                        // Slot available, set hidden fields automatically
                        document.getElementById('masa_mula_hidden').value = data[0].mula;
                        document.getElementById('masa_tamat_hidden').value = data[0].tamat;
                    } else {
                        alert("Fasiliti ini sudah ditempah untuk tempoh tersebut pada tarikh yang dipilih.");
                        // Reset selection
                        document.getElementById('tarikh_tempah').value = "";
                    }
                }
            })
            .catch(err => {
                console.error('Fetch error:', err);
                if (tempoh === '2') {
                    slotSelect.innerHTML = '<option value="">Ralat: ' + err.message + '</option>';
                }
            });
    }

    function applySlot() {
        const slotVal = document.getElementById('slot_select').value;
        if (!slotVal) return;
        
        const slot = JSON.parse(slotVal);
        document.getElementById('masa_mula_hidden').value = slot.mula;
        document.getElementById('masa_tamat_hidden').value = slot.tamat;
    }

    // Update form submission to use hidden inputs if slots are used
    document.getElementById('formTempah').onsubmit = function(e) {
        const tempoh = document.getElementById('tempoh_tempahan').value;
        if (tempoh !== 'specific') {
            const mula = document.getElementById('masa_mula_hidden').value;
            const tamat = document.getElementById('masa_tamat_hidden').value;
            
            if (!mula || !tamat) {
                alert("Sila pilih slot masa!");
                e.preventDefault();
                return false;
            }
            
            // Assign hidden values to the actual named inputs before submit
            document.getElementById('masa_mula').value = mula.substring(0,5);
            document.getElementById('masa_tamat').value = tamat.substring(0,5);
        }
    };

    function switchTab(tabId) {
        // Update Tabs UI
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-brand-purple', 'text-brand-purple');
            btn.classList.add('border-transparent', 'text-gray-400');
        });
        document.getElementById('tab-' + tabId).classList.add('border-brand-purple', 'text-brand-purple');
        document.getElementById('tab-' + tabId).classList.remove('border-transparent', 'text-gray-400');

        // Update Content
        document.getElementById('content-senarai').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        document.getElementById('content-' + tabId).classList.remove('hidden');
    }

    function openBookingModal(id, name, requiresApproval) {
        console.log('Opening modal for id:', id);
        document.getElementById('modalIdFasiliti').value = id;
        document.getElementById('modalFasilitiName').innerText = "Tempahan untuk: " + name;
        
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('tarikh_tempah').min = today;
        
        const tempohSelect = document.getElementById('tempoh_tempahan');
        tempohSelect.innerHTML = '';
        
        if (requiresApproval) {
            // Options for facilities that need approval (e.g. Hall)
            const optHalf = document.createElement('option');
            optHalf.value = 'HalfDay';
            optHalf.textContent = 'Separuh Hari (08:00 - 14:00)';
            
            const optFull = document.createElement('option');
            optFull.value = 'FullDay';
            optFull.textContent = 'Seharian Penuh (08:00 - 22:00)';
            
            tempohSelect.appendChild(optHalf);
            tempohSelect.appendChild(optFull);
        } else {
            // Options for auto-approval facilities (e.g. Futsal)
            const opt2 = document.createElement('option');
            opt2.value = '2';
            opt2.textContent = 'Slot 2 Jam (8 pagi - 12 malam)';
            
            const optFull = document.createElement('option');
            optFull.value = 'FullDay';
            optFull.textContent = 'Seharian Penuh (08:00 - 22:00)';
            
            tempohSelect.appendChild(opt2);
            tempohSelect.appendChild(optFull);
        }

        document.getElementById('modalTempah').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        
        // Trigger toggleDuration and loadSlots to refresh UI
        toggleDuration();
    }

    var detailsMap, detailsMarker;
    function openDetailsModal(id, name, lokasi, lat, lon, occupied) {
        document.getElementById('detNama').innerText = name;
        document.getElementById('detLokasi').innerText = lokasi;
        
        const badgeCont = document.getElementById('detStatusBadge');
        if (occupied) {
            badgeCont.innerHTML = `
                <div class="flex items-center gap-3 text-orange-600">
                    <div class="w-10 h-10 bg-orange-100 rounded-xl flex items-center justify-center text-lg">
                        <i class="fas fa-user-clock"></i>
                    </div>
                    <div>
                        <p class="font-bold text-sm">Sedang Digunakan</p>
                        <p class="text-[10px] text-orange-400">Fasiliti ini sedang mempunyai tempahan aktif.</p>
                    </div>
                </div>
            `;
        } else {
            badgeCont.innerHTML = `
                <div class="flex items-center gap-3 text-green-600">
                    <div class="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center text-lg">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div>
                        <p class="font-bold text-sm">Tersedia</p>
                        <p class="text-[10px] text-green-400">Anda boleh menempah fasiliti ini sekarang.</p>
                    </div>
                </div>
            `;
        }

        const navBtn = document.getElementById('detBtnNav');
        if (lat && lat !== 'null' && lon && lon !== 'null') {
            navBtn.onclick = () => window.open(`https://www.google.com/maps/dir/?api=1&destination=${lat},${lon}`, '_blank');
            navBtn.classList.remove('hidden');
        } else {
            navBtn.classList.add('hidden');
        }

        document.getElementById('modalButiran').classList.remove('hidden');
        document.body.style.overflow = 'hidden';

        // Init Map
        setTimeout(() => {
            if (detailsMap) detailsMap.remove();
            if (lat && lat !== 'null' && lon && lon !== 'null') {
                detailsMap = L.map('mapDetails').setView([lat, lon], 16);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19, attribution: '© OpenStreetMap'
                }).addTo(detailsMap);
                detailsMarker = L.marker([lat, lon]).addTo(detailsMap);
            } else {
                document.getElementById('mapDetails').innerHTML = `
                    <div class="flex flex-col items-center justify-center h-full text-gray-400 gap-2">
                        <i class="fas fa-map-marked-alt text-3xl opacity-20"></i>
                        <p class="text-[10px] font-bold uppercase tracking-widest">Tiada Koordinat GPS</p>
                    </div>
                `;
            }
        }, 300);
    }

    function closeDetailsModal() {
        document.getElementById('modalButiran').classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    function closeModal() {
        document.getElementById('modalTempah').classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    // Alert Handling
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const error = urlParams.get('error');

        if (success === 'booked') {
            Swal.fire('Berjaya!', 'Tempahan anda telah direkodkan.', 'success');
        } else if (success === 'pending_approval') {
            Swal.fire('Permohonan Dihantar!', 'Fasiliti ini memerlukan kelulusan. Sila semak status tempahan anda secara berkala.', 'info');
        } else if (success === 'cancelled') {
            Swal.fire('Dibatalkan!', 'Tempahan telah dibatalkan.', 'success');
        }

        if (error === 'blackout') {
            Swal.fire('Gagal!', 'Tarikh ini telah disekat untuk penyelenggaraan atau kegunaan khas.', 'error');
        } else if (error === 'quota') {
            Swal.fire('Had Maksimum!', 'Anda telah mencapai had maksimum 2 tempahan aktif untuk fasiliti ini.', 'warning');
        } else if (error === 'conflict') {
            Swal.fire('Konflik Masa!', 'Masa yang dipilih telah ditempah oleh orang lain.', 'error');
        } else if (error === 'time') {
            Swal.fire('Ralat Masa!', 'Masa tamat mestilah selepas masa mula.', 'error');
        } else if (error === 'db') {
            Swal.fire('Ralat!', 'Gagal memproses tempahan. Sila cuba lagi.', 'error');
        }
    });
</script>

<%@ include file="/views/common/footer.jsp" %>
