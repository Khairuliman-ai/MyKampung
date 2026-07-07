<%@ page import="model.Pengguna, model.ActivityLog, model.AhliKeluarga, java.util.List" %>
<%
    // 1. Dapatkan objek user dari session
    Pengguna pDetail = (Pengguna) session.getAttribute("currentUser");

    if (pDetail == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<link rel='stylesheet' href='https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css' />
<script src='https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js'></script>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 
    CONTAINER UTAMA: 
    - flex h-full overflow-hidden: Memastikan skrin penuh dan body utama tidak skrol. 
--%>
<div class="flex flex-1 h-full overflow-hidden bg-[#F7F7F9]">

    <%-- 
        MAIN CONTENT (Information Section): 
    --%>
    <div class="flex-1 overflow-y-auto p-4 md:p-10 scroll-smooth h-full custom-scrollbar relative">
        
        <%-- Background Decoration --%>
        <div class="absolute top-0 left-0 w-full h-64 bg-gradient-to-b from-purple-50/50 to-transparent pointer-events-none -z-10"></div>
        <div class="absolute top-20 right-10 w-64 h-64 bg-purple-200/20 rounded-full blur-3xl pointer-events-none -z-10"></div>

        <header class="mb-10 flex flex-col md:flex-row md:items-center justify-between gap-4 animate-in fade-in slide-in-from-top-4 duration-700">
            <div>
                <h2 class="text-3xl font-extrabold text-gray-900 tracking-tight flex items-center gap-3">
                    <span class="bg-gradient-to-r from-brand-purple to-brand-secondary bg-clip-text text-transparent">Profil Saya</span>
                    <i class="fas fa-user-circle text-brand-purple text-2xl"></i>
                </h2>
                <p class="text-gray-500 mt-1 font-medium">Urus maklumat peribadi dan tetapan akaun anda di sini.</p>
            </div>
            
            <div class="flex items-center gap-2 text-xs font-bold text-gray-400 bg-white px-4 py-2 rounded-full shadow-sm border border-gray-100">
                <i class="fas fa-calendar-alt text-brand-purple"></i>
                <span id="currentDateDisplay"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></span>
            </div>
        </header>

        <%-- Form Logic Scripts --%>
        <script>
            function formatPhoneNumber(input) {
                let num = input.value.replace(/\D/g, '');
                if (num.length > 3 && num.length <= 7) {
                    input.value = num.substring(0, 3) + '-' + num.substring(3);
                } else if (num.length > 7) {
                    input.value = num.substring(0, 3) + '-' + num.substring(3, 7) + ' ' + num.substring(7, 11);
                } else {
                    input.value = num;
                }
            }
            function formatIC(input) {
                let val = input.value.replace(/\D/g, '');
                if (val.length > 12) val = val.substring(0, 12);
                let formatted = "";
                if (val.length > 0) formatted += val.substring(0, 6);
                if (val.length > 6) formatted += '-' + val.substring(6, 8);
                if (val.length > 8) formatted += '-' + val.substring(8, 12);
                input.value = formatted;
            }
        </script>

        <%-- Mesej Maklum Balas --%>
        <% if (request.getParameter("status") != null) { 
            String status = request.getParameter("status");
            String msg = "";
            String bgColor = "";
            String textColor = "";
            String icon = "";
            
            if (status.equals("success")) {
                msg = "Berjaya! Maklumat anda telah dikemaskini.";
                bgColor = "bg-green-500/10 border-green-500/20";
                textColor = "text-green-700";
                icon = "fa-check-circle";
            } else if (status.equals("error")) {
                String err = request.getParameter("error");
                if ("file_too_large".equals(err)) {
                    msg = "Had saiz fail foto profil atau dokumen sokongan melebihi 10MB. Sila kecilkan fail gambar dan cuba lagi.";
                } else {
                    msg = "Ralat! Berlaku masalah semasa mengemaskini maklumat.";
                }
                bgColor = "bg-red-500/10 border-red-500/20";
                textColor = "text-red-700";
                icon = "fa-exclamation-circle";
            } else if (status.equals("pass_success")) {
                msg = "Berjaya! Kata laluan telah dikemaskini.";
                bgColor = "bg-green-500/10 border-green-500/20";
                textColor = "text-green-700";
                icon = "fa-shield-check";
            } else if (status.equals("pass_error")) {
                msg = "Ralat! Gagal menukar kata laluan.";
                bgColor = "bg-red-500/10 border-red-500/20";
                textColor = "text-red-700";
                icon = "fa-exclamation-triangle";
            } else if (status.equals("wrong_old_pass")) {
                msg = "Perhatian! Kata laluan lama yang dimasukkan adalah salah.";
                bgColor = "bg-yellow-500/10 border-yellow-500/20";
                textColor = "text-yellow-700";
                icon = "fa-key";
            }
        %>
        <div class="<%= bgColor %> border <%= textColor %> px-6 py-4 rounded-2xl mb-8 flex items-center gap-4 animate-in zoom-in duration-300 backdrop-blur-md">
            <div class="w-10 h-10 rounded-full bg-white/50 flex items-center justify-center shadow-sm">
                <i class="fas <%= icon %> text-lg"></i>
            </div>
            <div class="font-semibold text-sm"><%= msg %></div>
            <button onclick="this.parentElement.remove()" class="ml-auto text-gray-400 hover:text-gray-600 transition">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <% } %>

        <form action="<%= request.getContextPath()%>/profil/update?_csrf=<%= session.getAttribute("csrf_token") %>" method="post" enctype="multipart/form-data" class="w-full space-y-8 animate-in fade-in slide-in-from-bottom-8 duration-1000" onsubmit="return confirmAction(event, 'Simpan Perubahan?', 'Adakah anda pasti mahu menyimpan maklumat profil yang baharu?', 'Ya, Simpan!', '<%= primaryColor %>')">
            <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>

            <%-- Bekas Kad Tunggal (Single Form Card Container) --%>
            <div class="bg-white rounded-[2.5rem] p-8 md:p-12 shadow-sm border border-slate-100 space-y-10 animate-in fade-in duration-500">
                
                <%-- Profile Header Section --%>
                <div class="relative flex flex-col md:flex-row items-center gap-8 overflow-hidden pb-8 border-b border-slate-100">
                    <%-- Decorative Background Pattern --%>
                    <div class="absolute top-0 right-0 w-64 h-full opacity-[0.03] pointer-events-none">
                        <svg width="100%" height="100%" viewBox="0 0 100 100" preserveAspectRatio="none">
                            <path d="M0,0 L100,0 L100,100 L0,100 Z" fill="url(#grid)"></path>
                            <defs>
                                <pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse">
                                    <path d="M 10 0 L 0 0 0 10" fill="none" stroke="currentColor" stroke-width="0.5"/>
                                </pattern>
                            </defs>
                        </svg>
                    </div>

                    <div class="relative flex-shrink-0">
                        <div class="w-36 h-36 rounded-full p-1.5 bg-gradient-to-tr from-brand-purple to-brand-secondary shadow-2xl relative">
                            <div class="w-full h-full rounded-full bg-white overflow-hidden flex items-center justify-center text-5xl font-bold text-brand-purple">
                                <% if (pDetail.getFoto_profil() != null && !pDetail.getFoto_profil().isEmpty() && !pDetail.getFoto_profil().equals("default_avatar.png")) {%>
                                <img id="previewFoto" src="<%= request.getContextPath() %>/file/profil/<%= pDetail.getFoto_profil() %>" class="w-full h-full object-cover">
                                <% } else {%>
                                <img id="previewFoto" src="https://ui-avatars.com/api/?name=<%= pDetail.getNama_penuh() %>&background=6C5DD3&color=fff&size=128" class="w-full h-full object-cover">
                                <% }%>
                            </div>
                            <label for="fotoInput" class="absolute bottom-2 right-2 w-11 h-11 bg-white text-brand-purple rounded-full flex items-center justify-center cursor-pointer shadow-xl border border-gray-100 hover:scale-110 active:scale-95 transition-all z-10">
                                <i class="fas fa-camera text-base"></i>
                                <input type="file" id="fotoInput" name="foto_profil" class="hidden" accept="image/*" onchange="previewImage(this)">
                            </label>
                        </div>
                    </div>

                    <div class="text-center md:text-left flex-1">
                        <div class="flex flex-col md:flex-row md:items-center gap-3 mb-2 justify-center md:justify-start">
                            <h3 class="text-3xl font-extrabold text-gray-900 tracking-tight"><%= pDetail.getNama_penuh() %></h3>
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-[10px] font-bold bg-purple-100 text-brand-purple uppercase tracking-widest border border-purple-200 w-fit mx-auto md:mx-0">
                                <%= pDetail.getNama_peranan() %>
                            </span>
                        </div>
                        <p class="text-gray-500 font-medium flex items-center justify-center md:justify-start gap-2 mb-4">
                            <i class="far fa-id-card text-brand-purple"></i>
                            <%= pDetail.getNombor_kp() %>
                        </p>
                        
                        <div class="flex flex-wrap items-center justify-center md:justify-start gap-4">
                            <div class="flex items-center gap-2 px-4 py-2 bg-slate-50 rounded-xl border border-slate-100">
                                <i class="fas fa-envelope text-xs text-gray-400"></i>
                                <span class="text-xs font-semibold text-gray-600"><%= (pDetail.getEmail() != null) ? pDetail.getEmail() : "Tiada Email" %></span>
                            </div>
                            <div class="flex items-center gap-2 px-4 py-2 bg-slate-50 rounded-xl border border-slate-100">
                                <i class="fas fa-phone text-xs text-gray-400"></i>
                                <span class="text-xs font-semibold text-gray-600"><%= pDetail.getNombor_telefon() %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Section 1: Peribadi --%>
                <div class="space-y-6">
                    <div class="flex items-center gap-4 border-b border-slate-100 pb-4">
                        <div class="w-10 h-10 rounded-xl bg-purple-50 text-brand-purple flex items-center justify-center text-lg shadow-inner flex-shrink-0">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <div>
                            <h4 class="text-base font-bold text-slate-800">Maklumat Peribadi</h4>
                            <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wide">Lengkapkan data peribadi dan perhubungan utama anda</p>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Nama Penuh</label>
                            <div class="relative">
                                <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-brand-purple transition-colors"></i>
                                <input type="text" name="nama_penuh" value="<%= pDetail.getNama_penuh()%>" required 
                                    onkeypress="return !/[0-9]/.test(event.key)" oninput="this.value = this.value.replace(/[0-9]/g, '')"
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-slate-800 text-sm font-semibold transition-all">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="group opacity-70">
                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">No. Kad Pengenalan</label>
                                <%
                                    String icRaw = pDetail.getNombor_kp();
                                    String icFormatted = (icRaw != null && icRaw.length() == 12)
                                            ? icRaw.substring(0, 6) + "-" + icRaw.substring(6, 8) + "-" + icRaw.substring(8, 12) : icRaw;
                                %>
                                <div class="relative">
                                    <i class="fas fa-id-badge absolute left-4 top-1/2 -translate-y-1/2 text-gray-300"></i>
                                    <input type="text" value="<%= icFormatted%>" readonly 
                                        class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-100 border-none text-slate-400 text-sm cursor-not-allowed font-semibold">
                                </div>
                            </div>
                            <div class="group">
                                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">No. Telefon</label>
                                <div class="relative">
                                    <i class="fas fa-phone absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-brand-purple transition-colors"></i>
                                    <input type="text" name="nombor_telefon" value="<%= pDetail.getNombor_telefon()%>" required oninput="formatPhoneNumber(this)" maxlength="13" 
                                        class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-slate-800 text-sm font-semibold transition-all">
                                </div>
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Alamat Emel</label>
                            <div class="relative">
                                <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-brand-purple transition-colors"></i>
                                <input type="email" name="email" value="<%= (pDetail.getEmail() != null) ? pDetail.getEmail() : ""%>" required 
                                    pattern="[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" 
                                    title="Format emel tidak sah. Sila ikuti format cth: ali.03_bantuan@v2-kampung.edu.my"
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-slate-800 text-sm font-semibold transition-all">
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Divider --%>
                <div class="h-px bg-slate-100"></div>

                <%-- Section 2: Sosio-Ekonomi --%>
                <div class="space-y-6">
                    <div class="flex items-center gap-4 border-b border-slate-100 pb-4">
                        <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center text-lg shadow-inner flex-shrink-0">
                            <i class="fas fa-wallet text-xl"></i>
                        </div>
                        <div>
                            <h4 class="text-base font-bold text-slate-800">Sosio-Ekonomi</h4>
                            <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wide">Status kewangan & keluarga anda</p>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Status Keluarga</label>
                            <div class="relative">
                                <i class="fas fa-users absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-blue-600 transition-colors z-10"></i>
                                <select name="status_keluarga" class="w-full pl-12 pr-10 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-slate-800 text-sm font-semibold transition-all appearance-none">
                                    <option value="Bujang" <%= "Bujang".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bujang</option>
                                    <option value="Berkahwin" <%= "Berkahwin".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Berkahwin</option>
                                    <option value="Ibu Tunggal" <%= "Ibu Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Ibu Tunggal</option>
                                    <option value="Bapa Tunggal" <%= "Bapa Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bapa Tunggal</option>
                                </select>
                                <i class="fas fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none text-xs"></i>
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Pekerjaan</label>
                            <div class="relative">
                                <i class="fas fa-briefcase absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-blue-600 transition-colors"></i>
                                <input type="text" name="pekerjaan" value="<%= (pDetail.getPekerjaan() != null) ? pDetail.getPekerjaan() : ""%>" 
                                    onkeypress="return /^[a-zA-Z\s'-]$/.test(event.key)" oninput="this.value = this.value.replace(/[^a-zA-Z\s'-]/g, '')"
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-slate-800 text-sm font-semibold transition-all">
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Pendapatan Bulanan (RM)</label>
                            <div class="relative">
                                <div class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 font-bold text-sm group-focus-within:text-blue-600 transition-colors">RM</div>
                                <input type="number" step="0.01" name="pendapatan" value="<%= pDetail.getPendapatan()%>" 
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-slate-800 text-sm font-semibold transition-all">
                            </div>
                            <p class="text-[9px] text-slate-400 mt-2 italic px-1">* Digunakan untuk penentuan kelayakan bantuan.</p>
                        </div>

                        <div class="group">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Pengesahan Pendapatan (Slip Gaji / Dokumen Sokongan)</label>
                            <div class="relative flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
                                <div class="relative flex-1">
                                    <i class="fas fa-file-invoice-dollar absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-blue-600 transition-colors"></i>
                                    <input type="file" name="pengesahan_pendapatan" accept=".pdf,.png,.jpg,.jpeg" 
                                        class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-slate-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-slate-800 text-xs font-semibold transition-all file:mr-4 file:py-1.5 file:px-3 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:bg-blue-100 file:text-blue-600 hover:file:bg-blue-200 file:cursor-pointer">
                                </div>
                                <% if (pDetail.getPengesahan_pendapatan() != null && !pDetail.getPengesahan_pendapatan().isEmpty()) { %>
                                <a href="<%= request.getContextPath() %>/file/pendapatan/<%= pDetail.getPengesahan_pendapatan() %>" target="_blank" 
                                    class="px-5 py-4 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-2xl flex items-center justify-center gap-2 text-xs font-black shadow-sm transition-all whitespace-nowrap active:scale-95">
                                    <i class="fas fa-eye text-sm"></i>
                                    <span>Lihat Fail</span>
                                </a>
                                <% } %>
                            </div>
                            <p class="text-[9px] text-slate-400 mt-2 italic px-1">* Format dibenarkan: PDF, PNG, JPG, JPEG (Max 10MB).</p>
                        </div>
                    </div>
                </div>

                <%-- Divider --%>
                <div class="h-px bg-slate-100"></div>

                <%-- Section 2.5: Ahli Keluarga --%>
                <div class="space-y-6">
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 pb-4">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 rounded-xl bg-green-50 text-green-600 flex items-center justify-center text-lg shadow-inner flex-shrink-0">
                                <i class="fas fa-users text-xl"></i>
                            </div>
                            <div>
                                <h4 class="text-base font-bold text-slate-800">Maklumat Ahli Keluarga</h4>
                                <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wide">Senarai tanggungan & isi rumah</p>
                            </div>
                        </div>
                        <button type="button" onclick="showAddFamilyModal()" class="flex items-center gap-2 px-5 py-2.5 bg-green-500 hover:bg-green-600 text-white text-xs font-bold rounded-xl transition-all shadow-lg shadow-green-500/20 active:scale-95">
                            <i class="fas fa-plus"></i>
                            Tambah Ahli
                        </button>
                    </div>

                    <div id="familyContainer" class="space-y-4">
                        <%-- Existing Family Members --%>
                        <%
                            List<AhliKeluarga> family = pDetail.getSenaraiAhliKeluarga();
                            int famIndex = 0;
                            if (family != null && !family.isEmpty()) {
                                for (AhliKeluarga ak : family) {
                                    String relation = ak.getHubungan();
                                    String iconClass = "fa-user-friends text-green-600";
                                    if ("Suami".equalsIgnoreCase(relation) || "Bapa".equalsIgnoreCase(relation)) {
                                        iconClass = "fa-user-tie text-blue-600";
                                    } else if ("Isteri".equalsIgnoreCase(relation) || "Ibu".equalsIgnoreCase(relation)) {
                                        iconClass = "fa-user-nurse text-pink-600";
                                    } else if ("Anak".equalsIgnoreCase(relation)) {
                                        iconClass = "fa-child text-amber-600";
                                    } else if ("Adik-beradik".equalsIgnoreCase(relation)) {
                                        iconClass = "fa-people-arrows text-purple-600";
                                    }
                        %>
                        <div id="familyCard_<%= famIndex %>" class="family-row group relative bg-white hover:bg-green-50/10 rounded-3xl p-6 border border-gray-150 shadow-sm hover:shadow-md hover:border-green-300 transition-all duration-300 flex flex-col md:flex-row items-start md:items-center gap-6 animate-in fade-in duration-300">
                            <!-- Hidden Fields to submit with main form -->
                            <input type="hidden" name="f_index[]" class="f-index" value="<%= famIndex %>">
                            <input type="hidden" name="f_nama[]" class="f-nama" value="<%= ak.getNama_penuh() %>">
                            <input type="hidden" name="f_kp[]" class="f-kp" value="<%= ak.getNombor_kp() %>">
                            <input type="hidden" name="f_tel[]" class="f-tel" value="<%= ak.getNombor_telefon() %>">
                            <input type="hidden" name="f_umur[]" class="f-umur" value="<%= ak.getUmur() %>">
                            <input type="hidden" name="f_hubungan[]" class="f-hubungan" value="<%= ak.getHubungan() %>">
                            <input type="hidden" name="f_pekerjaan[]" class="f-pekerjaan" value="<%= ak.getPekerjaan() != null ? ak.getPekerjaan() : "" %>">
                            <input type="hidden" name="f_pendapatan[]" class="f-pendapatan" value="<%= ak.getPendapatan() != null ? ak.getPendapatan() : "" %>">
                            <input type="hidden" name="f_pengesahan_existing[]" class="f-pengesahan-existing" value="<%= ak.getPengesahan_pendapatan() != null ? ak.getPengesahan_pendapatan() : "" %>">

                            <!-- Avatar Icon -->
                            <div class="w-14 h-14 rounded-2xl bg-gray-50 flex items-center justify-center text-2xl shadow-sm border border-gray-100 group-hover:scale-105 transition-transform shrink-0">
                                <i class="card-icon fas <%= iconClass %>"></i>
                            </div>

                            <!-- Details -->
                            <div class="flex-1 min-w-0">
                                <div class="flex flex-wrap items-center gap-2 mb-2">
                                    <h5 class="card-display-nama text-sm font-extrabold text-gray-900 truncate"><%= ak.getNama_penuh() %></h5>
                                    <span class="card-display-hubungan inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-green-50 text-green-700 border border-green-200">
                                        <%= ak.getHubungan() %>
                                    </span>
                                    <span class="card-display-umur inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-200">
                                        <%= ak.getUmur() %> Tahun
                                    </span>
                                </div>

                                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-xs font-semibold text-gray-500">
                                    <div>
                                        <span class="block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">No. KP</span>
                                        <span class="card-display-kp text-gray-800"><%= ak.getNombor_kp() != null && !ak.getNombor_kp().isEmpty() ? ak.getNombor_kp() : "-" %></span>
                                    </div>
                                    <div>
                                        <span class="block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">No. Telefon</span>
                                        <span class="card-display-tel text-gray-800"><%= ak.getNombor_telefon() != null && !ak.getNombor_telefon().isEmpty() ? ak.getNombor_telefon() : "-" %></span>
                                    </div>
                                    <div>
                                        <span class="block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Pekerjaan</span>
                                        <span class="card-display-pekerjaan text-gray-800"><%= ak.getPekerjaan() != null && !ak.getPekerjaan().isEmpty() ? ak.getPekerjaan() : "Tiada" %></span>
                                    </div>
                                    <div>
                                        <span class="block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5">Pendapatan</span>
                                        <span class="card-display-pendapatan text-gray-800 font-bold text-blue-600">
                                            <%= ak.getPendapatan() != null ? "RM " + String.format("%.2f", ak.getPendapatan()) : "RM 0.00" %>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Document and Actions -->
                            <div class="flex items-center gap-3 w-full md:w-auto shrink-0 md:justify-end border-t md:border-t-0 pt-4 md:pt-0">
                                <div class="card-display-dokumen flex items-center shrink-0">
                                    <% if (ak.getPengesahan_pendapatan() != null && !ak.getPengesahan_pendapatan().isEmpty()) { %>
                                    <a href="<%= request.getContextPath() %>/file/pendapatan/<%= ak.getPengesahan_pendapatan() %>" target="_blank" 
                                        class="px-3.5 py-2.5 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-xl flex items-center justify-center gap-2 text-[11px] font-bold transition-all whitespace-nowrap active:scale-95 shadow-sm">
                                        <i class="fas fa-file-pdf"></i>
                                        <span>Lihat Fail</span>
                                    </a>
                                    <% } else { %>
                                    <span class="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-gray-50 border border-gray-200 text-gray-400 text-[10px] font-bold">
                                        <i class="fas fa-exclamation-circle text-xs"></i>
                                        Tiada Dokumen
                                    </span>
                                    <% } %>
                                </div>

                                <button type="button" onclick="editFamilyMember('familyCard_<%= famIndex %>')" 
                                    class="w-10 h-10 rounded-xl bg-amber-50 text-amber-600 hover:bg-amber-500 hover:text-white transition-all flex items-center justify-center active:scale-95 shrink-0" 
                                    title="Kemaskini Ahli Keluarga">
                                    <i class="fas fa-pencil-alt text-sm"></i>
                                </button>

                                <button type="button" onclick="removeFamilyRow(this)" 
                                    class="w-10 h-10 rounded-xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all flex items-center justify-center active:scale-95 shrink-0" 
                                    title="Hapus Ahli Keluarga">
                                    <i class="fas fa-trash-alt text-sm"></i>
                                </button>
                            </div>
                        </div>
                        <%
                                    famIndex++;
                                }
                            } else {
                        %>
                        <div id="emptyFamily" class="text-center py-12 bg-gray-50/50 rounded-3xl border-2 border-dashed border-gray-200 animate-in fade-in duration-300">
                            <div class="w-14 h-14 rounded-full bg-white mx-auto flex items-center justify-center text-gray-300 mb-3 shadow-inner">
                                <i class="fas fa-users text-xl"></i>
                            </div>
                            <p class="text-xs text-gray-400 font-bold uppercase tracking-wider">Tiada Maklumat Ahli Keluarga</p>
                            <p class="text-[10px] text-gray-400 mt-1">Sila klik "+ Tambah Ahli" di atas untuk mula mengisi.</p>
                        </div>
                        <% } %>
                    </div>
                </div>

                <%-- Divider --%>
                <div class="h-px bg-slate-100"></div>

                <%-- Section 3: Alamat --%>
                <div class="space-y-6">
                    <div class="flex items-center gap-4 border-b border-slate-100 pb-4">
                        <div class="w-10 h-10 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center text-lg shadow-inner flex-shrink-0">
                            <i class="fas fa-map-marked-alt text-xl"></i>
                        </div>
                        <div>
                            <h4 class="text-base font-bold text-slate-800">Alamat Kediaman</h4>
                            <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wide">Lokasi tempat tinggal tetap anda</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="md:col-span-2 lg:col-span-2">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Nama Jalan / No. Rumah</label>
                            <input type="text" name="nama_jalan" value="<%= pDetail.getNama_jalan()%>" 
                                class="w-full px-5 py-4 rounded-2xl bg-slate-50 border border-slate-200 focus:bg-white focus:ring-2 focus:ring-orange-600/20 focus:border-orange-600 text-slate-800 text-sm font-semibold transition-all">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Daerah</label>
                            <input type="text" name="daerah" value="<%= (pDetail.getDaerah() != null) ? pDetail.getDaerah() : "Selising"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-slate-100 border-none text-slate-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Poskod</label>
                            <input type="text" name="nombor_poskod" value="<%= (pDetail.getNombor_poskod() != null) ? pDetail.getNombor_poskod() : "16810"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-slate-100 border-none text-slate-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Bandar</label>
                            <input type="text" name="bandar" value="<%= (pDetail.getBandar() != null) ? pDetail.getBandar() : "Pasir Puteh"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-slate-100 border-none text-slate-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2 px-1">Negeri</label>
                            <input type="text" name="negeri" value="<%= (pDetail.getNegeri() != null) ? pDetail.getNegeri() : "Kelantan"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-slate-100 border-none text-slate-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                    </div>
                </div>

                <%-- Divider --%>
                <div class="h-px bg-slate-100"></div>

                <%-- Section 4: Lokasi Peta --%>
                <div class="space-y-6">
                    <div class="flex items-center justify-between border-b border-slate-100 pb-4">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 rounded-xl bg-red-50 text-red-600 flex items-center justify-center text-lg shadow-inner flex-shrink-0">
                                <i class="fas fa-location-dot text-xl"></i>
                            </div>
                            <div>
                                <h4 class="text-base font-bold text-slate-800">Pin Lokasi Rumah</h4>
                                <p class="text-[11px] text-slate-400 font-semibold uppercase tracking-wide">Koordinat GPS untuk rujukan kecemasan</p>
                            </div>
                        </div>
                        <div class="hidden md:block text-[9px] bg-red-50 text-red-600 font-bold px-3 py-1.5 rounded-lg border border-red-100">
                            TARIK PENANDA PADA PETA
                        </div>
                    </div>

                    <div class="mb-6">
                        <div class="relative group">
                            <span class="absolute inset-y-0 left-0 pl-5 flex items-center text-gray-400 group-focus-within:text-brand-purple transition-colors">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" id="mapSearchInput" placeholder="Cari nama jalan, taman atau mercu tanda di sini..." 
                                class="w-full pl-12 pr-28 py-4 rounded-2xl bg-slate-50 border border-slate-100 focus:ring-4 focus:ring-purple-100 focus:border-brand-purple text-sm font-bold shadow-sm transition-all outline-none"
                                onkeydown="handleMapSearch(event)">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-2">
                                <button type="button" onclick="performMapSearch()" class="px-5 py-2.5 bg-brand-purple text-white text-xs font-black rounded-xl hover:bg-brand-purpleHover transition-all shadow-md active:scale-95 flex items-center gap-2">
                                    <i class="fas fa-search-location"></i>
                                    <span>Cari</span>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="relative rounded-3xl overflow-hidden border-4 border-slate-50 shadow-inner group">
                        <div id="mapProfil" style="height: 400px; z-index: 0;" class="w-full transition-transform duration-700"></div>
                        <div class="absolute bottom-4 left-4 right-4 flex gap-4 pointer-events-none">
                            <div class="bg-white/90 backdrop-blur-sm px-4 py-2 rounded-xl shadow-lg border border-slate-100 pointer-events-auto flex items-center gap-3">
                                <i class="fas fa-crosshairs text-brand-purple animate-pulse"></i>
                                <span class="text-[10px] font-bold text-gray-600 tracking-tight" id="coord-display">Sila pilih lokasi</span>
                            </div>
                        </div>
                    </div>
                    
                    <input type="hidden" name="latitude" id="latInput" value="<%= (pDetail.getLatitude() != null) ? pDetail.getLatitude() : ""%>">
                    <input type="hidden" name="longitude" id="lonInput" value="<%= (pDetail.getLongitude() != null) ? pDetail.getLongitude() : ""%>">
                </div>

                <%-- Divider --%>
                <div class="h-px bg-slate-100"></div>

                <%-- Action Bar Section --%>
                <div class="flex flex-col md:flex-row gap-6 items-center justify-between pt-4">
                    <div class="flex items-center gap-4 px-6 py-3 bg-slate-50 rounded-2xl border border-slate-100 shadow-inner">
                        <div class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div>
                        <span class="text-xs font-bold text-slate-500">Sedia untuk disimpan</span>
                    </div>
                    <button type="submit" class="w-full md:w-auto px-12 py-5 bg-gradient-to-r from-brand-purple to-brand-secondary hover:shadow-2xl hover:shadow-purple-500/40 text-white font-black rounded-2xl transition-all duration-300 flex items-center justify-center gap-4 transform hover:-translate-y-1 active:scale-[0.98]">
                        <i class="fas fa-save text-xl"></i>
                        <span class="tracking-wide">SIMPAN SEMUA PERUBAHAN</span>
                    </button>
                </div>

            </div>
        </form>

        <% if ("Ketua Kampung".equalsIgnoreCase(pDetail.getNama_peranan())) { %>
            <%-- E-Tandatangan & Cap Rasmi Section --%>
            <div class="mt-12 bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500">
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-12 h-12 rounded-2xl bg-purple-50 flex items-center justify-center text-[#6C5DD3] shadow-inner">
                        <i class="fas fa-file-signature text-xl"></i>
                    </div>
                    <div>
                        <h4 class="text-lg font-bold text-gray-900">E-Tandatangan & Cap Rasmi Kampung</h4>
                        <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Daftarkan tandatangan digital dan muat naik cap rasmi untuk kegunaan pengesahan dokumen bantuan.</p>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <%-- Tandatangan Digital Card --%>
                    <div class="bg-slate-50/50 p-6 rounded-[2rem] border border-slate-100 flex flex-col justify-between min-h-[350px]">
                        <div>
                            <h5 class="text-sm font-bold text-gray-800 mb-2 flex items-center gap-2">
                                <i class="fas fa-pen-fancy text-purple-500"></i> Tandatangan Digital (Melukis)
                            </h5>
                            <p class="text-[11px] text-gray-400 mb-4">Gunakan tetikus (mouse) atau skrin sentuh untuk melukis tandatangan Ketua Kampung di bawah.</p>
                            
                            <div class="relative w-full aspect-[4/2] bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-inner flex items-center justify-center">
                                <canvas id="signature-pad" class="absolute inset-0 w-full h-full cursor-crosshair"></canvas>
                                <div id="no-signature-tip" class="text-xs text-gray-300 pointer-events-none select-none flex flex-col items-center gap-2">
                                    <i class="fas fa-hand-pointer text-xl animate-bounce"></i>
                                    <span>Klik & seret untuk melukis di sini</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-6 flex flex-col gap-4">
                            <%-- Saved signature preview --%>
                            <div id="saved-sig-box" class="<%= (pDetail.getDigital_signature() != null) ? "" : "hidden" %>">
                                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2">Tandatangan Aktif Semasa:</p>
                                <div class="bg-white rounded-xl border border-gray-100 p-2 max-w-[180px] aspect-[4/2] flex items-center justify-center">
                                    <img id="saved-signature-img" src="<%= (pDetail.getDigital_signature() != null) ? pDetail.getDigital_signature() : "" %>" class="max-h-full max-w-full object-contain">
                                </div>
                            </div>
                            
                            <div class="flex gap-2">
                                <button type="button" onclick="clearSignatureCanvas()" class="px-5 py-3 bg-gray-100 text-gray-600 text-xs font-bold rounded-xl hover:bg-gray-200 transition-all flex items-center justify-center gap-2">
                                    <i class="fas fa-eraser"></i> Padam
                                </button>
                                <button type="button" onclick="saveSignatureCanvas()" class="flex-1 px-5 py-3 bg-[#6C5DD3] text-white text-xs font-bold rounded-xl hover:bg-[#5b4eb8] transition-all shadow-md shadow-purple-200 flex items-center justify-center gap-2">
                                    <i class="fas fa-save"></i> Simpan Tandatangan
                                </button>
                            </div>
                        </div>
                    </div>

                    <%-- Cap Rasmi Kampung Card --%>
                    <div class="bg-slate-50/50 p-6 rounded-[2rem] border border-slate-100 flex flex-col justify-between min-h-[350px]">
                        <div>
                            <h5 class="text-sm font-bold text-gray-800 mb-2 flex items-center gap-2">
                                <i class="fas fa-stamp text-blue-500"></i> Cap Rasmi Kampung (Muat Naik)
                            </h5>
                            <p class="text-[11px] text-gray-400 mb-4">Muat naik gambar cap rasmi kampung (Format PNG dengan latar belakang lutsinar/transparent amat digalakkan).</p>
                            
                            <div class="relative w-full aspect-[4/2] bg-white rounded-2xl border border-gray-200 border-dashed overflow-hidden shadow-inner flex flex-col items-center justify-center p-4">
                                <input type="file" id="stamp-file-input" accept="image/png,image/jpeg,image/jpg" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" onchange="previewStampFile(this)">
                                <div id="stamp-upload-placeholder" class="text-center flex flex-col items-center gap-2 pointer-events-none">
                                    <i class="fas fa-cloud-upload-alt text-2xl text-blue-400"></i>
                                    <span class="text-xs font-bold text-gray-500">Klik / Seret fail imej di sini</span>
                                    <span class="text-[9px] text-gray-400">Format: PNG / JPG (Max 5MB)</span>
                                </div>
                                <div id="stamp-preview-container" class="hidden absolute inset-0 bg-white p-2 flex items-center justify-center">
                                    <img id="stamp-preview-img" class="max-h-full max-w-full object-contain">
                                </div>
                            </div>
                        </div>

                        <div class="mt-6 flex flex-col gap-4">
                            <%-- Saved stamp preview --%>
                            <div id="saved-stamp-box" class="<%= (pDetail.getOfficial_stamp() != null) ? "" : "hidden" %>">
                                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-2">Cap Aktif Semasa:</p>
                                <div class="bg-white rounded-xl border border-gray-100 p-2 max-w-[180px] aspect-[4/2] flex items-center justify-center">
                                    <img id="saved-stamp-img" src="<%= (pDetail.getOfficial_stamp() != null) ? pDetail.getOfficial_stamp() : "" %>" class="max-h-full max-w-full object-contain">
                                </div>
                            </div>

                            <div class="flex gap-2">
                                <button type="button" id="btn-cancel-stamp" onclick="cancelStampUpload()" class="hidden px-5 py-3 bg-gray-100 text-gray-600 text-xs font-bold rounded-xl hover:bg-gray-200 transition-all flex items-center justify-center gap-2">
                                    <i class="fas fa-times"></i> Batal
                                </button>
                                <button type="button" id="btn-save-stamp" onclick="saveOfficialStamp()" class="flex-1 px-5 py-3 bg-[#6C5DD3] text-white text-xs font-bold rounded-xl hover:bg-[#5b4eb8] transition-all shadow-md shadow-purple-200 flex items-center justify-center gap-2 opacity-50 cursor-not-allowed" disabled>
                                    <i class="fas fa-save"></i> Simpan Cap Rasmi
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <%-- 
        ASIDE BAR (Right Section): 
    --%>
    <aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar shrink-0 animate-in slide-in-from-right duration-700">
        
        <%-- Quick Stats --%>
        <div class="mb-10">
            <h3 class="font-extrabold text-sm text-gray-900 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span class="w-1.5 h-4 bg-brand-purple rounded-full"></span>
                Status Profil
            </h3>
            
            <div class="bg-gradient-to-br from-gray-900 to-gray-800 rounded-3xl p-6 text-white shadow-xl relative overflow-hidden group">
                <%-- Abstract Decor --%>
                <div class="absolute -top-10 -right-10 w-32 h-32 bg-brand-purple rounded-full blur-3xl opacity-20 group-hover:opacity-40 transition-opacity"></div>
                
                <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1">Kelengkapan Data</p>
                <%
                    int progress = 0;
                    if (pDetail.getPekerjaan() != null && !pDetail.getPekerjaan().isEmpty()) progress += 33;
                    if (pDetail.getPendapatan() != null) progress += 33;
                    if (pDetail.getStatus_keluarga() != null && !pDetail.getStatus_keluarga().isEmpty()) progress += 34;
                %>
                <div class="flex items-end gap-3 mb-4">
                    <h4 class="text-4xl font-black text-white"><%= progress%>%</h4>
                    <span class="text-[10px] text-gray-400 mb-1 font-bold"><%= progress == 100 ? "LENGKAP" : "KEMASKINI" %></span>
                </div>
                
                <div class="relative w-full h-2.5 bg-white/10 rounded-full overflow-hidden mb-6">
                    <div style="width: <%= progress%>%" class="absolute top-0 left-0 h-full bg-gradient-to-r from-brand-purple to-brand-secondary rounded-full transition-all duration-1000"></div>
                </div>
                
                <div class="space-y-3">
                    <div class="flex items-center gap-2 text-[10px] font-medium <%= (pDetail.getPekerjaan() != null && !pDetail.getPekerjaan().isEmpty()) ? "text-green-400" : "text-gray-500" %>">
                        <i class="fas <%= (pDetail.getPekerjaan() != null && !pDetail.getPekerjaan().isEmpty()) ? "fa-check-circle" : "fa-circle-notch" %>"></i>
                        <span>Maklumat Kerjaya</span>
                    </div>
                    <div class="flex items-center gap-2 text-[10px] font-medium <%= (pDetail.getPendapatan() != null) ? "text-green-400" : "text-gray-500" %>">
                        <i class="fas <%= (pDetail.getPendapatan() != null) ? "fa-check-circle" : "fa-circle-notch" %>"></i>
                        <span>Maklumat Pendapatan</span>
                    </div>
                    <div class="flex items-center gap-2 text-[10px] font-medium <%= (pDetail.getStatus_keluarga() != null && !pDetail.getStatus_keluarga().isEmpty()) ? "text-green-400" : "text-gray-500" %>">
                        <i class="fas <%= (pDetail.getStatus_keluarga() != null && !pDetail.getStatus_keluarga().isEmpty()) ? "fa-check-circle" : "fa-circle-notch" %>"></i>
                        <span>Status Perkahwinan</span>
                    </div>
                </div>
            </div>
        </div>

        <%-- Security Section --%>
        <div class="mb-10">
            <h3 class="font-extrabold text-sm text-gray-900 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span class="w-1.5 h-4 bg-blue-500 rounded-full"></span>
                Keselamatan
            </h3>
            
            <button onclick="showChangePassModal()" class="w-full group relative p-4 rounded-[1.5rem] bg-blue-50/50 border border-blue-100 hover:bg-blue-100/50 transition-all text-left overflow-hidden">
                <div class="relative z-10 flex items-center gap-4">
                    <div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center text-blue-600 group-hover:scale-110 transition-transform">
                        <i class="fas fa-key"></i>
                    </div>
                    <div>
                        <p class="text-xs font-bold text-gray-900">Tukar Kata Laluan</p>
                        <p class="text-[10px] text-gray-500 font-medium">Lindungi akaun anda</p>
                    </div>
                    <i class="fas fa-chevron-right ml-auto text-blue-300 text-xs group-hover:translate-x-1 transition-transform"></i>
                </div>
            </button>
        </div>

        <%-- Activity Logs --%>
        <div class="flex-1 flex flex-col min-h-0">
            <h3 class="font-extrabold text-sm text-gray-900 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span class="w-1.5 h-4 bg-orange-500 rounded-full"></span>
                Sejarah Aktiviti
            </h3>
            
            <div class="relative flex-1 min-h-0">
                <div class="space-y-4 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar pb-12">
                    <%
                        List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("activityLogs");
                        if (logs != null && !logs.isEmpty()) {
                            for (ActivityLog log : logs) {
                    %>
                    <div class="relative pl-6 pb-2 border-l-2 border-gray-100 group">
                        <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-gray-200 group-hover:border-brand-purple transition-colors"></div>
                        <div class="bg-gray-50 rounded-2xl p-4 border border-transparent hover:border-gray-200 hover:bg-white transition-all">
                            <div class="flex justify-between items-center mb-1">
                                <span class="text-[10px] font-bold text-brand-purple bg-purple-50 px-2 py-0.5 rounded-md">ADMIN</span>
                                <span class="text-[9px] font-bold text-gray-400"><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(log.getDibuat_pada())%></span>
                            </div>
                            <p class="text-[11px] font-semibold text-gray-700 leading-snug"><%= log.getKeterangan_tindakan()%></p>
                        </div>
                    </div>
                    <%      }
                    } else { %>
                    <div class="text-center py-12 bg-gray-50 rounded-[2rem] border-2 border-dashed border-gray-200">
                        <div class="w-12 h-12 rounded-full bg-white mx-auto flex items-center justify-center text-gray-300 mb-3 shadow-sm">
                            <i class="fas fa-history"></i>
                        </div>
                        <p class="text-[11px] text-gray-400 font-bold italic tracking-wide uppercase">Tiada Rekod Aktiviti</p>
                    </div>
                    <% }%>
                </div>
                <%-- Fade Effect Overlay --%>
                <div class="absolute bottom-0 left-0 right-0 h-16 bg-gradient-to-t from-white to-transparent pointer-events-none z-10"></div>
            </div>
        </div>
    </aside>

</div>

<style>
    @keyframes fade-in-up {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in-up {
        animation: fade-in-up 0.7s ease-out forwards;
    }
    
    /* Custom Scrollbar */
    .custom-scrollbar::-webkit-scrollbar { width: 5px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 10px; }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: var(--brand-color); }

    /* Map Custom Styling */
    .leaflet-container { font-family: inherit; }
    .leaflet-bar { border: none !important; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1) !important; }
    .leaflet-bar a { background-color: white !important; color: #374151 !important; border-radius: 12px !important; margin-bottom: 4px !important; }
</style>

<%-- Modal Tukar Kata Laluan (Glass Edition) --%>
<div id="changePassModal" class="fixed inset-0 bg-gray-900/40 z-[999] hidden flex items-center justify-center backdrop-blur-md animate-in fade-in duration-300 p-4">
    <div class="bg-white/90 backdrop-blur-2xl rounded-[3rem] p-10 w-full max-w-md shadow-2xl relative border border-white/50 animate-in zoom-in-95 duration-300">
        <button onclick="hideChangePassModal()" class="absolute top-6 right-6 w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 hover:text-gray-600 transition hover:scale-110 active:scale-95">
            <i class="fas fa-times"></i>
        </button>
        
        <div class="text-center mb-8">
            <div class="w-16 h-16 bg-blue-50 rounded-2xl flex items-center justify-center text-blue-600 text-2xl mx-auto mb-4 shadow-inner">
                <i class="fas fa-user-shield"></i>
            </div>
            <h3 class="text-2xl font-black text-gray-900 tracking-tight">Tukar Kata Laluan</h3>
            <p class="text-gray-500 text-sm mt-1 font-medium">Sila pastikan kata laluan anda kukuh.</p>
        </div>

        <form action="<%= request.getContextPath()%>/profil/update?action=changePassword" method="post" class="space-y-6" onsubmit="return confirmAction(event, 'Tukar Kata Laluan?', 'Tindakan ini akan menukar akses akaun anda. Adakah anda pasti?', 'Ya, Tukar!', '#3B82F6')">
            <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
            <div class="space-y-4">
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Kata Laluan Lama</label>
                    <div class="relative">
                        <i class="fas fa-lock-open absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-brand-purple transition-colors"></i>
                        <input type="password" name="oldPassword" required 
                            class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-sm font-semibold transition-all">
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Kata Laluan Baharu</label>
                    <div class="relative">
                        <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-brand-purple transition-colors"></i>
                        <input type="password" name="newPassword" required minlength="6" 
                            class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-brand-purple/20 focus:border-brand-purple text-sm font-semibold transition-all">
                    </div>
                </div>
            </div>
            
            <div class="flex flex-col gap-3 pt-4">
                <button type="submit" class="w-full py-4 bg-gradient-to-r from-brand-purple to-brand-secondary text-white font-bold rounded-2xl shadow-lg shadow-purple-500/20 hover:scale-[1.02] active:scale-95 transition-all">
                    Kemaskini Kata Laluan
                </button>
                <button type="button" onclick="hideChangePassModal()" class="w-full py-4 text-gray-500 font-bold hover:text-gray-700 transition">
                    Batal
                </button>
            </div>
        </form>
    </div>
</div>

<%-- Modal Tambah Ahli Keluarga (Glass Edition) --%>
<div id="addFamilyModal" class="fixed inset-0 bg-gray-900/40 z-[999] hidden flex items-center justify-center backdrop-blur-md animate-in fade-in duration-300 p-4">
    <div class="bg-white/95 backdrop-blur-2xl rounded-[3rem] p-8 md:p-10 w-full max-w-2xl shadow-2xl relative border border-white/50 animate-in zoom-in-95 duration-300 max-h-[90vh] overflow-y-auto custom-scrollbar">
        <button type="button" onclick="hideAddFamilyModal()" class="absolute top-6 right-6 w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center text-gray-400 hover:text-gray-600 transition hover:scale-110 active:scale-95">
            <i class="fas fa-times"></i>
        </button>
        <div class="text-center mb-8">
            <div class="w-16 h-16 bg-green-50 rounded-2xl flex items-center justify-center text-green-600 text-2xl mx-auto mb-4 shadow-inner">
                <i class="fas fa-user-plus animate-pulse"></i>
            </div>
            <h3 class="text-2xl font-black text-gray-900 tracking-tight">Tambah Ahli Keluarga</h3>
            <p class="text-gray-500 text-sm mt-1 font-medium">Lengkapkan maklumat ahli keluarga di bawah.</p>
        </div>
        <div class="space-y-6">
            <div class="group">
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Nama Penuh <span class="text-red-500">*</span></label>
                <div class="relative">
                    <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                    <input type="text" id="m_nama" placeholder="Nama penuh ahli keluarga" onkeypress="return !/[0-9]/.test(event.key)" oninput="this.value = this.value.replace(/[0-9]/g, '')" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                </div>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">No. Kad Pengenalan</label>
                    <div class="relative">
                        <i class="fas fa-id-badge absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                        <input type="text" id="m_kp" oninput="formatIC(this)" onblur="checkKPDuplicate(this.value)" maxlength="14" placeholder="000000-00-0000" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                    </div>
                    <div id="kpDuplicateWarning" class="hidden mt-2 px-3 py-2 bg-amber-50 border border-amber-200 rounded-xl flex items-center gap-2 text-[11px] text-amber-700 font-semibold animate-in fade-in duration-300">
                        <i class="fas fa-exclamation-triangle text-amber-500"></i>
                        <span>No. KP ini sudah wujud sebagai penduduk berdaftar dalam sistem. Ahli ini tidak akan dikira dua kali dalam senarai penduduk.</span>
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">No. Telefon</label>
                    <div class="relative">
                        <i class="fas fa-phone absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                        <input type="text" id="m_tel" oninput="formatPhoneNumber(this)" maxlength="13" placeholder="012-3456789" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Umur</label>
                    <div class="relative">
                        <i class="fas fa-birthday-cake absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                        <input type="number" id="m_umur" placeholder="0" min="0" max="150" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Hubungan</label>
                    <div class="relative">
                        <i class="fas fa-heart absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors z-10"></i>
                        <select id="m_hubungan" class="w-full pl-12 pr-10 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-gray-800 text-sm font-semibold transition-all appearance-none">
                            <option value="Suami">Suami</option>
                            <option value="Isteri">Isteri</option>
                            <option value="Anak">Anak</option>
                            <option value="Ibu">Ibu</option>
                            <option value="Bapa">Bapa</option>
                            <option value="Adik-beradik">Adik-beradik</option>
                            <option value="Lain-lain">Lain-lain</option>
                        </select>
                        <i class="fas fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none text-xs"></i>
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Pekerjaan</label>
                    <div class="relative">
                        <i class="fas fa-briefcase absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                        <input type="text" id="m_pekerjaan" placeholder="Suri Rumah, Pelajar, dll." onkeypress="return /^[a-zA-Z\s'-]$/.test(event.key)" oninput="this.value = this.value.replace(/[^a-zA-Z\s'-]/g, '')" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Pendapatan Bulanan (RM)</label>
                    <div class="relative">
                        <div class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold text-sm group-focus-within:text-green-600 transition-colors">RM</div>
                        <input type="number" step="0.01" id="m_pendapatan" placeholder="0.00" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-sm font-semibold transition-all">
                    </div>
                </div>
            </div>
            <div class="group">
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Dokumen Pengesahan Pendapatan</label>
                <div class="relative" id="modalFileContainer">
                    <i class="fas fa-file-invoice-dollar absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors"></i>
                    <input type="file" id="modalFile" accept=".pdf,.png,.jpg,.jpeg" class="w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-100 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-gray-800 text-xs font-semibold transition-all file:mr-4 file:py-1.5 file:px-3 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:bg-green-100 file:text-green-600 hover:file:bg-green-200 file:cursor-pointer">
                </div>
                <p class="text-[10px] text-gray-400 mt-2 italic px-1">* Sila muat naik fail slip gaji atau penyata jika ada (PDF/PNG/JPG/JPEG, Max 10MB).</p>
            </div>
            <div class="flex flex-col sm:flex-row gap-3 pt-6">
                <button type="button" onclick="saveFamilyMemberFromModal()" class="w-full py-4 bg-gradient-to-r from-green-500 to-emerald-600 text-white font-bold rounded-2xl shadow-lg shadow-green-500/20 hover:scale-[1.02] active:scale-95 transition-all flex items-center justify-center gap-2">
                    <i class="fas fa-save"></i>
                    Simpan Ahli Keluarga
                </button>
                <button type="button" onclick="hideAddFamilyModal()" class="w-full py-4 text-gray-500 font-bold hover:text-gray-700 transition">
                    Batal
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    // Senarai No. KP penduduk berdaftar (current user's KP) untuk semakan pertindihan client-side
    const currentUserKP = '<%= pDetail.getNombor_kp() %>';
    
    function checkKPDuplicate(kpValue) {
        const warning = document.getElementById('kpDuplicateWarning');
        if (!kpValue || kpValue.trim() === '') {
            warning.classList.add('hidden');
            return;
        }
        // Normalise: remove dashes and spaces for comparison
        const normalised = kpValue.replace(/[\-\s]/g, '');
        const normalised_current = currentUserKP.replace(/[\-\s]/g, '');
        
        // Check against current user's own KP
        if (normalised === normalised_current) {
            warning.classList.remove('hidden');
            return;
        }
        
        // Check against existing family members already on the page
        const existingKPs = document.querySelectorAll('.f-kp');
        for (const el of existingKPs) {
            const existingNorm = el.value.replace(/[\-\s]/g, '');
            if (existingNorm === normalised && existingNorm !== '') {
                warning.classList.remove('hidden');
                warning.querySelector('span').textContent = 
                    'No. KP ini sudah didaftarkan sebagai ahli keluarga anda. Sila semak semula.';
                return;
            }
        }
        
        warning.classList.add('hidden');
    }
</script>

<script>
    function confirmAction(e, title, text, confirmButtonText, confirmButtonColor) {
        e.preventDefault();
        const form = e.target;
        
        const namaInput = form.querySelector('input[name="nama_penuh"]');
        if (namaInput && /[0-9]/.test(namaInput.value)) {
            Swal.fire({
                title: 'Ralat Nama',
                text: 'Nama Penuh tidak boleh mengandungi nombor.',
                icon: 'error',
                confirmButtonColor: confirmButtonColor,
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return false;
        }

        const emailInput = form.querySelector('input[name="email"]');
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (emailInput && !emailRegex.test(emailInput.value)) {
            Swal.fire({
                title: 'Ralat Emel',
                text: 'Format emel tidak sah. Sila ikuti format cth: ali.03_bantuan@v2-kampung.edu.my',
                icon: 'error',
                confirmButtonColor: confirmButtonColor,
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return false;
        }

        const pekerjaanInput = form.querySelector('input[name="pekerjaan"]');
        if (pekerjaanInput && /[^a-zA-Z\s'-]/.test(pekerjaanInput.value)) {
            Swal.fire({
                title: 'Ralat Pekerjaan',
                text: 'Pekerjaan hanya boleh mengandungi huruf, ruang kosong dan tanda sempang.',
                icon: 'error',
                confirmButtonColor: confirmButtonColor,
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return false;
        }

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

    function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                document.getElementById('previewFoto').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
    function showChangePassModal() {
        document.getElementById('changePassModal').classList.remove('hidden');
    }
    function hideChangePassModal() {
        document.getElementById('changePassModal').classList.add('hidden');
    }

    let familyCounter = <%= famIndex %>;
    let editCardId = null;

    function showAddFamilyModal() {
        editCardId = null;
        
        // Reset modal title and button text for add mode
        document.getElementById('addFamilyModal').querySelector('h3').innerText = 'Tambah Ahli Keluarga';
        document.getElementById('addFamilyModal').querySelector('button[onclick="saveFamilyMemberFromModal()"]').innerHTML = '<i class="fas fa-save"></i> Simpan Ahli Keluarga';

        document.getElementById('m_nama').value = '';
        document.getElementById('m_kp').value = '';
        document.getElementById('m_tel').value = '';
        document.getElementById('m_umur').value = '';
        document.getElementById('m_hubungan').value = 'Suami';
        document.getElementById('m_pekerjaan').value = '';
        document.getElementById('m_pendapatan').value = '';
        
        // Re-create the file input inside modal to clear selection
        document.getElementById('modalFileContainer').innerHTML = 
            "<i class='fas fa-file-invoice-dollar absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors'></i>" +
            "<input type='file' id='modalFile' accept='.pdf,.png,.jpg,.jpeg' " +
            "    class='w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-150 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-gray-800 text-xs font-semibold transition-all file:mr-4 file:py-1.5 file:px-3 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:bg-green-100 file:text-green-600 hover:file:bg-green-200 file:cursor-pointer'>";

        document.getElementById('addFamilyModal').classList.remove('hidden');
    }

    function editFamilyMember(cardId) {
        editCardId = cardId;
        const card = document.getElementById(cardId);
        
        // Set modal title and button text for edit mode
        document.getElementById('addFamilyModal').querySelector('h3').innerText = 'Kemaskini Ahli Keluarga';
        document.getElementById('addFamilyModal').querySelector('button[onclick="saveFamilyMemberFromModal()"]').innerHTML = '<i class="fas fa-save"></i> Kemaskini Ahli Keluarga';

        // Load values from hidden fields
        document.getElementById('m_nama').value = card.querySelector('.f-nama').value;
        document.getElementById('m_kp').value = card.querySelector('.f-kp').value;
        document.getElementById('m_tel').value = card.querySelector('.f-tel').value;
        document.getElementById('m_umur').value = card.querySelector('.f-umur').value;
        document.getElementById('m_hubungan').value = card.querySelector('.f-hubungan').value;
        document.getElementById('m_pekerjaan').value = card.querySelector('.f-pekerjaan').value;
        document.getElementById('m_pendapatan').value = card.querySelector('.f-pendapatan').value;

        // Clear modal file input selection
        document.getElementById('modalFileContainer').innerHTML = 
            "<i class='fas fa-file-invoice-dollar absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-green-600 transition-colors'></i>" +
            "<input type='file' id='modalFile' accept='.pdf,.png,.jpg,.jpeg' " +
            "    class='w-full pl-12 pr-4 py-3.5 rounded-2xl bg-gray-50 border border-gray-150 focus:bg-white focus:ring-2 focus:ring-green-500/20 focus:border-green-500 text-gray-800 text-xs font-semibold transition-all file:mr-4 file:py-1.5 file:px-3 file:rounded-xl file:border-0 file:text-[10px] file:font-black file:bg-green-100 file:text-green-600 hover:file:bg-green-200 file:cursor-pointer'>";

        document.getElementById('addFamilyModal').classList.remove('hidden');
    }

    function hideAddFamilyModal() {
        document.getElementById('addFamilyModal').classList.add('hidden');
    }

    function saveFamilyMemberFromModal() {
        const nama = document.getElementById('m_nama').value.trim();
        if (!nama) {
            Swal.fire({
                title: 'Ralat',
                text: 'Sila masukkan Nama Penuh ahli keluarga.',
                icon: 'warning',
                confirmButtonColor: '#10B981',
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return;
        }

        if (/[0-9]/.test(nama)) {
            Swal.fire({
                title: 'Ralat Nama',
                text: 'Nama Penuh ahli keluarga tidak boleh mengandungi nombor.',
                icon: 'warning',
                confirmButtonColor: '#10B981',
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return;
        }

        const kp = document.getElementById('m_kp').value.trim();
        const tel = document.getElementById('m_tel').value.trim();
        const umurVal = document.getElementById('m_umur').value;
        const umur = umurVal ? parseInt(umurVal) : 0;
        const hubungan = document.getElementById('m_hubungan').value;
        const pekerjaan = document.getElementById('m_pekerjaan').value.trim();

        if (pekerjaan && /[^a-zA-Z\s'-]/.test(pekerjaan)) {
            Swal.fire({
                title: 'Ralat Pekerjaan',
                text: 'Pekerjaan ahli keluarga hanya boleh mengandungi huruf, ruang kosong dan tanda sempang.',
                icon: 'warning',
                confirmButtonColor: '#10B981',
                customClass: {
                    popup: 'rounded-[2rem]',
                    confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                }
            });
            return;
        }

        const pendapatanVal = document.getElementById('m_pendapatan').value;
        const pendapatan = pendapatanVal ? parseFloat(pendapatanVal) : 0.0;
        const fileInput = document.getElementById('modalFile');
        const hasFile = fileInput && fileInput.files && fileInput.files.length > 0;

        let iconClass = 'fa-user-friends text-green-600';
        if (['Suami', 'Bapa'].includes(hubungan)) {
            iconClass = 'fa-user-tie text-blue-600';
        } else if (['Isteri', 'Ibu'].includes(hubungan)) {
            iconClass = 'fa-user-nurse text-pink-600';
        } else if (hubungan === 'Anak') {
            iconClass = 'fa-child text-amber-600';
        } else if (hubungan === 'Adik-beradik') {
            iconClass = 'fa-people-arrows text-purple-600';
        }

        const incomeFormatted = 'RM ' + pendapatan.toFixed(2);

        const isEdit = editCardId !== null;
        const confirmTitle = isEdit ? 'Kemaskini Ahli Keluarga?' : 'Tambah Ahli Keluarga?';
        const confirmText = isEdit 
            ? 'Adakah anda pasti mahu mengemaskini maklumat ahli keluarga ini?' 
            : 'Adakah anda pasti mahu menambah ahli keluarga ini?';
        const confirmBtnText = isEdit ? 'Ya, Kemaskini' : 'Ya, Tambah';
        const confirmBtnColor = isEdit ? '#D97706' : '#10B981';

        Swal.fire({
            title: confirmTitle,
            text: confirmText,
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: confirmBtnColor,
            cancelButtonColor: '#9CA3AF',
            confirmButtonText: confirmBtnText,
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                if (isEdit) {
                    // EDIT MODE
                    const card = document.getElementById(editCardId);
                    
                    // Update hidden inputs
                    card.querySelector('.f-nama').value = nama;
                    card.querySelector('.f-kp').value = kp;
                    card.querySelector('.f-tel').value = tel;
                    card.querySelector('.f-umur').value = umur;
                    card.querySelector('.f-hubungan').value = hubungan;
                    card.querySelector('.f-pekerjaan').value = pekerjaan;
                    card.querySelector('.f-pendapatan').value = pendapatan;

                    // Update visible fields
                    card.querySelector('.card-icon').className = 'card-icon fas ' + iconClass;
                    card.querySelector('.card-display-nama').innerText = nama;
                    card.querySelector('.card-display-hubungan').innerText = hubungan;
                    card.querySelector('.card-display-umur').innerText = umur + ' Tahun';
                    card.querySelector('.card-display-kp').innerText = kp ? kp : '-';
                    card.querySelector('.card-display-tel').innerText = tel ? tel : '-';
                    card.querySelector('.card-display-pekerjaan').innerText = pekerjaan ? pekerjaan : 'Tiada';
                    card.querySelector('.card-display-pendapatan').innerText = incomeFormatted;

                    // Update file if user selected a new one
                    if (hasFile) {
                        // Get f_index[] value
                        const idx = card.querySelector('.f-index').value;
                        
                        // Remove previous file input in card if exists
                        const oldFileInput = card.querySelector('input[type="file"]');
                        if (oldFileInput) oldFileInput.remove();
                        
                        // Clear f_pengesahan_existing value since we are uploading a new file
                        card.querySelector('.f-pengesahan-existing').value = '';

                        // Move/append new file input to card
                        fileInput.id = 'f_file_' + idx;
                        fileInput.name = 'f_pengesahan_pendapatan_' + idx;
                        fileInput.style.display = 'none';
                        fileInput.className = 'hidden';
                        card.appendChild(fileInput);

                        // Update document badge inside card
                        card.querySelector('.card-display-dokumen').innerHTML = 
                            "<span class='inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-blue-50 border border-blue-200 text-blue-600 text-[10px] font-bold animate-in zoom-in-95 duration-200'>" +
                            "    <i class='fas fa-file-invoice-dollar text-xs'></i>" +
                            "    Fail Baru Dimuat Naik" +
                            "</span>";
                    }

                    hideAddFamilyModal();
                } else {
                    // ADD MODE
                    const container = document.getElementById('familyContainer');
                    const emptyMsg = document.getElementById('emptyFamily');
                    if (emptyMsg) emptyMsg.remove();

                    const idx = familyCounter++;

                    const card = document.createElement('div');
                    card.id = 'familyCard_' + idx;
                    card.className = 'family-row group relative bg-white hover:bg-green-50/10 rounded-3xl p-6 border border-gray-150 shadow-sm hover:shadow-md hover:border-green-300 transition-all duration-300 flex flex-col md:flex-row items-start md:items-center gap-6 animate-in slide-in-from-bottom-4 duration-300';
                    
                    let docBadgeHtml = '';
                    if (hasFile) {
                        docBadgeHtml = "<span class='inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-blue-50 border border-blue-200 text-blue-600 text-[10px] font-bold'>" +
                                       "    <i class='fas fa-file-invoice-dollar text-xs'></i>" +
                                       "    Fail Dimuat Naik" +
                                       "</span>";
                    } else {
                        docBadgeHtml = "<span class='inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-gray-50 border border-gray-200 text-gray-400 text-[10px] font-bold'>" +
                                       "    <i class='fas fa-exclamation-circle text-xs'></i>" +
                                       "    Tiada Dokumen" +
                                       "</span>";
                    }

                    card.innerHTML = 
                        "<input type='hidden' name='f_index[]' class='f-index' value='" + idx + "'>" +
                        "<input type='hidden' name='f_nama[]' class='f-nama' value='" + escapeHtml(nama) + "'>" +
                        "<input type='hidden' name='f_kp[]' class='f-kp' value='" + escapeHtml(kp) + "'>" +
                        "<input type='hidden' name='f_tel[]' class='f-tel' value='" + escapeHtml(tel) + "'>" +
                        "<input type='hidden' name='f_umur[]' class='f-umur' value='" + umur + "'>" +
                        "<input type='hidden' name='f_hubungan[]' class='f-hubungan' value='" + escapeHtml(hubungan) + "'>" +
                        "<input type='hidden' name='f_pekerjaan[]' class='f-pekerjaan' value='" + escapeHtml(pekerjaan) + "'>" +
                        "<input type='hidden' name='f_pendapatan[]' class='f-pendapatan' value='" + pendapatan + "'>" +
                        "<input type='hidden' name='f_pengesahan_existing[]' class='f-pengesahan-existing' value=''>" +
                        "" +
                        "<div class='w-14 h-14 rounded-2xl bg-gray-50 flex items-center justify-center text-2xl shadow-sm border border-gray-100 group-hover:scale-105 transition-transform shrink-0'>" +
                        "    <i class='card-icon fas " + iconClass + "'></i>" +
                        "</div>" +
                        "" +
                        "<div class='flex-1 min-w-0'>" +
                        "    <div class='flex flex-wrap items-center gap-2 mb-2'>" +
                        "        <h5 class='card-display-nama text-sm font-extrabold text-gray-900 truncate'>" + escapeHtml(nama) + "</h5>" +
                        "        <span class='card-display-hubungan inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-green-50 text-green-700 border border-green-200'>" +
                        "            " + escapeHtml(hubungan) + "" +
                        "        </span>" +
                        "        <span class='card-display-umur inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-gray-50 text-gray-600 border border-gray-200'>" +
                        "            " + umur + " Tahun" +
                        "        </span>" +
                        "    </div>" +
                        "" +
                        "<div class='grid grid-cols-2 md:grid-cols-4 gap-4 text-xs font-semibold text-gray-500'>" +
                        "        <div>" +
                        "            <span class='block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5'>No. KP</span>" +
                        "            <span class='card-display-kp text-gray-800'>" + (kp ? escapeHtml(kp) : '-') + "</span>" +
                        "        </div>" +
                        "        <div>" +
                        "            <span class='block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5'>No. Telefon</span>" +
                        "            <span class='card-display-tel text-gray-800'>" + (tel ? escapeHtml(tel) : '-') + "</span>" +
                        "        </div>" +
                        "        <div>" +
                        "            <span class='block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5'>Pekerjaan</span>" +
                        "            <span class='card-display-pekerjaan text-gray-800'>" + (pekerjaan ? escapeHtml(pekerjaan) : 'Tiada') + "</span>" +
                        "        </div>" +
                        "        <div>" +
                        "            <span class='block text-[9px] text-gray-400 font-bold uppercase tracking-wider mb-0.5'>Pendapatan</span>" +
                        "            <span class='card-display-pendapatan text-gray-800 font-bold text-blue-600'>" + incomeFormatted + "</span>" +
                        "        </div>" +
                        "    </div>" +
                        "</div>" +
                        "" +
                        "<div class='flex items-center gap-3 w-full md:w-auto shrink-0 md:justify-end border-t md:border-t-0 pt-4 md:pt-0'>" +
                        "    <div class='card-display-dokumen flex items-center shrink-0'>" +
                        "        " + docBadgeHtml +
                        "    </div>" +
                        "" +
                        "    <button type='button' onclick='editFamilyMember(\"familyCard_" + idx + "\")' " +
                        "        class='w-10 h-10 rounded-xl bg-amber-50 text-amber-600 hover:bg-amber-500 hover:text-white transition-all flex items-center justify-center active:scale-95 shrink-0' " +
                        "        title='Kemaskini Ahli Keluarga'>" +
                        "        <i class='fas fa-pencil-alt text-sm'></i>" +
                        "    </button>" +
                        "" +
                        "    <button type='button' onclick='removeFamilyRow(this)' " +
                        "        class='w-10 h-10 rounded-xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all flex items-center justify-center active:scale-95 shrink-0' " +
                        "        title='Hapus Ahli Keluarga'>" +
                        "        <i class='fas fa-trash-alt text-sm'></i>" +
                        "    </button>" +
                        "</div>";

                    if (hasFile) {
                        fileInput.id = 'f_file_' + idx;
                        fileInput.name = 'f_pengesahan_pendapatan_' + idx;
                        fileInput.style.display = 'none';
                        fileInput.className = 'hidden';
                        card.appendChild(fileInput);
                    }

                    container.appendChild(card);
                    hideAddFamilyModal();
                }
            }
        });
    }

    function removeFamilyRow(btn) {
        Swal.fire({
            title: 'Hapus Ahli Keluarga?',
            text: "Adakah anda pasti mahu memadam ahli keluarga ini dari senarai?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#EF4444',
            cancelButtonColor: '#9CA3AF',
            confirmButtonText: 'Ya, Hapus',
            cancelButtonText: 'Batal',
            customClass: {
                popup: 'rounded-[2rem]',
                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold',
                cancelButton: 'rounded-xl px-6 py-3 text-sm font-bold'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                const row = btn.closest('.family-row');
                row.classList.add('fade-out', 'scale-95');
                setTimeout(() => {
                    row.remove();
                    const container = document.getElementById('familyContainer');
                    if (container.querySelectorAll('.family-row').length === 0) {
                        container.innerHTML = 
                            "<div id='emptyFamily' class='text-center py-12 bg-gray-50/50 rounded-3xl border-2 border-dashed border-gray-200 animate-in fade-in duration-300'>" +
                            "    <div class='w-14 h-14 rounded-full bg-white mx-auto flex items-center justify-center text-gray-300 mb-3 shadow-inner'>" +
                            "        <i class='fas fa-users text-xl'></i>" +
                            "    </div>" +
                            "    <p class='text-xs text-gray-400 font-bold uppercase tracking-wider'>Tiada Maklumat Ahli Keluarga</p>" +
                            "    <p class='text-[10px] text-gray-400 mt-1'>Sila klik \"+ Tambah Ahli\" di atas untuk mula mengisi.</p>" +
                            "</div>";
                    }
                }, 300);
            }
        });
    }

    function escapeHtml(text) {
        if (!text) return '';
        return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    let mainMap, mainMarker;

    (function () {
        var defaultLat = 6.0289, defaultLon = 102.2935;
        var latElement = document.getElementById('latInput');
        var lonElement = document.getElementById('lonInput');
        var coordDisplay = document.getElementById('coord-display');
        
        if (!latElement || !lonElement) return;

        var initLat = latElement.value ? parseFloat(latElement.value) : defaultLat;
        var initLon = lonElement.value ? parseFloat(lonElement.value) : defaultLon;

        mainMap = L.map('mapProfil', { zoomControl: false }).setView([initLat, initLon], latElement.value ? 17 : 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap',
            className: 'map-tiles'
        }).addTo(mainMap);
        
        L.control.zoom({ position: 'topright' }).addTo(mainMap);

        mainMarker = L.marker([initLat, initLon], { draggable: true }).addTo(mainMap);
        
        if (latElement.value && lonElement.value) {
            updateDisplay({ lat: initLat, lng: initLon });
        }

        L.Control.geocoder({ 
            defaultMarkGeocode: false, 
            placeholder: 'Cari lokasi/alamat...', 
            errorMessage: 'Lokasi tidak dijumpai.' 
        }).on('markgeocode', function(e) { 
            var latlng = e.geocode.center; 
            mainMarker.setLatLng(latlng); 
            mainMap.setView(latlng, 17); 
            updateInputs(latlng); 
        }).addTo(mainMap);

        window.handleMapSearch = function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                performMapSearch();
                return false;
            }
        };

        window.performMapSearch = function() {
            const btn = document.querySelector('button[onclick="performMapSearch()"]');
            const input = document.getElementById('mapSearchInput');
            const query = input.value.trim();
            
            if (!query) return;

            // Loading state
            const originalContent = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i>';
            btn.disabled = true;

            // Optimasi carian
            let searchContext = query;
            if (!query.toLowerCase().includes("kelantan")) {
                searchContext += ", Pasir Puteh, Kelantan, Malaysia";
            }

            const url = 'https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(searchContext) + '&limit=1';

            fetch(url, {
                headers: {
                    'Accept-Language': 'ms,en'
                }
            })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                btn.innerHTML = originalContent;
                btn.disabled = false;

                if (data && data.length > 0) {
                    const r = data[0];
                    const latlng = { lat: parseFloat(r.lat), lng: parseFloat(r.lon) };
                    
                    mainMarker.setLatLng(latlng);
                    mainMap.setView(latlng, 17);
                    updateInputs(latlng);
                    
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true
                    });
                    Toast.fire({
                        icon: 'success',
                        title: 'Lokasi ditemui: ' + r.display_name.split(',')[0]
                    });
                } else {
                    // Cuba carian tanpa konteks tambahan jika gagal
                    return fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&limit=1')
                        .then(res => res.json())
                        .then(secondData => {
                            if (secondData && secondData.length > 0) {
                                const r = secondData[0];
                                const latlng = { lat: parseFloat(r.lat), lng: parseFloat(r.lon) };
                                mainMarker.setLatLng(latlng);
                                mainMap.setView(latlng, 17);
                                updateInputs(latlng);
                            } else {
                                throw new Error('No results');
                            }
                        });
                }
            })
            .catch(err => {
                btn.innerHTML = originalContent;
                btn.disabled = false;
                
                Swal.fire({
                    title: 'Carian Gagal',
                    text: 'Lokasi "' + query + '" tidak ditemui. Sila cuba alamat yang lebih umum atau gerakkan penanda secara manual.',
                    icon: 'warning',
                    confirmButtonColor: '<%= primaryColor %>',
                    customClass: {
                        popup: 'rounded-[2rem]',
                        confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                    }
                });
            });
        };

        function updateInputs(latlng) {
            latElement.value = latlng.lat.toFixed(8);
            lonElement.value = latlng.lng.toFixed(8);
            updateDisplay(latlng);
        }
        
        function updateDisplay(latlng) {
            if(coordDisplay) {
                coordDisplay.innerText = latlng.lat.toFixed(4) + ', ' + latlng.lng.toFixed(4);
            }
        }

        mainMarker.on('dragend', function (e) { updateInputs(e.target.getLatLng()); });
        mainMap.on('click', function (e) {
            mainMarker.setLatLng(e.latlng);
            updateInputs(e.latlng);
        });
        
        setTimeout(function () { mainMap.invalidateSize(); }, 300);
    })();
</script>

<% if ("Ketua Kampung".equalsIgnoreCase(pDetail.getNama_peranan())) { %>
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.2.0/dist/signature_pad.umd.min.js"></script>
    <script>
        (function() {
            var canvas = document.getElementById('signature-pad');
            var tip = document.getElementById('no-signature-tip');
            var signaturePad = null;
            
            // Adjust canvas size for high-dpi screens
            function resizeCanvas() {
                var ratio = Math.max(window.devicePixelRatio || 1, 1);
                canvas.width = canvas.offsetWidth * ratio;
                canvas.height = canvas.offsetHeight * ratio;
                canvas.getContext("2d").scale(ratio, ratio);
                if (signaturePad) signaturePad.clear();
            }
            
            signaturePad = new SignaturePad(canvas, {
                backgroundColor: 'rgba(255, 255, 255, 0)', // transparent background
                penColor: 'rgb(0, 0, 0)'
            });

            signaturePad.addEventListener("beginStroke", () => {
                tip.classList.add('hidden');
            });
            
            // Initialize sizing
            setTimeout(resizeCanvas, 300);
            window.addEventListener("resize", resizeCanvas);

            window.clearSignatureCanvas = function() {
                signaturePad.clear();
                tip.classList.remove('hidden');
            };

            window.saveSignatureCanvas = function() {
                if (signaturePad.isEmpty()) {
                    Swal.fire({
                        title: 'Melukis Terlebih Dahulu',
                        text: 'Sila lukis tandatangan anda sebelum menyimpan.',
                        icon: 'warning',
                        confirmButtonColor: '#6C5DD3',
                        customClass: {
                            popup: 'rounded-[2rem]',
                            confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                        }
                    });
                    return;
                }
                
                var base64Data = signaturePad.toDataURL("image/png");
                
                saveDataAjax("signature", base64Data, function(response) {
                    if (response.success) {
                        document.getElementById('saved-sig-box').classList.remove('hidden');
                        document.getElementById('saved-signature-img').src = base64Data;
                        Swal.fire({
                            title: 'Berjaya!',
                            text: 'Tandatangan digital anda telah disimpan.',
                            icon: 'success',
                            confirmButtonColor: '#00B69B',
                            customClass: {
                                popup: 'rounded-[2rem]',
                                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                            }
                        });
                    } else {
                        Swal.fire({
                            title: 'Gagal Menyimpan',
                            text: 'Ralat berlaku semasa menghubungi pelayan.',
                            icon: 'error',
                            confirmButtonColor: '#6C5DD3',
                            customClass: {
                                popup: 'rounded-[2rem]',
                                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                            }
                        });
                    }
                });
            };

            // Stamp Upload logic
            let stampBase64 = null;
            window.previewStampFile = function(input) {
                var file = input.files[0];
                if (!file) return;

                if (file.size > 5 * 1024 * 1024) {
                    Swal.fire({
                        title: 'Fail Terlalu Besar',
                        text: 'Had saiz fail adalah 5MB.',
                        icon: 'warning',
                        confirmButtonColor: '#6C5DD3',
                        customClass: {
                            popup: 'rounded-[2rem]',
                            confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                        }
                    });
                    input.value = "";
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    stampBase64 = e.target.result;
                    document.getElementById('stamp-preview-img').src = stampBase64;
                    document.getElementById('stamp-preview-container').classList.remove('hidden');
                    
                    var btnSave = document.getElementById('btn-save-stamp');
                    btnSave.disabled = false;
                    btnSave.classList.remove('opacity-50', 'cursor-not-allowed');
                    
                    document.getElementById('btn-cancel-stamp').classList.remove('hidden');
                };
                reader.readAsDataURL(file);
            };

            window.cancelStampUpload = function() {
                document.getElementById('stamp-file-input').value = "";
                document.getElementById('stamp-preview-container').classList.add('hidden');
                document.getElementById('stamp-preview-img').src = "";
                stampBase64 = null;
                
                var btnSave = document.getElementById('btn-save-stamp');
                btnSave.disabled = true;
                btnSave.classList.add('opacity-50', 'cursor-not-allowed');
                document.getElementById('btn-cancel-stamp').classList.add('hidden');
            };

            window.saveOfficialStamp = function() {
                if (!stampBase64) return;

                saveDataAjax("stamp", stampBase64, function(response) {
                    if (response.success) {
                        document.getElementById('saved-stamp-box').classList.remove('hidden');
                        document.getElementById('saved-stamp-img').src = stampBase64;
                        cancelStampUpload();
                        Swal.fire({
                            title: 'Berjaya!',
                            text: 'Cap rasmi kampung telah dikemaskini.',
                            icon: 'success',
                            confirmButtonColor: '#00B69B',
                            customClass: {
                                popup: 'rounded-[2rem]',
                                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                            }
                        });
                    } else {
                        Swal.fire({
                            title: 'Gagal Menyimpan',
                            text: 'Ralat berlaku semasa menghubungi pelayan.',
                            icon: 'error',
                            confirmButtonColor: '#6C5DD3',
                            customClass: {
                                popup: 'rounded-[2rem]',
                                confirmButton: 'rounded-xl px-6 py-3 text-sm font-bold'
                            }
                        });
                    }
                });
            };

            function saveDataAjax(type, base64Str, callback) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "<%= request.getContextPath() %>/profil/update", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            try {
                                var response = JSON.parse(xhr.responseText);
                                callback(response);
                            } catch(e) {
                                callback({ success: false });
                            }
                        } else {
                            callback({ success: false });
                        }
                    }
                };
                
                var body = "action=saveSignature&type=" + encodeURIComponent(type) + "&data=" + encodeURIComponent(base64Str) + "&_csrf=" + encodeURIComponent("<%= session.getAttribute("csrf_token") %>");
                xhr.send(body);
            }
        })();
    </script>
<% } %>

<%@ include file="/views/common/footer.jsp" %>
