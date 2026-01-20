<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %> 
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<PermohonanBantuan> mainList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
    List<Bantuan> senaraiJenis = (List<Bantuan>) request.getAttribute("senaraiJenisBantuan");

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
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm animate-fade-in-up">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Permohonan anda telah dihantar.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Bantuan Komuniti</h2>
            <p class="text-gray-500 text-sm">Mohon bantuan kebajikan, khairat kematian, atau sumbangan tabung.</p>
        </div>
        <div class="flex gap-3">
            <button onclick="openModal('modalPilihan')" class="bg-white border border-gray-200 text-gray-600 hover:border-[#6C5DD3] hover:text-[#6C5DD3] px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-sm flex items-center gap-2">
                <i class="fas fa-file-alt"></i> Buat Permohonan
            </button>
            <button onclick="openModal('modalHantar')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-paper-plane"></i> Hantar Borang
            </button>
        </div>
    </div>

    <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
                        <tr class="data-row hover:bg-purple-50/50 transition-colors" data-date="<%= filterDate %>">
                            <td class="p-4 text-sm font-medium text-gray-600 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] search-col"><%= pb.getNamaBantuan() %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="inline-flex items-center gap-2 px-3 py-1 bg-red-50 text-red-600 rounded-lg text-xs font-bold hover:bg-red-100 transition">
                                        <i class="fas fa-file-pdf"></i> PDF
                                    </a>
                                <% } else { %> <span class="text-gray-400">-</span> <% } %>
                            </td>
                            <td class="p-4">
                                <% if (pb.getStatus() == 0) { %> 
                                    <span class="px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold">Dalam Proses</span>
                                <% } else if (pb.getStatus() == 2) { %> 
                                    <span class="px-3 py-1 rounded-full bg-orange-50 text-orange-600 text-xs font-bold">Tidak Lengkap</span>
                                <% } else if (pb.getStatus() == 3) { %> 
                                    <span class="px-3 py-1 rounded-full bg-purple-50 text-purple-600 text-xs font-bold">Disemak JKKK</span> 
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <% if (pb.getStatus() == 0) { %>
                                    <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getIdPermohonan() %>" 
                                       onclick="return confirm('Adakah anda pasti mahu memadam permohonan ini?');"
                                       class="w-8 h-8 rounded-full bg-gray-100 text-gray-500 hover:bg-red-100 hover:text-red-500 inline-flex items-center justify-center transition">
                                        <i class="fas fa-trash-alt text-xs"></i>
                                    </a>
                                <% } else { %> <span class="text-gray-300 text-xs"><i class="fas fa-lock"></i></span> <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada permohonan aktif.</td></tr>
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Keterangan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Ulasan Admin</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) {
                            for (PermohonanBantuan pb : listSejarah) {
                                String filterDate = (pb.getTarikhMohon() != null) ? sdfFull.format(pb.getTarikhMohon()) : "";
                                String displayDate = (pb.getTarikhMohon() != null) ? sdfDisplay.format(pb.getTarikhMohon()) : "-";
                        %>
                        <tr class="data-row" data-date="<%= filterDate %>">
                            <td class="p-4 text-sm text-gray-500 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-700 search-col"><%= pb.getNamaBantuan() %></td>
                            <td class="p-4 text-sm text-gray-500 search-col max-w-xs truncate"><%= (pb.getCatatan() != null) ? pb.getCatatan() : "-" %></td>
                            <td class="p-4 text-sm text-gray-500 max-w-xs truncate"><%= (pb.getUlasanAdmin() != null) ? pb.getUlasanAdmin() : "-" %></td>
                            <td class="p-4">
                                <% if (pb.getStatus() == 1) { %> 
                                    <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-check-circle"></i> Lulus</span>
                                <% } else { %> 
                                    <span class="px-3 py-1 rounded-full bg-red-50 text-red-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-times-circle"></i> Ditolak</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="5" class="p-8 text-center text-gray-400"><i class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada sejarah permohonan.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Panduan</h3>
    </div>

    <div class="space-y-6 relative">
        <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>

        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center font-bold text-sm border-2 border-white shadow-sm">1</div>
            <h4 class="font-bold text-sm text-gray-800">Muat Turun</h4>
            <p class="text-xs text-gray-500 mt-1">Pilih jenis bantuan dan muat turun borang PDF yang disediakan.</p>
        </div>

        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center font-bold text-sm border-2 border-white shadow-sm">2</div>
            <h4 class="font-bold text-sm text-gray-800">Isi Borang</h4>
            <p class="text-xs text-gray-500 mt-1">Lengkapkan maklumat secara manual atau digital.</p>
        </div>

        <div class="relative pl-10">
            <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center font-bold text-sm border-2 border-white shadow-sm">3</div>
            <h4 class="font-bold text-sm text-gray-800">Muat Naik</h4>
            <p class="text-xs text-gray-500 mt-1">Tangkap gambar/scan borang dan muat naik semula di sini.</p>
        </div>
    </div>

    <div class="mt-auto bg-blue-50 rounded-2xl p-6 relative overflow-hidden">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-blue-200 rounded-full opacity-50"></div>
        <h4 class="font-bold text-blue-600 mb-2 relative z-10"><i class="fas fa-info-circle mr-1"></i> Perhatian</h4>
        <p class="text-xs text-gray-600 leading-relaxed relative z-10">
            Sila pastikan dokumen sokongan (Salinan IC, Slip Gaji) disertakan sekali dalam satu fail PDF jika perlu.
        </p>
    </div>
</aside>

<div id="modalPilihan" class="fixed inset-0 z-50 hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalPilihan')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            
            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                <div class="sm:flex sm:items-start">
                    <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-purple-100 sm:mx-0 sm:h-10 sm:w-10">
                        <i class="fas fa-file-download text-[#6C5DD3]"></i>
                    </div>
                    <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                        <h3 class="text-lg font-semibold leading-6 text-gray-900" id="modal-title">Pilih Borang Bantuan</h3>
                        <div class="mt-2">
                            <p class="text-sm text-gray-500 mb-4">Sila pilih jenis borang untuk diisi dan dimuat turun:</p>
                            
                            <div class="space-y-2 max-h-60 overflow-y-auto pr-2 custom-scrollbar">
                                <% if (senaraiJenis != null) {
                                    for (Bantuan b : senaraiJenis) { %>
                                    <a href="borangDigital.jsp?id=<%= b.getIdBantuan() %>&nama=<%= URLEncoder.encode(b.getNamaBantuan(), "UTF-8") %>" 
                                       class="flex items-center justify-between w-full p-4 bg-gray-50 hover:bg-purple-50 rounded-xl border border-transparent hover:border-purple-200 group transition">
                                        <span class="font-bold text-gray-700 group-hover:text-[#6C5DD3] text-sm"><%= b.getNamaBantuan() %></span>
                                        <i class="fas fa-chevron-right text-gray-300 group-hover:text-[#6C5DD3]"></i>
                                    </a>
                                <% } } %>
                                <a href="borangDigital.jsp?id=999&nama=Lain-Lain" 
                                   class="flex items-center justify-between w-full p-4 bg-gray-50 hover:bg-gray-100 rounded-xl border border-transparent hover:border-gray-200 group transition">
                                    <span class="font-bold text-gray-500 group-hover:text-gray-700 text-sm">LAIN-LAIN</span>
                                    <i class="fas fa-chevron-right text-gray-300"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6">
                <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalPilihan')">Tutup</button>
            </div>
        </div>
    </div>
</div>

<div id="modalHantar" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalHantar')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data">
                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-green-100 sm:mx-0 sm:h-10 sm:w-10">
                            <i class="fas fa-paper-plane text-green-600"></i>
                        </div>
                        <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left w-full">
                            <h3 class="text-lg font-semibold leading-6 text-gray-900">Hantar Permohonan</h3>
                            
                            <div class="mt-4 space-y-4">
                                <div class="bg-blue-50 text-blue-700 p-3 rounded-lg text-xs flex gap-2 items-start">
                                    <i class="fas fa-info-circle mt-0.5"></i>
                                    <p>Sila muat naik borang PDF yang telah lengkap diisi.</p>
                                </div>

                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Kategori Bantuan</label>
                                    <div class="relative">
                                        <select name="jenisBantuan" id="jenisBantuanSubmit" required onchange="toggleLainBantuan()"
                                                class="w-full px-4 py-2.5 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm appearance-none">
                                            <option value="" disabled selected>-- Pilih Kategori --</option>
                                            <% if (senaraiJenis != null) {
                                                for (Bantuan b : senaraiJenis) { %>
                                                <option value="<%= b.getIdBantuan() %>"><%= b.getNamaBantuan() %></option>
                                            <% } } %>
                                            <option value="999">LAIN-LAIN</option>
                                        </select>
                                        <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                                            <i class="fas fa-chevron-down text-xs"></i>
                                        </div>
                                    </div>
                                </div>

                                <div id="lainBantuanDiv" class="hidden">
                                    <label class="block text-xs font-bold text-purple-600 mb-1">Nyatakan Jenis Bantuan</label>
                                    <input type="text" name="jenisBantuanLain" class="w-full px-4 py-2.5 rounded-xl bg-purple-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm">
                                </div>

                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Dokumen (PDF)</label>
                                    <input type="file" name="dokumenSokongan" accept="application/pdf" required
                                           class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-purple-50 file:text-[#6C5DD3] hover:file:bg-purple-100">
                                </div>

                                <div>
                                    <label class="block text-xs font-bold text-gray-500 mb-1">Keterangan Lanjut</label>
                                    <textarea name="keterangan" rows="3" placeholder="Nota tambahan..."
                                              class="w-full px-4 py-2.5 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm"></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                    <button type="submit" class="inline-flex w-full justify-center rounded-xl bg-[#6C5DD3] px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-[#5b4eb8] sm:ml-3 sm:w-auto">Hantar Sekarang</button>
                    <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeModal('modalHantar')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Filter Logic
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

    // Modal Logic (Vanilla JS for Tailwind)
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    // Lain-lain Logic
    function toggleLainBantuan() {
        const select = document.getElementById("jenisBantuanSubmit");
        const lainDiv = document.getElementById("lainBantuanDiv");
        const lainInput = lainDiv.querySelector("input");
        
        if (select.value === "999") {
            lainDiv.classList.remove("hidden");
            lainInput.required = true;
        } else {
            lainDiv.classList.add("hidden");
            lainInput.required = false;
        }
    }
</script>

<%@ include file="/views/common/footer.jsp" %>