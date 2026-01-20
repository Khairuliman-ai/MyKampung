<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pusat Kawalan</h2>
            <p class="text-gray-500 text-sm">Urus tadbir organisasi JKKK dan penduduk kampung.</p>
        </div>
        <div>
            <button onclick="openModal('modalLantik')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-user-shield"></i> Lantik JKKK
            </button>
        </div>
    </div>

    <% if (request.getParameter("status") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Operasi telah dilaksanakan.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="mb-6 border-b border-gray-200">
        <nav class="flex gap-6" aria-label="Tabs">
            <button onclick="switchTab('jkkk')" id="tab-jkkk" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-id-badge"></i> Senarai JKKK
            </button>
            <button onclick="switchTab('penduduk')" id="tab-penduduk" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-users"></i> Senarai Penduduk
            </button>
        </nav>
    </div>

    <div id="content-jkkk" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-purple-50 border-b border-purple-100">
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Nama Penuh</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Kad Pengenalan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Telefon</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% 
                        List<Pengguna> listJKKK = (List<Pengguna>) request.getAttribute("listJKKK");
                        if (listJKKK != null && !listJKKK.isEmpty()) {
                            for (Pengguna p : listJKKK) { 
                        %>
                        <tr class="hover:bg-purple-50/30 transition">
                            <td class="p-4 text-sm font-bold text-gray-800 flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center text-xs font-bold">
                                    <%= p.getNamaLengkap().substring(0,1) %>
                                </div>
                                <%= p.getNamaLengkap() %>
                            </td>
                            <td class="p-4 text-sm text-gray-600 font-mono"><%= p.getNomborKP() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNomborTelefon() %></td>
                            <td class="p-4 text-center">
                                <button onclick="openEditModal('<%= p.getIdPengguna() %>', '<%= p.getNamaLengkap() %>', '<%= p.getNomborKP() %>', '<%= p.getNomborTelefon() %>', '<%= p.getNamaJalan() %>', '<%= p.getBandar() %>', '<%= p.getNomborPoskod() %>', '<%= p.getNegeri() %>', '<%= p.getKataLaluan() %>')"
                                        class="bg-purple-50 text-[#6C5DD3] hover:bg-[#6C5DD3] hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="4" class="p-8 text-center text-gray-400"><i class="fas fa-user-slash text-3xl mb-2 block opacity-50"></i>Tiada ahli JKKK dilantik.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="content-penduduk" class="hidden">
        
        <div class="mb-4">
            <div class="relative">
                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                <input type="text" id="searchPenduduk" placeholder="Cari penduduk..." 
                       class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-[#6C5DD3] focus:border-transparent text-sm shadow-sm">
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tablePenduduk">
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
                        List<Pengguna> listPenduduk = (List<Pengguna>) request.getAttribute("listPenduduk");
                        if (listPenduduk != null && !listPenduduk.isEmpty()) {
                            for (Pengguna p : listPenduduk) { 
                        %>
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4 text-sm font-bold text-gray-800 search-col"><%= p.getNamaLengkap() %></td>
                            <td class="p-4 text-sm text-gray-600 search-col"><%= p.getNomborKP() %></td>
                            <td class="p-4 text-sm text-gray-500 max-w-xs truncate search-col"><%= p.getAlamat() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNomborTelefon() %></td>
                            <td class="p-4 text-center">
                                <button onclick="openEditModal('<%= p.getIdPengguna() %>', '<%= p.getNamaLengkap() %>', '<%= p.getNomborKP() %>', '<%= p.getNomborTelefon() %>', '<%= p.getNamaJalan() %>', '<%= p.getBandar() %>', '<%= p.getNomborPoskod() %>', '<%= p.getNegeri() %>', '<%= p.getKataLaluan() %>')"
                                        class="text-gray-400 hover:text-[#6C5DD3] transition">
                                    <i class="fas fa-pencil-alt"></i>
                                </button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-users-slash text-3xl mb-2 block opacity-50"></i>Tiada data penduduk.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Statistik Organisasi</h3>
    </div>

    <div class="space-y-4">
        <div class="bg-purple-50 p-4 rounded-2xl flex items-center gap-4 border border-purple-100">
            <div class="w-10 h-10 bg-purple-100 text-[#6C5DD3] rounded-full flex items-center justify-center font-bold">
                <i class="fas fa-user-shield"></i>
            </div>
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Ahli JKKK</p>
                <h4 class="font-bold text-xl text-gray-800"><%= (listJKKK != null) ? listJKKK.size() : 0 %></h4>
            </div>
        </div>

        <div class="bg-blue-50 p-4 rounded-2xl flex items-center gap-4 border border-blue-100">
            <div class="w-10 h-10 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center font-bold">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Total Penduduk</p>
                <h4 class="font-bold text-xl text-gray-800"><%= (listPenduduk != null) ? listPenduduk.size() : 0 %></h4>
            </div>
        </div>
    </div>

    <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
        <h4 class="font-bold text-gray-700 mb-2 text-sm">Struktur Organisasi</h4>
        <p class="text-xs text-gray-500 leading-relaxed mb-4">
            Pastikan setiap biro mempunyai wakil JKKK yang aktif untuk kelancaran pentadbiran kampung.
        </p>
        <button class="w-full bg-white border border-gray-200 text-gray-600 py-2 rounded-xl text-xs font-bold hover:bg-gray-100 transition">
            Lihat Carta Organisasi
        </button>
    </div>
</aside>

<div id="modalLantik" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalLantik')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            
            <div class="bg-[#6C5DD3] px-4 py-4 sm:px-6">
                <h3 class="text-base font-bold leading-6 text-white flex items-center gap-2">
                    <i class="fas fa-user-plus"></i> Lantik JKKK Baru
                </h3>
            </div>

            <form action="<%= request.getContextPath() %>/ketua/lantik" method="post">
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="bg-blue-50 text-blue-700 p-3 rounded-xl text-xs flex gap-2 items-start mb-4">
                        <i class="fas fa-info-circle mt-0.5"></i>
                        <p>Akaun ini akan mempunyai akses Pentadbir sebagai JKKK.</p>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Nama Penuh</label>
                            <input type="text" name="namaLengkap" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-1">No. KP</label>
                                <input type="text" name="nomborKP" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-1">No. Telefon</label>
                                <input type="text" name="nomborTelefon" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Alamat Ringkas</label>
                            <input type="text" name="alamat" placeholder="Contoh: Kg. Danan" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Kata Laluan Sementara</label>
                            <input type="text" name="kataLaluan" value="jkkk123" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" class="inline-flex w-full justify-center rounded-xl bg-[#6C5DD3] px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-[#5b4eb8] sm:ml-3 sm:w-auto">Lantik</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalLantik')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="modalEdit" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalEdit')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-2xl">
            
            <div class="bg-gray-50 px-4 py-4 sm:px-6 border-b border-gray-100">
                <h3 class="text-base font-bold leading-6 text-gray-900 flex items-center gap-2">
                    <i class="fas fa-user-edit text-[#6C5DD3]"></i> Kemaskini Maklumat
                </h3>
            </div>

            <form action="<%= request.getContextPath() %>/ketua/update" method="post">
                <input type="hidden" name="idPengguna" id="editId">
                
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Nama Penuh</label>
                            <input type="text" name="namaLengkap" id="editNama" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">No. KP</label>
                            <input type="text" name="nomborKP" id="editKP" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">No. Telefon</label>
                            <input type="text" name="nomborTelefon" id="editTel" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Kata Laluan</label>
                            <input type="text" name="kataLaluan" id="editPass" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>

                        <div class="md:col-span-2 border-t border-gray-100 my-2"></div>
                        <h4 class="md:col-span-2 text-xs font-bold text-[#6C5DD3] uppercase">Alamat</h4>

                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-gray-500 mb-1">Jalan / No. Rumah</label>
                            <input type="text" name="namaJalan" id="editJalan" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Poskod</label>
                            <input type="text" name="nomborPoskod" id="editPoskod" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-1">Bandar</label>
                            <input type="text" name="bandar" id="editBandar" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" class="inline-flex w-full justify-center rounded-xl bg-[#6C5DD3] px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-[#5b4eb8] sm:ml-3 sm:w-auto">Simpan</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalEdit')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Tab Switching
    function switchTab(tabName) {
        // Reset Buttons
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]');
            btn.classList.add('border-transparent', 'text-gray-500');
        });
        // Activate Button
        document.getElementById('tab-' + tabName).classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]');
        document.getElementById('tab-' + tabName).classList.remove('border-transparent', 'text-gray-500');

        // Toggle Content
        document.getElementById('content-jkkk').classList.add('hidden');
        document.getElementById('content-penduduk').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    // Modal Functions
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    function openEditModal(id, nama, kp, tel, jalan, bandar, poskod, negeri, pass) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editKP').value = kp;
        document.getElementById('editTel').value = tel;
        document.getElementById('editJalan').value = jalan;
        document.getElementById('editBandar').value = (bandar === 'null' || bandar === '-') ? '' : bandar;
        document.getElementById('editPoskod').value = (poskod === 'null' || poskod === '-') ? '' : poskod;
        document.getElementById('editPass').value = pass;
        
        openModal('modalEdit');
    }

    // Search Filter
    document.getElementById('searchPenduduk').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#tablePenduduk tbody tr');
        rows.forEach(row => {
            let text = "";
            row.querySelectorAll('.search-col').forEach(col => text += col.innerText.toLowerCase() + " ");
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });
</script>

<%@ include file="/views/common/footer.jsp" %>