
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Papan Pemuka</h2>
            <p class="text-gray-500 text-sm">Gambaran keseluruhan aktiviti kampung.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-purple-500 shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari pengumuman atau aktiviti...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-purple-200 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm">PENGUMUMAN UTAMA</span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Datang, Penduduk!</h1>
            <p class="text-purple-100 mb-6 text-sm opacity-90">
                Mesyuarat Agung PIBG akan diadakan pada sabtu ini. Sila semak jadual anda.
            </p>
            <button class="bg-white text-[#6C5DD3] px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-gray-50 transition shadow-md">
                Lihat Detail
            </button>
        </div>
        
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-20 w-32 h-32 bg-purple-900 opacity-20 rounded-full blur-2xl"></div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-red-50 flex items-center justify-center text-red-500 text-xl">
                <i class="fas fa-bell"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Notis Baru</p>
                <h3 class="text-xl font-bold text-gray-800">2</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-500 text-xl">
                <i class="fas fa-file-invoice-dollar"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Tunggakan</p>
                <h3 class="text-xl font-bold text-gray-800">RM 50.00</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm hover:shadow-md transition border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-green-50 flex items-center justify-center text-green-500 text-xl">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Aktiviti</p>
                <h3 class="text-xl font-bold text-gray-800">Gotong Royong</h3>
            </div>
        </div>
    </div>

    <div class="flex justify-between items-end mb-6">
        <h3 class="font-bold text-xl text-gray-800">Aktiviti Terkini</h3>
        <a href="#" class="text-sm text-[#6C5DD3] font-medium hover:underline">Lihat Semua</a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 pb-8">
        <div class="bg-white p-4 rounded-2xl shadow-sm border border-gray-50 flex gap-4">
            <div class="w-24 h-24 bg-gray-200 rounded-xl flex-shrink-0 bg-cover bg-center" style="background-image: url('https://source.unsplash.com/random/200x200/?community');"></div>
            <div class="flex-1 flex flex-col justify-center">
                <span class="text-[10px] font-bold text-orange-500 bg-orange-50 w-max px-2 py-1 rounded mb-2">SUKAN</span>
                <h4 class="font-bold text-gray-800 mb-1">Pertandingan Futsal Kampung</h4>
                <div class="flex items-center text-xs text-gray-400 gap-2">
                    <i class="far fa-clock"></i> 25 Feb 2024
                </div>
            </div>
        </div>
        
        <div class="bg-white p-4 rounded-2xl shadow-sm border border-gray-50 flex gap-4">
            <div class="w-24 h-24 bg-gray-200 rounded-xl flex-shrink-0 bg-cover bg-center" style="background-image: url('https://source.unsplash.com/random/200x200/?meeting');"></div>
            <div class="flex-1 flex flex-col justify-center">
                <span class="text-[10px] font-bold text-blue-500 bg-blue-50 w-max px-2 py-1 rounded mb-2">MESYUARAT</span>
                <h4 class="font-bold text-gray-800 mb-1">Taklimat Keselamatan</h4>
                <div class="flex items-center text-xs text-gray-400 gap-2">
                    <i class="far fa-clock"></i> 28 Feb 2024
                </div>
            </div>
        </div>
    </div>

</div> 


<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil Anda</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-pen"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <div class="absolute inset-0 border-2 border-dashed border-purple-300 rounded-full animate-spin-slow"></div>
            <img src="https://ui-avatars.com/api/?name=<%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "User" %>&background=6C5DD3&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= (user != null && user.getNamaPertama() != null) ? user.getNamaPertama() : "Penduduk" %></h2>
        <p class="text-sm text-gray-500 mb-6">No. 12, Lorong Cempaka</p>

        <div class="flex justify-center gap-4">
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-[#6C5DD3] hover:text-white transition flex items-center justify-center">
                <i class="fas fa-envelope"></i>
            </button>
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-[#6C5DD3] hover:text-white transition flex items-center justify-center">
                <i class="fas fa-bell"></i>
            </button>
        </div>
    </div>

    <div>
        <div class="flex justify-between items-center mb-6">
            <h3 class="font-bold text-sm text-gray-800">AJK Kawasan</h3>
            <button class="w-8 h-8 rounded-full border border-gray-200 flex items-center justify-center text-gray-400 hover:bg-gray-50">
                <i class="fas fa-plus text-xs"></i>
            </button>
        </div>

        <div class="space-y-5">
            <div class="flex items-center gap-3">
                <img src="https://ui-avatars.com/api/?name=Ketua+Kampung&background=random" class="w-10 h-10 rounded-full">
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-gray-800 truncate">En. Razak</p>
                    <p class="text-xs text-gray-500 truncate">Ketua Kampung</p>
                </div>
                <a href="tel:+60123456789" class="text-xs bg-purple-50 text-purple-600 px-3 py-1.5 rounded-full font-bold hover:bg-purple-100">
                    Call
                </a>
            </div>

            <div class="flex items-center gap-3">
                <img src="https://ui-avatars.com/api/?name=Siti+Aminah&background=random" class="w-10 h-10 rounded-full">
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-gray-800 truncate">Pn. Siti</p>
                    <p class="text-xs text-gray-500 truncate">Biro Wanita</p>
                </div>
                <a href="#" class="text-xs bg-purple-50 text-purple-600 px-3 py-1.5 rounded-full font-bold hover:bg-purple-100">
                    Msg
                </a>
            </div>
        </div>
    </div>
    
    <div class="mt-auto pt-8">
        <div class="bg-[#F7F7F9] p-4 rounded-2xl text-center">
            <p class="text-xs text-gray-500 mb-2">Perlukan Bantuan?</p>
            <button class="w-full bg-black text-white py-2 rounded-xl text-xs font-bold hover:bg-gray-800">
                Hubungi Admin
            </button>
        </div>
    </div>

</aside>

<%@ include file="/views/common/footer.jsp" %>