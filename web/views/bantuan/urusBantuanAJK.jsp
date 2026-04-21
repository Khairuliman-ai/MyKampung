<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%
    // 1. ASINGKAN DATA KEPADA BARU & SEJARAH
    List<PermohonanBantuan> allList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
    List<PermohonanBantuan> listBaru = new ArrayList<>();
    List<PermohonanBantuan> listSejarah = new ArrayList<>();
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    if (allList != null) {
        for (PermohonanBantuan pb : allList) {
            if (pb.getStatus() == null || "BARU".equalsIgnoreCase(pb.getStatus())) {
                listBaru.add(pb); // Belum Semak
            } else {
                listSejarah.add(pb); // Dah Semak (Lulus/Tolak/Return)
            }
        }
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Semakan Permohonan AJK</h2>
            <p class="text-gray-500 text-sm">Uruskan permohonan baharu dan semak sejarah tindakan.</p>
        </div>
        <div>
            <button onclick="openModal('modalTambahBantuan')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-plus-circle"></i> Jenis Bantuan Baru
            </button>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-[#6C5DD3] rounded-full"></div>
            Permohonan Baharu <span class="bg-purple-100 text-[#6C5DD3] text-xs px-2 py-1 rounded-lg ml-2"><%= listBaru.size() %></span>
        </h3>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-purple-50 border-b border-purple-100">
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Rujukan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Info Pemohon</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider w-1/5">Keterangan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center w-48">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listBaru.isEmpty()) { 
                            for (PermohonanBantuan pb : listBaru) {
                                String namaBantuanDisplay = (pb.getNama_bantuan() != null) ? pb.getNama_bantuan() : "Lain-lain (" + pb.getId_bantuan() + ")";
                                String dateDisplay = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="hover:bg-purple-50/30 transition">
                             <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= pb.getId_permohonan() %></td>
                            <td class="p-4 text-sm text-gray-600 font-medium"><%= dateDisplay %></td>
                            <td class="p-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center text-xs font-bold">
                                        <%= (pb.getNama_penuh() != null) ? pb.getNama_penuh().substring(0,1) : "U" %>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-sm font-bold text-gray-800"><%= (pb.getNama_penuh() != null) ? pb.getNama_penuh() : "TIADA NAMA" %></span>
                                        <span class="text-[10px] text-gray-400">Penduduk Sah</span>
                                    </div>
                                </div>
                            </td>
                            <td class="p-4">
                                <span class="bg-blue-50 text-blue-600 border border-blue-100 px-3 py-1 rounded-lg text-xs font-bold uppercase tracking-wider">
                                    <%= namaBantuanDisplay %>
                                </span>
                            </td>
                            <td class="p-4 text-sm text-gray-500">
                                <%= (pb.getCatatan_pemohon() != null && !pb.getCatatan_pemohon().isEmpty()) ? pb.getCatatan_pemohon() : "-" %>
                            </td>
                            <td class="p-4">
                                <% if (pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="inline-flex items-center gap-2 px-3 py-1.5 bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg text-xs font-bold text-gray-600 transition">
                                        <i class="fas fa-file-pdf text-red-500"></i> PDF
                                    </a>
                                <% } else { %> <span class="text-gray-400">-</span> <% } %>
                            </td>
                             <td class="p-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <button onclick="openActionModal('<%= pb.getId_permohonan() %>', '<%= namaBantuanDisplay %>', 'tak_lengkap')" 
                                            class="flex items-center gap-1 px-3 py-1.5 rounded-lg border border-red-200 text-red-500 hover:bg-red-50 text-xs font-bold transition">
                                        <i class="fas fa-reply"></i> Hantar Semula
                                    </button>
                                    <button onclick="openActionModal('<%= pb.getId_permohonan() %>', '<%= namaBantuanDisplay %>', 'lengkap')" 
                                            class="flex items-center gap-1 px-3 py-1.5 rounded-lg bg-green-500 hover:bg-green-600 text-white text-xs font-bold shadow-sm transition">
                                        <i class="fas fa-check"></i> Lengkap
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="7" class="p-12 text-center">
                                <div class="flex flex-col items-center justify-center text-gray-400">
                                    <i class="fas fa-clipboard-check text-4xl mb-4 text-gray-300"></i>
                                    <p class="text-lg font-bold text-gray-500">Tiada Permohonan Baharu</p>
                                    <p class="text-sm">Semua permohonan telah disemak.</p>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-gray-400 rounded-full"></div>
            Sejarah Tindakan <span class="bg-gray-100 text-gray-500 text-xs px-2 py-1 rounded-lg ml-2"><%= listSejarah.size() %></span>
        </h3>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Dokumen</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Ulasan Anda</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-32">Status Terkini</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) { 
                            for (PermohonanBantuan pb : listSejarah) {
                                String dateDisplay = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                        %>
                         <tr class="hover:bg-gray-50 transition">
                            <td class="p-4 text-sm text-gray-500"><%= (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-" %></td>
                            <td class="p-4 text-sm font-bold text-gray-700"><%= (pb.getNama_penuh() != null) ? pb.getNama_penuh() : "-" %></td>
                            <td class="p-4 text-sm text-gray-600"><%= (pb.getNama_bantuan() != null) ? pb.getNama_bantuan() : "Lain-lain" %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="text-blue-500 hover:text-blue-700 text-xs font-bold underline">Lihat PDF</a>
                                <% } else { %> - <% } %>
                            </td>
                            <td class="p-4 text-sm text-gray-500 max-w-xs truncate" title="<%= pb.getCatatan_pemohon() %>">
                                <%= (pb.getCatatan_pemohon() != null) ? pb.getCatatan_pemohon() : "-" %>
                            </td>
                            <td class="p-4">
                                <%-- LOGIK STATUS BADGE --%>
                                 <% if ("LULUS".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold bg-green-100 text-green-700">
                                        <i class="fas fa-check-circle"></i> Lulus (Ketua)
                                    </span>
                                <% } else if ("DIKEMBALIKAN".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold bg-orange-100 text-orange-700">
                                        <i class="fas fa-undo"></i> Dikembalikan
                                    </span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold bg-purple-100 text-purple-700">
                                        <i class="fas fa-arrow-right"></i> Dimajukan
                                    </span>
                                <% } else if ("DITOLAK".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold bg-red-100 text-red-700">
                                        <i class="fas fa-times-circle"></i> Ditolak (Ketua)
                                    </span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="p-8 text-center text-gray-400 text-sm italic">Tiada sejarah rekod.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div> 

    <aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
        
        <div class="flex justify-between items-start mb-8">
            <h3 class="font-bold text-lg text-gray-800">Statistik Semasa</h3>
            <span class="text-[10px] bg-purple-50 text-[#6C5DD3] px-2 py-1 rounded-lg font-bold">AJK MODE</span>
        </div>

        <div class="space-y-4 mb-10">
            <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
                <div>
                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Menunggu Semakan</p>
                    <h4 class="font-bold text-xl text-gray-800"><%= listBaru.size() %></h4>
                </div>
                <div class="w-10 h-10 rounded-xl bg-orange-100 text-orange-500 flex items-center justify-center shadow-sm">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
            
            <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
                <div>
                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Telah Disemak</p>
                    <h4 class="font-bold text-xl text-gray-800"><%= listSejarah.size() %></h4>
                </div>
                <div class="w-10 h-10 rounded-xl bg-green-100 text-green-500 flex items-center justify-center shadow-sm">
                    <i class="fas fa-check-double"></i>
                </div>
            </div>
        </div>

        <div class="mb-10">
            <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Langkah Pengesahan</h3>
            <div class="space-y-6 relative">
                <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
                
                <div class="relative pl-10">
                    <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-xs border-2 border-[#6C5DD3] z-10">1</div>
                    <h4 class="font-bold text-xs text-gray-800 uppercase">Semak Dokumen</h4>
                    <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Klik butang PDF untuk memastikan semua dokumen yang dimuat naik adalah sah dan jelas.</p>
                </div>

                <div class="relative pl-10">
                    <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                    <h4 class="font-bold text-xs text-gray-800 uppercase">Beri Keputusan</h4>
                    <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Pilih 'Lengkap' untuk hantar ke Ketua Kampung atau 'Hantar Semula' jika ada pembetulan.</p>
                </div>

                <div class="relative pl-10">
                    <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">3</div>
                    <h4 class="font-bold text-xs text-gray-800 uppercase">Pantau Status</h4>
                    <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Lihat ruangan 'Sejarah Tindakan' untuk mengetahui keputusan akhir daripada Ketua Kampung.</p>
                </div>
            </div>
        </div>

        <div class="mt-auto">
            <div class="bg-gradient-to-br from-[#6C5DD3] to-[#8E82EF] rounded-3xl p-6 text-white relative overflow-hidden shadow-lg shadow-purple-100">
                <div class="relative z-10">
                    <h4 class="font-bold text-sm mb-2">Bantuan Tambahan?</h4>
                    <p class="text-[10px] text-purple-100 leading-relaxed mb-4">Hubungi Setiausaha jika terdapat ralat pada sistem atau data pemohon.</p>
                    <a href="tel:0123456789" class="inline-flex items-center gap-2 text-xs font-bold bg-white/20 hover:bg-white/30 px-3 py-2 rounded-xl transition backdrop-blur-md">
                        <i class="fas fa-phone-alt"></i> Hubungi Sekarang
                    </a>
                </div>
                <i class="fas fa-question-circle absolute -right-4 -bottom-4 text-6xl opacity-10 rotate-12"></i>
            </div>
        </div>

    </aside>

<div id="modalTindakan" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalTindakan')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md">
            <div class="bg-gray-50 px-4 py-4 sm:px-6 border-b border-gray-100 flex justify-between items-center">
                <h3 class="text-base font-bold leading-6 text-gray-900">Pengesahan AJK</h3>
                <button type="button" class="text-gray-400 hover:text-gray-500" onclick="closeModal('modalTindakan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/reviewJKKK" method="post">
                <input type="hidden" name="idPermohonan" id="modalId">
                <input type="radio" name="keputusan" value="lengkap" id="radioLengkap" class="hidden">
                <input type="radio" name="keputusan" value="tak_lengkap" id="radioTakLengkap" class="hidden">
                <div class="bg-white px-6 py-6">
                    <div class="bg-blue-50 text-blue-700 p-4 rounded-xl text-sm mb-6 flex items-start gap-3">
                        <i class="fas fa-info-circle mt-1 text-lg"></i>
                        <div><p class="text-xs font-bold uppercase text-blue-400 mb-1">Permohonan</p><p class="font-bold" id="modalBantuanName"></p></div>
                    </div>
                    <div id="viewLengkap" class="hidden text-center">
                        <div class="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl"><i class="fas fa-check"></i></div>
                        <h4 class="text-lg font-bold text-gray-900 mb-2">Sahkan Dokumen Lengkap?</h4>
                        <p class="text-sm text-gray-500">Permohonan ini akan dimajukan kepada <strong>Ketua Kampung</strong>.</p>
                    </div>
                    <div id="viewTakLengkap" class="hidden text-center">
                        <div class="w-16 h-16 bg-red-100 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl"><i class="fas fa-undo-alt"></i></div>
                        <h4 class="text-lg font-bold text-gray-900 mb-2">Hantar Balik Permohonan</h4>
                        <p class="text-sm text-gray-500 mb-4">Sila nyatakan sebab untuk pembetulan.</p>
                        <textarea name="ulasan" id="ulasanBox" rows="3" placeholder="Contoh: Salinan Kad Pengenalan kabur..." class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:ring-2 focus:ring-red-500 focus:border-transparent text-sm transition"></textarea>
                    </div>
                </div>
                <div class="bg-gray-50 px-6 py-4 sm:flex sm:flex-row-reverse gap-2">
                    <button type="submit" id="btnSubmit" class="w-full inline-flex justify-center rounded-xl border border-transparent px-4 py-2.5 text-sm font-bold text-white shadow-sm focus:outline-none sm:w-auto transition">Sahkan</button>
                    <button type="button" class="mt-3 w-full inline-flex justify-center rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-sm font-bold text-gray-700 shadow-sm hover:bg-gray-50 sm:mt-0 sm:w-auto transition" onclick="closeModal('modalTindakan')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="modalTambahBantuan" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalTambahBantuan')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-[#6C5DD3] px-4 py-4 sm:px-6 flex justify-between items-center">
                <h3 class="text-base font-bold leading-6 text-white flex items-center gap-2"><i class="fas fa-folder-plus"></i> Tambah Jenis Bantuan</h3>
                <button class="text-white hover:text-gray-200" onclick="closeModal('modalTambahBantuan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/tambahJenisBantuan" method="post">
                <div class="bg-white px-6 py-6">
                    <div class="bg-purple-50 text-[#6C5DD3] p-4 rounded-xl text-xs flex gap-3 items-start mb-6 border border-purple-100">
                        <i class="fas fa-lightbulb text-lg mt-0.5"></i>
                        <p>Bantuan baharu ini akan disenaraikan secara automatik dalam menu "Bantuan Komuniti".</p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nama Bantuan</label>
                        <input type="text" name="namaBantuanBaru" placeholder="Contoh: SUMBANGAN RAMADHAN" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:ring-2 focus:ring-[#6C5DD3] focus:border-transparent font-bold text-gray-800 shadow-sm">
                    </div>
                </div>
                <div class="bg-gray-50 px-6 py-4 sm:flex sm:flex-row-reverse gap-2">
                    <button type="submit" class="w-full inline-flex justify-center rounded-xl bg-[#6C5DD3] px-4 py-2.5 text-sm font-bold text-white shadow-sm hover:bg-[#5b4eb8] sm:w-auto transition">Simpan</button>
                    <button type="button" class="mt-3 w-full inline-flex justify-center rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-sm font-bold text-gray-700 shadow-sm hover:bg-gray-50 sm:mt-0 sm:w-auto transition" onclick="closeModal('modalTambahBantuan')">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openModal(modalId) { document.getElementById(modalId).classList.remove('hidden'); }
    function closeModal(modalId) { document.getElementById(modalId).classList.add('hidden'); }
    
    function openActionModal(id, namaBantuan, actionType) {
        document.getElementById('modalId').value = id;
        document.getElementById('modalBantuanName').innerText = namaBantuan;
        const viewLengkap = document.getElementById('viewLengkap');
        const viewTakLengkap = document.getElementById('viewTakLengkap');
        const btnSubmit = document.getElementById('btnSubmit');
        const ulasanBox = document.getElementById('ulasanBox');

        viewLengkap.classList.add('hidden');
        viewTakLengkap.classList.add('hidden');
        btnSubmit.classList.remove('bg-green-600', 'bg-red-600', 'hover:bg-green-700', 'hover:bg-red-700');

        if(actionType === 'lengkap') {
            document.getElementById('radioLengkap').checked = true;
            viewLengkap.classList.remove('hidden');
            btnSubmit.classList.add('bg-green-600', 'hover:bg-green-700');
            btnSubmit.innerText = "Hantar ke Ketua";
            ulasanBox.required = false;
        } else {
            document.getElementById('radioTakLengkap').checked = true;
            viewTakLengkap.classList.remove('hidden');
            btnSubmit.classList.add('bg-red-600', 'hover:bg-red-700');
            btnSubmit.innerText = "Hantar Balik";
            ulasanBox.required = true; 
        }
        openModal('modalTindakan');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>