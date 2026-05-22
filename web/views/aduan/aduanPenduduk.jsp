<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.KategoriAduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    List<Aduan> aduanList = (List<Aduan>) request.getAttribute("aduanList");
    List<KategoriAduan> kategoriList = (List<KategoriAduan>) request.getAttribute("kategoriList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Aduan & Cadangan</h2>
            <p class="text-gray-500 text-sm">Laporkan isu atau beri cadangan untuk kesejahteraan kampung.</p>
        </div>
        <button onclick="openModal('modalAduanBaru')" class="bg-brand-purple hover:bg-brand-purpleHover text-white px-6 py-3 rounded-2xl font-bold text-sm transition shadow-lg shadow-purple-100 flex items-center gap-2">
            <i class="fas fa-plus-circle"></i> Hantar Aduan Baru
        </button>
    </div>

    <!-- Carian & Penapis Card -->
    <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterData()" placeholder="Cari no. aduan, tajuk, kategori..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-brand-purple text-gray-800 text-sm transition-all">
                </div>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Tarikh Aduan</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterData()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-brand-purple text-gray-800 text-sm transition-all">
                </div>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-gray-50 border-b border-gray-100">
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-24">No. Aduan</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Tarikh</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tajuk</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-40">Kategori</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (aduanList != null && !aduanList.isEmpty()) { 
                        for (Aduan a : aduanList) { 
                            String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                    %>
                    <tr class="data-row hover:bg-purple-50/50 transition-colors cursor-pointer" 
                        onclick="showAduanDetail(this)"
                        data-date="<%= filterDate %>"
                        data-id="<%= a.getId_aduan() %>"
                        data-tajuk="<%= a.getTajuk().replace("\"", "&quot;") %>"
                        data-keterangan="<%= a.getKeterangan().replace("\"", "&quot;") %>"
                        data-pengadu="<%= a.getNama_penuh() %>"
                        data-tarikh="<%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %>"
                        data-kategori="<%= a.getNama_kategori() %>"
                        data-status="<%= a.getStatus() %>"
                        data-status-label="<%= a.getStatusLabel() %>"
                        data-status-class="<%= a.getStatusBadgeClass() %>"
                        data-priority="<%= a.getKeutamaan() %>"
                        data-priority-class="<%= a.getKeutamaanBadge() %>"
                        data-catatan-ajk="<%= a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;") : "" %>"
                        data-catatan-ketua="<%= a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;") : "" %>"
                        data-gambar="<%= a.getGambar_aduan() != null ? a.getGambar_aduan() : "" %>"
                        >
                        <td class="p-4 text-sm font-bold text-[#6C5DD3] whitespace-nowrap search-col">#<%= a.getId_aduan() %></td>
                        <td class="p-4 text-sm text-gray-600 whitespace-nowrap"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                        <td class="p-4 search-col">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800"><%= a.getTajuk() %></span>
                                <span class="text-xs text-gray-400 mt-0.5 truncate w-48"><%= a.getKeterangan() %></span>
                            </div>
                        </td>
                        <td class="p-4 whitespace-nowrap search-col">
                            <span class="bg-blue-50 text-blue-600 border border-blue-100 px-3 py-1.5 rounded-lg text-xs font-bold uppercase">
                                <%= a.getNama_kategori() %>
                            </span>
                        </td>
                        <td class="p-4 whitespace-nowrap search-col">
                            <span class="px-3 py-1.5 rounded-full text-xs font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                <%= a.getStatusLabel() %>
                            </span>
                        </td>
                        <td class="p-4 text-center whitespace-nowrap" onclick="event.stopPropagation()">
                            <button onclick="showAduanDetail(this.closest('tr'))" 
                                    class="group inline-flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-gray-50 text-gray-600 hover:bg-purple-50 hover:text-brand-purple transition text-xs font-bold border border-gray-100">
                                <i class="fas fa-eye group-hover:scale-110 transition-transform"></i> Lihat Detail
                            </button>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr class="no-data">
                        <td colspan="6" class="p-8 text-center text-gray-400">
                            <i class="fas fa-comment-slash text-3xl mb-2 block opacity-50"></i>
                            <span class="font-bold text-sm block">Tiada Rekod Aduan</span>
                            <span class="text-xs text-gray-400 mt-1 block">Klik butang 'Hantar Aduan Baru' untuk mula.</span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-10">
        <h3 class="font-bold text-lg text-gray-800 mb-2">Pusat Bantuan</h3>
        <p class="text-xs text-gray-400">Suara anda, perubahan kita</p>
    </div>

    <div class="bg-gray-50 rounded-3xl p-6 border border-gray-100 mb-10">
        <h4 class="font-bold text-sm text-gray-800 mb-4">Kenapa Mengadu?</h4>
        <div class="space-y-4">
            <div class="flex items-start gap-3">
                <div class="w-6 h-6 rounded-full bg-green-100 text-green-600 flex items-center justify-center text-[10px] flex-shrink-0"><i class="fas fa-check"></i></div>
                <p class="text-[10px] text-gray-500 leading-relaxed">Membantu AJK mengenalpasti masalah infrastruktur dengan lebih pantas.</p>
            </div>
            <div class="flex items-start gap-3">
                <div class="w-6 h-6 rounded-full bg-green-100 text-green-600 flex items-center justify-center text-[10px] flex-shrink-0"><i class="fas fa-check"></i></div>
                <p class="text-[10px] text-gray-500 leading-relaxed">Meningkatkan keselamatan dan kesejahteraan komuniti Kampung Danan.</p>
            </div>
        </div>
    </div>

    <div class="space-y-6">
        <h3 class="font-bold text-sm text-gray-800 uppercase tracking-widest">Kategori Isu</h3>
        <div class="space-y-3">
            <% if (kategoriList != null) { 
                for (KategoriAduan k : kategoriList) { %>
            <div class="flex items-center justify-between p-3 rounded-2xl bg-white border border-gray-50 hover:border-purple-100 transition">
                <span class="text-xs font-bold text-gray-700"><%= k.getNama_kategori() %></span>
                <i class="fas fa-arrow-right text-[10px] text-gray-300"></i>
            </div>
            <% } } %>
        </div>
    </div>
