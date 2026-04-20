<%@ page import="model.Pengguna, model.ActivityLog, java.util.List" %>
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

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 
    CONTAINER UTAMA: 
    - flex h-full overflow-hidden: Memastikan skrin penuh dan body utama tidak skrol. 
--%>
<div class="flex flex-1 h-full overflow-hidden bg-[#F7F7F9]">

    <%-- 
        KOTAK MERAH (Information Section): 
        - flex-1: Memastikan ia 'expand' memenuhi ruang sehingga ke garisan Aside.
        - overflow-y-auto: Skrol berasingan (Independent Scroll).
    --%>
    <div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full custom-scrollbar">

        <header class="mb-8">
            <h2 class="text-2xl font-bold text-gray-800">Profil Saya</h2>
            <p class="text-gray-500 text-sm">Kemaskini maklumat peribadi dan status sosio-ekonomi.</p>
        </header>

        <%-- Script format nombor telefon --%>
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
        </script> 

        <%-- script format IC --%>
        <script>
            function formatIC(input) {
                let val = input.value.replace(/\D/g, '');
                if (val.length > 12) { val = val.substring(0, 12); }
                let formatted = "";
                if (val.length > 0) { formatted += val.substring(0, 6); }
                if (val.length > 6) { formatted += '-' + val.substring(6, 8); }
                if (val.length > 8) { formatted += '-' + val.substring(8, 12); }
                input.value = formatted;
            }
        </script>

        <%-- Mesej Maklum Balas --%>
        <% if (request.getParameter("status") != null) { %>
            <% if (request.getParameter("status").equals("success")) { %>
            <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-check-circle text-lg"></i>
                <div><span class="font-bold">Berjaya!</span> Maklumat anda telah dikemaskini.</div>
            </div>
            <% } else if (request.getParameter("status").equals("error")) { %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-exclamation-circle text-lg"></i>
                <div><span class="font-bold">Ralat!</span> Berlaku masalah semasa mengemaskini maklumat.</div>
            </div>
            <% } else if (request.getParameter("status").equals("pass_success")) { %>
            <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-check-circle text-lg"></i>
                <div><span class="font-bold">Berjaya!</span> Kata laluan telah dikemaskini.</div>
            </div>
            <% } else if (request.getParameter("status").equals("pass_error")) { %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-exclamation-circle text-lg"></i>
                <div><span class="font-bold">Ralat!</span> Gagal menukar kata laluan.</div>
            </div>
            <% } else if (request.getParameter("status").equals("wrong_old_pass")) { %>
            <div class="bg-yellow-50 border border-yellow-200 text-yellow-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-exclamation-triangle text-lg"></i>
                <div><span class="font-bold">Perhatian!</span> Kata laluan lama yang dimasukkan adalah salah.</div>
            </div>
            <% } %>
        <% }%>

        <form action="<%= request.getContextPath()%>/profil/update" method="post" enctype="multipart/form-data" class="w-full">
            
            <%-- Bahagian Foto Profil (Expandable) --%>
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 mb-8 flex flex-col md:flex-row items-center gap-8 relative overflow-hidden">
                <div class="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8]"></div>
                
                <div class="relative group">
                    <div class="w-32 h-32 rounded-full p-1 border-4 border-[#6C5DD3] bg-white flex items-center justify-center text-4xl font-bold text-[#6C5DD3] shadow-lg overflow-hidden transition-transform group-hover:scale-105">
                        <% if (pDetail.getFoto_profil() != null && !pDetail.getFoto_profil().isEmpty() && !pDetail.getFoto_profil().equals("default_avatar.png")) { %>
                            <img id="previewFoto" src="<%= request.getContextPath() %>/file/profil/<%= pDetail.getFoto_profil() %>" class="w-full h-full object-cover">
                        <% } else { %>
                            <img id="previewFoto" src="https://ui-avatars.com/api/?name=<%= pDetail.getNama_penuh()%>&background=6C5DD3&color=fff&size=128" class="w-full h-full object-cover">
                        <% } %>
                    </div>
                    <label for="fotoInput" class="absolute bottom-1 right-1 w-10 h-10 bg-[#6C5DD3] text-white rounded-full flex items-center justify-center cursor-pointer border-4 border-white shadow-md hover:bg-[#5b4eb8] transition-all">
                        <i class="fas fa-camera text-sm"></i>
                        <input type="file" id="fotoInput" name="foto_profil" class="hidden" accept="image/*" onchange="previewImage(this)">
                    </label>
                </div>

                <div class="text-center md:text-left">
                    <h3 class="text-2xl font-bold text-gray-800 mb-1"><%= pDetail.getNama_penuh()%></h3>
                    <p class="text-gray-400 text-sm mb-3"><i class="far fa-id-card mr-1"></i> <%= pDetail.getNombor_kp()%></p>
                    <span class="bg-purple-50 text-[#6C5DD3] px-4 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-wider border border-purple-100">
                        <%= pDetail.getNama_peranan()%>
                    </span>
                </div>
            </div>

            <%-- Bahagian Borang Maklumat --%>
            <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100 w-full space-y-10">

                <%-- Bahagian 1: Peribadi --%>
                <div>
                    <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">1. Maklumat Peribadi</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-gray-500 mb-2">Nama Penuh</label>
                            <input type="text" name="nama_penuh" value="<%= pDetail.getNama_penuh()%>" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-2">No. Kad Pengenalan</label>
                            <% 
                                String icRaw = pDetail.getNombor_kp();
                                String icFormatted = (icRaw != null && icRaw.length() == 12) ? 
                                    icRaw.substring(0, 6) + "-" + icRaw.substring(6, 8) + "-" + icRaw.substring(8, 12) : icRaw;
                            %>
                            <input type="text" value="<%= icFormatted %>" readonly class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-400 text-sm cursor-not-allowed font-medium">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-2">No. Telefon</label>
                            <input type="text" name="nombor_telefon" value="<%= pDetail.getNombor_telefon()%>" required oninput="formatPhoneNumber(this)" maxlength="13" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-xs font-bold text-gray-500 mb-2">Alamat Emel</label>
                            <input type="email" name="email" value="<%= (pDetail.getEmail() != null) ? pDetail.getEmail() : "" %>" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                        </div>
                    </div>
                </div>

                <%-- Bahagian 2: Alamat --%>
                <div>
                    <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">2. Alamat Tempat Tinggal</h4>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div class="md:col-span-3">
                            <label class="block text-xs font-bold text-gray-500 mb-2">Nama Jalan / No. Rumah</label>
                            <input type="text" name="nama_jalan" value="<%= pDetail.getNama_jalan()%>" readonly class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
                        </div>
                        <div><label class="block text-xs font-bold text-gray-500 mb-2">Daerah</label>
                        <input type="text" value="<%= (pDetail.getDaerah() != null) ? pDetail.getDaerah() : "Selising"%>" readonly class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium"></div>
                        <div><label class="block text-xs font-bold text-gray-500 mb-2">Poskod</label>
                        <input type="text" value="<%= (pDetail.getNombor_poskod() != null) ? pDetail.getNombor_poskod() : "16810"%>" readonly class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium"></div>
                        <div><label class="block text-xs font-bold text-gray-500 mb-2">Bandar</label>
                        <input type="text" value="<%= (pDetail.getBandar() != null) ? pDetail.getBandar() : "Pasir Puteh"%>" readonly class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium"></div>
                    </div>
                </div>

                <%-- Bahagian 3: Sosio-Ekonomi --%>
                <div>
                    <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">3. Maklumat Sosio-Ekonomi</h4>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-2">Status Keluarga</label>
                            <select name="status_keluarga" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium">
                                <option value="Bujang" <%= "Bujang".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bujang</option>
                                <option value="Berkahwin" <%= "Berkahwin".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Berkahwin</option>
                                <option value="Ibu Tunggal" <%= "Ibu Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Ibu Tunggal</option>
                                <option value="Bapa Tunggal" <%= "Bapa Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : ""%>>Bapa Tunggal</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-2">Pekerjaan</label>
                            <input type="text" name="pekerjaan" value="<%= (pDetail.getPekerjaan() != null) ? pDetail.getPekerjaan() : ""%>" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 mb-2">Pendapatan (RM)</label>
                            <input type="number" step="0.01" name="pendapatan" value="<%= pDetail.getPendapatan()%>" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                        </div>
                    </div>
                </div>

                <%-- Bahagian 4: Lokasi Rumah --%>
                <div>
                    <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">4. Lokasi Rumah</h4>
                    <div id="mapProfil" style="height: 350px; border-radius: 1rem; z-index: 0;" class="border-2 border-dashed border-gray-200"></div>
                    <input type="hidden" name="latitude" id="latInput" value="<%= (pDetail.getLatitude() != null) ? pDetail.getLatitude() : "" %>">
                    <input type="hidden" name="longitude" id="lonInput" value="<%= (pDetail.getLongitude() != null) ? pDetail.getLongitude() : "" %>">
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white font-bold py-3.5 rounded-xl shadow-lg shadow-purple-200 transition-all flex justify-center items-center gap-2">
                        <i class="fas fa-save"></i> Simpan Perubahan
                    </button>
                </div>
            </div>
        </form>
    </div>

    <%-- 
        RIGHT SECTION (Aside): 
        - w-80: Lebar tetap.
        - overflow-y-auto: Skrol berasingan (Independent Scroll).
    --%>
    <aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full custom-scrollbar shrink-0">
        <div class="flex justify-between items-start mb-10">
            <h3 class="font-bold text-lg text-gray-800">Status Profil</h3>
        </div>

        <div class="text-center mb-10">
            <div class="w-full bg-purple-50 rounded-2xl p-6">
                <p class="text-xs font-bold text-gray-400 uppercase mb-2">Kelengkapan Data</p>
                <%
                    int progress = 0;
                    if (pDetail.getPekerjaan() != null && !pDetail.getPekerjaan().isEmpty()) progress += 33;
                    if (pDetail.getPendapatan() != null) progress += 33;
                    if (pDetail.getStatus_keluarga() != null && !pDetail.getStatus_keluarga().isEmpty()) progress += 34;
                %>
                <div class="relative pt-1">
                    <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-purple-200">
                        <div style="width: <%= progress%>%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-[#6C5DD3]"></div>
                    </div>
                    <p class="text-2xl font-bold text-[#6C5DD3]"><%= progress%>%</p>
                </div>
            </div>
        </div>

        <div class="mt-8">
            <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase">Keselamatan</h3>
            <button onclick="showChangePassModal()" class="w-full flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 border border-gray-100 transition text-left">
                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                    <i class="fas fa-key text-xs"></i>
                </div>
                <p class="text-sm font-bold text-gray-800">Tukar Kata Laluan</p>
                <i class="fas fa-chevron-right ml-auto text-gray-300 text-xs"></i>
            </button>
        </div>

        <div class="mt-8">
            <h3 class="font-bold text-sm text-gray-800 mb-4 flex items-center gap-2 uppercase">
                <i class="fas fa-history text-[#6C5DD3]"></i> Sejarah Aktiviti
            </h3>
            <div class="space-y-3">
                <%
                    List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("activityLogs");
                    if (logs != null && !logs.isEmpty()) {
                        for (ActivityLog log : logs) {
                %>
                <div class="p-3 rounded-xl bg-gray-50 border border-gray-100">
                    <div class="flex justify-between items-start mb-1">
                        <span class="text-[10px] font-bold text-[#6C5DD3]">Admin</span>
                        <span class="text-[9px] text-gray-400"><%= new java.text.SimpleDateFormat("dd/MM/yy").format(log.getDibuat_pada()) %></span>
                    </div>
                    <p class="text-[11px] text-gray-600 leading-tight mb-1"><%= log.getKeterangan_tindakan() %></p>
                </div>
                <%      }
                    } else { %>
                <div class="text-center py-6 bg-gray-50 rounded-xl border border-dashed border-gray-200">
                    <p class="text-[10px] text-gray-400 italic">Tiada rekod aktiviti.</p>
                </div>
                <% } %>
            </div>
        </div>
    </aside>

