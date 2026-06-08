<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="model.Bantuan" %> 
<%@ page import="model.Pengguna" %> 
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

    // Default User Info for Auto-populate
    String uNama = (currentUser != null) ? currentUser.getNama_penuh() : "";
    String uIC = (currentUser != null) ? currentUser.getNombor_kp() : "";
    String uTel = (currentUser != null) ? currentUser.getNombor_telefon() : "";
    String uAlamat = (currentUser != null) ? currentUser.getAlamatLengkap() : "";
%>

<%! 
    public String cleanForJS(String text) {
        if (text == null) return "";
        return text.replace("\r\n", " ").replace("\n", " ").replace("'", "\\'").replace("\"", "&quot;");
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <% if (request.getParameter("status") != null) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
            <i class="fas fa-check-circle text-lg"></i>
            <div>
                <span class="font-bold">Berjaya!</span> Permohonan anda telah diterima.
            </div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-green-500 hover:text-green-700"><i class="fas fa-times"></i></button>
        </div>
    <% } %>

    <div class="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Bantuan Komuniti</h2>
            <p class="text-gray-500 text-sm">Sistem bantuan kebajikan digital untuk warga Kampung Danan.</p>
        </div>
        <button onclick="openWizard()" class="bg-brand-purple hover:bg-brand-purpleHover text-white px-6 py-3 rounded-2xl font-bold text-sm transition shadow-lg shadow-purple-100 flex items-center gap-2">
            <i class="fas fa-plus-circle"></i> Mohon Baru
        </button>
    </div>

    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8" aria-label="Tabs">
            <button onclick="switchTab('proses')" id="tab-proses" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-brand-purple text-brand-purple">
                <i class="fas fa-sync-alt"></i> Sedang Diproses
                <% if (!listProses.isEmpty()) { %>
                    <span class="bg-brand-purple text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= listProses.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-history"></i> Sejarah Terdahulu
            </button>
        </nav>
    </div>

    <!-- TAB: PROSES -->
    <div id="content-proses" class="block">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableProses">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider w-16">No.</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Tarikh Mohon</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider">Jenis Bantuan</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Status</th>
                            <th class="p-4 text-xs font-bold text-gray-400 uppercase tracking-wider text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (!listProses.isEmpty()) { 
                            int no = 1;
                            for (PermohonanBantuan pb : listProses) {
                                String displayDate = (pb.getDibuat_pada() != null) ? sdfDisplay.format(pb.getDibuat_pada()) : "-";
                                String status = (pb.getStatus() != null) ? pb.getStatus().toUpperCase() : "BARU";
                                
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

                                StringBuilder sbDocsJson = new StringBuilder();
                                sbDocsJson.append("[");
                                if(pb.getSenaraiLampiran() != null) {
                                    List<model.BantuanLampiran> lamps = pb.getSenaraiLampiran();
                                    for(int idx = 0; idx < lamps.size(); idx++) {
                                        model.BantuanLampiran bl = lamps.get(idx);
                                        sbDocsJson.append("{");
                                        sbDocsJson.append("\"id\":").append(bl.getId_lampiran()).append(",");
                                        sbDocsJson.append("\"nama\":\"").append(cleanForJS(bl.getNama_fail())).append("\"");
                                        sbDocsJson.append("}");
                                        if(idx < lamps.size() - 1) sbDocsJson.append(",");
                                    }
                                }
                                sbDocsJson.append("]");
                                String jsDocsJson = sbDocsJson.toString();
                        %>
                        <tr class="hover:bg-purple-50/50 transition cursor-pointer group" 
                            onclick="openDetailModal('<%= jsNama %>', '<%= displayDate %>', '<%= status %>', '<%= jsCatatan %>', '<%= jsUlasan %>', '<%= jsBank %>', '<%= jsAkaun %>', '<%= jsPenyata %>', '<%= jsDokumen %>')">
                            <td class="p-4 text-sm text-gray-400 font-medium"><%= no++ %></td>
                            <td class="p-4 text-sm text-gray-600"><%= displayDate %></td>
                            <td class="p-4 text-sm font-bold text-gray-800 group-hover:text-brand-purple"><%= pb.getNama_bantuan() %></td>
                            <td class="p-4 text-center">
                                <% if ("DIKEMBALIKAN".equalsIgnoreCase(status)) { %> 
                                    <span class="px-3 py-1 rounded-full bg-orange-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Dikembalikan</span>
                                <% } else if ("MENUNGGU_KETUA".equalsIgnoreCase(status)) { %> 
                                    <span class="px-3 py-1 rounded-full bg-purple-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Semakan Ketua</span> 
                                <% } else { %>
                                    <span class="px-3 py-1 rounded-full bg-blue-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Dihantar</span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <div class="flex justify-center gap-2" onclick="event.stopPropagation()">
                                     <% if ("DIKEMBALIKAN".equalsIgnoreCase(status)) { %>
                                         <button type="button" 
                                                 class="edit-btn-<%= pb.getId_permohonan() %> w-8 h-8 flex items-center justify-center text-blue-600 hover:bg-blue-100 rounded-lg transition" 
                                                 title="Kemaskini"
                                                 data-id="<%= pb.getId_permohonan() %>"
                                                 data-idbantuan="<%= pb.getId_bantuan() %>"
                                                 data-nama="<%= jsNama %>"
                                                 data-catatan="<%= jsCatatan %>"
                                                 data-bank="<%= jsBank %>"
                                                 data-akaun="<%= jsAkaun %>"
                                                 data-penyata="<%= jsPenyata %>"
                                                 data-israsmi="false"
                                                 data-docs='<%= jsDocsJson %>'
                                                 onclick="initiateEdit(this)">
                                             <i class="fas fa-pen text-xs"></i>
                                         </button>
                                         <a href="<%= request.getContextPath() %>/bantuan/delete?idPermohonan=<%= pb.getId_permohonan() %>" 
                                            onclick="confirmDelete(event, this.href);"
                                            class="w-8 h-8 flex items-center justify-center text-red-600 hover:bg-red-100 rounded-lg transition" title="Padam">
                                             <i class="fas fa-trash text-xs"></i>
                                         </a>
                                     <% } else { %>
                                         <span class="text-[10px] text-gray-400 italic">Terkunci</span>
                                     <% } %>
                                </div>
                            </td>
                        </tr>
                        <% } } %>
                        <tr id="tableProses-empty" class="<%= !listProses.isEmpty() ? "hidden" : "" %> empty-state-row">
                            <td colspan="5" class="p-12 text-center text-gray-400">
                                <i class="fas fa-inbox text-4xl mb-4 block opacity-20"></i>Tiada permohonan aktif.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div id="footerProses" class="p-6 bg-white border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
            </div>
        </div>
    </div>

    <!-- TAB: SEJARAH -->
    <div id="content-sejarah" class="hidden">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
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
                            String sStatus = (pb.getStatus() != null) ? pb.getStatus().toUpperCase() : "";
                            
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
                        <td class="p-4 text-sm text-gray-500"><%= displayDate %></td>
                        <td class="p-4 text-sm font-bold text-gray-700 group-hover:text-brand-purple"><%= pb.getNama_bantuan() %></td>
                        <td class="p-4 text-center">
                             <% if ("LULUS".equalsIgnoreCase(sStatus)) { %> 
                                 <span class="px-3 py-1 rounded-full bg-green-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Disokong</span>
                             <% } else { %> 
                                 <span class="px-3 py-1 rounded-full bg-red-500 text-white text-[10px] font-bold uppercase whitespace-nowrap">Ditolak</span>
                             <% } %>
                        </td>
                    </tr>
                    <% } } %>
                    <tr id="tableSejarah-empty" class="<%= !listSejarah.isEmpty() ? "hidden" : "" %> empty-state-row">
                        <td colspan="4" class="p-12 text-center text-gray-400">
                            <i class="fas fa-history text-4xl mb-4 block opacity-20"></i>Tiada sejarah permohonan.
                        </td>
                    </tr>
                </tbody>
            </table>
            <div id="footerSejarah" class="p-6 bg-white border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
            </div>
        </div>
    </div>

