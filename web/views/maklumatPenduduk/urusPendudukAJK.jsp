<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.AhliKeluarga" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-3xl font-extrabold text-gray-900 tracking-tight">Pengurusan Komuniti</h2>
            <p class="text-gray-500 mt-1 flex items-center gap-2">
                <span class="flex h-2 w-2 rounded-full bg-indigo-500"></span>
                Urus pendaftaran baharu dan kemaskini maklumat penduduk kampung.
            </p>
        </div>
    </div>

    <% 
        List<Pengguna> pendingList = (List<Pengguna>) request.getAttribute("pendingList");
        List<Pengguna> activeList = (List<Pengguna>) request.getAttribute("activeList");
        List<Pengguna> inactiveList = (List<Pengguna>) request.getAttribute("inactiveList");
        List<AhliKeluarga> familyOnlyList = (List<AhliKeluarga>) request.getAttribute("familyOnlyList");
        int totalMerged = ((activeList != null) ? activeList.size() : 0) + ((familyOnlyList != null) ? familyOnlyList.size() : 0);
        
        Pengguna currentAJK = (Pengguna) session.getAttribute("currentUser");
        int currentAJKId = (currentAJK != null) ? currentAJK.getId_pengguna() : 0;
    %>

    <% if (request.getParameter("status") != null) { %>
        <% 
            String status = request.getParameter("status");
            String alertClass = "bg-green-50 border-green-500 text-green-700";
            String icon = "fa-check-circle";
            String msg = "Tindakan telah berjaya direkodkan!";
            
            if (status.equals("updated")) msg = "Profil penduduk telah dikemaskini!";
            else if (status.equals("approved")) msg = "Pendaftaran penduduk telah diluluskan!";
            else if (status.equals("activated")) msg = "Akaun penduduk telah diaktifkan semula!";
            else if (status.equals("deactivated")) {
                alertClass = "bg-orange-50 border-orange-500 text-orange-700";
                icon = "fa-user-slash";
                msg = "Akaun penduduk telah dinyahaktifkan.";
            } else if (status.equals("rejected")) {
                alertClass = "bg-orange-50 border-orange-500 text-orange-700";
                icon = "fa-user-minus";
                msg = "Pendaftaran penduduk telah ditolak.";
            }
        %>
        <div class="<%= alertClass %> border-l-4 p-4 mb-6 rounded-r-xl shadow-sm flex items-center gap-3 animate-fade-in">
            <i class="fas <%= icon %>"></i>
            <p class="text-sm font-bold"><%= msg %></p>
        </div>
    <% } %>

    <div class="mb-6 border-b border-gray-200">
        <nav class="flex gap-6" aria-label="Tabs">
            <button onclick="switchTab('pending')" id="tab-pending" 
                    class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-brand-purple text-brand-purple">
                <i class="fas fa-user-plus"></i> Permohonan Baru
                <% if(pendingList != null && !pendingList.isEmpty()) { %>
                    <span class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= pendingList.size() %></span>
                <% } %>
            </button>
            <button onclick="switchTab('active')" id="tab-active" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-users"></i> Senarai Penduduk
            </button>
            <button onclick="switchTab('inactive')" id="tab-inactive" 
                    class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                <i class="fas fa-user-slash"></i> Tidak Aktif
                <% if(inactiveList != null && !inactiveList.isEmpty()) { %>
                    <span class="bg-gray-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full"><%= inactiveList.size() %></span>
                <% } %>
            </button>
        </nav>
    </div>

    <!-- Tab: Pending Applications -->
    <div id="content-pending" class="block animate-in fade-in slide-in-from-bottom-2 duration-300">
        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50/50 border-b border-gray-100">
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest w-16">No.</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Pemohon</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Alamat & Hubungan</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Dokumen</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest text-center">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% if (pendingList != null && !pendingList.isEmpty()) {
                            int countPending = 1;
                            for (Pengguna p : pendingList) { %>
                        <tr class="hover:bg-gray-50/50 transition-colors group">
                            <td class="p-5 text-sm text-gray-400 font-medium"><%= countPending++ %></td>
                            <td class="p-5">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center text-sm font-bold shadow-sm">
                                        <%= (p.getNama_penuh() != null && !p.getNama_penuh().isEmpty()) ? p.getNama_penuh().substring(0,1).toUpperCase() : "U" %>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold text-gray-800"><%= p.getNama_penuh() %></div>
                                        <div class="text-[11px] text-gray-400 font-medium mt-0.5">
                                            <i class="fas fa-id-card text-[10px]"></i> <%= p.getNombor_kp() %>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="p-5">
                                <div class="flex flex-col gap-1">
                                    <span class="text-xs font-bold text-gray-700 truncate max-w-[200px]"><%= p.getNama_jalan() %></span>
                                    <span class="text-[10px] text-gray-400 font-bold"><i class="fas fa-phone-alt text-[9px]"></i> <%= p.getNombor_telefon() %></span>
                                </div>
                            </td>
                            <td class="p-5">
                                <% if (p.getLampiran_pengesahan() != null && !p.getLampiran_pengesahan().isEmpty()) { %>
                                    <a href="<%= request.getContextPath() %>/file/pengguna/<%= p.getLampiran_pengesahan() %>" target="_blank" 
                                       class="px-3 py-1.5 bg-gray-100 text-gray-600 rounded-lg text-[10px] font-bold hover:bg-gray-200 transition-colors flex items-center gap-2 w-fit">
                                        <i class="fas fa-file-download text-xs text-brand-purple"></i> Lampiran
                                    </a>
                                <% } else { %>
                                    <span class="text-gray-300 italic text-[10px]">Tiada lampiran</span>
                                <% } %>
                            </td>
                            <td class="p-5">
                                <div class="flex items-center justify-center gap-2">
                                    <form action="<%= request.getContextPath() %>/penduduk/approve" method="post" class="m-0" onsubmit="return confirmAction(event, 'Sahkan Kelulusan?', 'Adakah anda pasti mahu meluluskan pendaftaran penduduk ini?', 'Ya, Luluskan!', '#10B981')">
                                        <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                                        <input type="hidden" name="idPengguna" value="<%= p.getId_pengguna() %>">
                                        <button type="submit" class="px-4 py-2 bg-green-50 text-green-600 hover:bg-green-600 hover:text-white rounded-xl text-[10px] font-black uppercase tracking-tight transition-all">
                                            Lulus
                                        </button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/penduduk/reject" method="post" class="m-0" onsubmit="return confirmAction(event, 'Tolak Pendaftaran?', 'Tindakan ini tidak boleh diubah. Adakah anda pasti?', 'Ya, Tolak', '#EF4444')">
                                        <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                                        <input type="hidden" name="idPengguna" value="<%= p.getId_pengguna() %>">
                                        <button type="submit" class="px-4 py-2 bg-red-50 text-red-600 hover:bg-red-600 hover:text-white rounded-xl text-[10px] font-black uppercase tracking-tight transition-all">
                                            Tolak
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="5" class="p-20 text-center">
                                <div class="flex flex-col items-center justify-center opacity-40">
                                    <div class="w-16 h-16 mb-4 rounded-full bg-gray-100 flex items-center justify-center">
                                        <i class="fas fa-inbox text-3xl text-gray-400"></i>
                                    </div>
                                    <p class="font-bold text-gray-500 italic">Tiada permohonan baharu buat masa ini.</p>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Tab: Active Residents -->
    <div id="content-active" class="hidden animate-in fade-in slide-in-from-bottom-2 duration-300">
        <div class="mb-4">
            <div class="relative group">
                <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400 group-focus-within:text-brand-purple transition-colors">
                    <i class="fas fa-search text-sm"></i>
                </span>
                <input type="text" id="searchActive" placeholder="Cari nama, No. KP atau alamat penduduk..." 
                       class="w-full pl-11 pr-4 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-4 focus:ring-purple-100 focus:border-brand-purple text-sm shadow-sm transition-all outline-none">
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableActive">
                    <thead>
                        <tr class="bg-gray-50/50 border-b border-gray-100">
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest w-16">No.</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Informasi Penduduk</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Alamat Kediaman</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% 
                        int countActive = 1;
                        if (activeList != null && !activeList.isEmpty()) {
                            for (Pengguna p : activeList) { 
                                // Serialize family info
                                StringBuilder sbFam = new StringBuilder();
                                if (p.getSenaraiAhliKeluarga() != null) {
                                    for (model.AhliKeluarga ak : p.getSenaraiAhliKeluarga()) {
                                        if (sbFam.length() > 0) sbFam.append(";;");
                                        sbFam.append(ak.getNama_penuh()).append("::")
                                             .append(ak.getHubungan()).append("::")
                                             .append(ak.getUmur()).append("::")
                                             .append((ak.getPekerjaan() != null) ? ak.getPekerjaan() : "Tiada").append("::")
                                             .append((ak.getPendapatan() != null) ? ak.getPendapatan() : "0.00").append("::")
                                             .append((ak.getPengesahan_pendapatan() != null) ? ak.getPengesahan_pendapatan() : "");
                                    }
                                }
                        %>
                        <tr class="hover:bg-gray-50 transition-all group cursor-pointer" 
                            onclick="showUserInfo(this)"
                            data-id="<%= p.getId_pengguna() %>"
                            data-nama="<%= p.getNama_penuh() %>"
                            data-kp="<%= p.getNombor_kp() %>"
                            data-tel="<%= p.getNombor_telefon() %>"
                            data-jalan="<%= p.getNama_jalan() %>"
                            data-bandar="<%= (p.getBandar() != null) ? p.getBandar() : "-" %>"
                            data-poskod="<%= (p.getNombor_poskod() != null) ? p.getNombor_poskod() : "-" %>"
                            data-negeri="<%= (p.getNegeri() != null) ? p.getNegeri() : "-" %>"
                            data-tarikh="<%= (p.getTarikh_lahir() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(p.getTarikh_lahir()) : "-" %>"
                            data-statusk="<%= (p.getStatus_keluarga() != null) ? p.getStatus_keluarga() : "-" %>"
                            data-lat="<%= p.getLatitude() %>"
                            data-lon="<%= p.getLongitude() %>"
                            data-jawatan="<%= (p.getNama_jawatan() != null) ? p.getNama_jawatan() : p.getNama_peranan() %>"
                            data-pekerjaan="<%= (p.getPekerjaan() != null) ? p.getPekerjaan() : "Tiada" %>"
                            data-pendapatan="<%= p.getPendapatan() %>"
                            data-pengesahan="<%= (p.getPengesahan_pendapatan() != null) ? p.getPengesahan_pendapatan() : "" %>"
                            data-email="<%= (p.getEmail() != null) ? p.getEmail() : "Tiada" %>"
                            data-foto="<%= (p.getFoto_profil() != null) ? p.getFoto_profil() : "default_avatar.png" %>"
                            data-family="<%= sbFam.toString() %>"
                            data-role="<%= p.getNama_peranan() %>"
                            data-statusval="1">
                            <td class="p-5 text-sm text-gray-400 font-medium"><%= countActive++ %></td>
                            <td class="p-5">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-2xl bg-gray-50 text-gray-400 flex items-center justify-center text-sm font-bold border border-gray-100 group-hover:bg-brand-purple group-hover:text-white transition-all">
                                        <%= (p.getNama_penuh() != null && !p.getNama_penuh().isEmpty()) ? p.getNama_penuh().substring(0,1).toUpperCase() : "U" %>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold text-gray-800 search-col"><%= p.getNama_penuh() %></div>
                                        <div class="text-[11px] text-gray-400 font-medium mt-0.5 search-col flex items-center gap-2">
                                            <i class="fas fa-id-card text-[10px]"></i> <%= p.getNombor_kp() %>
                                            <% if (!"Penduduk".equals(p.getNama_peranan())) { %>
                                                <span class="px-2 py-0.5 rounded-md bg-indigo-50 text-indigo-600 text-[9px] font-black uppercase tracking-tighter border border-indigo-100">
                                                    <%= p.getNama_peranan() %>
                                                </span>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="p-5">
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-gray-700 search-col"><%= p.getNama_jalan() %></span>
                                    <span class="text-[10px] text-gray-400"><%= p.getNombor_poskod() %> <%= p.getBandar() %></span>
                                </div>
                            </td>
                            <td class="p-5 text-center">
                                <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-[10px] font-black uppercase tracking-widest border border-green-100">
                                    Aktif
                                </span>
                            </td>
                        </tr>
                        <% } 
                        }
                        // --- PAPARAN AHLI KELUARGA YANG BELUM BERDAFTAR ---
                        if (familyOnlyList != null && !familyOnlyList.isEmpty()) {
                            for (AhliKeluarga fam : familyOnlyList) {
                        %>
                        <tr class="hover:bg-green-50/30 transition-all group" title="Ahli keluarga didaftarkan oleh <%= fam.getNamaWakil() %>">
                            <td class="p-5 text-sm text-gray-400 font-medium"><%= countActive++ %></td>
                            <td class="p-5">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-2xl bg-green-50 text-green-500 flex items-center justify-center text-sm font-bold border border-green-100">
                                        <i class="fas fa-user-friends text-xs"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold text-gray-800 search-col flex items-center gap-2">
                                            <%= fam.getNama_penuh() %>
                                            <span class="px-2 py-0.5 rounded-md bg-green-50 text-green-600 text-[9px] font-black uppercase tracking-tighter border border-green-200 whitespace-nowrap flex items-center gap-1">
                                                <i class="fas fa-link text-[7px]"></i> <%= fam.getHubungan() != null ? fam.getHubungan() : "Ahli Keluarga" %>
                                            </span>
                                        </div>
                                        <div class="text-[11px] text-gray-400 font-medium mt-0.5 search-col flex items-center gap-2">
                                            <% if (fam.getNombor_kp() != null && !fam.getNombor_kp().isEmpty()) { %>
                                                <i class="fas fa-id-card text-[10px]"></i> <%= fam.getNombor_kp() %>
                                            <% } else { %>
                                                <span class="text-gray-300 italic">Tiada KP</span>
                                            <% } %>
                                            <span class="px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-600 text-[9px] font-bold border border-emerald-100 whitespace-nowrap">
                                                <i class="fas fa-house-user text-[7px]"></i> Wakil: <%= fam.getNamaWakil() %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="p-5">
                                <div class="flex flex-col">
                                    <span class="text-xs text-gray-400 italic">Ikut wakil keluarga</span>
                                </div>
                            </td>
                            <td class="p-5 text-center">
                                <span class="px-3 py-1 rounded-full bg-green-50 text-green-600 text-[10px] font-black uppercase tracking-widest border border-green-100">
                                    Ahli Keluarga
                                </span>
                            </td>
                        </tr>
                        <% }
                        } 
                        // Hanya papar empty state jika kedua-dua senarai kosong
                        if ((activeList == null || activeList.isEmpty()) && (familyOnlyList == null || familyOnlyList.isEmpty())) { %>
                        <tr>
                            <td colspan="4" class="p-20 text-center text-gray-400">
                                <i class="fas fa-users-slash text-3xl mb-4 block opacity-30"></i>
                                <p class="font-bold italic">Tiada data penduduk aktif dijumpai.</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Tab: Inactive Residents -->
    <div id="content-inactive" class="hidden animate-in fade-in slide-in-from-bottom-2 duration-300">
        <div class="mb-4">
            <div class="relative group">
                <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400 group-focus-within:text-brand-purple transition-colors">
                    <i class="fas fa-search text-sm"></i>
                </span>
                <input type="text" id="searchInactive" placeholder="Cari nama, No. KP atau alamat penduduk tidak aktif..." 
                       class="w-full pl-11 pr-4 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-4 focus:ring-purple-100 focus:border-brand-purple text-sm shadow-sm transition-all outline-none">
            </div>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse" id="tableInactive">
                    <thead>
                        <tr class="bg-gray-50/50 border-b border-gray-100">
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest w-16">No.</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Informasi Penduduk</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest">Alamat Kediaman</th>
                            <th class="p-5 text-[11px] font-extrabold text-gray-400 uppercase tracking-widest text-center">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <% 
                        int countInactive = 1;
                        if (inactiveList != null && !inactiveList.isEmpty()) {
                            for (Pengguna p : inactiveList) { 
                                // Serialize family info
                                StringBuilder sbFam = new StringBuilder();
                                if (p.getSenaraiAhliKeluarga() != null) {
                                    for (model.AhliKeluarga ak : p.getSenaraiAhliKeluarga()) {
                                        if (sbFam.length() > 0) sbFam.append(";;");
                                        sbFam.append(ak.getNama_penuh()).append("::")
                                             .append(ak.getHubungan()).append("::")
                                             .append(ak.getUmur()).append("::")
                                             .append((ak.getPekerjaan() != null) ? ak.getPekerjaan() : "Tiada").append("::")
                                             .append((ak.getPendapatan() != null) ? ak.getPendapatan() : "0.00").append("::")
                                             .append((ak.getPengesahan_pendapatan() != null) ? ak.getPengesahan_pendapatan() : "");
                                    }
                                }
                        %>
                        <tr class="hover:bg-gray-50 transition-all group cursor-pointer" 
                            onclick="showUserInfo(this)"
                            data-id="<%= p.getId_pengguna() %>"
                            data-nama="<%= p.getNama_penuh() %>"
                            data-kp="<%= p.getNombor_kp() %>"
                            data-tel="<%= p.getNombor_telefon() %>"
                            data-jalan="<%= p.getNama_jalan() %>"
                            data-bandar="<%= (p.getBandar() != null) ? p.getBandar() : "-" %>"
                            data-poskod="<%= (p.getNombor_poskod() != null) ? p.getNombor_poskod() : "-" %>"
                            data-negeri="<%= (p.getNegeri() != null) ? p.getNegeri() : "-" %>"
                            data-tarikh="<%= (p.getTarikh_lahir() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(p.getTarikh_lahir()) : "-" %>"
                            data-statusk="<%= (p.getStatus_keluarga() != null) ? p.getStatus_keluarga() : "-" %>"
                            data-lat="<%= p.getLatitude() %>"
                            data-lon="<%= p.getLongitude() %>"
                            data-jawatan="<%= (p.getNama_jawatan() != null) ? p.getNama_jawatan() : p.getNama_peranan() %>"
                            data-pekerjaan="<%= (p.getPekerjaan() != null) ? p.getPekerjaan() : "Tiada" %>"
                            data-pendapatan="<%= p.getPendapatan() %>"
                            data-pengesahan="<%= (p.getPengesahan_pendapatan() != null) ? p.getPengesahan_pendapatan() : "" %>"
                            data-email="<%= (p.getEmail() != null) ? p.getEmail() : "Tiada" %>"
                            data-foto="<%= (p.getFoto_profil() != null) ? p.getFoto_profil() : "default_avatar.png" %>"
                            data-family="<%= sbFam.toString() %>"
                            data-role="<%= p.getNama_peranan() %>"
                            data-statusval="0">
                            <td class="p-5 text-sm text-gray-400 font-medium"><%= countInactive++ %></td>
                            <td class="p-5">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-2xl bg-gray-50 text-gray-400 flex items-center justify-center text-sm font-bold border border-gray-100 group-hover:bg-red-500 group-hover:text-white transition-all">
                                        <%= (p.getNama_penuh() != null && !p.getNama_penuh().isEmpty()) ? p.getNama_penuh().substring(0,1).toUpperCase() : "U" %>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold text-gray-800 search-col"><%= p.getNama_penuh() %></div>
                                        <div class="text-[11px] text-gray-400 font-medium mt-0.5 search-col flex items-center gap-2">
                                            <i class="fas fa-id-card text-[10px]"></i> <%= p.getNombor_kp() %>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td class="p-5">
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-gray-700 search-col"><%= p.getNama_jalan() %></span>
                                    <span class="text-[10px] text-gray-400"><%= p.getNombor_poskod() %> <%= p.getBandar() %></span>
                                </div>
                            </td>
                            <td class="p-5 text-center">
                                <span class="px-3 py-1 rounded-full bg-red-50 text-red-600 text-[10px] font-black uppercase tracking-widest border border-red-100">
                                    Tidak Aktif
                                </span>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="4" class="p-20 text-center text-gray-400">
                                <i class="fas fa-user-slash text-3xl mb-4 block opacity-30"></i>
                                <p class="font-bold italic">Tiada data penduduk tidak aktif.</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="text-lg font-black text-gray-900 tracking-tight">Ringkasan Statistik</h3>
        <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1">Status Penduduk Semasa</p>
    </div>

    <div class="space-y-4">
        <div class="bg-indigo-50/50 p-5 rounded-[2rem] border border-indigo-100/50 flex items-center gap-4 group hover:bg-indigo-50 transition-colors">
            <div class="w-12 h-12 bg-indigo-100 text-indigo-600 rounded-2xl flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                <i class="fas fa-users text-lg"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Jumlah Penduduk</p>
                <h4 class="font-black text-2xl text-gray-900"><%= totalMerged %></h4>
                <p class="text-[9px] text-gray-400 mt-0.5">
                    <span class="text-indigo-500 font-bold"><%= (activeList != null) ? activeList.size() : 0 %></span> Berdaftar
                    <% if (familyOnlyList != null && !familyOnlyList.isEmpty()) { %>
                        &middot; <span class="text-green-500 font-bold"><%= familyOnlyList.size() %></span> Ahli Keluarga
                    <% } %>
                </p>
            </div>
        </div>

        <div class="bg-rose-50/50 p-5 rounded-[2rem] border border-rose-100/50 flex items-center gap-4 group hover:bg-rose-50 transition-colors">
            <div class="w-12 h-12 bg-rose-100 text-rose-600 rounded-2xl flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                <i class="fas fa-user-clock text-lg"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Menunggu Kelulusan</p>
                <h4 class="font-black text-2xl text-gray-900"><%= (pendingList != null) ? pendingList.size() : 0 %></h4>
            </div>
        </div>

        <div class="bg-amber-50/50 p-5 rounded-[2rem] border border-amber-100/50 flex items-center gap-4 group hover:bg-amber-50 transition-colors">
            <div class="w-12 h-12 bg-amber-100 text-amber-600 rounded-2xl flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                <i class="fas fa-user-slash text-lg"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Akaun Nyahaktif</p>
                <h4 class="font-black text-2xl text-gray-900"><%= (inactiveList != null) ? inactiveList.size() : 0 %></h4>
            </div>
        </div>
    </div>

    <div class="mt-8 pt-8 border-t border-gray-100">
        <h4 class="text-[11px] font-black text-gray-400 uppercase tracking-widest mb-4">Nota Pengurusan</h4>
        <div class="bg-gray-50 rounded-3xl p-6 border border-gray-100 relative overflow-hidden group">
            <i class="fas fa-info-circle absolute -right-2 -bottom-2 text-gray-200 text-6xl opacity-20"></i>
            <p class="text-xs text-gray-500 leading-relaxed relative z-10 font-medium">
                Sila pastikan maklumat penduduk disemak dengan teliti sebelum meluluskan pendaftaran. Pastikan alamat rumah yang dilampirkan adalah sah. Penduduk yang ditolak perlu mendaftar semula dengan maklumat yang betul.
            </p>
        </div>
    </div>
</aside>

<!-- Modal Zoom Foto -->
<div id="modalZoom" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4" onclick="closeModal('modalZoom')">
    <div class="fixed inset-0 bg-black/90 backdrop-blur-xl"></div>
    <div class="relative max-w-4xl w-full flex flex-col items-center gap-4">
        <img id="zoomImage" src="" class="max-h-[80vh] w-auto rounded-3xl shadow-2xl border-4 border-white/10 transition-transform duration-300">
        <button class="bg-white/10 hover:bg-white/20 text-white px-8 py-3 rounded-2xl font-bold backdrop-blur-md border border-white/10 transition-all flex items-center gap-2">
            <i class="fas fa-times"></i> Tutup Pratinjau
        </button>
    </div>
</div>

<div id="modalInfoUser" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900/40 backdrop-blur-sm transition-opacity" onclick="closeModal('modalInfoUser')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative transform overflow-hidden rounded-[2.5rem] bg-white text-left shadow-2xl transition-all sm:w-full sm:max-w-3xl border border-white/20 flex flex-col max-h-[90vh]">
            <!-- Header Modal -->
            <div class="bg-gradient-to-r from-brand-purple to-brand-secondary px-8 py-10 text-white relative shrink-0">
                <div class="absolute top-0 right-0 p-8 opacity-10">
                    <i class="fas fa-user-circle text-8xl"></i>
                </div>
                <div class="flex justify-between items-start relative z-10">
                    <div class="flex items-center gap-6">
                        <div class="relative group/avatar cursor-pointer" onclick="zoomProfilePic()">
                            <img id="infoFoto" src="" class="w-24 h-24 rounded-3xl object-cover border-4 border-white/30 shadow-xl group-hover:scale-105 transition-transform">
                            <div class="absolute inset-0 flex items-center justify-center bg-black/20 opacity-0 group-hover:opacity-100 transition-opacity rounded-3xl">
                                <i class="fas fa-search-plus text-white"></i>
                            </div>
                        </div>
                        <div>
                            <span id="infoRoleBadge" class="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase border border-white/20">PENDUDUK</span>
                            <h3 class="text-3xl font-black mt-2 tracking-tight" id="infoNama">-</h3>
                            <p class="text-white/70 text-sm font-medium" id="infoJawatan">-</p>
                        </div>
                    </div>
                    <button onclick="closeModal('modalInfoUser')" class="w-10 h-10 flex items-center justify-center rounded-full bg-white/10 hover:bg-white/20 transition-all">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
            </div>

            <!-- Scrollable Content -->
            <div class="p-8 overflow-y-auto custom-scrollbar flex-1 bg-gray-50/30">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <!-- Maklumat Peribadi -->
                    <div class="space-y-4">
                        <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-id-card text-brand-purple"></i> Maklumat Peribadi
                        </h5>
                        <div class="space-y-3">
                            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">No. Kad Pengenalan</span>
                                <span id="infoKP" class="text-sm font-bold text-gray-800">-</span>
                            </div>
                            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">No. Telefon</span>
                                <div class="flex justify-between items-center">
                                    <span id="infoTel" class="text-sm font-bold text-gray-800">-</span>
                                    <a id="infoWA" href="#" target="_blank" class="text-[#25D366] text-xl hover:scale-110 transition-transform"><i class="fab fa-whatsapp"></i></a>
                                </div>
                            </div>
                            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">E-mel</span>
                                <span id="infoEmail" class="text-sm font-bold text-gray-800">-</span>
                            </div>
                        </div>
                    </div>

                    <!-- Status Sosio-Ekonomi -->
                    <div class="space-y-4">
                        <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-wallet text-indigo-400"></i> Sosio-Ekonomi
                        </h5>
                        <div class="space-y-3">
                            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">Status Keluarga</span>
                                <span id="infoStatusK" class="text-sm font-bold text-gray-800">-</span>
                            </div>
                            <div class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">Pekerjaan</span>
                                <span id="infoKerja" class="text-sm font-bold text-gray-800">-</span>
                            </div>
                            <div class="bg-indigo-50/50 p-4 rounded-2xl border border-indigo-100 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-indigo-400 font-bold uppercase">Pendapatan Bulanan</span>
                                <span id="infoGaji" class="text-sm font-black text-indigo-700">-</span>
                            </div>
                            <div id="infoBoxPengesahan" class="bg-blue-50/50 p-4 rounded-2xl border border-blue-100 shadow-sm flex flex-col gap-1 hidden">
                                <span class="text-[10px] text-blue-500 font-bold uppercase">Pengesahan Pendapatan</span>
                                <div class="flex justify-between items-center mt-1">
                                    <span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-xl bg-blue-100 border border-blue-200 text-blue-700 text-[10px] font-black uppercase">
                                        <i class="fas fa-file-invoice-dollar text-[10px]"></i>
                                        Ada Dokumen
                                    </span>
                                    <a id="infoLinkPengesahan" href="#" target="_blank" class="px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-[10px] font-bold transition-all flex items-center gap-1.5 shadow-md shadow-blue-500/10">
                                        <i class="fas fa-eye"></i> Lihat Fail
                                    </a>
                                </div>
                            </div>
                            <div id="infoBoxTiadaPengesahan" class="bg-gray-50/50 p-4 rounded-2xl border border-gray-150 shadow-sm flex flex-col gap-1">
                                <span class="text-[10px] text-gray-400 font-bold uppercase">Pengesahan Pendapatan</span>
                                <span class="inline-flex items-center gap-1 px-2.5 py-2 rounded-xl bg-gray-50 border border-gray-200 text-gray-400 text-[10px] font-bold mt-1 w-fit">
                                    <i class="fas fa-exclamation-circle text-xs"></i>
                                    Tiada Dokumen Sokongan
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Maklumat Ahli Keluarga -->
                    <div class="md:col-span-2 space-y-4">
                        <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-users text-green-500"></i> Maklumat Ahli Keluarga
                        </h5>
                        <div id="infoFamilyContainer" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <!-- Dynamic Content -->
                        </div>
                    </div>

                    <!-- Alamat Kediaman -->
                    <div class="md:col-span-2 space-y-4">
                        <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                            <i class="fas fa-map-marked-alt text-orange-400"></i> Alamat & Lokasi
                        </h5>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="bg-white p-5 rounded-3xl border border-gray-100 shadow-sm space-y-2">
                                <div class="flex flex-col">
                                    <span class="text-[10px] text-gray-400 font-bold uppercase">Alamat Penuh</span>
                                    <p id="infoAlamat" class="text-sm font-bold text-gray-800 leading-relaxed mt-1">-</p>
                                    <p id="infoPoskodBandar" class="text-xs text-gray-500 font-medium"></p>
                                    <p id="infoNegeri" class="text-xs text-gray-500 font-medium"></p>
                                </div>
                            </div>
                            <div class="bg-white p-4 rounded-3xl border border-gray-100 shadow-sm flex flex-col items-center justify-center gap-3">
                                <div id="mapInfoPreview" class="w-full h-32 bg-gray-100 rounded-2xl overflow-hidden relative">
                                    <div class="absolute inset-0 flex items-center justify-center text-gray-300">
                                        <i class="fas fa-map-marker-alt text-2xl"></i>
                                    </div>
                                </div>
                                <div class="flex gap-2 w-full">
                                    <button onclick="viewLocationFromModal()" class="flex-1 px-4 py-2 bg-blue-50 text-blue-600 rounded-xl text-xs font-bold hover:bg-blue-100 transition-all flex items-center justify-center gap-2">
                                        <i class="fas fa-search-location"></i> Preview Peta
                                    </button>
                                    <a id="infoNav" href="#" target="_blank" class="flex-1 px-4 py-2 bg-green-500 text-white rounded-xl text-xs font-bold hover:bg-green-600 transition-all flex items-center justify-center gap-2 shadow-lg shadow-green-100">
                                        <i class="fas fa-directions"></i> Navigasi
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Footer -->
            <div class="p-8 bg-gray-50 border-t border-gray-100 shrink-0 flex flex-col md:flex-row justify-between items-center gap-4">
                <button onclick="closeModal('modalInfoUser')" class="text-gray-400 hover:text-gray-600 font-bold text-sm transition order-2 md:order-1">Tutup Profil</button>
                <div class="flex gap-3 order-1 md:order-2 w-full md:w-auto items-center">
                    <!-- Deactivate Form -->
                    <form id="infoFormDeactivate" action="<%= request.getContextPath() %>/penduduk/deactivate" method="post" onsubmit="return confirmAction(event, 'Nyahaktif Akaun?', 'Adakah anda pasti untuk menyahaktifkan akaun penduduk ini?', 'Ya, Nyahaktifkan', '#EF4444')" class="m-0 hidden">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                        <input type="hidden" name="idPengguna" id="deactivateId">
                        <button type="submit" class="px-6 py-3 bg-red-50 text-red-500 border border-red-100 rounded-2xl font-bold text-[10px] hover:bg-red-500 hover:text-white transition-all flex items-center justify-center gap-2 uppercase tracking-wide">
                            <i class="fas fa-user-slash text-xs"></i> Nyahaktif Akaun
                        </button>
                    </form>
                    
                    <!-- Activate Form -->
                    <form id="infoFormActivate" action="<%= request.getContextPath() %>/penduduk/activate" method="post" onsubmit="return confirmAction(event, 'Aktifkan Akaun?', 'Adakah anda pasti untuk mengaktifkan akaun penduduk ini?', 'Ya, Aktifkan', '#10B981')" class="m-0 hidden">
                        <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                        <input type="hidden" name="idPengguna" id="activateId">
                        <button type="submit" class="px-6 py-3 bg-green-50 text-green-600 border border-green-100 rounded-2xl font-bold text-[10px] hover:bg-green-600 hover:text-white transition-all flex items-center justify-center gap-2 uppercase tracking-wide">
                            <i class="fas fa-user-check text-xs"></i> Aktifkan Akaun
                        </button>
                    </form>

                    <button id="infoBtnEdit" class="flex-1 md:flex-none px-10 py-3 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-lg shadow-purple-100 hover:bg-brand-purpleHover transition-all flex items-center justify-center gap-2">
                        <i class="fas fa-user-edit"></i> Kemaskini Profil
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="modalEdit" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900/40 backdrop-blur-sm transition-opacity" onclick="closeModal('modalEdit')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative transform overflow-hidden rounded-[2.5rem] bg-white text-left shadow-2xl transition-all sm:w-full sm:max-w-3xl border border-white/20 flex flex-col max-h-[90vh]">
            <form action="<%= request.getContextPath() %>/penduduk/update" method="post" class="flex flex-col h-full" onsubmit="return confirmAction(event, 'Simpan Perubahan?', 'Adakah anda mahu menyimpan maklumat profil yang dikemaskini?', 'Ya, Simpan', '<%= primaryColor %>')">
                <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                <input type="hidden" name="idPengguna" id="editId">
                
                <!-- Header Modal -->
                <div class="bg-gradient-to-r from-gray-800 to-gray-900 px-8 py-8 text-white relative shrink-0">
                    <div class="flex justify-between items-center relative z-10">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-2xl bg-white/10 flex items-center justify-center text-xl border border-white/20">
                                <i class="fas fa-user-edit"></i>
                            </div>
                            <div>
                                <h3 class="text-xl font-extrabold tracking-tight">Kemaskini Profil Penduduk</h3>
                                <p class="text-gray-400 text-xs mt-0.5">Sila pastikan maklumat adalah tepat.</p>
                            </div>
                        </div>
                        <button type="button" onclick="closeModal('modalEdit')" class="w-10 h-10 flex items-center justify-center rounded-full bg-white/5 hover:bg-white/10 transition-all">
                            <i class="fas fa-times text-lg"></i>
                        </button>
                    </div>
                </div>

                <!-- Scrollable Body -->
                <div class="p-8 overflow-y-auto custom-scrollbar flex-1 bg-gray-50/30">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Peribadi -->
                        <div class="space-y-4">
                            <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-id-card text-brand-purple"></i> Informasi Asas
                            </h5>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1">Nama Penuh (Kekal)</label>
                                    <input type="text" id="editNama" readonly class="w-full px-5 py-3 rounded-2xl bg-gray-100 border-none text-gray-400 text-sm font-semibold cursor-not-allowed">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1">No. Kad Pengenalan (Kekal)</label>
                                    <input type="text" id="editKP" readonly class="w-full px-5 py-3 rounded-2xl bg-gray-100 border-none text-gray-400 text-sm font-semibold cursor-not-allowed">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">No. Telefon</label>
                                    <input type="text" name="nomborTelefon" id="editTel" required class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-sm font-semibold transition-all">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1">Tarikh Lahir (Kekal)</label>
                                    <input type="text" id="editTarikhLahir" readonly class="w-full px-5 py-3 rounded-2xl bg-gray-100 border-none text-gray-400 text-sm font-semibold cursor-not-allowed">
                                </div>
                            </div>
                        </div>

                        <!-- Alamat -->
                        <div class="space-y-4">
                            <h5 class="text-[11px] font-black text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                <i class="fas fa-map-marked-alt text-indigo-400"></i> Kediaman & Status
                            </h5>
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">Status Keluarga</label>
                                    <select name="statusKeluarga" id="editStatusKeluarga" class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 text-sm font-semibold appearance-none focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple">
                                        <option value="Bujang">Bujang</option>
                                        <option value="Berkahwin">Berkahwin</option>
                                        <option value="Ibu Tunggal">Ibu Tunggal</option>
                                        <option value="Bapa Tunggal">Bapa Tunggal</option>
                                        <option value="Duda">Duda</option>
                                    </select>
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">Alamat Rumah (Jalan)</label>
                                    <input type="text" name="namaJalan" id="editJalan" required class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 text-sm font-semibold focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple">
                                </div>
                                <div class="grid grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">Bandar</label>
                                        <input type="text" name="bandar" id="editBandar" class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 text-sm font-semibold focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple">
                                    </div>
                                    <div>
                                        <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">Poskod</label>
                                        <input type="text" name="nomborPoskod" id="editPoskod" class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 text-sm font-semibold focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple">
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-2 px-1 text-brand-purple">Negeri</label>
                                    <input type="text" name="negeri" id="editNegeri" class="w-full px-5 py-3 rounded-2xl bg-white border border-gray-100 text-sm font-semibold focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="p-8 bg-gray-50 border-t border-gray-100 shrink-0 flex justify-between items-center">
                    <button type="button" onclick="closeModal('modalEdit')" class="text-gray-400 hover:text-gray-600 font-bold text-sm transition-colors">Batal</button>
                    <button type="submit" class="px-10 py-3 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-lg shadow-purple-100 hover:bg-purple-700 transition-all flex items-center gap-2">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
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
        <div class="bg-white rounded-[2.5rem] shadow-2xl w-full max-w-2xl overflow-hidden transform transition-all border border-white/20">
            <div class="bg-brand-purple p-8 text-white flex justify-between items-center relative overflow-hidden">
                <div class="absolute -right-4 -top-4 opacity-10">
                    <i class="fas fa-map-marker-alt text-8xl"></i>
                </div>
                <div class="relative z-10">
                    <h3 class="text-2xl font-black tracking-tight" id="locationTitle">Lokasi Kediaman</h3>
                    <p class="text-xs font-medium opacity-80 mt-1">Koordinat GPS penduduk.</p>
                </div>
                <button onclick="closeModal('modalLocation')" class="w-10 h-10 flex items-center justify-center rounded-full bg-white/10 hover:bg-white/20 transition-all relative z-10">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-4">
                <div id="mapView" style="height: 450px; border-radius: 2rem;" class="border-4 border-gray-50 shadow-inner"></div>
            </div>
            <div class="p-8 bg-gray-50 flex justify-end gap-3">
                <button onclick="closeModal('modalLocation')" class="px-8 py-3 bg-white text-gray-500 font-bold rounded-2xl border border-gray-200 hover:bg-gray-50 transition">
                    Tutup
                </button>
                <a id="locationNavBtn" href="#" target="_blank" class="px-10 py-3 bg-brand-purple text-white font-bold rounded-2xl shadow-xl shadow-purple-100 hover:bg-brand-purpleHover transition flex items-center gap-2">
                    <i class="fas fa-directions"></i> Buka Navigasi
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    let viewMap;
    let viewMarker;
    let currentUserData = {};

    function confirmAction(e, title, text, confirmButtonText, confirmButtonColor) {
        e.preventDefault();
        const form = e.target;
        
        Swal.fire({
            title: title,
            text: text,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: confirmButtonColor,
            cancelButtonColor: '#9CA3AF',
            confirmButtonText: confirmButtonText,
            cancelButtonText: 'Batal',
            border: 'none',
            borderRadius: '2rem',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                form.submit();
            }
        });
        return false;
    }

    function showUserInfo(row) {
        const d = row.dataset;
        currentUserData = d;
        
        const ctx = '<%= request.getContextPath() %>';
        const fotoUrl = (d.foto && d.foto !== 'null' && d.foto !== 'default_avatar.png') 
                        ? ctx + '/file/profil/' + d.foto 
                        : 'https://ui-avatars.com/api/?name=' + d.nama + '&background=6C5DD3&color=fff&size=128';
        
        document.getElementById('infoFoto').src = fotoUrl;
        document.getElementById('infoNama').innerText = d.nama;
        document.getElementById('infoRoleBadge').innerText = d.role;
        document.getElementById('infoJawatan').innerText = d.jawatan;
        document.getElementById('infoKP').innerText = d.kp;
        document.getElementById('infoTel').innerText = d.tel;
        document.getElementById('infoWA').href = "https://wa.me/6" + d.tel.replace(/\D/g, '');
        document.getElementById('infoEmail').innerText = d.email;
        document.getElementById('infoStatusK').innerText = d.statusk;
        document.getElementById('infoKerja').innerText = d.pekerjaan;
        
        const income = (d.pendapatan && d.pendapatan !== 'null') ? parseFloat(d.pendapatan) : 0;
        document.getElementById('infoGaji').innerText = "RM " + income.toLocaleString('ms-MY', {minimumFractionDigits: 2});
        
        // Handle main resident income verification document
        const pengesahan = (d.pengesahan && d.pengesahan !== 'null' && d.pengesahan !== '') ? d.pengesahan : '';
        const boxPengesahan = document.getElementById('infoBoxPengesahan');
        const boxTiadaPengesahan = document.getElementById('infoBoxTiadaPengesahan');
        const linkPengesahan = document.getElementById('infoLinkPengesahan');
        
        if (pengesahan) {
            boxPengesahan.classList.remove('hidden');
            boxTiadaPengesahan.classList.add('hidden');
            linkPengesahan.href = ctx + '/file/pendapatan/' + pengesahan;
        } else {
            boxPengesahan.classList.add('hidden');
            boxTiadaPengesahan.classList.remove('hidden');
        }
        
        document.getElementById('infoAlamat').innerText = d.jalan;
        document.getElementById('infoPoskodBandar').innerText = d.poskod + " " + d.bandar;
        document.getElementById('infoNegeri').innerText = d.negeri;
        
        // Handle Family Info
        const famContainer = document.getElementById('infoFamilyContainer');
        famContainer.innerHTML = '';
        if (d.family && d.family !== '') {
            const members = d.family.split(';;');
            members.forEach(m => {
                const parts = m.split('::');
                const div = document.createElement('div');
                div.className = 'bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex items-center justify-between gap-3 group/fam hover:border-green-200 transition-all';
                
                const docFile = parts[5];
                const docBadge = (docFile && docFile !== 'null' && docFile !== '')
                                 ? `<a href="\${ctx}/file/pendapatan/\${docFile}" target="_blank" 
                                       class="px-3 py-1.5 bg-blue-50 hover:bg-blue-100 text-blue-600 border border-blue-200 rounded-xl text-[9px] font-black uppercase tracking-tight transition-all flex items-center gap-1 shrink-0" 
                                       title="Lihat Pengesahan Pendapatan">
                                       <i class="fas fa-file-pdf"></i> Fail
                                    </a>`
                                 : `<span class="inline-flex items-center gap-1 px-2.5 py-1 rounded-xl bg-gray-50 border border-gray-200 text-gray-400 text-[9px] font-semibold shrink-0">
                                       <i class="fas fa-exclamation-circle text-[8px]"></i> Tiada
                                    </span>`;
                                    
                div.innerHTML = `
                    <div class="flex items-center gap-3 min-w-0">
                        <div class="w-8 h-8 rounded-lg bg-green-50 text-green-600 flex items-center justify-center text-xs font-bold shrink-0">
                            \${parts[1].charAt(0)}
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-bold text-gray-800 truncate">\${parts[0]}</p>
                            <p class="text-[10px] text-gray-400 font-medium uppercase truncate">\${parts[1]} • \${parts[2]} Thn</p>
                            <p class="text-[10px] text-gray-500 font-semibold truncate mt-0.5">\${parts[3]} • RM \${(parts[4] && !isNaN(parts[4])) ? parseFloat(parts[4]).toLocaleString('ms-MY', {minimumFractionDigits: 2}) : '0.00'}</p>
                        </div>
                    </div>
                    \${docBadge}
                `;
                famContainer.appendChild(div);
            });
        } else {
            famContainer.innerHTML = `
                <div class="md:col-span-2 text-center py-6 bg-gray-50/50 rounded-2xl border border-dashed border-gray-200">
                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest">Tiada Maklumat Ahli Keluarga</p>
                </div>
            `;
        }
             // Navigation Link
        const navUrl = `https://www.google.com/maps/search/?api=1&query=\${d.lat},\${d.lon}`;
        document.getElementById('infoNav').href = navUrl;

        // Toggle activation/deactivation forms based on user status
        const formDeactivate = document.getElementById('infoFormDeactivate');
        const formActivate = document.getElementById('infoFormActivate');
        const statusVal = d.statusval;
        const currentAJKId = <%= currentAJKId %>;

        if (parseInt(d.id) === currentAJKId) {
            // Cannot deactivate oneself
            formDeactivate.classList.add('hidden');
            formActivate.classList.add('hidden');
        } else if (d.role === 'Ketua Kampung') {
            // Cannot deactivate the Ketua Kampung
            formDeactivate.classList.add('hidden');
            formActivate.classList.add('hidden');
        } else if (statusVal === '1') {
            formDeactivate.classList.remove('hidden');
            formActivate.classList.add('hidden');
            document.getElementById('deactivateId').value = d.id;
        } else if (statusVal === '0') {
            formDeactivate.classList.add('hidden');
            formActivate.classList.remove('hidden');
            document.getElementById('activateId').value = d.id;
        } else {
            formDeactivate.classList.add('hidden');
            formActivate.classList.add('hidden');
        }

        document.getElementById('infoBtnEdit').onclick = () => {
            closeModal('modalInfoUser');
            openEditModal(d.id, d.nama, d.kp, d.tel, d.jalan, d.bandar, d.poskod, d.negeri, d.tarikh, d.statusk);
        };

        openModal('modalInfoUser');
    }

    function zoomProfilePic() {
        const src = document.getElementById('infoFoto').src;
        document.getElementById('zoomImage').src = src;
        openModal('modalZoom');
    }

    function viewLocationFromModal() {
        if (!currentUserData.lat || currentUserData.lat === 'null') {
            alert('Koordinat GPS tidak tersedia untuk penduduk ini.');
            return;
        }
        viewLocation(currentUserData.nama, currentUserData.lat, currentUserData.lon);
    }

    function viewLocation(nama, lat, lon) {
        document.getElementById('locationTitle').innerText = "Lokasi: " + nama;
        document.getElementById('locationNavBtn').href = `https://www.google.com/maps/search/?api=1&query=\${lat},\${lon}`;
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
            btn.classList.remove('border-brand-purple', 'text-brand-purple');
            btn.classList.add('border-transparent', 'text-gray-500');
        });
        document.getElementById('tab-' + tabName).classList.add('border-brand-purple', 'text-brand-purple');
        document.getElementById('tab-' + tabName).classList.remove('border-transparent', 'text-gray-500');

        document.getElementById('content-pending').classList.add('hidden');
        document.getElementById('content-active').classList.add('hidden');
        document.getElementById('content-inactive').classList.add('hidden');
        document.getElementById('content-' + tabName).classList.remove('hidden');
    }

    document.getElementById('searchActive').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#tableActive tbody tr');
        rows.forEach(row => {
            let text = "";
            row.querySelectorAll('.search-col').forEach(col => text += col.innerText.toLowerCase() + " ");
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });

    if (document.getElementById('searchInactive')) {
        document.getElementById('searchInactive').addEventListener('keyup', function() {
            let val = this.value.toLowerCase();
            let rows = document.querySelectorAll('#tableInactive tbody tr');
            rows.forEach(row => {
                let text = "";
                row.querySelectorAll('.search-col').forEach(col => text += col.innerText.toLowerCase() + " ");
                row.style.display = text.includes(val) ? '' : 'none';
            });
        });
    }

    function openEditModal(id, nama, kp, tel, jalan, bandar, poskod, negeri, tarikh, statusKeluarga) {
        document.getElementById('editId').value = id;
        document.getElementById('editNama').value = nama;
        document.getElementById('editKP').value = kp;
        document.getElementById('editTel').value = tel;
        document.getElementById('editJalan').value = jalan;
        document.getElementById('editBandar').value = (bandar === 'null' || bandar === '-' || bandar === '') ? '' : bandar;
        document.getElementById('editPoskod').value = (poskod === 'null' || poskod === '-' || poskod === '') ? '' : poskod;
        document.getElementById('editNegeri').value = (negeri === 'null' || negeri === '-' || negeri === '') ? '' : negeri;
        document.getElementById('editTarikhLahir').value = (tarikh === 'null' || tarikh === '-') ? '' : tarikh;
        document.getElementById('editStatusKeluarga').value = (statusKeluarga === 'null' || statusKeluarga === '-') ? 'Bujang' : statusKeluarga;
        
        openModal('modalEdit');
    }
</script>

<%@ include file="/views/common/footer.jsp" %>