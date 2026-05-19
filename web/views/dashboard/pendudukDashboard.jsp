<%@ page import="model.Pengguna, model.Hebahan, model.Aduan, model.PermohonanBantuan, model.TempahanFasiliti, java.util.List, java.text.SimpleDateFormat" %>
<%
    // 1. Dapatkan objek user dari session (Guna 'currentUser' supaya selaras dengan Servlet)
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. Sekuriti: Jika user cuba akses terus tanpa login
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }

    // 3. Dapatkan data dari request attributes (set oleh DashboardServlet)
    List<Hebahan> latestHebahan = (List<Hebahan>) request.getAttribute("latestHebahan");
    List<Aduan> userAduan = (List<Aduan>) request.getAttribute("userAduan");
    List<PermohonanBantuan> userBantuan = (List<PermohonanBantuan>) request.getAttribute("userBantuan");
    List<TempahanFasiliti> userTempahan = (List<TempahanFasiliti>) request.getAttribute("userTempahan");
    List<Pengguna> ajkList = (List<Pengguna>) request.getAttribute("ajkList");

    Long pendingAduan = (Long) request.getAttribute("pendingAduan");
    Long activeTempahan = (Long) request.getAttribute("activeTempahan");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 p-4 md:p-8 scroll-smooth h-auto xl:h-full xl:overflow-y-auto">

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

    <!-- Announcement Carousel -->
    <div class="relative mb-8 group">
        <div id="announcementSlider" class="relative rounded-[2.5rem] overflow-hidden shadow-xl shadow-purple-100 h-[400px]">
            <% if (latestHebahan != null && !latestHebahan.isEmpty()) { 
                for (int i = 0; i < latestHebahan.size(); i++) {
                    Hebahan h = latestHebahan.get(i);
                    String bgImage = (h.getGambar_poster() != null) ? 
                        request.getContextPath() + "/file/hebahan/" + h.getGambar_poster() : "";
            %>
                <!-- Slide <%= i %> -->
                <div class="announcement-slide absolute inset-0 transition-all duration-1000 transform opacity-0 <%= i == 0 ? "opacity-100 scale-100 z-10" : "scale-105" %>" 
                     data-index="<%= i %>">
                    
                    <!-- Background with Overlay -->
                    <% if (!bgImage.isEmpty()) { %>
                        <div class="absolute inset-0 bg-cover bg-center transition-transform duration-[10s] ease-linear slide-zoom" style="background-image: url('<%= bgImage %>')"></div>
                        <div class="absolute inset-0 bg-gradient-to-r from-gray-900 via-gray-900/60 to-transparent"></div>
                    <% } else { %>
                        <div class="absolute inset-0 bg-gradient-to-r from-brand-purple to-brand-secondary"></div>
                    <% } %>

                    <!-- Content -->
                    <div class="relative z-10 h-full flex flex-col justify-center px-12 md:px-16 max-w-3xl">
                        <span class="bg-white/20 text-[10px] font-bold px-4 py-1.5 rounded-full backdrop-blur-md border border-white/10 uppercase tracking-widest w-max mb-6">PENGUMUMAN TERKINI</span>
                        <h1 class="text-4xl md:text-5xl font-extrabold text-white mb-4 leading-tight drop-shadow-lg"><%= h.getTajuk() %></h1>
                        <p class="text-purple-50 mb-8 text-sm md:text-base opacity-90 line-clamp-2 max-w-xl drop-shadow-md">
                            <%= h.getKandungan() %>
                        </p>
                        <div class="flex gap-4">
                            <a href="<%= request.getContextPath() %>/hebahan/list" class="bg-white text-brand-purple px-8 py-3.5 rounded-2xl font-bold text-sm hover:shadow-xl hover:-translate-y-1 transition-all shadow-md flex items-center gap-2">
                                Baca Selengkapnya <i class="fas fa-arrow-right text-xs"></i>
                            </a>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <!-- Default Slide if no data -->
                <div class="absolute inset-0 bg-gradient-to-r from-brand-purple to-brand-secondary flex flex-col justify-center px-12 md:px-16">
                    <span class="bg-white/20 text-[10px] font-bold px-4 py-1.5 rounded-full backdrop-blur-md border border-white/10 uppercase tracking-widest w-max mb-6">SELAMAT DATANG</span>
                    <h1 class="text-4xl font-bold text-white mb-4 leading-tight">Selamat Datang, <%= user.getNama_penuh() %>!</h1>
                    <p class="text-purple-100 mb-8 text-sm opacity-90">Tiada hebahan baru buat masa ini. Sila semak profil anda untuk maklumat terkini.</p>
                    <a href="<%= request.getContextPath() %>/views/profil/profilPenduduk.jsp" class="bg-white/20 hover:bg-white/30 text-white px-8 py-3.5 rounded-2xl font-bold text-sm backdrop-blur-md transition-all border border-white/10 w-max">
                        Lihat Profil
                    </a>
                </div>
            <% } %>

            <!-- Dot Indicators -->
            <% if (latestHebahan != null && latestHebahan.size() > 1) { %>
                <div class="absolute bottom-8 left-12 md:left-16 z-20 flex gap-2">
                    <% for (int i = 0; i < latestHebahan.size(); i++) { %>
                        <button onclick="goToSlide(<%= i %>)" class="slider-dot w-8 h-1.5 rounded-full bg-white/30 transition-all hover:bg-white/50 <%= i == 0 ? "bg-white !w-12" : "" %>" data-index="<%= i %>"></button>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- Decorative Elements -->
        <div class="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 bg-white opacity-5 rounded-full blur-3xl pointer-events-none"></div>
    </div>

    <style>
        @keyframes slideZoom {
            from { transform: scale(1); }
            to { transform: scale(1.1); }
        }
        .announcement-slide.opacity-100 .slide-zoom {
            animation: slideZoom 10s linear forwards;
        }
    </style>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
        <!-- Stat: Hebahan -->
        <a href="<%= request.getContextPath() %>/hebahan/list" class="group bg-white p-6 rounded-3xl shadow-sm hover:shadow-xl transition-all border border-gray-50 flex items-center gap-5">
            <div class="w-14 h-14 rounded-2xl bg-orange-50 text-orange-500 flex items-center justify-center text-2xl group-hover:scale-110 transition-transform">
                <i class="fas fa-bullhorn"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Hebahan Baru</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= latestHebahan != null ? latestHebahan.size() : 0 %></h3>
            </div>
        </a>

        <!-- Stat: Aduan -->
        <a href="<%= request.getContextPath() %>/aduan/list" class="group bg-white p-6 rounded-3xl shadow-sm hover:shadow-xl transition-all border border-gray-50 flex items-center gap-5">
            <div class="w-14 h-14 rounded-2xl bg-red-50 text-red-500 flex items-center justify-center text-2xl group-hover:scale-110 transition-transform">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Aduan Aktif</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= pendingAduan != null ? pendingAduan : 0 %></h3>
            </div>
        </a>

        <!-- Stat: Fasiliti -->
        <a href="<%= request.getContextPath() %>/fasiliti/tempahan" class="group bg-white p-6 rounded-3xl shadow-sm hover:shadow-xl transition-all border border-gray-50 flex items-center gap-5">
            <div class="w-14 h-14 rounded-2xl bg-blue-50 text-blue-500 flex items-center justify-center text-2xl group-hover:scale-110 transition-transform">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Tempahan Aktif</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= activeTempahan != null ? activeTempahan : 0 %></h3>
            </div>
        </a>
    </div>

    <div class="flex justify-between items-end mb-6">
        <h3 class="font-bold text-xl text-gray-800">Aktiviti Terkini</h3>
        <a href="#" class="text-sm text-brand-purple font-medium hover:underline">Lihat Semua</a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 pb-8">
        <% if (latestHebahan != null && latestHebahan.size() > 1) { 
            for (int i = 1; i < latestHebahan.size(); i++) {
                Hebahan h = latestHebahan.get(i);
        %>
            <a href="<%= request.getContextPath() %>/hebahan/list" class="bg-white p-5 rounded-[2rem] shadow-sm hover:shadow-xl transition-all border border-gray-50 flex gap-5 group">
                <div class="w-24 h-24 bg-gray-100 rounded-2xl flex-shrink-0 overflow-hidden">
                    <% if (h.getGambar_poster() != null) { %>
                        <img src="<%= request.getContextPath() %>/file/hebahan/<%= h.getGambar_poster() %>" class="w-full h-full object-cover group-hover:scale-110 transition duration-500">
                    <% } else { %>
                        <div class="w-full h-full bg-brand-purple/10 flex items-center justify-center text-brand-purple">
                            <i class="<%= h.getKategoriIcon() %> text-3xl"></i>
                        </div>
                    <% } %>
                </div>
                <div class="flex-1 flex flex-col justify-center min-w-0">
                    <span class="text-[9px] font-bold px-2 py-1 rounded mb-2 w-max <%= h.getKategoriBadgeClass() %>"><%= h.getKategori().toUpperCase() %></span>
                    <h4 class="font-bold text-gray-800 mb-2 truncate group-hover:text-brand-purple transition-colors"><%= h.getTajuk() %></h4>
                    <div class="flex items-center text-xs text-gray-400 gap-3">
                        <span class="flex items-center gap-1"><i class="far fa-calendar"></i> <%= h.getTarikh_hebahan() != null ? sdf.format(h.getTarikh_hebahan()) : "-" %></span>
                    </div>
                </div>
            </a>
        <% } } else if (userAduan != null && !userAduan.isEmpty()) { 
            for (int i = 0; i < Math.min(2, userAduan.size()); i++) {
                Aduan a = userAduan.get(i);
        %>
            <a href="<%= request.getContextPath() %>/aduan/list" class="bg-white p-5 rounded-[2rem] shadow-sm hover:shadow-xl transition-all border border-gray-50 flex gap-5 group">
                <div class="w-24 h-24 bg-red-50 rounded-2xl flex-shrink-0 flex items-center justify-center text-red-500">
                    <i class="fas fa-exclamation-triangle text-3xl"></i>
                </div>
                <div class="flex-1 flex flex-col justify-center min-w-0">
                    <span class="text-[9px] font-bold text-red-600 bg-red-50 px-2 py-1 rounded mb-2 w-max uppercase">ADUAN ANDA</span>
                    <h4 class="font-bold text-gray-800 mb-2 truncate"><%= a.getTajuk() %></h4>
                    <div class="flex items-center text-xs text-gray-400 gap-3">
                        <span class="flex items-center gap-1 font-bold <%= "RESOLVED".equals(a.getStatus()) ? "text-green-500" : "text-orange-500" %>">
                            <i class="fas fa-circle text-[8px]"></i> <%= a.getStatus() %>
                        </span>
                    </div>
                </div>
            </a>
        <% } } else { %>
            <div class="lg:col-span-2 py-10 text-center bg-gray-50 rounded-[2rem] border border-dashed border-gray-200">
                <p class="text-sm text-gray-400">Tiada aktiviti terbaru ditemui.</p>
            </div>
        <% } %>
    </div>

</div> 


<aside class="w-full xl:w-80 bg-white border-t xl:border-t-0 xl:border-l border-gray-100 flex flex-col p-8 flex-shrink-0">
    
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil Anda</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-pen"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <div class="absolute inset-0 border-2 border-dashed border-purple-300 rounded-full animate-spin-slow"></div>
            <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=6C5DD3&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-sm text-gray-500 mb-6"><%= user.getNama_jalan() %>, <%= user.getBandar() %></p>

        <div class="flex justify-center gap-4">
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-brand-purple hover:text-white transition flex items-center justify-center">
                <i class="fas fa-envelope"></i>
            </button>
            <button class="w-10 h-10 rounded-full bg-gray-50 text-gray-500 hover:bg-brand-purple hover:text-white transition flex items-center justify-center">
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
            <% if (ajkList != null && !ajkList.isEmpty()) { 
                for (int i = 0; i < Math.min(3, ajkList.size()); i++) {
                    Pengguna ajk = ajkList.get(i);
            %>
                <div class="flex items-center gap-3">
                    <img src="https://ui-avatars.com/api/?name=<%= ajk.getNama_penuh() %>&background=random" class="w-10 h-10 rounded-full border border-gray-100 shadow-sm">
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-bold text-gray-800 truncate"><%= ajk.getNama_penuh() %></p>
                        <p class="text-[10px] text-gray-500 truncate uppercase font-bold"><%= ajk.getNama_jawatan() %></p>
                    </div>
                    <a href="tel:<%= ajk.getNombor_telefon() %>" class="w-8 h-8 rounded-full bg-brand-purple/10 text-brand-purple flex items-center justify-center hover:bg-brand-purple hover:text-white transition shadow-sm shadow-purple-50">
                        <i class="fas fa-phone-alt text-[10px]"></i>
                    </a>
                </div>
            <% } } else { %>
                <p class="text-xs text-gray-400 italic">Maklumat AJK tidak tersedia.</p>
            <% } %>
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

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.announcement-slide');
    const dots = document.querySelectorAll('.slider-dot');
    const totalSlides = slides.length;

    function showSlide(index) {
        if (totalSlides === 0) return;
        
        slides.forEach(s => {
            s.classList.remove('opacity-100', 'scale-100', 'z-10');
            s.classList.add('opacity-0', 'scale-105');
        });
        
        dots.forEach(d => {
            d.classList.remove('bg-white', '!w-12');
            d.classList.add('bg-white/30');
        });

        slides[index].classList.remove('opacity-0', 'scale-105');
        slides[index].classList.add('opacity-100', 'scale-100', 'z-10');
        
        if (dots[index]) {
            dots[index].classList.remove('bg-white/30');
            dots[index].classList.add('bg-white', '!w-12');
        }
        
        currentSlide = index;
    }

    function nextSlide() {
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