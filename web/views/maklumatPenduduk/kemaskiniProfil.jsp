<%@ page import="model.Pengguna, model.ActivityLog, java.util.List" %>
<%
    // 1. Dapatkan objek user dari session (Variabel 'user' biasanya sudah ada dari navbar.jsp)
    // Jika tiada, kita ambil semula untuk kepastian.
    Pengguna pDetail = (Pengguna) session.getAttribute("currentUser");

    if (pDetail == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Profil Saya</h2>
        <p class="text-gray-500 text-sm">Kemaskini maklumat peribadi dan status sosio-ekonomi.</p>
    </header>

    <%-- Script format nombor telefon (xxx-xxxx xxxx) --%>
    <script>
        function formatPhoneNumber(input) {
            // 1. Buang semua karakter kecuali nombor
            let num = input.value.replace(/\D/g, '');

            // 2. Formatkan mengikut panjang nombor
            // Untuk format: 011-1101 3816
            if (num.length > 3 && num.length <= 7) {
                input.value = num.substring(0, 3) + '-' + num.substring(3);
            } else if (num.length > 7) {
                input.value = num.substring(0, 3) + '-' + num.substring(3, 7) + ' ' + num.substring(7, 11);
            } else {
                input.value = num;
            }
        }
    </script> 

    <%-- script format IC (xxxxxx-xx-xxxx) --%>
    <script>
        function formatIC(input) {
            // 1. Buang semua karakter bukan nombor
            let val = input.value.replace(/\D/g, '');

            // 2. Potong jika lebih 12 digit (elak ralat)
            if (val.length > 12) {
                val = val.substring(0, 12);
            }

            // 3. Masukkan sempang mengikut posisi
            let formatted = "";
            if (val.length > 0) {
                // Bahagian Tarikh Lahir (6 digit pertama)
                formatted += val.substring(0, 6);
            }
            if (val.length > 6) {
                // Bahagian Kod Negeri (2 digit tengah)
                formatted += '-' + val.substring(6, 8);
            }
            if (val.length > 8) {
                // Bahagian Nombor Siri (4 digit terakhir)
                formatted += '-' + val.substring(8, 12);
            }

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

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

        <%-- Kad Kiri: Ringkasan --%>
        <div class="lg:col-span-1">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 text-center relative overflow-hidden">
                <div class="absolute top-0 left-0 w-full h-24 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] opacity-10"></div>

                <div class="relative inline-block mb-4 mt-4">
                    <div class="w-32 h-32 rounded-full p-1 border-4 border-[#6C5DD3] bg-white mx-auto flex items-center justify-center text-4xl font-bold text-[#6C5DD3] shadow-lg overflow-hidden">
                        <img src="https://ui-avatars.com/api/?name=<%= pDetail.getNama_penuh()%>&background=6C5DD3&color=fff&size=128" class="w-full h-full object-cover">
                    </div>
                    <div class="absolute bottom-2 right-2 w-6 h-6 bg-green-500 border-2 border-white rounded-full"></div>
                </div>

                <h3 class="text-xl font-bold text-gray-800"><%= pDetail.getNama_penuh()%></h3>
                <p class="text-sm text-gray-400 mb-4"><%= pDetail.getNombor_kp()%></p>

                <span class="bg-purple-50 text-[#6C5DD3] px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider">
                    <%= pDetail.getNama_peranan()%>
                </span>
            </div>
        </div>

        <%-- Kolum Kanan: Borang Kemaskini --%>
        <div class="lg:col-span-2">
            <form action="<%= request.getContextPath()%>/profil/update" method="post">
                <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100">

                    <%-- Bahagian 1: Peribadi --%>
                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            1. Maklumat Peribadi
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="md:col-span-2">
                                <label class="block text-xs font-bold text-gray-500 mb-2">Nama Penuh</label>
                                <input type="text" name="nama_penuh" value="<%= pDetail.getNama_penuh()%>" required placeholder=" Nama seperti dalam MyKad" 
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
<div>
    <label class="block text-xs font-bold text-gray-500 mb-2">No. Kad Pengenalan</label>
    <% 
        String icRaw = pDetail.getNombor_kp();
        String icFormatted = (icRaw != null && icRaw.length() == 12) ? 
            icRaw.substring(0, 6) + "-" + icRaw.substring(6, 8) + "-" + icRaw.substring(8, 12) : icRaw;
    %>
    <input type="text" 
           value="<%= icFormatted %>" 
           readonly
           class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-400 text-sm cursor-not-allowed font-medium">
</div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">No. Telefon</label>
                                <input type="text" name="nombor_telefon" value="<%= pDetail.getNombor_telefon()%>" required oninput="formatPhoneNumber(this)" 
                                       maxlength="13" placeholder="Contoh: 012-6047 0421" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Alamat Emel</label>
                                <input type="email" name="email" value="<%= (pDetail.getEmail() != null) ? pDetail.getEmail() : "" %>" required 
                                       placeholder="Contoh: ali@gmail.com" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                        </div>
                    </div>

                    <%-- Bahagian 2: Alamat --%>
<div class="mb-8">
    <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
        2. Alamat Tempat Tinggal
    </h4>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="md:col-span-3">
            <label class="block text-xs font-bold text-gray-500 mb-2">Nama Jalan / No. Rumah</label>
            <input type="text" name="nama_jalan" value="<%= pDetail.getNama_jalan()%>" readonly
                   class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
        </div>

        <div>
            <label class="block text-xs font-bold text-gray-500 mb-2">Daerah</label>
            <input type="text" name="daerah" value="<%= (pDetail.getDaerah() != null) ? pDetail.getDaerah() : "Selising"%>" readonly
                   class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
        </div>

        <div>
            <label class="block text-xs font-bold text-gray-500 mb-2">Poskod</label>
            <input type="text" name="nombor_poskod" value="<%= (pDetail.getNombor_poskod() != null) ? pDetail.getNombor_poskod() : "16810"%>" readonly
                   class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
        </div>

        <div>
            <label class="block text-xs font-bold text-gray-500 mb-2">Bandar</label>
            <input type="text" name="bandar" value="<%= (pDetail.getBandar() != null) ? pDetail.getBandar() : "Pasir Puteh"%>" readonly
                   class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
        </div>

        <div>
            <label class="block text-xs font-bold text-gray-500 mb-2">Negeri</label>
            <input type="text" name="negeri" value="<%= (pDetail.getNegeri() != null) ? pDetail.getNegeri() : "Kelantan"%>" readonly
                   class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-500 text-sm font-medium cursor-not-allowed">
        </div>
    </div>
</div>

                    <%-- Bahagian 3: Sosio-Ekonomi --%>
                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            3. Maklumat Sosio-Ekonomi
                        </h4>
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
                                <input type="text" name="pekerjaan" value="<%= (pDetail.getPekerjaan() != null) ? pDetail.getPekerjaan() : ""%>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Pendapatan (RM)</label>
                                <input type="number" step="0.01" name="pendapatan" value="<%= pDetail.getPendapatan()%>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                        </div>
                    </div>

                    <%-- Bahagian 4: Lokasi Rumah (Peta) --%>
                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            4. Lokasi Rumah (Klik/Seret Penanda)
                        </h4>
                        <div id="mapProfil" style="height: 350px; border-radius: 1rem; z-index: 0;" class="border-2 border-dashed border-gray-200"></div>
                        <input type="hidden" name="latitude" id="latInput"
                               value="<%= (pDetail.getLatitude() != null) ? pDetail.getLatitude() : "" %>">
                        <input type="hidden" name="longitude" id="lonInput"
                               value="<%= (pDetail.getLongitude() != null) ? pDetail.getLongitude() : "" %>">
                        <p class="text-xs text-gray-400 mt-2">
                            <i class="fas fa-info-circle"></i>
                            Klik pada peta atau seret penanda untuk menentukan lokasi rumah anda.
                        </p>
                    </div>

                    <div class="pt-4">
                        <button type="submit" class="w-full bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white font-bold py-3.5 rounded-xl shadow-lg shadow-purple-200 transition-all flex justify-center items-center gap-2">
                            <i class="fas fa-save"></i> Simpan Perubahan
                        </button>
                    </div>

                </div>
            </form>

            <%-- Bahagian: Sejarah Aktiviti Profil (Audit Trail) --%>
            <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100 mt-8">
                <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-6 border-b border-gray-100 pb-2 flex items-center gap-2">
                    <i class="fas fa-history"></i> Sejarah Aktiviti Profil
                </h4>
                
                <%
                    List<ActivityLog> logs = (List<ActivityLog>) request.getAttribute("activityLogs");
                    if (logs != null && !logs.isEmpty()) {
                %>
                <div class="space-y-4">
                    <% for (ActivityLog log : logs) { %>
                    <div class="flex gap-4 p-4 rounded-2xl bg-gray-50 border border-gray-100 transition-hover hover:shadow-md">
                        <div class="w-10 h-10 rounded-full bg-purple-100 flex-shrink-0 flex items-center justify-center text-purple-600">
                            <i class="fas fa-user-edit text-sm"></i>
                        </div>
                        <div class="flex-1">
                            <div class="flex justify-between items-start mb-1">
                                <p class="text-sm font-bold text-gray-800">
                                    Admin (<%= log.getAdminName() %>)
                                </p>
                                <span class="text-[10px] font-bold text-gray-400 uppercase tracking-tight bg-white px-2 py-0.5 rounded-full border border-gray-100">
                                    <%= new java.text.SimpleDateFormat("dd MMM yyyy, h:mm a").format(log.getDibuat_pada()) %>
                                </span>
                            </div>
                            <p class="text-xs text-gray-600 leading-relaxed"><%= log.getKeterangan_tindakan() %></p>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="text-center py-12">
                    <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center text-gray-300 mx-auto mb-4">
                        <i class="fas fa-clipboard-list text-2xl"></i>
                    </div>
                    <p class="text-gray-400 text-sm">Tiada rekod aktiviti dijumpai.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div> 

<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Status Profil</h3>
    </div>

    <div class="text-center mb-10">
        <div class="w-full bg-purple-50 rounded-2xl p-6">
            <p class="text-xs font-bold text-gray-400 uppercase mb-2">Kelengkapan Data</p>
            <%-- Logik Progress Bar Ringkas --%>
            <%
                int progress = 0;
                if (pDetail.getPekerjaan() != null) {
                    progress += 33;
                }
                if (pDetail.getPendapatan() != null) {
                    progress += 33;
                }
                if (pDetail.getStatus_keluarga() != null)
                    progress += 34;
            %>
            <div class="relative pt-1">
                <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-purple-200">
                    <div style="width: <%= progress%>%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-[#6C5DD3]"></div>
                </div>
                <p class="text-2xl font-bold text-[#6C5DD3]"><%= progress%>%</p>
            </div>
            <p class="text-xs text-gray-500 mt-2">Maklumat yang lengkap memudahkan urusan permohonan bantuan.</p>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4">Keselamatan</h3>
        <div class="space-y-3">
            <button onclick="showChangePassModal()" class="w-full flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 border border-transparent hover:border-gray-100 transition text-left">
                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                    <i class="fas fa-key text-xs"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-bold text-gray-800">Tukar Kata Laluan</p>
                </div>
                <i class="fas fa-chevron-right text-gray-300 text-xs"></i>
            </button>
        </div>
    </div>
</aside>

<%-- Modal Tukar Kata Laluan --%>
<div id="changePassModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center backdrop-blur-sm">
    <div class="bg-white rounded-3xl p-8 w-full max-w-md shadow-2xl transform transition-all relative">
        <button onclick="hideChangePassModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition">
            <i class="fas fa-times text-xl"></i>
        </button>
        <div class="text-center mb-6">
            <div class="w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center text-blue-500 mx-auto mb-4">
                <i class="fas fa-shield-alt text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-gray-800">Tukar Kata Laluan</h3>
            <p class="text-sm text-gray-500">Sila masukkan kata laluan lama dan cipta yang baharu.</p>
        </div>

        <form action="<%= request.getContextPath()%>/profil/update?action=changePassword" method="post">
            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2">Kata Laluan Lama</label>
                    <input type="password" name="oldPassword" required
                           class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#6C5DD3] focus:ring-1 focus:ring-[#6C5DD3] text-sm">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 mb-2">Kata Laluan Baharu</label>
                    <input type="password" name="newPassword" required minlength="6"
                           class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 focus:border-[#6C5DD3] focus:ring-1 focus:ring-[#6C5DD3] text-sm">
                </div>
            </div>
            <div class="mt-8 flex gap-3">
                <button type="button" onclick="hideChangePassModal()" class="flex-1 py-3 bg-gray-100 text-gray-600 font-bold rounded-xl hover:bg-gray-200 transition">Batal</button>
                <button type="submit" class="flex-1 py-3 bg-[#6C5DD3] text-white font-bold rounded-xl shadow-lg hover:bg-[#5b4eb8] transition">Kemaskini</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showChangePassModal() {
        document.getElementById('changePassModal').classList.remove('hidden');
    }
    function hideChangePassModal() {
        document.getElementById('changePassModal').classList.add('hidden');
    }
</script>

<script>
(function() {
    var defaultLat = 6.0289, defaultLon = 102.2935;
    var latElement = document.getElementById('latInput');
    var lonElement = document.getElementById('lonInput');
    if(!latElement || !lonElement) return;

    var lat = latElement.value;
    var lon = lonElement.value;
    var hasCoords = (lat !== '' && lon !== '');
    var initLat = hasCoords ? parseFloat(lat) : defaultLat;
    var initLon = hasCoords ? parseFloat(lon) : defaultLon;

    var map = L.map('mapProfil').setView([initLat, initLon], hasCoords ? 17 : 14);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '© OpenStreetMap'
    }).addTo(map);

    var marker = L.marker([initLat, initLon], { draggable: true }).addTo(map);

    function updateInputs(latlng) {
        document.getElementById('latInput').value = latlng.lat.toFixed(8);
        document.getElementById('lonInput').value = latlng.lng.toFixed(8);
    }

    marker.on('dragend', function(e) { updateInputs(e.target.getLatLng()); });
    map.on('click', function(e) {
        marker.setLatLng(e.latlng);
        updateInputs(e.latlng);
    });

    if (hasCoords) updateInputs(marker.getLatLng());

    // Fix Leaflet rendering
    setTimeout(function() { map.invalidateSize(); }, 300);
})();
</script>

<%@ include file="/views/common/footer.jsp" %>