<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Aduan" %>
<%@ page import="model.KategoriAduan" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    List<Aduan> aduanList = (List<Aduan>) request.getAttribute("aduanList");
    List<KategoriAduan> kategoriList = (List<KategoriAduan>) request.getAttribute("kategoriList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    SimpleDateFormat sdfFull = new SimpleDateFormat("yyyy-MM-dd");

    // Live metrics calculation
    int totalAduan = (aduanList != null) ? aduanList.size() : 0;
    long pendingCount = 0;
    long resolvedCount = 0;
    if (aduanList != null) {
        pendingCount = aduanList.stream().filter(a -> !"RESOLVED".equals(a.getStatus()) && !"REJECTED".equals(a.getStatus()) && !"CLOSED".equals(a.getStatus())).count();
        resolvedCount = aduanList.stream().filter(a -> "RESOLVED".equals(a.getStatus()) || "CLOSED".equals(a.getStatus())).count();
    }

    String statusParam = request.getParameter("status");
    String msgParam = request.getParameter("msg");
    String errorParam = request.getParameter("error");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F8FAFC]">
    
    <!-- Hero / Welcome Section -->
    <div class="relative overflow-hidden rounded-3xl bg-gradient-to-r from-emerald-600 to-teal-700 text-white p-6 md:p-8 shadow-xl mb-8 border border-emerald-500/20">
        <div class="absolute right-0 bottom-0 opacity-10 pointer-events-none transform translate-y-8 translate-x-8">
            <i class="fas fa-bullhorn text-9xl"></i>
        </div>
        <div class="relative z-10">
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-xl md:text-3xl font-extrabold tracking-tight">Hai, <%= user.getNama_penuh() %>! 👋</h2>
                    <p class="text-xs md:text-sm text-emerald-100 mt-1 font-medium max-w-xl">Pusat Laporan & Aduan Kampung Danan. Kongsi sebarang maklum balas, kerosakan infrastruktur, atau masalah keselamatan untuk tindakan Biro Keselamatan.</p>
                </div>
                <div>
                    <button onclick="openModal('modalAduanBaru')" class="w-full md:w-auto bg-white hover:bg-emerald-50 text-emerald-800 px-6 py-3.5 rounded-2xl font-black text-xs uppercase tracking-wider transition hover:scale-105 active:scale-95 shadow-md flex items-center justify-center gap-2">
                        <i class="fas fa-plus-circle text-sm text-emerald-600"></i> Hantar Laporan Baru
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats Grid (Glassmorphism Cards) -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-8">
        <!-- Card 1: Total -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-lg"><i class="fas fa-folder-open"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Jumlah Laporan Anda</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= totalAduan %></h4>
            </div>
        </div>
        <!-- Card 2: Pending -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center text-lg"><i class="fas fa-spinner animate-spin-slow"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Sedang Diproses</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= pendingCount %></h4>
            </div>
        </div>
        <!-- Card 3: Resolved -->
        <div class="bg-white/80 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm flex items-center gap-5 hover:shadow-md transition">
            <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-lg"><i class="fas fa-check-circle"></i></div>
            <div>
                <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Selesai & Ditutup</p>
                <h4 class="text-2xl font-black text-slate-800 mt-0.5"><%= resolvedCount %></h4>
            </div>
        </div>
    </div>

    <!-- Carian & Penapis Section -->
    <div class="bg-white/90 backdrop-blur-md p-6 rounded-3xl border border-slate-100 shadow-sm mb-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Carian Pantas</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="fas fa-search"></i></span>
                    <input type="text" id="searchInput" onkeyup="filterCards()" placeholder="Cari nombor aduan, tajuk, kategori..." 
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-2">Tapis Mengikut Tarikh</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-slate-400"><i class="far fa-calendar-alt"></i></span>
                    <input type="date" id="dateFilter" onchange="filterCards()"
                           class="w-full pl-11 pr-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-slate-800 text-xs transition">
                </div>
            </div>
        </div>
    </div>

    <!-- Complaint Cards Grid Layout -->
    <div id="cardsContainer" class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
        <% if (aduanList != null && !aduanList.isEmpty()) { 
            for (Aduan a : aduanList) { 
                String filterDate = (a.getDibuat_pada() != null) ? sdfFull.format(a.getDibuat_pada()) : "";
                
                // Safe JSON/Attribute escaping
                String safeTajuk = a.getTajuk() != null ? a.getTajuk().replace("\"", "&quot;").replace("'", "&#39;") : "";
                String safeKeterangan = a.getKeterangan() != null ? a.getKeterangan().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ").replace("\r", "") : "";
                String safeAjkCatatan = a.getCatatan_ajk() != null ? a.getCatatan_ajk().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
                String safeKetuaCatatan = a.getCatatan_ketua() != null ? a.getCatatan_ketua().replace("\"", "&quot;").replace("'", "&#39;").replace("\n", " ") : "";
        %>
        <!-- Complaint Card -->
        <div class="data-card bg-white rounded-3xl border border-slate-100 shadow-sm overflow-hidden hover:shadow-md transition duration-300 flex flex-col cursor-pointer"
             onclick="showAduanDetail(this)"
             data-date="<%= filterDate %>"
             data-id="<%= a.getId_aduan() %>"
             data-tajuk="<%= safeTajuk %>"
             data-keterangan="<%= safeKeterangan %>"
             data-pengadu="<%= a.getNama_penuh() %>"
             data-tarikh="<%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %>"
             data-kategori="<%= a.getNama_kategori() %>"
             data-status="<%= a.getStatus() %>"
             data-status-label="<%= a.getStatusLabel() %>"
             data-status-class="<%= a.getStatusBadgeClass() %>"
             data-priority="<%= a.getKeutamaan() %>"
             data-priority-class="<%= a.getKeutamaanBadge() %>"
             data-catatan-ajk="<%= safeAjkCatatan %>"
             data-catatan-ketua="<%= safeKetuaCatatan %>"
             data-gambar="<%= a.getGambar_aduan() != null ? a.getGambar_aduan() : "" %>"
             data-bukti-selesai="<%= a.getBukti_selesai() != null ? a.getBukti_selesai() : "" %>"
             data-reopen-count="<%= a.getReopen_count() %>"
             >
             
             <!-- Card Top Header -->
             <div class="px-6 py-4 bg-slate-50/50 border-b border-slate-100 flex justify-between items-center">
                 <span class="text-xs font-black text-emerald-700 tracking-wider">ADUAN #<%= a.getId_aduan() %></span>
                 <div class="flex gap-2">
                     <span class="px-2.5 py-1 rounded-full text-[9px] font-extrabold uppercase tracking-wide <%= a.getKeutamaanBadge() %>">
                         <%= a.getKeutamaan() %>
                     </span>
                     <span class="px-2.5 py-1 rounded-full text-[9px] font-extrabold uppercase tracking-wide <%= a.getStatusBadgeClass() %>">
                         <%= a.getStatusLabel() %>
                     </span>
                 </div>
             </div>

             <!-- Stepper Progress Bar -->
             <div class="px-6 pt-5 pb-3">
                 <div class="flex items-center justify-between text-[8px] font-bold text-slate-400 uppercase tracking-tight mb-2">
                     <span class="text-emerald-600">Dihantar</span>
                     <span class="<%= (!"SUBMITTED".equals(a.getStatus())) ? "text-emerald-600" : "" %>">Disemak</span>
                     <span class="<%= (!"SUBMITTED".equals(a.getStatus()) && !"UNDER_REVIEW_AJK".equals(a.getStatus()) && !"REOPENED".equals(a.getStatus())) ? "text-emerald-600" : "" %>">Tindakan</span>
                     <span class="<%= ("RESOLVED".equals(a.getStatus()) || "CLOSED".equals(a.getStatus())) ? "text-emerald-600" : "" %>">Selesai</span>
                 </div>
                 
                 <!-- Visual Stepper bar -->
                 <div class="w-full bg-slate-100 h-1.5 rounded-full flex overflow-hidden">
                     <%
                         int progressWidth = 25;
                         String stepperColor = "bg-emerald-500";
                         String statusKey = a.getStatus() != null ? a.getStatus() : "SUBMITTED";
                         
                         if ("UNDER_REVIEW_AJK".equals(statusKey) || "UNDER_REVIEW_KETUA".equals(statusKey)) {
                             progressWidth = 50;
                         } else if ("IN_PROGRESS_AJK".equals(statusKey) || "IN_PROGRESS_HIGH_LEVEL".equals(statusKey) || "ESCALATED_TO_KETUA".equals(statusKey)) {
                             progressWidth = 75;
                         } else if ("RESOLVED".equals(statusKey) || "CLOSED".equals(statusKey)) {
                             progressWidth = 100;
                         } else if ("REJECTED".equals(statusKey)) {
                             progressWidth = 100;
                             stepperColor = "bg-rose-500";
                         } else if ("REOPENED".equals(statusKey)) {
                             progressWidth = 40;
                             stepperColor = "bg-amber-500 animate-pulse";
                         }
                     %>
                     <div class="<%= stepperColor %> h-full rounded-full transition-all duration-500" style="width: <%= progressWidth %>%"></div>
                 </div>
             </div>

             <!-- Card Body Content -->
             <div class="px-6 py-4 flex-1 space-y-3">
                 <div>
                     <h3 class="font-extrabold text-slate-800 text-base leading-snug line-clamp-1 search-col"><%= a.getTajuk() %></h3>
                     <p class="text-xs text-slate-400 mt-1 uppercase font-bold tracking-wider search-col"><i class="fas fa-tag text-emerald-500"></i> <%= a.getNama_kategori() %></p>
                 </div>
                 <p class="text-xs text-slate-500 leading-relaxed line-clamp-3 search-col"><%= a.getKeterangan() %></p>
                 
                 <% if (a.getGambar_aduan() != null && !a.getGambar_aduan().trim().isEmpty()) { %>
                 <div class="w-20 h-12 rounded-lg overflow-hidden border border-slate-100 bg-slate-50 flex items-center justify-center">
                     <img src="<%= request.getContextPath() %>/file/aduan/<%= a.getGambar_aduan() %>" class="w-full h-full object-cover">
                 </div>
                 <% } %>
             </div>

             <!-- Card Bottom Footer -->
             <div class="px-6 py-4 border-t border-slate-100 bg-slate-50/20 flex justify-between items-center mt-auto" onclick="event.stopPropagation()">
                 <span class="text-[9px] text-slate-400 font-bold uppercase"><i class="far fa-clock"></i> <%= a.getDibuat_pada() != null ? sdf.format(a.getDibuat_pada()) : "-" %></span>
                 
                 <div class="flex gap-2">
                     <% if (("RESOLVED".equals(statusKey) || "CLOSED".equals(statusKey) || "REJECTED".equals(statusKey)) && a.getReopen_count() < 2) { %>
                     <button onclick="openReopenModal(<%= a.getId_aduan() %>)"
                             class="px-3.5 py-1.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-extrabold text-[10px] shadow-sm transition hover:scale-105 active:scale-95 flex items-center gap-1">
                         <i class="fas fa-undo"></i> Reopen (<%= a.getReopen_count() %>/2)
                     </button>
                     <% } %>
                     <button onclick="showAduanDetail(this.closest('.data-card'))" 
                             class="px-3.5 py-1.5 rounded-xl bg-white hover:bg-slate-50 text-slate-700 font-bold text-[10px] border border-slate-200 shadow-sm transition flex items-center gap-1 hover:scale-105">
                         <i class="fas fa-eye text-emerald-600"></i> Perincian
                     </button>
                 </div>
             </div>
        </div>
        <% } } else { %>
        <!-- Empty State -->
        <div class="col-span-1 md:col-span-2 bg-white rounded-3xl border border-slate-100 p-12 text-center shadow-sm">
            <div class="w-16 h-16 rounded-full bg-slate-50 text-slate-400 flex items-center justify-center mx-auto mb-4 text-2xl border border-slate-100">
                <i class="far fa-comments"></i>
            </div>
            <h4 class="font-extrabold text-slate-800 text-base">Tiada Rekod Aduan Dijumpai</h4>
            <p class="text-xs text-slate-400 mt-1 max-w-sm mx-auto">Anda belum menghantar sebarang laporan atau tiada rekod yang sepadan dengan carian.</p>
            <button onclick="openModal('modalAduanBaru')" class="mt-5 inline-flex items-center gap-2 bg-emerald-600 hover:bg-emerald-700 text-white px-5 py-2.5 rounded-xl font-bold text-xs shadow-md transition hover:scale-105">
                <i class="fas fa-plus-circle"></i> Hantar Aduan Pertama Anda
            </button>
        </div>
        <% } %>
    </div>
