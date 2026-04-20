<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Pusat Kawalan</h2>
            <p class="text-gray-500 text-sm">Urus tadbir organisasi AJK dan penduduk kampung.</p>
        </div>
        <div>
            <button onclick="openModal('modalLantik')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-user-shield"></i> Lantik AJK
            </button>
        </div>
    </div>

    <% if (request.getParameter("status") != null) { %>
        <% if (request.getParameter("status").equals("updated")) { %>
            <div class="bg-green-50 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-r-xl shadow-sm animate-fade-in flex items-center gap-3">
                <i class="fas fa-check-circle"></i>
                <p class="text-sm font-bold">Profil berjaya dikemaskini!</p>
            </div>
        <% } else if (request.getParameter("status").equals("lantikSuccess")) { %>
            <div class="bg-blue-50 border-l-4 border-blue-500 text-blue-700 p-4 mb-6 rounded-r-xl shadow-sm flex items-center gap-3">
                <i class="fas fa-user-shield"></i>
                <p class="text-sm font-bold">AJK Baharu berjaya dilantik!</p>
            </div>
        <% } else if (request.getParameter("status").equals("dropSuccess")) { %>
            <div class="bg-orange-50 border-l-4 border-orange-500 text-orange-700 p-4 mb-6 rounded-r-xl shadow-sm flex items-center gap-3">
                <i class="fas fa-user-minus"></i>
                <p class="text-sm font-bold">Jawatan telah digugurkan.</p>
            </div>
        <% } else if (request.getParameter("status").equals("error")) { %>
            <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-r-xl shadow-sm flex items-center gap-3">
                <i class="fas fa-exclamation-circle"></i>
                <p class="text-sm font-bold">Ralat berlaku. Sila cuba lagi.</p>
            </div>
        <% } %>
    <% } %>

    <div class="mb-6 border-b border-gray-200">
        <nav class="flex gap-6" aria-label="Tabs">
            <button onclick="switchTab('jkkk')" id="tab-jkkk" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-id-badge"></i> Senarai AJK
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
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Nama Penuh</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Kad Pengenalan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Telefon</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% 
                        List<Pengguna> listJKKK = (List<Pengguna>) request.getAttribute("listAJK");
                        if (listJKKK != null && !listJKKK.isEmpty()) {
                            int countAJK = 1;
                            for (Pengguna p : listJKKK) { 
                        %>
                        <tr class="hover:bg-purple-50/30 transition">
                            <td class="p-4 text-sm text-gray-500 font-medium"><%= countAJK++ %></td>
                            <td class="p-4 text-sm font-bold text-gray-800 flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center text-xs font-bold">
                                    <%= (p.getNama_penuh() != null) ? p.getNama_penuh().substring(0,1).toUpperCase() : "U" %>
                                </div>
                                <%= p.getNama_penuh() %>
                            </td>
                            <td class="p-4 text-sm text-gray-600 font-mono"><%= p.getNombor_kp() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNombor_telefon() %></td>
                            <td class="p-4">
                                <div class="flex items-center justify-center gap-2">
                                    <% if (p.getLatitude() != null && p.getLongitude() != null) { %>
                                        <button onclick="viewLocation('<%= p.getNama_penuh() %>', <%= p.getLatitude() %>, <%= p.getLongitude() %>)"
                                                class="bg-blue-50 text-blue-600 hover:bg-blue-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition" title="Lihat Lokasi">
                                            <i class="fas fa-map-marker-alt"></i>
                                        </button>
                                        <a href="https://www.google.com/maps/dir/?api=1&destination=<%= p.getLatitude() %>,<%= p.getLongitude() %>"
                                           target="_blank"
                                           class="bg-green-50 text-green-600 hover:bg-green-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition"
                                           title="Navigasi (Google Maps)">
                                            <i class="fas fa-route"></i>
                                        </a>
                                    <% } %>
                                    
                                    <% 
                                        String tarikh = (p.getTarikh_lahir() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(p.getTarikh_lahir()) : "";
                                    %>
                                    <button onclick="openEditModal('<%= p.getId_pengguna() %>', '<%= p.getNama_penuh() %>', '<%= p.getNombor_kp() %>', '<%= p.getNombor_telefon() %>', '<%= p.getNama_jalan() %>', '<%= p.getBandar() %>', '<%= p.getNombor_poskod() %>', '<%= p.getNegeri() %>', '<%= tarikh %>', '<%= p.getStatus_keluarga() %>')"
                                            class="bg-purple-50 text-[#6C5DD3] hover:bg-[#6C5DD3] hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <form action="<%= request.getContextPath() %>/ketua/gugurkan" method="post" onsubmit="return confirm('Adakah anda pasti untuk menggugurkan jawatan ini?')">
                                        <input type="hidden" name="idPengguna" value="<%= p.getId_pengguna() %>">
                                        <input type="hidden" name="idJawatan" value="<%= p.getId_jawatan() %>">
                                        <button type="submit" class="bg-red-50 text-red-500 hover:bg-red-500 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition" title="Gugurkan Jawatan">
                                            <i class="fas fa-user-minus"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        <% } } else { %>
                        <tr><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-user-slash text-3xl mb-2 block opacity-50"></i>Tiada ahli AJK dilantik.</td></tr>
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
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
                            int countPenduduk = 1;
                            for (Pengguna p : listPenduduk) { 
                        %>
                        <tr class="hover:bg-gray-50/50 transition">
                            <td class="p-4 text-sm text-gray-500 font-medium"><%= countPenduduk++ %></td>
                            <td class="p-4 text-sm font-bold text-gray-800 search-col"><%= p.getNama_penuh() %></td>
                            <td class="p-4 text-sm text-gray-600 search-col"><%= p.getNombor_kp() %></td>
                            <td class="p-4 text-sm text-gray-500 max-w-xs truncate search-col"><%= p.getNama_jalan() %></td>
                            <td class="p-4 text-sm text-gray-500"><%= p.getNombor_telefon() %></td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <% if (p.getLatitude() != null && p.getLongitude() != null) { %>
                                        <button onclick="viewLocation('<%= p.getNama_penuh() %>', <%= p.getLatitude() %>, <%= p.getLongitude() %>)"
                                                class="text-blue-500 hover:text-blue-700 transition" title="Lihat Lokasi">
                                            <i class="fas fa-map-marker-alt"></i>
                                        </button>
                                        <a href="https://www.google.com/maps/dir/?api=1&destination=<%= p.getLatitude() %>,<%= p.getLongitude() %>"
                                           target="_blank"
                                           class="text-green-500 hover:text-green-700 transition"
                                           title="Navigasi (Google Maps)">
                                            <i class="fas fa-route"></i>
                                        </a>
                                    <% } %>
                                    
                                    <% 
                                        String tarikhPenduduk = (p.getTarikh_lahir() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(p.getTarikh_lahir()) : "";
                                    %>
                                    <button onclick="openEditModal('<%= p.getId_pengguna() %>', '<%= p.getNama_penuh() %>', '<%= p.getNombor_kp() %>', '<%= p.getNombor_telefon() %>', '<%= p.getNama_jalan() %>', '<%= p.getBandar() %>', '<%= p.getNombor_poskod() %>', '<%= p.getNegeri() %>', '<%= tarikhPenduduk %>', '<%= p.getStatus_keluarga() %>')"
                                            class="text-gray-400 hover:text-[#6C5DD3] transition">
                                        <i class="fas fa-pencil-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-users-slash text-3xl mb-2 block opacity-50"></i>Tiada data penduduk.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <h3 class="font-bold text-lg text-gray-800 mb-8">Statistik Organisasi</h3>
    <div class="space-y-4">
        <div class="bg-purple-50 p-4 rounded-2xl flex items-center gap-4 border border-purple-100">
            <div class="w-10 h-10 bg-purple-100 text-[#6C5DD3] rounded-full flex items-center justify-center font-bold">
                <i class="fas fa-user-shield"></i>
            </div>
            <div>
                <p class="text-xs text-gray-500 font-bold uppercase">Ahli AJK</p>
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
</aside>

<div id="modalLantik" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm" onclick="closeModal('modalLantik')"></div>
    <div class="relative min-h-screen flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden transform transition-all">
            <div class="bg-[#6C5DD3] p-6 text-white flex justify-between items-center">
                <div>
                    <h3 class="text-xl font-bold">Lantik AJK Baharu</h3>
                    <p class="text-xs opacity-80">Pilih penduduk dan jawatan yang tersedia.</p>
                </div>
                <button onclick="closeModal('modalLantik')" class="text-white hover:rotate-90 transition-transform duration-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            
            <form action="<%= request.getContextPath() %>/ketua/lantik" method="post" class="p-6 space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">1. Pilih Penduduk</label>
                    <select name="idPengguna" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm font-medium">
                        <option value="">-- Pilih Penduduk --</option>
                        <% 
                            List<Pengguna> listPendudukSelection = (List<Pengguna>) request.getAttribute("listPenduduk");
                            if (listPendudukSelection != null) {
                                for (Pengguna pp : listPendudukSelection) {
                        %>
                            <option value="<%= pp.getId_pengguna() %>"><%= pp.getNama_penuh() %> (<%= pp.getNombor_kp() %>)</option>
                        <% 
                                }
                            }
                        %>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">2. Pilih Jawatan</label>
                    <select name="idJawatan" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm font-medium">
                        <option value="">-- Pilih Jawatan --</option>
                        <% 
                            List<Pengguna> listJawatanSelection = (List<Pengguna>) request.getAttribute("listJawatan");
                            if (listJawatanSelection != null) {
                                for (Pengguna j : listJawatanSelection) {
                                    boolean isOccupied = (j.getId_pengguna() > 0);
                        %>
                            <option value="<%= j.getStatus() %>" <%= isOccupied ? "disabled" : "" %>>
                                <%= j.getNama_jawatan() %> <%= isOccupied ? "(Penuh: " + j.getNama_penuh() + ")" : "" %>
                            </option>
                        <% 
                                }
                            }
                        %>
                    </select>
                    <p class="text-[10px] text-gray-400 mt-2">
                        <i class="fas fa-info-circle"></i> Jawatan yang mempunyai pemegang perlu digugurkan terlebih dahulu.
                    </p>
                </div>

                <div class="pt-4 flex gap-3">
                    <button type="button" onclick="closeModal('modalLantik')" 
                            class="flex-1 px-6 py-3 bg-gray-100 text-gray-600 font-bold rounded-xl hover:bg-gray-200 transition">
                        Batal
                    </button>
                    <button type="submit" 
                            class="flex-1 px-6 py-3 bg-[#6C5DD3] text-white font-bold rounded-xl shadow-lg shadow-purple-200 hover:bg-[#5b4eb8] transition">
                        Lantik Sekarang
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="modalEdit" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalEdit')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:w-full sm:max-w-2xl">
            <div class="bg-gray-50 px-6 py-4 border-b border-gray-100">
                <h3 class="font-bold text-gray-900 flex items-center gap-2"><i class="fas fa-user-edit text-[#6C5DD3]"></i> Kemaskini Maklumat</h3>
            </div>
            <form action="<%= request.getContextPath() %>/ketua/update" method="post" class="p-6">
                <input type="hidden" name="idPengguna" id="editId">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">Nama Penuh</label>
                        <input type="text" id="editNama" readonly class="w-full px-4 py-2 rounded-xl bg-gray-100 border-none text-gray-500 text-sm cursor-not-allowed">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">No. KP</label>
                        <input type="text" id="editKP" readonly class="w-full px-4 py-2 rounded-xl bg-gray-100 border-none text-gray-500 text-sm cursor-not-allowed">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">Tarikh Lahir</label>
                        <input type="text" id="editTarikhLahir" readonly class="w-full px-4 py-2 rounded-xl bg-gray-100 border-none text-gray-500 text-sm cursor-not-allowed">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">Status Keluarga</label>
                        <select name="statusKeluarga" id="editStatusKeluarga" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                            <option value="Bujang">Bujang</option>
                            <option value="Berkahwin">Berkahwin</option>
                            <option value="Ibu Tunggal">Ibu Tunggal</option>
                            <option value="Duda">Duda</option>
                        </select>
                    </div>
                    <div class="md:col-span-2 border-t border-gray-100 my-2 pt-4">
                        <h4 class="text-sm font-bold text-gray-700">Maklumat Boleh Dikemaskini</h4>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">No. Telefon</label>
                        <input type="text" name="nomborTelefon" id="editTel" required class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                    </div>
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
                    <div>
                        <label class="block text-xs font-bold text-gray-500 mb-1">Negeri</label>
                        <input type="text" name="negeri" id="editNegeri" class="w-full px-4 py-2 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-sm">
                    </div>
                </div>
                <div class="flex flex-row-reverse gap-2 pt-6">
                    <button type="submit" class="bg-[#6C5DD3] text-white px-6 py-2 rounded-xl font-bold text-sm">Simpan</button>
                    <button type="button" onclick="closeModal('modalEdit')" class="text-gray-500 px-6 py-2">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

<%-- Modal View Location (Map) --%>
<div id="modalLocation" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm" onclick="closeModal('modalLocation')"></div>
    <div class="relative min-h-screen flex items-center justify-center p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all">
            <div class="bg-[#6C5DD3] p-6 text-white flex justify-between items-center">
                <div>
                    <h3 class="text-xl font-bold" id="locationTitle">Lokasi Kediaman</h3>
                    <p class="text-xs opacity-80">Koordinat GPS penduduk.</p>
                </div>
                <button onclick="closeModal('modalLocation')" class="text-white hover:rotate-90 transition-transform duration-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-4">
                <div id="mapView" style="height: 450px; border-radius: 1.5rem;" class="border border-gray-200"></div>
            </div>
            <div class="p-6 bg-gray-50 flex justify-end">
                <button onclick="closeModal('modalLocation')" class="px-8 py-3 bg-[#6C5DD3] text-white font-bold rounded-xl shadow-lg hover:bg-[#5b4eb8] transition">
                    Tutup
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    let viewMap;
    let viewMarker;

    function viewLocation(nama, lat, lon) {
        document.getElementById('locationTitle').innerText = "Lokasi: " + nama;
        openModal('modalLocation');
        
        setTimeout(() => {
            if (!viewMap) {
                viewMap = L.map('mapView').setView([lat, lon], 17);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    maxZoom: 19,
                    attribution: '© OpenStreetMap'
                }).addTo(viewMap);
                viewMarker = L.marker([lat, lon]).addTo(viewMap);
            } else {
                viewMap.setView([lat, lon], 17);
                viewMarker.setLatLng([lat, lon]);
            }
            viewMap.invalidateSize();
        }, 300);
    }

    function switchTab(tabName) {
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]');
            btn.classList.add('border-transparent', 'text-gray-500');
        });
        document.getElementById('tab-' + tabName).classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]');
        document.getElementById('tab-' + tabName).classList.remove('border-transparent', 'text-gray-500');
        document.getElementById('content-jkkk').classList.add('hidden');
        document.getElementById('content-penduduk').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    function openModal(modalId) { document.getElementById(modalId).classList.remove('hidden'); }
    function closeModal(modalId) { document.getElementById(modalId).classList.add('hidden'); }

    function openEditModal(id, nama, kp, tel, jalan, bandar, poskod, negeri, tarikh, statusKeluarga) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editKP').value = kp;
        document.getElementById('editTel').value = tel;
        document.getElementById('editJalan').value = jalan;
        document.getElementById('editBandar').value = (bandar === 'null' || bandar === '-') ? '' : bandar;
        document.getElementById('editPoskod').value = (poskod === 'null' || poskod === '-') ? '' : poskod;
        document.getElementById('editNegeri').value = (negeri === 'null' || negeri === '-') ? '' : negeri;
        document.getElementById('editTarikhLahir').value = (tarikh === 'null' || tarikh === '-') ? '' : tarikh;
        document.getElementById('editStatusKeluarga').value = (statusKeluarga === 'null' || statusKeluarga === '-') ? 'Bujang' : statusKeluarga;
        openModal('modalEdit');
    }

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