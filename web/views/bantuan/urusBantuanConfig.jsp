<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.BantuanRule" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    List<BantuanRule> rules = (List<BantuanRule>) request.getAttribute("rules");
    Double povertyLine = (Double) request.getAttribute("povertyLine");
    if (povertyLine == null) povertyLine = 2500.0;

    Map<String, Double> weightsMap = new HashMap<>();
    if (rules != null) {
        for (BantuanRule r : rules) {
            weightsMap.put(r.getRuleKey(), r.getWeight());
        }
    }

    double wIncome = weightsMap.getOrDefault("INCOME_FACTOR", 40.0);
    double wDependent = weightsMap.getOrDefault("DEPENDENT_FACTOR", 25.0);
    double wFamily = weightsMap.getOrDefault("FAMILY_STATUS_FACTOR", 20.0);
    double wEmployment = weightsMap.getOrDefault("EMPLOYMENT_STATUS_FACTOR", 15.0);
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">
    <div class="max-w-4xl mx-auto">
        <!-- Breadcrumb / Header -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
                <span class="text-xs font-bold text-brand-purple uppercase tracking-wider">Pentadbiran Modul Bantuan</span>
                <h1 class="text-3xl font-extrabold text-gray-800 tracking-tight mt-1">Konfigurasi Aturan Kelayakan</h1>
            </div>
            <a href="<%= request.getContextPath() %>/bantuan/list" class="inline-flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-white border border-gray-200 text-gray-700 hover:text-brand-purple hover:border-purple-200 shadow-sm transition-all text-xs font-bold">
                <i class="fas fa-chevron-left text-[10px]"></i>
                Kembali ke Senarai
            </a>
        </div>

        <!-- Alert Notification -->
        <% if (request.getParameter("status") != null && "success".equals(request.getParameter("status"))) { %>
            <div class="mb-6 p-4 rounded-2xl bg-emerald-50 border border-emerald-200 text-emerald-700 flex items-center gap-3 animate-fade-in shadow-sm">
                <div class="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center text-emerald-600">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div>
                    <p class="text-sm font-bold">Konfigurasi Berjaya Disimpan</p>
                    <p class="text-xs text-emerald-600">Enjin scoring kelayakan telah dikemaskini secara langsung menggunakan berat aturan baharu.</p>
                </div>
            </div>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="mb-6 p-4 rounded-2xl bg-rose-50 border border-rose-200 text-rose-700 flex items-center gap-3 animate-fade-in shadow-sm">
                <div class="w-8 h-8 rounded-full bg-rose-100 flex items-center justify-center text-rose-600">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div>
                    <p class="text-sm font-bold">Ralat Menyimpan Konfigurasi</p>
                    <p class="text-xs text-rose-600">
                        <% if ("weight_sum".equals(request.getParameter("error"))) { %>
                            Jumlah berat aturan mestilah bersamaan dengan 100%. Sila semak semula pembahagian berat anda.
                        <% } else if ("invalid_input".equals(request.getParameter("error"))) { %>
                            Input tidak sah. Sila masukkan nilai nombor sahaja.
                        <% } else { %>
                            Masalah pangkalan data. Sila cuba seketika lagi.
                        <% } %>
                    </p>
                </div>
            </div>
        <% } %>

        <!-- Configuration Card Form -->
        <form id="configForm" action="<%= request.getContextPath() %>/bantuan/config/save" method="post" class="space-y-6">
            <input type="hidden" name="_csrf" value="${sessionScope.csrf_token}"/>
            
            <!-- SECTION 1: Poverty Line Threshold -->
            <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100 transition-all hover:shadow-md relative overflow-hidden">
                <div class="absolute -right-16 -top-16 w-36 h-36 bg-blue-50 rounded-full opacity-40"></div>
                <div class="relative z-10 flex items-start gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-500 flex items-center justify-center text-xl shadow-sm shrink-0">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="flex-1">
                        <h2 class="text-lg font-bold text-gray-800 mb-1">Paras Pendapatan Kemiskinan</h2>
                        <p class="text-gray-500 text-xs leading-relaxed mb-4">Tetapkan nilai had bulanan isi rumah yang digunapakai sebagai KKM Poverty Line untuk pengiraan nisbah kemiskinan.</p>
                        
                        <div class="max-w-xs">
                            <label class="block text-xs font-bold text-gray-500 uppercase mb-2">Had Kemiskinan (RM)</label>
                            <div class="relative rounded-2xl shadow-sm">
                                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                    <span class="text-gray-400 font-bold text-sm">RM</span>
                                </div>
                                <input type="number" step="0.01" name="povertyLine" id="povertyLine" value="<%= String.format("%.2f", povertyLine) %>" 
                                       class="block w-full pl-12 pr-4 py-3 border border-gray-200 rounded-2xl text-gray-800 font-bold placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-brand-purple focus:border-brand-purple sm:text-sm" required />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: Dynamic Eligibility Weight Factors -->
            <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100 transition-all hover:shadow-md relative overflow-hidden">
                <div class="absolute -right-16 -top-16 w-36 h-36 bg-purple-50 rounded-full opacity-40"></div>
                
                <div class="relative z-10">
                    <div class="flex items-start gap-4 mb-6">
                        <div class="w-12 h-12 rounded-2xl bg-purple-50 text-brand-purple flex items-center justify-center text-xl shadow-sm shrink-0">
                            <i class="fas fa-sliders-h"></i>
                        </div>
                        <div>
                            <h2 class="text-lg font-bold text-gray-800 mb-1">Berat Faktor Kelayakan</h2>
                            <p class="text-gray-500 text-xs leading-relaxed">Pecahkan nilai kepentingan (weightage) untuk 4 parameter utama kelayakan. **Jumlah berat mestilah tepat 100%**.</p>
                        </div>
                    </div>

                    <!-- Rule Sliders -->
                    <div class="space-y-6 mt-8">
                        <!-- Rule 1: Income -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 transition-all">
                            <div class="flex justify-between items-center mb-2">
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-blue-500"></span>
                                    <span class="text-sm font-bold text-gray-800">Faktor Pendapatan Rendah</span>
                                </div>
                                <span class="text-sm font-extrabold text-blue-600 bg-blue-50 px-3 py-1 rounded-full"><span id="valIncome"><%= (int)wIncome %></span>%</span>
                            </div>
                            <input type="range" min="0" max="100" name="weightIncome" id="weightIncome" value="<%= (int)wIncome %>" 
                                   class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-brand-purple" oninput="updateSliders()" />
                            <div class="flex justify-between text-[10px] text-gray-400 mt-2">
                                <span>Tiada kepentingan (0%)</span>
                                <span>Utamakan sepenuhnya (100%)</span>
                            </div>
                        </div>

                        <!-- Rule 2: Dependents -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 transition-all">
                            <div class="flex justify-between items-center mb-2">
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-emerald-500"></span>
                                    <span class="text-sm font-bold text-gray-800">Faktor Bilangan Tanggungan</span>
                                </div>
                                <span class="text-sm font-extrabold text-emerald-600 bg-emerald-50 px-3 py-1 rounded-full"><span id="valDependent"><%= (int)wDependent %></span>%</span>
                            </div>
                            <input type="range" min="0" max="100" name="weightDependent" id="weightDependent" value="<%= (int)wDependent %>" 
                                   class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-brand-purple" oninput="updateSliders()" />
                            <div class="flex justify-between text-[10px] text-gray-400 mt-2">
                                <span>Tiada kepentingan (0%)</span>
                                <span>Utamakan sepenuhnya (100%)</span>
                            </div>
                        </div>

                        <!-- Rule 3: Family Status -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 transition-all">
                            <div class="flex justify-between items-center mb-2">
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-amber-500"></span>
                                    <span class="text-sm font-bold text-gray-800">Faktor Status Ibu Tunggal/OKU</span>
                                </div>
                                <span class="text-sm font-extrabold text-amber-600 bg-amber-50 px-3 py-1 rounded-full"><span id="valFamily"><%= (int)wFamily %></span>%</span>
                            </div>
                            <input type="range" min="0" max="100" name="weightFamily" id="weightFamily" value="<%= (int)wFamily %>" 
                                   class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-brand-purple" oninput="updateSliders()" />
                            <div class="flex justify-between text-[10px] text-gray-400 mt-2">
                                <span>Tiada kepentingan (0%)</span>
                                <span>Utamakan sepenuhnya (100%)</span>
                            </div>
                        </div>

                        <!-- Rule 4: Employment -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 transition-all">
                            <div class="flex justify-between items-center mb-2">
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-indigo-500"></span>
                                    <span class="text-sm font-bold text-gray-800">Faktor Pengangguran</span>
                                </div>
                                <span class="text-sm font-extrabold text-indigo-600 bg-indigo-50 px-3 py-1 rounded-full"><span id="valEmployment"><%= (int)wEmployment %></span>%</span>
                            </div>
                            <input type="range" min="0" max="100" name="weightEmployment" id="weightEmployment" value="<%= (int)wEmployment %>" 
                                   class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-brand-purple" oninput="updateSliders()" />
                            <div class="flex justify-between text-[10px] text-gray-400 mt-2">
                                <span>Tiada kepentingan (0%)</span>
                                <span>Utamakan sepenuhnya (100%)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Real-time Sum Indicator -->
                    <div class="mt-8 pt-6 border-t border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-4">
                        <div class="flex items-center gap-3">
                            <div id="sumCircle" class="w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold transition-all shadow-sm">
                                <span id="valTotal">100</span>%
                            </div>
                            <div>
                                <p class="text-sm font-bold text-gray-800">Jumlah Pembahagian Berat</p>
                                <p id="sumMessage" class="text-xs transition-colors"></p>
                            </div>
                        </div>
                        
                        <button type="submit" id="btnSubmit" class="inline-flex items-center gap-2 px-6 py-3 rounded-2xl text-sm font-bold text-white shadow-lg transition-all transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-offset-2">
                            <i class="fas fa-save"></i>
                            Simpan Konfigurasi
                        </button>
                    </div>
                </div>
            </div>
        </form>
