<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<PermohonanBantuan> mainList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
    List<PermohonanBantuan> listProses = new ArrayList<>();
    List<PermohonanBantuan> listSejarah = new ArrayList<>();
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd MMM yyyy");

    if (mainList != null) {
        Collections.sort(mainList, (o1, o2) -> Integer.compare(o2.getIdPermohonan(), o1.getIdPermohonan()));
        for (PermohonanBantuan pb : mainList) {
            if (pb.getStatus() == 0 || pb.getStatus() == 2 || pb.getStatus() == 3) {
                listProses.add(pb);
            } else {
                listSejarah.add(pb);
            }
        }
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <% if (request.getParameter("status") != null) { %>
    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
        <i class="fas fa-check-circle text-lg"></i>
        <div>
            <span class="font-bold">Berjaya!</span> Rekod telah dikemaskini.
        </div>
        <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
    </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
        <i class="fas fa-exclamation-circle text-lg"></i>
        <div>
            <span class="font-bold">Ralat!</span> <%= request.getParameter("error") %>
        </div>
        <button onclick="this.parentElement.remove()" class="ml-auto text-red-500 hover:text-red-700"><i class="fas fa-times"></i></button>
    </div>
    <% } %>

    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Rekod Bantuan Rasmi</h2>
            <p class="text-gray-500 text-sm">Pantau status permohonan bantuan kerajaan dan sokongan penghulu.</p>
        </div>
        <div>
            <button onclick="openModal('modalMohon')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-plus"></i> Mohon Baru
            </button>
        </div>
    </div>

    <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterData()" placeholder="Nama bantuan, keterangan..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm transition-all">
                </div>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Tarikh Mohon</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterData()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm transition-all">
                </div>
            </div>
             <div>
                <label class="block text-xs font-bold text-gray-500 mb-2 uppercase tracking-wider">Status Sejarah</label>
                <div class="relative">
                    <select id="statusFilter" onchange="filterData()" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm appearance-none">
                        <option value="all">Semua Status</option>
                        <option value="1">Lulus (Disokong)</option>
                        <option value="2">Ditolak</option>
                    </select>
                    <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                        <i class="fas fa-chevron-down text-xs"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <i class="fas fa-hourglass-half text-blue-500"></i> Sedang Diproses
        </h3>
        
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableProses">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Keterangan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listProses.isEmpty()) { 
                            for (PermohonanBantuan pb : listProses) {
                                String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition-colors" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                            <td class="p-4 text-sm font-medium text-gray-600 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] search-col"><%= pb.getNamaBantuan() %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="inline-flex items-center gap-2 px-3 py-1 bg-gray-100 text-gray-600 rounded-lg text-xs font-bold hover:bg-gray-200 transition">
                                        <i class="fas fa-file-pdf text-red-500"></i> PDF
                                    </a>
                                <% } else { %> <span class="text-gray-400">-</span> <% } %>
                            </td>
                            <td class="p-4 text-sm text-gray-500 search-col max-w-xs truncate"><%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %></td>
                            <td class="p-4">
                                <% if (pb.getStatus() == 2) { %> 
                                    <div class="flex flex-col">
                                        <span class="text-xs text-red-500 font-bold mb-1"><i class="fas fa-exclamation-circle"></i> <%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "Sila kemaskini" %></span>
                                        <span class="px-3 py-1 rounded-full bg-orange-50 text-orange-600 text-xs font-bold w-max">Tidak Lengkap</span>
                                    </div>
                                <% } else if (pb.getStatus() == 3) { %> 
                                    <span class="px-3 py-1 rounded-full bg-purple-50 text-purple-600 text-xs font-bold w-max"><i class="fas fa-check-circle mr-1"></i> Disemak JKKK</span> 
                                <% } else { %>
                                    <span class="px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold w-max"><i class="fas fa-sync-alt mr-1"></i> Dalam Proses</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center flex justify-center gap-2">
                                <% if (pb.getStatus() == 2) { %>
                                    <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" class="w-8 h-8 rounded-full bg-yellow-100 text-yellow-600 hover:bg-yellow-200 inline-flex items-center justify-center transition" title="Betulkan">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                <% } else if (pb.getStatus() == 0) { %>
                                    <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getIdPermohonan() %>" class="w-8 h-8 rounded-full bg-gray-100 text-gray-500 hover:bg-yellow-100 hover:text-yellow-600 inline-flex items-center justify-center transition">
                                        <i class="fas fa-pen"></i>
                                    </a>
                                    <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getIdPermohonan() %>" 
                                       onclick="return confirm('Padam permohonan ini?');"
                                       class="w-8 h-8 rounded-full bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500 inline-flex items-center justify-center transition">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                <% } else { %>
                                    <span class="text-gray-300"><i class="fas fa-lock"></i></span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="6" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada permohonan sedang diproses.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <i class="fas fa-history text-gray-400"></i> Sejarah Terdahulu
        </h3>
        
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableSejarah">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Keterangan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Ulasan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Dokumen Balik</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Info</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) {
                            for (PermohonanBantuan pb : listSejarah) {
                                String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                        %>
                        <tr class="data-row text-gray-500" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                            <td class="p-4 text-sm whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-700 search-col"><%= pb.getNamaBantuan() %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="text-xs font-bold text-blue-500 hover:underline"><i class="fas fa-file-pdf"></i> PDF</a>
                                <% } else { %> - <% } %>
                            </td>
                            <td class="p-4 text-sm search-col max-w-xs truncate"><%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %></td>
                            <td class="p-4 text-sm max-w-xs truncate"><%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "-" %></td>
                            <td class="p-4">
                                <% if (pb.getStatus() == 1) { %> 
                                    <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-check-circle"></i> Disokong</span>
                                <% } else { %> 
                                    <span class="px-3 py-1 rounded-full bg-red-50 text-red-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-times-circle"></i> Ditolak</span>
                                <% } %>
                            </td>
                            <td class="p-4">
                                <% if (pb.getDokumenBalik() != null && !pb.getDokumenBalik().isEmpty()) { 
                                    String enc = URLEncoder.encode(pb.getDokumenBalik(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="inline-flex items-center gap-1 px-3 py-1 bg-green-50 text-green-600 rounded-lg text-xs font-bold hover:bg-green-100 transition">
                                        <i class="fas fa-download"></i> PDF
                                    </a>
                                <% } else { %> - <% } %>
                            </td>
                            <td class="p-4 text-center text-xs text-gray-400"><i class="fas fa-lock"></i> Selesai</td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="8" class="p-8 text-center text-gray-400"><i class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada sejarah permohonan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Info Penting</h3>
    </div>

    <div class="space-y-6">
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-purple-50 text-[#6C5DD3] flex-shrink-0 flex items-center justify-center font-bold text-lg"><i class="fas fa-id-card"></i></div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Salinan Dokumen</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Pastikan salinan Kad Pengenalan dan Slip Gaji disahkan oleh Pegawai Kerajaan Kumpulan A atau Penghulu.</p>
            </div>
        </div>

        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-blue-50 text-blue-600 flex-shrink-0 flex items-center justify-center font-bold text-lg"><i class="fas fa-file-pdf"></i></div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Format Fail</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Semua dokumen sokongan wajib dimuat naik dalam format <strong>PDF</strong> sahaja.</p>
            </div>
        </div>
        
        <div class="flex gap-4">
            <div class="w-10 h-10 rounded-full bg-green-50 text-green-600 flex-shrink-0 flex items-center justify-center font-bold text-lg"><i class="fas fa-user-check"></i></div>
            <div>
                <h4 class="font-bold text-sm text-gray-800">Pengesahan</h4>
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Permohonan akan disemak oleh JKKK sebelum dimajukan ke peringkat atasan.</p>
            </div>
        </div>
    </div>

    <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
        <h4 class="font-bold text-gray-700 mb-2 text-sm">Masalah Permohonan?</h4>
        <p class="text-xs text-gray-500 mb-4">Hubungi Setiausaha JKKK untuk pertanyaan lanjut mengenai status anda.</p>
        <button class="w-full bg-white border border-gray-200 text-gray-700 py-2 rounded-xl text-xs font-bold hover:bg-gray-100 transition">Hubungi SU</button>
    </div>
</aside>


<div id="modalMohon" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalMohon')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data">
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-purple-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-file-signature text-[#6C5DD3]"></i>
                        </div>
                        <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                            <h3 class="text-lg font-semibold leading-6 text-gray-900">Permohonan Rasmi Baru</h3>
                            <div class="mt-2">
                                <p class="text-sm text-gray-500 mb-4 bg-purple-50 p-3 rounded-lg border border-purple-100">
                                    <i class="fas fa-info-circle mr-1"></i> Sila pastikan semua maklumat adalah benar.
                                </p>

                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-xs font-bold text-gray-500 mb-1">Jenis Bantuan</label>
                                        <div class="relative">
                                            <select name="jenisBantuan" id="jenisBantuan" required onchange="toggleLainBantuan()"
                                                    class="w-full px-4 py-2.5 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-xs font-medium appearance-none">
                                                <option value="" disabled selected>-- Sila Pilih --</option>
                                                <option value="6">BANTUAN AM</option>
                                                <option value="7">BANTUAN HARI RAYA</option>
                                                <option value="8">BANTUAN KEPADA GHARIMIN</option>
                                                <option value="9">BANTUAN MELANJUT PELAJARAN KE IPT</option>
                                                <option value="10">BANTUAN PEMBANGUNAN ASNAF</option>
                                                <option value="11">BANTUAN PEMULIHAN RUMAH KEDIAMAN</option>
                                                <option value="12">BANTUAN RAWATAN PERUBATAN</option>
                                                <option value="13">BANTUAN SEWA RUMAH</option>
                                                <option value="14">BANTUAN TETAP BULANAN</option>
                                                <option value="15">BIASISWA PENDIDIKAN DALAM NEGARA (BPDN)</option>
                                                <option value="16">BIASISWA PENDIDIKAN LUAR NEGARA (BPLN)</option>
                                                <option value="17">BIASISWA PROFESIONAL PERAKAUNAN (BPP)</option>
                                                <option value="18">PROG. BIASISWA SULTAN ISMAIL PETRA (BSIP)</option>
                                                <option value="19">PROGRAM DERMASISWA SULTAN ISMAIL PETRA (DSIP)</option>
                                                <option value="20">SUMBANGAN IPT - FISABILILLAH</option>
                                                <option value="999">LAIN-LAIN</option>
                                            </select>
                                            <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                                                <i class="fas fa-chevron-down text-xs"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <div id="lainBantuanDiv" class="hidden">
                                        <label class="block text-xs font-bold text-purple-600 mb-1">Nyatakan Jenis Bantuan</label>
                                        <input type="text" name="jenisBantuanLain" placeholder="Contoh: Bantuan Bencana Alam"
                                               class="w-full px-4 py-2.5 rounded-xl bg-purple-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm">
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-gray-500 mb-1">Dokumen Sokongan (PDF)</label>
                                        <input type="file" name="dokumenSokongan" accept="application/pdf" required
                                               class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-bold file:bg-purple-50 file:text-[#6C5DD3] hover:file:bg-purple-100">
                                    </div>

                                    <div>
                                        <label class="block text-xs font-bold text-gray-500 mb-1">Keterangan / Sebab</label>
                                        <textarea name="keterangan" rows="2" placeholder="Ringkasan permohonan..."
                                                  class="w-full px-4 py-2.5 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" class="inline-flex w-full justify-center rounded-xl bg-[#6C5DD3] px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-[#5b4eb8] sm:ml-3 sm:w-auto">Hantar Permohonan</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalMohon')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Modal Logic
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    // Toggle Input Lain-lain
    function toggleLainBantuan() {
        const select = document.getElementById("jenisBantuan");
        const lainDiv = document.getElementById("lainBantuanDiv");
        const lainInput = lainDiv.querySelector("input");

        if (select.value === "999") {
            lainDiv.classList.remove("hidden");
            lainInput.required = true;
        } else {
            lainDiv.classList.add("hidden");
            lainInput.required = false;
            lainInput.value = "";
        }
    }

    // Filter Logic
    function filterData() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        const statusVal = document.getElementById("statusFilter").value;
        const rows = document.querySelectorAll(".data-row");

        rows.forEach(row => {
            const rowDate = row.getAttribute("data-date");
            const status = row.getAttribute("data-status");
            let textContent = "";
            row.querySelectorAll(".search-col").forEach(col => {
                textContent += col.innerText.toLowerCase() + " ";
            });

            let showRow = true;
            if (dateVal !== "" && rowDate !== dateVal) showRow = false;
            
            // Filter Status (Logic Asal dikekalkan: Status 1=Lulus, Status 2=Ditolak dalam konteks sejarah)
            if (statusVal !== "all") {
                if (status !== statusVal) showRow = false;
            }
            
            if (searchVal !== "" && !textContent.includes(searchVal)) showRow = false;

            row.style.display = showRow ? "" : "none";
        });
    }
</script>

<%@ include file="/views/common/footer.jsp" %>