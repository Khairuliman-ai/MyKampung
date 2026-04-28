<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="model.Hebahan, model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<%
    List<Hebahan> list = (List<Hebahan>) request.getAttribute("hebahanList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String keyword = request.getParameter("q");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Info & Hebahan</h2>
            <p class="text-gray-500 text-sm">Pengumuman rasmi kampung terkini.</p>
        </div>
    </div>

    <!-- Search & Filter Bar -->
    <div class="flex gap-4 mb-6">
        <form action="${pageContext.request.contextPath}/hebahan/list" method="get" class="flex gap-3 flex-1">
            <input type="text" name="q" placeholder="Cari hebahan..." value="<%= keyword != null ? keyword : "" %>"
                class="flex-1 px-4 py-3 rounded-xl bg-white border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm">
            <button type="submit" class="bg-[#6C5DD3] text-white px-6 py-3 rounded-xl font-bold text-sm">
                <i class="fas fa-search"></i> Cari
            </button>
        </form>
    </div>

    <!-- Category Filter Pills -->
    <div class="flex gap-2 mb-6">
        <a href="${pageContext.request.contextPath}/hebahan/list" class="px-4 py-2 rounded-full text-xs font-bold bg-[#6C5DD3] text-white">Semua</a>
        <a href="?kategori=Kecemasan" class="px-4 py-2 rounded-full text-xs font-bold bg-red-50 text-red-600 border border-red-100">Kecemasan</a>
        <a href="?kategori=Aktiviti" class="px-4 py-2 rounded-full text-xs font-bold bg-blue-50 text-blue-600 border border-blue-100">Aktiviti</a>
        <a href="?kategori=Umum" class="px-4 py-2 rounded-full text-xs font-bold bg-green-50 text-green-600 border border-green-100">Umum</a>
    </div>

    <!-- List Layout -->
    <div class="flex flex-col gap-6">
        <% if (list != null && !list.isEmpty()) { 
            for (Hebahan h : list) { 
                String fullDate = h.getTarikh_hebahan() != null ? sdf.format(h.getTarikh_hebahan()) : "-";
                String eventDateRange = "-";
                if (h.getTarikh_mula_acara() != null) {
                    eventDateRange = sdf.format(h.getTarikh_mula_acara());
                    if (h.getTarikh_tamat_acara() != null) {
                        eventDateRange += " - " + sdf.format(h.getTarikh_tamat_acara());
                    }
                }
        %>
        <div onclick="showHebahanDetail({
                id: '<%= h.getId_hebahan() %>',
                tajuk: '<%= h.getTajuk().replace("'", "\\'") %>',
                kandungan: `<%= h.getKandungan().replace("`", "\\`") %>`,
                kategori: '<%= h.getKategori() %>',
                badgeClass: '<%= h.getKategoriBadgeClass() %>',
                icon: '<%= h.getKategoriIcon() %>',
                gambar: '<%= h.getGambar_poster() != null ? h.getGambar_poster() : "" %>',
                lokasi: '<%= h.getLokasi_acara() != null ? h.getLokasi_acara().replace("'", "\\'") : "-" %>',
                tarikhHebahan: '<%= fullDate %>',
                tarikhAcara: '<%= eventDateRange %>'
             })"
           class="bg-white rounded-[2rem] shadow-sm border border-gray-50 overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 group flex flex-col md:flex-row md:h-64 cursor-pointer">

            <!-- Poster Image Section -->
            <div class="w-full md:w-72 lg:w-96 shrink-0 relative overflow-hidden bg-gray-100">
                <% if (h.getGambar_poster() != null) { %>
                    <img src="${pageContext.request.contextPath}/file/hebahan/<%= h.getGambar_poster() %>"
                         class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                <% } else { %>
                    <div class="w-full h-full bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center">
                        <i class="<%= h.getKategoriIcon() %> text-white text-5xl opacity-30"></i>
                    </div>
                <% } %>
                
                <div class="absolute top-4 left-4 md:hidden">
                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase shadow-lg <%= h.getKategoriBadgeClass() %>">
                        <%= h.getKategori() %>
                    </span>
                </div>
            </div>

            <!-- Content Section -->
            <div class="p-6 md:p-8 flex flex-col flex-1 min-w-0">
                <div class="hidden md:flex gap-2 mb-4">
                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase border <%= h.getKategoriBadgeClass() %>">
                        <%= h.getKategori() %>
                    </span>
                </div>

                <div class="flex-1">
                    <h3 class="text-xl md:text-2xl font-bold text-gray-800 mb-2 truncate group-hover:text-brand-purple transition-colors"><%= h.getTajuk() %></h3>
                    <p class="text-sm text-gray-500 line-clamp-2 md:line-clamp-3 mb-6 leading-relaxed"><%= h.getKandungan() %></p>
                </div>

                <div class="flex flex-wrap items-center gap-y-2 gap-x-6 pt-4 border-t border-gray-50">
                    <% if (h.getLokasi_acara() != null && !h.getLokasi_acara().isEmpty()) { %>
                    <div class="flex items-center gap-2 text-xs text-gray-400">
                        <div class="w-6 h-6 rounded-lg bg-gray-50 flex items-center justify-center">
                            <i class="fas fa-map-marker-alt text-brand-purple"></i>
                        </div>
                        <span class="font-medium"><%= h.getLokasi_acara() %></span>
                    </div>
                    <% } %>

                    <div class="flex items-center gap-2 text-xs text-gray-400">
                        <div class="w-6 h-6 rounded-lg bg-gray-50 flex items-center justify-center">
                            <i class="fas fa-calendar-alt text-brand-purple"></i>
                        </div>
                        <span class="font-medium"><%= fullDate %></span>
                    </div>

                    <div class="ml-auto hidden md:flex items-center gap-2 text-brand-purple font-bold text-xs group-hover:translate-x-2 transition-transform">
                        Baca Lanjut
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </div>
            </div>
        </div>
        <% } } else { %>
            <div class="py-20 text-center bg-white rounded-[3rem] border border-dashed border-gray-200 w-full">
                <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-bullhorn text-3xl text-gray-200"></i>
                </div>
                <p class="font-bold text-gray-400">Tiada Hebahan Ditemui</p>
                <p class="text-xs text-gray-300 mt-1">Cuba kata kunci lain atau pilih kategori berbeza.</p>
            </div>
        <% } %>
    </div> <!-- Closes List Layout -->
