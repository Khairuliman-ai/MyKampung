<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pengurusan Penduduk</h2>
            <p class="text-gray-500 text-sm">Urus pendaftaran baharu dan kemaskini maklumat penduduk.</p>
        </div>
    </header>

    <% if (request.getParameter("status") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Tindakan telah direkodkan.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="mb-6 border-b border-gray-200">
        <nav class="flex gap-6" aria-label="Tabs">
            <button onclick="switchTab('pending')" id="tab-pending" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-user-plus"></i> Permohonan Baru
                <% 
                   List<Pengguna> pendingList = (List<Pengguna>) request.getAttribute("pendingList");
                   if(pendingList != null && !pendingList.isEmpty()) { 
                %>
                    <span class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= pendingList.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('active')" id="tab-active" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-users"></i> Senarai Penduduk
            </button>
        </nav>
    </div>

    <div id="content-pending" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Nama Penuh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">No. Kad Pengenalan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Alamat</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">No. Telefon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (pendingList != null && !pendingList.isEmpty()) {
                            for (Pengguna p : pendingList) { %>
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4 text-sm font-bold text-gray-800"><%= p.getNamaLengkap() %></td>
                            <td class="p-4 text-sm text-gray-600">
                                <span class="bg-gray-100 px-2 py-1 rounded text-xs font-mono"><%= p.getNomborKP() %></span>
                            </td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getAlamat() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNomborTelefon() %></td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <form action="<%= request.getContextPath() %>/penduduk/approve" method="post">
                                        <input type="hidden" name="idPengguna" value="<%= p.getIdPengguna() %>">
                                        <button type="submit" class="bg-green-100 text-green-600 hover:bg-green-200 px-3 py-1.5 rounded-lg text-xs font-bold flex items-center gap-1 transition">
                                            <i class="fas fa-check"></i> Lulus
                                        </button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/penduduk/reject" method="post">
                                        <input type="hidden" name="idPengguna" value="<%= p.getIdPengguna() %>">
                                        <button type="submit" class="bg-red-100 text-red-600 hover:bg-red-200 px-3 py-1.5 rounded-lg text-xs font-bold flex items-center gap-1 transition">
                                            <i class="fas fa-times"></i> Tolak
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada permohonan baharu.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="content-active" class="hidden">
        
        <div class="mb-4">
            <div class="relative">
                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                <input type="text" id="searchActive" placeholder="Cari penduduk..." 
                       class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-[#6C5DD3] focus:border-transparent text-sm">
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableActive">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Nama Penuh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">No. Kad Pengenalan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Alamat</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">No. Telefon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% 
                        List<Pengguna> activeList = (List<Pengguna>) request.getAttribute("activeList");
                        if (activeList != null && !activeList.isEmpty()) {
                            for (Pengguna p : activeList) { 
                        %>
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4 text-sm font-bold text-gray-800 search-col"><%= p.getNamaLengkap() %></td>
                            <td class="p-4 text-sm text-gray-600 search-col"><%= p.getNomborKP() %></td>
                            <td class="p-4 text-sm text-gray-500 max-w-xs truncate search-col"><%= p.getAlamat() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNomborTelefon() %></td>
                            <td class="p-4 text-center">
                                <button onclick="openEditModal('<%= p.getIdPengguna() %>', '<%= p.getNamaLengkap() %>', '<%= p.getNomborKP() %>', '<%= p.getNomborTelefon() %>', '<%= p.getNamaJalan() %>', '<%= p.getBandar() %>', '<%= p.getNomborPoskod() %>', '<%= p.getNegeri() %>', '<%= p.getKataLaluan() %>')"
                                        class="text-[#6C5DD3] hover:bg-purple-50 p-2 rounded-lg transition">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-users-slash text-3xl mb-2 block opacity-50"></i>Tiada data penduduk aktif.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Statistik</h3>
    </div>

    <div class="space-y-4">
        <div class="bg-blue-50 p-4 rounded-2xl flex items-center gap-4">
            <div class="w-10 h-10 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center font-bold"><i class="fas fa-users"></i></div>
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Jumlah Penduduk</p>
                <h4 class="font-bold text-xl text-gray-800"><%= (activeList != null) ? activeList.size() : 0 %></h4>
            </div>
        </div>

        <div class="bg-red-50 p-4 rounded-2xl flex items-center gap-4">
            <div class="w-10 h-10 bg-red-100 text-red-600 rounded-full flex items-center justify-center font-bold"><i class="fas fa-user-clock"></i></div>
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Menunggu</p>
                <h4 class="font-bold text-xl text-gray-800"><%= (pendingList != null) ? pendingList.size() : 0 %></h4>
            </div>
        </div>
    </div>

    <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
        <h4 class="font-bold text-gray-700 mb-2 text-sm">Nota Admin</h4>
        <p class="text-xs text-gray-500 leading-relaxed">
            Sila pastikan maklumat penduduk disemak dengan teliti sebelum meluluskan pendaftaran. Penduduk yang ditolak perlu mendaftar semula.
        </p>
    </div>
</aside>

<div id="modalEdit" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalEdit')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-2xl">
            
            <form action="<%= request.getContextPath() %>/penduduk/update" method="post">
                <input type="hidden" name="idPengguna" id="editId">
                
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-blue-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-user-edit text-blue-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                            <h3 class="text-lg font-semibold leading-6 text-gray-900">Kemaskini Maklumat Penduduk</h3>
                            
                            <div class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Nama Penuh</label>
                                    <input type="text" name="namaLengkap" id="editNama" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm" required>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">No. Kad Pengenalan</label>
                                    <input type="text" name="nomborKP" id="editKP" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm" required>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">No. Telefon</label>
                                    <input type="text" name="nomborTelefon" id="editTel" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm" required>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Kata Laluan</label>
                                    <input type="text" name="kataLaluan" id="editPass" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm" required>
                                </div>

                                <div class="md:col-span-2 border-t border-gray-100 my-2"></div>
                                <h4 class="md:col-span-2 text-sm font-bold text-gray-700">Alamat Kediaman</h4>

                                <div class="md:col-span-2">
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Nama Jalan / No. Rumah</label>
                                    <input type="text" name="namaJalan" id="editJalan" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm" required>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Poskod</label>
                                    <input type="text" name="nomborPoskod" id="editPoskod" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Bandar</label>
                                    <input type="text" name="bandar" id="editBandar" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Negeri</label>
                                    <div class="relative">
                                        <select name="negeri" id="editNegeri" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm appearance-none">
                                            <option value="Kelantan">Kelantan</option>
                                            <option value="Terengganu">Terengganu</option>
                                            <option value="Pahang">Pahang</option>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                                            <i class="fas fa-chevron-down text-xs"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" class="inline-flex w-full justify-center rounded-xl bg-[#6C5DD3] px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-[#5b4eb8] sm:ml-3 sm:w-auto">Simpan Perubahan</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalEdit')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tab Logic
    function switchTab(tabName) {
        // Update Buttons
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]');
            btn.classList.add('border-transparent', 'text-gray-500');
        });
        document.getElementById('tab-' + tabName).classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]');
        document.getElementById('tab-' + tabName).classList.remove('border-transparent', 'text-gray-500');

        // Update Content
        document.getElementById('content-pending').classList.add('hidden');
        document.getElementById('content-active').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    // Search Logic
    document.getElementById('searchActive').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#tableActive tbody tr');
        rows.forEach(row => {
            let text = "";
            row.querySelectorAll('.search-col').forEach(col => text += col.innerText.toLowerCase() + " ");
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });

    // Modal Logic
    function openEditModal(id, nama, kp, tel, jalan, bandar, poskod, negeri, pass) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editKP').value = kp;
        document.getElementById('editTel').value = tel;
        document.getElementById('editJalan').value = jalan;
        document.getElementById('editBandar').value = (bandar === 'null' || bandar === '-') ? '' : bandar;
        document.getElementById('editPoskod').value = (poskod === 'null' || poskod === '-') ? '' : poskod;
        document.getElementById('editNegeri').value = (negeri === 'null' || negeri === '-') ? 'Kelantan' : negeri;
        document.getElementById('editPass').value = pass;
        
        document.getElementById('modalEdit').classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>