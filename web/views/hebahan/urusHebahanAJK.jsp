<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="model.Hebahan, model.Pengguna" %>
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>
<!-- Cropper.js CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.css">
<!-- Cropper.js JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.13/cropper.min.js"></script>
<%
    List<Hebahan> list = (List<Hebahan>) request.getAttribute("hebahanList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <div class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Urus Hebahan</h2>
            <p class="text-gray-500 text-sm">Cipta dan kemaskini pengumuman kampung.</p>
        </div>
        <div class="flex items-center gap-4">
            <div class="relative min-w-[160px]">
                <form action="${pageContext.request.contextPath}/hebahan/list" method="get" id="sortForm">
                    <select name="sort" onchange="this.form.submit()" class="w-full pl-4 pr-10 py-3 rounded-2xl bg-white border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm appearance-none cursor-pointer font-bold text-gray-600 shadow-sm transition-all">
                        <option value="DESC" <%= "DESC".equals(request.getParameter("sort")) ? "selected" : "" %>>Terbaru</option>
                        <option value="ASC" <%= "ASC".equals(request.getParameter("sort")) ? "selected" : "" %>>Terlama</option>
                    </select>
                    <i class="fas fa-sort-amount-down absolute right-4 top-1/2 -translate-y-1/2 text-brand-purple pointer-events-none"></i>
                </form>
            </div>
            <button onclick="openAddModal()" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-6 py-3 rounded-2xl font-bold text-sm transition shadow-lg shadow-purple-100 flex items-center gap-2">
                <i class="fas fa-plus-circle"></i> Tambah Hebahan Baru
            </button>
        </div>
    </div>

    <!-- List Layout (Mirror Resident View) -->
    <div class="flex flex-col gap-6">
        <% if (list != null && !list.isEmpty()) { 
            for (Hebahan h : list) { 
                String fullDate = h.getTarikh_hebahan() != null ? sdf.format(h.getTarikh_hebahan()) : "-";
                String eventDateRange = "-";
                if (h.getTarikh_mula_acara() != null) {
                    eventDateRange = sdf.format(h.getTarikh_mula_acara());
                    if (h.getTarikh_tamat_acara() != null) {
                        eventDateRange += " - " + sdf.format(h.getTarikh_tamat_acara());
                    }
                }
        %>
        <div class="bg-white rounded-[2rem] shadow-sm border border-gray-50 overflow-hidden hover:shadow-xl transition-all duration-300 group flex flex-col md:flex-row md:h-64 relative">
            
            <!-- Admin Overlay: Status Badge -->
            <div class="absolute top-4 right-4 z-10 flex gap-2">
                <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase shadow-sm border <%= h.getStatusBadgeClass() %>">
                    <i class="fas fa-circle text-[8px] mr-1"></i> <%= h.getStatus_hebahan() %>
                </span>
            </div>

            <!-- Poster Image Section -->
            <div class="w-full md:w-72 lg:w-96 shrink-0 relative overflow-hidden bg-gray-100">
                <% if (h.getGambar_poster() != null) { %>
                    <img src="${pageContext.request.contextPath}/file/hebahan/<%= h.getGambar_poster() %>"
                         class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                <% } else { %>
                    <div class="w-full h-full bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center">
                        <i class="<%= h.getKategoriIcon() %> text-white text-5xl opacity-30"></i>
                    </div>
                <% } %>
            </div>

            <!-- Content Section -->
            <div class="p-6 md:p-8 flex flex-col flex-1 min-w-0">
                <div class="flex gap-2 mb-4">
                    <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase border <%= h.getKategoriBadgeClass() %>">
                        <%= h.getKategori() %>
                    </span>
                </div>

                <div class="flex-1">
                    <h3 class="text-xl md:text-2xl font-bold text-gray-800 mb-2 truncate"><%= h.getTajuk() %></h3>
                    <p class="text-sm text-gray-500 line-clamp-2 mb-6 leading-relaxed"><%= h.getKandungan() %></p>
                </div>

                <div class="flex flex-wrap items-center gap-y-2 gap-x-6 pt-4 border-t border-gray-50">
                    <div class="flex items-center gap-2 text-xs text-gray-400">
                        <i class="fas fa-calendar-alt text-brand-purple"></i>
                        <span class="font-medium"><%= fullDate %></span>
                    </div>

                    <!-- Management Actions -->
                    <div class="ml-auto flex items-center gap-3">
                        <button onclick="showHebahanDetail({
                            tajuk: '<%= h.getTajuk().replace("'", "\\'") %>',
                            kandungan: `<%= h.getKandungan().replace("`", "\\`") %>`,
                            kategori: '<%= h.getKategori() %>',
                            badgeClass: '<%= h.getKategoriBadgeClass() %>',
                            icon: '<%= h.getKategoriIcon() %>',
                            gambar: '<%= h.getGambar_poster() != null ? h.getGambar_poster() : "" %>',
                            lokasi: '<%= h.getLokasi_acara() != null ? h.getLokasi_acara().replace("'", "\\'") : "-" %>',
                            tarikhHebahan: '<%= fullDate %>',
                            tarikhAcara: '<%= eventDateRange %>'
                        })" class="px-4 py-2 bg-gray-50 hover:bg-gray-100 text-gray-600 rounded-xl text-xs font-bold transition flex items-center gap-2">
                            <i class="fas fa-eye"></i> Pratinjau
                        </button>

                        <button onclick="openEditModal(this)" 
                                data-id="<%= h.getId_hebahan() %>"
                                data-tajuk="<%= h.getTajuk() %>"
                                data-kandungan="<%= h.getKandungan() %>"
                                data-kategori="<%= h.getKategori() %>"
                                data-status="<%= h.getStatus_hebahan() %>"
                                data-lokasi="<%= h.getLokasi_acara() != null ? h.getLokasi_acara() : "" %>"
                                data-mula="<%= h.getTarikh_mula_acara() != null ? sdfInput.format(h.getTarikh_mula_acara()) : "" %>"
                                data-tamat_acara="<%= h.getTarikh_tamat_acara() != null ? sdfInput.format(h.getTarikh_tamat_acara()) : "" %>"
                                data-tamat_hebahan="<%= h.getTarikh_tamat() != null ? sdfInput.format(h.getTarikh_tamat()) : "" %>"
                                class="w-10 h-10 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-xl flex items-center justify-center transition shadow-sm">
                            <i class="fas fa-edit"></i>
                        </button>
                        
                        <button onclick="confirmDelete(<%= h.getId_hebahan() %>)" 
                                class="w-10 h-10 bg-red-50 hover:bg-red-100 text-red-600 rounded-xl flex items-center justify-center transition shadow-sm">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <% } } else { %>
            <div class="py-20 text-center bg-white rounded-[3rem] border border-dashed border-gray-200">
                <div class="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-6">
                    <i class="fas fa-comment-slash text-3xl text-gray-200"></i>
                </div>
                <p class="font-bold text-gray-400">Tiada Rekod Hebahan</p>
                <p class="text-xs text-gray-300 mt-1">Klik 'Tambah Hebahan Baru' untuk mula.</p>
            </div>
        <% } %>
    </div>
