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

    // User info for auto-populate
    String uNama = (currentUser != null) ? currentUser.getNama_penuh() : "";
    String uIC = (currentUser != null) ? currentUser.getNombor_kp() : "";
    String uTel = (currentUser != null) ? currentUser.getNombor_telefon() : "";
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
            <button onclick="openWizard()" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-5 py-2.5 rounded-xl font-bold text-sm transition shadow-md shadow-purple-200 flex items-center gap-2">
                <i class="fas fa-plus"></i> Mohon Baru
            </button>
        </div>
    </div>

    <% if (request.getParameter("status") != null) { %>
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
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh Mohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center w-32">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listProses.isEmpty()) { 
                            int noP = 1;
                            for (PermohonanBantuan pb : listProses) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdfDisplay.format(pb.getDibuat_pada()) : "-";
                                String status = (pb.getStatus() != null) ? pb.getStatus().trim().toUpperCase() : "BARU";
                                
                                // JS Data
                                String jsNama = cleanForJS(pb.getNama_bantuan());
                                String jsCatatan = cleanForJS(pb.getCatatan_pemohon());
                                String jsUlasan = cleanForJS(pb.getCatatan_pentadbir());
                                String jsBank = cleanForJS(pb.getNama_bank());
                                String jsAkaun = cleanForJS(pb.getNombor_akaun());
                                String jsPenyata = (pb.getPenyata_bank() != null) ? URLEncoder.encode(pb.getPenyata_bank(), "UTF-8") : "";
                                
                                // Ambil senarai lampiran
                                StringBuilder sbDocs = new StringBuilder();
                                if(pb.getSenaraiLampiran() != null) {
                                    for(model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                                        if(sbDocs.length() > 0) sbDocs.append(",");
                                        sbDocs.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                    }
                                }
                                String jsDokumen = sbDocs.toString();
                        %>
                        <tr class="data-row hover:bg-purple-50/50 transition cursor-pointer group" 
                            onclick="openDetailModal('<%= jsNama %>', '<%= displayDate %>', '<%= status %>', '<%= jsCatatan %>', '<%= jsUlasan %>', '<%= jsBank %>', '<%= jsAkaun %>', '<%= jsPenyata %>', '<%= jsDokumen %>')">
                            <td class="p-4 text-sm text-gray-400 font-medium"><%= noP++ %></td>
                            <td class="p-4 text-sm text-gray-600"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-800 group-hover:text-[#6C5DD3]"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4 text-center">
                                <% if ("DIKEMBALIKAN".equalsIgnoreCase(status)) { %> 
                                    <span class="px-3 py-1 rounded-full bg-orange-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Kembali</span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(status)) { %> 
                                    <span class="px-3 py-1 rounded-full bg-purple-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Semakan Ketua</span> 
                                <% } else { %>
                                    <span class="px-3 py-1 rounded-full bg-blue-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Dihantar</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2" onclick="event.stopPropagation()">
                                    <% if ("DIKEMBALIKAN".equalsIgnoreCase(status) || "BARU".equalsIgnoreCase(status)) { %>
                                        <a href="<%= request.getContextPath() %>/bantuan/edit?id=<%= pb.getId_permohonan() %>" 
                                           class="w-8 h-8 flex items-center justify-center text-blue-600 hover:bg-blue-100 rounded-lg transition" title="Kemaskini">
                                            <i class="fas fa-pen text-xs"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getId_permohonan() %>" 
                                           onclick="return confirm('Padam permohonan ini?');"
                                           class="w-8 h-8 flex items-center justify-center text-red-600 hover:bg-red-100 rounded-lg transition" title="Padam">
                                            <i class="fas fa-trash text-xs"></i>
                                        </a>
                                    <% } else { %>
                                        <span class="text-[10px] text-gray-400 italic">Terkunci</span>
                                    <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                            <tr class="no-data"><td colspan="5" class="p-12 text-center text-gray-400"><i class="fas fa-inbox text-3xl mb-2 block opacity-50"></i>Tiada permohonan sedang diproses.</td></tr>
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
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh Mohon</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Status</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <% if (!listSejarah.isEmpty()) {
                        int noS = 1;
                        for (PermohonanBantuan pb : listSejarah) {
                            String displayDate = (pb.getDibuat_pada() != null) ? sdfDisplay.format(pb.getDibuat_pada()) : "-";
                            String sStatus = (pb.getStatus() != null) ? pb.getStatus().trim().toUpperCase() : "";
                            
                            // JS Data
                            String jsNama = cleanForJS(pb.getNama_bantuan());
                            String jsCatatan = cleanForJS(pb.getCatatan_pemohon());
                            String jsUlasan = cleanForJS(pb.getCatatan_pentadbir());
                            String jsBank = cleanForJS(pb.getNama_bank());
                            String jsAkaun = cleanForJS(pb.getNombor_akaun());
                            String jsPenyata = (pb.getPenyata_bank() != null) ? URLEncoder.encode(pb.getPenyata_bank(), "UTF-8") : "";
                            
                            // Ambil senarai lampiran - Asingkan PEMOHON dan PENTADBIR
                            StringBuilder sbDocs = new StringBuilder();
                            StringBuilder sbDocsAdmin = new StringBuilder();
                            if(pb.getSenaraiLampiran() != null) {
                                for(model.BantuanLampiran bl : pb.getSenaraiLampiran()) {
                                    if("PEMOHON".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                        if(sbDocs.length() > 0) sbDocs.append(",");
                                        sbDocs.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                    } else if("PENTADBIR".equalsIgnoreCase(bl.getJenis_lampiran())) {
                                        if(sbDocsAdmin.length() > 0) sbDocsAdmin.append(",");
                                        sbDocsAdmin.append(URLEncoder.encode(bl.getNama_fail(), "UTF-8"));
                                    }
                                }
                            }
                            String jsDokumen = sbDocs.toString();
                            String jsDokumenAdmin = sbDocsAdmin.toString();
                    %>
                    <tr class="data-row hover:bg-gray-50 transition cursor-pointer group" 
                        onclick="openDetailModal('<%= jsNama %>', '<%= displayDate %>', '<%= sStatus %>', '<%= jsCatatan %>', '<%= jsUlasan %>', '<%= jsBank %>', '<%= jsAkaun %>', '<%= jsPenyata %>', '<%= jsDokumen %>', '<%= jsDokumenAdmin %>')">
                        <td class="p-4 text-sm text-gray-400 font-medium"><%= noS++ %></td>
                        <td class="p-4 text-sm text-gray-500 whitespace-nowrap"><%= displayDate %></td>
                        <td class="p-4 text-sm font-bold text-gray-700 group-hover:text-[#6C5DD3] search-col"><%= pb.getNama_bantuan() %></td>
                        <td class="p-4 text-center">
                            <% if ("LULUS".equalsIgnoreCase(sStatus)) { %> 
                                <span class="px-3 py-1 rounded-full bg-green-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Disokong</span>
                            <% } else { %> 
                                <span class="px-3 py-1 rounded-full bg-red-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Ditolak</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } else { %>
                        <tr class="no-data"><td colspan="4" class="p-12 text-center text-gray-400"><i class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada sejarah permohonan.</td></tr>
                    <% } %>
                </tbody>
            </table>
            </div>
        </div>
    </div>
</div>
<!-- MODAL: TRACKING PROGRES (PREMIUM REDESIGN) -->
<div id="modalDetail" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeModal('modalDetail')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-white/20 flex flex-col max-h-[90vh]">
            
            <!-- Modal Header (Matching Admin Design) -->
            <div class="bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] px-8 py-6 text-white relative shrink-0">
                <div class="absolute top-0 right-0 p-6 opacity-10">
                    <i class="fas fa-tasks text-8xl rotate-12"></i>
                </div>
                <div class="flex justify-between items-start relative z-10">
                    <div>
                        <span id="detTarikhBadge" class="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase border border-white/20">DIBUAT PADA: <span id="detTarikh">-</span></span>
                        <h3 class="text-2xl font-bold mt-2" id="detNama">-</h3>
                    </div>
                    <button onclick="closeModal('modalDetail')" class="w-10 h-10 flex items-center justify-center rounded-full bg-white/10 hover:bg-white/20 transition-all">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>

            <!-- Scrollable Content -->
            <div class="p-8 overflow-y-auto custom-scrollbar flex-1 bg-white">
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-12">
                    
                    <!-- LEFT COLUMN: VERTICAL PROGRESS TRACKER (STATIC) -->
                    <div class="lg:col-span-4 border-r border-gray-100 pr-8">
                        <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest mb-8 flex items-center gap-2">
                            <i class="fas fa-stream text-[#6C5DD3]"></i> Status Semasa
                        </h5>
                        
                        <div class="space-y-0 relative">
                            <!-- Vertical Line -->
                            <div class="absolute left-[15px] top-2 bottom-2 w-0.5 bg-gray-100"></div>

                            <!-- Step 1: Dihantar -->
                            <div class="relative pl-12 pb-10">
                                <div id="vStep1" class="absolute left-0 top-0 w-8 h-8 rounded-full bg-emerald-500 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10">✓</div>
                                <h4 class="font-bold text-sm text-gray-800">Permohonan Dihantar</h4>
                                <p class="text-[10px] text-gray-400 mt-1 leading-relaxed">Berjaya direkodkan dalam sistem.</p>
                            </div>

                            <!-- Step 2: Biro (AJK) -->
                            <div class="relative pl-12 pb-10">
                                <div id="vStep2" class="absolute left-0 top-0 w-8 h-8 rounded-full bg-gray-200 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10">2</div>
                                <h4 id="vTitle2" class="font-bold text-sm text-gray-400">Semakan Biro Kebajikan</h4>
                                <p id="vDesc2" class="text-[10px] text-gray-400 mt-1 leading-relaxed">Menunggu Biro menyemak dokumen.</p>
                            </div>

                            <!-- Step 3: Ketua Kampung -->
                            <div class="relative pl-12 pb-10">
                                <div id="vStep3" class="absolute left-0 top-0 w-8 h-8 rounded-full bg-gray-200 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10">3</div>
                                <h4 id="vTitle3" class="font-bold text-sm text-gray-400">Pengesahan Ketua Kampung</h4>
                                <p id="vDesc3" class="text-[10px] text-gray-400 mt-1 leading-relaxed">Menunggu kelulusan akhir.</p>
                            </div>

                            <!-- Step 4: Hasil -->
                            <div class="relative pl-12">
                                <div id="vStep4" class="absolute left-0 top-0 w-8 h-8 rounded-full bg-gray-200 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10">4</div>
                                <h4 id="vTitle4" class="font-bold text-sm text-gray-400">Keputusan</h4>
                                <p id="vDesc4" class="text-[10px] text-gray-400 mt-1 leading-relaxed">Status akhir permohonan.</p>
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT COLUMN: DETAILS -->
                    <div class="lg:col-span-8 space-y-8">
                        
                        <!-- Top Row: Bank & Documents -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <!-- Bank Card (Matching Admin Style) -->
                            <div class="bg-blue-50/50 p-6 rounded-[2rem] border border-blue-100 relative overflow-hidden">
                                <div class="absolute -right-4 -bottom-4 opacity-5">
                                    <i class="fas fa-university text-7xl"></i>
                                </div>
                                <h5 class="text-[10px] font-bold text-blue-400 uppercase tracking-widest mb-4">Butiran Bank</h5>
                                <div class="space-y-4 relative z-10">
                                    <div>
                                        <p class="text-[9px] text-blue-400/60 font-bold uppercase">Nama Bank</p>
                                        <p id="detBank" class="font-bold text-blue-900 uppercase text-sm">-</p>
                                    </div>
                                    <div>
                                        <p class="text-[9px] text-blue-400/60 font-bold uppercase">Nombor Akaun</p>
                                        <p id="detAkaun" class="font-bold text-blue-900 text-lg tracking-widest">-</p>
                                    </div>
                                    <div class="pt-2">
                                        <a id="linkPenyata" href="#" target="_blank" class="inline-flex items-center gap-2 px-4 py-2 bg-white text-blue-600 rounded-xl text-[10px] font-bold shadow-sm border border-blue-100 hover:shadow-md transition-all">
                                            <i class="fas fa-file-invoice-dollar"></i> Lihat Penyata
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Documents -->
                            <div class="bg-gray-50 p-6 rounded-[2rem] border border-gray-100 flex flex-col">
                                <h5 class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-4">Dokumen Sokongan</h5>
                                <div id="dokumenList" class="space-y-2 flex-1">
                                    <!-- Dynamic List -->
                                </div>
                                <div class="hidden">
                                    <a id="linkDokumen" href="#" target="_blank" class="flex items-center gap-3 p-3 bg-white border border-gray-100 rounded-2xl hover:border-red-200 transition group">
                                        <div class="w-8 h-8 bg-red-50 rounded-xl flex items-center justify-center text-red-500 shadow-sm group-hover:scale-110 transition">
                                            <i class="fas fa-file-pdf text-xs"></i>
                                        </div>
                                        <span class="text-[10px] font-bold text-gray-700 truncate max-w-[120px]">Fail_Sokongan.pdf</span>
                                        <i class="fas fa-external-link-alt ml-auto text-gray-300 text-[10px]"></i>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Feedback Section (Admin Feedback) -->
                        <div id="ulasanDiv" class="space-y-4">
                            <h5 class="text-[11px] font-bold text-orange-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-shield-alt"></i> Maklum Balas Pentadbir
                            </h5>
                            <div class="bg-orange-50/50 p-6 rounded-[2rem] border border-orange-100 relative">
                                <i class="fas fa-quote-left absolute top-4 left-4 text-orange-100 text-3xl"></i>
                                <div class="relative z-10 pl-8">
                                    <p id="detUlasan" class="text-sm text-gray-700 leading-relaxed font-medium italic">-</p>
                                    
                                    <div id="dokumenAdminSection" class="hidden mt-6 pt-4 border-t border-orange-200/50">
                                        <p class="text-[9px] font-bold text-orange-500 uppercase tracking-widest mb-3">Dokumen Daripada Pentadbir</p>
                                        <div id="dokumenAdminList" class="flex flex-wrap gap-2">
                                            <!-- Dynamic Admin Files -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Reason / Description Section -->
                        <div class="space-y-4">
                            <h5 class="text-[11px] font-bold text-gray-400 uppercase tracking-widest">Keterangan Pemohon</h5>
                            <div class="bg-gray-50/50 p-6 rounded-[2rem] border border-gray-100">
                                <p id="detCatatan" class="text-sm text-gray-600 leading-relaxed">-</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Footer -->
            <div class="bg-slate-50 p-8 flex justify-end border-t border-slate-100 shrink-0">
                <button type="button" class="px-10 py-3 bg-[#6C5DD3] text-white font-bold rounded-2xl hover:bg-[#5b4eb8] transition shadow-lg shadow-purple-100" onclick="closeModal('modalDetail')">
                    Tutup
                </button>
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


<!-- MODAL: WIZARD PERMOHONAN (2 STEPS) -->
<div id="modalWizard" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeWizard()"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl overflow-hidden transition-all duration-300">
            
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data" id="wizardForm">
                <input type="hidden" name="bantuanSource" value="rasmi">
                
                <!-- Wizard Header -->
                <div class="bg-[#6C5DD3] p-6 text-white">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="font-bold text-xl flex items-center gap-2"><i class="fas fa-file-signature"></i> Borang Bantuan Rasmi</h3>
                        <button type="button" onclick="closeWizard()" class="text-white/70 hover:text-white"><i class="fas fa-times"></i></button>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="flex items-center gap-2">
                            <div id="w-step-1" class="w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-sm">1</div>
                            <span class="text-xs font-bold uppercase tracking-wider">Kategori</span>
                        </div>
                        <div class="flex-1 h-px bg-white/20"></div>
                        <div class="flex items-center gap-2">
                            <div id="w-step-2" class="w-8 h-8 rounded-full bg-[#8E82EF] text-white/50 flex items-center justify-center font-bold text-sm border border-white/20">2</div>
                            <span class="text-xs font-bold uppercase tracking-wider text-white/50" id="w-label-2">Butiran & Dokumen</span>
                        </div>
                    </div>
                </div>

                <!-- STEP 1: PILIH BANTUAN -->
                <div id="step-1-content" class="p-8 block">
                    <h4 class="font-bold text-gray-800 mb-4">Sila pilih jenis bantuan yang ingin dimohon:</h4>
                    <div class="grid grid-cols-1 gap-3 max-h-[300px] overflow-y-auto pr-2 custom-scrollbar">
                        <% if (senaraiJenis != null) { 
                            for (Bantuan b : senaraiJenis) { %>
                        <label class="relative flex items-center p-4 bg-gray-50 border-2 border-transparent hover:border-purple-200 rounded-2xl cursor-pointer group transition">
                            <input type="radio" name="jenisBantuan" value="<%= b.getId_bantuan() %>" 
                                   data-name="<%= b.getNama_bantuan() %>" 
                                   data-syarat="<%= (b.getSyarat_dokumen() != null) ? b.getSyarat_dokumen() : "Tiada syarat khusus." %>"
                                   class="hidden peer" required onchange="goToStep(2)">
                            <div class="flex-1">
                                <p class="font-bold text-gray-700 group-hover:text-[#6C5DD3]"><%= b.getNama_bantuan() %></p>
                                <p class="text-[10px] text-gray-400">Kategori: <%= b.getJenis_bantuan() %></p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-bold text-[#6C5DD3]"><%= b.getJumlahBantuanFormatted() %></p>
                                <p class="text-[9px] text-gray-300">Sedia Dimohon</p>
                            </div>
                            <div class="absolute inset-0 border-2 border-[#6C5DD3] rounded-2xl opacity-0 peer-checked:opacity-100 transition-opacity pointer-events-none"></div>
                        </label>
                        <% } } %>
                        <!-- Lain-lain option -->
                        <label class="relative flex items-center p-4 bg-gray-50 border-2 border-transparent hover:border-purple-200 rounded-2xl cursor-pointer group transition">
                            <input type="radio" name="jenisBantuan" value="999" data-name="Lain-lain" data-syarat="Sila lampirkan dokumen sokongan yang berkaitan." class="hidden peer" onchange="goToStep(2)">
                            <div class="flex-1"><p class="font-bold text-gray-700 group-hover:text-[#6C5DD3]">Lain-lain Bantuan</p></div>
                            <i class="fas fa-plus text-gray-300 group-hover:text-[#6C5DD3]"></i>
                            <div class="absolute inset-0 border-2 border-[#6C5DD3] rounded-2xl opacity-0 peer-checked:opacity-100 transition-opacity"></div>
                        </label>
                    </div>
                </div>

                <!-- STEP 2: FORM & BANK -->
                <div id="step-2-content" class="p-8 hidden h-[450px] overflow-y-auto custom-scrollbar">
                    
                    <!-- Syarat Display -->
                    <div class="bg-blue-50 border border-blue-100 p-4 rounded-2xl mb-6 flex gap-3 items-start">
                        <i class="fas fa-info-circle text-blue-500 mt-1"></i>
                        <div>
                            <p class="text-[10px] font-bold text-blue-400 uppercase tracking-widest">Syarat Dokumen Wajib</p>
                            <p id="syaratTxt" class="text-xs text-blue-700 font-medium leading-relaxed mt-1">-</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Personal Info (Read Only) -->
                        <div class="space-y-4">
                            <h5 class="text-xs font-bold text-gray-400 uppercase tracking-widest border-b pb-1">Maklumat Peribadi</h5>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase">Nama Penuh</label>
                                <input type="text" value="<%= uNama %>" readonly class="w-full bg-gray-50 border-none rounded-xl text-sm font-bold text-gray-600 px-4 py-2 mt-1">
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase">No. Kad Pengenalan</label>
                                <input type="text" value="<%= uIC %>" readonly class="w-full bg-gray-50 border-none rounded-xl text-sm font-bold text-gray-600 px-4 py-2 mt-1">
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase">No. Telefon</label>
                                <input type="text" value="<%= uTel %>" readonly class="w-full bg-gray-50 border-none rounded-xl text-sm font-bold text-gray-600 px-4 py-2 mt-1">
                            </div>
                        </div>

                        <!-- Application Details -->
                        <div class="space-y-4">
                            <h5 class="text-xs font-bold text-[#6C5DD3] uppercase tracking-widest border-b pb-1">Butiran Permohonan</h5>
                            <div id="lainInputDiv" class="hidden">
                                <label class="text-[10px] text-purple-500 uppercase font-bold">Jenis Bantuan (Nyatakan)</label>
                                <input type="text" name="jenisBantuanLain" id="inLain" class="w-full bg-purple-50 border-purple-100 border rounded-xl text-sm font-bold px-4 py-2 mt-1">
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase font-bold">Sebab / Keterangan</label>
                                <textarea name="keterangan" required rows="2" class="w-full bg-gray-50 border rounded-xl text-sm px-4 py-2 mt-1 outline-none focus:ring-2 focus:ring-[#6C5DD3] transition"></textarea>
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase font-bold">Lampiran Dokumen (PDF)</label>
                                <input type="file" name="dokumenSokongan" accept="application/pdf" multiple required class="block w-full text-[10px] text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-bold file:bg-purple-100 file:text-[#6C5DD3] mt-1">
                                <p class="text-[8px] text-blue-500 mt-1 italic font-bold">Sila sertakan Borang Permohonan dan dokumen yang perlu dicop (Slip Gaji, Salinan IC dan etc.)</p>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Wizard Footer -->
                <div class="bg-gray-50 p-6 flex justify-between items-center border-t">
                    <button type="button" id="btnBack" onclick="goToStep(1)" class="hidden text-sm font-bold text-gray-500 hover:text-gray-800 flex items-center gap-2">
                        <i class="fas fa-arrow-left"></i> Kembali
                    </button>
                    <div id="step-1-footer" class="flex-1 text-right">
                        <span class="text-[10px] text-gray-400 font-bold mr-4 italic">Pilih satu untuk teruskan...</span>
                    </div>
                    <button type="submit" id="btnSubmit" class="hidden bg-[#6C5DD3] text-white px-8 py-3 rounded-xl font-bold text-sm shadow-lg hover:bg-[#5b4eb8] transition">
                        Hantar Permohonan <i class="fas fa-paper-plane ml-2"></i>
                    </button>
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
    function openDetailModal(nama, tarikh, status, catatan, ulasan, bank, akaun, penyata, dokumen, dokumenAdmin) {
        document.getElementById('detNama').innerText = nama;
        document.getElementById('detTarikh').innerText = tarikh;
        document.getElementById('detCatatan').innerText = (catatan && catatan !== "null") ? catatan : "Tiada maklumat.";
        document.getElementById('detUlasan').innerText = (ulasan && ulasan !== "null") ? ulasan : "Belum ada ulasan.";
        
        // Bank & Files
        document.getElementById('detBank').innerText = (bank && bank !== "null") ? bank : "-";
        document.getElementById('detAkaun').innerText = (akaun && akaun !== "null") ? akaun : "-";
        
        const linkPenyata = document.getElementById('linkPenyata');
        if(penyata) {
            linkPenyata.href = "<%= request.getContextPath() %>/file/bantuan/" + penyata;
            linkPenyata.classList.remove('hidden');
        } else {
            linkPenyata.classList.add('hidden');
        }

        // Files List (PEMOHON)
        const dokumenList = document.getElementById('dokumenList');
        const template = document.getElementById('linkDokumen');
        
        if (dokumenList) {
            dokumenList.innerHTML = '';
            if(dokumen && dokumen !== "" && template) {
                const files = dokumen.split(',');
                files.forEach(f => {
                    const newLink = template.cloneNode(true);
                    newLink.id = ""; // Remove ID to prevent collisions
                    newLink.classList.remove('hidden');
                    newLink.href = "<%= request.getContextPath() %>/file/bantuan/" + f;
                    newLink.querySelector('span').innerText = decodeURIComponent(f).split('_').slice(1).join('_') || decodeURIComponent(f);
                    dokumenList.appendChild(newLink);
                });
            }
        }

        // Files List (PENTADBIR)
        const dokAdminList = document.getElementById('dokumenAdminList');
        const dokAdminSection = document.getElementById('dokumenAdminSection');
        dokAdminList.innerHTML = '';
        
        if(dokumenAdmin && dokumenAdmin !== "" && template) {
            dokAdminSection.classList.remove('hidden');
            const filesA = dokumenAdmin.split(',');
            filesA.forEach(f => {
                const newLink = template.cloneNode(true);
                newLink.id = ""; // Remove ID to prevent collisions
                newLink.classList.remove('hidden');
                newLink.classList.replace('bg-white', 'bg-orange-50');
                newLink.classList.replace('border-gray-100', 'border-orange-100');
                newLink.href = "<%= request.getContextPath() %>/file/bantuan/" + f;
                newLink.querySelector('span').innerText = decodeURIComponent(f).split('_').slice(1).join('_') || decodeURIComponent(f);
                newLink.querySelector('div').classList.replace('text-red-500', 'text-orange-500');
                dokAdminList.appendChild(newLink);
            });
        } else {
            dokAdminSection.classList.add('hidden');
        }
        
        // --- VERTICAL PROGRESS LOGIC (STATIC) ---
        const vSteps = ['vStep2', 'vStep3', 'vStep4'];
        const vTitles = ['vTitle2', 'vTitle3', 'vTitle4'];
        const vDescs = ['vDesc2', 'vDesc3', 'vDesc4'];

        // Reset to default
        vSteps.forEach((s, i) => {
            const stepEl = document.getElementById(s);
            if(stepEl) {
                stepEl.className = "absolute left-0 top-0 w-8 h-8 rounded-full bg-gray-100 text-gray-400 flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10";
                stepEl.innerHTML = i + 2;
                document.getElementById(vTitles[i]).className = "font-bold text-sm text-gray-400";
                document.getElementById(vDescs[i]).className = "text-[10px] text-gray-400 mt-1 leading-relaxed";
            }
        });

        const setStepActive = (idx, color = "bg-[#6C5DD3]", title = "Sedang Diproses", desc = "") => {
            const el = document.getElementById('vStep' + idx);
            if(el) {
                el.className = `absolute left-0 top-0 w-8 h-8 rounded-full \${color} text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10`;
                el.innerHTML = idx;
                document.getElementById('vTitle' + idx).className = "font-bold text-sm text-gray-800";
                if(desc) document.getElementById('vDesc' + idx).innerText = desc;
            }
        };

        const setStepDone = (idx) => {
            const el = document.getElementById('vStep' + idx);
            if(el) {
                el.className = "absolute left-0 top-0 w-8 h-8 rounded-full bg-emerald-500 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10";
                el.innerHTML = "✓";
                document.getElementById('vTitle' + idx).className = "font-bold text-sm text-gray-800";
            }
        };

        if (status === "BARU") {
            setStepActive(2, "bg-[#6C5DD3]", "Semakan Biro Kebajikan", "Dokumen anda sedang disemak oleh AJK.");
        } else if (status === "MENUNGGU_KETUA") {
            setStepDone(2);
            setStepActive(3, "bg-[#6C5DD3]", "Pengesahan Ketua Kampung", "Telah disokong oleh AJK. Menunggu kelulusan Ketua Kampung.");
        } else if (status === "DIKEMBALIKAN") {
            setStepActive(2, "bg-orange-500", "Perlu Kemaskini", "Sila semak maklum balas dan hantar semula dokumen.");
            const step2 = document.getElementById('vStep2');
            if(step2) step2.innerHTML = "!";
        } else if (status === "LULUS" || status === "DITOLAK") {
            setStepDone(2);
            setStepDone(3);
            const color = status === "LULUS" ? "bg-emerald-500" : "bg-red-500";
            setStepActive(4, color, status === "LULUS" ? "Permohonan Diluluskan" : "Permohonan Ditolak", status === "LULUS" ? "Bantuan telah diluluskan. Sila semak akaun/penerimaan." : "Mohon maaf, permohonan tidak berjaya.");
            const step4 = document.getElementById('vStep4');
            if(status === "DITOLAK" && step4) step4.innerHTML = "✕";
        }

        openModal('modalDetail');
    }

    function openWizard() {
        openModal('modalWizard');
        goToStep(1);
    }
    function closeWizard() {
        closeModal('modalWizard');
    }

    function goToStep(step) {
        // Elements
        const s1 = document.getElementById('step-1-content');
        const s2 = document.getElementById('step-2-content');
        const f1 = document.getElementById('step-1-footer');
        const btnBack = document.getElementById('btnBack');
        const btnSubmit = document.getElementById('btnSubmit');
        
        // Progress UI
        const w1 = document.getElementById('w-step-1');
        const w2 = document.getElementById('w-step-2');
        const l2 = document.getElementById('w-label-2');

        if(step === 1) {
            s1.classList.remove('hidden');
            s2.classList.add('hidden');
            f1.classList.remove('hidden');
            btnBack.classList.add('hidden');
            btnSubmit.classList.add('hidden');
            
            w1.className = "w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-sm";
            w2.className = "w-8 h-8 rounded-full bg-[#8E82EF] text-white/50 flex items-center justify-center font-bold text-sm border border-white/20";
            l2.className = "text-xs font-bold uppercase tracking-wider text-white/50";
        } else {
            s1.classList.add('hidden');
            s2.classList.remove('hidden');
            f1.classList.add('hidden');
            btnBack.classList.remove('hidden');
            btnSubmit.classList.remove('hidden');
            
            w1.className = "w-8 h-8 rounded-full bg-emerald-400 text-white flex items-center justify-center font-bold text-sm";
            w1.innerHTML = "✓";
            w2.className = "w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-sm";
            l2.className = "text-xs font-bold uppercase tracking-wider text-white";

            // Get selected aid info
            const selected = document.querySelector('input[name="jenisBantuan"]:checked');
            if(selected) {
                document.getElementById('syaratTxt').innerText = selected.getAttribute('data-syarat');
                if(selected.value === "999") {
                    document.getElementById('lainInputDiv').classList.remove('hidden');
                    document.getElementById('inLain').required = true;
                } else {
                    document.getElementById('lainInputDiv').classList.add('hidden');
                    document.getElementById('inLain').required = false;
                }
            }
        }
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