</div>

<!-- Modal Aduan Baru (Redesigned with Previews and counters) -->
<div id="modalAduanBaru" class="fixed inset-0 z-50 hidden" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeModal('modalAduanBaru')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-2xl transition-all sm:my-8 sm:w-full sm:max-w-lg border border-slate-100">
            <div class="bg-gradient-to-r from-emerald-600 to-teal-700 px-6 py-5 flex justify-between items-center text-white">
                <h3 class="text-sm font-black uppercase tracking-wider flex items-center gap-2"><i class="fas fa-pen-nib"></i> Hantar Aduan Baru</h3>
                <button class="text-white/60 hover:text-white" onclick="closeModal('modalAduanBaru')"><i class="fas fa-times"></i></button>
            </div>
            <form action="<%= request.getContextPath() %>/aduan/submit" method="post" enctype="multipart/form-data" id="aduanForm">
                <div class="bg-white px-6 py-6 space-y-5 max-h-[70vh] overflow-y-auto custom-scrollbar">
                    
                    <!-- Tajuk -->
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Tajuk Aduan / Isu</label>
                        <input type="text" name="tajuk" required max="100" placeholder="Contoh: Lampu jalan rosak di simpang lorong 2..." 
                               class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                    </div>

                    <!-- Kategori & Keutamaan -->
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Kategori Isu</label>
                            <select name="id_kategori" required class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                                <% if (kategoriList != null) { 
                                    for (KategoriAduan k : kategoriList) { %>
                                    <option value="<%= k.getId_kategori_aduan() %>"><%= k.getNama_kategori() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Tahap Keutamaan</label>
                            <select name="keutamaan" required class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition">
                                <option value="RENDAH">RENDAH</option>
                                <option value="SEDERHANA" selected>SEDERHANA</option>
                                <option value="TINGGI">TINGGI</option>
                                <option value="KRITIKAL">KRITIKAL</option>
                            </select>
                        </div>
                    </div>

                    <!-- Keterangan -->
                    <div>
                        <div class="flex justify-between items-center mb-2">
                            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider">Keterangan Terperinci</label>
                            <span id="charCount" class="text-[9px] text-slate-400 font-bold">0 / 500</span>
                        </div>
                        <textarea name="keterangan" id="keteranganInput" rows="4" required maxlength="500" onkeyup="updateCharCount()"
                                  placeholder="Sila jelaskan butiran masalah secara terperinci (lokasi, waktu kejadian, dll)..." 
                                  class="w-full px-4 py-3 rounded-xl bg-slate-50 border border-slate-100 focus:ring-2 focus:ring-emerald-500 focus:bg-white text-xs transition"></textarea>
                    </div>

                    <!-- Gambar Bukti & Preview -->
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-wider mb-2">Gambar Lampiran Bukti (Jika Ada)</label>
                        
                        <!-- Upload Box -->
                        <div id="uploadBox" class="mt-1 flex flex-col justify-center px-6 pt-5 pb-6 border-2 border-slate-100 border-dashed rounded-2xl hover:border-emerald-500 hover:bg-emerald-50/10 transition cursor-pointer text-center" 
                             onclick="document.getElementById('fileInput').click()">
                            <i class="fas fa-image text-slate-300 text-3xl mb-2"></i>
                            <div class="flex text-xs text-slate-500 justify-center">
                                <span class="font-bold text-emerald-600">Klik untuk memuat naik</span>
                                <p class="pl-1">atau seret dan lepas fail</p>
                            </div>
                            <p class="text-[9px] text-slate-400 mt-1">PNG, JPG, JPEG (Had 5MB)</p>
                            <input id="fileInput" name="gambar_aduan" type="file" class="hidden" accept="image/*" onchange="previewImage(this)">
                        </div>

                        <!-- Image Preview Container -->
                        <div id="imagePreviewContainer" class="hidden mt-3 relative rounded-2xl overflow-hidden border border-slate-100 shadow-sm aspect-video">
                            <img id="imagePreview" src="#" class="w-full h-full object-cover">
                            <button type="button" onclick="removePreview()" class="absolute top-2 right-2 w-8 h-8 rounded-full bg-black/60 hover:bg-black/80 text-white flex items-center justify-center transition hover:scale-105">
                                <i class="fas fa-trash-alt text-xs"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Modal Actions -->
                <div class="bg-slate-50 px-8 py-4 flex flex-row-reverse gap-3 border-t border-slate-100 rounded-b-3xl">
                    <button type="submit" id="btnSubmitAduan" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2.5 rounded-xl font-bold text-xs shadow-md transition hover:scale-105 flex items-center gap-1.5">
                        <i class="fas fa-paper-plane text-xs"></i> Hantar Aduan
                    </button>
                    <button type="button" onclick="closeModal('modalAduanBaru')" class="bg-white hover:bg-slate-50 text-slate-500 px-5 py-2.5 rounded-xl font-bold text-xs border border-slate-200 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/views/aduan/modalDetailAduan.jsp" %>

<script>
    // Live Search Filter for Cards
    function filterCards() {
        const searchVal = document.getElementById("searchInput").value.toLowerCase();
        const dateVal = document.getElementById("dateFilter").value;
        const cards = document.querySelectorAll(".data-card");
        
        cards.forEach(card => {
            const cardDate = card.getAttribute("data-date");
            let textContent = "";
            card.querySelectorAll(".search-col").forEach(col => textContent += col.innerText.toLowerCase() + " ");
            
            let showCard = true;
            if (dateVal !== "" && cardDate !== dateVal) showCard = false;
            if (searchVal !== "" && !textContent.includes(searchVal)) showCard = false;
            
            card.style.display = showCard ? "" : "none";
        });
    }

    // Live character counter
    function updateCharCount() {
        const textarea = document.getElementById("keteranganInput");
        const count = document.getElementById("charCount");
        count.innerText = textarea.value.length + " / 500";
    }

    // Live Upload Image Preview
    function previewImage(input) {
        const previewContainer = document.getElementById("imagePreviewContainer");
        const preview = document.getElementById("imagePreview");
        const uploadBox = document.getElementById("uploadBox");

        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                uploadBox.classList.add("hidden");
                previewContainer.classList.remove("hidden");
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // Remove Upload Image Preview
    function removePreview() {
        const previewContainer = document.getElementById("imagePreviewContainer");
        const uploadBox = document.getElementById("uploadBox");
        const fileInput = document.getElementById("fileInput");

        fileInput.value = "";
        previewContainer.classList.add("hidden");
        uploadBox.classList.remove("hidden");
    }

    // Loading overlay on form submit
    document.getElementById("aduanForm").addEventListener("submit", function() {
        const btn = document.getElementById("btnSubmitAduan");
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner animate-spin"></i> Menghantar...';
    });

    // SweetAlert2 Toast Notifications
    document.addEventListener("DOMContentLoaded", function() {
        <% if ("success".equals(statusParam)) { %>
            Swal.fire({
                icon: 'success',
                title: 'Aduan Dihantar!',
                text: 'Aduan anda telah berjaya dihantar dan ditugaskan kepada Biro Keselamatan.',
                confirmButtonColor: '#059669',
                customClass: { popup: 'rounded-3xl font-sans' }
            });
        <% } else if ("error".equals(statusParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Ralat Penghantaran!',
                text: 'Sistem gagal menyimpan aduan. Sila semak semula fail lampiran atau cuba lagi.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("reopened".equals(statusParam) || "reopened".equals(msgParam)) { %>
            Swal.fire({
                icon: 'success',
                title: 'Aduan Dibuka Semula!',
                text: 'Aduan anda telah berjaya dibuka semula dan diletakkan di bawah pemantauan sensitif Biro Keselamatan.',
                confirmButtonColor: '#D97706',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("db".equals(errorParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Ralat Pangkalan Data!',
                text: 'Perubahan gagal disimpan. Pangkalan data mengalami masalah sementara.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("reopen_limit".equals(errorParam)) { %>
            Swal.fire({
                icon: 'warning',
                title: 'Had Reopen Dicapai!',
                text: 'Anda hanya dibenarkan membuka semula sesuatu aduan maksimum 2 kali sahaja.',
                confirmButtonColor: '#D97706',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } else if ("cannot_reopen".equals(errorParam)) { %>
            Swal.fire({
                icon: 'error',
                title: 'Tidak Boleh Dibuka Semula!',
                text: 'Aduan hanya boleh dibuka semula sekiranya ia telah diselesaikan atau ditolak oleh pihak pengurusan.',
                confirmButtonColor: '#DC2626',
                customClass: { popup: 'rounded-3xl' }
            });
        <% } %>
    });
</script>

<%@ include file="/views/common/footer.jsp" %>