</div>

<!-- Modal Detail Hebahan (Pratinjau Paparan Penduduk) -->
<div id="modalDetailPreview" class="fixed inset-0 z-[60] hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeDetailModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[3rem] shadow-2xl overflow-hidden transform transition-all duration-300">
            <!-- Header Image -->
            <div id="modalImageContainer" class="h-64 md:h-96 bg-gray-100 overflow-hidden relative">
                <img id="modalImage" src="" class="w-full h-full object-cover">
                <div id="modalGradient" class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                <button onclick="closeDetailModal()" class="absolute top-6 right-6 w-12 h-12 bg-white/20 hover:bg-white/40 backdrop-blur-md text-white rounded-2xl flex items-center justify-center transition-all">
                    <i class="fas fa-times"></i>
                </button>
                <div class="absolute bottom-8 left-8 right-8 text-white text-left">
                    <div id="modalBadge" class="inline-block px-4 py-1.5 rounded-full text-[10px] font-bold uppercase mb-4 backdrop-blur-md border border-white/20"></div>
                    <h2 id="modalTitlePreview" class="text-2xl md:text-4xl font-bold"></h2>
                </div>
            </div>

            <!-- Content Body -->
            <div class="p-8 md:p-12 text-left">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-12">
                    <div class="md:col-span-2">
                        <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Kandungan Hebahan</h3>
                        <div id="modalKandungan" class="text-gray-600 leading-relaxed space-y-4 whitespace-pre-wrap"></div>
                    </div>
                    <div class="space-y-8">
                        <div>
                            <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Maklumat Acara</h3>
                            <div class="space-y-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-purple-50 text-brand-purple flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Lokasi</p>
                                        <p id="modalLokasi" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Tarikh Acara</p>
                                        <p id="modalTarikhAcara" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 bg-gray-50 rounded-[2rem] border border-gray-100 text-center">
                            <p class="text-[10px] font-bold text-gray-400 uppercase mb-2">Hebahan Diterbitkan Pada</p>
                            <p id="modalTarikhHebahan" class="text-xs font-bold text-gray-600"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Right Aside Bar -->
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="mb-8">
        <h3 class="font-bold text-lg text-gray-800">Statistik Hebahan</h3>
        <p class="text-xs text-gray-400 font-medium">Ringkasan kandungan anda</p>
    </div>

    <div class="space-y-4 mb-10">
        <div class="bg-gray-50 p-4 rounded-2xl flex items-center justify-between border border-gray-100">
            <div>
                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-wider">Jumlah Hebahan</p>
                <h4 class="font-bold text-xl text-gray-800"><%= list != null ? list.size() : 0 %></h4>
            </div>
            <div class="w-10 h-10 rounded-xl bg-purple-100 text-[#6C5DD3] flex items-center justify-center">
                <i class="fas fa-bullhorn"></i>
            </div>
        </div>
    </div>

    <div class="mb-10">
        <h3 class="font-bold text-sm text-gray-800 mb-4 uppercase tracking-widest">Panduan Pengurusan</h3>
        <div class="space-y-6 relative">
            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-gray-100"></div>
            
            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-[#6C5DD3] flex items-center justify-center font-bold text-xs border-2 border-[#6C5DD3] z-10">1</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Draf atau Terbit</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Gunakan status 'Draft' jika maklumat belum muktamad.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">2</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Kategori Kecemasan</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Hebahan kecemasan akan sentiasa berada di kedudukan teratas paparan penduduk.</p>
            </div>

            <div class="relative pl-10">
                <div class="absolute left-0 top-0 w-8 h-8 rounded-full bg-white text-gray-400 flex items-center justify-center font-bold text-xs border-2 border-gray-100 z-10">3</div>
                <h4 class="font-bold text-xs text-gray-800 uppercase">Poster & Gambar</h4>
                <p class="text-[10px] text-gray-500 mt-1 leading-relaxed">Muat naik poster menarik untuk menarik perhatian penduduk.</p>
            </div>
        </div>
    </div>
</aside>

<!-- Modal Tambah/Edit Hebahan -->
<div id="modalHebahan" class="fixed inset-0 z-50 hidden">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeModal('modalHebahan')"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
            <div class="bg-[#6C5DD3] px-6 py-4 flex justify-between items-center">
                <h3 class="text-lg font-bold text-white flex items-center gap-2"><i class="fas fa-bullhorn"></i> <span id="modalTitle">Hebahan Baru</span></h3>
                <button class="text-white hover:text-gray-200" onclick="closeModal('modalHebahan')"><i class="fas fa-times"></i></button>
            </div>
            <form id="formHebahan" action="<%= request.getContextPath() %>/hebahan/create" method="post" enctype="multipart/form-data" onsubmit="return validateHebahanForm()">
                <input type="hidden" name="id_hebahan" id="id_hebahan">
                <div class="bg-white px-8 py-6 space-y-4 max-h-[70vh] overflow-y-auto">
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tajuk Hebahan</label>
                        <input type="text" name="tajuk" id="tajuk" required maxlength="50" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Kandungan</label>
                        <textarea name="kandungan" id="kandungan" rows="4" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition"></textarea>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Kategori</label>
                            <select name="kategori" id="kategori" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                                <option value="Umum">Umum</option>
                                <option value="Aktiviti">Aktiviti</option>
                                <option value="Kecemasan">Kecemasan</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Status</label>
                            <select name="status_hebahan" id="status_hebahan" required class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 focus:ring-2 focus:ring-[#6C5DD3] text-sm transition">
                                <option value="Draft">Draft</option>
                                <option value="Published">Published</option>
                            </select>
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Mula Acara</label>
                            <input type="datetime-local" name="tarikh_mula_acara" id="tarikh_mula_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Tamat Acara</label>
                            <input type="datetime-local" name="tarikh_tamat_acara" id="tarikh_tamat_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Lokasi Acara</label>
                        <input type="text" name="lokasi_acara" id="lokasi_acara" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Tarikh Auto-Archive (Hebahan Tamat)</label>
                        <input type="datetime-local" name="tarikh_tamat" id="tarikh_tamat" class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">Gambar Poster</label>
                        <div class="flex flex-col gap-4">
                            <!-- Preview Box -->
                            <div id="posterPreviewContainer" class="hidden relative w-full aspect-video rounded-2xl overflow-hidden border-2 border-dashed border-purple-100 bg-purple-50 group">
                                <img id="posterPreview" class="w-full h-full object-cover">
                                <button type="button" onclick="resetPosterSelection()" class="absolute top-2 right-2 w-8 h-8 bg-red-500 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition shadow-lg">
                                    <i class="fas fa-times text-xs"></i>
                                </button>
                            </div>
                            
                            <!-- Custom File Input -->
                            <div class="relative">
                                <input type="file" name="gambar_poster" id="gambar_poster" accept="image/*" onchange="handleFileSelect(this)" 
                                       class="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10">
                                <div class="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-100 text-sm flex items-center gap-3 text-gray-400 group-hover:border-purple-200 transition">
                                    <i class="fas fa-image text-[#6C5DD3]"></i>
                                    <span id="fileNameLabel">Pilih atau Seret Gambar Poster</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-gray-50 px-8 py-4 flex flex-row-reverse gap-3">
                    <button type="submit" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-8 py-2.5 rounded-xl font-bold text-sm transition shadow-lg shadow-purple-100">Simpan</button>
                    <button type="button" onclick="closeModal('modalHebahan')" class="bg-white hover:bg-gray-50 text-gray-500 px-6 py-2.5 rounded-xl font-bold text-sm border border-gray-100 transition">Batal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Cropper -->
<div id="modalCrop" class="fixed inset-0 z-[100] hidden">
    <div class="fixed inset-0 bg-gray-900 bg-opacity-60 backdrop-blur-sm"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative bg-white rounded-[2.5rem] shadow-2xl w-full max-w-4xl overflow-hidden transform transition-all">
            <!-- Header -->
            <div class="bg-[#6C5DD3] px-8 py-5 flex justify-between items-center">
                <div>
                    <h3 class="text-lg font-bold text-white">Laraskan & Potong Poster</h3>
                    <p class="text-purple-100 text-[10px] uppercase font-bold tracking-widest">Suaikan mengikut bingkai yang disediakan</p>
                </div>
                <button onclick="closeCropModal()" class="text-white hover:rotate-90 transition-transform duration-300">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <!-- Cropper Area -->
            <div class="p-8">
                <div class="bg-gray-100 rounded-3xl overflow-hidden max-h-[50vh] flex items-center justify-center">
                    <img id="imageToCrop" class="max-w-full">
                </div>
                
                <!-- Controls -->
                <div class="mt-8 flex flex-wrap items-center justify-center gap-4">
                    <div class="flex bg-gray-50 p-1.5 rounded-2xl border border-gray-100">
                        <button type="button" onclick="cropper.rotate(-90)" class="w-10 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400">
                            <i class="fas fa-undo"></i>
                        </button>
                        <button type="button" onclick="cropper.rotate(90)" class="w-10 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400">
                            <i class="fas fa-redo"></i>
                        </button>
                        <div class="w-px bg-gray-200 mx-1 my-2"></div>
                        <button type="button" onclick="cropper.scaleX(-1)" class="w-10 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400">
                            <i class="fas fa-arrows-alt-h"></i>
                        </button>
                    </div>

                    <div class="flex bg-gray-50 p-1.5 rounded-2xl border border-gray-100">
                        <button type="button" onclick="cropper.setAspectRatio(16/9)" class="px-4 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400 text-xs font-bold">16:9</button>
                        <button type="button" onclick="cropper.setAspectRatio(4/3)" class="px-4 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400 text-xs font-bold">4:3</button>
                        <button type="button" onclick="cropper.setAspectRatio(1)" class="px-4 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400 text-xs font-bold">1:1</button>
                        <button type="button" onclick="cropper.setAspectRatio(NaN)" class="px-4 h-10 rounded-xl hover:bg-white hover:text-brand-purple transition text-gray-400 text-xs font-bold">Bebas</button>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="bg-gray-50 px-8 py-6 flex flex-row-reverse gap-3">
                <button type="button" onclick="saveCroppedImage()" class="bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white px-8 py-3 rounded-2xl font-bold text-sm transition shadow-lg shadow-purple-100 flex items-center gap-2">
                    <i class="fas fa-check-circle"></i> Gunakan Gambar Ini
                </button>
                <button type="button" onclick="closeCropModal()" class="bg-white hover:bg-gray-100 text-gray-500 px-6 py-3 rounded-2xl font-bold text-sm border border-gray-100 transition">Batal</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal Delete -->
<div id="modalDelete" class="fixed inset-0 z-[100] hidden">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 backdrop-blur-sm" onclick="closeModal('modalDelete')"></div>
    <div class="flex min-h-full items-center justify-center p-4">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-sm">
            <div class="p-6 text-center">
                <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100 mb-4">
                    <i class="fas fa-trash text-red-600"></i>
                </div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Padam Hebahan?</h3>
                <p class="text-sm text-gray-500">Tindakan ini tidak boleh diundur.</p>
            </div>
            <form action="<%= request.getContextPath() %>/hebahan/delete" method="post" class="bg-gray-50 px-6 py-4 flex flex-row-reverse gap-2">
                <input type="hidden" name="id_hebahan" id="delete_id">
                <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded-xl font-bold text-sm">Ya, Padam</button>
                <button type="button" onclick="closeModal('modalDelete')" class="bg-white text-gray-500 px-4 py-2 rounded-xl font-bold text-sm border">Batal</button>
            </form>
        </div>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Hebahan Baru';
        document.getElementById('formHebahan').action = '<%= request.getContextPath() %>/hebahan/create';
        document.getElementById('id_hebahan').value = '';
        document.getElementById('formHebahan').reset();
        resetPosterSelection();
        document.getElementById('modalHebahan').classList.remove('hidden');
    }

    function openEditModal(btn) {
        document.getElementById('modalTitle').innerText = 'Kemaskini Hebahan';
        document.getElementById('formHebahan').action = '<%= request.getContextPath() %>/hebahan/update';
        document.getElementById('id_hebahan').value = btn.getAttribute('data-id');
        document.getElementById('tajuk').value = btn.getAttribute('data-tajuk');
        document.getElementById('kandungan').value = btn.getAttribute('data-kandungan');
        document.getElementById('kategori').value = btn.getAttribute('data-kategori');
        document.getElementById('status_hebahan').value = btn.getAttribute('data-status');
        document.getElementById('lokasi_acara').value = btn.getAttribute('data-lokasi');
        document.getElementById('tarikh_mula_acara').value = btn.getAttribute('data-mula');
        document.getElementById('tarikh_tamat_acara').value = btn.getAttribute('data-tamat_acara');
        document.getElementById('tarikh_tamat').value = btn.getAttribute('data-tamat_hebahan');
        
        resetPosterSelection();
        document.getElementById('modalHebahan').classList.remove('hidden');
    }

    // Functions for Resident View Preview
    function showHebahanDetail(data) {
        const modal = document.getElementById('modalDetailPreview');
        const img = document.getElementById('modalImage');
        const imgContainer = document.getElementById('modalImageContainer');
        const grad = document.getElementById('modalGradient');
        
        document.getElementById('modalTitlePreview').innerText = data.tajuk;
        document.getElementById('modalKandungan').innerText = data.kandungan;
        document.getElementById('modalLokasi').innerText = data.lokasi;
        document.getElementById('modalTarikhAcara').innerText = data.tarikhAcara;
        document.getElementById('modalTarikhHebahan').innerText = data.tarikhHebahan;
        
        const badge = document.getElementById('modalBadge');
        badge.innerText = data.kategori;
        badge.className = 'inline-block px-4 py-1.5 rounded-full text-[10px] font-bold uppercase mb-4 backdrop-blur-md border border-white/20 ' + data.badgeClass;

        if (data.gambar) {
            img.src = '${pageContext.request.contextPath}/file/hebahan/' + data.gambar;
            img.classList.remove('hidden');
            imgContainer.classList.remove('bg-gradient-to-br');
            grad.classList.remove('hidden');
        } else {
            img.classList.add('hidden');
            imgContainer.className = 'h-64 md:h-96 overflow-hidden relative bg-gradient-to-br from-[#6C5DD3] to-[#8B7EE0] flex items-center justify-center';
            grad.classList.add('hidden');
            const icon = document.createElement('i');
            icon.className = data.icon + ' text-white text-9xl opacity-20';
            icon.id = 'tempIcon';
            imgContainer.appendChild(icon);
        }

        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function closeDetailModal() {
        const modal = document.getElementById('modalDetailPreview');
        modal.classList.add('hidden');
        document.body.style.overflow = 'auto';
        
        const tempIcon = document.getElementById('tempIcon');
        if (tempIcon) tempIcon.remove();
        
        const imgContainer = document.getElementById('modalImageContainer');
        imgContainer.className = 'h-64 md:h-96 bg-gray-100 overflow-hidden relative';
    }

    function confirmDelete(id) {
        document.getElementById('delete_id').value = id;
        document.getElementById('modalDelete').classList.remove('hidden');
    }

    // closeModal centralized in footer.jsp

    function validateHebahanForm() {
        const mula = document.getElementById('tarikh_mula_acara').value;
        const tamat = document.getElementById('tarikh_tamat_acara').value;
        if (mula && tamat && new Date(tamat) <= new Date(mula)) {
            alert('Tarikh tamat acara mesti selepas tarikh mula.');
            return false;
        }
        return true;
    }

    // --- Image Adjustment & Cropper Logic ---
    let cropper;
    const cropModal = document.getElementById('modalCrop');
    const imageToCrop = document.getElementById('imageToCrop');
    const posterInput = document.getElementById('gambar_poster');
    const previewContainer = document.getElementById('posterPreviewContainer');
    const previewImage = document.getElementById('posterPreview');
    const fileNameLabel = document.getElementById('fileNameLabel');

    function handleFileSelect(input) {
        if (input.files && input.files[0]) {
            const file = input.files[0];
            const reader = new FileReader();
            
            reader.onload = function(e) {
                imageToCrop.src = e.target.result;
                openCropModal();
            };
            reader.readAsDataURL(file);
        }
    }

    function openCropModal() {
        cropModal.classList.remove('hidden');
        if (cropper) {
            cropper.destroy();
        }
        
        setTimeout(() => {
            cropper = new Cropper(imageToCrop, {
                aspectRatio: 16 / 9,
                viewMode: 2,
                autoCropArea: 1,
                responsive: true,
                restore: false,
                checkCrossOrigin: false,
                checkOrientation: false,
                guides: true,
                center: true,
                highlight: false,
                cropBoxMovable: true,
                cropBoxResizable: true,
                toggleDragModeOnDblclick: false,
            });
        }, 100);
    }

    function closeCropModal() {
        cropModal.classList.add('hidden');
        if (cropper) {
            cropper.destroy();
        }
    }

    function saveCroppedImage() {
        const canvas = cropper.getCroppedCanvas({
            width: 1280,
            height: 720,
            imageSmoothingEnabled: true,
            imageSmoothingQuality: 'high',
        });

        canvas.toBlob((blob) => {
            // Create a new File object from the blob
            const originalFile = posterInput.files[0];
            const croppedFile = new File([blob], originalFile.name, {
                type: 'image/jpeg',
                lastModified: Date.now()
            });

            // Replace the file input's content using DataTransfer
            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(croppedFile);
            posterInput.files = dataTransfer.files;

            // Show Preview
            previewImage.src = canvas.toDataURL('image/jpeg');
            previewContainer.classList.remove('hidden');
            fileNameLabel.innerText = originalFile.name + " (Telah Dipotong)";
            
            closeCropModal();
        }, 'image/jpeg', 0.9);
    }

    function resetPosterSelection() {
        posterInput.value = '';
        previewContainer.classList.add('hidden');
        previewImage.src = '';
        fileNameLabel.innerText = 'Pilih atau Seret Gambar Poster';
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
