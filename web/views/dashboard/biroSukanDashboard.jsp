<%@ page import="model.Pengguna" %>
<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <!-- Header -->
    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Papan Pemuka Biro Sukan</h2>
            <p class="text-gray-500 text-sm">Urus fasiliti dan tempahan sukan penduduk.</p>
        </div>
        
        <div class="flex gap-3">
             <a href="<%= request.getContextPath() %>/fasiliti/urus" class="bg-brand-purple text-white px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-opacity-90 transition shadow-lg shadow-indigo-100 flex items-center gap-2">
                <i class="fas fa-plus"></i> Urus Fasiliti
            </a>
        </div>
    </header>

    <!-- Welcome Card -->
    <div class="relative bg-gradient-to-r from-[#6C5DD3] to-[#8E82EF] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-indigo-100 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-indigo-100"><%= user.getNama_jawatan().toUpperCase() %></span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Datang, <%= user.getNama_penuh() %>!</h1>
            <p class="text-indigo-50 mb-6 text-sm opacity-90">
                Sistem pengurusan fasiliti kini di bawah tanggungjawab Biro Sukan & Riadah. Pastikan semua gelanggang dan dewan dalam keadaan terbaik.
            </p>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-10 rounded-full blur-3xl"></div>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5">
            <div class="w-14 h-14 bg-blue-50 text-blue-500 rounded-2xl flex items-center justify-center text-xl">
                <i class="fas fa-building-circle-check"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Fasiliti Aktif</p>
                <h3 class="text-2xl font-bold text-gray-800">4</h3>
            </div>
        </div>

        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5">
            <div class="w-14 h-14 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center text-xl">
                <i class="fas fa-calendar-clock"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Tempahan Baru</p>
                <h3 class="text-2xl font-bold text-gray-800">2</h3>
            </div>
        </div>

        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5">
            <div class="w-14 h-14 bg-green-50 text-green-500 rounded-2xl flex items-center justify-center text-xl">
                <i class="fas fa-check-double"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Selesai (Bulan Ini)</p>
                <h3 class="text-2xl font-bold text-gray-800">12</h3>
            </div>
        </div>
    </div>

    <!-- Recent Bookings Table -->
    <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="p-8 border-b border-gray-50 flex justify-between items-center">
             <h3 class="font-bold text-xl text-gray-800">Permohonan Tempahan Terbaru</h3>
             <a href="<%= request.getContextPath() %>/fasiliti/urus" class="text-sm font-bold text-brand-purple hover:underline">Lihat Semua</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Pemohon</th>
                        <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Fasiliti</th>
                        <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</th>
                        <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    <tr class="hover:bg-gray-50/50 transition-colors">
                        <td class="px-8 py-6">
                            <p class="text-sm font-bold text-gray-800">Khairul Iman</p>
                            <p class="text-[10px] text-gray-400 font-medium">18 Apr 2026</p>
                        </td>
                        <td class="px-8 py-6 text-sm text-gray-500 font-medium">Gelanggang Futsal</td>
                        <td class="px-8 py-6">
                            <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-bold uppercase tracking-wider">Menunggu</span>
                        </td>
                        <td class="px-8 py-6 text-center">
                            <a href="<%= request.getContextPath() %>/fasiliti/urus" class="bg-gray-50 text-brand-purple text-[10px] font-bold px-4 py-2 rounded-xl hover:bg-indigo-50 transition border border-indigo-100">Urus</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div> 

<!-- Right Sidebar (Profile) -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil Biro</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-cog"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=6C5DD3&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20 shadow-sm"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-xs font-bold text-brand-purple mt-1"><%= user.getNama_jawatan() %></p>
        <p class="text-[10px] text-gray-400 font-medium tracking-wide"><%= user.getNombor_kp() %></p>
    </div>

    <div class="mb-8">
        <h3 class="font-bold text-sm text-gray-800 mb-4 px-2">Portfolio</h3>
        <div class="p-5 rounded-[2rem] bg-indigo-50/50 border border-indigo-100 space-y-3">
            <div class="flex items-center gap-3">
                <i class="fas fa-check-circle text-brand-purple text-xs"></i>
                <span class="text-xs font-bold text-indigo-700">Pengurusan Fasiliti</span>
            </div>
            <div class="flex items-center gap-3">
                <i class="fas fa-check-circle text-brand-purple text-xs"></i>
                <span class="text-xs font-bold text-indigo-700">Aktiviti Sukan</span>
            </div>
            <div class="flex items-center gap-3">
                <i class="fas fa-check-circle text-brand-purple text-xs"></i>
                <span class="text-xs font-bold text-indigo-700">Riadah Komuniti</span>
            </div>
        </div>
    </div>

    <div class="mt-auto">
        <a href="<%= request.getContextPath() %>/logout" class="w-full bg-red-50 text-red-600 py-4 rounded-2xl text-sm font-bold hover:bg-red-100 transition flex items-center justify-center gap-2 border border-red-100 shadow-sm">
            <i class="fas fa-sign-out-alt"></i> Log Keluar
        </a>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>