</div>

<!-- SIDE PANEL: MAKLUMAT KELAYAKAN & DANA -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full shrink-0">
    <div class="mb-8">
        <h3 class="font-black text-lg text-slate-800 tracking-tight">Kriteria & Had Dana</h3>
        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mt-1">Panduan Bantuan Komuniti</p>
    </div>

    <div class="flex flex-col gap-6 flex-1">
        <!-- Had Siling Bantuan -->
        <div class="bg-emerald-50/50 border border-emerald-100 rounded-3xl p-5 shadow-sm transition-all hover:bg-emerald-50">
            <h4 class="text-xs font-black text-emerald-700 uppercase tracking-wider mb-3 flex items-center gap-1.5">
                <i class="fas fa-coins text-sm"></i> Anggaran Kadar Bantuan
            </h4>
            <ul class="space-y-3.5 text-[11px] text-slate-600 font-medium">
                <li class="flex items-start justify-between gap-2 border-b border-dashed border-emerald-100 pb-2">
                    <span class="text-slate-700 font-bold">Khairat Kematian:</span>
                    <span class="text-emerald-600 font-black">RM 500.00</span>
                </li>
                <li class="flex items-start justify-between gap-2 border-b border-dashed border-emerald-100 pb-2">
                    <span class="text-slate-700 font-bold">Bantuan Bencana:</span>
                    <span class="text-emerald-600 font-black">Sehingga RM 1,000</span>
                </li>
                <li class="flex items-start justify-between gap-2 border-b border-dashed border-emerald-100 pb-2">
                    <span class="text-slate-700 font-bold">Kos Perubatan:</span>
                    <span class="text-emerald-600 font-black">Sehingga RM 500</span>
                </li>
                <li class="flex items-start justify-between gap-2">
                    <span class="text-slate-700 font-bold">Pendidikan/Kemasukan IPT:</span>
                    <span class="text-emerald-600 font-black">RM 200.00</span>
                </li>
            </ul>
        </div>

        <!-- Syarat Kelayakan -->
        <div class="space-y-4">
            <h4 class="text-xs font-black text-slate-800 uppercase tracking-wider flex items-center gap-1.5">
                <i class="fas fa-user-shield text-sm text-brand-purple"></i> Syarat Kelayakan
            </h4>
            <ul class="space-y-3.5 text-[11px] text-slate-600 leading-relaxed font-medium">
                <li class="flex items-start gap-2">
                    <span class="w-1.5 h-1.5 rounded-full bg-brand-purple shrink-0 mt-1.5"></span>
                    <span>Merupakan penduduk <strong>berdaftar</strong> di Kampung Danan dengan status profil "Aktif".</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="w-1.5 h-1.5 rounded-full bg-brand-purple shrink-0 mt-1.5"></span>
                    <span>Pendapatan isi rumah di bawah paras kriteria (diutamakan golongan B40, asnaf, atau miskin tegar).</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="w-1.5 h-1.5 rounded-full bg-brand-purple shrink-0 mt-1.5"></span>
                    <span>Mempunyai bukti sokongan rasmi (sijil kematian, laporan polis bagi bencana, surat tawaran belajar, dll).</span>
                </li>
            </ul>
        </div>
    </div>

    <!-- Informational Tip Card -->
    <div class="mt-8 bg-brand-accent border border-brand-secondary/10 rounded-3xl p-6 relative overflow-hidden group hover:border-brand-secondary/20 transition-all duration-300 shrink-0">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-brand-purple/5 rounded-full opacity-50 group-hover:scale-110 transition-transform"></div>
        <h4 class="font-black text-brand-purple text-xs uppercase tracking-widest mb-2 relative z-10 flex items-center gap-1.5">
            <i class="fas fa-info-circle"></i> Info Dana Kampung
        </h4>
        <p class="text-[11px] text-slate-500 leading-relaxed relative z-10 font-medium">
            Dana Bantuan Komuniti ini disumbangkan oleh hasil kutipan kebajikan kariah kampung, zakat setempat, serta sumbangan khas individu persendirian.
        </p>
    </div>
