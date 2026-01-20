<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.net.URLEncoder" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Semakan Permohonan JKKK</h2>
            <p class="text-gray-500 text-sm">Senarai permohonan baharu dari penduduk untuk disemak.</p>
        </div>
        <div>
            <button onclick="openModal('modalTambahBantuan')" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-plus-circle"></i> Jenis Bantuan Baru
            </button>
        </div>
    </div>

    <%
        List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    %>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-purple-50 border-b border-purple-100">
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Rujukan</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh Mohon</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Info Pemohon</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Jenis Bantuan</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider w-1/5">Keterangan</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Dokumen</th>
                        <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center w-48">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% 
                    boolean adaData = false;
                    if (list != null && !list.isEmpty()) { 
                        for (PermohonanBantuan pb : list) {
                            
                            // FILTER: Hanya status 0 (Baharu)
                            if(pb.getStatus() != 0) { continue; }
                            adaData = true;

                            String namaBantuanDisplay = (pb.getNamaBantuan() != null) ? pb.getNamaBantuan() : "Lain-lain (" + pb.getIdBantuan() + ")";
                            String dateDisplay = (pb.getTarikhMohon() != null) ? sdf.format(pb.getTarikhMohon()) : "-";
                    %>
                    <tr class="hover:bg-purple-50/30 transition">
                        <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= pb.getIdPermohonan() %></td>
                        <td class="p-4 text-sm text-gray-600 font-medium"><%= dateDisplay %></td>
                        <td class="p-4">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-full bg-purple-100 text-[#6C5DD3] flex items-center justify-center text-xs font-bold">
                                    <%= (pb.getNamaPemohon() != null) ? pb.getNamaPemohon().substring(0,1) : "U" %>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-sm font-bold text-gray-800"><%= (pb.getNamaPemohon() != null) ? pb.getNamaPemohon() : "TIADA NAMA" %></span>
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
                            <% String infoCatatan = pb.getCatatan();
                               if (infoCatatan != null && !infoCatatan.trim().isEmpty()) { %>
                                <%= infoCatatan %>
                            <% } else { %>
                                <span class="italic text-gray-400">- Tiada keterangan -</span>
                            <% } %>
                        </td>
                        <td class="p-4">
                            <% if (pb.getDokumen() != null) { String enc = URLEncoder.encode(pb.getDokumen(), "UTF-8").replace("+", "%20"); %>
                                <a href="<%= request.getContextPath() %>/file/<%= enc %>" target="_blank" class="inline-flex items-center gap-2 px-3 py-1.5 bg-gray-50 hover:bg-gray-100 border border-gray-200 rounded-lg text-xs font-bold text-gray-600 transition">
                                    <i class="fas fa-file-pdf text-red-500"></i> PDF
                                </a>
                            <% } else { %> <span class="text-gray-400">-</span> <% } %>
                        </td>
                        <td class="p-4 text-center">
                            <div class="flex justify-center gap-2">
                                <button onclick="openActionModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuanDisplay %>', 'tak_lengkap')" 
                                        class="flex items-center gap-1 px-3 py-1.5 rounded-lg border border-red-200 text-red-500 hover:bg-red-50 text-xs font-bold transition">
                                    <i class="fas fa-reply"></i> Balik
                                </button>
                                <button onclick="openActionModal('<%= pb.getIdPermohonan() %>', '<%= namaBantuanDisplay %>', 'lengkap')" 
                                        class="flex items-center gap-1 px-3 py-1.5 rounded-lg bg-green-500 hover:bg-green-600 text-white text-xs font-bold shadow-sm transition">
                                    <i class="fas fa-check"></i> Lengkap
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } } 
                    if (!adaData) { %>
                    <tr>
                        <td colspan="7" class="p-12 text-center">
                            <div class="flex flex-col items-center justify-center text-gray-400">
                                <i class="fas fa-clipboard-check text-4xl mb-4 text-gray-300"></i>
                                <p class="text-lg font-bold text-gray-500">Semua Beres!</p>
                                <p class="text-sm">Tiada permohonan baharu untuk disemak buat masa ini.</p>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div> 
<div id="modalTindakan" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalTindakan')"></div>

    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-md">
            
            <div class="bg-gray-50 px-4 py-4 sm:px-6 border-b border-gray-100 flex justify-between items-center">
                <h3 class="text-base font-bold leading-6 text-gray-900">Pengesahan JKKK</h3>
                <button type="button" class="text-gray-400 hover:text-gray-500" onclick="closeModal('modalTindakan')">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <form action="<%= request.getContextPath() %>/bantuan/reviewJKKK" method="post">
                <input type="hidden" name="idPermohonan" id="modalId">
                <input type="radio" name="keputusan" value="lengkap" id="radioLengkap" class="hidden">
                <input type="radio" name="keputusan" value="tak_lengkap" id="radioTakLengkap" class="hidden">

                <div class="bg-white px-6 py-6">
                    
                    <div class="bg-blue-50 text-blue-700 p-4 rounded-xl text-sm mb-6 flex items-start gap-3">
                        <i class="fas fa-info-circle mt-1 text-lg"></i>
                        <div>
                            <p class="text-xs font-bold uppercase text-blue-400 mb-1">Permohonan</p>
                            <p class="font-bold" id="modalBantuanName"></p>
                        </div>
                    </div>

                    <div id="viewLengkap" class="hidden text-center">
                        <div class="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                            <i class="fas fa-check"></i>
                        </div>
                        <h4 class="text-lg font-bold text-gray-900 mb-2">Sahkan Dokumen Lengkap?</h4>
                        <p class="text-sm text-gray-500">Permohonan ini akan dimajukan kepada <strong>Ketua Kampung</strong> untuk kelulusan muktamad.</p>
                    </div>

                    <div id="viewTakLengkap" class="hidden text-center">
                        <div class="w-16 h-16 bg-red-100 text-red-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">
                            <i class="fas fa-undo-alt"></i>
                        </div>
                        <h4 class="text-lg font-bold text-gray-900 mb-2">Hantar Balik Permohonan</h4>
                        <p class="text-sm text-gray-500 mb-4">Sila nyatakan sebab/dokumen yang perlu diperbetulkan oleh pemohon.</p>
                        
                        <textarea name="ulasan" id="ulasanBox" rows="3" placeholder="Contoh: Salinan Kad Pengenalan kabur..."
                                  class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:ring-2 focus:ring-red-500 focus:border-transparent text-sm transition"></textarea>
                    </div>

                </div>

                <div class="bg-gray-50 px-6 py-4 sm:flex sm:flex-row-reverse gap-2">
                    <button type="submit" id="btnSubmit" class="w-full inline-flex justify-center rounded-xl border border-transparent px-4 py-2.5 text-sm font-bold text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 sm:w-auto transition">Sahkan</button>
                    <button type="button" class="mt-3 w-full inline-flex justify-center rounded-xl border border-gray-300 bg-white px-4 py-2.5 text-sm font-bold text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none sm:mt-0 sm:w-auto transition" onclick="closeModal('modalTindakan')">Batal</button>
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
                <h3 class="text-base font-bold leading-6 text-white flex items-center gap-2">
                    <i class="fas fa-folder-plus"></i> Tambah Jenis Bantuan
                </h3>
                <button class="text-white hover:text-gray-200" onclick="closeModal('modalTambahBantuan')"><i class="fas fa-times"></i></button>
            </div>

            <form action="<%= request.getContextPath() %>/bantuan/tambahJenisBantuan" method="post">
                <div class="bg-white px-6 py-6">
                    <div class="bg-purple-50 text-[#6C5DD3] p-4 rounded-xl text-xs flex gap-3 items-start mb-6 border border-purple-100">
                        <i class="fas fa-lightbulb text-lg mt-0.5"></i>
                        <p>Bantuan baharu ini akan disenaraikan secara automatik dalam menu "Bantuan Komuniti" untuk dipilih oleh penduduk.</p>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Nama Bantuan</label>
                        <input type="text" name="namaBantuanBaru" placeholder="Contoh: SUMBANGAN RAMADHAN" required
                               class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:ring-2 focus:ring-[#6C5DD3] focus:border-transparent font-bold text-gray-800 shadow-sm">
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
    // Modal Open/Close Logic
    function openModal(modalId) {
        document.getElementById(modalId).classList.remove('hidden');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.add('hidden');
    }

    // Logic Modal Tindakan
    function openActionModal(id, namaBantuan, actionType) {
        document.getElementById('modalId').value = id;
        document.getElementById('modalBantuanName').innerText = namaBantuan;
        
        const viewLengkap = document.getElementById('viewLengkap');
        const viewTakLengkap = document.getElementById('viewTakLengkap');
        const btnSubmit = document.getElementById('btnSubmit');
        const ulasanBox = document.getElementById('ulasanBox');

        // Reset
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