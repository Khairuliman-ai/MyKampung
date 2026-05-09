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
                    <span class="bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] bg-clip-text text-transparent">Profil Saya</span>
                    <i class="fas fa-user-circle text-[#6C5DD3] text-2xl"></i>
                </h2>
                <p class="text-gray-500 mt-1 font-medium">Urus maklumat peribadi dan tetapan akaun anda di sini.</p>
            </div>
            
            <div class="flex items-center gap-2 text-xs font-bold text-gray-400 bg-white px-4 py-2 rounded-full shadow-sm border border-gray-100">
                <i class="fas fa-calendar-alt text-[#6C5DD3]"></i>
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
                msg = "Ralat! Berlaku masalah semasa mengemaskini maklumat.";
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

        <form action="<%= request.getContextPath()%>/profil/update" method="post" enctype="multipart/form-data" class="w-full space-y-8 animate-in fade-in slide-in-from-bottom-8 duration-1000" onsubmit="return confirmAction(event, 'Simpan Perubahan?', 'Adakah anda pasti mahu menyimpan maklumat profil yang baharu?', 'Ya, Simpan!', '#6C5DD3')">

            <%-- Profile Header Card --%>
            <div class="relative group">
                <div class="absolute -inset-1 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] rounded-[2rem] blur opacity-25 group-hover:opacity-40 transition duration-1000 group-hover:duration-200"></div>
                <div class="relative bg-white rounded-[2rem] p-8 shadow-sm border border-gray-100 flex flex-col md:flex-row items-center gap-8 overflow-hidden">
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

                    <div class="relative">
                        <div class="w-36 h-36 rounded-full p-1.5 bg-gradient-to-tr from-[#6C5DD3] to-[#8B7EF8] shadow-2xl relative">
                            <div class="w-full h-full rounded-full bg-white overflow-hidden flex items-center justify-center text-5xl font-bold text-[#6C5DD3]">
                                <% if (pDetail.getFoto_profil() != null && !pDetail.getFoto_profil().isEmpty() && !pDetail.getFoto_profil().equals("default_avatar.png")) {%>
                                <img id="previewFoto" src="<%= request.getContextPath()%>/file/profil/<%= pDetail.getFoto_profil()%>" class="w-full h-full object-cover">
                                <% } else {%>
                                <img id="previewFoto" src="https://ui-avatars.com/api/?name=<%= pDetail.getNama_penuh()%>&background=6C5DD3&color=fff&size=128" class="w-full h-full object-cover">
                                <% }%>
                            </div>
                            <label for="fotoInput" class="absolute bottom-2 right-2 w-11 h-11 bg-white text-[#6C5DD3] rounded-full flex items-center justify-center cursor-pointer shadow-xl border border-gray-100 hover:scale-110 active:scale-95 transition-all z-10">
                                <i class="fas fa-camera text-base"></i>
                                <input type="file" id="fotoInput" name="foto_profil" class="hidden" accept="image/*" onchange="previewImage(this)">
                            </label>
                        </div>
                    </div>

                    <div class="text-center md:text-left flex-1">
                        <div class="flex flex-col md:flex-row md:items-center gap-3 mb-2">
                            <h3 class="text-3xl font-extrabold text-gray-900 tracking-tight"><%= pDetail.getNama_penuh()%></h3>
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-[10px] font-bold bg-purple-100 text-[#6C5DD3] uppercase tracking-widest border border-purple-200 w-fit mx-auto md:mx-0">
                                <%= pDetail.getNama_peranan()%>
                            </span>
                        </div>
                        <p class="text-gray-500 font-medium flex items-center justify-center md:justify-start gap-2 mb-4">
                            <i class="far fa-id-card text-[#6C5DD3]"></i>
                            <%= pDetail.getNombor_kp()%>
                        </p>
                        
                        <div class="flex flex-wrap items-center justify-center md:justify-start gap-4">
                            <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded-xl border border-gray-100">
                                <i class="fas fa-envelope text-xs text-gray-400"></i>
                                <span class="text-xs font-semibold text-gray-600"><%= (pDetail.getEmail() != null) ? pDetail.getEmail() : "Tiada Email"%></span>
                            </div>
                            <div class="flex items-center gap-2 px-4 py-2 bg-gray-50 rounded-xl border border-gray-100">
                                <i class="fas fa-phone text-xs text-gray-400"></i>
                                <span class="text-xs font-semibold text-gray-600"><%= pDetail.getNombor_telefon()%></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Form Content --%>
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                
                <%-- Section 1: Peribadi --%>
                <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500 flex flex-col">
                    <div class="flex items-center gap-4 mb-8">
                        <div class="w-12 h-12 rounded-2xl bg-purple-50 flex items-center justify-center text-[#6C5DD3] shadow-inner">
                            <i class="fas fa-user-edit text-xl"></i>
                        </div>
                        <div>
                            <h4 class="text-lg font-bold text-gray-900">Maklumat Peribadi</h4>
                            <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Lengkapkan data asas anda</p>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="group">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Nama Penuh</label>
                            <div class="relative">
                                <i class="fas fa-user absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-[#6C5DD3] transition-colors"></i>
                                <input type="text" name="nama_penuh" value="<%= pDetail.getNama_penuh()%>" required 
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-[#6C5DD3]/20 focus:border-[#6C5DD3] text-gray-800 text-sm font-semibold transition-all">
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="group opacity-70">
                                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">No. Kad Pengenalan</label>
                                <%
                                    String icRaw = pDetail.getNombor_kp();
                                    String icFormatted = (icRaw != null && icRaw.length() == 12)
                                            ? icRaw.substring(0, 6) + "-" + icRaw.substring(6, 8) + "-" + icRaw.substring(8, 12) : icRaw;
                                %>
                                <div class="relative">
                                    <i class="fas fa-id-badge absolute left-4 top-1/2 -translate-y-1/2 text-gray-300"></i>
                                    <input type="text" value="<%= icFormatted%>" readonly 
                                        class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-100 border-none text-gray-400 text-sm cursor-not-allowed font-semibold">
                                </div>
                            </div>
                            <div class="group">
                                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">No. Telefon</label>
                                <div class="relative">
                                    <i class="fas fa-phone absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-[#6C5DD3] transition-colors"></i>
                                    <input type="text" name="nombor_telefon" value="<%= pDetail.getNombor_telefon()%>" required oninput="formatPhoneNumber(this)" maxlength="13" 
                                        class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-[#6C5DD3]/20 focus:border-[#6C5DD3] text-gray-800 text-sm font-semibold transition-all">
                                </div>
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Alamat Emel</label>
                            <div class="relative">
                                <i class="fas fa-envelope absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-[#6C5DD3] transition-colors"></i>
                                <input type="email" name="email" value="<%= (pDetail.getEmail() != null) ? pDetail.getEmail() : ""%>" required 
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-[#6C5DD3]/20 focus:border-[#6C5DD3] text-gray-800 text-sm font-semibold transition-all">
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Section 2: Sosio-Ekonomi --%>
                <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500 flex flex-col">
                    <div class="flex items-center gap-4 mb-8">
                        <div class="w-12 h-12 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 shadow-inner">
                            <i class="fas fa-wallet text-xl"></i>
                        </div>
                        <div>
                            <h4 class="text-lg font-bold text-gray-900">Sosio-Ekonomi</h4>
                            <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Status kewangan & keluarga</p>
                        </div>
                    </div>

                    <div class="space-y-6">
                        <div class="group">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Status Keluarga</label>
                            <div class="relative">
                                <i class="fas fa-users absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-blue-600 transition-colors z-10"></i>
                                <select name="status_keluarga" class="w-full pl-12 pr-10 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-gray-800 text-sm font-semibold transition-all appearance-none">
                                    <option value="Bujang" <%= "Bujang".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bujang</option>
                                    <option value="Berkahwin" <%= "Berkahwin".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Berkahwin</option>
                                    <option value="Ibu Tunggal" <%= "Ibu Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Ibu Tunggal</option>
                                    <option value="Bapa Tunggal" <%= "Bapa Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bapa Tunggal</option>
                                </select>
                                <i class="fas fa-chevron-down absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none text-xs"></i>
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Pekerjaan</label>
                            <div class="relative">
                                <i class="fas fa-briefcase absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-blue-600 transition-colors"></i>
                                <input type="text" name="pekerjaan" value="<%= (pDetail.getPekerjaan() != null) ? pDetail.getPekerjaan() : ""%>" 
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-gray-800 text-sm font-semibold transition-all">
                            </div>
                        </div>

                        <div class="group">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Pendapatan Bulanan (RM)</label>
                            <div class="relative">
                                <div class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold text-sm group-focus-within:text-blue-600 transition-colors">RM</div>
                                <input type="number" step="0.01" name="pendapatan" value="<%= pDetail.getPendapatan()%>" 
                                    class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-blue-600/20 focus:border-blue-600 text-gray-800 text-sm font-semibold transition-all">
                            </div>
                            <p class="text-[10px] text-gray-400 mt-2 italic px-1">* Digunakan untuk penentuan kelayakan bantuan.</p>
                        </div>
                    </div>
                </div>

                <%-- Section 2.5: Ahli Keluarga --%>
                <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500 flex flex-col lg:col-span-2">
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-2xl bg-green-50 flex items-center justify-center text-green-600 shadow-inner">
                                <i class="fas fa-users-medical text-xl"></i>
                            </div>
                            <div>
                                <h4 class="text-lg font-bold text-gray-900">Maklumat Ahli Keluarga</h4>
                                <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Senarai tanggungan & isi rumah</p>
                            </div>
                        </div>
                        <button type="button" onclick="addFamilyMember()" class="flex items-center gap-2 px-5 py-2.5 bg-green-500 hover:bg-green-600 text-white text-xs font-bold rounded-xl transition-all shadow-lg shadow-green-500/20 active:scale-95">
                            <i class="fas fa-plus"></i>
                            Tambah Ahli
                        </button>
                    </div>

                    <div id="familyContainer" class="space-y-4">
                        <%-- Existing Family Members --%>
                        <%
                            List<AhliKeluarga> family = pDetail.getSenaraiAhliKeluarga();
                            if (family != null && !family.isEmpty()) {
                                for (AhliKeluarga ak : family) {
                        %>
                        <div class="family-row group relative grid grid-cols-1 md:grid-cols-6 gap-4 p-6 bg-gray-50/50 rounded-2xl border border-gray-100 hover:bg-white hover:border-green-200 transition-all animate-in fade-in duration-300">
                            <div class="md:col-span-2">
                                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Nama Penuh</label>
                                <input type="text" name="f_nama[]" value="<%= ak.getNama_penuh() %>" placeholder="Nama Penuh" class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">No. KP</label>
                                <input type="text" name="f_kp[]" value="<%= ak.getNombor_kp() %>" 
                                    oninput="formatIC(this)" maxlength="14" placeholder="000000-00-0000" 
                                    class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
                            </div>
                            <div>
                                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">No. Tel</label>
                                <input type="text" name="f_tel[]" value="<%= ak.getNombor_telefon() %>" 
                                    oninput="formatPhoneNumber(this)" maxlength="13" placeholder="012-3456789" 
                                    class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
                            </div>
                            <div class="grid grid-cols-2 gap-2">
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Umur</label>
                                    <input type="number" name="f_umur[]" value="<%= ak.getUmur() %>" class="w-full px-3 py-2.5 rounded-xl bg-white border border-gray-200 text-xs font-semibold">
                                </div>
                                <div>
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Hubungan</label>
                                    <select name="f_hubungan[]" class="w-full px-2 py-2.5 rounded-xl bg-white border border-gray-200 text-[10px] font-bold">
                                        <option value="Suami" <%= "Suami".equals(ak.getHubungan()) ? "selected" : "" %>>Suami</option>
                                        <option value="Isteri" <%= "Isteri".equals(ak.getHubungan()) ? "selected" : "" %>>Isteri</option>
                                        <option value="Anak" <%= "Anak".equals(ak.getHubungan()) ? "selected" : "" %>>Anak</option>
                                        <option value="Ibu" <%= "Ibu".equals(ak.getHubungan()) ? "selected" : "" %>>Ibu</option>
                                        <option value="Bapa" <%= "Bapa".equals(ak.getHubungan()) ? "selected" : "" %>>Bapa</option>
                                        <option value="Adik-beradik" <%= "Adik-beradik".equals(ak.getHubungan()) ? "selected" : "" %>>Adik-beradik</option>
                                        <option value="Lain-lain" <%= "Lain-lain".equals(ak.getHubungan()) ? "selected" : "" %>>Lain-lain</option>
                                    </select>
                                </div>
                            </div>
                            <div class="flex items-center justify-between gap-4">
                                <div class="flex-1">
                                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Tanggungan?</label>
                                    <select name="f_tanggungan[]" class="w-full px-2 py-2.5 rounded-xl bg-white border border-gray-200 text-[10px] font-bold">
                                        <option value="Ya" <%= "Ya".equals(ak.getStatus_tanggungan()) ? "selected" : "" %>>Ya</option>
                                        <option value="Tidak" <%= "Tidak".equals(ak.getStatus_tanggungan()) ? "selected" : "" %>>Tidak</option>
                                    </select>
                                </div>
                                <button type="button" onclick="removeFamilyRow(this)" class="mt-4 w-10 h-10 rounded-xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all flex items-center justify-center">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                        <%      }
                            } else { %>
                            <div id="emptyFamily" class="text-center py-10 bg-gray-50/50 rounded-2xl border-2 border-dashed border-gray-200">
                                <div class="w-12 h-12 rounded-full bg-white mx-auto flex items-center justify-center text-gray-300 mb-3">
                                    <i class="fas fa-users"></i>
                                </div>
                                <p class="text-xs text-gray-400 font-bold uppercase tracking-wider">Tiada Maklumat Ahli Keluarga</p>
                                <p class="text-[10px] text-gray-400 mt-1">Sila klik "Tambah Ahli" untuk mula mengisi.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <%-- Section 3: Alamat --%>
                <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500 lg:col-span-2">
                    <div class="flex items-center gap-4 mb-8">
                        <div class="w-12 h-12 rounded-2xl bg-orange-50 flex items-center justify-center text-orange-600 shadow-inner">
                            <i class="fas fa-map-marked-alt text-xl"></i>
                        </div>
                        <div>
                            <h4 class="text-lg font-bold text-gray-900">Alamat Kediaman</h4>
                            <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Lokasi tempat tinggal tetap</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                        <div class="md:col-span-2 lg:col-span-2">
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Nama Jalan / No. Rumah</label>
                            <input type="text" name="nama_jalan" value="<%= pDetail.getNama_jalan()%>" 
                                class="w-full px-5 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-orange-600/20 focus:border-orange-600 text-gray-800 text-sm font-semibold transition-all">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Daerah</label>
                            <input type="text" name="daerah" value="<%= (pDetail.getDaerah() != null) ? pDetail.getDaerah() : "Selising"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-gray-100 border-none text-gray-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Poskod</label>
                            <input type="text" name="nombor_poskod" value="<%= (pDetail.getNombor_poskod() != null) ? pDetail.getNombor_poskod() : "16810"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-gray-100 border-none text-gray-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Bandar</label>
                            <input type="text" name="bandar" value="<%= (pDetail.getBandar() != null) ? pDetail.getBandar() : "Pasir Puteh"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-gray-100 border-none text-gray-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Negeri</label>
                            <input type="text" name="negeri" value="<%= (pDetail.getNegeri() != null) ? pDetail.getNegeri() : "Kelantan"%>" readonly 
                                class="w-full px-5 py-4 rounded-2xl bg-gray-100 border-none text-gray-500 text-sm font-semibold cursor-not-allowed">
                        </div>
                    </div>
                </div>

                <%-- Section 4: Lokasi Peta --%>
                <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:shadow-purple-500/5 transition-all duration-500 lg:col-span-2">
                    <div class="flex items-center justify-between mb-8">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-2xl bg-red-50 flex items-center justify-center text-red-600 shadow-inner">
                                <i class="fas fa-location-dot text-xl"></i>
                            </div>
                            <div>
                                <h4 class="text-lg font-bold text-gray-900">Pin Lokasi Rumah</h4>
                                <p class="text-xs text-gray-500 font-medium tracking-wide uppercase">Koordinat GPS untuk rujukan kecemasan</p>
                            </div>
                        </div>
                        <div class="hidden md:block text-[10px] bg-red-50 text-red-600 font-bold px-3 py-1.5 rounded-lg border border-red-100">
                            DRAG MARKER PADA PETA
                        </div>
                    </div>

                    <div class="relative rounded-3xl overflow-hidden border-4 border-gray-50 shadow-inner group">
                        <div id="mapProfil" style="height: 400px; z-index: 0;" class="w-full transition-transform duration-700"></div>
                        <div class="absolute bottom-4 left-4 right-4 flex gap-4 pointer-events-none">
                            <div class="bg-white/90 backdrop-blur-sm px-4 py-2 rounded-xl shadow-lg border border-gray-100 pointer-events-auto flex items-center gap-3">
                                <i class="fas fa-crosshairs text-[#6C5DD3] animate-pulse"></i>
                                <span class="text-[10px] font-bold text-gray-600 tracking-tight" id="coord-display">Sila pilih lokasi</span>
                            </div>
                        </div>
                    </div>
                    
                    <input type="hidden" name="latitude" id="latInput" value="<%= (pDetail.getLatitude() != null) ? pDetail.getLatitude() : ""%>">
                    <input type="hidden" name="longitude" id="lonInput" value="<%= (pDetail.getLongitude() != null) ? pDetail.getLongitude() : ""%>">
                </div>
            </div>

            <%-- Action Bar --%>
            <div class="sticky bottom-4 z-20">
                <div class="bg-white/80 backdrop-blur-md p-4 rounded-3xl border border-white shadow-2xl flex flex-col md:flex-row gap-4 items-center justify-between max-w-4xl mx-auto ring-1 ring-black/5">
                    <div class="flex items-center gap-3 px-4 py-2 bg-gray-50 rounded-2xl">
                        <div class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></div>
                        <span class="text-xs font-bold text-gray-500">Auto-save sedia ada</span>
                    </div>
                    <button type="submit" class="w-full md:w-auto px-10 py-4 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] hover:shadow-lg hover:shadow-purple-500/30 text-white font-bold rounded-2xl transition-all duration-300 flex items-center justify-center gap-3 active:scale-[0.98]">
                        <i class="fas fa-save text-lg"></i>
                        <span>Simpan Semua Perubahan</span>
                    </button>
                </div>
            </div>
        </form>
    </div>

    <%-- 
        ASIDE BAR (Right Section): 
    --%>
    <aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar shrink-0 animate-in slide-in-from-right duration-700">
        
        <%-- Quick Stats --%>
        <div class="mb-10">
            <h3 class="font-extrabold text-sm text-gray-900 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span class="w-1.5 h-4 bg-[#6C5DD3] rounded-full"></span>
                Status Profil
            </h3>
            
            <div class="bg-gradient-to-br from-gray-900 to-gray-800 rounded-3xl p-6 text-white shadow-xl relative overflow-hidden group">
                <%-- Abstract Decor --%>
                <div class="absolute -top-10 -right-10 w-32 h-32 bg-[#6C5DD3] rounded-full blur-3xl opacity-20 group-hover:opacity-40 transition-opacity"></div>
                
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
                    <div style="width: <%= progress%>%" class="absolute top-0 left-0 h-full bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] rounded-full transition-all duration-1000"></div>
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
                        <i class="fas fa-key-skeleton"></i>
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
        <div class="flex-1">
            <h3 class="font-extrabold text-sm text-gray-900 uppercase tracking-widest mb-6 flex items-center gap-2">
                <span class="w-1.5 h-4 bg-orange-500 rounded-full"></span>
                Sejarah Aktiviti
            </h3>
            
            <div class="space-y-4">
                <%
                    List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("activityLogs");
                    if (logs != null && !logs.isEmpty()) {
                        for (ActivityLog log : logs) {
                %>
                <div class="relative pl-6 pb-2 border-l-2 border-gray-100 group">
                    <div class="absolute -left-[9px] top-0 w-4 h-4 rounded-full bg-white border-2 border-gray-200 group-hover:border-[#6C5DD3] transition-colors"></div>
                    <div class="bg-gray-50 rounded-2xl p-4 border border-transparent hover:border-gray-200 hover:bg-white transition-all">
                        <div class="flex justify-between items-center mb-1">
                            <span class="text-[10px] font-bold text-[#6C5DD3] bg-purple-50 px-2 py-0.5 rounded-md">ADMIN</span>
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
    .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6C5DD3; }

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
                <i class="fas fa-shield-keyhole"></i>
            </div>
            <h3 class="text-2xl font-black text-gray-900 tracking-tight">Tukar Kata Laluan</h3>
            <p class="text-gray-500 text-sm mt-1 font-medium">Sila pastikan kata laluan anda kukuh.</p>
        </div>

        <form action="<%= request.getContextPath()%>/profil/update?action=changePassword" method="post" class="space-y-6" onsubmit="return confirmAction(event, 'Tukar Kata Laluan?', 'Tindakan ini akan menukar akses akaun anda. Adakah anda pasti?', 'Ya, Tukar!', '#3B82F6')">
            <div class="space-y-4">
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Kata Laluan Lama</label>
                    <div class="relative">
                        <i class="fas fa-lock-open absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-[#6C5DD3] transition-colors"></i>
                        <input type="password" name="oldPassword" required 
                            class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-[#6C5DD3]/20 focus:border-[#6C5DD3] text-sm font-semibold transition-all">
                    </div>
                </div>
                <div class="group">
                    <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">Kata Laluan Baharu</label>
                    <div class="relative">
                        <i class="fas fa-lock absolute left-4 top-1/2 -translate-y-1/2 text-gray-300 group-focus-within:text-[#6C5DD3] transition-colors"></i>
                        <input type="password" name="newPassword" required minlength="6" 
                            class="w-full pl-12 pr-4 py-4 rounded-2xl bg-gray-50 border-transparent focus:bg-white focus:ring-2 focus:ring-[#6C5DD3]/20 focus:border-[#6C5DD3] text-sm font-semibold transition-all">
                    </div>
                </div>
            </div>
            
            <div class="flex flex-col gap-3 pt-4">
                <button type="submit" class="w-full py-4 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] text-white font-bold rounded-2xl shadow-lg shadow-purple-500/20 hover:scale-[1.02] active:scale-95 transition-all">
                    Kemaskini Kata Laluan
                </button>
                <button type="button" onclick="hideChangePassModal()" class="w-full py-4 text-gray-500 font-bold hover:text-gray-700 transition">
                    Batal
                </button>
            </div>
        </form>
    </div>
</div>

<script>
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

    function addFamilyMember() {
        const container = document.getElementById('familyContainer');
        const emptyMsg = document.getElementById('emptyFamily');
        if (emptyMsg) emptyMsg.remove();

        const row = document.createElement('div');
        row.className = 'family-row group relative grid grid-cols-1 md:grid-cols-6 gap-4 p-6 bg-gray-50/50 rounded-2xl border border-gray-100 hover:bg-white hover:border-green-200 transition-all animate-in slide-in-from-right-4 duration-300';
        row.innerHTML = `
            <div class="md:col-span-2">
                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Nama Penuh</label>
                <input type="text" name="f_nama[]" placeholder="Nama Penuh" required class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
            </div>
            <div>
                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">No. KP</label>
                <input type="text" name="f_kp[]" oninput="formatIC(this)" maxlength="14" placeholder="000000-00-0000" class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
            </div>
            <div>
                <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">No. Tel</label>
                <input type="text" name="f_tel[]" oninput="formatPhoneNumber(this)" maxlength="13" placeholder="012-3456789" class="w-full px-4 py-2.5 rounded-xl bg-white border border-gray-200 focus:ring-2 focus:ring-green-500/20 text-xs font-semibold">
            </div>
            <div class="grid grid-cols-2 gap-2">
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Umur</label>
                    <input type="number" name="f_umur[]" placeholder="0" class="w-full px-3 py-2.5 rounded-xl bg-white border border-gray-200 text-xs font-semibold">
                </div>
                <div>
                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Hubungan</label>
                    <select name="f_hubungan[]" class="w-full px-2 py-2.5 rounded-xl bg-white border border-gray-200 text-[10px] font-bold">
                        <option value="Suami">Suami</option>
                        <option value="Isteri">Isteri</option>
                        <option value="Anak">Anak</option>
                        <option value="Ibu">Ibu</option>
                        <option value="Bapa">Bapa</option>
                        <option value="Adik-beradik">Adik-beradik</option>
                        <option value="Lain-lain">Lain-lain</option>
                    </select>
                </div>
            </div>
            <div class="flex items-center justify-between gap-4">
                <div class="flex-1">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase mb-1">Tanggungan?</label>
                    <select name="f_tanggungan[]" class="w-full px-2 py-2.5 rounded-xl bg-white border border-gray-200 text-[10px] font-bold">
                        <option value="Ya">Ya</option>
                        <option value="Tidak">Tidak</option>
                    </select>
                </div>
                <button type="button" onclick="removeFamilyRow(this)" class="mt-4 w-10 h-10 rounded-xl bg-red-50 text-red-500 hover:bg-red-500 hover:text-white transition-all flex items-center justify-center">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </div>
        `;
        container.appendChild(row);
    }

    function removeFamilyRow(btn) {
        const row = btn.closest('.family-row');
        row.classList.add('fade-out', 'scale-95');
        setTimeout(() => {
            row.remove();
            const container = document.getElementById('familyContainer');
            if (container.children.length === 0) {
                container.innerHTML = `
                    <div id="emptyFamily" class="text-center py-10 bg-gray-50/50 rounded-2xl border-2 border-dashed border-gray-200">
                        <div class="w-12 h-12 rounded-full bg-white mx-auto flex items-center justify-center text-gray-300 mb-3">
                            <i class="fas fa-users"></i>
                        </div>
                        <p class="text-xs text-gray-400 font-bold uppercase tracking-wider">Tiada Maklumat Ahli Keluarga</p>
                        <p class="text-[10px] text-gray-400 mt-1">Sila klik "Tambah Ahli" untuk mula mengisi.</p>
                    </div>
                `;
            }
        }, 300);
    }

    (function () {
        var defaultLat = 6.0289, defaultLon = 102.2935;
        var latElement = document.getElementById('latInput');
        var lonElement = document.getElementById('lonInput');
        var coordDisplay = document.getElementById('coord-display');
        
        if (!latElement || !lonElement) return;

        var initLat = latElement.value ? parseFloat(latElement.value) : defaultLat;
        var initLon = lonElement.value ? parseFloat(lonElement.value) : defaultLon;

        var map = L.map('mapProfil', { zoomControl: false }).setView([initLat, initLon], latElement.value ? 17 : 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap',
            className: 'map-tiles'
        }).addTo(map);
        
        L.control.zoom({ position: 'topright' }).addTo(map);

        var marker = L.marker([initLat, initLon], { draggable: true }).addTo(map);
        
        if (latElement.value && lonElement.value) {
            updateDisplay({ lat: initLat, lng: initLon });
        }

        L.Control.geocoder({ 
            defaultMarkGeocode: false, 
            placeholder: 'Cari lokasi/alamat...', 
            errorMessage: 'Lokasi tidak dijumpai.' 
        }).on('markgeocode', function(e) { 
            var latlng = e.geocode.center; 
            marker.setLatLng(latlng); 
            map.setView(latlng, 17); 
            updateInputs(latlng); 
        }).addTo(map);

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

        marker.on('dragend', function (e) { updateInputs(e.target.getLatLng()); });
        map.on('click', function (e) {
            marker.setLatLng(e.latlng);
            updateInputs(e.latlng);
        });
        
        setTimeout(function () { map.invalidateSize(); }, 300);
    })();
</script>

<%@ include file="/views/common/footer.jsp" %>
>