</aside>

<!-- MODAL: TRACKING PROGRES (PREMIUM REDESIGN) -->
<div id="modalDetail" class="fixed inset-0 z-[60] hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm" onclick="closeModal('modalDetail')"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-white/20 flex flex-col max-h-[90vh]">
            
            <!-- Modal Header (Matching Admin Design) -->
            <div class="bg-gradient-to-r from-brand-purple to-brand-secondary px-8 py-6 text-white relative shrink-0">
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
                            <i class="fas fa-stream text-brand-purple"></i> Status Semasa
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
                <button type="button" class="px-10 py-3 bg-brand-purple text-white font-bold rounded-2xl hover:bg-brand-purpleHover transition shadow-lg shadow-purple-100" onclick="closeModal('modalDetail')">
                    Tutup
                </button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: WIZARD PERMOHONAN (2 STEPS) -->
<div id="modalWizard" class="fixed inset-0 z-50 hidden" role="dialog">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeWizard()"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative w-full max-w-2xl bg-white rounded-3xl shadow-2xl overflow-hidden transition-all duration-300">
            
            <form action="<%= request.getContextPath() %>/bantuan/apply" method="post" enctype="multipart/form-data" id="wizardForm">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="bantuanSource" value="komuniti">
                
                <!-- Wizard Header -->
                <div class="bg-brand-purple p-6 text-white">
                    <div class="flex justify-between items-center mb-6">
                        <h3 class="font-bold text-xl flex items-center gap-2"><i class="fas fa-file-signature"></i> Borang Bantuan Digital</h3>
                        <button type="button" onclick="closeWizard()" class="text-white/70 hover:text-white"><i class="fas fa-times"></i></button>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="flex items-center gap-2">
                            <div id="w-step-1" class="w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-sm">1</div>
                            <span class="text-xs font-bold uppercase tracking-wider">Kategori</span>
                        </div>
                        <div class="flex-1 h-px bg-white/20"></div>
                        <div class="flex items-center gap-2">
                            <div id="w-step-2" class="w-8 h-8 rounded-full bg-[#8E82EF] text-white/50 flex items-center justify-center font-bold text-sm border border-white/20">2</div>
                            <span class="text-xs font-bold uppercase tracking-wider text-white/50" id="w-label-2">Butiran & Bank</span>
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
                                <p class="font-bold text-gray-700 group-hover:text-brand-purple"><%= b.getNama_bantuan() %></p>
                                <p class="text-[10px] text-gray-400">Kategori: <%= b.getJenis_bantuan() %></p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm font-bold text-brand-purple"><%= b.getJumlahBantuanFormatted() %></p>
                                <p class="text-[9px] text-gray-300">Sedia Dimohon</p>
                            </div>
                            <div class="absolute inset-0 border-2 border-brand-purple rounded-2xl opacity-0 peer-checked:opacity-100 transition-opacity pointer-events-none"></div>
                        </label>
                        <% } } %>
                        <!-- Lain-lain option -->
                        <label class="relative flex items-center p-4 bg-gray-50 border-2 border-transparent hover:border-purple-200 rounded-2xl cursor-pointer group transition">
                            <input type="radio" name="jenisBantuan" value="998" data-name="Lain-lain" data-syarat="Sila lampirkan dokumen sokongan yang berkaitan." class="hidden peer" onchange="goToStep(2)">
                            <div class="flex-1"><p class="font-bold text-gray-700 group-hover:text-brand-purple">Lain-lain Bantuan</p></div>
                            <i class="fas fa-plus text-gray-300 group-hover:text-brand-purple"></i>
                            <div class="absolute inset-0 border-2 border-brand-purple rounded-2xl opacity-0 peer-checked:opacity-100 transition-opacity"></div>
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
                            <h5 class="text-xs font-bold text-brand-purple uppercase tracking-widest border-b pb-1">Butiran Permohonan</h5>
                            <div id="lainInputDiv" class="hidden">
                                <label class="text-[10px] text-purple-500 uppercase font-bold">Jenis Bantuan (Nyatakan)</label>
                                <input type="text" name="jenisBantuanLain" id="inLain" class="w-full bg-purple-50 border-purple-100 border rounded-xl text-sm font-bold px-4 py-2 mt-1">
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase font-bold">Sebab / Keterangan</label>
                                <textarea name="keterangan" required rows="2" class="w-full bg-gray-50 border rounded-xl text-sm px-4 py-2 mt-1 outline-none focus:ring-2 focus:ring-brand-purple transition"></textarea>
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-400 uppercase font-bold">Lampiran Dokumen (PDF)</label>
                                <input type="file" id="dokumenSokongan" name="dokumenSokongan" accept="application/pdf" multiple required class="block w-full text-[10px] text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-bold file:bg-purple-100 file:text-brand-purple mt-1">
                                <div id="selectedFilesList" class="mt-2 space-y-2"></div>
                                <p class="text-[8px] text-gray-400 mt-1 italic">Boleh pilih lebih daripada satu fail.</p>
                            </div>
                        </div>
                    </div>

                    <!-- BANK SECTION (USER REQUEST) -->
                    <div class="mt-8 pt-6 border-t border-gray-100">
                        <h5 class="text-xs font-bold text-blue-600 uppercase tracking-widest mb-4 flex items-center gap-2">
                            <i class="fas fa-university"></i> Maklumat Bank & Penyaluran
                        </h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 bg-blue-50/30 p-6 rounded-3xl border border-blue-50">
                            <div>
                                <label class="text-[10px] text-gray-500 uppercase font-bold">Nama Bank</label>
                                <input type="text" name="namaBank" required placeholder="Contoh: Maybank, CIMB, Bank Islam" onkeypress="return !/[0-9]/.test(event.key)" oninput="this.value = this.value.replace(/[0-9]/g, '')" class="w-full bg-white border rounded-xl text-sm px-4 py-3 mt-1 outline-none focus:ring-2 focus:ring-blue-400 transition shadow-sm font-bold">
                            </div>
                            <div>
                                <label class="text-[10px] text-gray-500 uppercase font-bold">Nombor Akaun</label>
                                <input type="text" name="nomorAkaun" required placeholder="Sila semak nombor dengan betul" oninput="this.value = this.value.replace(/[^0-9]/g, '')" pattern="[0-9]*" inputmode="numeric" class="w-full bg-white border rounded-xl text-sm px-4 py-3 mt-1 outline-none focus:ring-2 focus:ring-blue-400 transition shadow-sm font-bold tracking-wider">
                            </div>
                            <div class="md:col-span-2">
                                <label class="text-[10px] text-gray-500 uppercase font-bold">Muat Naik Penyata Bank (Bukti Kewujudan Akaun)</label>
                                <div class="mt-2 flex items-center gap-4">
                                    <div class="flex-1 bg-white p-3 rounded-xl border border-dashed border-blue-300 flex items-center gap-3 relative animate-in fade-in duration-200" id="penyataUploadBox">
                                        <i class="fas fa-file-invoice-dollar text-blue-400 text-xl"></i>
                                        <input type="file" id="penyataBankInput" name="penyataBank" accept="application/pdf" required class="text-xs text-gray-400">
                                    </div>
                                    <div id="penyataFilePreview" class="hidden flex-1 bg-white p-3 rounded-xl border border-blue-300 flex items-center justify-between text-[10px] font-bold animate-in zoom-in-95 duration-200">
                                        <span class="truncate max-w-[280px] text-gray-700">
                                            <i class="fas fa-file-pdf text-red-500 mr-2 text-xs"></i><span id="penyataFileName">-</span>
                                        </span>
                                        <button type="button" id="btnDeletePenyata" class="w-7 h-7 rounded-lg bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition flex items-center justify-center active:scale-95 shrink-0">
                                            <i class="fas fa-trash-alt text-[10px]"></i>
                                        </button>
                                    </div>
                                    <p class="text-[9px] text-gray-400 w-32 leading-tight">Pastikan nama pada penyata bank sama dengan nama pemohon.</p>
                                </div>
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
                    <button type="submit" id="btnSubmit" class="hidden bg-brand-purple text-white px-8 py-3 rounded-xl font-bold text-sm shadow-lg hover:bg-brand-purpleHover transition">
                        Hantar Permohonan <i class="fas fa-paper-plane ml-2"></i>
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

