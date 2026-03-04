
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Papan Pemuka Ketua</h2>
            <p class="text-gray-500 text-sm">Ringkasan tadbir urus dan pengesahan permohonan.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-[#6C5DD3] shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari pemohon atau fail...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#2c3e50] to-[#4ca1af] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-gray-300 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-cyan-300">PENTADBIRAN</span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Datang, Tuan!</h1>
            <p class="text-gray-100 mb-6 text-sm opacity-90">
                Anda mempunyai <span class="font-bold text-white underline">3 permohonan</span> yang memerlukan sokongan dan pengesahan segera.
            </p>
            <div class="flex gap-3">
                <a href="<%= request.getContextPath() %>/bantuan/list" class="bg-white text-[#2c3e50] px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-gray-100 transition shadow-md flex items-center gap-2">
                    <i class="fas fa-pen-nib"></i> Sahkan Permohonan
                </a>
            </div>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-20 w-32 h-32 bg-cyan-900 opacity-20 rounded-full blur-2xl"></div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4 group">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 text-xl group-hover:bg-orange-500 group-hover:text-white transition">
                <i class="fas fa-stamp"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Menunggu Sokongan</p>
                <h3 class="text-xl font-bold text-gray-800">3</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4 group">
            <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-500 text-xl group-hover:bg-blue-500 group-hover:text-white transition">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Populasi Kampung</p>
                <h3 class="text-xl font-bold text-gray-800">1,240</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4 group">
            <div class="w-12 h-12 rounded-xl bg-purple-50 flex items-center justify-center text-purple-500 text-xl group-hover:bg-purple-500 group-hover:text-white transition">
                <i class="fas fa-bullhorn"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Hebahan Aktif</p>
                <h3 class="text-xl font-bold text-gray-800">2</h3>
            </div>
        </div>
    </div>

    <div class="flex justify-between items-end mb-6">
        <h3 class="font-bold text-xl text-gray-800">Menunggu Tindakan Tuan</h3>
        <a href="#" class="text-sm text-[#6C5DD3] font-medium hover:underline">Lihat Semua</a>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Pemohon</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Jenis Bantuan</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Tarikh Mohon</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-green-100 text-green-600 flex items-center justify-center font-bold text-xs">AB</div>
                                <div>
                                    <p class="text-sm font-bold text-gray-800">Abu Bakar</p>
                                    <p class="text-[10px] text-gray-500">Lorong Cempaka</p>
                                </div>
                            </div>
                        </td>
                        <td class="p-4 text-sm font-medium text-gray-600">Bantuan Bencana Alam</td>
                        <td class="p-4 text-sm text-gray-500">20 Jan 2026</td>
                        <td class="p-4 text-center">
                            <button class="text-[#6C5DD3] hover:bg-purple-50 px-3 py-1.5 rounded-lg text-xs font-bold transition border border-purple-200">
                                Semak
                            </button>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-xs">SS</div>
                                <div>
                                    <p class="text-sm font-bold text-gray-800">Siti Sarah</p>
                                    <p class="text-[10px] text-gray-500">Jalan Utama</p>
                                </div>
                            </div>
                        </td>
                        <td class="p-4 text-sm font-medium text-gray-600">Surat Sokongan Pendapatan</td>
                        <td class="p-4 text-sm text-gray-500">19 Jan 2026</td>
                        <td class="p-4 text-center">
                            <button class="text-[#6C5DD3] hover:bg-purple-50 px-3 py-1.5 rounded-lg text-xs font-bold transition border border-purple-200">
                                Semak
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-cog"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <img src="https://ui-avatars.com/api/?name=<%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "Ketua" %>&background=2c3e50&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "Ketua Kampung" %></h2>
        <p class="text-xs font-bold text-gray-500 mt-1">Mukim Danan</p>
    </div>

    <div class="mb-8">
        <div class="flex justify-between items-center mb-4">
            <h3 class="font-bold text-sm text-gray-800">Agenda Minggu Ini</h3>
        </div>
        
        <div class="space-y-4">
            <div class="flex gap-3 items-start p-3 rounded-xl bg-gray-50 border border-gray-100">
                <div class="bg-white p-2 rounded-lg text-center min-w-[50px] shadow-sm">
                    <span class="block text-xs text-red-500 font-bold uppercase">Sab</span>
                    <span class="block text-lg font-bold text-gray-800 leading-none">24</span>
                </div>
                <div>
                    <h4 class="text-sm font-bold text-gray-800">Mesyuarat JKKK</h4>
                    <p class="text-xs text-gray-500 mt-1">9:00 Pagi - Balai Raya</p>
                </div>
            </div>

            <div class="flex gap-3 items-start p-3 rounded-xl bg-gray-50 border border-gray-100">
                <div class="bg-white p-2 rounded-lg text-center min-w-[50px] shadow-sm">
                    <span class="block text-xs text-blue-500 font-bold uppercase">Aha</span>
                    <span class="block text-lg font-bold text-gray-800 leading-none">25</span>
                </div>
                <div>
                    <h4 class="text-sm font-bold text-gray-800">Gotong Royong</h4>
                    <p class="text-xs text-gray-500 mt-1">8:00 Pagi - Masjid</p>
                </div>
            </div>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4">Pautan Pantas</h3>
        <button class="w-full bg-[#6C5DD3] text-white py-3 rounded-xl text-sm font-bold shadow-md hover:bg-[#5b4eb8] transition mb-3 flex items-center justify-center gap-2">
            <i class="fas fa-bullhorn"></i> Buat Hebahan Baru
        </button>
        <button class="w-full bg-white border border-gray-200 text-gray-600 py-3 rounded-xl text-sm font-bold hover:bg-gray-50 transition flex items-center justify-center gap-2">
            <i class="fas fa-file-alt"></i> Laporan Bulanan
        </button>
    </div>

</aside>

<%@ include file="/views/common/footer.jsp" %>