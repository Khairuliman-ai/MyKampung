<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="java.util.ArrayList" %>
            <%@ page import="java.util.Collections" %>
                <%@ page import="java.text.SimpleDateFormat" %>
                    <%@ page import="model.PermohonanBantuan" %>
                        <%@ page import="java.net.URLEncoder" %>

                            <%@ include file="/views/common/header.jsp" %>
                                <%@ include file="/views/common/navbar.jsp" %>

                                    <div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

                                        <header
                                            class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
                                            <div>
                                                <h2 class="text-2xl font-bold text-gray-800">Pengesahan Ketua Kampung
                                                </h2>
                                                <p class="text-gray-500 text-sm">Semak dan luluskan permohonan yang
                                                    telah disahkan oleh AJK.</p>
                                            </div>

                                            <div class="flex flex-wrap items-center gap-3">
                                                <a href="<%= request.getContextPath() %>/bantuan/config"
                                                    class="inline-flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-white border border-gray-200 text-gray-700 hover:text-brand-purple hover:border-purple-200 shadow-sm transition-all text-xs font-bold">
                                                    <i class="fas fa-sliders-h text-brand-purple"></i>
                                                    Konfigurasi Kelayakan
                                                </a>

                                                <!-- Professional Filter Bar -->
                                                <div
                                                    class="bg-white p-3 rounded-2xl shadow-sm border border-gray-100 flex flex-wrap items-center gap-3">
                                                    <div class="relative">
                                                        <i
                                                            class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
                                                        <input type="text" id="searchPemohon" onkeyup="filterData()"
                                                            placeholder="Cari pemohon/ID..."
                                                            class="pl-9 pr-4 py-2 bg-gray-50 border-none rounded-xl text-xs focus:ring-2 focus:ring-brand-purple w-48">
                                                    </div>

                                                    <select id="filterKategori" onchange="filterData()"
                                                        class="bg-gray-50 border-none rounded-xl text-xs focus:ring-2 focus:ring-brand-purple py-2 px-3 pr-8">
                                                        <option value="ALL">Semua Kategori</option>
                                                        <option value="RASMI">Bantuan Rasmi</option>
                                                        <option value="KOMUNITI">Bantuan Komuniti</option>
                                                    </select>

                                                    <div
                                                        class="flex items-center gap-2 bg-gray-50 px-3 py-1.5 rounded-xl border border-transparent focus-within:border-brand-purple/30 transition">
                                                        <i class="fas fa-calendar-alt text-gray-400 text-[10px]"></i>
                                                        <input type="date" id="filterDateStart" onchange="filterData()"
                                                            class="bg-transparent border-none p-0 text-[10px] focus:ring-0">
                                                        <span class="text-gray-300">-</span>
                                                        <input type="date" id="filterDateEnd" onchange="filterData()"
                                                            class="bg-transparent border-none p-0 text-[10px] focus:ring-0">
                                                    </div>

                                                    <button onclick="resetFilters()"
                                                        class="p-2 text-gray-400 hover:text-red-500 transition tooltip"
                                                        title="Reset Tapisan">
                                                        <i class="fas fa-sync-alt text-xs"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </header>

                                        <% if (request.getParameter("msg") !=null) { %>
                                            <div
                                                class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                                                <i class="fas fa-check-circle text-lg"></i>
                                                <div>
                                                    <span class="font-bold">Berjaya!</span> Tindakan telah direkodkan.
                                                </div>
                                                <button onclick="this.parentElement.remove()"
                                                    class="ml-auto text-green-500 hover:text-green-700"><i
                                                        class="fas fa-times"></i></button>
                                            </div>
                                            <% } %>

                                                <% if (request.getParameter("error") !=null) { %>
                                                    <div
                                                        class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                                                        <i class="fas fa-exclamation-circle text-lg"></i>
                                                        <div>
                                                            <% String err=request.getParameter("error"); if(err !=null)
                                                                err=err.replace("&", "&amp;" ).replace("<", "&lt;"
                                                                ).replace(">", "&gt;").replace("\"",
                                                                "&quot;").replace("'", "&#39;");
                                                                %>
                                                                <span class="font-bold">Ralat!</span>
                                                                <%= (err !=null ? err : "" ) %>
                                                        </div>
                                                        <button onclick="this.parentElement.remove()"
                                                            class="ml-auto text-red-500 hover:text-red-700"><i
                                                                class="fas fa-times"></i></button>
                                                    </div>
                                                    <% } %>

                                                        <%
                                                            // Logic Pengasingan Data
                                                            List<PermohonanBantuan> list = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
                                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                                                            SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");
                                                            List<PermohonanBantuan> listPending = new ArrayList<>();
                                                            // Status 3 (Dari AJK)
                                                            List<PermohonanBantuan> listSejarah = new ArrayList<>(); // Status 1 (Lulus) atau 4 (Tolak)

                                                                                if(list != null) {
                                                                                for(PermohonanBantuan pb : list) {
                                                                                if("MENUNGGU_KETUA".equalsIgnoreCase(pb.getStatus()))
                                                                                {
                                                                                listPending.add(pb);
                                                                                } else
                                                                                if("LULUS".equalsIgnoreCase(pb.getStatus())
                                                                                ||
                                                                                "DITOLAK".equalsIgnoreCase(pb.getStatus()))
                                                                                {
                                                                                listSejarah.add(pb);
                                                                                }
                                                                                }
                                                                                }
                                                                                %>

                                                                                <div
                                                                                    class="mb-8 border-b border-gray-200">
                                                                                    <nav class="flex gap-8"
                                                                                        aria-label="Tabs">
                                                                                        <button
                                                                                            onclick="switchTab('pending')"
                                                                                            id="tab-pending"
                                                                                            class="py-4 px-1 border-b-2 font-bold text-sm flex items-center gap-2 transition-colors border-brand-purple text-brand-purple">
                                                                                            <i
                                                                                                class="fas fa-hourglass-half"></i>
                                                                                            Menunggu Tindakan
                                                                                            <% if (listPending !=null &&
                                                                                                !listPending.isEmpty())
                                                                                                { %>
                                                                                                <span
                                                                                                    class="bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full">
                                                                                                    <%= listPending.size()
                                                                                                        %>
                                                                                                </span>
                                                                                                <% } %>
                                                                                        </button>
                                                                                        <button
                                                                                            onclick="switchTab('sejarah')"
                                                                                            id="tab-sejarah"
                                                                                            class="py-4 px-1 border-b-2 border-transparent font-medium text-sm text-gray-500 hover:text-gray-700 hover:border-gray-300 flex items-center gap-2 transition-colors">
                                                                                            <i
                                                                                                class="fas fa-history"></i>
                                                                                            Sejarah Keputusan
                                                                                        </button>
                                                                                    </nav>
                                                                                </div>

                                                                                <div id="content-pending" class="block">
                                                                                    <h3
                                                                                        class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
                                                                                        <div
                                                                                            class="w-2 h-6 bg-orange-500 rounded-full">
                                                                                        </div>
                                                                                        Senarai Permohonan
                                                                                    </h3>

                                                                                    <div
                                                                                        class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
                                                                                        <div class="overflow-x-auto">
                                                                                            <table
                                                                                                class="w-full text-left border-collapse"
                                                                                                id="tablePending">
                                                                                                <thead>
                                                                                                    <tr
                                                                                                        class="bg-gray-50 border-b border-gray-100">
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-16">
                                                                                                            No.</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Tarikh</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Pemohon</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Bantuan</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">
                                                                                                            Kategori
                                                                                                        </th>
                                                                                                    </tr>
                                                                                                </thead>
                                                                                                <tbody
                                                                                                    class="divide-y divide-gray-100">
                                                                                                    <% if(listPending
                                                                                                        !=null &&
                                                                                                        !listPending.isEmpty())
                                                                                                        { int noP=1;
                                                                                                        for(PermohonanBantuan
                                                                                                        pb :
                                                                                                        listPending) {
                                                                                                        String
                                                                                                        displayDate=(pb.getDibuat_pada()
                                                                                                        !=null) ?
                                                                                                        sdf.format(pb.getDibuat_pada())
                                                                                                        : "-" ; String
                                                                                                        namaBantuan=pb.getNama_bantuan();
                                                                                                        StringBuilder
                                                                                                        sbDocs=new
                                                                                                        StringBuilder();
                                                                                                        if(pb.getSenaraiLampiran()
                                                                                                        !=null) {
                                                                                                        for(model.BantuanLampiran
                                                                                                        bl :
                                                                                                        pb.getSenaraiLampiran())
                                                                                                        {
                                                                                                        if(sbDocs.length()>
                                                                                                        0)
                                                                                                        sbDocs.append(",");
                                                                                                        sbDocs.append(URLEncoder.encode(bl.getNama_fail(),
                                                                                                        "UTF-8"));
                                                                                                        }
                                                                                                        }
                                                                                                        String jsDokumen
                                                                                                        =
                                                                                                        sbDocs.toString();
                                                                                                        %>
                                                                                                        <tr class="hover:bg-gray-50/50 transition data-row-filter cursor-pointer group"
                                                                                                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>"
                                                                                                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                                                                                                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>"
                                                                                                            data-id="<%= pb.getId_permohonan() %>"
                                                                                                            data-bantuan="<%= (pb.getNama_bantuan() != null ? pb.getNama_bantuan().replace("\"", "&quot;") : "Lain-lain") %>"
                                                                                                            data-pemohon="
                                                                                                            <%= pb.getNama_penuh().replace("\"", "&quot;"
                                                                                                                ) %>"
                                                                                                                data-ket="
                                                                                                                <%= (pb.getCatatan_pemohon()
                                                                                                                    !=null
                                                                                                                    ?
                                                                                                                    pb.getCatatan_pemohon().replace("\"", "&quot;"
                                                                                                                    )
                                                                                                                    : ""
                                                                                                                    ) %>
                                                                                                                    "
                                                                                                                    data-dok="
                                                                                                                    <%= jsDokumen
                                                                                                                        %>
                                                                                                                        "
                                                                                                                        data-bank="
                                                                                                                        <%= (pb.getNama_bank()
                                                                                                                            !=null
                                                                                                                            ?
                                                                                                                            pb.getNama_bank().replace("\"", "&quot;"
                                                                                                                            )
                                                                                                                            : ""
                                                                                                                            )
                                                                                                                            %>
                                                                                                                            "
                                                                                                                            data-akaun="
                                                                                                                            <%= (pb.getNombor_akaun()
                                                                                                                                !=null
                                                                                                                                ?
                                                                                                                                pb.getNombor_akaun().replace("\"", "&quot;"
                                                                                                                                )
                                                                                                                                : ""
                                                                                                                                )
                                                                                                                                %>
                                                                                                                                "
                                                                                                                                data-penbank="
                                                                                                                                <%= (pb.getPenyata_bank()
                                                                                                                                    !=null
                                                                                                                                    ?
                                                                                                                                    pb.getPenyata_bank()
                                                                                                                                    : ""
                                                                                                                                    )
                                                                                                                                    %>
                                                                                                                                    "
                                                                                                                                    data-showaction="true"
                                                                                                                                    data-ic="
                                                                                                                                    <%= (pb.getNombor_kp()
                                                                                                                                        !=null
                                                                                                                                        ?
                                                                                                                                        pb.getNombor_kp()
                                                                                                                                        : ""
                                                                                                                                        )
                                                                                                                                        %>
                                                                                                                                        "
                                                                                                                                        data-phone="
                                                                                                                                        <%= (pb.getNombor_telefon()
                                                                                                                                            !=null
                                                                                                                                            ?
                                                                                                                                            pb.getNombor_telefon()
                                                                                                                                            : ""
                                                                                                                                            )
                                                                                                                                            %>
                                                                                                                                            "
                                                                                                                                            data-statusk="
                                                                                                                                            <%= (pb.getStatus_keluarga()
                                                                                                                                                !=null
                                                                                                                                                ?
                                                                                                                                                pb.getStatus_keluarga()
                                                                                                                                                : ""
                                                                                                                                                )
                                                                                                                                                %>
                                                                                                                                                "
                                                                                                                                                data-kerja="
                                                                                                                                                <%= (pb.getPekerjaan()
                                                                                                                                                    !=null
                                                                                                                                                    ?
                                                                                                                                                    pb.getPekerjaan()
                                                                                                                                                    : ""
                                                                                                                                                    )
                                                                                                                                                    %>
                                                                                                                                                    "
                                                                                                                                                    data-gaji="
                                                                                                                                                    <%= pb.getPendapatanFormatted()
                                                                                                                                                        %>
                                                                                                                                                        "
                                                                                                                                                        data-kategori="
                                                                                                                                                        <%= pb.getJenis_bantuan()
                                                                                                                                                            %>
                                                                                                                                                            "
                                                                                                                                                            data-ulasanajk="
                                                                                                                                                            <%= (pb.getCatatan_pentadbir()
                                                                                                                                                                !=null
                                                                                                                                                                ?
                                                                                                                                                                pb.getCatatan_pentadbir().replace("\"", "&quot;"
                                                                                                                                                                )
                                                                                                                                                                : "Tiada ulasan."
                                                                                                                                                                )
                                                                                                                                                                %>
                                                                                                                                                                "
                                                                                                                                                                data-score="
                                                                                                                                                                <%= pb.getEligibilityScore()
                                                                                                                                                                    !=null
                                                                                                                                                                    ?
                                                                                                                                                                    pb.getEligibilityScore()
                                                                                                                                                                    :
                                                                                                                                                                    0.0
                                                                                                                                                                    %>
                                                                                                                                                                    "
                                                                                                                                                                    data-tier="
                                                                                                                                                                    <%= pb.getEligibilityTier()
                                                                                                                                                                        !=null
                                                                                                                                                                        ?
                                                                                                                                                                        pb.getEligibilityTier()
                                                                                                                                                                        : ""
                                                                                                                                                                        %>
                                                                                                                                                                        "
                                                                                                                                                                        data-flags="
                                                                                                                                                                        <%= pb.getEligibilityFlags()
                                                                                                                                                                            !=null
                                                                                                                                                                            ?
                                                                                                                                                                            String.join(",",
                                                                                                                                                                            pb.getEligibilityFlags())
                                                                                                                                                                            : ""
                                                                                                                                                                            %>
                                                                                                                                                                            "
                                                                                                                                                                            onclick="viewDetail(this)">
                                                                                                                                                                            <td
                                                                                                                                                                                class="p-4 text-sm text-gray-400 font-medium">
                                                                                                                                                                                <%= noP++
                                                                                                                                                                                    %>
                                                                                                                                                                            </td>
                                                                                                                                                                            <td
                                                                                                                                                                                class="p-4 text-sm text-gray-500 whitespace-nowrap">
                                                                                                                                                                                <%= displayDate
                                                                                                                                                                                    %>
                                                                                                                                                                            </td>
                                                                                                                                                                            <td
                                                                                                                                                                                class="p-4 text-sm font-bold text-gray-800 group-hover:text-brand-purple transition-colors">
                                                                                                                                                                                <%= pb.getNama_penuh()
                                                                                                                                                                                    %>
                                                                                                                                                                            </td>
                                                                                                                                                                            <td
                                                                                                                                                                                class="p-4 text-sm text-gray-600">
                                                                                                                                                                                <%= namaBantuan
                                                                                                                                                                                    %>
                                                                                                                                                                            </td>
                                                                                                                                                                            <td
                                                                                                                                                                                class="p-4 text-center">
                                                                                                                                                                                <% if
                                                                                                                                                                                    ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan()))
                                                                                                                                                                                    {
                                                                                                                                                                                    %>
                                                                                                                                                                                    <span
                                                                                                                                                                                        class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                                                                                                                                                                                    <% } else
                                                                                                                                                                                        {
                                                                                                                                                                                        %>
                                                                                                                                                                                        <span
                                                                                                                                                                                            class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                                                                                                                                                                                        <% }
                                                                                                                                                                                            %>
                                                                                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <% } } else { %>
                                                                                                            <tr>
                                                                                                                <td colspan="5"
                                                                                                                    class="p-8 text-center text-gray-400">
                                                                                                                    <i
                                                                                                                        class="fas fa-check-double text-3xl mb-2 block opacity-50"></i>Tiada
                                                                                                                    permohonan
                                                                                                                    tertunggak.
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <% } %>
                                                                                                </tbody>
                                                                                            </table>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>

                                                                                <!-- TAB 2: SEJARAH -->
                                                                                <div id="content-sejarah"
                                                                                    class="hidden">
                                                                                    <h3
                                                                                        class="font-bold text-lg text-gray-800 mb-4 flex items-center gap-2">
                                                                                        <div
                                                                                            class="w-2 h-6 bg-gray-400 rounded-full">
                                                                                        </div>
                                                                                        Rekod Sejarah Keputusan <span
                                                                                            class="bg-gray-100 text-gray-400 text-xs px-2 py-1 rounded-lg ml-2 font-normal">
                                                                                            <%= listSejarah.size() %>
                                                                                        </span>
                                                                                    </h3>

                                                                                    <div
                                                                                        class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden">
                                                                                        <div class="overflow-x-auto">
                                                                                            <table
                                                                                                class="w-full text-left border-collapse"
                                                                                                id="tableSejarah">
                                                                                                <thead>
                                                                                                    <tr
                                                                                                        class="bg-gray-50 border-b border-gray-100">
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider w-16">
                                                                                                            No.</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Tarikh</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Pemohon</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                                                                            Bantuan</th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">
                                                                                                            Kategori
                                                                                                        </th>
                                                                                                        <th
                                                                                                            class="p-4 text-xs font-bold text-gray-500 uppercase tracking-wider text-center">
                                                                                                            Keputusan
                                                                                                        </th>
                                                                                                    </tr>
                                                                                                </thead>
                                                                                                <tbody
                                                                                                    class="divide-y divide-gray-100">
                                                                                                    <% if(!listSejarah.isEmpty())
                                                                                                        { int noS=1;
                                                                                                        for(PermohonanBantuan
                                                                                                        pb :
                                                                                                        listSejarah) {
                                                                                                        String
                                                                                                        displayDate=(pb.getDibuat_pada()
                                                                                                        !=null) ?
                                                                                                        sdf.format(pb.getDibuat_pada())
                                                                                                        : "-" ; String
                                                                                                        namaBantuan=pb.getNama_bantuan();
                                                                                                        StringBuilder
                                                                                                        sbDocsH=new
                                                                                                        StringBuilder();
                                                                                                        StringBuilder
                                                                                                        sbDocsAdminH=new
                                                                                                        StringBuilder();
                                                                                                        if(pb.getSenaraiLampiran()
                                                                                                        !=null) {
                                                                                                        for(model.BantuanLampiran
                                                                                                        bl :
                                                                                                        pb.getSenaraiLampiran())
                                                                                                        {
                                                                                                        if("PEMOHON".equalsIgnoreCase(bl.getJenis_lampiran()))
                                                                                                        {
                                                                                                        if(sbDocsH.length()>
                                                                                                        0)
                                                                                                        sbDocsH.append(",");
                                                                                                        sbDocsH.append(URLEncoder.encode(bl.getNama_fail(),
                                                                                                        "UTF-8"));
                                                                                                        } else
                                                                                                        if("PENTADBIR".equalsIgnoreCase(bl.getJenis_lampiran()))
                                                                                                        {
                                                                                                        if(sbDocsAdminH.length()
                                                                                                        > 0)
                                                                                                        sbDocsAdminH.append(",");
                                                                                                        sbDocsAdminH.append(URLEncoder.encode(bl.getNama_fail(),
                                                                                                        "UTF-8"));
                                                                                                        }
                                                                                                        }
                                                                                                        }
                                                                                                        String
                                                                                                        jsDokumenH =
                                                                                                        sbDocsH.toString();
                                                                                                        String
                                                                                                        jsDokumenAdminH
                                                                                                        =
                                                                                                        sbDocsAdminH.toString();
                                                                                                        %>
                                                                                                        <tr class="hover:bg-gray-50/50 transition data-row-filter cursor-pointer group"
                                                                                                            data-search="<%= pb.getNama_penuh() %> #<%= pb.getId_permohonan() %>"
                                                                                                            data-category="<%= (pb.getJenis_bantuan() != null) ? pb.getJenis_bantuan() : "" %>"
                                                                                                            data-date="<%= (pb.getDibuat_pada() != null) ? sdfFull.format(pb.getDibuat_pada()) : "" %>"
                                                                                                            data-id="<%= pb.getId_permohonan() %>"
                                                                                                            data-bantuan="<%= (pb.getNama_bantuan() != null ? pb.getNama_bantuan().replace("\"", "&quot;") : "Lain-lain") %>"
                                                                                                            data-pemohon="
                                                                                                            <%= pb.getNama_penuh().replace("\"", "&quot;"
                                                                                                                ) %>"
                                                                                                                data-ket="
                                                                                                                <%= (pb.getCatatan_pemohon()
                                                                                                                    !=null
                                                                                                                    ?
                                                                                                                    pb.getCatatan_pemohon().replace("\"", "&quot;"
                                                                                                                    )
                                                                                                                    : ""
                                                                                                                    ) %>
                                                                                                                    "
                                                                                                                    data-dok="
                                                                                                                    <%= jsDokumenH
                                                                                                                        %>
                                                                                                                        "
                                                                                                                        data-bank="
                                                                                                                        <%= (pb.getNama_bank()
                                                                                                                            !=null
                                                                                                                            ?
                                                                                                                            pb.getNama_bank().replace("\"", "&quot;"
                                                                                                                            )
                                                                                                                            : ""
                                                                                                                            )
                                                                                                                            %>
                                                                                                                            "
                                                                                                                            data-akaun="
                                                                                                                            <%= (pb.getNombor_akaun()
                                                                                                                                !=null
                                                                                                                                ?
                                                                                                                                pb.getNombor_akaun().replace("\"", "&quot;"
                                                                                                                                )
                                                                                                                                : ""
                                                                                                                                )
                                                                                                                                %>
                                                                                                                                "
                                                                                                                                data-penbank="
                                                                                                                                <%= (pb.getPenyata_bank()
                                                                                                                                    !=null
                                                                                                                                    ?
                                                                                                                                    pb.getPenyata_bank()
                                                                                                                                    : ""
                                                                                                                                    )
                                                                                                                                    %>
                                                                                                                                    "
                                                                                                                                    data-showaction="false"
                                                                                                                                    data-ic="
                                                                                                                                    <%= (pb.getNombor_kp()
                                                                                                                                        !=null
                                                                                                                                        ?
                                                                                                                                        pb.getNombor_kp()
                                                                                                                                        : ""
                                                                                                                                        )
                                                                                                                                        %>
                                                                                                                                        "
                                                                                                                                        data-phone="
                                                                                                                                        <%= (pb.getNombor_telefon()
                                                                                                                                            !=null
                                                                                                                                            ?
                                                                                                                                            pb.getNombor_telefon()
                                                                                                                                            : ""
                                                                                                                                            )
                                                                                                                                            %>
                                                                                                                                            "
                                                                                                                                            data-statusk="
                                                                                                                                            <%= (pb.getStatus_keluarga()
                                                                                                                                                !=null
                                                                                                                                                ?
                                                                                                                                                pb.getStatus_keluarga()
                                                                                                                                                : ""
                                                                                                                                                )
                                                                                                                                                %>
                                                                                                                                                "
                                                                                                                                                data-kerja="
                                                                                                                                                <%= (pb.getPekerjaan()
                                                                                                                                                    !=null
                                                                                                                                                    ?
                                                                                                                                                    pb.getPekerjaan()
                                                                                                                                                    : ""
                                                                                                                                                    )
                                                                                                                                                    %>
                                                                                                                                                    "
                                                                                                                                                    data-gaji="
                                                                                                                                                    <%= pb.getPendapatanFormatted()
                                                                                                                                                        %>
                                                                                                                                                        "
                                                                                                                                                        data-kategori="
                                                                                                                                                        <%= pb.getJenis_bantuan()
                                                                                                                                                            %>
                                                                                                                                                            "
                                                                                                                                                            data-ulasanajk="
                                                                                                                                                            <%= (pb.getCatatan_pentadbir()
                                                                                                                                                                !=null
                                                                                                                                                                ?
                                                                                                                                                                pb.getCatatan_pentadbir().replace("\"", "&quot;"
                                                                                                                                                                )
                                                                                                                                                                : "Tiada ulasan."
                                                                                                                                                                )
                                                                                                                                                                %>
                                                                                                                                                                "
                                                                                                                                                                data-dokadmin="
                                                                                                                                                                <%= jsDokumenAdminH
                                                                                                                                                                    %>
                                                                                                                                                                    "
                                                                                                                                                                    data-score="
                                                                                                                                                                    <%= pb.getEligibilityScore()
                                                                                                                                                                        !=null
                                                                                                                                                                        ?
                                                                                                                                                                        pb.getEligibilityScore()
                                                                                                                                                                        :
                                                                                                                                                                        0.0
                                                                                                                                                                        %>
                                                                                                                                                                        "
                                                                                                                                                                        data-tier="
                                                                                                                                                                        <%= pb.getEligibilityTier()
                                                                                                                                                                            !=null
                                                                                                                                                                            ?
                                                                                                                                                                            pb.getEligibilityTier()
                                                                                                                                                                            : ""
                                                                                                                                                                            %>
                                                                                                                                                                            "
                                                                                                                                                                            data-flags="
                                                                                                                                                                            <%= pb.getEligibilityFlags()
                                                                                                                                                                                !=null
                                                                                                                                                                                ?
                                                                                                                                                                                String.join(",",
                                                                                                                                                                                pb.getEligibilityFlags())
                                                                                                                                                                                : ""
                                                                                                                                                                                %>
                                                                                                                                                                                "
                                                                                                                                                                                onclick="viewDetail(this)">
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-sm text-gray-400 font-medium">
                                                                                                                                                                                    <%= noS++
                                                                                                                                                                                        %>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-sm text-gray-500 whitespace-nowrap">
                                                                                                                                                                                    <%= displayDate
                                                                                                                                                                                        %>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-sm font-bold text-gray-800 group-hover:text-brand-purple transition-colors">
                                                                                                                                                                                    <%= pb.getNama_penuh()
                                                                                                                                                                                        %>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-sm text-gray-600">
                                                                                                                                                                                    <%= namaBantuan
                                                                                                                                                                                        %>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-center">
                                                                                                                                                                                    <% if
                                                                                                                                                                                        ("RASMI".equalsIgnoreCase(pb.getJenis_bantuan()))
                                                                                                                                                                                        {
                                                                                                                                                                                        %>
                                                                                                                                                                                        <span
                                                                                                                                                                                            class="px-2 py-1 rounded-lg text-[9px] font-bold bg-blue-50 text-blue-600 border border-blue-100">RASMI</span>
                                                                                                                                                                                        <% } else
                                                                                                                                                                                            {
                                                                                                                                                                                            %>
                                                                                                                                                                                            <span
                                                                                                                                                                                                class="px-2 py-1 rounded-lg text-[9px] font-bold bg-teal-50 text-teal-600 border border-teal-100">KOMUNITI</span>
                                                                                                                                                                                            <% }
                                                                                                                                                                                                %>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td
                                                                                                                                                                                    class="p-4 text-center">
                                                                                                                                                                                    <% if("LULUS".equalsIgnoreCase(pb.getStatus()))
                                                                                                                                                                                        {
                                                                                                                                                                                        %>
                                                                                                                                                                                        <span
                                                                                                                                                                                            class="bg-green-50 text-green-600 text-[10px] font-bold px-3 py-1.5 rounded-full border border-green-100">LULUS</span>
                                                                                                                                                                                        <% } else
                                                                                                                                                                                            {
                                                                                                                                                                                            %>
                                                                                                                                                                                            <span
                                                                                                                                                                                                class="bg-red-50 text-red-600 text-[10px] font-bold px-3 py-1.5 rounded-full border border-red-100">DITOLAK</span>
                                                                                                                                                                                            <% }
                                                                                                                                                                                                %>
                                                                                                                                                                                </td>
                                                                                                        </tr>
                                                                                                        <% } } else { %>
                                                                                                            <tr
                                                                                                                class="no-data">
                                                                                                                <td colspan="6"
                                                                                                                    class="p-8 text-center text-gray-400">
                                                                                                                    <i
                                                                                                                        class="fas fa-archive text-3xl mb-2 block opacity-50"></i>Tiada
                                                                                                                    rekod
                                                                                                                    sejarah.
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <% } %>
                                                                                                </tbody>
                                                                                            </table>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                    </div>

                                    <aside
                                        class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col flex-shrink-0 p-8 overflow-y-auto h-full">
                                        <div class="flex justify-between items-start mb-8">
                                            <h3 class="font-bold text-lg text-gray-800">Statistik Semasa</h3>
                                        </div>

                                        <div class="space-y-4">
                                            <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between">
                                                <div>
                                                    <p class="text-xs text-gray-500 font-bold uppercase">Menunggu</p>
                                                    <h4 class="font-bold text-xl text-gray-800">
                                                        <%= listPending.size() %>
                                                    </h4>
                                                </div>
                                                <div
                                                    class="w-10 h-10 rounded-full bg-orange-100 text-orange-500 flex items-center justify-center font-bold">
                                                    <i class="fas fa-clock"></i>
                                                </div>
                                            </div>

                                            <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between">
                                                <div>
                                                    <p class="text-xs text-gray-500 font-bold uppercase">Selesai</p>
                                                    <h4 class="font-bold text-xl text-gray-800">
                                                        <%= listSejarah.size() %>
                                                    </h4>
                                                </div>
                                                <div
                                                    class="w-10 h-10 rounded-full bg-green-100 text-green-500 flex items-center justify-center font-bold">
                                                    <i class="fas fa-check-double"></i>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-auto bg-purple-50 rounded-2xl p-6 relative overflow-hidden">
                                            <div
                                                class="absolute -right-4 -top-4 w-16 h-16 bg-purple-200 rounded-full opacity-50">
                                            </div>
                                            <h4 class="font-bold text-brand-purple mb-2 relative z-10 text-sm">Panduan
                                                Kelulusan</h4>
                                            <p class="text-xs text-gray-600 leading-relaxed relative z-10 mb-2">
                                                1. Semak maklumat pemohon.
                                            </p>
                                            <p class="text-xs text-gray-600 leading-relaxed relative z-10 mb-2">
                                                2. Sahkan kelayakan berdasarkan kriteria bantuan.
                                            </p>
                                            <p class="text-xs text-gray-600 leading-relaxed relative z-10">
                                                3. Muat naik memo/surat sokongan jika perlu.
                                            </p>
                                        </div>
                                    </aside>

                                    <!-- MODAL: DETAIL PERMOHONAN -->
                                    <div id="modalDetail" class="fixed inset-0 z-50 hidden" role="dialog">
                                        <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm"
                                            onclick="closeModal('modalDetail')"></div>
                                        <div class="flex min-h-screen items-center justify-center p-4">
                                            <div
                                                class="relative w-full max-w-3xl bg-white rounded-[2.5rem] shadow-2xl overflow-hidden border border-white/20 flex flex-col max-h-[90vh]">
                                                <!-- Modal Header -->
                                                <div
                                                    class="bg-gradient-to-r from-brand-purple to-brand-secondary px-8 py-6 text-white relative shrink-0">
                                                    <div class="absolute top-0 right-0 p-6 opacity-10">
                                                        <i class="fas fa-file-invoice text-8xl rotate-12"></i>
                                                    </div>
                                                    <div class="flex justify-between items-start relative z-10">
                                                        <div>
                                                            <span id="detId"
                                                                class="bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase border border-white/20">#000</span>
                                                            <h3 class="text-2xl font-bold mt-2" id="detBantuan">-</h3>
                                                        </div>
                                                        <button onclick="closeModal('modalDetail')"
                                                            class="w-10 h-10 flex items-center justify-center rounded-full bg-white/10 hover:bg-white/20 transition-all">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <!-- Scrollable Content Area -->
                                                <div class="p-8 overflow-y-auto custom-scrollbar flex-1">
                                                    <div class="space-y-8">
                                                        <!-- Profile Section -->
                                                        <div
                                                            class="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-gray-100 pb-6">
                                                            <div class="space-y-1">
                                                                <p
                                                                    class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                                                                    Maklumat Pemohon</p>
                                                                <h4 id="detPemohon"
                                                                    class="text-2xl font-extrabold text-gray-800">-</h4>
                                                                <div class="flex flex-wrap gap-4 mt-2">
                                                                    <div
                                                                        class="flex items-center gap-2 text-sm text-gray-500">
                                                                        <i class="far fa-id-card text-brand-purple"></i>
                                                                        <span id="detIC" class="font-medium">-</span>
                                                                    </div>
                                                                    <div
                                                                        class="flex items-center gap-2 text-sm text-gray-500">
                                                                        <i
                                                                            class="fas fa-phone-alt text-brand-purple"></i>
                                                                        <span id="detPhone" class="font-medium">-</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Eligibility Score Panel -->
                                                        <div
                                                            class="bg-gradient-to-r from-slate-50 to-slate-100/50 p-6 rounded-[2rem] border border-slate-200/60 shadow-sm mb-6 flex flex-col md:flex-row items-center gap-6">
                                                            <!-- Score Circle -->
                                                            <div
                                                                class="relative flex items-center justify-center shrink-0">
                                                                <div id="detScoreBadge"
                                                                    class="w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 shadow-inner bg-white">
                                                                    <span id="detScoreValue"
                                                                        class="text-3xl font-black text-slate-800">0</span>
                                                                    <span
                                                                        class="text-[9px] font-bold text-gray-400 uppercase tracking-widest">SKOR</span>
                                                                </div>
                                                            </div>
                                                            <!-- Score Info & Bar -->
                                                            <div class="flex-1 w-full space-y-2">
                                                                <div class="flex justify-between items-center">
                                                                    <div>
                                                                        <h5 class="text-sm font-black text-gray-800">
                                                                            Keputusan Skor Kelayakan</h5>
                                                                        <p
                                                                            class="text-[10px] text-gray-400 font-medium">
                                                                            Berdasarkan data sosio-ekonomi penduduk
                                                                            semasa.</p>
                                                                    </div>
                                                                    <span id="detTierBadge"
                                                                        class="px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider"></span>
                                                                </div>
                                                                <!-- Progress Bar -->
                                                                <div
                                                                    class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
                                                                    <div id="detScoreProgress"
                                                                        class="h-full rounded-full transition-all duration-500"
                                                                        style="width: 0%"></div>
                                                                </div>
                                                                <!-- Indicator flags -->
                                                                <div id="detFlagsContainer"
                                                                    class="flex flex-wrap gap-2 pt-1">
                                                                    <!-- Dynamic Flags -->
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Main Content Grid -->
                                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                                            <!-- Socio-Economic Card -->
                                                            <div class="space-y-4">
                                                                <h5
                                                                    class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                                                    <i class="fas fa-chart-pie text-indigo-400"></i>
                                                                    Profil Sosio-Ekonomi
                                                                </h5>
                                                                <div class="grid grid-cols-1 gap-3">
                                                                    <div
                                                                        class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                                                        <span
                                                                            class="text-xs text-slate-500 font-medium">Status
                                                                            Keluarga</span>
                                                                        <span id="detStatusK"
                                                                            class="text-sm font-bold text-slate-700">-</span>
                                                                    </div>
                                                                    <div
                                                                        class="flex items-center justify-between p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                                                        <span
                                                                            class="text-xs text-slate-500 font-medium">Pekerjaan</span>
                                                                        <span id="detPekerjaan"
                                                                            class="text-sm font-bold text-slate-700">-</span>
                                                                    </div>
                                                                    <div
                                                                        class="flex items-center justify-between p-4 bg-indigo-50/50 rounded-2xl border border-indigo-100">
                                                                        <span
                                                                            class="text-xs text-indigo-600 font-bold">Pendapatan
                                                                            Bulanan</span>
                                                                        <span id="detPendapatan"
                                                                            class="text-sm font-black text-indigo-700">-</span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Bank Information Card -->
                                                            <div class="space-y-4">
                                                                <h5
                                                                    class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                                                    <i class="fas fa-university text-blue-400"></i>
                                                                    Maklumat Perbankan
                                                                </h5>
                                                                <div id="bankCard"
                                                                    class="bg-blue-50/50 p-6 rounded-[2rem] border border-blue-100 relative overflow-hidden h-full min-h-[160px]">
                                                                    <!-- Dynamic Content from JS -->
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Semakan AJK Section -->
                                                        <div
                                                            class="space-y-3 bg-green-50/50 p-6 rounded-3xl border border-green-100">
                                                            <h5
                                                                class="text-[11px] font-bold text-green-600 uppercase tracking-widest flex items-center gap-2">
                                                                <i class="fas fa-user-shield"></i> Semakan & Ulasan AJK
                                                            </h5>
                                                            <div class="relative">
                                                                <i
                                                                    class="fas fa-comment-medical absolute top-0 left-0 text-green-200 text-xl"></i>
                                                                <p id="detUlasanAJK"
                                                                    class="text-sm text-green-800 leading-relaxed pl-8 font-medium italic">
                                                                    -
                                                                </p>
                                                            </div>
                                                        </div>

                                                        <!-- AI Decision Support and Recommendation Box -->
                                                        <div id="aiSupportDiv"
                                                            class="space-y-4 pt-6 border-t border-gray-100">
                                                            <h5
                                                                class="text-[11px] font-bold text-brand-purple uppercase tracking-widest flex items-center gap-2">
                                                                <i class="fas fa-robot"></i> Sokongan Keputusan AI
                                                            </h5>
                                                            <div class="p-6 rounded-3xl border flex flex-col justify-between"
                                                                id="aiRecommendCard">
                                                                <div>
                                                                    <div class="flex items-center justify-between mb-3">
                                                                        <span
                                                                            class="text-xs font-bold text-gray-400 uppercase tracking-wide">Pengesyoran
                                                                            Sistem</span>
                                                                        <span id="aiRecommendBadge"
                                                                            class="px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider"></span>
                                                                    </div>
                                                                    <h4 class="text-lg font-black text-gray-800"
                                                                        id="aiRecommendTitle">-</h4>
                                                                    <p class="text-xs text-gray-500 leading-relaxed mt-2"
                                                                        id="aiRecommendDesc">-</p>
                                                                </div>
                                                                <div class="mt-4 pt-3 border-t border-gray-100/60 hidden"
                                                                    id="aiAutoRejectionInfo">
                                                                    <p class="text-[10px] text-rose-500 font-bold"><i
                                                                            class="fas fa-magic"></i> Templat sebab
                                                                        penolakan automatik telah sedia dijana.</p>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Bottom Section: Keterangan & Documents -->
                                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 pt-4">
                                                            <div class="space-y-3">
                                                                <h5
                                                                    class="text-[11px] font-bold text-gray-400 uppercase tracking-widest flex items-center gap-2">
                                                                    <i class="fas fa-align-left text-gray-400"></i>
                                                                    Keterangan Pemohon
                                                                </h5>
                                                                <div
                                                                    class="bg-gray-50 p-5 rounded-2xl border border-gray-100 relative">
                                                                    <i
                                                                        class="fas fa-quote-left absolute top-4 left-4 text-gray-200 text-xl"></i>
                                                                    <p id="detKeterangan"
                                                                        class="text-sm text-gray-600 leading-relaxed pl-6 italic">
                                                                        -
                                                                    </p>
                                                                </div>
                                                            </div>
                                                            <div class="space-y-4">
                                                                <label
                                                                    class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">Dokumen
                                                                    Sokongan (Pemohon)</label>
                                                                <div id="dokumenList" class="flex flex-wrap gap-2">
                                                                    <!-- Dynamic Content -->
                                                                </div>
                                                                <div class="hidden">
                                                                    <a id="detDokMain" href="#" target="_blank"
                                                                        class="inline-flex items-center gap-2 px-4 py-2.5 bg-red-50 text-red-600 rounded-xl text-xs font-bold hover:bg-red-100 transition shadow-sm border border-red-100">
                                                                        <i class="fas fa-file-pdf"></i> PDF
                                                                    </a>
                                                                </div>
                                                                <!-- New Section for Admin Documents -->
                                                                <div id="detAdminDokSection"
                                                                    class="space-y-4 pt-4 border-t border-gray-100 hidden">
                                                                    <label
                                                                        class="block text-[10px] font-bold text-brand-purple uppercase tracking-widest mb-2">Dokumen
                                                                        Maklum Balas (Ketua Kampung)</label>
                                                                    <div id="dokumenAdminList"
                                                                        class="flex flex-wrap gap-2">
                                                                        <!-- Dynamic Content -->
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Modal Footer -->
                                                <div id="detActionBox"
                                                    class="p-8 bg-gray-50 border-t border-gray-100 shrink-0 flex flex-col md:flex-row justify-between items-center gap-4">
                                                    <button onclick="closeModal('modalDetail')"
                                                        class="text-gray-400 hover:text-gray-600 font-bold text-sm transition order-2 md:order-1">Kembali
                                                        ke Senarai</button>
                                                    <div class="flex gap-3 order-1 md:order-2 w-full md:w-auto">
                                                        <button id="btnDetReject"
                                                            class="flex-1 md:flex-none px-8 py-3 bg-white text-red-500 border border-red-100 rounded-2xl font-bold text-sm shadow-sm hover:bg-red-50 transition-all flex items-center justify-center gap-2">
                                                            <i class="fas fa-times-circle"></i> Tolak
                                                        </button>
                                                        <button id="btnDetApprove"
                                                            class="flex-1 md:flex-none px-10 py-3 bg-[#00B69B] text-white rounded-2xl font-bold text-sm shadow-lg shadow-teal-100 hover:bg-[#00a38b] transition-all flex items-center justify-center gap-2">
                                                            <i class="fas fa-check-circle"></i> Luluskan
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- MODAL: KEPUTUSAN -->
                                    <div id="modalKeputusan" class="fixed inset-0 z-[60] hidden" role="dialog">
                                        <div class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm"
                                            onclick="closeModal('modalKeputusan')"></div>
                                        <div class="flex min-h-screen items-center justify-center p-4">
                                            <div
                                                class="relative w-full max-w-md bg-white rounded-[2rem] shadow-2xl overflow-hidden border border-white/20">
                                                <form action="<%= request.getContextPath() %>/bantuan/keputusanKetua"
                                                    method="post" enctype="multipart/form-data">
                                                    <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
                                                    <input type="hidden" name="idPermohonan" id="actId">
                                                    <input type="hidden" name="keputusan" id="actDecision">

                                                    <div class="p-8 text-center" id="boxLengkap">
                                                        <div
                                                            class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                                            <i class="fas fa-check text-3xl text-green-500"></i>
                                                        </div>
                                                        <h3 class="text-xl font-bold text-gray-800 mb-2">Luluskan
                                                            Permohonan?</h3>
                                                        <p class="text-sm text-gray-500 leading-relaxed mb-6">
                                                            Permohonan ini akan diluluskan secara rasmi dan penduduk
                                                            akan menerima makluman.
                                                        </p>
                                                        <div class="text-left mb-6">
                                                            <label
                                                                class="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-2">Ulasan
                                                                (Pilihan)</label>
                                                            <textarea name="ulasan" id="actUlasanApprove"
                                                                class="w-full bg-gray-50 border-none rounded-2xl p-4 text-sm focus:ring-2 focus:ring-green-400"
                                                                placeholder="Masukkan ulasan jika perlu..."></textarea>
                                                        </div>
                                                    </div>

                                                    <div class="p-8 text-center hidden" id="boxTakLengkap">
                                                        <div
                                                            class="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                                                            <i class="fas fa-times text-3xl text-red-500"></i>
                                                        </div>
                                                        <h3 class="text-xl font-bold text-gray-800 mb-2">Tolak
                                                            Permohonan?</h3>
                                                        <p class="text-sm text-gray-500 leading-relaxed mb-6">
                                                            Sila berikan sebab penolakan supaya penduduk dapat
                                                            maklumbalas yang jelas.
                                                        </p>
                                                        <div class="text-left mb-6">
                                                            <label
                                                                class="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-2">Sebab
                                                                Penolakan (Wajib)</label>
                                                            <textarea name="ulasan" id="actUlasan" required
                                                                class="w-full bg-gray-50 border-none rounded-2xl p-4 text-sm focus:ring-2 focus:ring-red-400"
                                                                placeholder="Contoh: Dokumen tidak sah, pemohon tidak layak..."></textarea>
                                                        </div>
                                                    </div>

                                                    <!-- Upload Section with Dynamic Logic -->
                                                    <div class="px-8 pb-4 border-t border-gray-50 pt-6">
                                                        <div id="rasmiWarning"
                                                            class="hidden mb-4 p-3 bg-blue-50 border border-blue-100 rounded-2xl flex items-start gap-3">
                                                            <i class="fas fa-info-circle text-blue-500 mt-0.5"></i>
                                                            <p class="text-[11px] text-blue-700 leading-relaxed">
                                                                <strong>Bantuan Rasmi:</strong> Sila muat naik semula
                                                                dokumen/borang pemohon yang telah <strong>dicop
                                                                    pengesahan</strong> oleh Ketua Kampung.
                                                            </p>
                                                        </div>
                                                        <label id="uploadLabel"
                                                            class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2">Muat
                                                            Naik Dokumen Sokongan (Pilihan)</label>
                                                        <input type="file" name="dokumenBalas" accept="application/pdf"
                                                            id="dokumenBalas" multiple
                                                            class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-purple-50 file:text-brand-purple hover:file:bg-purple-100">
                                                    </div>

                                                    <div class="px-8 pb-8 flex gap-3">
                                                        <button type="button" onclick="closeModal('modalKeputusan')"
                                                            class="flex-1 py-3 bg-gray-100 text-gray-500 rounded-2xl font-bold text-sm hover:bg-gray-200 transition">Batal</button>
                                                        <button type="submit" id="actSubmitBtn"
                                                            class="flex-2 py-3 px-8 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-lg hover:bg-[#5a4cb3] transition">Sahkan
                                                            & Hantar</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <script>
                                            let currentKategori = "";

                                            function resetFilters() {
                                                document.getElementById('searchPemohon').value = '';
                                                document.getElementById('filterKategori').value = 'ALL';
                                                document.getElementById('filterDateStart').value = '';
                                                document.getElementById('filterDateEnd').value = '';
                                                filterData();
                                            }

                                            function filterData() {
                                                const search = document.getElementById('searchPemohon').value.toLowerCase();
                                                const category = document.getElementById('filterKategori').value;
                                                const dateStart = document.getElementById('filterDateStart').value;
                                                const dateEnd = document.getElementById('filterDateEnd').value;

                                                const rows = document.querySelectorAll('.data-row-filter');
                                                rows.forEach(row => {
                                                    const rowSearch = row.getAttribute('data-search').toLowerCase();
                                                    const rowCategory = row.getAttribute('data-category');
                                                    const rowDate = row.getAttribute('data-date'); // YYYY-MM-DD

                                                    let show = true;

                                                    if (search && !rowSearch.includes(search)) show = false;
                                                    if (category !== 'ALL' && rowCategory !== category) show = false;

                                                    if (dateStart && rowDate < dateStart) show = false;
                                                    if (dateEnd && rowDate > dateEnd) show = false;

                                                    row.style.display = show ? '' : 'none';
                                                });
                                            }

                                            function switchTab(name) {
                                                // Reset Tabs Style
                                                document.querySelectorAll('nav button').forEach(btn => {
                                                    btn.classList.remove('border-brand-purple', 'text-brand-purple', 'font-bold');
                                                    btn.classList.add('border-transparent', 'text-gray-500', 'font-medium');
                                                });

                                                // Active Tab Style
                                                const activeTab = document.getElementById('tab-' + name);
                                                activeTab.classList.add('border-brand-purple', 'text-brand-purple', 'font-bold');
                                                activeTab.classList.remove('border-transparent', 'text-gray-500', 'font-medium');

                                                // Toggle Content
                                                document.getElementById('content-pending').classList.add('hidden');
                                                document.getElementById('content-sejarah').classList.add('hidden');

                                                document.getElementById('content-' + name).classList.remove('hidden');
                                            }

                                            let currentScore = 0;

                                            function getFlagBadge(flag) {
                                                switch (flag) {
                                                    case 'TIADA_PENDAPATAN':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-hand-holding-usd"></i> Tiada Pendapatan</span>';
                                                    case 'PENDAPATAN_SANGAT_RENDAH':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-arrow-down"></i> Pendapatan Sangat Rendah</span>';
                                                    case 'PENDAPATAN_RENDAH':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-600 text-xs font-bold"><i class="fas fa-arrow-down text-[10px]"></i> Pendapatan Rendah</span>';
                                                    case 'TANGGUNGAN_SANGAT_RAMAI':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-users"></i> Tanggungan Sangat Ramai</span>';
                                                    case 'TANGGUNGAN_RAMAI':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 border border-amber-200 text-amber-600 text-xs font-bold"><i class="fas fa-user-friends"></i> Tanggungan Ramai</span>';
                                                    case 'IBU_BAPA_TUNGGAL':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-purple-50 border border-purple-200 text-purple-600 text-xs font-bold"><i class="fas fa-child"></i> Ibu/Bapa Tunggal</span>';
                                                    case 'OKU':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-indigo-50 border border-indigo-200 text-indigo-600 text-xs font-bold"><i class="fas fa-wheelchair"></i> OKU</span>';
                                                    case 'TIADA_KERJA':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-bold"><i class="fas fa-user-slash"></i> Tiada Pekerjaan</span>';
                                                    case 'KERJA_SEKTOR_TIDAK_FORMAL':
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-blue-50 border border-blue-200 text-blue-600 text-xs font-bold"><i class="fas fa-tools"></i> Sektor Tidak Formal</span>';
                                                    default:
                                                        return '<span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-50 border border-gray-200 text-gray-600 text-xs font-bold">' + flag + '</span>';
                                                }
                                            }

                                            function populateDecisionSupport(scoreVal, tier, flagsStr) {
                                                const flags = flagsStr ? flagsStr.split(',') : [];

                                                // 1. Eligibility Score Panel values
                                                const detScoreValue = document.getElementById('detScoreValue');
                                                const detScoreProgress = document.getElementById('detScoreProgress');
                                                const detTierBadge = document.getElementById('detTierBadge');
                                                const detScoreBadge = document.getElementById('detScoreBadge');

                                                if (detScoreValue && detScoreProgress && detTierBadge && detScoreBadge) {
                                                    detScoreValue.innerText = scoreVal.toFixed(0);
                                                    detScoreProgress.style.width = scoreVal + '%';
                                                    detTierBadge.innerText = tier || 'RENDAH';

                                                    if (scoreVal >= 80) {
                                                        detScoreProgress.className = "h-full rounded-full bg-emerald-500 transition-all duration-500";
                                                        detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-emerald-50 text-emerald-600 border border-emerald-200";
                                                        detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-emerald-500 shadow-inner bg-white";
                                                    } else if (scoreVal >= 40) {
                                                        detScoreProgress.className = "h-full rounded-full bg-amber-500 transition-all duration-500";
                                                        detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-amber-50 text-amber-600 border border-amber-200";
                                                        detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-amber-500 shadow-inner bg-white";
                                                    } else {
                                                        detScoreProgress.className = "h-full rounded-full bg-rose-500 transition-all duration-500";
                                                        detTierBadge.className = "px-3 py-1 rounded-xl text-[10px] font-black uppercase tracking-wider bg-rose-50 text-rose-600 border border-rose-200";
                                                        detScoreBadge.className = "w-24 h-24 rounded-full flex flex-col items-center justify-center border-4 border-rose-500 shadow-inner bg-white";
                                                    }
                                                }

                                                // 2. Flags Container
                                                const detFlagsContainer = document.getElementById('detFlagsContainer');
                                                if (detFlagsContainer) {
                                                    detFlagsContainer.innerHTML = '';
                                                    if (flags.length > 0 && flags[0] !== "") {
                                                        flags.forEach(f => {
                                                            detFlagsContainer.innerHTML += getFlagBadge(f);
                                                        });
                                                    } else {
                                                        detFlagsContainer.innerHTML = '<span class="text-xs text-gray-400 italic">Tiada indikator kelayakan dikesan.</span>';
                                                    }
                                                }

                                                // 3. AI Recommendation
                                                const aiRecommendCard = document.getElementById('aiRecommendCard');
                                                const aiRecommendBadge = document.getElementById('aiRecommendBadge');
                                                const aiRecommendTitle = document.getElementById('aiRecommendTitle');
                                                const aiRecommendDesc = document.getElementById('aiRecommendDesc');
                                                const aiAutoRejectionInfo = document.getElementById('aiAutoRejectionInfo');

                                                if (aiRecommendCard && aiRecommendBadge && aiRecommendTitle && aiRecommendDesc) {
                                                    let syorTitle = '';
                                                    let syorDesc = '';
                                                    let syorBadgeText = '';
                                                    let cardClass = '';
                                                    let badgeClass = '';

                                                    if (scoreVal >= 80) {
                                                        syorBadgeText = 'Cadangan Lulus';
                                                        syorTitle = 'Sangat Layak Diluluskan';
                                                        syorDesc = 'Pemohon mempunyai skor kelayakan yang sangat tinggi (' + scoreVal.toFixed(0) + '%). Status sosio-ekonomi berada dalam kumpulan keutamaan tinggi untuk menerima bantuan ini. AJK Kampung telah menyokong penuh permohonan ini.';
                                                        cardClass = 'bg-emerald-50/40 border-emerald-100 p-6 rounded-3xl border flex flex-col justify-between';
                                                        badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-emerald-100 text-emerald-700';
                                                        if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
                                                    } else if (scoreVal >= 40) {
                                                        syorBadgeText = 'Syor Pertimbangan';
                                                        syorTitle = 'Kelayakan Sederhana';
                                                        syorDesc = 'Pemohon mempunyai skor kelayakan sederhana (' + scoreVal.toFixed(0) + '%). Status sosio-ekonomi pemohon layak, tetapi dinasihatkan menyemak ulasan AJK di atas sebelum keputusan akhir dibuat.';
                                                        cardClass = 'bg-amber-50/40 border-amber-100 p-6 rounded-3xl border flex flex-col justify-between';
                                                        badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-amber-100 text-amber-700';
                                                        if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
                                                    } else {
                                                        syorBadgeText = 'Cadangan Tolak';
                                                        syorTitle = 'Tidak Menepati Kriteria';
                                                        syorDesc = 'Pemohon mempunyai skor kelayakan yang rendah (' + scoreVal.toFixed(0) + '%). Berdasarkan penilaian sistem, status pendapatan berada di atas paras kemiskinan dan pemohon mempunyai keupayaan sara diri yang mencukupi.';
                                                        cardClass = 'bg-rose-50/40 border-rose-100 p-6 rounded-3xl border flex flex-col justify-between';
                                                        badgeClass = 'px-2.5 py-1 rounded-lg text-[10px] font-black uppercase tracking-wider bg-rose-100 text-rose-700';

                                                        if (scoreVal < 35) {
                                                            if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.remove('hidden');
                                                        } else {
                                                            if (aiAutoRejectionInfo) aiAutoRejectionInfo.classList.add('hidden');
                                                        }
                                                    }

                                                    aiRecommendCard.className = cardClass;
                                                    aiRecommendBadge.className = badgeClass;
                                                    aiRecommendBadge.innerText = syorBadgeText;
                                                    aiRecommendTitle.innerText = syorTitle;
                                                    aiRecommendDesc.innerText = syorDesc;
                                                }
                                            }

                                            function viewDetail(row) {
                                                const d = row.dataset;
                                                const id = d.id;
                                                const bantuan = d.bantuan;
                                                const kategori = d.kategori;
                                                const showAction = (d.showaction === "true");
                                                currentKategori = kategori;
                                                currentScore = parseFloat(d.score || 0);

                                                document.getElementById('detId').innerText = "#" + id;
                                                document.getElementById('detBantuan').innerText = bantuan;
                                                document.getElementById('detPemohon').innerText = d.pemohon;
                                                document.getElementById('detIC').innerText = (d.ic && d.ic !== "null") ? d.ic : "-";
                                                document.getElementById('detPhone').innerText = (d.phone && d.phone !== "null") ? d.phone : "-";
                                                document.getElementById('detStatusK').innerText = (d.statusk && d.statusk !== "null") ? d.statusk : "-";
                                                document.getElementById('detPekerjaan').innerText = (d.kerja && d.kerja !== "null") ? d.kerja : "-";
                                                document.getElementById('detPendapatan').innerText = (d.gaji && d.gaji !== "null") ? d.gaji : "RM 0.00";
                                                document.getElementById('detKeterangan').innerText = (d.ket && d.ket !== "null") ? d.ket : "Tiada keterangan tambahan.";
                                                document.getElementById('detUlasanAJK').innerText = (d.ulasanajk && d.ulasanajk !== "null") ? d.ulasanajk : "Tiada ulasan dari AJK.";

                                                populateDecisionSupport(currentScore, d.tier, d.flags);

                                                const bank = d.bank;
                                                const akaun = d.akaun;
                                                const penBank = d.penbank;
                                                const dok = d.dok;
                                                const dokAdmin = d.dokadmin;

                                                // Bank Section Logic
                                                const bankCard = document.getElementById('bankCard');
                                                if (kategori === "RASMI") {
                                                    bankCard.innerHTML = `
                <div class="flex flex-col items-center justify-center h-full text-center p-4">
                    <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center text-blue-500 mb-3">
                        <i class="fas fa-info-circle text-xl"></i>
                    </div>
                    <p class="text-[10px] font-bold text-blue-400 uppercase tracking-wider">Bantuan Rasmi</p>
                    <p class="text-xs text-blue-600 font-medium mt-1 italic leading-relaxed">Maklumat perbankan tidak diperlukan atau dikendalikan oleh agensi luar.</p>
                </div>
            `;
                                                } else {
                                                    bankCard.innerHTML = `
                <div class="absolute -right-4 -bottom-4 opacity-5">
                    <i class="fas fa-credit-card text-7xl"></i>
                </div>
                <div class="space-y-4 relative z-10">
                    <div>
                        <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nama Bank</p>
                        <p id="detBank" class="font-bold text-blue-900 uppercase tracking-wide text-lg">\${(bank && bank !== "null") ? bank : "-"}</p>
                    </div>
                    <div>
                        <p class="text-[10px] text-blue-400 font-bold uppercase mb-1">Nombor Akaun</p>
                        <p id="detAkaun" class="font-bold text-blue-900 text-xl tracking-widest">\${(akaun && akaun !== "null") ? akaun : "-"}</p>
                    </div>
                    <div class="pt-2">
                        <a id="detDokBank" href="\${(penBank && penBank !== "null") ? '<%= request.getContextPath() %>/file/bantuan/' + penBank : '#'}" 
                           target="_blank" 
                           class="inline-flex items-center gap-2 px-4 py-2.5 bg-white text-blue-600 rounded-xl text-xs font-bold shadow-sm border border-blue-100 hover:shadow-md transition-all \${(penBank && penBank !== "null") ? '' : 'opacity-50 pointer-events-none'}">
                            <i class="fas fa-file-invoice-dollar"></i> Lihat Penyata Bank
                        </a>
                    </div>
                </div>
            `;
                                                }

                                                const ctx = '<%= request.getContextPath() %>';

                                                // Handle Action Buttons
                                                const actionBox = document.getElementById('detActionBox');
                                                if (showAction) {
                                                    actionBox.classList.remove('hidden');
                                                    document.getElementById('btnDetReject').onclick = () => { closeModal('modalDetail'); openActionModal(id, 'tak_lengkap'); };
                                                    document.getElementById('btnDetApprove').onclick = () => { closeModal('modalDetail'); openActionModal(id, 'lengkap'); };
                                                } else {
                                                    actionBox.classList.add('hidden');
                                                }

                                                // Handle Multiple Documents
                                                const dokumenList = document.getElementById('dokumenList');
                                                const template = document.getElementById('detDokMain');

                                                if (dokumenList) {
                                                    dokumenList.innerHTML = '';
                                                    if (dok && template) {
                                                        const files = dok.split(',');
                                                        files.forEach(f => {
                                                            const newLink = template.cloneNode(true);
                                                            newLink.id = ""; // Remove ID to prevent collisions
                                                            newLink.classList.remove('hidden');
                                                            newLink.href = ctx + "/file/bantuan/" + f;
                                                            newLink.innerHTML = '<i class="fas fa-file-pdf"></i> PDF';
                                                            dokumenList.appendChild(newLink);
                                                        });
                                                    }
                                                }

                                                // Handle Admin Documents
                                                const adminDokList = document.getElementById('dokumenAdminList');
                                                const adminDokSection = document.getElementById('detAdminDokSection');
                                                adminDokList.innerHTML = '';

                                                if (dokAdmin && dokAdmin !== "" && template) {
                                                    adminDokSection.classList.remove('hidden');
                                                    const filesA = dokAdmin.split(',');
                                                    filesA.forEach(f => {
                                                        const newLink = template.cloneNode(true);
                                                        newLink.id = ""; // Remove ID to prevent collisions
                                                        newLink.classList.remove('hidden');
                                                        newLink.classList.replace('bg-red-50', 'bg-purple-50');
                                                        newLink.classList.replace('text-red-600', 'text-brand-purple');
                                                        newLink.classList.replace('border-red-100', 'border-purple-100');
                                                        newLink.href = ctx + "/file/bantuan/" + f;
                                                        newLink.innerHTML = '<i class="fas fa-check-circle"></i> ' + decodeURIComponent(f).split('_').slice(2).join('_');
                                                        adminDokList.appendChild(newLink);
                                                    });
                                                } else {
                                                    adminDokSection.classList.add('hidden');
                                                }

                                                openModal('modalDetail');
                                            }

                                            function openActionModal(id, type) {
                                                document.getElementById('actId').value = id;
                                                document.getElementById('actDecision').value = type === 'lengkap' ? 'LULUS' : 'DITOLAK';
                                                const boxL = document.getElementById('boxLengkap');
                                                const boxTL = document.getElementById('boxTakLengkap');
                                                const btn = document.getElementById('actSubmitBtn');

                                                // Logic for Official Aid (RASMI) verification loop
                                                const uploadLabel = document.getElementById('uploadLabel');
                                                const uploadInput = document.getElementById('dokumenBalas');
                                                const rasmiWarning = document.getElementById('rasmiWarning');

                                                if (type === 'lengkap') {
                                                    boxL.classList.remove('hidden');
                                                    boxTL.classList.add('hidden');
                                                    btn.className = "flex-2 py-3 px-8 bg-green-500 text-white rounded-2xl font-bold text-sm shadow-lg hover:bg-green-600 transition";

                                                    // Fix: Handle required and disabled states for hidden fields
                                                    document.getElementById('actUlasan').required = false;
                                                    document.getElementById('actUlasan').disabled = true;
                                                    document.getElementById('actUlasanApprove').disabled = false;

                                                    if (currentKategori === "RASMI") {
                                                        uploadLabel.innerHTML = 'Muat Naik Borang/Dokumen Dicop (Wajib)';
                                                        uploadLabel.className = 'block text-xs font-bold text-blue-600 mb-2';
                                                        uploadInput.required = true;
                                                        rasmiWarning.classList.remove('hidden');
                                                    } else {
                                                        uploadLabel.innerHTML = 'Muat Naik Dokumen Sokongan (Pilihan)';
                                                        uploadLabel.className = 'block text-xs font-bold text-gray-500 mb-2';
                                                        uploadInput.required = false;
                                                        rasmiWarning.classList.add('hidden');
                                                    }
                                                } else {
                                                    boxL.classList.add('hidden');
                                                    boxTL.classList.remove('hidden');
                                                    btn.className = "flex-2 py-3 px-8 bg-red-500 text-white rounded-2xl font-bold text-sm shadow-lg hover:bg-red-600 transition";

                                                    // Fix: Handle required and disabled states for hidden fields
                                                    document.getElementById('actUlasan').required = true;
                                                    document.getElementById('actUlasan').disabled = false;
                                                    document.getElementById('actUlasanApprove').disabled = true;

                                                    // Pre-populate rejection template if score is below threshold
                                                    if (currentScore < 35) {
                                                        document.getElementById('actUlasan').value = "DITOLAK: Skor kelayakan permohonan (" + currentScore.toFixed(0) + "%) adalah di bawah paras minima kelayakan. Sila hubungi AJK jika maklumat sosio-ekonomi (pendapatan/pekerjaan/ahli keluarga) perlu dikemaskini.";
                                                    } else {
                                                        document.getElementById('actUlasan').value = "";
                                                    }

                                                    // For rejection, documents are always optional
                                                    uploadLabel.innerHTML = 'Muat Naik Dokumen Sokongan (Pilihan)';
                                                    uploadLabel.className = 'block text-xs font-bold text-gray-500 mb-2';
                                                    uploadInput.required = false;
                                                    rasmiWarning.classList.add('hidden');
                                                }
                                                openModal('modalKeputusan');
                                            }

                                            // Functions centralized in footer.jsp
                                        </script>

                                        <%@ include file="/views/common/footer.jsp" %>