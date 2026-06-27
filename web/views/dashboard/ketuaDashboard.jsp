<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="java.util.List" %>
<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. SEKURITI: Redirect jika session tamat atau tidak sah
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }

    // 3. Ambil data dinamik yang disuntik oleh DashboardServlet
    List<PermohonanBantuan> pendingBantuan = (List<PermohonanBantuan>) request.getAttribute("pendingBantuanList");
    List<TempahanFasiliti> pendingTempahan = (List<TempahanFasiliti>) request.getAttribute("pendingTempahanList");
    List<Pengguna> ajkList = (List<Pengguna>) request.getAttribute("ajkList");

    Integer pendingBantuanCount = (Integer) request.getAttribute("pendingBantuanCount");
    if (pendingBantuanCount == null) pendingBantuanCount = 0;
    
    Integer pendingTempahanCount = (Integer) request.getAttribute("pendingTempahanCount");
    if (pendingTempahanCount == null) pendingTempahanCount = 0;
    
    Integer pendingAduanCount = (Integer) request.getAttribute("pendingAduanCount");
    if (pendingAduanCount == null) pendingAduanCount = 0;
    
    Integer totalPenduduk = (Integer) request.getAttribute("totalPenduduk");
    if (totalPenduduk == null) totalPenduduk = 0;
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<!-- Google Fonts Outfit & Custom Glassmorphism Styles -->
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<style>
    body {
        font-family: 'Outfit', sans-serif;
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.4);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .glass-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.08);
    }
    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #E2E8F0;
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #CBD5E1;
    }