</aside>

<!-- Modal Aduan Baru -->
<div id="modalAduanBaru" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanBaru')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-brand-purple px-6 py-4 flex justify-between items-center">
                <h3 class="text-lg font-bold text-white flex items-center gap-2"><i class="fas fa-pen-nib"></i> Borang Aduan Baru</h3>
                <button class="text-white hover:text-gray-200" onclick="closeModal('modalAduanBaru')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/submit" method="post" enctype="multipart/form-data">
                <div class="bg-white px-8 py-8 space-y-6">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tajuk Aduan</label>
                        <input type="text" name="tajuk" required placeholder="Contoh: Jalan Berlubang di Lorong 4" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm transition">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Kategori</label>
                            <select name="id_kategori" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm transition">
                                <% if (kategoriList != null) { 
                                    for (KategoriAduan k : kategoriList) { %>
                                    <option value="<%= k.getId_kategori_aduan() %>"><%= k.getNama_kategori() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Keutamaan</label>
                            <select name="keutamaan" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm transition">
                                <option value="RENDAH">RENDAH</option>
                                <option value="SEDERHANA" selected>SEDERHANA</option>
                                <option value="TINGGI">TINGGI</option>
                                <option value="KRITIKAL">KRITIKAL</option>
                            </select>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Keterangan Terperinci</label>
                        <textarea name="keterangan" rows="4" required placeholder="Sila jelaskan isu atau cadangan anda..." class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm transition"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Gambar Bukti (Jika Ada)</label>
                        <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-100 border-dashed rounded-xl hover:border-brand-purple transition cursor-pointer" onclick="document.getElementById('fileInput').click()">
                            <div class="space-y-1 text-center">
                                <i class="fas fa-image text-gray-400 text-3xl mb-2"></i>
                                <div class="flex text-sm text-gray-600">
                                    <span class="font-bold text-brand-purple">Muat Naik Fail</span>
                                    <p class="pl-1">atau seret dan lepas</p>
                                </div>
                                <p class="text-xs text-gray-500">PNG, JPG, JPEG sehingga 5MB</p>
                            </div>
                            <input id="fileInput" name="gambar_aduan" type="file" class="hidden" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-brand-purple hover:bg-brand-purpleHover text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Hantar Aduan</button>
                    <button type="button" onclick="closeModal('modalAduanBaru')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/views/aduan/modalDetailAduan.jsp" %>

<script>
    function filterData() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        const rows = document.querySelectorAll(".data-row");
        
        rows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showRow = true;
            if (dateVal !== "" && rowDate !== dateVal) showRow = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;
            
            row.style.display = showRow ? "" : "none";
        });
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
