<%@ page import="java.util.List" %>
<%@ page import="model.Fasiliti" %>
<%@ page import="model.TempahanFasiliti" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<Fasiliti> senaraiFasiliti = (List<Fasiliti>) request.getAttribute("senaraiFasiliti");
    List<TempahanFasiliti> senaraiTempahan = (List<TempahanFasiliti>) request.getAttribute("senaraiTempahan");
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 bg-[#F7F7F9]">
    <!-- Header -->
    <header class="flex justify-between items-center mb-8">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Fasiliti Kampung</h2>
            <p class="text-gray-500 text-sm">Tempah kemudahan kampung secara dalam talian dengan mudah.</p>
        </div>
    </header>

    <!-- Alerts -->
    <% if (request.getParameter("success") != null) { %>
        <div class="bg-green-50 border border-green-100 text-green-700 px-6 py-4 rounded-3xl mb-8 flex items-center gap-4 animate-fade-in shadow-sm">
            <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center text-green-600">
                <i class="fas fa-check-circle"></i>
            </div>
            <p class="font-bold text-sm">Berjaya! Permohonan tempahan anda telah dihantar untuk semakan.</p>
        </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
        <div class="bg-red-50 border border-red-100 text-red-700 px-6 py-4 rounded-3xl mb-8 flex items-center gap-4 animate-fade-in shadow-sm">
            <div class="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center text-red-600">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <p class="font-bold text-sm">Ralat! Sila pastikan masa tempahan tidak bertindih dengan tempahan lain.</p>
        </div>
    <% } %>

    <!-- Stat Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5 group hover:shadow-md transition-all duration-300">
            <div class="w-14 h-14 bg-indigo-50 text-brand-purple rounded-2xl flex items-center justify-center text-xl group-hover:scale-110 transition-transform">
                <i class="fas fa-building-circle-check"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Fasiliti Aktif</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= (senaraiFasiliti != null) ? senaraiFasiliti.size() : 0 %></h3>
            </div>
        </div>
        <div class="bg-white p-6 rounded-[2rem] shadow-sm border border-gray-100 flex items-center gap-5 group hover:shadow-md transition-all duration-300">
            <div class="w-14 h-14 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center text-xl group-hover:scale-110 transition-transform">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1">Tempahan Saya</p>
                <h3 class="text-2xl font-bold text-gray-800"><%= (senaraiTempahan != null) ? senaraiTempahan.size() : 0 %></h3>
            </div>
        </div>
    </div>

    <!-- Main Content Tabs -->
    <div class="mb-8 border-b border-gray-200">
        <nav class="flex gap-8">
            <button onclick="switchTab('senarai')" id="tab-senarai" class="pb-4 px-2 text-sm font-bold border-b-2 border-brand-purple text-brand-purple transition-all">Senarai Fasiliti</button>
            <button onclick="switchTab('sejarah')" id="tab-sejarah" class="pb-4 px-2 text-sm font-bold border-b-2 border-transparent text-gray-400 hover:text-gray-600 transition-all">Sejarah Tempahan</button>
        </nav>
    </div>

    <!-- Tab 1: Senarai Fasiliti -->
    <div id="content-senarai" class="block">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% if (senaraiFasiliti != null && !senaraiFasiliti.isEmpty()) { 
                for (Fasiliti f : senaraiFasiliti) { %>
                <div class="bg-white rounded-[2.5rem] p-8 border border-gray-50 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300">
                    <div class="flex justify-between items-start mb-6">
                        <div class="w-14 h-14 bg-brand-purple bg-opacity-10 text-brand-purple rounded-2xl flex items-center justify-center text-xl">
                            <i class="fas fa-building"></i>
                        </div>
                        <span class="bg-green-100 text-green-600 text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider">Aktif</span>
                    </div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2"><%= f.getNama_fasiliti() %></h3>
                    <div class="flex items-center gap-2 text-gray-400 text-sm mb-8">
                        <i class="fas fa-location-dot"></i>
                        <span><%= f.getLokasi() %></span>
                    </div>
                    <button onclick="openBookingModal('<%= f.getId_fasiliti() %>', '<%= f.getNama_fasiliti() %>')" 
                            class="w-full py-4 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-lg shadow-indigo-100 hover:bg-opacity-90 transition-all">
                        Tempah Sekarang
                    </button>
                </div>
            <% } } else { %>
                <div class="col-span-full py-20 text-center bg-white rounded-[2.5rem] border border-dashed border-gray-300">
                    <i class="fas fa-building-circle-exclamation text-4xl text-gray-200 mb-4"></i>
                    <p class="text-gray-400 font-medium">Tiada fasiliti tersedia buat masa ini.</p>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Tab 2: Sejarah Tempahan -->
    <div id="content-sejarah" class="hidden">
        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-100">
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Fasiliti</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tarikh & Masa</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Status</th>
                            <th class="px-8 py-5 text-[10px] font-bold text-gray-400 uppercase tracking-widest">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                        <% if (senaraiTempahan != null && !senaraiTempahan.isEmpty()) { 
                            for (TempahanFasiliti t : senaraiTempahan) { %>
                            <tr class="hover:bg-gray-50/50 transition-colors">
                                <td class="px-8 py-6">
                                    <div class="flex items-center gap-4">
                                        <div class="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center text-brand-purple">
                                            <i class="fas fa-building text-sm"></i>
                                        </div>
                                        <div>
                                            <p class="text-sm font-bold text-gray-800"><%= t.getNama_fasiliti() %></p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-8 py-6">
                                    <p class="text-sm font-bold text-gray-700 mb-1"><%= t.getTarikh_tempah() %></p>
                                    <p class="text-xs text-gray-400 font-medium"><%= t.getMasa_mula() %> - <%= t.getMasa_tamat() %></p>
                                </td>
                                <td class="px-8 py-6">
                                    <% if ("LULUS".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-green-50 text-green-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-check-circle text-[8px]"></i> LULUS
                                        </span>
                                    <% } else if ("TOLAK".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-red-50 text-red-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-times-circle text-[8px]"></i> TOLAK
                                        </span>
                                    <% } else if ("DIBATAL".equals(t.getStatus())) { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-gray-100 text-gray-500 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-ban text-[8px]"></i> BATAL
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-[10px] font-bold">
                                            <i class="fas fa-clock text-[8px]"></i> MENUNGGU
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-8 py-6">
                                    <% if ("MENUNGGU".equals(t.getStatus())) { %>
                                        <a href="<%= contextPath %>/fasiliti/batal?id=<%= t.getId_tempahan() %>" 
                                           onclick="return confirm('Adakah anda pasti mahu membatalkan tempahan ini?')"
                                           class="text-xs font-bold text-red-400 hover:text-red-600 transition-colors">Batal Tempahan</a>
                                    <% } else { %>
                                        <span class="text-xs text-gray-300 italic">-</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="4" class="px-8 py-10 text-center text-gray-400 text-sm italic">Tiada sejarah tempahan ditemui.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Tempahan -->
<div id="modalTempah" class="fixed inset-0 z-50 hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-lg bg-white rounded-[2.5rem] shadow-2xl p-8 transform transition-all">
            <header class="flex justify-between items-center mb-8">
                <div>
                    <h3 class="text-xl font-bold text-gray-800">Borang Tempahan</h3>
                    <p class="text-xs text-gray-400 mt-1" id="modalFasilitiName"></p>
                </div>
                <button onclick="closeModal()" class="w-10 h-10 flex items-center justify-center text-gray-400 hover:text-gray-600 bg-gray-50 rounded-xl">
                    <i class="fas fa-times"></i>
                </button>
            </header>

            <form action="<%= contextPath %>/fasiliti/tempah" method="post" class="space-y-6" id="formTempah">
                <input type="hidden" name="id_fasiliti" id="modalIdFasiliti">
                
                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Tarikh Tempahan</label>
                    <input type="date" name="tarikh_tempah" id="tarikh_tempah" required 
                           class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                </div>

                <div class="space-y-2">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Tempoh Tempahan</label>
                    <select name="tempoh_tempahan" id="tempoh_tempahan" onchange="toggleDuration()"
                            class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        <option value="1">1 Jam</option>
                        <option value="2">2 Jam</option>
                        <option value="specific">Masa Spesifik</option>
                    </select>
                </div>

                <div class="space-y-2" id="slot_container">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Pilih Slot Masa</label>
                    <select id="slot_select" onchange="applySlot()"
                            class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                        <option value="">Sila pilih tarikh & tempoh dahulu...</option>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-4 hidden" id="manual_time_container">
                    <div class="space-y-2">
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Waktu Mula</label>
                        <input type="time" name="masa_mula" id="masa_mula" 
                               class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                    </div>
                    <div class="space-y-2">
                        <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Waktu Tamat</label>
                        <input type="time" name="masa_tamat" id="masa_tamat" 
                               class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium">
                    </div>
                </div>

                <!-- Hidden inputs to hold the actual values for form submission when using slots -->
                <input type="hidden" name="masa_mula_hidden" id="masa_mula_hidden">
                <input type="hidden" name="masa_tamat_hidden" id="masa_tamat_hidden">

                <div class="space-y-2 hidden" id="catatan_container">
                    <label class="block text-[10px] font-bold text-gray-400 uppercase tracking-widest px-2">Sebab / Catatan</label>
                    <textarea name="catatan_pemohon" id="catatan_pemohon" rows="3"
                              class="w-full px-6 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-brand-purple text-sm font-medium"
                              placeholder="Nyatakan sebab anda memerlukan tempoh masa yang spesifik..."></textarea>
                </div>

                <button type="submit" class="w-full py-5 bg-brand-purple text-white rounded-2xl font-bold text-sm shadow-xl shadow-indigo-100 hover:bg-opacity-90 mt-8 transition-all">
                    Sahkan Tempahan
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleDuration() {
        const tempoh = document.getElementById('tempoh_tempahan').value;
        const slotContainer = document.getElementById('slot_container');
        const manualContainer = document.getElementById('manual_time_container');
        const catatanContainer = document.getElementById('catatan_container');
        
        const masaMula = document.getElementById('masa_mula');
        const masaTamat = document.getElementById('masa_tamat');
        const catatanInput = document.getElementById('catatan_pemohon');

        if (tempoh === 'specific') {
            slotContainer.classList.add('hidden');
            manualContainer.classList.remove('hidden');
            catatanContainer.classList.remove('hidden');
            
            masaMula.required = true;
            masaTamat.required = true;
            catatanInput.required = true;
            
            // Reset hidden inputs
            document.getElementById('masa_mula_hidden').value = "";
            document.getElementById('masa_tamat_hidden').value = "";
        } else {
            slotContainer.classList.remove('hidden');
            manualContainer.classList.add('hidden');
            catatanContainer.classList.add('hidden');
            
            masaMula.required = false;
            masaTamat.required = false;
            catatanInput.required = false;
            
            loadSlots();
        }
    }

    function loadSlots() {
        const idFasiliti = document.getElementById('modalIdFasiliti').value;
        const tempoh = document.getElementById('tempoh_tempahan').value;
        const slotSelect = document.getElementById('slot_select');

        if (!idFasiliti || tempoh === 'specific') return;

        slotSelect.innerHTML = '<option value="">Memuatkan slot...</option>';

        fetch(`<%= contextPath %>/fasiliti/getSlots?idFasiliti=${idFasiliti}&durasi=${tempoh}`)
            .then(response => response.json())
            .then(data => {
                slotSelect.innerHTML = '<option value="">Pilih Slot Masa</option>';
                if (data.length === 0) {
                    slotSelect.innerHTML = '<option value="">Tiada slot ditetapkan oleh admin</option>';
                } else {
                    data.forEach(slot => {
                        const option = document.createElement('option');
                        option.value = JSON.stringify({mula: slot.mula, tamat: slot.tamat});
                        option.textContent = `${slot.mula.substring(0,5)} - ${slot.tamat.substring(0,5)}`;
                        slotSelect.appendChild(option);
                    });
                }
            })
            .catch(err => {
                console.error('Error fetching slots:', err);
                slotSelect.innerHTML = '<option value="">Ralat memuatkan slot</option>';
            });
    }

    function applySlot() {
        const slotVal = document.getElementById('slot_select').value;
        if (!slotVal) return;
        
        const slot = JSON.parse(slotVal);
        document.getElementById('masa_mula_hidden').value = slot.mula;
        document.getElementById('masa_tamat_hidden').value = slot.tamat;
    }

    // Update form submission to use hidden inputs if slots are used
    document.getElementById('formTempah').onsubmit = function(e) {
        const tempoh = document.getElementById('tempoh_tempahan').value;
        if (tempoh !== 'specific') {
            const mula = document.getElementById('masa_mula_hidden').value;
            const tamat = document.getElementById('masa_tamat_hidden').value;
            
            if (!mula || !tamat) {
                alert("Sila pilih slot masa!");
                e.preventDefault();
                return false;
            }
            
            // Assign hidden values to the actual named inputs before submit
            document.getElementById('masa_mula').value = mula.substring(0,5);
            document.getElementById('masa_tamat').value = tamat.substring(0,5);
        }
    };

    function switchTab(tabId) {
        // Update Tabs UI
        document.querySelectorAll('nav button').forEach(btn => {
            btn.classList.remove('border-brand-purple', 'text-brand-purple');
            btn.classList.add('border-transparent', 'text-gray-400');
        });
        document.getElementById('tab-' + tabId).classList.add('border-brand-purple', 'text-brand-purple');
        document.getElementById('tab-' + tabId).classList.remove('border-transparent', 'text-gray-400');

        // Update Content
        document.getElementById('content-senarai').classList.add('hidden');
        document.getElementById('content-sejarah').classList.add('hidden');
        document.getElementById('content-' + tabId).classList.remove('hidden');
    }

    function openBookingModal(id, name) {
        document.getElementById('modalIdFasiliti').value = id;
        document.getElementById('modalFasilitiName').innerText = "Tempahan untuk: " + name;
        document.getElementById('modalTempah').classList.remove('hidden');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('modalTempah').classList.add('hidden');
        document.body.style.overflow = 'auto';
    }
</script>

<%@ include file="/views/common/footer.jsp" %>
