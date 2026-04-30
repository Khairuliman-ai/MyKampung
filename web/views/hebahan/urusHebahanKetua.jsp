<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="model.Hebahan, model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<%
    List<Hebahan> list = (List<Hebahan>) request.getAttribute("hebahanList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    Integer totalPublished = (Integer) request.getAttribute("totalPublished");
    Integer totalDraft = (Integer) request.getAttribute("totalDraft");
    Integer totalArchived = (Integer) request.getAttribute("totalArchived");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pemantauan Hebahan</h2>
            <p class="text-gray-500 text-sm">Oversight dan analitik untuk semua hebahan kampung.</p>
        </div>
        <div class="relative min-w-[160px]">
            <form action="${pageContext.request.contextPath}/hebahan/list" method="get" id="sortForm">
                <select name="sort" onchange="this.form.submit()" class="w-full pl-4 pr-10 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm appearance-none cursor-pointer font-bold text-gray-600 shadow-sm transition-all">
                    <option value="DESC" <%= "DESC".equals(request.getParameter("sort")) ? "selected" : "" %>>Terbaru</option>
                    <option value="ASC" <%= "ASC".equals(request.getParameter("sort")) ? "selected" : "" %>>Terlama</option>
                </select>
                <i class="fas fa-sort-amount-down absolute right-4 top-1/2 -translate-y-1/2 text-brand-purple pointer-events-none"></i>
            </form>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
            <div class="w-12 h-12 bg-green-100 rounded-2xl flex items-center justify-center text-green-600 text-xl">
                <i class="fas fa-check-circle"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Published</p>
                <p class="text-2xl font-bold text-gray-800"><%= totalPublished != null ? totalPublished : 0 %></p>
            </div>
        </div>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
            <div class="w-12 h-12 bg-yellow-100 rounded-2xl flex items-center justify-center text-yellow-600 text-xl">
                <i class="fas fa-file-alt"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Draft</p>
                <p class="text-2xl font-bold text-gray-800"><%= totalDraft != null ? totalDraft : 0 %></p>
            </div>
        </div>
        <div class="bg-white rounded-3xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
            <div class="w-12 h-12 bg-gray-100 rounded-2xl flex items-center justify-center text-gray-600 text-xl">
                <i class="fas fa-archive"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Archived</p>
                <p class="text-2xl font-bold text-gray-800"><%= totalArchived != null ? totalArchived : 0 %></p>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tajuk</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pencipta</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Kategori</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Status</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (list != null && !list.isEmpty()) { 
                        for (Hebahan h : list) { %>
                    <tr class="hover:bg-purple-50/30 transition">
                        <td class="p-4">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800"><%= h.getTajuk() %></span>
                                <span class="text-[10px] text-gray-400"><%= sdf.format(h.getTarikh_hebahan()) %></span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-600"><%= h.getNama_penuh() %></td>
                        <td class="p-4">
                            <span class="px-3 py-1 rounded-lg text-[10px] font-bold uppercase <%= h.getKategoriBadgeClass() %>">
                                <%= h.getKategori() %>
                            </span>
                        </td>
                        <td class="p-4">
                            <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%= h.getStatusBadgeClass() %>">
                                <%= h.getStatus_hebahan() %>
                            </span>
                        </td>
                        <td class="p-4 text-center">
                            <button onclick="confirmDelete(<%= h.getId_hebahan() %>)" class="text-red-400 hover:text-red-600 transition">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" class="p-12 text-center text-gray-400">
                            <i class="fas fa-bullhorn text-4xl mb-4 opacity-20"></i>
                            <p class="font-bold">Tiada Rekod Hebahan</p>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800">Rumusan Global</h3>
        <p class="text-xs text-gray-400 font-medium">Statistik hebahan seluruh kampung</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Hebahan Aktif</p>
                <h4 class="font-bold text-xl text-gray-800"><%= totalPublished %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-green-100 text-green-600 flex items-center justify-center">
                <i class="fas fa-check-circle"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Tugas Moderasi</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-xs border-2 border-[#6C5DD3] z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Pantau Kandungan</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Pastikan semua hebahan adalah tepat dan tidak mengelirukan penduduk.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Kuasa Padam</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Anda mempunyai kuasa mutlak untuk memadam hebahan yang tidak sesuai.</p>
            </div>
        </div>
    </div>
</aside>

<!-- Modal Delete -->
<div id="modalDelete" class="fixed inset-0 z-[100] hidden">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeModal('modalDelete')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-sm">
            <div class="p-6 text-center">
                <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100 mb-4">
                    <i class="fas fa-trash text-red-600"></i>
                </div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Padam Hebahan?</h3>
                <p class="text-sm text-gray-500">Anda mempunyai kuasa untuk memoderasi hebahan ini.</p>
            </div>
            <form action="<%= request.getContextPath() %>/hebahan/delete" method="post" class="bg-gray-50 px-6 py-4 flex flex-row-reverse gap-2">
                <input type="hidden" name="id_hebahan" id="delete_id">
                <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-xl font-bold text-sm">Ya, Padam</button>
                <button type="button" onclick="closeModal('modalDelete')" class="bg-white text-gray-500 px-4 py-2 rounded-xl font-bold text-sm border">Batal</button>
            </form>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id) {
        document.getElementById('delete_id').value = id;
        document.getElementById('modalDelete').classList.remove('hidden');
    }
    function closeModal(id) {
        document.getElementById(id).classList.add('hidden');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
