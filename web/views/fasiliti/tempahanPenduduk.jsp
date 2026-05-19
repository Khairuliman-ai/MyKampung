<%@ page import="java.util.List" %>
<%@ page import="model.Fasiliti" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="model.ActivityLog" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="util.StatusConstant" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<Fasiliti> senaraiFasiliti = (List<Fasiliti>) request.getAttribute("senaraiFasiliti");
    List<TempahanFasiliti> senaraiTempahan = (List<TempahanFasiliti>) request.getAttribute("senaraiTempahan");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9] min-w-0">
    <!-- Header -->
    <header class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-10">
        <div>
            <h2 class="text-3xl font-black text-gray-800 tracking-tight">Fasiliti Kampung</h2>
            <p class="text-gray-400 text-sm font-medium mt-1">Tempah kemudahan kampung secara dalam talian dengan mudah dan pantas.</p>
        </div>
        <div class="flex items-center gap-3">
            <div class="px-4 py-2 bg-white rounded-2xl border border-gray-100 shadow-sm flex items-center gap-2">
                <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                <span class="text-[10px] font-black text-gray-500 uppercase tracking-widest">Sistem Aktif</span>
            </div>
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
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-10">
        <div class="bg-white p-7 rounded-[2.5rem] shadow-sm border border-gray-100 flex items-center gap-6 group hover:shadow-xl hover:shadow-indigo-50/50 transition-all duration-500 relative overflow-hidden">
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-indigo-50/50 rounded-full blur-2xl group-hover:bg-indigo-100/50 transition-colors"></div>
            <div class="w-16 h-16 bg-gradient-to-br from-indigo-50 to-indigo-100 text-brand-purple rounded-3xl flex items-center justify-center text-2xl group-hover:scale-110 group-hover:rotate-6 transition-all duration-500 shadow-inner">
                <i class="fas fa-building-circle-check"></i>
            </div>
            <div>
                <p class="text-[10px] font-extrabold text-gray-400 uppercase tracking-[0.2em] mb-1.5">Fasiliti Aktif</p>
                <h3 class="text-3xl font-black text-gray-800 tracking-tight"><%= (senaraiFasiliti != null) ? senaraiFasiliti.size() : 0 %></h3>
            </div>
        </div>
        
        <div class="bg-white p-7 rounded-[2.5rem] shadow-sm border border-gray-100 flex items-center gap-6 group hover:shadow-xl hover:shadow-orange-50/50 transition-all duration-500 relative overflow-hidden">
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-orange-50/50 rounded-full blur-2xl group-hover:bg-orange-100/50 transition-colors"></div>
            <div class="w-16 h-16 bg-gradient-to-br from-orange-50 to-orange-100 text-orange-500 rounded-3xl flex items-center justify-center text-2xl group-hover:scale-110 group-hover:rotate-6 transition-all duration-500 shadow-inner">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <p class="text-[10px] font-extrabold text-gray-400 uppercase tracking-[0.2em] mb-1.5">Tempahan Saya</p>
                <h3 class="text-3xl font-black text-gray-800 tracking-tight"><%= (senaraiTempahan != null) ? senaraiTempahan.size() : 0 %></h3>
            </div>
        </div>

        <div class="bg-gradient-to-br from-brand-purple to-brand-secondary p-7 rounded-[2.5rem] shadow-lg shadow-purple-100 flex items-center gap-6 group hover:shadow-md transition-all duration-500 relative overflow-hidden">
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-white/10 rounded-full blur-2xl group-hover:bg-white/20 transition-colors"></div>
            <div class="w-16 h-16 bg-white/20 backdrop-blur-md text-white rounded-3xl flex items-center justify-center text-2xl group-hover:scale-110 group-hover:-rotate-6 transition-all duration-500">
                <i class="fas fa-clock-rotate-left"></i>
            </div>
            <div class="relative z-10">
                <p class="text-[10px] font-extrabold text-white/70 uppercase tracking-[0.2em] mb-1.5">Status Terkini</p>
                <h3 class="text-lg font-bold text-white leading-tight">Semak Rekod<br>Masa Nyata</h3>
            </div>
        </div>
    </div>

    <!-- Search Bar -->
    <div class="flex gap-4 mb-10">
        <div class="flex gap-3 flex-1 relative group">
            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-brand-purple group-focus-within:scale-110 transition-all duration-300">
                <i class="fas fa-search"></i>
            </div>
            <input type="text" id="searchInput" oninput="filterData()" placeholder="Cari fasiliti, lokasi, atau sejarah tempahan..." 
                class="flex-1 pl-14 pr-8 py-5 rounded-[2rem] bg-white border border-gray-100 focus:ring-4 focus:ring-purple-50 focus:border-brand-purple text-sm font-semibold shadow-sm transition-all outline-none placeholder:text-gray-300">
        </div>
    </div>

    <!-- Main Content Tabs -->
    <div class="mb-10 flex justify-center md:justify-start">
        <nav class="flex gap-2 p-1.5 bg-gray-100/50 backdrop-blur-sm rounded-[2rem] border border-gray-100">
            <button onclick="switchTab('senarai')" id="tab-senarai" 
                    class="py-3 px-8 text-[11px] font-black uppercase tracking-widest rounded-[1.5rem] transition-all duration-500 bg-white text-brand-purple shadow-sm">
                Senarai Fasiliti
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-3 px-8 text-[11px] font-black uppercase tracking-widest rounded-[1.5rem] transition-all duration-500 text-gray-400 hover:text-gray-600">
                Sejarah Tempahan
            </button>
        </nav>
    </div>

    <!-- Tab 1: Senarai Fasiliti -->
    <div id="content-senarai" class="block">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if (senaraiFasiliti != null && !senaraiFasiliti.isEmpty()) { 
                for (Fasiliti f : senaraiFasiliti) { %>
                <div class="facility-card bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden hover:shadow-2xl hover:-translate-y-2 transition-all duration-500 group animate-fade-in-up">
                    <!-- Facility Image -->
                    <div class="h-56 overflow-hidden relative">
                        <% if (f.getGambar_fasiliti() != null) { %>
                            <img src="${pageContext.request.contextPath}/file/fasiliti/<%= f.getGambar_fasiliti() %>"
                                 class="w-full h-full object-cover group-hover:scale-110 transition duration-700">
                        <% } else { %>
                            <div class="w-full h-full bg-gradient-to-br from-indigo-100 to-purple-100 flex items-center justify-center">
                                <i class="fas fa-building text-brand-purple/20 text-5xl"></i>
                            </div>
                        <% } %>
                        
                        <!-- Overlay Badges -->
                        <div class="absolute top-5 left-5 right-5 flex justify-between items-center">
                            <% if (f.isRequiresApproval()) { %>
                                <div class="bg-white/80 backdrop-blur-md px-3 py-1.5 rounded-2xl border border-white/50 shadow-sm flex items-center gap-2">
                                    <div class="w-2 h-2 bg-indigo-500 rounded-full animate-pulse"></div>
                                    <span class="text-[9px] font-black text-indigo-700 uppercase tracking-wider">AJK Approval</span>
                                </div>
                            <% } else { %>
                                <div></div>
                            <% } %>

                            <% if (f.isOccupied()) { %>
                                <span class="bg-red-500/90 backdrop-blur-sm text-white text-[9px] font-black px-4 py-1.5 rounded-2xl uppercase tracking-[0.1em] shadow-lg flex items-center gap-2">
                                    <i class="fas fa-lock text-[8px]"></i> Penuh
                                </span>
                            <% } else { %>
                                <span class="bg-emerald-500/90 backdrop-blur-sm text-white text-[9px] font-black px-4 py-1.5 rounded-2xl uppercase tracking-[0.1em] shadow-lg flex items-center gap-2">
                                    <i class="fas fa-check text-[8px]"></i> Tersedia
                                </span>
                            <% } %>
                        </div>
                    </div>

                    <div class="p-8">
                        <div class="mb-5">
                            <h3 class="facility-name text-xl font-black text-gray-800 mb-2 leading-tight group-hover:text-brand-purple transition-colors"><%= f.getNama_fasiliti() %></h3>
                            <div class="flex items-center gap-2.5 text-gray-400">
                                <div class="w-7 h-7 rounded-full bg-gray-50 flex items-center justify-center text-[10px]">
                                    <i class="fas fa-location-dot"></i>
                                </div>
                                <span class="facility-location text-xs font-semibold tracking-tight"><%= f.getLokasi() %></span>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-3 mt-6">
                            <button onclick="openBookingModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', <%= f.isRequiresApproval() %>)" 
                                    <%= f.isOccupied() ? "disabled" : "" %>
                                    class="col-span-2 py-4 <%= f.isOccupied() ? "bg-gray-100 text-gray-400 cursor-not-allowed" : "brand-gradient text-white shadow-lg shadow-indigo-100 hover:shadow-indigo-200 hover:scale-[1.02]" %> rounded-2xl font-black text-[11px] uppercase tracking-widest transition-all duration-300">
                                <%= f.isOccupied() ? "Tidak Tersedia" : "Tempah Sekarang" %>
                            </button>
                            <button onclick="openDetailsModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>', '<%= f.getLokasi() %>', '<%= f.getLatitude() %>', '<%= f.getLongitude() %>', <%= f.isOccupied() %>)"
                                    class="col-span-2 py-3.5 bg-gray-50 text-gray-500 border border-gray-100 rounded-2xl font-bold text-[10px] hover:bg-gray-100 transition-all flex items-center justify-center gap-2 uppercase tracking-wider">
                                <i class="fas fa-circle-info"></i> Butiran Lanjut
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>
                <!-- Empty state for search results -->
                <div id="senarai-empty" class="hidden col-span-full py-20 text-center bg-white rounded-[2.5rem] border border-dashed border-gray-300">
                    <i class="fas fa-search text-4xl text-gray-200 mb-4"></i>
                    <p class="text-gray-400 font-medium">Tiada fasiliti sepadan dengan carian anda.</p>
                </div>
            <% } else { %>
                <div class="col-span-full py-20 text-center bg-white rounded-[2.5rem] border border-dashed border-gray-300">
                    <i class="fas fa-building-circle-exclamation text-4xl text-gray-200 mb-4"></i>
                    <p class="text-gray-400 font-medium">Tiada fasiliti tersedia buat masa ini.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Tab 2: Sejarah Tempahan -->
    <div id="content-sejarah" class="hidden animate-fade-in-up">
        <div class="bg-white rounded-[3rem] shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50/50 border-b border-gray-100">
                            <th class="px-10 py-6 text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Maklumat Fasiliti</th>
                            <th class="px-10 py-6 text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Slot Masa</th>
                            <th class="px-10 py-6 text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Status Tempahan</th>
                            <th class="px-10 py-6 text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Tindakan</th>
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
                            <tr class="booking-row group hover:bg-gray-50/50 transition-all duration-300">
                                <td class="px-10 py-7">
                                    <div class="flex items-center gap-5">
                                        <div class="w-12 h-12 brand-gradient rounded-2xl flex items-center justify-center text-white shadow-lg shadow-purple-100 group-hover:scale-110 transition-transform">
                                            <i class="fas fa-building text-sm"></i>
                                        </div>
                                        <div>
                                            <p class="booking-facility-name text-[15px] font-black text-gray-800 tracking-tight"><%= t.getNama_fasiliti() %></p>
                                            <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-0.5">ID: #TMP-<%= t.getId_tempahan() %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-10 py-7">
                                    <div class="space-y-1.5">
                                        <div class="flex items-center gap-2">
                                            <i class="far fa-calendar text-brand-purple text-xs"></i>
                                            <p class="booking-date text-sm font-bold text-gray-700 tracking-tight"><%= t.getTarikh_tempah() %></p>
                                        </div>
                                        <div class="flex items-center gap-2">
                                            <i class="far fa-clock text-gray-300 text-xs"></i>
                                            <p class="text-[11px] text-gray-400 font-black uppercase tracking-wider"><%= t.getMasa_mula() %> — <%= t.getMasa_tamat() %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-10 py-7">
                                    <% if (StatusConstant.TEMPAHAN_LULUS.equals(t.getStatus())) { %>
                                        <span class="booking-status inline-flex items-center gap-2 px-4 py-1.5 bg-emerald-50 text-emerald-600 rounded-2xl text-[10px] font-black uppercase tracking-wider border border-emerald-100">
                                            <span class="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span> LULUS
                                        </span>
                                    <% } else if (StatusConstant.TEMPAHAN_TOLAK.equals(t.getStatus())) { %>
                                        <span class="booking-status inline-flex items-center gap-2 px-4 py-1.5 bg-rose-50 text-rose-600 rounded-2xl text-[10px] font-black uppercase tracking-wider border border-rose-100">
                                            <span class="w-1.5 h-1.5 bg-rose-500 rounded-full"></span> TOLAK
                                        </span>
                                    <% } else if (StatusConstant.TEMPAHAN_DIBATAL.equals(t.getStatus())) { %>
                                        <span class="booking-status inline-flex items-center gap-2 px-4 py-1.5 bg-gray-100 text-gray-500 rounded-2xl text-[10px] font-black uppercase tracking-wider border border-gray-200">
                                            <span class="w-1.5 h-1.5 bg-gray-400 rounded-full"></span> BATAL
                                        </span>
                                    <% } else { %>
                                        <span class="booking-status inline-flex items-center gap-2 px-4 py-1.5 bg-blue-50 text-blue-600 rounded-2xl text-[10px] font-black uppercase tracking-wider border border-blue-100">
                                            <span class="w-1.5 h-1.5 bg-blue-500 rounded-full animate-bounce"></span> MENUNGGU
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-10 py-7">
                                    <div class="flex items-center gap-3">
                                        <button onclick='openBookingDetailModal({
                                            namaFasiliti: "<%= t.getNama_fasiliti().replace("\"", "\\\"") %>",
                                            tarikh: "<%= t.getTarikh_tempah() %>",
                                            masa: "<%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %>",
                                            status: "<%= t.getStatus() %>",
                                            catatan: "<%= t.getCatatan_pemohon() != null ? t.getCatatan_pemohon().replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "" %>",
                                            alasan: "<%= t.getAlasanPenolakan() != null ? t.getAlasanPenolakan().replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "" %>",
                                            lat: <%= t.getLatitude() %>,
                                            lon: <%= t.getLongitude() %>,
                                            gambar: "<%= t.getGambar_fasiliti() != null ? t.getGambar_fasiliti() : "" %>"
                                        })' class="w-9 h-9 rounded-xl bg-gray-50 text-gray-400 hover:bg-brand-purple hover:text-white transition-all flex items-center justify-center shadow-sm">
                                            <i class="fas fa-eye text-xs"></i>
                                        </button>
                                        
                                        <% if (isFuture && (StatusConstant.TEMPAHAN_MENUNGGU.equals(t.getStatus()) || StatusConstant.TEMPAHAN_LULUS.equals(t.getStatus()))) { %>
                                            <a href="<%= contextPath %>/fasiliti/batal?id=<%= t.getId_tempahan() %>" 
                                               onclick="return confirm('Adakah anda pasti mahu membatalkan tempahan ini?')"
                                               class="w-9 h-9 rounded-xl bg-rose-50 text-rose-400 hover:bg-rose-500 hover:text-white transition-all flex items-center justify-center shadow-sm">
                                                <i class="fas fa-trash-can text-xs"></i>
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="4" class="px-10 py-20 text-center text-gray-400 text-sm italic font-medium">Tiada sejarah tempahan ditemui.</td></tr>
                        <% } %>
                        <tr id="sejarah-empty" class="hidden">
                            <td colspan="4" class="px-10 py-20 text-center text-gray-400 text-sm italic font-medium">Tiada tempahan sepadan dengan carian anda.</td>
                        </tr>
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
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: var(--brand-color); }

        @keyframes fade-in-up {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in-up { animation: fade-in-up 0.6s ease-out forwards; }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .brand-gradient {
            background: linear-gradient(135deg, var(--brand-color) 0%, var(--brand-secondary) 100%);
        }
    </style>

<!-- Right Aside Bar (Resident) -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar flex-shrink-0 animate-fade-in">
    <div class="flex justify-between items-center mb-8">
        <h3 class="font-black text-xl text-gray-800 tracking-tight">Info Penting</h3>
        <div class="w-8 h-8 bg-indigo-50 rounded-xl flex items-center justify-center text-brand-purple">
            <i class="fas fa-circle-info text-xs"></i>
        </div>
    </div>

    <div class="space-y-6">
        <!-- Rule 1 -->
        <div class="p-6 rounded-[2rem] bg-indigo-50/50 border border-indigo-100/50 group hover:bg-indigo-50 transition-colors duration-300">
            <div class="w-10 h-10 rounded-2xl bg-white text-brand-purple flex-shrink-0 flex items-center justify-center shadow-sm mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <h4 class="font-black text-sm text-gray-800 tracking-tight">Had Tempahan</h4>
                <p class="text-[11px] text-gray-500 mt-2 leading-relaxed font-medium">Setiap penduduk hanya dibenarkan mempunyai maksimum <span class="text-brand-purple font-bold">2 tempahan aktif</span> pada satu-satu masa.</p>
            </div>
        </div>

        <!-- Rule 2 -->
        <div class="p-6 rounded-[2rem] bg-emerald-50/50 border border-emerald-100/50 group hover:bg-emerald-50 transition-colors duration-300">
            <div class="w-10 h-10 rounded-2xl bg-white text-emerald-600 flex-shrink-0 flex items-center justify-center shadow-sm mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-user-shield"></i>
            </div>
            <div>
                <h4 class="font-black text-sm text-gray-800 tracking-tight">Kelulusan Manual</h4>
                <p class="text-[11px] text-gray-500 mt-2 leading-relaxed font-medium">Fasiliti tertentu memerlukan kelulusan AJK. Sila semak status secara berkala di tab <span class="text-emerald-600 font-bold">Sejarah</span>.</p>
            </div>
        </div>
        
        <!-- Rule 3 -->
        <div class="p-6 rounded-[2rem] bg-amber-50/50 border border-amber-100/50 group hover:bg-amber-50 transition-colors duration-300">
            <div class="w-10 h-10 rounded-2xl bg-white text-amber-600 flex-shrink-0 flex items-center justify-center shadow-sm mb-4 group-hover:scale-110 transition-transform">
                <i class="fas fa-clock"></i>
            </div>
            <div>
                <h4 class="font-black text-sm text-gray-800 tracking-tight">Slot Masa</h4>
                <p class="text-[11px] text-gray-500 mt-2 leading-relaxed font-medium">Pastikan anda hadir mengikut slot. Kegagalan hadir boleh menyebabkan tempahan akan datang <span class="text-amber-600 font-bold">disekat</span>.</p>
            </div>
        </div>
    </div>

    <!-- Contact Box -->
    <div class="mt-10 p-7 rounded-[2.5rem] brand-gradient text-white relative overflow-hidden group shadow-xl shadow-purple-100">
        <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-white/10 rounded-full blur-2xl group-hover:bg-white/20 transition-colors"></div>
        <h4 class="font-black text-base mb-2 tracking-tight relative z-10">Bantuan Teknis?</h4>
        <p class="text-[11px] text-white/80 mb-6 leading-relaxed font-medium relative z-10">Hubungi Biro Sukan & Riadah jika anda mempunyai masalah teknikal atau pembatalan saat akhir.</p>
        <button class="w-full bg-white/20 backdrop-blur-md border border-white/30 text-white py-3.5 rounded-2xl text-[10px] font-black uppercase tracking-widest hover:bg-white/30 transition-all shadow-lg relative z-10">Hubungi Biro</button>
    </div>
</aside>

<!-- Modal Tempahan -->
<div id="modalTempah" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900/60 transition-opacity backdrop-blur-md" onclick="closeModal('modalTempah')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[3rem] shadow-2xl p-10 transform transition-all animate-fade-in-up">
            <header class="flex justify-between items-center mb-10">
                <div>
                    <h3 class="text-2xl font-black text-gray-800 tracking-tight">Sahkan Tempahan</h3>
                    <div class="flex items-center gap-2 mt-1.5">
                        <div class="w-2 h-2 bg-brand-purple rounded-full"></div>
                        <p class="text-xs text-gray-400 font-bold uppercase tracking-widest" id="modalFasilitiName"></p>
                    </div>
                </div>
                <button onclick="closeModal('modalTempah')" class="w-12 h-12 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 hover:bg-gray-100 rounded-2xl transition-all">
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
    <div class="fixed inset-0 bg-gray-900/60 transition-opacity backdrop-blur-md" onclick="closeModal('modalButiran')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-xl bg-white rounded-[3rem] shadow-2xl p-10 transform transition-all animate-fade-in-up">
            <header class="flex justify-between items-start mb-8">
                <div class="space-y-1">
                    <h3 class="text-2xl font-black text-gray-800 tracking-tight" id="detNama">Nama Fasiliti</h3>
                    <p class="text-[11px] text-gray-400 font-bold uppercase tracking-[0.2em] flex items-center gap-2">
                        <i class="fas fa-location-dot text-brand-purple"></i> <span id="detLokasi">Lokasi</span>
                    </p>
                </div>
                <button onclick="closeModal('modalButiran')" class="w-12 h-12 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 hover:bg-gray-100 rounded-2xl transition-all">
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

<!-- Modal Detail Sejarah Tempahan -->
<div id="modalHistoryDetail" class="fixed inset-0 z-[60] hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900/60 transition-opacity backdrop-blur-md" onclick="closeModal('modalHistoryDetail')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[3rem] shadow-2xl p-10 transform transition-all animate-fade-in-up">
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h3 class="text-2xl font-black text-gray-800 tracking-tight">Status Tempahan</h3>
                    <p class="text-[11px] text-gray-400 font-bold uppercase tracking-[0.2em] mt-1.5" id="histNama">Nama Fasiliti</p>
                </div>
                <button onclick="closeModal('modalHistoryDetail')" class="w-12 h-12 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 hover:bg-gray-100 rounded-2xl transition-all">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <div class="space-y-6">
                <!-- Image Preview Section -->
                <div id="histImageContainer" class="h-40 w-full rounded-3xl overflow-hidden hidden bg-gray-100 border border-gray-100">
                    <img id="histImage" src="" class="w-full h-full object-cover">
                </div>

                <!-- Status & Timing -->
                <div class="bg-gray-50 rounded-3xl p-6 border border-gray-100 flex justify-between items-center">
                    <div class="space-y-1">
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</p>
                        <div id="histStatusBadge"></div>
                    </div>
                    <div class="text-right space-y-1">
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tarikh & Masa</p>
                        <p id="histTarikh" class="text-xs font-bold text-gray-700"></p>
                        <p id="histMasa" class="text-[10px] text-gray-400 font-medium"></p>
                    </div>
                </div>

                <!-- Note Section -->
                <div class="space-y-2 px-2">
                    <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Catatan Anda</h4>
                    <p id="histCatatan" class="text-sm text-gray-600 leading-relaxed bg-white border border-gray-100 p-4 rounded-2xl"></p>
                </div>

                <!-- Rejection Reason Section -->
                <div id="histRejectSection" class="space-y-2 px-2 hidden">
                    <h4 class="text-[10px] font-bold text-red-400 uppercase tracking-widest">Alasan Penolakan (AJK)</h4>
                    <div class="bg-red-50 border border-red-100 p-4 rounded-2xl">
                        <p id="histAlasan" class="text-sm text-red-600 leading-relaxed font-medium"></p>
                    </div>
                </div>

                <!-- Map Section -->
                <div class="space-y-3">
                    <h4 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Lokasi Fasiliti</h4>
                    <div id="mapHistory" style="height: 180px; border-radius: 1.5rem; z-index: 0;" class="border border-gray-100 bg-gray-50"></div>
                </div>

                <div class="flex gap-4">
                    <button id="histBtnNav" class="flex-1 py-4 bg-green-500 text-white rounded-2xl font-bold text-sm shadow-lg shadow-green-100 hover:bg-green-600 transition-all flex items-center justify-center gap-2">
                        <i class="fas fa-route"></i> Navigasi
                    </button>
                    <button onclick="closeModal('modalHistoryDetail')" class="flex-1 py-4 bg-gray-100 text-gray-500 rounded-2xl font-bold text-sm hover:bg-gray-200 transition-all">
                        Tutup
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function filterData() {
        const keyword = document.getElementById('searchInput').value.toLowerCase();
        
        // Filter Facility Cards
        const cards = document.querySelectorAll('.facility-card');
        let cardFound = false;
        cards.forEach(card => {
            const name = card.querySelector('.facility-name').innerText.toLowerCase();
            const location = card.querySelector('.facility-location').innerText.toLowerCase();
            if (name.includes(keyword) || location.includes(keyword)) {
                card.classList.remove('hidden');
                cardFound = true;
            } else {
                card.classList.add('hidden');
            }
        });

        const cardEmpty = document.getElementById('senarai-empty');
        if (cardEmpty) {
            if (!cardFound && keyword !== "") {
                cardEmpty.classList.remove('hidden');
            } else {
                cardEmpty.classList.add('hidden');
            }
        }

        // Filter Booking Table
        const rows = document.querySelectorAll('.booking-row');
        let rowFound = false;
        rows.forEach(row => {
            const name = row.querySelector('.booking-facility-name').innerText.toLowerCase();
            const date = row.querySelector('.booking-date').innerText.toLowerCase();
            const status = row.querySelector('.booking-status').innerText.toLowerCase();
            if (name.includes(keyword) || date.includes(keyword) || status.includes(keyword)) {
                row.style.display = '';
                rowFound = true;
            } else {
                row.style.display = 'none';
            }
        });

        const rowEmpty = document.getElementById('sejarah-empty');
        if (rowEmpty) {
            if (!rowFound && keyword !== "") {
                rowEmpty.style.display = '';
            } else {
                rowEmpty.style.display = 'none';
            }
        }
    }

    var historyMap, historyMarker;
    function openBookingDetailModal(data) {
        document.getElementById('histNama').innerText = data.namaFasiliti;
        document.getElementById('histTarikh').innerText = data.tarikh;
        document.getElementById('histMasa').innerText = data.masa;
        document.getElementById('histCatatan').innerText = data.catatan || 'Tiada catatan.';
        
        const statusBadge = document.getElementById('histStatusBadge');
        const rejectSection = document.getElementById('histRejectSection');
        const rejectAlasan = document.getElementById('histAlasan');

        if (data.status === '<%= StatusConstant.TEMPAHAN_LULUS %>') {
            statusBadge.className = "inline-flex items-center gap-1.5 px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold";
            statusBadge.innerHTML = '<i class="fas fa-check-circle text-[8px]"></i> LULUS';
            rejectSection.classList.add('hidden');
        } else if (data.status === '<%= StatusConstant.TEMPAHAN_TOLAK %>') {
            statusBadge.className = "inline-flex items-center gap-1.5 px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold";
            statusBadge.innerHTML = '<i class="fas fa-times-circle text-[8px]"></i> TOLAK';
            rejectSection.classList.remove('hidden');
            rejectAlasan.innerText = data.alasan || 'Tiada alasan dinyatakan.';
        } else if (data.status === '<%= StatusConstant.TEMPAHAN_DIBATAL %>') {
            statusBadge.className = "inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 text-gray-500 rounded-full text-[10px] font-bold";
            statusBadge.innerHTML = '<i class="fas fa-ban text-[8px]"></i> BATAL';
            rejectSection.classList.add('hidden');
        } else {
            statusBadge.className = "inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-bold";
            statusBadge.innerHTML = '<i class="fas fa-clock text-[8px]"></i> MENUNGGU';
            rejectSection.classList.add('hidden');
        }

        // Image Logic
        const imgContainer = document.getElementById('histImageContainer');
        const imgElement = document.getElementById('histImage');
        if (data.gambar) {
            imgElement.src = '<%= request.getContextPath() %>/file/fasiliti/' + data.gambar;
            imgContainer.classList.remove('hidden');
        } else {
            imgContainer.classList.add('hidden');
        }

        // Map Logic
        const navBtn = document.getElementById('histBtnNav');
        if (data.lat && data.lon) {
            navBtn.onclick = () => window.open(`https://www.google.com/maps/dir/?api=1&destination=${data.lat},${data.lon}`, '_blank');
            navBtn.classList.remove('hidden');
            
            setTimeout(() => {
                if (historyMap) historyMap.remove();
                historyMap = L.map('mapHistory').setView([data.lat, data.lon], 16);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19, attribution: '© OpenStreetMap'
                }).addTo(historyMap);
                historyMarker = L.marker([data.lat, data.lon]).addTo(historyMap);
            }, 300);
        } else {
            navBtn.classList.add('hidden');
            document.getElementById('mapHistory').innerHTML = `
                <div class="flex flex-col items-center justify-center h-full text-gray-400 gap-2">
                    <i class="fas fa-map-marked-alt text-3xl opacity-20"></i>
                    <p class="text-[10px] font-bold uppercase tracking-widest">Tiada Koordinat GPS</p>
                </div>
            `;
        }

        openModal('modalHistoryDetail');
    }

    // closeHistoryDetailModal centralized in footer.jsp

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
        const tabSenarai = document.getElementById('tab-senarai');
        const tabSejarah = document.getElementById('tab-sejarah');
        
        if (tabId === 'senarai') {
            tabSenarai.classList.add('bg-white', 'text-brand-purple', 'shadow-sm');
            tabSenarai.classList.remove('text-gray-400');
            tabSejarah.classList.remove('bg-white', 'text-brand-purple', 'shadow-sm');
            tabSejarah.classList.add('text-gray-400');
        } else {
            tabSejarah.classList.add('bg-white', 'text-brand-purple', 'shadow-sm');
            tabSejarah.classList.remove('text-gray-400');
            tabSenarai.classList.remove('bg-white', 'text-brand-purple', 'shadow-sm');
            tabSenarai.classList.add('text-gray-400');
        }

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

        openModal('modalButiran');

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

    // Modal close functions centralized in footer.jsp

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