</div>
</div>

<aside class="w-80 bg-white/80 border-l border-slate-100 backdrop-blur-md hidden xl:flex flex-col p-8 overflow-y-auto h-full shrink-0">
    <div class="mb-8">
        <h3 class="text-lg font-black text-gray-900 tracking-tight">Ringkasan Enjin Kelayakan</h3>
        <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1">Status Aturan Semasa</p>
    </div>

    <!-- Active Poverty Line Display -->
    <div class="bg-indigo-50/50 p-5 rounded-[2rem] border border-indigo-100/50 flex flex-col gap-2 mb-6 group hover:bg-indigo-50 transition-all">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-indigo-100 text-indigo-600 rounded-xl flex items-center justify-center shadow-sm">
                <i class="fas fa-hand-holding-usd text-lg"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Garis Kemiskinan Semasa</p>
                <h4 class="font-black text-xl text-gray-900">RM <%= String.format("%,.2f", povertyLine) %></h4>
            </div>
        </div>
        <div class="mt-2 text-[11px] text-indigo-600 font-medium">
            * Penduduk dengan pendapatan di bawah had ini diberi skor penuh 100 markah untuk faktor pendapatan.
        </div>
    </div>

    <!-- Algorithm Status -->
    <div class="bg-emerald-50/50 p-5 rounded-[2rem] border border-emerald-100/50 flex flex-col gap-2 mb-6 group hover:bg-emerald-50 transition-all">
        <div class="flex items-center gap-3">
            <div class="w-10 h-10 bg-emerald-100 text-emerald-600 rounded-xl flex items-center justify-center shadow-sm">
                <i class="fas fa-cogs text-lg"></i>
            </div>
            <div>
                <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Enjin Scoring Kelayakan</p>
                <span class="px-2.5 py-0.5 rounded-full bg-emerald-100 border border-emerald-200 text-emerald-700 text-[10px] font-black uppercase inline-block mt-1">
                    Aktif & Dinamik
                </span>
            </div>
        </div>
    </div>

    <!-- Interactive Guideline Card -->
    <div class="mt-4 pt-6 border-t border-gray-150">
        <h4 class="text-[11px] font-black text-gray-400 uppercase tracking-widest mb-4">Panduan Penyelarasan Berat</h4>
        
        <div class="space-y-4">
            <!-- Guideline Item 1 -->
            <div class="p-4 bg-white/60 border border-slate-100 rounded-2xl flex gap-3 text-xs">
                <div class="text-blue-500 shrink-0 mt-0.5">
                    <i class="fas fa-info-circle"></i>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800 mb-0.5">Faktor Pendapatan</h5>
                    <p class="text-gray-500 leading-relaxed font-medium">Mengukur jurang kemiskinan relatif kepada paras garis kemiskinan (poverty line) yang ditetapkan.</p>
                </div>
            </div>

            <!-- Guideline Item 2 -->
            <div class="p-4 bg-white/60 border border-slate-100 rounded-2xl flex gap-3 text-xs">
                <div class="text-emerald-500 shrink-0 mt-0.5">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800 mb-0.5">Bilangan Tanggungan</h5>
                    <p class="text-gray-500 leading-relaxed font-medium">Semakin ramai tanggungan isi rumah, semakin tinggi wajaran merit kelayakan yang diperoleh.</p>
                </div>
            </div>

            <!-- Guideline Item 3 -->
            <div class="p-4 bg-white/60 border border-slate-100 rounded-2xl flex gap-3 text-xs">
                <div class="text-amber-500 shrink-0 mt-0.5">
                    <i class="fas fa-heart"></i>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800 mb-0.5">Status Ibu Tunggal / OKU</h5>
                    <p class="text-gray-500 leading-relaxed font-medium">Memberikan keutamaan merit tambahan kepada golongan rentan secara automatik.</p>
                </div>
            </div>

            <!-- Guideline Item 4 -->
            <div class="p-4 bg-white/60 border border-slate-100 rounded-2xl flex gap-3 text-xs">
                <div class="text-indigo-500 shrink-0 mt-0.5">
                    <i class="fas fa-briefcase-slash"></i>
                </div>
                <div>
                    <h5 class="font-bold text-gray-800 mb-0.5">Faktor Pengangguran</h5>
                    <p class="text-gray-500 leading-relaxed font-medium">Menilai status pekerjaan ketua keluarga untuk menyokong pemohon yang hilang punca pendapatan.</p>
                </div>
            </div>
        </div>
    </div>
