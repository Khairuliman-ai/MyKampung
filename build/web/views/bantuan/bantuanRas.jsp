<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
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
        Collections.sort(mainList, (o1, o2) -> Integer.compare(o2.getId_permohonan(), o1.getId_permohonan()));
        for (PermohonanBantuan pb : mainList) {
            String s = (pb.getStatus() != null) ? pb.getStatus().trim().toUpperCase() : "BARU";
            if (s.equals("BARU") || s.equals("DIKEMBALIKAN") || s.equals("MENUNGGU_KETUA")) {
                listProses.add(pb);
            } else {
                listSejarah.add(pb);
            }
        }
    }
%>

<%! 
    public String cleanForJS(String text) {
        if (text == null) return "";
        return text.replace("\r\n", " ").replace("\n", " ").replace("'", "\\'").replace("\"", "&quot;");
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

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

    <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
        <i class="fas fa-check-circle text-lg"></i>
        <div>
            <% String stat = request.getParameter("status"); 
               if(stat != null) stat = stat.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
            %>
            <span class="font-bold">Berjaya!</span> <%= (stat != null ? stat : "") %>
        </div>
        <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
    </div>
    <% } %>
    
    <% if (request.getParameter("error") != null) { %>
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
        <i class="fas fa-exclamation-circle text-lg"></i>
        <div>
            <% String err = request.getParameter("error"); 
               if(err != null) err = err.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
            %>
            <span class="font-bold">Ralat!</span> <%= (err != null ? err : "") %>
        </div>
        <button onclick="this.parentElement.remove()" class="ml-auto text-red-500 hover:text-red-700"><i class="fas fa-times"></i></button>
    </div>
    <% } %>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8" aria-label="Tabs">
            <button onclick="switchTab('proses')" id="tab-proses" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-[#6C5DD3] text-[#6C5DD3]">
                <i class="fas fa-sync-alt"></i> Sedang Diproses
                <% if (!listProses.isEmpty()) { %>
                    <span class="bg-[#6C5DD3] text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= listProses.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-history"></i> Sejarah Terdahulu
            </button>
        </nav>
    </div>

    <div id="content-proses" class="block">
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-blue-500 rounded-full"></div>
            Permohonan Sedang Diproses
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listProses.isEmpty()) { 
                            for (PermohonanBantuan pb : listProses) {
                                String filterDate = (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "";
                                String displayDate = (pb.getDibuat_pada() != null) ? sdfDisplay.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition-colors" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                            <td class="p-4 text-sm font-medium text-gray-600 whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-[#6C5DD3] search-col"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/bantuan/<%= enc %>" target="_blank" class="inline-flex items-center gap-2 px-3 py-1 bg-gray-100 text-gray-600 rounded-lg text-xs font-bold hover:bg-gray-200 transition">
                                        <i class="fas fa-file-pdf text-red-500"></i> PDF
                                    </a>
                                <% } else { %> <span class="text-gray-400">-</span> <% } %>
                            </td>
                            <td class="p-4 text-sm text-gray-500 search-col max-w-xs truncate"><%= (pb.getCatatan_pemohon() != null) ? pb.getCatatan_pemohon() : "-" %></td>
                            <td class="p-4">
                                <% if ("DIKEMBALIKAN".equalsIgnoreCase(pb.getStatus())) { %> 
                                    <span class="px-3 py-1 rounded-full bg-orange-50 text-orange-600 text-xs font-bold whitespace-nowrap">Perlu Pembetulan</span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus())) { %> 
                                    <span class="px-3 py-1 rounded-full bg-purple-50 text-purple-600 text-xs font-bold whitespace-nowrap">Semakan Ketua</span> 
                                <% } else { %>
                                    <span class="px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold whitespace-nowrap">Dihantar</span>
                                <% } %>
                            </td>

                            <td class="p-4 text-center">
                                <div class="flex flex-col gap-2 items-center">
                                    <% 
                                        String jsCatatan = cleanForJS(pb.getCatatan_pemohon());
                                        String jsUlasan = cleanForJS(pb.getCatatan_pentadbir());
                                    %>
                                    <button onclick="openDetailModal('<%= pb.getNama_bantuan() %>', '<%= displayDate %>', '<%= pb.getStatus() %>', '<%= jsCatatan %>', '<%= jsUlasan %>')" 
                                            class="flex items-center justify-center gap-1.5 px-3 py-1.5 rounded-lg bg-purple-50 text-[#6C5DD3] hover:bg-purple-100 transition w-full text-[10px] font-bold">
                                        <i class="fas fa-tasks"></i> Progres
                                    </button>

                                    <div class="flex gap-2 w-full justify-center">
                                        <% if ("DIKEMBALIKAN".equalsIgnoreCase(pb.getStatus()) || "BARU".equalsIgnoreCase(pb.getStatus())) { %>
                                            <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getId_permohonan() %>" class="flex-1 py-1.5 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 flex items-center justify-center transition" title="Kemaskini">
                                                <i class="fas fa-pen text-[10px]"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getId_permohonan() %>" 
                                               onclick="return confirm('Padam permohonan ini?');"
                                               class="flex-1 py-1.5 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 flex items-center justify-center transition" title="Padam">
                                                <i class="fas fa-trash-alt text-[10px]"></i>
                                            </a>
                                        <% } else { %>
                                            <span class="text-gray-300 text-[10px]"><i class="fas fa-lock mr-1"></i> Terkunci</span>
                                        <% } %>
                                    </div>
                                </div>
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

<div id="content-sejarah" class="hidden">
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
                            <option value="LULUS">Lulus (Disokong)</option>
                            <option value="DITOLAK">Ditolak</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
        <h3 class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
            <div class="w-2 h-6 bg-gray-400 rounded-full"></div>
            Rekod Sejarah Terdahulu
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-24">Info</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listSejarah.isEmpty()) {
                            for (PermohonanBantuan pb : listSejarah) {
                                String filterDate = (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "";
                                String displayDate = (pb.getDibuat_pada() != null) ? sdfDisplay.format(pb.getDibuat_pada()) : "-";
                        %>
                        <tr class="data-row text-gray-500" data-date="<%= filterDate %>" data-status="<%= pb.getStatus() %>">
                            <td class="p-4 text-sm whitespace-nowrap"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-700 search-col"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4">
                                <% if (pb.getDokumen_pemohon() != null) { String enc = URLEncoder.encode(pb.getDokumen_pemohon(), "UTF-8").replace("+", "%20"); %>
                                    <a href="<%= request.getContextPath() %>/file/bantuan/<%= enc %>" target="_blank" class="text-xs font-bold text-blue-500 hover:underline"><i class="fas fa-file-pdf"></i> PDF</a>
                                <% } else { %> - <% } %>
                            </td>
                            <td class="p-4 text-sm search-col max-w-xs truncate"><%= (pb.getCatatan_pemohon() != null) ? pb.getCatatan_pemohon() : "-" %></td>
                            <td class="p-4 text-sm max-w-xs truncate"><%= (pb.getCatatan_pentadbir() != null) ? pb.getCatatan_pentadbir() : "-" %></td>
                            <td class="p-4">
                                <% if ("LULUS".equalsIgnoreCase(pb.getStatus())) { %> 
                                    <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-check-circle"></i> Disokong</span>
                                <% } else { %> 
                                    <span class="px-3 py-1 rounded-full bg-red-50 text-red-600 text-xs font-bold flex items-center w-max gap-1"><i class="fas fa-times-circle"></i> Ditolak</span>
                                <% } %>
                            </td>
                            <td class="p-4">
                                <div class="flex items-center w-full max-w-[250px]">
                                    <div class="flex items-center justify-center w-4 h-4 rounded-full bg-[#6C5DD3] text-[8px] text-white">✓</div>
                                    <div class="flex-1 h-0.5 bg-[#6C5DD3] mx-1"></div>
                                    <div class="flex items-center justify-center w-4 h-4 rounded-full bg-[#6C5DD3] text-[8px] text-white">✓</div>
                                    <div class="flex-1 h-0.5 bg-[#6C5DD3] mx-1"></div>
                                    <div class="flex items-center justify-center w-4 h-4 rounded-full bg-[#6C5DD3] text-[8px] text-white">✓</div>
                                    <div class="flex-1 h-0.5 bg-[#6C5DD3] mx-1"></div>
                                    <div class="flex items-center justify-center w-4 h-4 rounded-full <%= "LULUS".equalsIgnoreCase(pb.getStatus()) ? "bg-green-500" : "bg-red-500" %> text-[8px] text-white">✓</div>
                                </div>
                            </td>
                            <td class="p-4 text-center">
                                <% 
                                    String jsCatatan = cleanForJS(pb.getCatatan_pemohon());
                                    String jsUlasan = cleanForJS(pb.getCatatan_pentadbir());
                                %>
                                <button onclick="openDetailModal('<%= pb.getNama_bantuan() %>', '<%= displayDate %>', '<%= pb.getStatus() %>', '<%= jsCatatan %>', '<%= jsUlasan %>')" 
                                        class="w-10 h-10 rounded-full bg-gray-50 text-gray-400 hover:bg-purple-50 hover:text-[#6C5DD3] transition flex items-center justify-center mx-auto">
                                    <i class="fas fa-info-circle text-lg"></i>
                                </button>
                            </td>
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
<div id="modalDetail" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalDetail')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all sm:w-full sm:max-w-lg">
            <div class="bg-[#6C5DD3] px-6 py-4 flex justify-between items-center">
                <h3 class="text-white font-bold flex items-center gap-2">
                    <i class="fas fa-tasks"></i> Progres Permohonan
                </h3>
                <button onclick="closeModal('modalDetail')" class="text-white/80 hover:text-white transition"><i class="fas fa-times"></i></button>
            </div>
            
            <div class="p-8">
                <!-- Info Summary -->
                <div class="flex justify-between items-start mb-8 bg-gray-50 p-4 rounded-2xl border border-gray-100">
                    <div>
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Jenis Bantuan</p>
                        <h4 id="detNama" class="text-lg font-bold text-gray-800">-</h4>
                    </div>
                    <div class="text-right">
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Tarikh Mohon</p>
                        <p id="detTarikh" class="text-sm font-bold text-gray-700">-</p>
                    </div>
                </div>

                <!-- Status Tracker (Large) -->
                <div class="mb-12 relative px-4">
                    <div class="flex justify-between items-center relative z-10">
                        <div class="flex flex-col items-center gap-2">
                            <div id="step1" class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200">1</div>
                            <span class="text-[10px] font-bold text-gray-500 uppercase">Mula</span>
                        </div>
                        <div class="flex-1 h-1 bg-gray-100 -mt-6 mx-1">
                            <div id="line1" class="h-full bg-[#6C5DD3] transition-all duration-700 w-0"></div>
                        </div>
                        <div class="flex flex-col items-center gap-2">
                            <div id="step2" class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200">2</div>
                            <span class="text-[10px] font-bold text-gray-500 uppercase">AJK</span>
                        </div>
                        <div class="flex-1 h-1 bg-gray-100 -mt-6 mx-1">
                            <div id="line2" class="h-full bg-[#6C5DD3] transition-all duration-700 w-0"></div>
                        </div>
                        <div class="flex flex-col items-center gap-2">
                            <div id="step3" class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200">3</div>
                            <span class="text-[10px] font-bold text-gray-500 uppercase">Ketua</span>
                        </div>
                        <div class="flex-1 h-1 bg-gray-100 -mt-6 mx-1">
                            <div id="line3" class="h-full bg-[#6C5DD3] transition-all duration-700 w-0"></div>
                        </div>
                        <div class="flex flex-col items-center gap-2">
                            <div id="step4" class="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200">4</div>
                            <span class="text-[10px] font-bold text-gray-500 uppercase">Hasil</span>
                        </div>
                    </div>
                </div>

                <div class="space-y-6">
                    <div>
                        <h5 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 flex items-center gap-2">
                            <i class="fas fa-comment-alt text-[#6C5DD3]"></i> Keterangan Anda
                        </h5>
                        <p id="detCatatan" class="text-sm text-gray-600 bg-gray-50 p-4 rounded-xl border border-gray-100 leading-relaxed">-</p>
                    </div>
                    <div id="ulasanDiv">
                        <h5 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 flex items-center gap-2">
                            <i class="fas fa-shield-alt text-orange-500"></i> Maklum Balas Pentadbir
                        </h5>
                        <p id="detUlasan" class="text-sm text-gray-600 bg-orange-50 p-4 rounded-xl border border-orange-100 leading-relaxed">-</p>
                    </div>
                </div>
            </div>

            <div class="bg-gray-50 px-8 py-6 sm:flex sm:flex-row-reverse rounded-b-3xl">
                <button type="button" class="w-full sm:w-auto px-8 py-3 bg-[#6C5DD3] text-white font-bold rounded-xl hover:bg-[#5b4eb8] transition shadow-lg shadow-purple-100" onclick="closeModal('modalDetail')">Tutup</button>
            </div>
        </div>
    </div>
</div>

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col flex-shrink-0 p-8 overflow-y-auto h-full">
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
                <p class="text-xs text-gray-500 mt-1 leading-relaxed">Permohonan akan disemak oleh AJK sebelum dimajukan ke peringkat atasan.</p>
            </div>
        </div>
    </div>

    <div class="mt-auto bg-gray-50 rounded-2xl p-6 border border-gray-100">
        <h4 class="font-bold text-gray-700 mb-2 text-sm">Masalah Permohonan?</h4>
        <p class="text-xs text-gray-500 mb-4">Hubungi Setiausaha AJK untuk pertanyaan lanjut mengenai status anda.</p>
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
                                                <% if (senaraiJenis != null) { for (Bantuan b : senaraiJenis) { %>
                                                    <option value="<%= b.getId_bantuan() %>"><%= b.getNama_bantuan() %></option>
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
    function switchTab(tabName) {
        // Reset Tabs Style
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });

        // Active Tab Style
        const activeTab = document.getElementById('tab-' + tabName);
        activeTab.classList.add('border-[#6C5DD3]', 'text-[#6C5DD3]', 'font-bold');
        activeTab.classList.remove('border-transparent', 'text-gray-500', 'font-medium');

        // Toggle Content
        document.getElementById('content-proses').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    // 1. OPEN DETAIL MODAL LOGIC
    function openDetailModal(nama, tarikh, status, catatan, ulasan) {
        document.getElementById('detNama').innerText = nama;
        document.getElementById('detTarikh').innerText = tarikh;
        document.getElementById('detCatatan').innerText = (catatan && catatan !== "null") ? catatan : "Tiada maklumat.";
        document.getElementById('detUlasan').innerText = (ulasan && ulasan !== "null") ? ulasan : "Belum ada ulasan.";
        
        // Reset Steps
        const steps = ['step1', 'step2', 'step3', 'step4'];
        const lines = ['line1', 'line2', 'line3'];
        
        steps.forEach(s => {
            const el = document.getElementById(s);
            el.className = "w-10 h-10 rounded-full flex items-center justify-center text-white font-bold shadow-lg transition-all duration-500 bg-gray-200";
            el.innerHTML = s.replace('step', '');
        });
        lines.forEach(l => {
            const el = document.getElementById(l);
            el.style.width = "0%";
            el.classList.remove('bg-orange-500');
            el.classList.add('bg-[#6C5DD3]');
        });

        let activeStep = 1;
        let mainColor = "bg-[#6C5DD3]";
        
        if (status === "MENUNGGU_KETUA") activeStep = 3;
        else if (status === "LULUS" || status === "DITOLAK") activeStep = 4;
        else if (status === "DIKEMBALIKAN") mainColor = "bg-orange-500";

        // Animate Steps
        setTimeout(() => {
            for(let i=1; i<=activeStep; i++) {
                const el = document.getElementById('step'+i);
                el.classList.remove('bg-gray-200');
                el.classList.add(mainColor);
                if(i < activeStep) el.innerHTML = "✓";
                
                if(i < activeStep && i <= 3) {
                    const line = document.getElementById('line'+i);
                    line.style.width = "100%";
                    if(mainColor === "bg-orange-500") {
                        line.classList.remove('bg-[#6C5DD3]');
                        line.classList.add('bg-orange-500');
                    }
                }
            }
            
            if(activeStep === 4) {
                const lastStep = document.getElementById('step4');
                lastStep.classList.remove('bg-[#6C5DD3]');
                lastStep.classList.add(status === "LULUS" ? "bg-green-500" : "bg-red-500");
                lastStep.innerHTML = "✓";
            }
        }, 100);

        openModal('modalDetail');
    }

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