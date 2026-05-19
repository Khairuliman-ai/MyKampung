<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Hebahan, model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<%
    Hebahan h = (Hebahan) request.getAttribute("hebahan");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy, hh:mm a");
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd MMMM yyyy");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="max-w-4xl mx-auto">
        <button onclick="history.back()" class="flex items-center gap-2 text-gray-500 hover:text-brand-purple mb-6 transition font-medium">
            <i class="fas fa-arrow-left"></i> Kembali
        </button>

        <% if (h != null) { %>
        <div class="bg-white rounded-[40px] shadow-sm border border-gray-100 overflow-hidden">
            <!-- Hero Poster Section -->
            <% if (h.getGambar_poster() != null) { %>
            <div class="w-full h-96 bg-gray-100">
                <img src="${pageContext.request.contextPath}/file/hebahan/<%= h.getGambar_poster() %>"
                     class="w-full h-full object-cover">
            </div>
            <% } else { %>
            <div class="w-full h-48 bg-gradient-to-r from-brand-purple to-[#A297E8] flex items-center justify-center">
                <i class="<%= h.getKategoriIcon() %> text-white text-6xl opacity-30"></i>
            </div>
            <% } %>

            <div class="p-8 md:p-12">
                <div class="flex items-center gap-3 mb-6">
                    <span class="px-4 py-1.5 rounded-xl text-xs font-bold uppercase <%= h.getKategoriBadgeClass() %>">
                        <%= h.getKategori() %>
                    </span>
                    <span class="text-sm text-gray-400">Diterbitkan pada <%= h.getTarikh_hebahan() != null ? sdfDate.format(h.getTarikh_hebahan()) : "-" %></span>
                </div>

                <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-8 leading-tight"><%= h.getTajuk() %></h1>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                    <div class="md:col-span-2">
                        <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-4">Butiran Hebahan</h3>
                        <div class="text-gray-600 leading-relaxed space-y-4">
                            <%= h.getKandungan().replace("\n", "<br>") %>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <% if (h.getLokasi_acara() != null && !h.getLokasi_acara().isEmpty()) { %>
                        <div class="bg-gray-50 rounded-3xl p-6">
                            <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-4">Maklumat Acara</h3>
                            <div class="space-y-4">
                                <div class="flex gap-3">
                                    <div class="w-8 h-8 rounded-xl bg-white flex items-center justify-center text-brand-purple shadow-sm">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Lokasi</p>
                                        <p class="text-sm font-bold text-gray-800"><%= h.getLokasi_acara() %></p>
                                    </div>
                                </div>
                                <% if (h.getTarikh_mula_acara() != null) { %>
                                <div class="flex gap-3">
                                    <div class="w-8 h-8 rounded-xl bg-white flex items-center justify-center text-brand-purple shadow-sm">
                                        <i class="fas fa-calendar-alt"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Masa Mula</p>
                                        <p class="text-sm font-bold text-gray-800"><%= sdf.format(h.getTarikh_mula_acara()) %></p>
                                    </div>
                                </div>
                                <% } %>
                                <% if (h.getTarikh_tamat_acara() != null) { %>
                                <div class="flex gap-3">
                                    <div class="w-8 h-8 rounded-xl bg-white flex items-center justify-center text-brand-purple shadow-sm">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Masa Tamat</p>
                                        <p class="text-sm font-bold text-gray-800"><%= sdf.format(h.getTarikh_tamat_acara()) %></p>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% } %>

                        <div class="px-6">
                            <p class="text-[10px] font-bold text-gray-400 uppercase mb-2">Disediakan Oleh</p>
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-brand-purple flex items-center justify-center text-white font-bold">
                                    <%= h.getNama_penuh().substring(0, 1).toUpperCase() %>
                                </div>
                                <span class="text-sm font-bold text-gray-700"><%= h.getNama_penuh() %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="bg-white rounded-[40px] p-20 text-center border border-gray-100 shadow-sm">
            <i class="fas fa-search text-6xl text-gray-100 mb-6"></i>
            <h2 class="text-2xl font-bold text-gray-800">Hebahan Tidak Ditemui</h2>
            <p class="text-gray-500">Hebahan ini mungkin telah dipadam atau tidak wujud.</p>
        </div>
        <% } %>
    </div>
</div>

<%@ include file="/views/common/footer.jsp" %>
