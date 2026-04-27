<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    List<Aduan> allList = (List<Aduan>) request.getAttribute("aduanList");
    
    List<Aduan> listDimajukan = new ArrayList<>();
    List<Aduan> listTindakan = new ArrayList<>();
    List<Aduan> listSemua = new ArrayList<>();
    
    if (allList != null) {
        for (Aduan a : allList) {
            String status = a.getStatus();
            if ("ESCALATED_TO_KETUA".equals(status)) {
                listDimajukan.add(a);
            } else if ("UNDER_REVIEW_KETUA".equals(status) || "IN_PROGRESS_HIGH_LEVEL".equals(status)) {
                listTindakan.add(a);
            }
            listSemua.add(a);
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Urus Aduan (Ketua Kampung)</h2>
        <p class="text-gray-500 text-sm">Pantau dan beri keputusan untuk aduan yang dimajukan.</p>
    </div>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('dimajukan')" id="tab-dimajukan" class="py-4 px-1 border-b-2 font-bold text-sm border-[#6C5DD3] text-[#6C5DD3]">
                Aduan Dimajukan (<%= listDimajukan.size() %>)
            </button>
            <button onclick="switchTab('tindakan')" id="tab-tindakan" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Dalam Tindakan (<%= listTindakan.size() %>)
            </button>
            <button onclick="switchTab('semua')" id="tab-semua" class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700">
                Semua Aduan
            </button>
        </nav>
    </div>

    <!-- Tab Dimajukan -->
    <div id="content-dimajukan" class="space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No.</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengadu / Tajuk</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengendali AJK</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Status</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (!listDimajukan.isEmpty()) { 
                        for (Aduan a : listDimajukan) { %>
                    <tr class="hover:bg-purple-50/30 transition cursor-pointer" onclick="location.href='<%= request.getContextPath() %>/aduan/detail?id=<%= a.getId_aduan() %>'">
                        <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= a.getId_aduan() %></td>
                        <td class="p-4 text-sm text-gray-600"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                        <td class="p-4">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                <span class="text-[10px] text-gray-400"><%= a.getTajuk() %></span>
                            </div>
                        </td>
                        <td class="p-4">
                            <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                        </td>
                        <td class="p-4">
                            <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                <%= a.getStatusLabel() %>
                            </span>
                        </td>
                        <td class="p-4 text-center">
                            <button onclick="event.stopPropagation(); openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" class="p-2 text-gray-400 hover:text-[#6C5DD3] transition">
                                <i class="fas fa-tasks"></i>
                            </button>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="p-12 text-center text-gray-400 italic">Tiada aduan dimajukan.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Tab Tindakan -->
    <div id="content-tindakan" class="hidden space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No.</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengadu / Tajuk</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengendali AJK</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Status</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (!listTindakan.isEmpty()) { 
                        for (Aduan a : listTindakan) { %>
                    <tr class="hover:bg-purple-50/30 transition cursor-pointer" onclick="location.href='<%= request.getContextPath() %>/aduan/detail?id=<%= a.getId_aduan() %>'">
                        <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= a.getId_aduan() %></td>
                        <td class="p-4 text-sm text-gray-600"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                        <td class="p-4">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                <span class="text-[10px] text-gray-400"><%= a.getTajuk() %></span>
                            </div>
                        </td>
                        <td class="p-4">
                            <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                        </td>
                        <td class="p-4">
                            <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                <%= a.getStatusLabel() %>
                            </span>
                        </td>
                        <td class="p-4 text-center">
                            <button onclick="event.stopPropagation(); openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" class="p-2 text-gray-400 hover:text-[#6C5DD3] transition">
                                <i class="fas fa-tasks"></i>
                            </button>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="p-12 text-center text-gray-400 italic">Tiada aduan dalam tindakan.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Tab Semua -->
    <div id="content-semua" class="hidden space-y-6">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No.</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengadu / Tajuk</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pengendali AJK</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Status</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (!listSemua.isEmpty()) { 
                        for (Aduan a : listSemua) { %>
                    <tr class="hover:bg-purple-50/30 transition cursor-pointer" onclick="location.href='<%= request.getContextPath() %>/aduan/detail?id=<%= a.getId_aduan() %>'">
                        <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= a.getId_aduan() %></td>
                        <td class="p-4 text-sm text-gray-600"><%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></td>
                        <td class="p-4">
                            <div class="flex flex-col">
                                <span class="text-sm font-bold text-gray-800"><%= a.getNama_penuh() %></span>
                                <span class="text-[10px] text-gray-400"><%= a.getTajuk() %></span>
                            </div>
                        </td>
                        <td class="p-4">
                            <span class="text-xs text-gray-500 font-medium"><%= a.getNama_pengendali() != null ? a.getNama_pengendali() : "Tiada" %></span>
                        </td>
                        <td class="p-4">
                            <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase <%= a.getStatusBadgeClass() %>">
                                <%= a.getStatusLabel() %>
                            </span>
                        </td>
                        <td class="p-4 text-center">
                            <button onclick="event.stopPropagation(); openStatusModal('<%= a.getId_aduan() %>', '<%= a.getStatus() %>', '<%= a.getStatusLabel() %>')" class="p-2 text-gray-400 hover:text-[#6C5DD3] transition">
                                <i class="fas fa-tasks"></i>
                            </button>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="p-12 text-center text-gray-400 italic">Tiada rekod aduan.</td></tr>
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
        <h3 class="font-bold text-lg text-gray-800">Rumusan Aduan</h3>
        <p class="text-xs text-gray-400 font-medium">Prestasi penyelesaian masalah</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Perlu Keputusan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listDimajukan.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-purple-100 text-[#6C5DD3] flex items-center justify-center">
                <i class="fas fa-gavel"></i>
            </div>
        </div>
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Keseluruhan Aduan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= listSemua.size() %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-gray-100 text-gray-500 flex items-center justify-center">
                <i class="fas fa-list-ul"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Kuasa Ketua</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-xs border-2 border-[#6C5DD3] z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Keputusan Akhir</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Gunakan ulasan untuk memberi arahan kepada AJK atau memberi maklum balas kepada pengadu.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Pantau AJK</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Pastikan AJK bertindak pantas sebelum kes dimajukan kepada anda.</p>
            </div>
        </div>
    </div>
</aside>

<!-- Modal Update Status (Ketua) -->
<div id="modalStatus" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalStatus')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md">
            <div class="bg-[#6C5DD3] px-6 py-4">
                <h3 class="text-lg font-bold text-white">Keputusan Ketua Kampung</h3>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/updateStatus" method="post">
                <input type="hidden" name="id_aduan" id="modal-id">
                <input type="hidden" name="current_status" id="modal-current">
                <div class="p-8 space-y-6">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Status Semasa</label>
                        <p id="modal-label" class="text-sm font-bold text-gray-800"></p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Keputusan Baru</label>
                        <select name="next_status" id="modal-next" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Ulasan Ketua</label>
                        <textarea name="catatan" rows="3" required placeholder="Sila berikan arahan atau sebab..." class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm"></textarea>
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Sahkan Keputusan</button>
                    <button type="button" onclick="closeModal('modalStatus')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(name) {
        ['dimajukan', 'tindakan', 'semua'].forEach(t => {
            document.getElementById('content-' + t).classList.add('hidden');
            document.getElementById('tab-' + t).classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            document.getElementById('tab-' + t).classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });
        document.getElementById('content-' + name).classList.remove('hidden');
        document.getElementById('tab-' + name).classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        document.getElementById('tab-' + name).classList.remove('border-transparent', 'text-gray-500', 'font-medium');
    }

    function openStatusModal(id, status, label) {
        document.getElementById('modal-id').value = id;
        document.getElementById('modal-current').value = status;
        document.getElementById('modal-label').innerText = label;
        
        const next = document.getElementById('modal-next');
        next.innerHTML = '';
        
        const options = {
            'ESCALATED_TO_KETUA': [
                {v: 'UNDER_REVIEW_KETUA', t: 'Terima untuk Semakan (Ketua)'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'UNDER_REVIEW_KETUA': [
                {v: 'IN_PROGRESS_HIGH_LEVEL', t: 'Mula Tindakan (Pihak Luar/External)'},
                {v: 'RESOLVED', t: 'Tandakan SELESAI'},
                {v: 'REJECTED', t: 'Tolak Aduan'}
            ],
            'IN_PROGRESS_HIGH_LEVEL': [
                {v: 'RESOLVED', t: 'Tandakan SELESAI'}
            ],
            'RESOLVED': [
                {v: 'CLOSED', t: 'Tutup Kes Secara Rasmi'}
            ],
            'REJECTED': [
                {v: 'CLOSED', t: 'Tutup Kes Secara Rasmi'}
            ]
        };
        
        const possible = options[status] || [];
        possible.forEach(o => {
            const el = document.createElement('option');
            el.value = o.v;
            el.innerText = o.t;
            next.appendChild(el);
        });
        
        document.getElementById('modalStatus').classList.remove('hidden');
    }

    function closeModal(id) { document.getElementById(id).classList.add('hidden'); }
</script>

<%@ include file="/views/common/footer.jsp" %>