</aside>


<script>
    function updateSliders() {
        const income = parseInt(document.getElementById('weightIncome').value) || 0;
        const dependent = parseInt(document.getElementById('weightDependent').value) || 0;
        const family = parseInt(document.getElementById('weightFamily').value) || 0;
        const employment = parseInt(document.getElementById('weightEmployment').value) || 0;

        document.getElementById('valIncome').innerText = income;
        document.getElementById('valDependent').innerText = dependent;
        document.getElementById('valFamily').innerText = family;
        document.getElementById('valEmployment').innerText = employment;

        const total = income + dependent + family + employment;
        document.getElementById('valTotal').innerText = total;

        const circle = document.getElementById('sumCircle');
        const message = document.getElementById('sumMessage');
        const button = document.getElementById('btnSubmit');

        if (total === 100) {
            circle.className = 'w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold transition-all shadow-sm bg-emerald-100 text-emerald-600 border border-emerald-200';
            message.innerText = 'Sempurna! Pembahagian adalah tepat 100%.';
            message.className = 'text-xs text-emerald-600 font-bold';
            
            button.disabled = false;
            button.className = 'inline-flex items-center gap-2 px-6 py-3 rounded-2xl text-sm font-bold text-white bg-brand-purple hover:bg-brand-purple/95 shadow-lg shadow-purple-100 hover:shadow-xl transition-all transform hover:scale-[1.02] cursor-pointer';
        } else {
            circle.className = 'w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold transition-all shadow-sm bg-rose-100 text-rose-600 border border-rose-200';
            message.innerText = 'Nilai semisal mesti ' + (total > 100 ? 'kurang ' + (total - 100) : 'tambah ' + (100 - total)) + '% untuk mencukupi 100%.';
            message.className = 'text-xs text-rose-600 font-bold';
            
            button.disabled = true;
            button.className = 'inline-flex items-center gap-2 px-6 py-3 rounded-2xl text-sm font-bold text-gray-400 bg-gray-100 border border-gray-200 shadow-none cursor-not-allowed';
        }
    }

    // Run once on load
    window.addEventListener('DOMContentLoaded', updateSliders);
</script>

<%@ include file="/views/common/footer.jsp" %>