</div>

<style>
    .custom-scrollbar::-webkit-scrollbar { width: 4px; }
    .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e2e2; border-radius: 10px; }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6C5DD3; }
</style>

<%-- Modal Tukar Kata Laluan --%>
<div id="changePassModal" class="fixed inset-0 bg-black bg-opacity-50 z-[999] hidden flex items-center justify-center backdrop-blur-sm">
    <div class="bg-white rounded-3xl p-8 w-full max-w-md shadow-2xl relative">
        <button onclick="hideChangePassModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><i class="fas fa-times"></i></button>
        <div class="text-center mb-6">
            <h3 class="text-xl font-bold text-gray-800">Tukar Kata Laluan</h3>
        </div>
        <form action="<%= request.getContextPath()%>/profil/update?action=changePassword" method="post" class="space-y-4">
            <input type="password" name="oldPassword" placeholder="Kata Laluan Lama" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm">
            <input type="password" name="newPassword" placeholder="Kata Laluan Baharu" required minlength="6" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm">
            <div class="flex gap-3 pt-4">
                <button type="button" onclick="hideChangePassModal()" class="flex-1 py-3 bg-gray-100 text-gray-600 font-bold rounded-xl">Batal</button>
                <button type="submit" class="flex-1 py-3 bg-[#6C5DD3] text-white font-bold rounded-xl">Kemaskini</button>
            </div>
        </form>
    </div>