<script>
    function switchTab(tabName) {
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-brand-purple', 'text-brand-purple', 'font-bold');
            btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
        });
        document.getElementById('tab-' + tabName).classList.add('border-brand-purple', 'text-brand-purple', 'font-bold');
        document.getElementById('content-proses').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    function openWizard() {
        openModal('modalWizard');
        goToStep(1);
    }
    function closeWizard() { 
        closeModal('modalWizard'); 
    }



    // TRACKING & DETAIL MODAL LOGIC
    // TRACKING & DETAIL MODAL LOGIC
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
            document.getElementById(s).className = "absolute left-0 top-0 w-8 h-8 rounded-full bg-gray-100 text-gray-400 flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10";
            document.getElementById(s).innerHTML = i + 2;
            document.getElementById(vTitles[i]).className = "font-bold text-sm text-gray-400";
            document.getElementById(vDescs[i]).className = "text-[10px] text-gray-400 mt-1 leading-relaxed";
        });

        const setStepActive = (idx, color = "bg-brand-purple", title = "Sedang Diproses", desc = "") => {
            const el = document.getElementById('vStep' + idx);
            el.className = `absolute left-0 top-0 w-8 h-8 rounded-full \${color} text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10`;
            el.innerHTML = idx;
            document.getElementById('vTitle' + idx).className = "font-bold text-sm text-gray-800";
            if(desc) document.getElementById('vDesc' + idx).innerText = desc;
        };

        const setStepDone = (idx) => {
            const el = document.getElementById('vStep' + idx);
            el.className = "absolute left-0 top-0 w-8 h-8 rounded-full bg-emerald-500 text-white flex items-center justify-center font-bold text-xs border-4 border-white shadow-sm z-10";
            el.innerHTML = "✓";
            document.getElementById('vTitle' + idx).className = "font-bold text-sm text-gray-800";
        };

        if (status === "BARU") {
            setStepActive(2, "bg-brand-purple", "Semakan Biro Kebajikan", "Dokumen anda sedang disemak oleh AJK.");
        } else if (status === "MENUNGGU_KETUA") {
            setStepDone(2);
            setStepActive(3, "bg-brand-purple", "Pengesahan Ketua Kampung", "Telah disokong oleh AJK. Menunggu kelulusan Ketua Kampung.");
        } else if (status === "DIKEMBALIKAN") {
            setStepActive(2, "bg-orange-500", "Perlu Kemaskini", "Sila semak maklum balas dan hantar semula dokumen.");
            document.getElementById('vStep2').innerHTML = "!";
        } else if (status === "LULUS" || status === "DITOLAK") {
            setStepDone(2);
            setStepDone(3);
            const color = status === "LULUS" ? "bg-emerald-500" : "bg-red-500";
            setStepActive(4, color, status === "LULUS" ? "Permohonan Diluluskan" : "Permohonan Ditolak", status === "LULUS" ? "Bantuan telah diluluskan. Sila semak akaun/penerimaan." : "Mohon maaf, permohonan tidak berjaya.");
            if(status === "DITOLAK") document.getElementById('vStep4').innerHTML = "✕";
        }

        openModal('modalDetail');
    }

    function goToStep(step) {
        const s1 = document.getElementById('step-1-content');
        const s2 = document.getElementById('step-2-content');
        const h1 = document.getElementById('w-step-1');
        const h2 = document.getElementById('w-step-2');
        const l2 = document.getElementById('w-label-2');
        const bBack = document.getElementById('btnBack');
        const bSub = document.getElementById('btnSubmit');

        if(step === 1) {
            s1.classList.remove('hidden');
            s2.classList.add('hidden');
            h1.className = "w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-sm";
            h2.className = "w-8 h-8 rounded-full bg-[#8E82EF] text-white/50 flex items-center justify-center font-bold text-sm border border-white/20";
            l2.classList.add('text-white/50');
            bBack.classList.add('hidden');
            bSub.classList.add('hidden');
        } else {
            // STEP 2
            const selected = document.querySelector('input[name="jenisBantuan"]:checked');
            if(!selected) return;

            s1.classList.add('hidden');
            s2.classList.remove('hidden');
            h1.className = "w-8 h-8 rounded-full bg-green-400 text-white flex items-center justify-center font-bold text-sm";
            h1.innerHTML = "✓";
            h2.className = "w-8 h-8 rounded-full bg-white text-brand-purple flex items-center justify-center font-bold text-sm";
            l2.classList.remove('text-white/50');
            bBack.classList.remove('hidden');
            bSub.classList.remove('hidden');

            // Set Syarat & Type
            document.getElementById('syaratTxt').innerText = selected.getAttribute('data-syarat');
            const lainDiv = document.getElementById('lainInputDiv');
            const inLain = document.getElementById('inLain');
            if(selected.value === "998") {
                lainDiv.classList.remove('hidden');
                inLain.required = true;
            } else {
                lainDiv.classList.add('hidden');
                inLain.required = false;
            }
        }
    }

    // File upload removal logic
    (function() {
        const fileInput = document.getElementById('dokumenSokongan');
        const container = document.getElementById('selectedFilesList');
        if (!fileInput || !container) return;

        let selectedFiles = [];

        fileInput.addEventListener('change', function() {
            for (let i = 0; i < this.files.length; i++) {
                selectedFiles.push(this.files[i]);
            }
            this.value = ''; // Clear input to allow re-selection
            updateDisplay();
        });

        function updateDisplay() {
            container.innerHTML = '';
            const dt = new DataTransfer();
            
            selectedFiles.forEach((file, index) => {
                dt.items.add(file);
                
                const item = document.createElement('div');
                item.className = 'flex items-center justify-between p-3 bg-gray-50 border border-gray-150 rounded-2xl text-[10px] font-bold';
                item.innerHTML = `
                    <span class="truncate max-w-[200px] text-gray-700">
                        <i class="fas fa-file-pdf text-red-500 mr-2 text-xs"></i>\${file.name} (\${(file.size/1024).toFixed(1)} KB)
                    </span>
                    <button type="button" class="w-7 h-7 rounded-lg bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition flex items-center justify-center active:scale-95 shrink-0">
                        <i class="fas fa-trash-alt text-[10px]"></i>
                    </button>
                `;
                
                item.querySelector('button').onclick = function() {
                    selectedFiles.splice(index, 1);
                    updateDisplay();
                };
                
                container.appendChild(item);
            });

            // Sync the DataTransfer files list to input file files
            fileInput.files = dt.files;
        }
    })();

    // Single penyataBank file upload removal logic
    (function() {
        const penyataInput = document.getElementById('penyataBankInput');
        const penyataBox = document.getElementById('penyataUploadBox');
        const penyataPreview = document.getElementById('penyataFilePreview');
        const penyataName = document.getElementById('penyataFileName');
        const btnDeletePenyata = document.getElementById('btnDeletePenyata');

        if (penyataInput && penyataBox && penyataPreview && penyataName && btnDeletePenyata) {
            penyataInput.addEventListener('change', function() {
                if (this.files && this.files.length > 0) {
                    penyataName.innerText = this.files[0].name;
                    penyataBox.classList.add('hidden');
                    penyataPreview.classList.remove('hidden');
                }
            });

            btnDeletePenyata.addEventListener('click', function() {
                penyataInput.value = ''; // Clear selected file
                penyataName.innerText = '-';
                penyataPreview.classList.add('hidden');
                penyataBox.classList.remove('hidden');
            });
        }
    })();

    // Client-side Pagination Logic
    const clientPaginators = {};

    function initClientPagination(tableId, footerId, itemsPerPage = 10) {
        clientPaginators[tableId] = {
            footerId: footerId,
            itemsPerPage: itemsPerPage,
            currentPage: 1
        };
        updateClientPagination(tableId);
    }

    function updateClientPagination(tableId) {
        const paginator = clientPaginators[tableId];
        if (!paginator) return;

        const table = document.getElementById(tableId);
        const footer = document.getElementById(paginator.footerId);
        if (!table || !footer) return;

        const tbody = table.querySelector('tbody');
        const allRows = Array.from(tbody.querySelectorAll('tr:not(.empty-state-row)'));
        const visibleRows = allRows.filter(row => row.getAttribute('data-search-hidden') !== 'true');

        const totalItems = visibleRows.length;
        const totalPages = Math.ceil(totalItems / paginator.itemsPerPage) || 1;

        if (paginator.currentPage > totalPages) {
            paginator.currentPage = totalPages;
        }
        if (!(paginator.currentPage >= 1)) {
            paginator.currentPage = 1;
        }

        allRows.forEach(row => {
            row.style.display = 'none';
        });

        const startIndex = (paginator.currentPage - 1) * paginator.itemsPerPage;
        const endIndex = startIndex + paginator.itemsPerPage;

        visibleRows.forEach((row, index) => {
            if (index >= startIndex && !(index >= endIndex)) {
                row.style.display = '';
            }
        });

        // Show/hide empty state
        const emptyRow = document.getElementById(tableId + '-empty');
        if (emptyRow) {
            if (totalItems === 0) {
                emptyRow.classList.remove('hidden');
            } else {
                emptyRow.classList.add('hidden');
            }
        }

        renderClientFooter(tableId, footer, paginator.currentPage, totalPages, totalItems);
    }

    function renderClientFooter(tableId, footer, currentPage, totalPages, totalItems) {
        let pagesHtml = '';
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, startPage + 4);
        
        for (let i = startPage; !(i > endPage); i++) {
            if (i === currentPage) {
                pagesHtml += '<button type="button" class="w-9 h-9 flex items-center justify-center rounded-xl text-xs font-bold bg-brand-purple text-white shadow-lg shadow-purple-100">' +
                             i +
                             '</button>';
            } else {
                pagesHtml += '<button type="button" onclick="setClientPage(\'' + tableId + '\', ' + i + ')" class="w-9 h-9 flex items-center justify-center rounded-xl text-xs font-bold bg-white text-gray-500 hover:bg-gray-50 border border-gray-100 transition">' +
                             i +
                             '</button>';
            }
        }

        let leftBtnHtml = '';
        if (currentPage > 1) {
            leftBtnHtml = '<button type="button" onclick="setClientPage(\'' + tableId + '\', ' + (currentPage - 1) + ')" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">' +
                          '<i class="fas fa-chevron-left"></i> Sebelumnya' +
                          '</button>';
        } else {
            leftBtnHtml = '<button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">' +
                          '<i class="fas fa-chevron-left"></i> Sebelumnya' +
                          '</button>';
        }

        let rightBtnHtml = '';
        if (currentPage !== totalPages) {
            rightBtnHtml = '<button type="button" onclick="setClientPage(\'' + tableId + '\', ' + (currentPage + 1) + ')" class="px-4 py-2 bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-600 hover:bg-gray-50 transition flex items-center gap-2">' +
                           'Seterusnya <i class="fas fa-chevron-right"></i>' +
                           '</button>';
        } else {
            rightBtnHtml = '<button disabled class="px-4 py-2 bg-gray-50 border border-gray-100 rounded-xl text-xs font-bold text-gray-300 cursor-not-allowed flex items-center gap-2">' +
                           'Seterusnya <i class="fas fa-chevron-right"></i>' +
                           '</button>';
        }

        footer.innerHTML = 
            '<div class="text-xs text-gray-500 font-medium">' +
            '    Menunjukkan halaman <span class="text-gray-900 font-bold">' + currentPage + '</span> daripada <span class="text-gray-900 font-bold">' + totalPages + '</span> ' +
            '    (' + totalItems + ' rekod keseluruhan)' +
            '</div>' +
            '' +
            '<div class="flex items-center gap-2">' +
            '    ' + leftBtnHtml +
            '' +
            '    <div class="flex items-center gap-1">' +
            '        ' + pagesHtml +
            '    </div>' +
            '' +
            '    ' + rightBtnHtml +
            '' +
            '    ' +
            '    <div class="flex items-center gap-1.5 text-xs text-gray-500 font-medium border-l border-gray-200 pl-4 ml-2">' +
            '        <span>Lompat ke:</span>' +
            '        <input type="number" min="1" max="' + totalPages + '" value="' + currentPage + '" ' +
            '               id="page-jump-' + tableId + '" ' +
            '               class="w-12 h-9 px-2 text-center bg-white border border-gray-200 rounded-xl text-xs font-bold text-gray-700 outline-none focus:ring-2 focus:ring-brand-purple focus:border-brand-purple [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none">' +
            '    </div>' +
            '</div>';

        const jumpInput = document.getElementById('page-jump-' + tableId);
        if (jumpInput) {
            jumpInput.addEventListener('keypress', function(event) {
                if (event.key === 'Enter') {
                    const p = parseInt(this.value);
                    if (p >= 1 && p <= totalPages) {
                        setClientPage(tableId, p);
                    }
                }
            });
        }
    }

    function setClientPage(tableId, page) {
        if (clientPaginators[tableId]) {
            clientPaginators[tableId].currentPage = page;
            updateClientPagination(tableId);
        }
    }

    window.addEventListener('DOMContentLoaded', function() {
        initClientPagination('tableProses', 'footerProses', 10);
        initClientPagination('tableSejarah', 'footerSejarah', 10);
    });
