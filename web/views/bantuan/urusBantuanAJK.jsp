<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %>
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
    List<Bantuan> senaraiBantuan = (List<Bantuan>) request.getAttribute("senaraiBantuan");
    List<PermohonanBantuan> listBaru = new ArrayList<>();
    List<PermohonanBantuan> listSejarah = new ArrayList<>();
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");

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

    <div class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Semakan Permohonan AJK</h2>
        <p class="text-gray-500 text-sm">Uruskan permohonan baharu, semak sejarah, dan urus jenis bantuan.</p>
    </div>

    <% if (request.getParameter("msg") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Rekod telah dikemaskini.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8" aria-label="Tabs">
            <button onclick="switchTab('baru')" id="tab-baru" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-clipboard-list"></i> Permohonan Baharu
                <% if (!listBaru.isEmpty()) { %>
                    <span class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= listBaru.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-history"></i> Sejarah Tindakan
            </button>
            <button onclick="switchTab('jenis')" id="tab-jenis" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-cog"></i> Pengurusan Jenis Bantuan
            </button>
        </nav>
    </div>

    <!-- TAB 1: PERMOHONAN BARU -->
    <div id="content-baru" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableBaru">
                    <thead>
                        <tr class="bg-purple-50 border-b border-purple-100">
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">No. Rujukan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Butiran</th>
                            <th class="p-4 text-xs font-bold text-[#6C5DD3] uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listBaru.isEmpty()) { 
                            for (PermohonanBantuan pb : listBaru) {
                                String namaBantuanDisplay = (pb.getNama_bantuan() != null) ? pb.getNama_bantuan() : "Lain-lain";
                                String dateDisplay = (pb.getDibuat_pada() != null) ? sdf.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="hover:bg-purple-50/30 transition data-row-baru">
                            <td class="p-4 text-sm font-bold text-[#6C5DD3]">#<%= pb.getId_permohonan() %></td>
                            <td class="p-4 text-sm text-gray-600"><%= dateDisplay %></td>
                            <td class="p-4 text-sm font-bold text-gray-800"><%= (pb.getNama_penuh() != null) ? pb.getNama_penuh() : "TIADA NAMA" %></td>
                            <td class="p-4 text-sm font-medium text-gray-600"><%= namaBantuanDisplay %></td>
                            <td class="p-4 text-center">
                                <button onclick="viewDetail('<%= pb.getId_permohonan() %>', '<%= namaBantuanDisplay %>', '<%= pb.getNama_penuh() %>', '<%= pb.getCatatan_pemohon() %>', '<%= pb.getDokumen_pemohon() %>', '<%= pb.getNama_bank() %>', '<%= pb.getNombor_akaun() %>', '<%= pb.getPenyata_bank() %>')" 
                                        class="text-[#6C5DD3] hover:underline text-xs font-bold">Lihat Detail</button>
                            </td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2">
                                    <button onclick="openActionModal('<%= pb.getId_permohonan() %>', '<%= namaBantuanDisplay %>', 'tak_lengkap')" 
                                            class="px-3 py-1.5 rounded-lg border border-red-200 text-red-500 hover:bg-red-50 text-xs font-bold transition">
                                        <i class="fas fa-undo"></i>
                                    </button>
                                    <button onclick="openActionModal('<%= pb.getId_permohonan() %>', '<%= namaBantuanDisplay %>', 'lengkap')" 
                                            class="px-3 py-1.5 rounded-lg bg-green-500 hover:bg-green-600 text-white text-xs font-bold transition shadow-sm">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="p-12 text-center text-gray-400">Tiada permohonan baharu.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 2: SEJARAH -->
    <div id="content-sejarah" class="hidden">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Tarikh</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Pemohon</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">Butiran</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) { 
                            for (PermohonanBantuan pb : listSejarah) { %>
                        <tr class="hover:bg-gray-50 transition">
                            <td class="p-4 text-sm text-gray-500"><%= sdf.format(pb.getDibuat_pada()) %></td>
                            <td class="p-4 text-sm font-bold text-gray-700"><%= pb.getNama_penuh() %></td>
                            <td class="p-4 text-sm text-gray-600"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4">
                                <% if ("LULUS".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-2 py-1 rounded-full text-[10px] font-bold bg-green-100 text-green-700">LULUS</span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-2 py-1 rounded-full text-[10px] font-bold bg-purple-100 text-purple-700">DIMAJUKAN</span>
                                <% } else if ("DIKEMBALIKAN".equalsIgnoreCase(pb.getStatus())) { %>
                                    <span class="px-2 py-1 rounded-full text-[10px] font-bold bg-orange-100 text-orange-700">KEMBALI</span>
                                <% } else { %>
                                    <span class="px-2 py-1 rounded-full text-[10px] font-bold bg-red-100 text-red-700">DITOLAK</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <button onclick="viewDetail('<%= pb.getId_permohonan() %>', '<%= pb.getNama_bantuan() %>', '<%= pb.getNama_penuh() %>', '<%= pb.getCatatan_pemohon() %>', '<%= pb.getDokumen_pemohon() %>', '<%= pb.getNama_bank() %>', '<%= pb.getNombor_akaun() %>', '<%= pb.getPenyata_bank() %>')" 
                                        class="text-gray-500 hover:text-[#6C5DD3] transition"><i class="fas fa-eye"></i></button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="5" class="p-8 text-center text-gray-400">Tiada sejarah rekod.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB 3: JENIS BANTUAN -->
    <div id="content-jenis" class="hidden">
        <div class="flex justify-between items-center mb-4">
            <h3 class="font-bold text-lg text-gray-800">Senarai Konfigurasi Bantuan</h3>
            <button onclick="openModal('modalTambahBantuan')" class="bg-[#6C5DD3] text-white px-4 py-2 rounded-xl font-bold text-xs shadow-md">
                <i class="fas fa-plus"></i> Tambah Bantuan
            </button>
        </div>
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-blue-50 border-b border-blue-100">
                        <th class="p-4 text-xs font-bold text-blue-600 uppercase">Nama Bantuan</th>
                        <th class="p-4 text-xs font-bold text-blue-600 uppercase">Kategori</th>
                        <th class="p-4 text-xs font-bold text-blue-600 uppercase">Peruntukan</th>
                        <th class="p-4 text-xs font-bold text-blue-600 uppercase">Syarat Dokumen</th>
                        <th class="p-4 text-xs font-bold text-blue-600 uppercase text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (senaraiBantuan != null) { 
                        for (Bantuan b : senaraiBantuan) { %>
                    <tr class="hover:bg-blue-50/30 transition">
                        <td class="p-4 text-sm font-bold text-gray-800"><%= b.getNama_bantuan() %></td>
                        <td class="p-4 text-xs uppercase font-bold"><%= b.getJenis_bantuan() %></td>
                        <td class="p-4 text-sm text-gray-600 font-medium"><%= b.getJumlahBantuanFormatted() %></td>
                        <td class="p-4 text-xs text-gray-500 max-w-xs truncate"><%= (b.getSyarat_dokumen() != null) ? b.getSyarat_dokumen() : "Tiada syarat khusus" %></td>
                        <td class="p-4 text-center">
                            <div class="flex justify-center gap-2">
                                <button onclick="openEditBantuanModal('<%= b.getId_bantuan() %>', '<%= b.getNama_bantuan() %>', '<%= b.getJenis_bantuan() %>', '<%= b.getJumlah_bantuan() %>', '<%= (b.getSyarat_dokumen() != null ? b.getSyarat_dokumen().replace("'", "\\'") : "") %>')" 
                                        class="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition"><i class="fas fa-edit"></i></button>
                                <form action="<%= request.getContextPath() %>/bantuan/padamJenisBantuan" method="post" class="inline">
                                    <input type="hidden" name="id" value="<%= b.getId_bantuan() %>">
                                    <button type="submit" class="p-2 text-red-600 hover:bg-red-100 rounded-lg transition"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- MODAL: DETAIL PERMOHONAN (INCLUDING BANK) -->
<div id="modalDetail" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeModal('modalDetail')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl overflow-hidden">
            <div class="bg-gray-50 px-6 py-4 border-b flex justify-between items-center">
                <h3 class="font-bold text-gray-800">Detail Permohonan</h3>
                <button onclick="closeModal('modalDetail')" class="text-gray-400 hover:text-gray-600"><i class="fas fa-times"></i></button>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <!-- Section 1: Info Permohonan -->
                    <div class="space-y-4">
                        <h4 class="text-xs font-bold text-[#6C5DD3] uppercase tracking-wider border-b pb-1">Maklumat Bantuan</h4>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Jenis Bantuan</p>
                            <p id="detBantuan" class="font-bold text-gray-800">-</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Nama Pemohon</p>
                            <p id="detPemohon" class="font-bold text-gray-800">-</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Keterangan / Sebab</p>
                            <p id="detKeterangan" class="text-sm text-gray-600 leading-relaxed">-</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Lampiran Utama</p>
                            <a id="detDokMain" href="#" target="_blank" class="text-blue-600 font-bold text-sm flex items-center gap-2 mt-1">
                                <i class="fas fa-file-pdf"></i> Lihat Dokumen Sokongan
                            </a>
                        </div>
                    </div>
                    <!-- Section 2: Info Bank -->
                    <div class="space-y-4 bg-blue-50/50 p-4 rounded-2xl border border-blue-100">
                        <h4 class="text-xs font-bold text-blue-600 uppercase tracking-wider border-b border-blue-200 pb-1 flex items-center gap-2">
                            <i class="fas fa-university"></i> Maklumat Bank (Penyaluran)
                        </h4>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Nama Bank</p>
                            <p id="detBank" class="font-bold text-gray-800 uppercase">-</p>
                        </div>
                        <div>
                            <p class="text-[10px] text-gray-400 uppercase">Nombor Akaun</p>
                            <p id="detAkaun" class="font-bold text-gray-800 tracking-wider">-</p>
                        </div>
                        <div class="mt-4">
                            <p class="text-[10px] text-gray-400 uppercase mb-1">Bukti Penyata Bank</p>
                            <a id="detDokBank" href="#" target="_blank" class="inline-flex items-center gap-2 px-3 py-2 bg-white border border-blue-200 rounded-xl text-blue-600 text-xs font-bold shadow-sm hover:bg-blue-50 transition">
                                <i class="fas fa-file-invoice-dollar"></i> Lihat Penyata Bank
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 p-4 text-center">
                <button onclick="closeModal('modalDetail')" class="px-6 py-2 bg-white border rounded-xl text-sm font-bold text-gray-600 hover:bg-gray-100 transition">Tutup</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: TAMBAH JENIS BANTUAN -->
<div id="modalTambahBantuan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalTambahBantuan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-lg overflow-hidden">
            <div class="bg-[#6C5DD3] p-4 text-white font-bold flex justify-between items-center">
                <span>Tambah Jenis Bantuan</span>
                <button onclick="closeModal('modalTambahBantuan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/tambahJenisBantuan" method="post" class="p-6 space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Nama Bantuan</label>
                    <input type="text" name="namaBantuan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-[#6C5DD3] outline-none transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Kategori</label>
                    <select name="jenisBantuan" class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-[#6C5DD3] outline-none transition">
                        <option value="KOMUNITI">KOMUNITI</option>
                        <option value="RASMI">RASMI</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Peruntukan (RM)</label>
                    <input type="number" step="0.01" name="peruntukan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-[#6C5DD3] outline-none transition">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Syarat Dokumen Wajib</label>
                    <textarea name="syaratDokumen" rows="3" placeholder="Contoh: Salinan IC, Penyata Gaji, Sijil Kematian..." class="w-full px-4 py-2 bg-gray-50 border rounded-xl focus:ring-2 focus:ring-[#6C5DD3] outline-none transition text-sm"></textarea>
                    <p class="text-[10px] text-gray-400 mt-1 italic">Pisahkan setiap syarat dengan koma (,).</p>
                </div>
                <div class="flex justify-end gap-2 pt-4">
                    <button type="button" onclick="closeModal('modalTambahBantuan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" class="px-6 py-2 bg-[#6C5DD3] text-white rounded-xl font-bold shadow-md hover:bg-[#5b4eb8] transition">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: EDIT JENIS BANTUAN -->
<div id="modalEditBantuan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalEditBantuan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-lg overflow-hidden">
            <div class="bg-[#6C5DD3] p-4 text-white font-bold flex justify-between items-center">
                <span>Kemaskini Jenis Bantuan</span>
                <button onclick="closeModal('modalEditBantuan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/kemaskiniJenisBantuan" method="post" class="p-6 space-y-4">
                <input type="hidden" name="idBantuan" id="editId">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Nama Bantuan</label>
                    <input type="text" name="namaBantuan" id="editNama" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Kategori</label>
                    <select name="jenisBantuan" id="editJenis" class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                        <option value="KOMUNITI">KOMUNITI</option>
                        <option value="RASMI">RASMI</option>
                    </select>
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Peruntukan (RM)</label>
                    <input type="number" step="0.01" name="peruntukan" id="editPeruntukan" required class="w-full px-4 py-2 bg-gray-50 border rounded-xl">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Syarat Dokumen Wajib</label>
                    <textarea name="syaratDokumen" id="editSyarat" rows="3" class="w-full px-4 py-2 bg-gray-50 border rounded-xl text-sm"></textarea>
                </div>
                <div class="flex justify-end gap-2 pt-4">
                    <button type="button" onclick="closeModal('modalEditBantuan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" class="px-6 py-2 bg-[#6C5DD3] text-white rounded-xl font-bold shadow-md transition">Kemaskini</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL: TINDAKAN (LENGKAP/TAK LENGKAP) -->
<div id="modalTindakan" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal('modalTindakan')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative bg-white rounded-3xl shadow-xl w-full max-w-md overflow-hidden">
            <div class="bg-gray-50 p-4 font-bold border-b flex justify-between items-center">
                <span id="actTitle">Tindakan AJK</span>
                <button onclick="closeModal('modalTindakan')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/bantuan/reviewJKKK" method="post" class="p-6">
                <input type="hidden" name="idPermohonan" id="actId">
                <input type="hidden" name="keputusan" id="actDecision">
                <div id="boxLengkap" class="hidden text-center py-4">
                    <div class="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl"><i class="fas fa-check"></i></div>
                    <p class="font-bold text-gray-800">Sahkan Dokumen Lengkap?</p>
                    <p class="text-xs text-gray-500 mt-2">Permohonan ini akan dihantar ke Ketua Kampung.</p>
                </div>
                <div id="boxTakLengkap" class="hidden py-2">
                    <div class="w-12 h-12 bg-red-100 text-red-600 rounded-full flex items-center justify-center mb-4 text-xl"><i class="fas fa-exclamation-triangle"></i></div>
                    <p class="font-bold text-gray-800 mb-2">Nyatakan Sebab (Tidak Lengkap)</p>
                    <textarea name="ulasan" id="actUlasan" rows="3" class="w-full px-4 py-2 bg-gray-50 border rounded-xl text-sm" placeholder="Contoh: Lampiran PDF tidak boleh dibuka..."></textarea>
                </div>
                <div class="flex justify-end gap-2 mt-6">
                    <button type="button" onclick="closeModal('modalTindakan')" class="px-4 py-2 text-sm font-bold text-gray-500">Batal</button>
                    <button type="submit" id="actSubmitBtn" class="px-6 py-2 rounded-xl font-bold text-white transition shadow-md"></button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(tabName) {
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });
        document.getElementById('tab-' + tabName).classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        document.getElementById('content-baru').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        document.getElementById('content-jenis').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    function openModal(id) { document.getElementById(id).classList.remove('hidden'); }
    function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

    function openActionModal(id, name, type) {
        document.getElementById('actId').value = id;
        document.getElementById('actDecision').value = type;
        const btn = document.getElementById('actSubmitBtn');
        const boxL = document.getElementById('boxLengkap');
        const boxTL = document.getElementById('boxTakLengkap');
        const ulasan = document.getElementById('actUlasan');

        boxL.classList.add('hidden');
        boxTL.classList.add('hidden');

        if(type === 'lengkap') {
            boxL.classList.remove('hidden');
            btn.innerText = "Sahkan & Hantar";
            btn.className = "px-6 py-2 bg-green-500 text-white rounded-xl font-bold shadow-md hover:bg-green-600";
            ulasan.required = false;
        } else {
            boxTL.classList.remove('hidden');
            btn.innerText = "Hantar Semula";
            btn.className = "px-6 py-2 bg-red-500 text-white rounded-xl font-bold shadow-md hover:bg-red-600";
            ulasan.required = true;
        }
        openModal('modalTindakan');
    }

    function openEditBantuanModal(id, name, type, amount, syarat) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = name;
        document.getElementById('editJenis').value = type;
        document.getElementById('editPeruntukan').value = amount;
        document.getElementById('editSyarat').value = syarat;
        openModal('modalEditBantuan');
    }

    function viewDetail(id, bantuan, pemohon, ket, dok, bank, akaun, penBank) {
        document.getElementById('detBantuan').innerText = bantuan;
        document.getElementById('detPemohon').innerText = pemohon;
        document.getElementById('detKeterangan').innerText = ket || "Tiada keterangan tambahan.";
        document.getElementById('detBank').innerText = bank || "TIDAK DINYATAKAN";
        document.getElementById('detAkaun').innerText = akaun || "TIDAK DINYATAKAN";

        const ctx = '<%= request.getContextPath() %>';
        const dokBtn = document.getElementById('detDokMain');
        if(dok) {
            dokBtn.href = ctx + "/file/bantuan/" + encodeURIComponent(dok);
            dokBtn.classList.remove('hidden');
        } else { dokBtn.classList.add('hidden'); }

        const bankBtn = document.getElementById('detDokBank');
        if(penBank) {
            bankBtn.href = ctx + "/file/bantuan/" + encodeURIComponent(penBank);
            bankBtn.classList.remove('hidden');
        } else { bankBtn.classList.add('hidden'); }

        openModal('modalDetail');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>