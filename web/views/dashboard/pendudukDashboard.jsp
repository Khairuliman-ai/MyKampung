<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.Hebahan" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. Dapatkan objek user dari session (currentUser)
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. Sekuriti: Redirect jika session tamat atau tidak sah
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }

    // 3. Dapatkan data dinamik yang disuntik oleh DashboardServlet
    List<Hebahan> latestHebahan = (List<Hebahan>) request.getAttribute("latestHebahan");
    List<Aduan> userAduan = (List<Aduan>) request.getAttribute("userAduan");
    List<PermohonanBantuan> userBantuan = (List<PermohonanBantuan>) request.getAttribute("userBantuan");
    List<TempahanFasiliti> userTempahan = (List<TempahanFasiliti>) request.getAttribute("userTempahan");
    List<Pengguna> ajkList = (List<Pengguna>) request.getAttribute("ajkList");

    Long pendingAduan = (Long) request.getAttribute("pendingAduan");
    if (pendingAduan == null) pendingAduan = 0L;

    Long activeTempahan = (Long) request.getAttribute("activeTempahan");
    if (activeTempahan == null) activeTempahan = 0L;

    Integer totalBantuan = (Integer) request.getAttribute("totalBantuan");
    if (totalBantuan == null) totalBantuan = 0;

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
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
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-purple-50 border border-purple-100 text-purple-600 text-[10px] font-extrabold uppercase tracking-widest">
                    <i class="fas fa-home"></i> Portal Penduduk
                </span>
                <h1 class="text-3xl font-black text-slate-800 tracking-tight mt-2">Selamat Pulang, <%= user.getNama_penuh() %></h1>
                <p class="text-slate-500 text-sm mt-0.5">Semak pengumuman kampung, mohon bantuan kebajikan, buat aduan keselamatan, dan tempah fasiliti awam.</p>
            </div>
            
            <div class="relative w-full md:w-80 group">
                <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400 group-focus-within:text-purple-600 transition-colors">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" 
                       class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border border-slate-200 focus:ring-4 focus:ring-purple-100 focus:border-purple-400 shadow-sm text-sm placeholder-gray-400 transition-all outline-none" 
                       placeholder="Cari pengumuman atau aduan...">
            </div>
        </header>

        <!-- Announcement Slider Hero Section -->
        <div class="relative mb-8 overflow-hidden rounded-[2.5rem] shadow-xl h-[380px] bg-gradient-to-r from-[#581C87] to-[#C026D3] group">
            <div id="announcementSlider" class="relative h-full w-full">
                <% if (latestHebahan != null && !latestHebahan.isEmpty()) { 
                    for (int i = 0; i < latestHebahan.size(); i++) {
                        Hebahan h = latestHebahan.get(i);
                        String bgImage = (h.getGambar_poster() != null && !h.getGambar_poster().isEmpty()) ? 
                            request.getContextPath() + "/file/hebahan/" + h.getGambar_poster() : "";
                %>
                    <!-- Slide <%= i %> -->
                    <div class="announcement-slide absolute inset-0 transition-all duration-1000 transform opacity-0 <%= i == 0 ? "opacity-100 scale-100 z-10" : "scale-105 pointer-events-none" %>" 
                         data-index="<%= i %>">
                        
                        <!-- Background image with zoom effect and overlay -->
                        <% if (!bgImage.isEmpty()) { %>
                            <div class="absolute inset-0 bg-cover bg-center transition-transform duration-[10s] ease-linear slide-zoom" style="background-image: url('<%= bgImage %>')"></div>
                            <div class="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-900/70 to-transparent"></div>
                        <% } else { %>
                            <div class="absolute inset-0 bg-gradient-to-r from-[#581C87]/90 via-[#7E22CE]/85 to-[#C026D3]/60"></div>
                        <% } %>

                        <!-- Slide Content -->
                        <div class="relative z-10 h-full flex flex-col justify-center px-8 md:px-16 max-w-2xl text-white">
                            <span class="bg-white/20 text-[9px] font-extrabold px-3 py-1 rounded-full backdrop-blur-md border border-white/10 uppercase tracking-widest w-max mb-4">
                                <i class="fas fa-bullhorn text-purple-300"></i> <%= h.getKategori() %>
                            </span>
                            <h1 class="text-3xl md:text-4xl font-black mb-3 leading-tight drop-shadow-md line-clamp-2"><%= h.getTajuk() %></h1>
                            <p class="text-purple-100 mb-6 text-xs md:text-sm opacity-90 line-clamp-2 leading-relaxed">
                                <%= h.getKandungan() %>
                            </p>
                            <div class="flex gap-3">
                                <a href="<%= request.getContextPath() %>/hebahan/list" class="bg-white text-purple-900 px-6 py-3 rounded-xl font-bold text-xs hover:bg-slate-100 hover:shadow-lg transition flex items-center gap-2">
                                    Baca Selengkapnya <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                <% } } else { %>
                    <!-- Fallback default slide -->
                    <div class="absolute inset-0 bg-gradient-to-r from-[#581C87]/90 via-[#7E22CE]/85 to-[#C026D3]/60 flex flex-col justify-center px-8 md:px-16 text-white">
                        <span class="bg-white/20 text-[9px] font-extrabold px-3 py-1 rounded-full backdrop-blur-md border border-white/10 uppercase tracking-widest w-max mb-4">PENGUMUMAN</span>
                        <h1 class="text-3xl md:text-4xl font-black mb-3 leading-tight">Selamat Datang ke MyKampung!</h1>
                        <p class="text-purple-100 mb-6 text-xs md:text-sm opacity-90 leading-relaxed max-w-md">
                            Tiada hebahan rasmi diterbitkan buat masa ini. Hubungi AJK Kampung anda jika mempunyai sebarang pertanyaan atau usul baharu.
                        </p>
                        <a href="<%= request.getContextPath() %>/views/profil/profilPenduduk.jsp" class="bg-white/20 hover:bg-white/30 text-white px-6 py-3 rounded-xl font-bold text-xs backdrop-blur-md transition-all border border-white/10 w-max">
                            Semak Profil
                        </a>
                    </div>
                <% } %>

                <!-- Navigation Dot Indicators -->
                <% if (latestHebahan != null && latestHebahan.size() > 1) { %>
                    <div class="absolute bottom-6 left-8 md:left-16 z-20 flex gap-2">
                        <% for (int i = 0; i < latestHebahan.size(); i++) { %>
                            <button onclick="goToSlide(<%= i %>)" class="slider-dot w-6 h-1 rounded-full bg-white/30 transition-all hover:bg-white/50 <%= i == 0 ? "bg-white !w-10" : "" %>" data-index="<%= i %>"></button>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <div class="absolute top-0 right-0 -mr-16 -mt-16 w-80 h-80 bg-white opacity-5 rounded-full blur-3xl pointer-events-none"></div>
        </div>

        <style>
            @keyframes slideZoom {
                from { transform: scale(1); }
                to { transform: scale(1.08); }
            }
            .announcement-slide.opacity-100 .slide-zoom {
                animation: slideZoom 10s linear forwards;
            }
        </style>

        <!-- 3-Column Statistics Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-orange-50 border border-orange-100 text-orange-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-bullhorn"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Hebahan Diterbitkan</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= latestHebahan != null ? latestHebahan.size() : 0 %> <span class="text-xs font-normal text-slate-400">aktif</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-red-50 border border-red-100 text-red-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Aduan Aktif Anda</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= pendingAduan %> <span class="text-xs font-normal text-slate-400">kes</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-blue-50 border border-blue-100 text-blue-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Tempahan Fasiliti Aktif</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= activeTempahan %> <span class="text-xs font-normal text-slate-400">slot</span></span>
                </div>
            </div>
        </div>

        <!-- Two Column Content Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            
            <!-- Welfare / Assistance Requests Summary -->
            <div class="glass-card rounded-[2.5rem] p-6 flex flex-col">
                <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100/50">
                    <div>
                        <h3 class="font-black text-base text-slate-800">Sejarah Permohonan Kebajikan Anda</h3>
                        <p class="text-[11px] text-slate-400">Semak status permohonan sumbangan atau bantuan kebajikan.</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/bantuan/mohon" class="px-3 py-1.5 bg-purple-50 hover:bg-purple-100 text-purple-700 rounded-xl text-[10px] font-black uppercase tracking-wider transition-all">Maju Mohon</a>
                </div>

                <div class="flex-1 overflow-y-auto max-h-[220px] custom-scrollbar pr-1">
                    <% if (userBantuan != null && !userBantuan.isEmpty()) { 
                        for (PermohonanBantuan pb : userBantuan) {
                    %>
                        <div class="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-100 hover:border-slate-200 transition mb-3">
                            <div>
                                <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest block"><%= pb.getJenis_bantuan() %></span>
                                <span class="text-xs font-bold text-slate-700 block mt-0.5"><%= pb.getCatatan_pemohon() != null && pb.getCatatan_pemohon().length() > 30 ? pb.getCatatan_pemohon().substring(0,30) + "..." : (pb.getCatatan_pemohon() != null ? pb.getCatatan_pemohon() : "Tiada catatan") %></span>
                            </div>
                            <span class="px-2 py-0.5 rounded text-[8px] font-extrabold uppercase tracking-wide
                                <%= "LULUS".equalsIgnoreCase(pb.getStatus()) ? "bg-green-100 text-green-700" :
                                    "TOLAK".equalsIgnoreCase(pb.getStatus()) ? "bg-red-100 text-red-700" : "bg-yellow-100 text-yellow-700" %>">
                                <%= pb.getStatus() %>
                            </span>
                        </div>
                    <% } } else { %>
                        <div class="py-10 text-center text-slate-400 opacity-60">
                            <i class="fas fa-hand-holding-heart text-2xl mb-2"></i>
                            <p class="text-xs font-bold italic">Tiada rekod permohonan bantuan.</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Facility Booking History -->
            <div class="glass-card rounded-[2.5rem] p-6 flex flex-col">
                <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100/50">
                    <div>
                        <h3 class="font-black text-base text-slate-800">Sejarah Tempahan Dewan/Fasiliti Anda</h3>
                        <p class="text-[11px] text-slate-400">Jadual tempahan slot dewan awam, sukan, atau kemudahan riadah.</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/tempahan/urus" class="px-3 py-1.5 bg-blue-50 hover:bg-blue-100 text-blue-700 rounded-xl text-[10px] font-black uppercase tracking-wider transition-all">Tempah Slot</a>
                </div>

                <div class="flex-1 overflow-y-auto max-h-[220px] custom-scrollbar pr-1">
                    <% if (userTempahan != null && !userTempahan.isEmpty()) { 
                        for (TempahanFasiliti tf : userTempahan) {
                    %>
                        <div class="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-100 hover:border-slate-200 transition mb-3">
                            <div>
                                <span class="text-xs font-bold text-slate-700 block"><%= tf.getNama_fasiliti() %></span>
                                <span class="text-[9px] text-slate-400 font-bold block mt-0.5"><i class="far fa-calendar-alt"></i> <%= tf.getTarikh_tempah() %> | <i class="far fa-clock"></i> <%= tf.getMasa_mula() %> - <%= tf.getMasa_tamat() %></span>
                            </div>
                            <span class="px-2 py-0.5 rounded text-[8px] font-extrabold uppercase tracking-wide
                                <%= "LULUS".equalsIgnoreCase(tf.getStatus()) ? "bg-green-100 text-green-700" :
                                    "TOLAK".equalsIgnoreCase(tf.getStatus()) ? "bg-red-100 text-red-700" : "bg-yellow-100 text-yellow-700" %>">
                                <%= tf.getStatus() %>
                            </span>
                        </div>
                    <% } } else { %>
                        <div class="py-10 text-center text-slate-400 opacity-60">
                            <i class="fas fa-calendar-times text-2xl mb-2"></i>
                            <p class="text-xs font-bold italic">Tiada slot fasiliti ditempah.</p>
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
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=6D28D9&color=fff&size=128" 
                     class="w-full h-full rounded-[2rem] object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-slate-800 tracking-tight"><%= user.getNama_penuh() %></h2>
        <p class="text-[10px] font-extrabold text-purple-600 bg-purple-50 border border-purple-100 px-3.5 py-1 rounded-full inline-block mt-2 uppercase tracking-wider">
            <%= (user.getNama_peranan() != null) ? user.getNama_peranan() : "Penduduk Kampung" %>
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

    <!-- Help & Contacts Card -->
    <div class="mt-auto">
        <h4 class="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest mb-3">Sokongan Kecemasan</h4>
        <div class="bg-gradient-to-br from-[#581C87] to-[#4A044E] rounded-3xl p-5 border border-white/5 relative overflow-hidden group">
            <i class="fas fa-phone-alt absolute -right-2 -bottom-2 text-purple-950 text-6xl opacity-40"></i>
            <p class="text-[11px] text-purple-200 leading-relaxed relative z-10 font-medium mb-3">
                Hubungi talian hotline keselamatan kampung atau ajukan aduan bertulis sekiranya terdapat masalah infrastruktur / keselamatan.
            </p>
            <a href="tel:999" class="inline-block bg-white text-[#581C87] text-[10px] font-black uppercase px-4 py-2 rounded-xl hover:bg-slate-100 transition shadow">Hubungi 999</a>
        </div>
        
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="w-full mt-6 bg-rose-50 text-rose-600 border border-rose-100 py-3.5 rounded-2xl text-xs font-black uppercase tracking-wider hover:bg-rose-600 hover:text-white hover:border-rose-600 transition-all flex items-center justify-center gap-2 shadow-sm">
            <i class="fas fa-sign-out-alt"></i> Log Keluar
        </a>
    </div>
</aside>

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.announcement-slide');
    const dots = document.querySelectorAll('.slider-dot');
    const totalSlides = slides.length;

    function showSlide(index) {
        if (totalSlides === 0) return;
        
        slides.forEach(s => {
            s.classList.remove('opacity-100', 'scale-100', 'z-10');
            s.classList.add('opacity-0', 'scale-105', 'pointer-events-none');
        });
        
        dots.forEach(d => {
            d.classList.remove('bg-white', '!w-10');
            d.classList.add('bg-white/30');
        });

        slides[index].classList.remove('opacity-0', 'scale-105', 'pointer-events-none');
        slides[index].classList.add('opacity-100', 'scale-100', 'z-10');
        
        if (dots[index]) {
            dots[index].classList.remove('bg-white/30');
            dots[index].classList.add('bg-white', '!w-10');
        }
        
        currentSlide = index;
    }

    function nextSlide() {
        if (totalSlides === 0) return;
        let next = (currentSlide + 1) % totalSlides;
        showSlide(next);
    }

    function goToSlide(index) {
        showSlide(index);
        resetTimer();
    }

    let slideTimer = setInterval(nextSlide, 5000);

    function resetTimer() {
        clearInterval(slideTimer);
        slideTimer = setInterval(nextSlide, 5000);
    }
</script>

<%@ include file="/views/common/footer.jsp" %>