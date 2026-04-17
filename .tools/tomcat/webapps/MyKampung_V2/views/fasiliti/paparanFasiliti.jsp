<%@ page import="model.Pengguna" %>
<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. Sekuriti: Jika user cuba akses terus tanpa login
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#FBFAFF]">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Kemudahan & Fasiliti</h2>
            <p class="text-gray-500 text-sm">Tempah fasiliti kampung dengan mudah secara atas talian.</p>
        </div>
        
        <div class="flex items-center gap-3 w-full md:w-auto">
            <div class="relative flex-1 md:w-80">
                <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" 
                       class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-purple-500 shadow-sm text-sm" 
                       placeholder="Cari fasiliti (cth: Dewan)...">
            </div>
            <button class="bg-[#6C5DD3] text-white p-3.5 rounded-2xl shadow-lg shadow-purple-200 hover:bg-[#5a4cb3] transition">
                <i class="fas fa-plus"></i>
            </button>
        </div>
    </header>

    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50">
            <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Tersedia</p>
            <h3 class="text-xl font-bold text-gray-800">12</h3>
        </div>
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50">
            <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Tempahan Saya</p>
            <h3 class="text-xl font-bold text-purple-600">3</h3>
        </div>
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50">
            <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Menunggu</p>
            <h3 class="text-xl font-bold text-orange-500">1</h3>
        </div>
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50">
            <p class="text-[10px] text-gray-400 font-bold uppercase mb-1">Dibatalkan</p>
            <h3 class="text-xl font-bold text-red-500">0</h3>
        </div>
    </div>

    <div class="flex justify-between items-center mb-6">
        <h3 class="font-bold text-xl text-gray-800">Senarai Fasiliti</h3>
        <div class="flex gap-2">
            <button class="px-4 py-1.5 bg-purple-100 text-[#6C5DD3] rounded-full text-xs font-bold">Semua</button>
            <button class="px-4 py-1.5 bg-white text-gray-400 rounded-full text-xs font-bold hover:bg-gray-50">Sukan</button>
            <button class="px-4 py-1.5 bg-white text-gray-400 rounded-full text-xs font-bold hover:bg-gray-50">Dewan</button>
        </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 pb-10">
        
        <div class="group bg-white rounded-[2rem] overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-gray-50">
            <div class="relative h-48 bg-gray-200">
                <img src="https://images.unsplash.com/photo-1574629810360-7efbbe195018?auto=format&fit=crop&q=80&w=400" class="w-full h-full object-cover">
                <div class="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-xl shadow-sm">
                    <span class="text-[10px] font-bold text-green-600 uppercase">Tersedia</span>
                </div>
            </div>
            <div class="p-6">
                <div class="flex justify-between items-start mb-2">
                    <div>
                        <h4 class="font-bold text-gray-800 text-lg">Gelanggang Futsal</h4>
                        <p class="text-xs text-gray-400"><i class="fas fa-map-marker-alt mr-1"></i> Zon A, Simpang Tiga</p>
                    </div>
                </div>
                <div class="flex items-center gap-4 my-4 text-xs text-gray-500">
                    <span class="flex items-center gap-1"><i class="fas fa-users"></i> 12 Pax</span>
                    <span class="flex items-center gap-1"><i class="fas fa-clock"></i> 8AM - 11PM</span>
                </div>
                <div class="flex items-center justify-between mt-6 pt-6 border-t border-gray-50">
                    <div>
                        <p class="text-[10px] text-gray-400 font-bold uppercase">Kadar Sewa</p>
                        <p class="text-lg font-bold text-gray-800">RM 20<span class="text-xs font-normal text-gray-400">/jam</span></p>
                    </div>
                    <button class="bg-[#6C5DD3] text-white px-5 py-2.5 rounded-xl font-bold text-xs hover:bg-[#5a4cb3] transition-all transform group-hover:scale-105">
                        Tempah Sekarang
                    </button>
                </div>
            </div>
        </div>

        <div class="group bg-white rounded-[2rem] overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-gray-50">
            <div class="relative h-48 bg-gray-200">
                <img src="https://images.unsplash.com/photo-1517457373958-b7bdd4587205?auto=format&fit=crop&q=80&w=400" class="w-full h-full object-cover">
                <div class="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-xl shadow-sm">
                    <span class="text-[10px] font-bold text-orange-600 uppercase">Penuh</span>
                </div>
            </div>
            <div class="p-6">
                <div class="flex justify-between items-start mb-2">
                    <div>
                        <h4 class="font-bold text-gray-800 text-lg">Dewan Serbaguna</h4>
                        <p class="text-xs text-gray-400"><i class="fas fa-map-marker-alt mr-1"></i> Bersebelahan Masjid</p>
                    </div>
                </div>
                <div class="flex items-center gap-4 my-4 text-xs text-gray-500">
                    <span class="flex items-center gap-1"><i class="fas fa-users"></i> 300 Pax</span>
                    <span class="flex items-center gap-1"><i class="fas fa-bolt"></i> Elektrik Disediakan</span>
                </div>
                <div class="flex items-center justify-between mt-6 pt-6 border-t border-gray-50">
                    <div>
                        <p class="text-[10px] text-gray-400 font-bold uppercase">Kadar Sewa</p>
                        <p class="text-lg font-bold text-gray-800">RM 150<span class="text-xs font-normal text-gray-400">/hari</span></p>
                    </div>
                    <button class="bg-gray-100 text-gray-400 px-5 py-2.5 rounded-xl font-bold text-xs cursor-not-allowed">
                        Lihat Jadual
                    </button>
                </div>
            </div>
        </div>

    </div>
