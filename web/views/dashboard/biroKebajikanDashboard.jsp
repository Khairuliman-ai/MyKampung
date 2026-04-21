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
            <h2 class="text-2xl font-bold text-gray-800">Dashboard Biro Kebajikan</h2>
            <p class="text-gray-500 text-sm">Pantau kebajikan penduduk dan uruskan bantuan sosial.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-[#6C5DD3] shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari permohonan, bantuan, atau asnaf...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#0d9488] to-[#14b8a6] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-teal-100 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-teal-100 uppercase tracking-wider">BIRO KEBAJIKAN & SOSIAL</span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Bertugas, <%= user.getNama_penuh() %>!</h1>
            <p class="text-teal-50 mb-6 text-sm opacity-90">
                Amanah anda adalah memastikan tiada penduduk yang ketinggalan dalam menerima bantuan sewajarnya.
            </p>
            <div class="flex gap-3">
                <a href="<%= request.getContextPath() %>/views/bantuan/urusBantuanAJK.jsp" class="bg-white text-teal-700 px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-teal-50 transition shadow-md">
                    Urus Bantuan
                </a>
            </div>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-20 w-32 h-32 bg-teal-900 opacity-20 rounded-full blur-2xl"></div>
    </div>

    <%-- Statistik Ringkas --%>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-teal-50 flex items-center justify-center text-teal-600 text-xl">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Jenis Bantuan</p>
                <h3 class="text-xl font-bold text-gray-800">8</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 text-xl">
                <i class="fas fa-file-invoice"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Permohonan Baru</p>
                <h3 class="text-xl font-bold text-gray-800">12</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-500 text-xl">
                <i class="fas fa-user-check"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Penerima Aktif</p>
                <h3 class="text-xl font-bold text-gray-800">45</h3>
            </div>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <%-- Senarai Permohonan Terkini --%>
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="p-6 border-b border-gray-50 flex justify-between items-center">
                <h3 class="font-bold text-gray-800">Permohonan Menunggu Pengesahan</h3>
                <a href="<%= request.getContextPath() %>/views/bantuan/urusBantuanAJK.jsp" class="text-xs text-[#6C5DD3] font-bold">Lihat Semua</a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <tbody class="divide-y divide-gray-50">
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center font-bold text-xs">A</div>
                                    <div>
                                        <p class="text-sm font-bold text-gray-700">Aminah Hassan</p>
                                        <p class="text-[10px] text-gray-400">Bantuan Sara Hidup</p>
                                    </div>
                                </div>
                            </td>
                            <td class="p-4 text-right text-xs text-gray-400">2 jam lalu</td>
                        </tr>
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-xs">K</div>
                                    <div>
                                        <p class="text-sm font-bold text-gray-700">Kamal Mustafa</p>
                                        <p class="text-[10px] text-gray-400">Bantuan Bencana</p>
                                    </div>
                                </div>
                            </td>
                            <td class="p-4 text-right text-xs text-gray-400">5 jam lalu</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- Menu Pantas --%>
        <div class="space-y-6">
            <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100">
                <h3 class="font-bold text-gray-800 mb-4">Navigasi Pantas</h3>
                <div class="grid grid-cols-2 gap-4">
                    <a href="<%= request.getContextPath() %>/profil/view" class="p-4 rounded-2xl bg-gray-50 hover:bg-[#6C5DD3] hover:text-white transition group">
                        <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-[#6C5DD3] mb-3 group-hover:bg-white/20 group-hover:text-white">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <p class="text-sm font-bold">Kemaskini Profil</p>
                        <p class="text-[10px] opacity-60">Maklumat peribadi</p>
                    </a>
                    <a href="<%= request.getContextPath() %>/views/bantuan/urusBantuanAJK.jsp" class="p-4 rounded-2xl bg-gray-50 hover:bg-teal-600 hover:text-white transition group">
                        <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-teal-600 mb-3 group-hover:bg-white/20 group-hover:text-white">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <p class="text-sm font-bold">Urus Bantuan</p>
                        <p class="text-[10px] opacity-60">Senarai permohonan</p>
                    </a>
                </div>
            </div>
        </div>
    </div>

</div> 

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
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=0d9488&color=fff&size=128" 
                     class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-xs font-bold text-teal-600 bg-teal-50 px-4 py-1.5 rounded-full inline-block mt-2 uppercase tracking-tight">
            <%= (user.getNama_jawatan() != null) ? user.getNama_jawatan() : "Biro Kebajikan" %>
        </p>
    </div>

    <div class="mb-8">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-wider">Peruntukan Biro</h3>
        <div class="bg-gray-50 p-5 rounded-3xl border border-gray-100">
            <div class="flex justify-between items-center mb-3">
                <span class="text-xs text-gray-500 font-medium">Baki Dana</span>
                <span class="text-[10px] text-teal-600 font-bold bg-teal-100 px-2 py-0.5 rounded">AKTIF</span>
            </div>
            <h4 class="text-2xl font-bold text-gray-800 mb-1">RM 12,450</h4>
            <p class="text-[10px] text-gray-400">Kemaskini: 2 jam yang lalu</p>
            
            <div class="mt-4 pt-4 border-t border-gray-200">
                <div class="flex justify-between text-xs mb-1">
                    <span class="text-gray-500">Penggunaan</span>
                    <span class="font-bold text-gray-700">45%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-1.5">
                    <div class="bg-teal-500 h-1.5 rounded-full" style="width: 45%"></div>
                </div>
            </div>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-wider">Tugasan Hari Ini</h3>
        <div class="space-y-3">
            <div class="flex items-center gap-3 p-3 rounded-2xl bg-orange-50 border border-orange-100">
                <div class="w-8 h-8 rounded-full bg-white flex items-center justify-center text-orange-500 shadow-sm">
                    <i class="fas fa-check-circle text-xs"></i>
                </div>
                <p class="text-[11px] font-bold text-orange-700">Sahkan 12 permohonan baru</p>
            </div>
            <div class="flex items-center gap-3 p-3 rounded-2xl bg-blue-50 border border-blue-100">
                <div class="w-8 h-8 rounded-full bg-white flex items-center justify-center text-blue-500 shadow-sm">
                    <i class="fas fa-calendar-alt text-xs"></i>
                </div>
                <p class="text-[11px] font-bold text-blue-700">Lawatan ke rumah asnaf</p>
            </div>
        </div>
    </div>

</aside>

<%@ include file="/views/common/footer.jsp" %>
