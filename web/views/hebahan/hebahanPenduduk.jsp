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

    <!-- Card Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <% if (list != null && !list.isEmpty()) { 
            for (Hebahan h : list) { %>
        <a href="${pageContext.request.contextPath}/hebahan/detail?id=<%= h.getId_hebahan() %>"
           class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-lg transition group">

            <!-- Poster Image -->
            <% if (h.getGambar_poster() != null) { %>
            <div class="h-48 bg-gray-100 overflow-hidden">
                <img src="${pageContext.request.contextPath}/file/hebahan/<%= h.getGambar_poster() %>"
                     class="w-full h-full object-cover group-hover:scale-105 transition">
            </div>
            <% } else { %>
            <div class="h-48 bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center">
                <i class="<%= h.getKategoriIcon() %> text-white text-4xl opacity-50"></i>
            </div>
            <% } %>

            <div class="p-5">
                <div class="flex gap-2 mb-3">
                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%= h.getKategoriBadgeClass() %>">
                        <%= h.getKategori() %>
                    </span>
                </div>
                <h3 class="font-bold text-gray-800 mb-2"><%= h.getTajuk() %></h3>
                <p class="text-xs text-gray-400 line-clamp-2 mb-3"><%= h.getKandungan() %></p>

                <% if (h.getLokasi_acara() != null && !h.getLokasi_acara().isEmpty()) { %>
                <p class="text-xs text-gray-500">
                    <i class="fas fa-map-marker-alt mr-1"></i>
                    <%= h.getLokasi_acara() %></p>
                <% } %>

                <p class="text-xs text-gray-400 mt-2">
                    <i class="fas fa-calendar mr-1"></i>
                    <%= h.getTarikh_hebahan() != null ? sdf.format(h.getTarikh_hebahan()) : "-" %></p>
            </div>
        </a>
        <% } } else { %>
            <div class="col-span-full py-12 text-center text-gray-400">
                <i class="fas fa-bullhorn text-4xl mb-4 opacity-20"></i>
                <p class="font-bold">Tiada Hebahan Ditemui</p>
            </div>
        <% } %>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
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
