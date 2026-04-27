<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="model.Hebahan, model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<%
    List<Hebahan> list = (List<Hebahan>) request.getAttribute("hebahanList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Urus Hebahan</h2>
            <p class="text-gray-500 text-sm">Cipta dan kemaskini pengumuman kampung.</p>
        </div>
        <button onclick="openAddModal()" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-6 py-3 rounded-2xl font-bold text-sm transition shadow-lg shadow-purple-100 flex items-center gap-2">
            <i class="fas fa-plus-circle"></i> Tambah Hebahan Baru
        </button>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tajuk</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Kategori</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Status</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh Hebahan</th>
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
                                <span class="text-[10px] text-gray-400 truncate w-48"><%= h.getKandungan() %></span>
                            </div>
                        </td>
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
                        <td class="p-4 text-sm text-gray-600"><%= h.getTarikh_hebahan() != null ? sdf.format(h.getTarikh_hebahan()) : "-" %></td>
                        <td class="p-4 text-center">
                            <div class="flex justify-center gap-2">
                                <button onclick="openEditModal(this)" 
                                        data-id="<%= h.getId_hebahan() %>"
                                        data-tajuk="<%= h.getTajuk() %>"
                                        data-kandungan="<%= h.getKandungan() %>"
                                        data-kategori="<%= h.getKategori() %>"
                                        data-status="<%= h.getStatus_hebahan() %>"
                                        data-lokasi="<%= h.getLokasi_acara() != null ? h.getLokasi_acara() : "" %>"
                                        data-mula="<%= h.getTarikh_mula_acara() != null ? sdfInput.format(h.getTarikh_mula_acara()) : "" %>"
                                        data-tamat_acara="<%= h.getTarikh_tamat_acara() != null ? sdfInput.format(h.getTarikh_tamat_acara()) : "" %>"
                                        data-tamat_hebahan="<%= h.getTarikh_tamat() != null ? sdfInput.format(h.getTarikh_tamat()) : "" %>"
                                        class="text-blue-400 hover:text-blue-600 transition">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button onclick="confirmDelete(<%= h.getId_hebahan() %>)" class="text-red-400 hover:text-red-600 transition">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" class="p-12 text-center text-gray-400">
                            <i class="fas fa-comment-slash text-4xl mb-4 opacity-20"></i>
                            <p class="font-bold">Tiada Rekod Hebahan</p>
                            <p class="text-xs">Klik 'Tambah Hebahan Baru' untuk mula.</p>
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
    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800">Statistik Hebahan</h3>
        <p class="text-xs text-gray-400 font-medium">Ringkasan kandungan anda</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Jumlah Hebahan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= list != null ? list.size() : 0 %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-purple-100 text-[#6C5DD3] flex items-center justify-center">
                <i class="fas fa-bullhorn"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Panduan Pengurusan</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-xs border-2 border-[#6C5DD3] z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Draf atau Terbit</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Gunakan status 'Draft' jika maklumat belum muktamad.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Kategori Kecemasan</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Hebahan kecemasan akan sentiasa berada di kedudukan teratas paparan penduduk.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">3</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Poster & Gambar</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Muat naik poster menarik untuk menarik perhatian penduduk.</p>
            </div>
        </div>
    </div>
</aside>

<!-- Modal Tambah/Edit Hebahan -->
<div id="modalHebahan" class="fixed inset-0 z-50 hidden">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeModal('modalHebahan')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-[#6C5DD3] px-6 py-4 flex justify-between items-center">
                <h3 class="text-lg font-bold text-white flex items-center gap-2"><i class="fas fa-bullhorn"></i> <span id="modalTitle">Hebahan Baru</span></h3>
                <button class="text-white hover:text-gray-200" onclick="closeModal('modalHebahan')"><i class="fas fa-times"></i></button>
            </div>
            <form id="formHebahan" action="<%= request.getContextPath() %>/hebahan/create" method="post" enctype="multipart/form-data" onsubmit="return validateHebahanForm()">
                <input type="hidden" name="id_hebahan" id="id_hebahan">
                <div class="bg-white px-8 py-6 space-y-4 max-h-[70vh] overflow-y-auto">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tajuk Hebahan</label>
                        <input type="text" name="tajuk" id="tajuk" required maxlength="50" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Kandungan</label>
                        <textarea name="kandungan" id="kandungan" rows="4" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition"></textarea>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Kategori</label>
                            <select name="kategori" id="kategori" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                                <option value="Umum">Umum</option>
                                <option value="Aktiviti">Aktiviti</option>
                                <option value="Kecemasan">Kecemasan</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Status</label>
                            <select name="status_hebahan" id="status_hebahan" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                                <option value="Draft">Draft</option>
                                <option value="Published">Published</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Mula Acara</label>
                            <input type="datetime-local" name="tarikh_mula_acara" id="tarikh_mula_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Tamat Acara</label>
                            <input type="datetime-local" name="tarikh_tamat_acara" id="tarikh_tamat_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Lokasi Acara</label>
                        <input type="text" name="lokasi_acara" id="lokasi_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Auto-Archive (Hebahan Tamat)</label>
                        <input type="datetime-local" name="tarikh_tamat" id="tarikh_tamat" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Gambar Poster</label>
                        <input type="file" name="gambar_poster" accept="image/*" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Simpan</button>
                    <button type="button" onclick="closeModal('modalHebahan')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

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
                <p class="text-sm text-gray-500">Tindakan ini tidak boleh diundur.</p>
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
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Hebahan Baru';
        document.getElementById('formHebahan').action = '<%= request.getContextPath() %>/hebahan/create';
        document.getElementById('id_hebahan').value = '';
        document.getElementById('formHebahan').reset();
        document.getElementById('modalHebahan').classList.remove('hidden');
    }

    function openEditModal(btn) {
        document.getElementById('modalTitle').innerText = 'Kemaskini Hebahan';
        document.getElementById('formHebahan').action = '<%= request.getContextPath() %>/hebahan/update';
        document.getElementById('id_hebahan').value = btn.getAttribute('data-id');
        document.getElementById('tajuk').value = btn.getAttribute('data-tajuk');
        document.getElementById('kandungan').value = btn.getAttribute('data-kandungan');
        document.getElementById('kategori').value = btn.getAttribute('data-kategori');
        document.getElementById('status_hebahan').value = btn.getAttribute('data-status');
        document.getElementById('lokasi_acara').value = btn.getAttribute('data-lokasi');
        document.getElementById('tarikh_mula_acara').value = btn.getAttribute('data-mula');
        document.getElementById('tarikh_tamat_acara').value = btn.getAttribute('data-tamat_acara');
        document.getElementById('tarikh_tamat').value = btn.getAttribute('data-tamat_hebahan');
        
        document.getElementById('modalHebahan').classList.remove('hidden');
    }

    function confirmDelete(id) {
        document.getElementById('delete_id').value = id;
        document.getElementById('modalDelete').classList.remove('hidden');
    }

    function closeModal(id) {
        document.getElementById(id).classList.add('hidden');
    }

    function validateHebahanForm() {
        const mula = document.getElementById('tarikh_mula_acara').value;
        const tamat = document.getElementById('tarikh_tamat_acara').value;
        if (mula && tamat && new Date(tamat) <= new Date(mula)) {
            alert('Tarikh tamat acara mesti selepas tarikh mula.');
            return false;
        }
        return true;
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
