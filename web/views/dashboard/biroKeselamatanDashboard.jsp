<%@ page import="model.Pengguna" %>
<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. SEKURITI: Redirect jika session tamat atau tidak sah
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Dashboard Biro Keselamatan</h2>
            <p class="text-gray-500 text-sm">Pantau keamanan kampung dan uruskan aduan penduduk.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-[#6C5DD3] shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari aduan, laporan, atau aktiviti...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#1e293b] to-[#334155] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-slate-200 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-slate-100 uppercase tracking-wider">BIRO KESELAMATAN</span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Bertugas, <%= user.getNama_penuh() %>!</h1>
            <p class="text-slate-50 mb-6 text-sm opacity-90">
                Keamanan dan keharmonian kampung adalah tanggungjawab bersama. Pastikan setiap aduan disemak dengan teliti.
            </p>
            <div class="flex gap-3">
                <a href="<%= request.getContextPath() %>/aduan/list" class="bg-white text-slate-700 px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-slate-50 transition shadow-md">
                    Urus Aduan
                </a>
            </div>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-20 w-32 h-32 bg-slate-900 opacity-20 rounded-full blur-2xl"></div>
    </div>

    <%-- Statistik Ringkas --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600 text-xl">
                <i class="fas fa-shield-alt"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Status Keamanan</p>
                <h3 class="text-xl font-bold text-green-600">TERKAWAL</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 text-xl">
                <i class="fas fa-comment-dots"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Aduan Baharu</p>
                <h3 class="text-xl font-bold text-gray-800">3</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-purple-50 flex items-center justify-center text-purple-500 text-xl">
                <i class="fas fa-check-double"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Kes Selesai (Bulan Ini)</p>
                <h3 class="text-xl font-bold text-gray-800">12</h3>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <%-- Menu Pantas --%>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
            <h3 class="font-bold text-gray-800 mb-4">Akses Pantas</h3>
            <div class="grid grid-cols-2 gap-4">
                <a href="<%= request.getContextPath() %>/aduan/list" class="p-4 rounded-2xl bg-gray-50 hover:bg-[#6C5DD3] hover:text-white transition group">
                    <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-[#6C5DD3] mb-3 group-hover:bg-white/20 group-hover:text-white">
                        <i class="fas fa-list-ul"></i>
                    </div>
                    <p class="text-sm font-bold">Senarai Aduan</p>
                    <p class="text-[10px] opacity-60">Semua laporan penduduk</p>
                </a>
                <a href="<%= request.getContextPath() %>/profil/view" class="p-4 rounded-2xl bg-gray-50 hover:bg-slate-700 hover:text-white transition group">
                    <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-slate-700 mb-3 group-hover:bg-white/20 group-hover:text-white">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <p class="text-sm font-bold">Profil Biro</p>
                    <p class="text-[10px] opacity-60">Kemaskini maklumat</p>
                </a>
            </div>
        </div>

        <%-- Info Keselamatan --%>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
            <h3 class="font-bold text-gray-800 mb-4">Panduan Biro Keselamatan</h3>
            <div class="space-y-4">
                <div class="flex items-start gap-3">
                    <div class="mt-1 w-5 h-5 rounded-full bg-green-100 text-green-600 flex items-center justify-center text-[10px]"><i class="fas fa-check"></i></div>
                    <p class="text-xs text-gray-600">Semak aduan 'SUBMITTED' setiap 24 jam.</p>
                </div>
                <div class="flex items-start gap-3">
                    <div class="mt-1 w-5 h-5 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-[10px]"><i class="fas fa-info"></i></div>
                    <p class="text-xs text-gray-600">Majukan ke Ketua Kampung jika melibatkan kos besar atau autoriti luar.</p>
                </div>
                <div class="flex items-start gap-3">
                    <div class="mt-1 w-5 h-5 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center text-[10px]"><i class="fas fa-exclamation"></i></div>
                    <p class="text-xs text-gray-600">Pastikan bukti penyelesaian (gambar) dimuat naik untuk rekod.</p>
                </div>
            </div>
        </div>
    </div>

</div> 

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    
    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <% if (user.getFoto_profil() != null && !user.getFoto_profil().isEmpty() && !user.getFoto_profil().equals("default_avatar.png")) { %>
                <img src="<%= request.getContextPath() %>/file/profil/<%= user.getFoto_profil() %>" 
                     class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=1e293b&color=fff&size=128" 
                     class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-xs font-bold text-slate-600 bg-slate-50 px-4 py-1.5 rounded-full inline-block mt-2 uppercase tracking-tight">
            <%= (user.getNama_jawatan() != null) ? user.getNama_jawatan() : "Biro Keselamatan" %>
        </p>
    </div>

    <div class="mb-8">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-wider">Status Rondaan</h3>
        <div class="bg-gray-50 p-5 rounded-3xl border border-gray-100">
            <div class="flex justify-between items-center mb-3">
                <span class="text-xs text-gray-500 font-medium">Bulan April</span>
                <span class="text-[10px] text-green-600 font-bold bg-green-100 px-2 py-0.5 rounded">LENGKAP</span>
            </div>
            <h4 class="text-xl font-bold text-gray-800 mb-1">100% Selesai</h4>
            <p class="text-[10px] text-gray-400">Semua zon telah diperiksa.</p>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-wider">Peringatan</h3>
        <div class="space-y-3">
            <div class="flex items-center gap-3 p-3 rounded-2xl bg-red-50 border border-red-100">
                <div class="w-8 h-8 rounded-full bg-white flex items-center justify-center text-red-500 shadow-sm">
                    <i class="fas fa-bell text-xs"></i>
                </div>
                <p class="text-[11px] font-bold text-red-700">3 Aduan Kritikal perlu tindakan segera!</p>
            </div>
        </div>
    </div>

</aside>

<%@ include file="/views/common/footer.jsp" %>
