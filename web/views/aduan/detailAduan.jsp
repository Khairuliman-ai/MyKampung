<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.LogAduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna currentUser = (Pengguna) session.getAttribute("currentUser");
    Aduan aduan = (Aduan) request.getAttribute("aduan");
    List<LogAduan> logList = (List<LogAduan>) request.getAttribute("logList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="mb-8 flex items-center gap-4">
        <button onclick="history.back()" class="w-10 h-10 rounded-full bg-white flex items-center justify-center text-gray-400 hover:text-[#6C5DD3] transition shadow-sm border border-gray-100">
            <i class="fas fa-arrow-left"></i>
        </button>
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Butiran Aduan #<%= aduan.getId_aduan() %></h2>
            <p class="text-gray-500 text-sm">Lihat maklumat terperinci dan sejarah tindakan.</p>
        </div>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-8">
        <!-- Main Info -->
        <div class="xl:col-span-2 space-y-8">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100">
                <div class="flex justify-between items-start mb-6">
                    <span class="px-3 py-1 rounded-full text-xs font-bold uppercase <%= aduan.getStatusBadgeClass() %>">
                        <%= aduan.getStatusLabel() %>
                    </span>
                    <span class="px-3 py-1 rounded-lg text-xs font-bold border <%= aduan.getKeutamaanBadge() %>">
                        Keutamaan: <%= aduan.getKeutamaan() %>
                    </span>
                </div>
                
                <h3 class="text-2xl font-bold text-gray-800 mb-4"><%= aduan.getTajuk() %></h3>
                <div class="flex items-center gap-6 mb-8 text-sm text-gray-500">
                    <div class="flex items-center gap-2"><i class="far fa-calendar-alt"></i> <%= sdf.format(aduan.getDibuat_pada()) %></div>
                    <div class="flex items-center gap-2"><i class="fas fa-tag"></i> <%= aduan.getNama_kategori() %></div>
                    <div class="flex items-center gap-2"><i class="fas fa-user-edit"></i> <%= aduan.getNama_penuh() %></div>
                </div>

                <div class="prose prose-sm max-w-none text-gray-600 mb-8">
                    <p class="font-bold text-gray-800 mb-2">Keterangan:</p>
                    <p><%= aduan.getKeterangan() %></p>
                </div>

                <% if (aduan.getGambar_aduan() != null) { 
                    String enc = URLEncoder.encode(aduan.getGambar_aduan(), "UTF-8").replace("+", "%20");
                %>
                <div class="mb-8">
                    <p class="font-bold text-gray-800 mb-4">Gambar Lampiran:</p>
                    <div class="relative group w-full max-w-md">
                        <img src="<%= request.getContextPath() %>/file/aduan/<%= enc %>" class="rounded-2xl w-full shadow-md">
                        <a href="<%= request.getContextPath() %>/file/aduan/<%= enc %>" target="_blank" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center rounded-2xl">
                            <span class="bg-white px-4 py-2 rounded-xl text-xs font-bold text-gray-800">Lihat Gambar Penuh</span>
                        </a>
                    </div>
                </div>
                <% } %>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-8 border-t border-gray-100 pt-8">
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Catatan AJK</p>
                        <p class="text-sm text-gray-700 bg-gray-50 p-4 rounded-xl italic">
                            <%= aduan.getCatatan_ajk() != null ? aduan.getCatatan_ajk() : "Tiada catatan." %>
                        </p>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-2">Catatan Ketua</p>
                        <p class="text-sm text-gray-700 bg-gray-50 p-4 rounded-xl italic">
                            <%= aduan.getCatatan_ketua() != null ? aduan.getCatatan_ketua() : "Tiada catatan." %>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Timeline Log -->
        <div class="space-y-8">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 h-full">
                <h3 class="text-lg font-bold text-gray-800 mb-8 flex items-center gap-2">
                    <i class="fas fa-history text-[#6C5DD3]"></i> Log Aktiviti Aduan
                </h3>
                
                <div class="relative space-y-8 before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-0.5 before:bg-gray-100">
                    <% if (logList != null) { 
                        for (LogAduan l : logList) { %>
                    <div class="relative pl-10">
                        <div class="absolute left-0 top-1 w-6 h-6 rounded-full bg-white border-4 border-[#6C5DD3] z-10"></div>
                        <div class="flex flex-col">
                            <span class="text-[10px] font-bold text-gray-400 uppercase"><%= sdf.format(l.getDibuat_pada()) %></span>
                            <span class="text-sm font-bold text-gray-800"><%= l.getStatus_baru() %></span>
                            <span class="text-xs text-gray-500 mt-1">Oleh: <span class="font-bold"><%= l.getNama_pelaku() %></span></span>
                            <% if (l.getCatatan() != null && !l.getCatatan().isEmpty()) { %>
                                <p class="text-xs text-gray-600 mt-2 bg-gray-50 p-3 rounded-lg border-l-2 border-[#6C5DD3]"><%= l.getCatatan() %></p>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                    
                    <% if (aduan.getStatus().equals("RESOLVED") || aduan.getStatus().equals("CLOSED")) { %>
                    <div class="relative pl-10">
                        <div class="absolute left-0 top-1 w-6 h-6 rounded-full bg-green-500 border-4 border-green-100 z-10"></div>
                        <p class="text-sm font-bold text-green-600">Selesai</p>
                    </div>
                    <% } else { %>
                    <div class="relative pl-10">
                        <div class="absolute left-0 top-1 w-6 h-6 rounded-full bg-gray-100 border-4 border-white z-10 animate-pulse"></div>
                        <p class="text-sm font-bold text-gray-400 italic">Menunggu tindakan seterusnya...</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/views/common/footer.jsp" %>