</script>

<!-- Modal Edit Permohonan -->
<div id="modalEditPermohonan" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-slate-900/60 transition-opacity backdrop-blur-md" onclick="closeEditModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-2xl bg-white rounded-[2.5rem] shadow-2xl p-10 transform transition-all animate-fade-in-up flex flex-col max-h-[90vh]">
            <header class="flex justify-between items-center mb-6 shrink-0">
                <div>
                    <h3 class="text-2xl font-bold text-gray-800">Kemaskini Permohonan</h3>
                    <p class="text-xs text-gray-400 mt-1">Sila kemaskini maklumat permohonan anda di bawah.</p>
                </div>
                <button type="button" onclick="closeEditModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form id="editPermohonanForm" action="<%= request.getContextPath() %>/bantuan/updateMyRequest" method="post" enctype="multipart/form-data" class="space-y-6 overflow-y-auto pr-2 custom-scrollbar flex-1">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="idPermohonan" id="editIdPermohonan">
                <input type="hidden" name="jenisBantuan" id="editJenisBantuan">
                <input type="hidden" name="oldPenyataBank" id="editOldPenyataBank">

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Jenis Bantuan <span class="text-[9px] bg-gray-100 text-gray-400 px-2 py-0.5 rounded italic">Kunci</span></label>
                    <input type="text" id="editNamaBantuanDisplay" readonly
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl text-sm font-bold text-gray-500 cursor-not-allowed">
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Keterangan / Sebab Permohonan <span class="text-[9px] bg-gray-100 text-gray-400 px-2 py-0.5 rounded italic">Kunci</span></label>
                    <textarea id="editCatatanDisplay" readonly rows="3"
                              class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl text-sm font-medium text-gray-500 cursor-not-allowed"></textarea>
                </div>

                <div class="space-y-4">
                    <label class="block text-[10px] font-bold text-gray-500 uppercase tracking-widest px-2">Dokumen Sokongan (PDF)</label>
                    
                    <div id="editDokumenList" class="space-y-2">
                        <!-- Populated dynamically via JS -->
                    </div>

                    <div class="bg-purple-50/50 p-4 rounded-2xl border border-purple-100 border-dashed">
                        <label class="block text-[9px] font-bold text-brand-purple uppercase mb-2">Tambah Dokumen Baru</label>
                        <input type="file" name="dokumenSokongan" accept="application/pdf" multiple
                               class="block w-full text-xs text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-bold file:bg-brand-purple file:text-white hover:file:bg-brand-purpleHover transition cursor-pointer">
                        <p class="text-[9px] text-gray-400 mt-2 italic">Boleh pilih lebih dari satu fail baru untuk ditambah.</p>
                    </div>
                </div>

                <!-- Bank Section (Only shown if category is KOMUNITI) -->
                <div id="editBankSection" class="hidden space-y-6 pt-6 border-t border-dashed border-gray-200">
                    <h5 class="text-xs font-bold text-blue-600 uppercase tracking-widest flex items-center gap-2">
                        <i class="fas fa-university"></i> Kemaskini Maklumat Bank
                    </h5>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Nama Bank</label>
                            <input type="text" name="namaBank" id="editNamaBank" required
                                   class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl text-sm font-bold text-gray-800">
                        </div>
                        <div class="space-y-2">
                            <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Nombor Akaun</label>
                            <input type="text" name="nomorAkaun" id="editNomorAkaun" required
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')" pattern="[0-9]*" inputmode="numeric"
                                   class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl text-sm font-bold text-gray-800 tracking-wider">
                        </div>
                    </div>

                    <div class="space-y-2">
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Penyata Bank (PDF)</label>
                        <div id="editPenyataCurrentBox" class="hidden flex items-center gap-3 p-3 bg-green-50 rounded-2xl border border-green-100">
                            <div class="w-8 h-8 bg-green-100 text-green-600 rounded-lg flex items-center justify-center">
                                <i class="fas fa-file-invoice-dollar"></i>
                            </div>
                            <div class="flex-1 min-w-0 text-xs">
                                <p class="text-gray-400 uppercase font-bold text-[8px]">Fail Semasa</p>
                                <p id="editPenyataFileName" class="font-bold text-gray-800 truncate"></p>
                            </div>
                        </div>
                        <input type="file" name="penyataBank" accept="application/pdf"
                               class="block w-full text-xs text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-[10px] file:font-bold file:bg-blue-600 file:text-white hover:file:bg-blue-700 transition cursor-pointer bg-gray-50 rounded-2xl">
                        <p class="text-[9px] text-gray-400 mt-2 italic">Kosongkan jika tiada perubahan pada penyata bank.</p>
                    </div>
                </div>

                <div class="flex items-center justify-end gap-3 pt-6 border-t border-gray-100 shrink-0">
                    <button type="button" onclick="closeEditModal()" class="px-6 py-3 rounded-2xl bg-gray-100 text-gray-600 font-bold text-sm hover:bg-gray-200 transition">
                        Batal
                    </button>
                    <button type="submit" class="px-8 py-3 rounded-2xl bg-brand-purple hover:bg-brand-purpleHover text-white font-bold text-sm shadow-md transition flex items-center gap-2">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function initiateEdit(btn) {
        const data = {
            id: btn.getAttribute('data-id'),
            idBantuan: btn.getAttribute('data-idbantuan'),
            nama: btn.getAttribute('data-nama'),
            catatan: btn.getAttribute('data-catatan'),
            bank: btn.getAttribute('data-bank'),
            akaun: btn.getAttribute('data-akaun'),
            penyata: btn.getAttribute('data-penyata'),
            isRasmi: btn.getAttribute('data-israsmi') === 'true',
            docs: JSON.parse(btn.getAttribute('data-docs') || '[]')
        };
        openEditModal(data);
    }

    function openEditModal(data) {
        document.getElementById('editIdPermohonan').value = data.id;
        document.getElementById('editJenisBantuan').value = data.idBantuan;
        document.getElementById('editNamaBantuanDisplay').value = data.nama;
        
        let rawCatatan = data.catatan || '';
        let isLain = (data.idBantuan === '999' || data.idBantuan === '998');
        let keteranganClean = '';
        
        if (isLain) {
            let bersih = rawCatatan.replace('LAIN-LAIN: ', '');
            if (bersih.includes('|')) {
                let parts = bersih.split('|');
                keteranganClean = parts[1] ? parts[1].trim() : '';
            } else {
                keteranganClean = bersih;
            }
        } else {
            keteranganClean = rawCatatan;
        }
        document.getElementById('editCatatanDisplay').value = keteranganClean || 'Tiada maklumat.';
        
        const editDokumenList = document.getElementById('editDokumenList');
        editDokumenList.innerHTML = '';
        
        if (data.docs && data.docs.length > 0) {
            data.docs.forEach(doc => {
                const docDiv = document.createElement('div');
                docDiv.className = 'flex items-center gap-3 p-3 bg-white border border-gray-100 rounded-2xl shadow-sm hover:border-purple-200 transition';
                const cleanName = doc.nama.substring(doc.nama.indexOf('_') + 1);
                
                docDiv.innerHTML = `
                    <div class="w-8 h-8 bg-red-50 text-red-500 rounded-lg flex items-center justify-center">
                        <i class="fas fa-file-pdf"></i>
                    </div>
                    <div class="flex-1 min-w-0 text-xs">
                        <p class="text-gray-400 uppercase font-bold text-[8px]">Fail Terlampir</p>
                        <p class="font-bold text-gray-700 truncate" title="\${doc.nama}">\${cleanName}</p>
                    </div>
                    <div class="flex gap-2" onclick="event.stopPropagation()">
                        <a href="<%= request.getContextPath() %>/file/bantuan/\${encodeURIComponent(doc.nama)}" target="_blank" 
                           class="w-7 h-7 flex items-center justify-center bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition">
                            <i class="fas fa-eye text-[10px]"></i>
                        </a>
                        <a href="<%= request.getContextPath() %>/bantuan/deleteAttachment?idLampiran=\${doc.id}\&idPermohonan=\${data.id}" 
                           onclick="confirmDeleteAttachment(event, this.href)"
                           class="w-7 h-7 flex items-center justify-center bg-red-50 text-red-500 rounded-lg hover:bg-red-100 transition">
                            <i class="fas fa-trash text-[10px]"></i>
                        </a>
                    </div>
                `;
                editDokumenList.appendChild(docDiv);
            });
        } else {
            editDokumenList.innerHTML = '<p class="text-xs text-gray-400 italic p-4 bg-gray-50 rounded-2xl text-center border border-dashed">Tiada dokumen dilampirkan.</p>';
        }
        
        const bankSection = document.getElementById('editBankSection');
        if (bankSection) {
            if (!data.isRasmi) {
                bankSection.classList.remove('hidden');
                document.getElementById('editNamaBank').value = (data.bank && data.bank !== 'null') ? data.bank : '';
                document.getElementById('editNomorAkaun').value = (data.akaun && data.akaun !== 'null') ? data.akaun : '';
                document.getElementById('editOldPenyataBank').value = (data.penyata && data.penyata !== 'null') ? data.penyata : '';
                
                const penyataBox = document.getElementById('editPenyataCurrentBox');
                if (data.penyata && data.penyata !== 'null' && data.penyata !== '') {
                    penyataBox.classList.remove('hidden');
                    document.getElementById('editPenyataFileName').innerText = data.penyata;
                } else {
                    penyataBox.classList.add('hidden');
                }
            } else {
                bankSection.classList.add('hidden');
            }
        }
        
        document.getElementById('modalEditPermohonan').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function closeEditModal() {
        document.getElementById('modalEditPermohonan').classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

    function confirmDelete(event, url) {
        event.preventDefault();
        Swal.fire({
            title: 'Batal Permohonan?',
            text: "Adakah anda pasti mahu membatalkan permohonan ini? Tindakan ini tidak boleh diundurkan.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#EF4444',
            cancelButtonColor: '#6B7280',
            confirmButtonText: 'Ya, Batal',
            cancelButtonText: 'Batal'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }

    function confirmDeleteAttachment(event, url) {
        event.preventDefault();
        Swal.fire({
            title: 'Padam Lampiran?',
            text: "Adakah anda pasti mahu memadam fail dokumen sokongan ini?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#EF4444',
            cancelButtonColor: '#6B7280',
            confirmButtonText: 'Ya, Padam',
            cancelButtonText: 'Batal'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const wizardForm = document.getElementById('wizardForm');
        if (wizardForm) {
            wizardForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const form = this;
                Swal.fire({
                    title: 'Hantar Permohonan?',
                    text: "Adakah anda pasti maklumat yang diisi adalah betul dan lengkap?",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#4F46E5',
                    cancelButtonColor: '#6B7280',
                    confirmButtonText: 'Ya, Hantar',
                    cancelButtonText: 'Semak Semula'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });
        }

        const editForm = document.getElementById('editPermohonanForm');
        if (editForm) {
            editForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const form = this;
                Swal.fire({
                    title: 'Simpan Perubahan?',
                    text: "Adakah anda pasti mahu mengemaskini permohonan ini?",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#4F46E5',
                    cancelButtonColor: '#6B7280',
                    confirmButtonText: 'Ya, Simpan',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });
        }

        const urlParams = new URLSearchParams(window.location.search);
        const editId = urlParams.get('editId');
        if (editId) {
            const editBtn = document.querySelector('.edit-btn-' + editId);
            if (editBtn) {
                editBtn.click();
            }
        }
    });
</script>

<%@ include file="/views/common/footer.jsp" %>