</div> <!-- Closes flex-1 main scrollable area -->

<!-- Modal Detail Hebahan -->
<div id="modalHebahan" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeHebahanModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[3rem] shadow-2xl overflow-hidden transform transition-all duration-300">
            <!-- Header Image -->
            <div id="modalImageContainer" class="h-64 md:h-96 bg-gray-100 overflow-hidden relative">
                <img id="modalImage" src="" class="w-full h-full object-cover">
                <div id="modalGradient" class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                <button onclick="closeHebahanModal()" class="absolute top-6 right-6 w-12 h-12 bg-white/20 hover:bg-white/40 backdrop-blur-md text-white rounded-2xl flex items-center justify-center transition-all">
                    <i class="fas fa-times"></i>
                </button>
                <div class="absolute bottom-8 left-8 right-8 text-white">
                    <div id="modalBadge" class="inline-block px-4 py-1.5 rounded-full text-[10px] font-bold uppercase mb-4 backdrop-blur-md border border-white/20"></div>
                    <h2 id="modalTitle" class="text-2xl md:text-4xl font-bold"></h2>
                </div>
            </div>

            <!-- Content Body -->
            <div class="p-8 md:p-12">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-12">
                    <div class="md:col-span-2">
                        <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Kandungan Hebahan</h3>
                        <div id="modalKandungan" class="text-gray-600 leading-relaxed space-y-4 whitespace-pre-wrap"></div>
                    </div>
                    <div class="space-y-8">
                        <div>
                            <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Maklumat Acara</h3>
                            <div class="space-y-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-purple-50 text-brand-purple flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Lokasi</p>
                                        <p id="modalLokasi" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Tarikh Acara</p>
                                        <p id="modalTarikhAcara" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 bg-gray-50 rounded-[2rem] border border-gray-100">
                            <p class="text-[10px] font-bold text-gray-400 uppercase mb-2">Hebahan Diterbitkan Pada</p>
                            <p id="modalTarikhHebahan" class="text-xs font-bold text-gray-600"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function showHebahanDetail(data) {
        const modal = document.getElementById('modalHebahan');
        const img = document.getElementById('modalImage');
        const imgContainer = document.getElementById('modalImageContainer');
        const grad = document.getElementById('modalGradient');
        
        document.getElementById('modalTitle').innerText = data.tajuk;
        document.getElementById('modalKandungan').innerText = data.kandungan;
        document.getElementById('modalLokasi').innerText = data.lokasi;
        document.getElementById('modalTarikhAcara').innerText = data.tarikhAcara;
        document.getElementById('modalTarikhHebahan').innerText = data.tarikhHebahan;
        
        const badge = document.getElementById('modalBadge');
        badge.innerText = data.kategori;
        badge.className = 'inline-block px-4 py-1.5 rounded-full text-[10px] font-bold uppercase mb-4 backdrop-blur-md border border-white/20 ' + data.badgeClass;

        if (data.gambar) {
            img.src = '${pageContext.request.contextPath}/file/hebahan/' + data.gambar;
            img.classList.remove('hidden');
            imgContainer.classList.remove('bg-gradient-to-br');
            grad.classList.remove('hidden');
        } else {
            img.classList.add('hidden');
            imgContainer.className = 'h-64 md:h-96 overflow-hidden relative bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center';
            grad.classList.add('hidden');
            // Add icon if no image
            const icon = document.createElement('i');
            icon.className = data.icon + ' text-white text-9xl opacity-20';
            icon.id = 'tempIcon';
            imgContainer.appendChild(icon);
        }

        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function closeHebahanModal() {
        const modal = document.getElementById('modalHebahan');
        modal.classList.add('hidden');
        document.body.style.overflow = 'auto';
        
        const tempIcon = document.getElementById('tempIcon');
        if (tempIcon) tempIcon.remove();
        
        const imgContainer = document.getElementById('modalImageContainer');
        imgContainer.className = 'h-64 md:h-96 bg-gray-100 overflow-hidden relative';
    }
</script>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full shrink-0">
    <div class="mb-10">
        <h3 class="font-bold text-lg text-gray-800 mb-2">Hebahan Terbaru</h3>
        <p class="text-xs text-gray-400">Sentiasa peka dengan info kampung</p>
    </div>

    <div class="bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] rounded-3xl p-6 text-white shadow-lg shadow-purple-100 mb-10">
        <h4 class="font-bold text-sm mb-3">Ada Berita Menarik?</h4>
        <p class="text-[10px] text-purple-100 leading-relaxed mb-4">
            Hubungi Biro Hebahan jika anda mempunyai maklumat aktiviti untuk dikongsi bersama penduduk.
        </p>
        <button class="w-full py-2.5 bg-white/20 hover:bg-white/30 rounded-xl text-xs font-bold transition backdrop-blur-md">
            Hubungi AJK
        </button>
    </div>

    <div class="space-y-6">
        <h3 class="font-bold text-sm text-gray-800 uppercase tracking-widest">Kategori Popular</h3>
        <div class="space-y-3">
            <div class="flex items-center justify-between p-3 rounded-2xl bg-gray-50 border border-gray-100">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-red-100 text-red-500 flex items-center justify-center text-xs">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <span class="text-xs font-bold text-gray-700">Kecemasan</span>
                </div>
                <i class="fas fa-chevron-right text-[10px] text-gray-300"></i>
            </div>
            <div class="flex items-center justify-between p-3 rounded-2xl bg-gray-50 border border-gray-100">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-blue-100 text-blue-500 flex items-center justify-center text-xs">
                        <i class="fas fa-running"></i>
                    </div>
                    <span class="text-xs font-bold text-gray-700">Aktiviti</span>
                </div>
                <i class="fas fa-chevron-right text-[10px] text-gray-300"></i>
            </div>
        </div>
    </div>
</aside>
<%@ include file="/views/common/footer.jsp" %>
