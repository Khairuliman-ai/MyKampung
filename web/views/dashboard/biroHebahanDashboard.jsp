<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Selamat Datang, <%= user.getNama_penuh() %></h2>
        <p class="text-gray-500 text-sm">Dashboard Biro Hebahan Kampung Danan.</p>
    </div>

    <!-- Quick Stats & Actions -->
    <div class="space-y-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Card Urus Hebahan -->
            <a href="<%= request.getContextPath() %>/hebahan/list" class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm hover:shadow-md transition group">
                <div class="w-14 h-14 bg-purple-100 rounded-2xl flex items-center justify-center text-[#6C5DD3] text-2xl mb-6 group-hover:scale-110 transition">
                    <i class="fas fa-bullhorn"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Urus Hebahan</h3>
                <p class="text-gray-400 text-sm mb-6">Cipta, kemaskini, dan terbitkan pengumuman baru untuk penduduk.</p>
                <span class="text-[#6C5DD3] font-bold text-sm flex items-center gap-2">
                    Pergi ke Pengurusan <i class="fas fa-arrow-right"></i>
                </span>
            </a>

            <!-- Card Laporan -->
            <a href="<%= request.getContextPath() %>/views/common/dalamPembangunan.jsp?menu=analitik" class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm hover:shadow-md transition group opacity-75">
                <div class="w-14 h-14 bg-blue-100 rounded-2xl flex items-center justify-center text-blue-600 text-2xl mb-6 group-hover:scale-110 transition">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Analitik Hebahan</h3>
                <p class="text-gray-400 text-sm mb-6">Pantau keberkesanan hebahan dan jumlah capaian (Views).</p>
                <span class="text-blue-600 font-bold text-sm flex items-center gap-2">
                    Lihat Laporan <i class="fas fa-lock"></i>
                </span>
            </a>
        </div>

        <!-- Recent Activity Placeholder -->
        <div class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm">
            <h3 class="text-lg font-bold text-gray-800 mb-6">Aktiviti Terkini</h3>
            <div class="space-y-6">
                <div class="flex items-start gap-4">
                    <div class="w-2 h-2 rounded-full bg-[#6C5DD3] mt-2"></div>
                    <div>
                        <p class="text-sm font-bold text-gray-800">Modul Hebahan Baru Dilancarkan</p>
                        <p class="text-xs text-gray-400">Anda kini boleh mula menguruskan pengumuman rasmi.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil Biro</h3>
        <a href="<%= request.getContextPath() %>/profil/view" class="text-gray-400 hover:text-[#6C5DD3] transition"><i class="fas fa-edit"></i></a>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <% if (user.getFoto_profil() != null && !user.getFoto_profil().isEmpty() && !user.getFoto_profil().equals("default_avatar.png")) { %>
                <img src="<%= request.getContextPath() %>/file/profil/<%= user.getFoto_profil() %>" 
                     class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=6C5DD3&color=fff&size=128" 
                     class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-xs font-bold text-[#6C5DD3] bg-purple-50 px-4 py-1.5 rounded-full inline-block mt-2 uppercase tracking-tight">
            <%= (user.getNama_jawatan() != null) ? user.getNama_jawatan() : "Biro Hebahan" %>
        </p>
    </div>

    <div class="bg-[#6C5DD3] p-8 rounded-[32px] text-white shadow-lg shadow-purple-100 mb-8">
        <h3 class="text-lg font-bold mb-4">Tips Hebahan</h3>
        <p class="text-purple-100 text-sm leading-relaxed mb-6">
            Pastikan maklumat kecemasan menggunakan kategori <strong>Kecemasan</strong> supaya ia dipaparkan di bahagian paling atas untuk penduduk.
        </p>
        <div class="bg-white/10 p-4 rounded-2xl text-center">
            <p class="text-xs font-bold uppercase mb-1">Status Biro</p>
            <p class="text-sm">AKTIF & BEROPERASI</p>
        </div>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>