</style>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F8FAFC] custom-scrollbar">
    <div class="max-w-7xl mx-auto">

        <!-- Header Section -->
        <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
            <div>
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-slate-100 border border-slate-200 text-slate-600 text-[10px] font-extrabold uppercase tracking-widest">
                    <i class="fas fa-home"></i> Papan Pemuka Eksekutif
                </span>
                <h1 class="text-3xl font-black text-slate-800 tracking-tight mt-2">Portal Ketua Kampung</h1>
                <p class="text-slate-500 text-sm mt-0.5">Sahkan permohonan kebajikan, luluskan tempahan fasiliti, dan selia jawatankuasa AJK.</p>
            </div>
        </header>

        <!-- Premium Hero Section -->
        <div class="relative bg-gradient-to-r from-[#1E293B] to-[#475569] rounded-[2.5rem] p-8 md:p-10 text-white mb-8 shadow-xl overflow-hidden group">
            <div class="relative z-10 max-w-xl">
                <span class="bg-white/20 text-[10px] font-extrabold px-3 py-1 rounded-full backdrop-blur-md text-cyan-300 uppercase tracking-widest border border-white/10">KETUA KAMPUNG</span>
                <h1 class="text-3xl md:text-4xl font-black mt-4 mb-2 leading-tight">Selamat Datang, <%= user.getNama_penuh() %>!</h1>
                <p class="text-slate-200 mb-6 text-sm leading-relaxed opacity-95">
                    Anda sedang mentadbir urus kebajikan dan keharmonian bagi komuniti berdaftar Mukim <%= (user.getBandar() != null) ? user.getBandar() : "Kampung" %>.
                </p>
                <div class="flex flex-wrap gap-3">
                    <a href="<%= request.getContextPath() %>/bantuan/list" class="bg-white text-slate-800 px-6 py-3 rounded-xl font-bold text-xs hover:bg-slate-100 transition shadow-md flex items-center gap-2">
                        <i class="fas fa-stamp text-slate-500"></i> Urus Bantuan Kampung
                    </a>
                    <a href="<%= request.getContextPath() %>/views/laporan/laporanAnalitik.jsp" class="bg-white/10 hover:bg-white/20 text-white px-6 py-3 rounded-xl font-bold text-xs backdrop-blur-md border border-white/10 transition flex items-center gap-2">
                        <i class="fas fa-chart-pie text-cyan-300"></i> Portal Laporan & Analitik
                    </a>
                </div>
            </div>
            <div class="absolute top-0 right-0 -mr-16 -mt-16 w-80 h-80 bg-white opacity-5 rounded-full blur-3xl group-hover:scale-110 transition-transform duration-700"></div>
            <div class="absolute bottom-0 right-20 w-48 h-48 bg-slate-900 opacity-20 rounded-full blur-2xl"></div>
        </div>

        <!-- 4-Column Statistics Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-orange-50 border border-orange-100 text-orange-500 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-hand-holding-heart"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Bantuan Menunggu</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= pendingBantuanCount %> <span class="text-xs font-normal text-slate-400">kes</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-blue-50 border border-blue-100 text-blue-500 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Tempahan Menunggu</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= pendingTempahanCount %> <span class="text-xs font-normal text-slate-400">aktif</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-rose-50 border border-rose-100 text-rose-500 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Aduan Komuniti</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= pendingAduanCount %> <span class="text-xs font-normal text-slate-400">aktif</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-purple-50 border border-purple-100 text-purple-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Penduduk Berdaftar</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= totalPenduduk %> <span class="text-xs font-normal text-slate-400">orang</span></span>
                </div>
            </div>
        </div>

        <%-- AI Insights Widget --%>
        <%
            String latestReportJson = (String) session.getAttribute("latest_ai_structured_report");
            String aiSummary = null;
            List<String> aiAlerts = null;
            if (latestReportJson != null) {
                try {
                    com.google.gson.JsonObject reportObj = com.google.gson.JsonParser.parseString(latestReportJson).getAsJsonObject();
                    if (reportObj.has("executive_summary")) {
                        aiSummary = reportObj.get("executive_summary").getAsString();
                    }
                    if (reportObj.has("critical_alerts")) {
                        com.google.gson.JsonArray alertsArr = reportObj.getAsJsonArray("critical_alerts");
                        aiAlerts = new java.util.ArrayList<>();
                        for (int i = 0; i < alertsArr.size(); i++) {
                            aiAlerts.add(alertsArr.get(i).getAsString());
                        }
                    }
                } catch (Exception e) {
                    // Ignore or log
                }
            }
        %>
        <div class="glass-card rounded-[2.5rem] p-6 mb-8 border border-purple-100 bg-gradient-to-r from-purple-50/30 via-white to-indigo-50/10">
            <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100">
                <div class="flex items-center gap-2.5">
                    <div class="w-10 h-10 rounded-2xl bg-purple-50 text-purple-600 border border-purple-100/50 flex items-center justify-center text-lg">
                        <i class="fas fa-robot text-purple-500"></i>
                    </div>
                    <div>
                        <h3 class="font-black text-slate-800 text-sm tracking-tight">AI Insights & Amaran Komuniti</h3>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider mt-0.5">Analisis Pintar Bulanan</p>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/laporan/view" class="text-xs font-bold text-indigo-600 hover:text-indigo-800 flex items-center gap-1.5 transition">
                    Portal Laporan <i class="fas fa-arrow-right text-[10px]"></i>
                </a>
            </div>

            <% if (aiSummary != null) { %>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 space-y-4">
                        <div class="p-5 rounded-3xl bg-white border border-slate-100 shadow-sm h-full">
                            <h4 class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 flex items-center gap-1.5">
                                <i class="fas fa-file-invoice text-indigo-500"></i> Ringkasan Eksekutif AI
                            </h4>
                            <p class="text-xs text-slate-600 leading-relaxed font-medium"><%= aiSummary %></p>
                        </div>
                    </div>
                    <div class="lg:col-span-1 space-y-3">
                        <h4 class="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1 flex items-center gap-1.5">
                            <i class="fas fa-bell text-rose-500"></i> Amaran Kritikal
                        </h4>
                        <% if (aiAlerts != null && !aiAlerts.isEmpty()) { 
                            for (String alert : aiAlerts) { %>
                                <div class="flex items-start gap-2.5 p-3 bg-rose-50 border border-rose-100 rounded-2xl">
                                    <div class="w-5 h-5 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center text-[10px] shrink-0 animate-pulse">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </div>
                                    <span class="text-[11px] text-rose-700 font-semibold"><%= alert %></span>
                                </div>
                            <% } 
                        } else { %>
                            <div class="p-3 bg-emerald-50 border border-emerald-100 rounded-2xl flex items-center gap-2">
                                <div class="w-5 h-5 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[10px]">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <span class="text-[11px] text-emerald-700 font-semibold">Tiada amaran kritikal dikesan.</span>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } else { %>
                <div class="p-8 text-center max-w-lg mx-auto space-y-3">
                    <div class="w-14 h-14 rounded-2xl bg-purple-50 text-purple-600 border border-purple-100/50 flex items-center justify-center text-xl mx-auto">
                        <i class="fas fa-wand-magic-sparkles"></i>
                    </div>
                    <h4 class="text-xs font-bold text-slate-800">Ulasan AI Bulanan Belum Dijana</h4>
                    <p class="text-xs text-slate-400 leading-relaxed">Ketua Kampung boleh menjana laporan eksekutif berstruktur berasaskan statistik semasa kampung untuk mendapatkan ringkasan AI dan senarai amaran komuniti di sini.</p>
                    <a href="<%= request.getContextPath() %>/laporan/view" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-purple-600 hover:bg-purple-700 text-white text-xs font-bold transition shadow-md shadow-purple-100">
                        <i class="fas fa-sparkles"></i> Jana Ulasan Pertama Anda
                    </a>
                </div>
            <% } %>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <!-- Left Side: Bantuan Awaiting Endorsement -->
            <div class="glass-card rounded-[2rem] p-6 flex flex-col h-[500px]">
                <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100/50">
                    <div>
                        <h3 class="font-black text-lg text-slate-800">Sokongan Bantuan</h3>
                        <p class="text-xs text-slate-400">Permohonan bantuan kebajikan menunggu sokongan anda.</p>
                    </div>
                    <span class="px-2.5 py-1 rounded-full bg-orange-100 text-orange-600 text-[10px] font-extrabold uppercase"><%= pendingBantuanCount %> Baru</span>
                </div>

                <div class="flex-1 overflow-y-auto custom-scrollbar space-y-4 pr-1">
                    <% if (pendingBantuan != null && !pendingBantuan.isEmpty()) {
                        for (PermohonanBantuan pb : pendingBantuan) { %>
                        <div class="p-4 bg-white/60 hover:bg-white rounded-2xl border border-slate-100 shadow-sm flex items-center justify-between transition-all group">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center text-slate-600 font-bold text-sm border border-slate-100 group-hover:bg-slate-800 group-hover:text-white transition-colors">
                                    <%= pb.getNama_penuh() != null ? pb.getNama_penuh().substring(0,1).toUpperCase() : "B" %>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-800"><%= pb.getNama_penuh() %></h4>
                                    <p class="text-[10px] font-bold text-slate-400 mt-0.5"><%= pb.getNama_bantuan() %> &bull; <%= pb.getNombor_kp() %></p>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/bantuan/list" class="px-3.5 py-2 bg-slate-50 hover:bg-slate-800 hover:text-white text-slate-700 rounded-xl text-[10px] font-extrabold uppercase tracking-tight shadow-sm border border-slate-100 transition-all">
                                Semak
                            </a>
                        </div>
                    <% } } else { %>
                        <div class="h-full flex flex-col items-center justify-center text-slate-400 opacity-60">
                            <i class="fas fa-heart-circle-check text-4xl mb-3"></i>
                            <p class="text-xs font-bold italic">Tiada permohonan bantuan menunggu kelulusan.</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Right Side: Facilities Bookings Pending -->
            <div class="glass-card rounded-[2rem] p-6 flex flex-col h-[500px]">
                <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100/50">
                    <div>
                        <h3 class="font-black text-lg text-slate-800">Tempahan Fasiliti</h3>
                        <p class="text-xs text-slate-400">Tempahan kemudahan kampung menunggu kelulusan rasmi.</p>
                    </div>
                    <span class="px-2.5 py-1 rounded-full bg-blue-100 text-blue-600 text-[10px] font-extrabold uppercase"><%= pendingTempahanCount %> Baru</span>
                </div>

                <div class="flex-1 overflow-y-auto custom-scrollbar space-y-4 pr-1">
                    <% if (pendingTempahan != null && !pendingTempahan.isEmpty()) {
                        for (TempahanFasiliti tf : pendingTempahan) { %>
                        <div class="p-4 bg-white/60 hover:bg-white rounded-2xl border border-slate-100 shadow-sm flex items-center justify-between transition-all group">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-slate-50 flex items-center justify-center text-slate-600 font-bold text-sm border border-slate-100 group-hover:bg-slate-800 group-hover:text-white transition-colors">
                                    <i class="fas fa-hotel text-xs"></i>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-800"><%= tf.getNama_pengguna() %></h4>
                                    <p class="text-[10px] font-bold text-slate-400 mt-0.5"><%= tf.getNama_fasiliti() %> &bull; <%= tf.getTarikh_tempah() %></p>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/tempahan/urus" class="px-3.5 py-2 bg-slate-50 hover:bg-slate-800 hover:text-white text-slate-700 rounded-xl text-[10px] font-extrabold uppercase tracking-tight shadow-sm border border-slate-100 transition-all">
                                Urus
                            </a>
                        </div>
                    <% } } else { %>
                        <div class="h-full flex flex-col items-center justify-center text-slate-400 opacity-60">
                            <i class="fas fa-calendar-check text-4xl mb-3"></i>
                            <p class="text-xs font-bold italic">Tiada tempahan fasiliti menunggu kelulusan.</p>
                        </div>
                    <% } %>
                </div>
            </div>

        </div>

    </div>
</div>

<!-- Dynamic Aside Sidebar -->
<aside class="hidden xl:flex w-full xl:w-80 bg-white border-t xl:border-t-0 xl:border-l border-slate-100 flex-col p-8 flex-shrink-0 h-full overflow-y-auto custom-scrollbar shrink-0">
    
    <!-- Profile Card -->
    <div class="text-center mb-8 pb-8 border-b border-slate-100">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <% if (user.getFoto_profil() != null && !user.getFoto_profil().isEmpty() && !user.getFoto_profil().equals("default_avatar.png")) { %>
                <img src="<%= request.getContextPath() %>/file/profil/<%= user.getFoto_profil() %>" 
                     class="w-full h-full rounded-[2rem] object-cover border-4 border-white shadow-lg relative z-10">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=1E293B&color=fff&size=128" 
                     class="w-full h-full rounded-[2rem] object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-slate-800 tracking-tight"><%= user.getNama_penuh() %></h2>
        <p class="text-[10px] font-extrabold text-slate-400 bg-slate-50 border border-slate-100 px-3.5 py-1 rounded-full inline-block mt-2 uppercase tracking-wider">
            <%= user.getNama_peranan() %>
        </p>
    </div>

    <!-- Active Jawatankuasa AJK Directory -->
    <div class="mb-8 flex-1">
        <h3 class="text-xs font-extrabold text-slate-400 uppercase tracking-widest mb-4 flex items-center gap-1.5"><i class="fas fa-users-cog text-slate-300"></i> Hubungan Jawatankuasa</h3>
        <div class="space-y-4">
            <% if (ajkList != null && !ajkList.isEmpty()) {
                for (Pengguna ajk : ajkList) { %>
                <div class="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-100 hover:border-slate-200 transition-all group">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-lg bg-white shadow-sm flex items-center justify-center text-slate-700 font-extrabold text-[11px] uppercase border border-slate-100 group-hover:bg-slate-800 group-hover:text-white transition-colors">
                            <%= ajk.getNama_penuh().substring(0, 1) %>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-bold text-slate-800 truncate max-w-[120px]"><%= ajk.getNama_penuh() %></p>
                            <p class="text-[9px] text-slate-400 truncate max-w-[120px]"><%= ajk.getNama_jawatan() != null ? ajk.getNama_jawatan() : "AJK" %></p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1.5">
                        <a href="https://wa.me/6<%= ajk.getNombor_telefon() %>" target="_blank" 
                           class="w-7 h-7 rounded-lg bg-green-50 text-green-600 hover:bg-green-500 hover:text-white transition flex items-center justify-center text-xs shadow-sm border border-green-100"
                           title="Hubungi WhatsApp">
                            <i class="fab fa-whatsapp"></i>
                        </a>
                    </div>
                </div>
            <% } } else { %>
                <p class="text-[11px] text-slate-400 italic">Tiada maklumat AJK Kampung dijumpai.</p>
            <% } %>
        </div>
    </div>

    <!-- Management Advice Card -->
    <div class="mt-auto">
        <h4 class="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest mb-3">Nota Pengurusan Eksekutif</h4>
        <div class="bg-gradient-to-br from-[#1E293B] to-[#334155] rounded-3xl p-5 border border-white/5 relative overflow-hidden group">
            <i class="fas fa-scroll absolute -right-2 -bottom-2 text-slate-800 text-6xl opacity-40"></i>
            <p class="text-[11px] text-slate-300 leading-relaxed relative z-10 font-medium">
                Peringatan: Kelulusan bantuan tertakluk kepada keputusan mesyuarat bersama AJK Kebajikan. Pastikan permohonan dikemaskini sebelum tempoh akhir bulan.
            </p>
        </div>
        
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="w-full mt-6 bg-rose-50 text-rose-600 border border-rose-100 py-3.5 rounded-2xl text-xs font-black uppercase tracking-wider hover:bg-rose-600 hover:text-white hover:border-rose-600 transition-all flex items-center justify-center gap-2 shadow-sm">
            <i class="fas fa-sign-out-alt"></i> Log Keluar
        </a>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>