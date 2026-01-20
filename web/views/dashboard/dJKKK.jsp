
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Dashboard JKKK</h2>
            <p class="text-gray-500 text-sm">Pantau aktiviti kampung dan uruskan permohonan.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-[#6C5DD3] shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari penduduk, fail, atau aduan...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#1f2937] to-[#4b5563] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-gray-300 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-yellow-300">MOD PENTADBIR</span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Bertugas, Tuan!</h1>
            <p class="text-gray-200 mb-6 text-sm opacity-90">
                Terdapat <span class="font-bold text-white underline">5 permohonan bantuan</span> baru yang memerlukan pengesahan anda hari ini.
            </p>
            <div class="flex gap-3">
                <a href="<%= request.getContextPath() %>/bantuan/list" class="bg-white text-gray-900 px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-gray-100 transition shadow-md">
                    Semak Permohonan
                </a>
            </div>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-5 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-20 w-32 h-32 bg-gray-900 opacity-20 rounded-full blur-2xl"></div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-purple-50 flex items-center justify-center text-[#6C5DD3] text-xl">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Jumlah Penduduk</p>
                <h3 class="text-xl font-bold text-gray-800">1,240</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 text-xl">
                <i class="fas fa-file-signature"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Permohonan Baru</p>
                <h3 class="text-xl font-bold text-gray-800">5</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-red-50 flex items-center justify-center text-red-500 text-xl">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Aduan Tertunggak</p>
                <h3 class="text-xl font-bold text-gray-800">3</h3>
            </div>
        </div>
    </div>

    <div class="flex justify-between items-end mb-6">
        <h3 class="font-bold text-xl text-gray-800">Perlu Tindakan Segera</h3>
        <a href="#" class="text-sm text-[#6C5DD3] font-medium hover:underline">Lihat Semua</a>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Pemohon</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Jenis Permohonan</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Tarikh</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase text-center">Status</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <img src="https://ui-avatars.com/api/?name=Abu+Bakar&background=random" class="w-8 h-8 rounded-full">
                                <span class="text-sm font-bold text-gray-700">Abu Bakar</span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-600">Bantuan Banjir (NADMA)</td>
                        <td class="p-4 text-sm text-gray-500">Hari ini, 10:30 AM</td>
                        <td class="p-4 text-center">
                            <span class="px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-xs font-bold">Baru</span>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <img src="https://ui-avatars.com/api/?name=Siti+Sarah&background=random" class="w-8 h-8 rounded-full">
                                <span class="text-sm font-bold text-gray-700">Siti Sarah</span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-600">Pengesahan Pendapatan</td>
                        <td class="p-4 text-sm text-gray-500">Semalam, 2:15 PM</td>
                        <td class="p-4 text-center">
                            <span class="px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-xs font-bold">Baru</span>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <img src="https://ui-avatars.com/api/?name=Muthu+Samy&background=random" class="w-8 h-8 rounded-full">
                                <span class="text-sm font-bold text-gray-700">Muthu Samy</span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-600">Aduan Jalan Rosak</td>
                        <td class="p-4 text-sm text-gray-500">20 Jan 2026</td>
                        <td class="p-4 text-center">
                            <span class="px-3 py-1 rounded-full bg-blue-100 text-blue-700 text-xs font-bold">Dalam Proses</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil JKKK</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-cog"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <img src="https://ui-avatars.com/api/?name=<%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "Admin" %>&background=1f2937&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "Admin" %></h2>
        <p class="text-xs font-bold text-[#6C5DD3] bg-purple-50 px-3 py-1 rounded-full inline-block mt-1">Setiausaha JKKK</p>

        <div class="flex justify-center gap-4 mt-6">
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-gray-800 hover:text-white transition flex items-center justify-center" title="Mesyuarat">
                <i class="fas fa-calendar-alt"></i>
            </button>
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-gray-800 hover:text-white transition flex items-center justify-center" title="Laporan">
                <i class="fas fa-chart-pie"></i>
            </button>
        </div>
    </div>

    <div class="mb-8">
        <div class="flex justify-between items-center mb-4">
            <h3 class="font-bold text-sm text-gray-800">Dana Kampung</h3>
            <span class="text-xs text-gray-400">Jan 2026</span>
        </div>
        <div class="bg-gray-50 p-4 rounded-2xl">
            <div class="flex justify-between items-end mb-2">
                <div>
                    <p class="text-xs text-gray-500">Baki Semasa</p>
                    <h4 class="font-bold text-lg text-gray-800">RM 4,500</h4>
                </div>
                <div class="text-green-500 text-xs font-bold bg-green-100 px-2 py-1 rounded-md">
                    +12%
                </div>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-1.5 mt-2">
                <div class="bg-[#6C5DD3] h-1.5 rounded-full" style="width: 65%"></div>
            </div>
            <p class="text-[10px] text-gray-400 mt-2 text-right">Sasaran: RM 7,000</p>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4">Ahli Jawatankuasa</h3>
        <div class="space-y-4">
            <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-bold text-xs">P</div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-gray-800 truncate">Hj. Razak</p>
                    <p class="text-xs text-gray-500 truncate">Penghulu</p>
                </div>
                <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-phone"></i></button>
            </div>
             <div class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-600 font-bold text-xs">B</div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-gray-800 truncate">En. Kamal</p>
                    <p class="text-xs text-gray-500 truncate">Bendahari</p>
                </div>
                <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-phone"></i></button>
            </div>
        </div>
    </div>

</aside>

<%@ include file="/views/common/footer.jsp" %>