</div>

<script>
    function previewImage(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) { document.getElementById('previewFoto').src = e.target.result; };
            reader.readAsDataURL(input.files[0]);
        }
    }
    function showChangePassModal() { document.getElementById('changePassModal').classList.remove('hidden'); }
    function hideChangePassModal() { document.getElementById('changePassModal').classList.add('hidden'); }

    (function() {
        var defaultLat = 6.0289, defaultLon = 102.2935;
        var latElement = document.getElementById('latInput');
        var lonElement = document.getElementById('lonInput');
        if(!latElement || !lonElement) return;

        var initLat = latElement.value ? parseFloat(latElement.value) : defaultLat;
        var initLon = lonElement.value ? parseFloat(lonElement.value) : defaultLon;

        var map = L.map('mapProfil').setView([initLat, initLon], latElement.value ? 17 : 14);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '© OpenStreetMap' }).addTo(map);
        var marker = L.marker([initLat, initLon], { draggable: true }).addTo(map);

        function updateInputs(latlng) {
            document.getElementById('latInput').value = latlng.lat.toFixed(8);
            document.getElementById('lonInput').value = latlng.lng.toFixed(8);
        }

        marker.on('dragend', function(e) { updateInputs(e.target.getLatLng()); });
        map.on('click', function(e) { marker.setLatLng(e.latlng); updateInputs(e.latlng); });
        setTimeout(function() { map.invalidateSize(); }, 300);
    })();
</script>

<%@ include file="/views/common/footer.jsp" %>