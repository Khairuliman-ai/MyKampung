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
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    String sortParam = request.getParameter("sort");
    if (sortParam == null || sortParam.isEmpty()) sortParam = "DESC";
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pemantauan Hebahan</h2>
            <p class="text-gray-500 text-sm">Oversight dan analitik untuk semua hebahan kampung.</p>
        </div>
        <div class="relative min-w-[160px]">
            <form action="${pageContext.request.contextPath}/hebahan/list" method="get" id="sortForm">
                <select name="sort" onchange="this.form.submit()" class="w-full pl-4 pr-10 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-2 focus:ring-brand-purple text-sm appearance-none cursor-pointer font-bold text-gray-600 shadow-sm transition-all">
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
                    <tr class="bg-gray-50 border-b border-gray-100">
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Tajuk</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Pencipta</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Kategori</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Status</th>
                        <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (list != null && !list.isEmpty()) { 
                        for (Hebahan h : list) { %>
                    <tr class="hover:bg-gray-50/50 transition group">
                        <td class="p-4">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800 group-hover:text-brand-purple transition-colors"><%= h.getTajuk() %></span>
                                <span class="text-[10px] text-gray-400 block mt-1"><%= sdf.format(h.getTarikh_hebahan()) %></span>
                            </div>
                        </td>
                        <td class="p-4 text-sm text-gray-600"><%= h.getNama_penuh() %></td>
                        <td class="p-4 text-center">
                            <% if ("Kecemasan".equals(h.getKategori())) { %>
                                <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-red-50 text-red-600 border border-red-100">KECEMASAN</span>
                            <% } else if ("Aktiviti".equals(h.getKategori())) { %>
                                <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">AKTIVITI</span>
                            <% } else { %>
                                <span class="px-2 py-1 rounded-lg text-[9px] font-bold bg-green-50 text-green-600 border border-green-100">UMUM</span>
                            <% } %>
                        </td>
                        <td class="p-4 text-center">
                            <% if ("Published".equals(h.getStatus_hebahan())) { %>
                                <span class="bg-green-50 text-green-600 text-[10px] font-bold px-3 py-1.5 rounded-full border border-green-100">PUBLISHED</span>
                            <% } else if ("Draft".equals(h.getStatus_hebahan())) { %>
                                <span class="bg-yellow-50 text-yellow-600 text-[10px] font-bold px-3 py-1.5 rounded-full border border-yellow-100">DRAFT</span>
                            <% } else { %>
                                <span class="bg-gray-50 text-gray-600 text-[10px] font-bold px-3 py-1.5 rounded-full border border-gray-100">ARCHIVED</span>
                            <% } %>
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
                            <i class="fas fa-bullhorn text-4xl mb-4 block opacity-20 text-gray-300"></i>
                            <span class="block mt-2 font-medium">Tiada Rekod Hebahan.</span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pagination Bar -->
    <% if (totalPages > 1) { %>
    <div class="flex justify-center items-center gap-2 mt-8 bg-white px-6 py-4 rounded-[2rem] shadow-sm border border-gray-50 max-w-fit mx-auto">
        <%-- Previous Button --%>
        <% if (currentPage > 1) { %>
            <a href="?page=<%= currentPage - 1 %><%= sortParam != null ? "&sort=" + sortParam : "" %>" 
               class="w-10 h-10 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-600 flex items-center justify-center transition border border-gray-100 text-xs">
                <i class="fas fa-chevron-left"></i>
            </a>
        <% } else { %>
            <span class="w-10 h-10 rounded-xl bg-gray-50 text-gray-300 flex items-center justify-center border border-gray-100 text-xs cursor-not-allowed">
                <i class="fas fa-chevron-left"></i>
            </span>
        <% } %>

        <%-- Page Numbers --%>
        <% for (int i = 1; i <= totalPages; i++) { 
            if (i == currentPage) { %>
                <span class="w-10 h-10 rounded-xl bg-brand-purple text-white flex items-center justify-center font-bold text-xs shadow-md shadow-purple-100">
                    <%= i %>
                </span>
            <% } else { %>
                <a href="?page=<%= i %><%= sortParam != null ? "&sort=" + sortParam : "" %>" 
                   class="w-10 h-10 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-600 flex items-center justify-center transition border border-gray-100 text-xs font-semibold">
                    <%= i %>
                </a>
            <% } %>
        <% } %>

        <%-- Next Button --%>
        <% if (currentPage < totalPages) { %>
            <a href="?page=<%= currentPage + 1 %><%= sortParam != null ? "&sort=" + sortParam : "" %>" 
               class="w-10 h-10 rounded-xl bg-gray-50 hover:bg-gray-100 text-gray-600 flex items-center justify-center transition border border-gray-100 text-xs">
                <i class="fas fa-chevron-right"></i>
            </a>
        <% } else { %>
            <span class="w-10 h-10 rounded-xl bg-gray-50 text-gray-300 flex items-center justify-center border border-gray-100 text-xs cursor-not-allowed">
                <i class="fas fa-chevron-right"></i>
            </span>
        <% } %>
    </div>
    <% } %>
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
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-xs border-2 border-brand-purple z-10">1</div>
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

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        if (msg) {
            const messages = {
                'deleted': 'Hebahan berjaya dipadam.'
            };
            const alertText = messages[msg];
            if (alertText) {
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'success',
                    title: alertText,
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true
                });
            }
        }
    });

    function confirmDelete(id) {
        Swal.fire({
            title: 'Padam Hebahan?',
            text: 'Anda mempunyai kuasa untuk memoderasi hebahan ini.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#6b7280',
            confirmButtonText: 'Ya, Padam!',
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '<%= request.getContextPath() %>/hebahan/delete';
                
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf';
                csrfInput.value = '${sessionScope.csrf_token}';
                form.appendChild(csrfInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id_hebahan';
                idInput.value = id;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('error') === 'file_too_large') {
            Swal.fire({
                icon: 'warning',
                title: 'Had Saiz Fail Dilebihi!',
                text: 'Gambar poster hebahan melebihi had saiz maksimum (10MB). Sila kecilkan saiz fail gambar anda dan cuba lagi.',
                confirmButtonColor: '#D97706',
                customClass: { popup: 'rounded-[2rem] font-sans' }
            });
        }
    });
    // closeModal centralized in footer.jsp
</script>

<%@ include file="/views/common/footer.jsp" %>