</div>

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Rekod Tempahan</h3>
        <button class="text-[#6C5DD3] text-xs font-bold hover:underline">Lihat Semua</button>
    </div>

    <div class="space-y-6">
        <div class="flex gap-3">
            <div class="w-10 h-10 rounded-xl bg-purple-50 text-[#6C5DD3] flex items-center justify-center flex-shrink-0 text-sm">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <div>
                <p class="text-sm font-bold text-gray-800 line-clamp-1">Futsal - Slot Petang</p>
                <p class="text-[10px] text-gray-400">20 Mac 2026 ? 5:00 PM</p>
                <span class="inline-block mt-1 text-[9px] font-bold text-green-500 bg-green-50 px-2 py-0.5 rounded">Berjaya</span>
            </div>
        </div>

        <div class="flex gap-3">
            <div class="w-10 h-10 rounded-xl bg-orange-50 text-orange-500 flex items-center justify-center flex-shrink-0 text-sm">
                <i class="fas fa-hourglass-half"></i>
            </div>
            <div>
                <p class="text-sm font-bold text-gray-800 line-clamp-1">Dewan - Kenduri</p>
                <p class="text-[10px] text-gray-400">15 Mei 2026 ? 8:00 AM</p>
                <span class="inline-block mt-1 text-[9px] font-bold text-orange-500 bg-orange-50 px-2 py-0.5 rounded">Processing</span>
            </div>
        </div>
    </div>

    <div class="mt-auto pt-8">
        <div class="bg-gradient-to-br from-[#6C5DD3] to-[#8B7EF8] p-6 rounded-[2rem] text-white relative overflow-hidden shadow-lg shadow-purple-200">
            <div class="relative z-10">
                <p class="text-xs font-medium opacity-80 mb-1">Ada Masalah?</p>
                <h4 class="font-bold mb-4">Hubungi Biro Pembangunan</h4>
                <button class="w-full bg-white text-[#6C5DD3] py-2.5 rounded-xl text-xs font-bold hover:bg-gray-50 transition">
                    WhatsApp Sekarang
                </button>
            </div>
            <div class="absolute -bottom-4 -right-4 w-20 h-20 bg-white/10 rounded-full blur-xl"></div>
        </div>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>