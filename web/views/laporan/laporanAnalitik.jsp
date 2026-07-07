<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.LaporanSnapshot" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    // Retreive scoped statistics from servlet context attributes
    Integer totalPenduduk = (Integer) request.getAttribute("totalPenduduk");
    Double averageIncome = (Double) request.getAttribute("averageIncome");
    if (averageIncome == null) averageIncome = 0.0;

    Map<String, Integer> ageDist = (Map<String, Integer>) request.getAttribute("ageDistribution");
    Map<String, Integer> familyDist = (Map<String, Integer>) request.getAttribute("familyStatusDistribution");
    Map<String, Integer> incomeDist = (Map<String, Integer>) request.getAttribute("incomeDistribution");

    Integer totalBantuan = (Integer) request.getAttribute("totalBantuan");
    Map<String, Integer> banStats = (Map<String, Integer>) request.getAttribute("bantuanSummaryStats");
    Map<String, Integer> banRatio = (Map<String, Integer>) request.getAttribute("bantuanTypeRatio");
    Map<String, Integer> banScore = (Map<String, Integer>) request.getAttribute("bantuanScoreDistribution");

    Integer totalAduan = (Integer) request.getAttribute("totalAduan");
    Map<String, Integer> aduStats = (Map<String, Integer>) request.getAttribute("aduanSummaryStats");
    Map<String, Integer> aduCat = (Map<String, Integer>) request.getAttribute("aduanCategoryStats");
    Map<String, Integer> aduPrio = (Map<String, Integer>) request.getAttribute("aduanPriorityStats");

    Integer totalTempahan = (Integer) request.getAttribute("totalTempahan");
    Map<String, Integer> fasUsage = (Map<String, Integer>) request.getAttribute("fasilitiUsageStats");
    Map<String, Integer> fasStatus = (Map<String, Integer>) request.getAttribute("fasilitiStatusStats");

    List<LaporanSnapshot> snapshots = (List<LaporanSnapshot>) request.getAttribute("monthlySnapshots");

    // Calculate Bantuan statistics globally
    int lulusB = 0;
    int totalB = 0;
    if (banStats != null) {
        lulusB = banStats.getOrDefault("LULUS", 0);
        for (int v : banStats.values()) totalB += v;
    }
    double rateB = totalB > 0 ? (lulusB * 100.0 / totalB) : 0.0;

    // Calculate Aduan statistics globally
    int selesaiA = 0;
    int totalA = 0;
    if (aduStats != null) {
        selesaiA = aduStats.getOrDefault("RESOLVED", 0) + aduStats.getOrDefault("CLOSED", 0);
        for (int v : aduStats.values()) totalA += v;
    }
    double rateA = totalA > 0 ? (selesaiA * 100.0 / totalA) : 0.0;

    // Roles and Scoping Checks
    boolean isKetua = "Ketua Kampung".equalsIgnoreCase(role);
    boolean isSetiausaha = "AJK Kampung".equalsIgnoreCase(role) && "Setiausaha".equalsIgnoreCase(biro);
    boolean isKebajikan = "AJK Kampung".equalsIgnoreCase(role) && "Biro Kebajikan & Sosial".equalsIgnoreCase(biro);
    boolean isSukan = "AJK Kampung".equalsIgnoreCase(role) && "Biro Sukan & Riadah".equalsIgnoreCase(biro);
    boolean isKeselamatan = "AJK Kampung".equalsIgnoreCase(role) && "Biro Keselamatan".equalsIgnoreCase(biro);

    // Default to the first allowed section for AJKs
    String defaultTab = "ringkasan";
    if (isSetiausaha) defaultTab = "demografi";
    else if (isKebajikan) defaultTab = "kebajikan";
    else if (isSukan) defaultTab = "fasiliti";
    else if (isKeselamatan) defaultTab = "aduan";
%>

<!-- Include dynamic google font & CDN resources -->
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

<style>
    body {
        font-family: 'Outfit', sans-serif;
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.3);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .glass-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.07);
    }
    .bg-gradient-purple {
        background: linear-gradient(135deg, #7C3AED 0%, #4F46E5 100%);
    }
    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #E5E7EB;
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #D1D5DB;
    }
    
    /* Premium Print styling for Native PDF Export fallback */
    @media print {
        aside, 
        .print\:hidden,
        #btnPdf,
        button,
        select,
        .tab-btn,
        .aside-tab-btn,
        .border-b.border-slate-100 {
            display: none !important;
        }
        
        .tab-panel {
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
        
        body, .flex-1, #report-container {
            background: #ffffff !important;
            color: #1e293b !important;
            padding: 0 !important;
            margin: 0 !important;
            width: 100% !important;
            max-width: 100% !important;
            box-shadow: none !important;
            backdrop-filter: none !important;
        }
        
        .glass-card {
            background: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            box-shadow: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            page-break-inside: avoid;
            margin-bottom: 2rem !important;
            transform: none !important;
        }
        
        .bg-gradient-purple {
            background: #4F46E5 !important;
            color: #ffffff !important;
        }
        
        canvas {
            max-width: 100% !important;
            height: auto !important;
        }
    }
</style>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F8FAFC] custom-scrollbar">
    <div class="max-w-7xl mx-auto" id="report-container">
        
        <!-- Header Section -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8 border-b border-slate-100 pb-6">
            <div>
                <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-indigo-50 border border-indigo-100 text-indigo-600 text-xs font-bold uppercase tracking-wider">
                    <i class="fas fa-chart-pie"></i> Portal Analitik Kampung
                </span>
                <h1 class="text-3xl font-extrabold text-slate-800 tracking-tight mt-2 leading-tight">
                    Laporan & Analitik Komuniti
                </h1>
                <p class="text-sm text-slate-500 mt-1">
                    <% if (isKetua) { %>
                        Dashboard Eksekutif penuh bagi pengurusan kebajikan, aduan, fasiliti, dan demografi penduduk.
                    <% } else { %>
                        Laporan bertapis bagi portfolio AJK: <strong class="text-indigo-600"><%= biro %></strong>.
                    <% } %>
                </p>
            </div>
            
            <div class="flex flex-wrap items-center gap-3 print:hidden">
                <span id="currentDate" class="inline-flex items-center gap-1.5 px-3.5 py-2.5 rounded-2xl bg-white border border-slate-200 text-slate-500 text-xs font-semibold shadow-sm">
                    <i class="far fa-calendar-alt text-indigo-500"></i> -
                </span>
                <% if (isKetua) { %>
                    <button onclick="saveCurrentSnapshot()" class="inline-flex items-center gap-2 px-4 py-2.5 rounded-2xl bg-white border border-slate-200 text-slate-700 hover:text-indigo-600 hover:border-indigo-200 shadow-sm transition-all text-xs font-bold">
                        <i class="fas fa-camera text-indigo-500"></i> Simpan Snapshot
                    </button>
                    <button onclick="exportToPDF()" id="btnPdf" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white shadow-md shadow-indigo-100 transition-all text-xs font-bold">
                        <i class="fas fa-file-pdf"></i> Cetak PDF Penuh
                    </button>
                <% } else { %>
                    <button onclick="exportToPDF()" id="btnPdf" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white shadow-md shadow-indigo-100 transition-all text-xs font-bold">
                        <i class="fas fa-file-pdf"></i> Eksport PDF Biro
                    </button>
                <% } %>
            </div>
        </div>

        <!-- Navigation Tabs (Only shown to Ketua Kampung) -->
        <% if (isKetua) { %>
            <div class="flex flex-wrap gap-2 mb-8 border-b border-slate-100 pb-4 print:hidden xl:hidden">
                <button onclick="switchTab('ringkasan')" id="tab-ringkasan" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all bg-indigo-600 text-white shadow-sm flex items-center gap-2">
                    <i class="fas fa-home"></i> KPI & Trend Bulanan
                </button>
                <button onclick="switchTab('demografi')" id="tab-demografi" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all text-slate-600 hover:bg-slate-100 hover:text-slate-900 flex items-center gap-2">
                    <i class="fas fa-users"></i> Demografi Penduduk
                </button>
                <button onclick="switchTab('kebajikan')" id="tab-kebajikan" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all text-slate-600 hover:bg-slate-100 hover:text-slate-900 flex items-center gap-2">
                    <i class="fas fa-hand-holding-heart"></i> Kebajikan & Bantuan
                </button>
                <button onclick="switchTab('aduan')" id="tab-aduan" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all text-slate-600 hover:bg-slate-100 hover:text-slate-900 flex items-center gap-2">
                    <i class="fas fa-exclamation-circle"></i> Aduan Komuniti
                </button>
                <button onclick="switchTab('fasiliti')" id="tab-fasiliti" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all text-slate-600 hover:bg-slate-100 hover:text-slate-900 flex items-center gap-2">
                    <i class="fas fa-calendar-alt"></i> Fasiliti Kampung
                </button>
                <button onclick="switchTab('ai')" id="tab-ai" class="tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all bg-purple-50 text-purple-600 border border-purple-100 hover:bg-purple-100 flex items-center gap-2">
                    <i class="fas fa-robot text-purple-500 animate-pulse"></i> Ulasan AI Gemini
                </button>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 1: RINGKASAN & KPI ==================== -->
        <% if (isKetua) { %>
            <div id="panel-ringkasan" class="tab-panel space-y-8">
                <!-- KPI Cards Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xl">
                            <i class="fas fa-users-viewfinder"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Jumlah Penduduk</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= totalPenduduk != null ? totalPenduduk : 0 %> <span class="text-xs font-normal text-slate-400">orang</span></span>
                        </div>
                    </div>
                    

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center text-xl">
                            <i class="fas fa-heart-circle-check"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Kelulusan Bantuan</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= String.format("%.1f", rateB) %>%</span>
                        </div>
                    </div>


                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-rose-50 border border-rose-100 text-rose-600 flex items-center justify-center text-xl">
                            <i class="fas fa-shield-halved"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Penyelesaian Aduan</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= String.format("%.1f", rateA) %>%</span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-amber-50 border border-amber-100 text-amber-600 flex items-center justify-center text-xl">
                            <i class="fas fa-key"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Tempahan Dewan & Fasiliti</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= totalTempahan != null ? totalTempahan : 0 %> <span class="text-xs font-normal text-slate-400">aktif</span></span>
                        </div>
                    </div>
                </div>

                <!-- Snapshot History Chart -->
                <div class="glass-card p-6 md:p-8 rounded-3xl">
                    <h2 class="text-lg font-bold text-slate-800 mb-2 flex items-center gap-2">
                        <i class="fas fa-chart-line text-indigo-500"></i> Trend Sejarah Bulanan (Simulasi Snapshot)
                    </h2>
                    <p class="text-xs text-slate-500 mb-6">Pecahan dinamik penduduk, kelulusan permohonan bantuan, aduan aktif, dan penggunaan fasiliti bagi tempoh 4 bulan terakhir.</p>
                    <div class="w-full h-80">
                        <canvas id="chartSnapshot"></canvas>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 2: DEMOGRAFI ==================== -->
        <% if (isKetua || isSetiausaha) { %>
            <div id="panel-demografi" class="tab-panel space-y-8 <%= isKetua ? "hidden" : "" %>">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <!-- Stat Card: Purata Pendapatan -->
                    <div class="glass-card p-6 rounded-3xl flex flex-col justify-between h-48 lg:col-span-1 bg-gradient-purple text-white border-0">
                        <div class="flex items-center justify-between">
                            <div class="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-lg">
                                <i class="fas fa-wallet"></i>
                            </div>
                            <span class="text-[10px] font-bold uppercase tracking-wider bg-white/20 px-2.5 py-1 rounded-full">Sektor Ekonomi</span>
                        </div>
                        <div>
                            <span class="text-xs text-white/70 font-semibold uppercase tracking-wider block">Purata Pendapatan Komuniti</span>
                            <span class="text-3xl font-extrabold tracking-tight mt-1 block">RM <%= String.format("%,.2f", averageIncome) %></span>
                        </div>
                    </div>

                    <!-- Stat Card: OKU / Ibu Tunggal -->
                    <div class="glass-card p-6 rounded-3xl flex flex-col justify-between h-48 lg:col-span-1">
                        <div class="flex items-center justify-between">
                            <div class="w-10 h-10 rounded-xl bg-rose-50 border border-rose-100 text-rose-600 flex items-center justify-center text-lg">
                                <i class="fas fa-hands-holding"></i>
                            </div>
                            <span class="text-[10px] font-bold uppercase tracking-wider bg-rose-50 text-rose-600 px-2.5 py-1 rounded-full border border-rose-100">Khas</span>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Golongan Sasaran Sokongan</span>
                            <div class="flex items-center gap-6 mt-2">
                                <div>
                                    <span class="text-2xl font-extrabold text-slate-800 block"><%= familyDist != null ? familyDist.getOrDefault("Ibu Tunggal", 0) : 0 %></span>
                                    <span class="text-[10px] text-slate-400 font-bold block uppercase">Ibu Tunggal</span>
                                </div>
                                <div class="w-px h-8 bg-slate-100"></div>
                                <div>
                                    <span class="text-2xl font-extrabold text-slate-800 block"><%= familyDist != null ? familyDist.getOrDefault("OKU", 0) : 0 %></span>
                                    <span class="text-[10px] text-slate-400 font-bold block uppercase">Orang OKU</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Stat Card: Kumpulan Umur -->
                    <div class="glass-card p-6 rounded-3xl flex flex-col justify-between h-48 lg:col-span-1">
                        <div class="flex items-center justify-between">
                            <div class="w-10 h-10 rounded-xl bg-amber-50 border border-amber-100 text-amber-600 flex items-center justify-center text-lg">
                                <i class="fas fa-baby-carriage"></i>
                            </div>
                            <span class="text-[10px] font-bold uppercase tracking-wider bg-amber-50 text-amber-600 px-2.5 py-1 rounded-full border border-amber-100">Generasi</span>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Pecahan Warga Emas (60+)</span>
                            <span class="text-2xl font-extrabold text-slate-800 mt-1 block">
                                <%= ageDist != null ? ageDist.getOrDefault("60+", 0) : 0 %> <span class="text-xs font-normal text-slate-400">orang terdaftar</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="glass-card p-6 rounded-3xl">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-bar text-indigo-500"></i> Agihan Kumpulan Umur Penduduk
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartAge"></canvas>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-pie text-indigo-500"></i> Pecahan Kategori Pendapatan Isi Rumah
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartIncome"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 3: KEBAJIKAN & BANTUAN ==================== -->
        <% if (isKetua || isKebajikan) { %>
            <div id="panel-kebajikan" class="tab-panel space-y-8 <%= isKetua ? "hidden" : "" %>">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xl">
                            <i class="fas fa-hand-holding-heart"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Jumlah Bantuan Diterima</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= totalBantuan != null ? totalBantuan : 0 %> <span class="text-xs font-normal text-slate-400">permohonan</span></span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center text-xl">
                            <i class="fas fa-circle-check"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Bantuan Diluluskan</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= banStats != null ? banStats.getOrDefault("LULUS", 0) : 0 %> <span class="text-xs font-normal text-slate-400">permohonan</span></span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-amber-50 border border-amber-100 text-amber-600 flex items-center justify-center text-xl">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Bantuan Menunggu Semakan</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block">
                                <%= banStats != null ? (banStats.getOrDefault("BARU", 0) + banStats.getOrDefault("MENUNGGU_KETUA", 0)) : 0 %> <span class="text-xs font-normal text-slate-400">permohonan</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="glass-card p-6 rounded-3xl lg:col-span-2">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-line text-indigo-500"></i> Pecahan Skor Kelayakan Pemohon Bantuan (0-100)
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartBantuanScore"></canvas>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl lg:col-span-1">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-pie text-indigo-500"></i> Nisbah Jenis Bantuan Dipohon
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartBantuanRatio"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 4: ADUAN KOMUNITI ==================== -->
        <% if (isKetua || isKeselamatan) { %>
            <div id="panel-aduan" class="tab-panel space-y-8 <%= isKetua ? "hidden" : "" %>">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xl">
                            <i class="fas fa-comment-dots"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Jumlah Aduan Terdaftar</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= totalA %> <span class="text-xs font-normal text-slate-400">kes keseluruhan</span></span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-rose-50 border border-rose-100 text-rose-600 flex items-center justify-center text-xl">
                            <i class="fas fa-triangle-exclamation"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Aduan Kritikal & Tinggi</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block">
                                <%= aduPrio != null ? (aduPrio.getOrDefault("KRITIKAL", 0) + aduPrio.getOrDefault("TINGGI", 0)) : 0 %> <span class="text-xs font-normal text-slate-400">kes</span>
                            </span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center text-xl">
                            <i class="fas fa-badge-check"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Aduan Berjaya Diselesaikan</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= selesaiA %> <span class="text-xs font-normal text-slate-400">kes selesai</span></span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="glass-card p-6 rounded-3xl lg:col-span-1">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-pie text-indigo-500"></i> Pecahan Kategori Isu Utama
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartAduanCategory"></canvas>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl lg:col-span-2">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-bar text-indigo-500"></i> Agihan Tahap Keutamaan Aduan
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartAduanPriority"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 5: FASILITI ==================== -->
        <% if (isKetua || isSukan) { %>
            <div id="panel-fasiliti" class="tab-panel space-y-8 <%= isKetua ? "hidden" : "" %>">
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xl">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Jumlah Tempahan Aktif</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= totalTempahan != null ? totalTempahan : 0 %> <span class="text-xs font-normal text-slate-400">tempahan</span></span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center text-xl">
                            <i class="fas fa-check-double"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Tempahan Lulus</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block"><%= fasStatus != null ? fasStatus.getOrDefault("LULUS", 0) : 0 %> <span class="text-xs font-normal text-slate-400">tempahan</span></span>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                        <div class="w-12 h-12 rounded-2xl bg-amber-50 border border-amber-100 text-amber-600 flex items-center justify-center text-xl">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                        <div>
                            <span class="text-xs text-slate-500 font-bold uppercase tracking-wider block">Menunggu Kelulusan Manual</span>
                            <span class="text-2xl font-extrabold text-slate-800 tracking-tight block">
                                <%= fasStatus != null ? fasStatus.getOrDefault("MENUNGGU_KELULUSAN", 0) : 0 %> <span class="text-xs font-normal text-slate-400">tempahan</span>
                            </span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div class="glass-card p-6 rounded-3xl">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-bar text-indigo-500"></i> Kadar Penggunaan Dewan & Padang (Disahkan)
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartFasilitiUsage"></canvas>
                        </div>
                    </div>

                    <div class="glass-card p-6 rounded-3xl">
                        <h3 class="text-sm font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i class="fas fa-chart-pie text-indigo-500"></i> Status Kelulusan Tempahan Komuniti
                        </h3>
                        <div class="w-full h-64">
                            <canvas id="chartFasilitiStatus"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- ==================== TAB CONTENT 6: AI NARRATIVE GENERATOR ==================== -->
        <% if (isKetua) { %>
            <div id="panel-ai" class="tab-panel space-y-8 hidden">
                <div class="glass-card p-6 md:p-8 rounded-3xl">
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 border-b border-slate-100 pb-6 mb-6">
                        <div>
                            <h2 class="text-lg font-bold text-slate-800 flex items-center gap-2">
                                <i class="fas fa-robot text-purple-600"></i> Ulasan Naratif Bulanan berkuasa AI Gemini
                            </h2>
                            <p class="text-xs text-slate-500 mt-1">Gunakan kecerdasan buatan Gemini untuk mengulas trend demografi, kebajikan, aduan komuniti, dan aktiviti fasiliti secara menyeluruh dan professional.</p>
                        </div>
                        <div class="flex flex-wrap items-center gap-3">
                            <select id="aiReportType" class="px-4 py-2.5 rounded-2xl bg-slate-50 border border-slate-200 text-xs font-bold text-slate-700 focus:outline-none focus:border-indigo-300">
                                <option value="eksekutif">Ringkasan Eksekutif Kampung (Naratif)</option>
                                <option value="eksekutif_json">Laporan Eksekutif Berstruktur (JSON)</option>
                                <option value="kebajikan">Analisis Kebajikan & Bantuan</option>
                                <option value="aduan">Analisis Isu & Aduan Komuniti</option>
                                <option value="fasiliti">Analisis Penggunaan Fasiliti</option>
                            </select>
                            <button onclick="generateAIReport()" id="btnGenerateAI" class="inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl bg-purple-600 hover:bg-purple-700 text-white shadow-md shadow-purple-100 transition-all text-xs font-bold">
                                <i class="fas fa-sparkles"></i> Jana Laporan AI
                            </button>
                        </div>
                    </div>

                    <!-- AI Output Placeholder -->
                    <div id="aiOutputContainer" class="p-6 md:p-8 rounded-3xl bg-slate-50/50 border border-slate-100 min-h-[300px] flex items-center justify-center text-center relative overflow-hidden transition-all duration-300">
                        <div id="aiPlaceholder" class="max-w-md space-y-3">
                            <div class="w-16 h-16 rounded-3xl bg-purple-50 text-purple-600 flex items-center justify-center text-2xl mx-auto border border-purple-100">
                                <i class="fas fa-robot"></i>
                            </div>
                            <h4 class="text-sm font-bold text-slate-800">Menunggu Permintaan Penjanaan</h4>
                            <p class="text-xs text-slate-400">Sila pilih jenis laporan berfokus di atas dan klik butang "Jana Laporan AI" untuk memulakan analisa pintar Gemini.</p>
                        </div>
                        
                        <div id="aiSpinner" class="hidden">
                            <div class="w-12 h-12 border-4 border-purple-200 border-t-purple-600 rounded-full animate-spin mx-auto mb-4"></div>
                            <p class="text-xs text-slate-500 font-semibold animate-pulse">Menghubungi AI Gemini & menganalisis data kampung anda...</p>
                        </div>

                        <div id="aiResult" class="hidden text-left w-full h-full space-y-4 max-w-none prose prose-indigo text-slate-700 text-sm leading-relaxed overflow-y-auto custom-scrollbar">
                            <!-- Populated dynamically via JS -->
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

    </div>
</div>

<aside class="w-80 bg-white border-l border-slate-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full print:hidden shrink-0">
    <div class="mb-8">
        <h3 class="text-lg font-black text-slate-800 tracking-tight">Navigasi Laporan</h3>
        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mt-1">Menu Analitik Kampung</p>
    </div>

    <% if (isKetua) { %>
        <div class="space-y-3 mb-8">
            <button onclick="switchTab('ringkasan')" id="aside-tab-ringkasan" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left bg-indigo-600 text-white shadow-sm">
                <i class="fas fa-chart-pie text-base"></i>
                <span>KPI & Trend Bulanan</span>
            </button>
            <button onclick="switchTab('demografi')" id="aside-tab-demografi" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-slate-600 hover:bg-slate-50 hover:text-slate-900">
                <i class="fas fa-users text-base"></i>
                <span>Demografi Penduduk</span>
            </button>
            <button onclick="switchTab('kebajikan')" id="aside-tab-kebajikan" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-slate-600 hover:bg-slate-50 hover:text-slate-900">
                <i class="fas fa-hand-holding-heart text-base"></i>
                <span>Kebajikan & Bantuan</span>
            </button>
            <button onclick="switchTab('aduan')" id="aside-tab-aduan" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-slate-600 hover:bg-slate-50 hover:text-slate-900">
                <i class="fas fa-exclamation-circle text-base"></i>
                <span>Aduan Komuniti</span>
            </button>
            <button onclick="switchTab('fasiliti')" id="aside-tab-fasiliti" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-slate-600 hover:bg-slate-50 hover:text-slate-900">
                <i class="fas fa-calendar-alt text-base"></i>
                <span>Fasiliti Kampung</span>
            </button>
            <button onclick="switchTab('ai')" id="aside-tab-ai" class="aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-purple-600 bg-purple-50 hover:bg-purple-100 border border-purple-100/50">
                <i class="fas fa-robot text-base text-purple-500"></i>
                <span>Ulasan AI Gemini</span>
            </button>
        </div>
    <% } else { %>
        <div class="space-y-4 mb-8">
            <div class="bg-indigo-50/50 p-5 rounded-[2rem] border border-indigo-100/50 flex items-center gap-4">
                <div class="w-12 h-12 bg-indigo-100 text-indigo-600 rounded-2xl flex items-center justify-center shadow-sm">
                    <i class="fas fa-briefcase text-lg"></i>
                </div>
                <div>
                    <p class="text-[10px] text-gray-400 font-black uppercase tracking-widest">Skop Portfolio</p>
                    <h4 class="font-black text-xs text-gray-900 mt-0.5"><%= biro %></h4>
                </div>
            </div>
            
            <div class="w-full flex items-center gap-3 px-4 py-3.5 bg-indigo-600 text-white rounded-2xl text-xs font-bold transition-all text-left shadow-sm">
                <% if (isSetiausaha) { %>
                    <i class="fas fa-users text-base"></i>
                    <span>Demografi Penduduk</span>
                <% } else if (isKebajikan) { %>
                    <i class="fas fa-hand-holding-heart text-base"></i>
                    <span>Kebajikan & Bantuan</span>
                <% } else if (isSukan) { %>
                    <i class="fas fa-calendar-alt text-base"></i>
                    <span>Fasiliti Kampung</span>
                <% } else if (isKeselamatan) { %>
                    <i class="fas fa-exclamation-circle text-base"></i>
                    <span>Aduan Komuniti</span>
                  <% } else { %>
                      <i class="fas fa-chart-line text-base"></i>
                      <span>Laporan Biro</span>
                  <% } %>
            </div>
        </div>
    <% } %>

    <div class="mt-auto pt-8 border-t border-slate-100">
        <h4 class="text-[11px] font-black text-slate-400 uppercase tracking-widest mb-4">Nota Analitik</h4>
        <div class="bg-slate-50 rounded-3xl p-6 border border-slate-100 relative overflow-hidden group">
            <i class="fas fa-chart-line absolute -right-2 -bottom-2 text-slate-200 text-6xl opacity-20 group-hover:scale-110 transition-transform"></i>
            <p class="text-xs text-slate-500 leading-relaxed relative z-10 font-medium">
                Data laporan dikemaskini secara automatik berdasarkan pangkalan data MyKampung. Gunakan modul AI Gemini untuk menjana naratif ringkasan eksekutif bagi laporan bulanan.
            </p>
        </div>
    </div>
</aside>

<script>
    // System Configurations
    const activeTabKey = '<%= defaultTab %>';
    let activeTab = activeTabKey;
    const isKetuaKampung = <%= isKetua %>;

    // Date display
    const currentDateEl = document.getElementById('currentDate');
    if (currentDateEl) {
        currentDateEl.innerText = new Date().toLocaleDateString('ms-MY', {
            day: 'numeric',
            month: 'long',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // Tab Switching Logic (Only for Ketua Kampung)
    function switchTab(tabId) {
        if (!isKetuaKampung) return;
        activeTab = tabId;

        // 1. Manage mobile tab buttons
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.className = 'tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all text-slate-600 hover:bg-slate-100 hover:text-slate-900 flex items-center gap-2';
        });

        const activeBtn = document.getElementById('tab-' + tabId);
        if (activeBtn) {
            if (tabId === 'ai') {
                activeBtn.className = 'tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all bg-purple-600 text-white shadow-md flex items-center gap-2';
            } else {
                activeBtn.className = 'tab-btn px-4 py-2.5 rounded-xl text-xs font-bold transition-all bg-indigo-600 text-white shadow-sm flex items-center gap-2';
            }
        }

        // 2. Manage desktop aside tab buttons
        document.querySelectorAll('.aside-tab-btn').forEach(btn => {
            const btnId = btn.id || '';
            const tId = btnId.replace('aside-tab-', '');
            if (tId === 'ai') {
                btn.className = 'aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-purple-600 bg-purple-50 hover:bg-purple-100 border border-purple-100/50';
            } else {
                btn.className = 'aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left text-slate-600 hover:bg-slate-50 hover:text-slate-900';
            }
        });

        const activeAsideBtn = document.getElementById('aside-tab-' + tabId);
        if (activeAsideBtn) {
            if (tabId === 'ai') {
                activeAsideBtn.className = 'aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left bg-purple-600 text-white shadow-md';
            } else {
                activeAsideBtn.className = 'aside-tab-btn w-full flex items-center gap-3 px-4 py-3.5 rounded-2xl text-xs font-bold transition-all text-left bg-indigo-600 text-white shadow-md';
            }
        }

        // 3. Manage tab panels
        document.querySelectorAll('.tab-panel').forEach(panel => {
            panel.classList.add('hidden');
        });
        const activePanel = document.getElementById('panel-' + tabId);
        if (activePanel) {
            activePanel.classList.remove('hidden');
        }
    }

    // AI Narrative Generation Request (AJAX)
    function generateAIReport() {
        if (!isKetuaKampung) return;

        const reportType = document.getElementById('aiReportType').value;
        const btn = document.getElementById('btnGenerateAI');
        const container = document.getElementById('aiOutputContainer');
        const placeholder = document.getElementById('aiPlaceholder');
        const spinner = document.getElementById('aiSpinner');
        const result = document.getElementById('aiResult');

        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Menjana...';

        placeholder.classList.add('hidden');
        spinner.classList.remove('hidden');
        result.classList.add('hidden');
        container.className = 'p-6 md:p-8 rounded-3xl bg-slate-50 border border-slate-200 min-h-[300px] flex items-center justify-center';

        // Reset placeholder states to default before starting a new request
        const iconBox = document.querySelector('#aiPlaceholder div');
        const titleEl = document.querySelector('#aiPlaceholder h4');
        const textEl = document.querySelector('#aiPlaceholder p');
        if (iconBox) {
            iconBox.className = 'w-16 h-16 rounded-3xl bg-purple-50 text-purple-600 flex items-center justify-center text-2xl mx-auto border border-purple-100';
            iconBox.innerHTML = '<i class="fas fa-robot"></i>';
        }
        if (titleEl) {
            titleEl.className = 'text-sm font-bold text-slate-800';
            titleEl.innerText = 'Menunggu Permintaan Penjanaan';
        }
        if (textEl) {
            textEl.className = 'text-xs text-slate-400';
            textEl.innerText = 'Sila pilih jenis laporan berfokus di atas dan klik butang "Jana Laporan AI" untuk memulakan analisa pintar Gemini.';
        }

        const params = new URLSearchParams();
        params.append('reportType', reportType);
        params.append('_csrf', '${sessionScope.csrf_token}');

        fetch('<%= request.getContextPath() %>/laporan/ai/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(async response => {
            const contentType = response.headers.get('content-type') || '';
            const isJson = contentType.includes('application/json');
            const data = isJson ? await response.json() : null;

            if (!response.ok) {
                const errMsg = (data && data.reply) ? data.reply : 'Ralat Pelayan (HTTP ' + response.status + ')';
                throw new Error(errMsg);
            }
            if (!data) {
                throw new Error('Format maklum balas pelayan tidak sah (Bukan JSON).');
            }
            return data;
        })
        .then(data => {
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-sparkles"></i> Jana Laporan AI';
            spinner.classList.add('hidden');

            if (data.error) {
                placeholder.classList.remove('hidden');
                
                const is503 = data.reply && (data.reply.includes('503') || data.reply.toLowerCase().includes('unavailable') || data.reply.toLowerCase().includes('demand'));
                const is429 = data.reply && (data.reply.includes('429') || data.reply.toLowerCase().includes('quota') || data.reply.toLowerCase().includes('exhausted') || data.reply.toLowerCase().includes('limit'));
                
                const iconBox = document.querySelector('#aiPlaceholder div');
                const titleEl = document.querySelector('#aiPlaceholder h4');
                const textEl = document.querySelector('#aiPlaceholder p');
                
                if (is503) {
                    container.className = 'p-6 md:p-8 rounded-3xl bg-amber-50 border border-amber-200 min-h-[300px] flex items-center justify-center text-center';
                    if (iconBox) {
                        iconBox.className = 'w-16 h-16 rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center text-2xl mx-auto border border-amber-200';
                        iconBox.innerHTML = '<i class="fas fa-hourglass-half animate-pulse"></i>';
                    }
                    if (titleEl) {
                        titleEl.className = 'text-sm font-bold text-amber-800';
                        titleEl.innerText = 'KampungBot Sedang Sibuk (HTTP 503)';
                    }
                    if (textEl) {
                        textEl.className = 'text-xs text-amber-600 font-medium leading-relaxed max-w-sm mx-auto';
                        textEl.innerHTML = 'Model AI Gemini sedang mengalami kesesakan lalu lintas atau permintaan yang sangat tinggi di pelayan Google buat sementara waktu.<br><br>Sila tunggu <strong>1-2 minit</strong> dan klik butang <strong>Jana Laporan AI</strong> semula.';
                    }
                } else if (is429) {
                    container.className = 'p-6 md:p-8 rounded-3xl bg-amber-50 border border-amber-200 min-h-[300px] flex items-center justify-center text-center';
                    if (iconBox) {
                        iconBox.className = 'w-16 h-16 rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center text-2xl mx-auto border border-amber-200';
                        iconBox.innerHTML = '<i class="fas fa-clock animate-pulse"></i>';
                    }
                    if (titleEl) {
                        titleEl.className = 'text-sm font-bold text-amber-800';
                        titleEl.innerText = 'Had Kuota AI Melebihi Had (HTTP 429)';
                    }
                    if (textEl) {
                        textEl.className = 'text-xs text-amber-600 font-medium leading-relaxed max-w-sm mx-auto';
                        textEl.innerHTML = 'Had kuota harian/minit KampungBot telah dicapai (had panggilan harian/minit bagi model percuma Gemini telah melebihi had).<br><br>Sila **tunggu seketika** (rujuk ralat sistem untuk tempoh sekatan) sebelum cuba menjana semula.';
                    }
                } else {
                    container.className = 'p-6 md:p-8 rounded-3xl bg-red-50 border border-red-200 min-h-[300px] flex items-center justify-center text-center';
                    if (iconBox) {
                        iconBox.className = 'w-16 h-16 rounded-3xl bg-red-100 text-red-600 flex items-center justify-center text-2xl mx-auto border border-red-200';
                        iconBox.innerHTML = '<i class="fas fa-exclamation-triangle animate-bounce"></i>';
                    }
                    if (titleEl) {
                        titleEl.className = 'text-sm font-bold text-red-800';
                        titleEl.innerText = 'Ralat Dikesan';
                    }
                    if (textEl) {
                        textEl.className = 'text-xs text-red-600 font-medium leading-relaxed max-w-sm mx-auto';
                        textEl.innerText = data.reply;
                    }
                }
            } else {
                container.className = 'p-6 md:p-8 rounded-3xl bg-white border border-slate-100 min-h-[300px] block';
                result.classList.remove('hidden');
                
                if (data.structured_report) {
                    let report = data.structured_report;
                    let alertsHtml = '';
                    if (report.critical_alerts && report.critical_alerts.length > 0) {
                        alertsHtml = `
                            <div class="space-y-3">
                                \${report.critical_alerts.map(alert => `
                                    <div class="flex items-start gap-3 p-4 bg-rose-50 border border-rose-100 rounded-2xl">
                                        <div class="w-6 h-6 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center text-xs shrink-0 animate-pulse">
                                            <i class="fas fa-exclamation-triangle"></i>
                                        </div>
                                        <span class="text-xs text-rose-700 font-semibold">\${alert}</span>
                                    </div>
                                `).join('')}
                            </div>
                        `;
                    } else {
                        alertsHtml = `
                            <div class="p-4 bg-emerald-50 border border-emerald-100 rounded-2xl flex items-center gap-3">
                                <div class="w-6 h-6 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-xs shrink-0">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <span class="text-xs text-emerald-700 font-semibold">Tiada isu kritikal dikesan buat masa ini.</span>
                            </div>
                        `;
                    }

                    let actionsHtml = '';
                    if (report.recommended_actions && report.recommended_actions.length > 0) {
                        actionsHtml = `
                            <ol class="space-y-3">
                                \${report.recommended_actions.map((action, i) => `
                                    <li class="flex items-start gap-3 p-4 bg-slate-50 border border-slate-100 rounded-2xl">
                                        <div class="w-6 h-6 rounded-full bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center text-xs font-bold shrink-0">
                                            \${i + 1}
                                        </div>
                                        <span class="text-xs text-slate-700 font-medium">\${action}</span>
                                    </li>
                                `).join('')}
                            </ol>
                        `;
                    }

                    result.innerHTML = `
                        <div class="space-y-8">
                            <div class="flex items-center justify-between border-b border-slate-100 pb-4">
                                <div class="flex items-center gap-2">
                                    <span class="w-2 h-2 rounded-full bg-emerald-500 animate-ping"></span>
                                    <h3 class="text-xs font-extrabold text-slate-800 uppercase tracking-wider">Laporan Eksekutif AI Berstruktur</h3>
                                </div>
                                <button onclick="copyStructuredReportJSON()" class="px-3 py-1.5 rounded-xl border border-slate-200 text-slate-600 hover:bg-slate-50 text-[10px] font-bold flex items-center gap-1.5 transition-all">
                                    <i class="fas fa-copy"></i> Salin JSON
                                </button>
                            </div>

                            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                                <!-- Executive Summary -->
                                <div class="lg:col-span-2 p-6 rounded-3xl bg-gradient-to-r from-purple-50 to-indigo-50 border border-indigo-100/50">
                                    <h4 class="text-[10px] font-black text-indigo-900 uppercase tracking-widest mb-3 flex items-center gap-2">
                                        <i class="fas fa-file-invoice text-indigo-500"></i> Ringkasan Eksekutif
                                    </h4>
                                    <p class="text-xs text-indigo-950 font-medium leading-relaxed">\${report.executive_summary}</p>
                                </div>

                                <!-- Economic and Welfare Status -->
                                <div class="p-6 rounded-3xl border border-slate-100 bg-white shadow-sm">
                                    <h4 class="text-[10px] font-black text-slate-800 uppercase tracking-widest mb-4 flex items-center gap-2">
                                        <i class="fas fa-wallet text-amber-500"></i> Analisis Ekonomi & Kebajikan
                                    </h4>
                                    <p class="text-xs text-slate-600 leading-relaxed font-medium">\${report.economic_and_welfare_status}</p>
                                </div>

                                <!-- Critical Alerts -->
                                <div class="p-6 rounded-3xl border border-slate-100 bg-white shadow-sm">
                                    <h4 class="text-[10px] font-black text-slate-800 uppercase tracking-widest mb-4 flex items-center gap-2">
                                        <i class="fas fa-bell text-rose-500"></i> Amaran & Bottlenecks Kritikal
                                    </h4>
                                    \${alertsHtml}
                                </div>

                                <!-- Recommended Actions -->
                                <div class="lg:col-span-2 p-6 rounded-3xl border border-slate-100 bg-white shadow-sm">
                                    <h4 class="text-[10px] font-black text-slate-800 uppercase tracking-widest mb-4 flex items-center gap-2">
                                        <i class="fas fa-list-check text-emerald-500"></i> Syor & Pelan Tindakan Ketua Kampung
                                    </h4>
                                    \${actionsHtml}
                                </div>
                            </div>
                        </div>
                    `;
                    window.latestStructuredReportJSON = JSON.stringify(report, null, 2);
                } else {
                    result.innerHTML = formatMarkdown(data.reply);
                }
            }
        })
        .catch(err => {
            console.error(err);
            btn.disabled = false;
            btn.innerHTML = '<i class="fas fa-sparkles"></i> Jana Laporan AI';
            spinner.classList.add('hidden');
            placeholder.classList.remove('hidden');
            
            const errMsg = err.message || '';
            const is503 = errMsg.includes('503') || errMsg.toLowerCase().includes('unavailable') || errMsg.toLowerCase().includes('demand');
            const is429 = errMsg.includes('429') || errMsg.toLowerCase().includes('quota') || errMsg.toLowerCase().includes('exhausted') || errMsg.toLowerCase().includes('limit');
            
            const iconBox = document.querySelector('#aiPlaceholder div');
            const titleEl = document.querySelector('#aiPlaceholder h4');
            const textEl = document.querySelector('#aiPlaceholder p');
            
            if (is503) {
                container.className = 'p-6 md:p-8 rounded-3xl bg-amber-50 border border-amber-200 min-h-[300px] flex items-center justify-center text-center';
                if (iconBox) {
                    iconBox.className = 'w-16 h-16 rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center text-2xl mx-auto border border-amber-200';
                    iconBox.innerHTML = '<i class="fas fa-hourglass-half animate-pulse"></i>';
                }
                if (titleEl) {
                    titleEl.className = 'text-sm font-bold text-amber-800';
                    titleEl.innerText = 'KampungBot Sedang Sibuk (HTTP 503)';
                }
                if (textEl) {
                    textEl.className = 'text-xs text-amber-600 font-medium leading-relaxed max-w-sm mx-auto';
                    textEl.innerHTML = 'Model AI Gemini sedang mengalami kesesakan lalu lintas atau permintaan yang sangat tinggi di pelayan Google buat sementara waktu.<br><br>Sila tunggu <strong>1-2 minit</strong> dan klik butang <strong>Jana Laporan AI</strong> semula.';
                }
            } else if (is429) {
                container.className = 'p-6 md:p-8 rounded-3xl bg-amber-50 border border-amber-200 min-h-[300px] flex items-center justify-center text-center';
                if (iconBox) {
                    iconBox.className = 'w-16 h-16 rounded-3xl bg-amber-100 text-amber-600 flex items-center justify-center text-2xl mx-auto border border-amber-200';
                    iconBox.innerHTML = '<i class="fas fa-clock animate-pulse"></i>';
                }
                if (titleEl) {
                    titleEl.className = 'text-sm font-bold text-amber-800';
                    titleEl.innerText = 'Had Kuota AI Melebihi Had (HTTP 429)';
                }
                if (textEl) {
                    textEl.className = 'text-xs text-amber-600 font-medium leading-relaxed max-w-sm mx-auto';
                    textEl.innerHTML = 'Had kuota harian/minit KampungBot telah dicapai (had panggilan harian/minit bagi model percuma Gemini telah melebihi had).<br><br>Sila **tunggu seketika** (rujuk ralat sistem untuk tempoh sekatan) sebelum cuba menjana semula.';
                }
            } else {
                container.className = 'p-6 md:p-8 rounded-3xl bg-red-50 border border-red-200 min-h-[300px] flex items-center justify-center text-center';
                if (iconBox) {
                    iconBox.className = 'w-16 h-16 rounded-3xl bg-red-100 text-red-600 flex items-center justify-center text-2xl mx-auto border border-red-200';
                    iconBox.innerHTML = '<i class="fas fa-exclamation-triangle animate-bounce"></i>';
                }
                if (titleEl) {
                    titleEl.className = 'text-sm font-bold text-red-800';
                    titleEl.innerText = 'Ralat Sambungan';
                }
                if (textEl) {
                    textEl.className = 'text-xs text-red-600 font-medium leading-relaxed max-w-sm mx-auto';
                    textEl.innerText = errMsg || 'Sambungan ke pelayan terputus. Sila cuba lagi.';
                }
            }
        });
    }

    // Salin JSON Laporan
    function copyStructuredReportJSON() {
        if (!window.latestStructuredReportJSON) return;
        navigator.clipboard.writeText(window.latestStructuredReportJSON)
            .then(() => {
                alert('JSON laporan eksekutif berjaya disalin ke papan klip.');
            })
            .catch(err => {
                console.error('Gagal menyalin JSON:', err);
                alert('Gagal menyalin JSON secara automatik.');
            });
    }

    // Save Monthly Snapshot (AJAX)
    function saveCurrentSnapshot() {
        if (!isKetuaKampung) return;

        if (!confirm('Adakah anda pasti mahu menyimpan snapshot bulanan bagi statistik semasa? Tindakan ini akan mengemas kini trend pangkalan data.')) {
            return;
        }

        const params = new URLSearchParams();
        params.append('_csrf', '${sessionScope.csrf_token}');

        fetch('<%= request.getContextPath() %>/laporan/snapshot/save', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                location.reload();
            }
        })
        .catch(err => {
            console.error(err);
            alert('Gagal menyambung ke pelayan untuk menyimpan snapshot.');
        });
    }

    // Helper function to restore panels to original states
    function restorePanels(panels, originalDisplays) {
        if (isKetuaKampung && originalDisplays.length > 0) {
            panels.forEach((panel, index) => {
                panel.style.display = originalDisplays[index];
                if (panel.id !== 'panel-' + activeTab) {
                    panel.classList.add('hidden');
                }
            });
        }
    }

    // Fallback to Native Print Dialog
    function fallbackToNativePrint(btn, originalText, panels, originalDisplays, errorMsg) {
        console.warn("PDF generation error, falling back to native print:", errorMsg);
        
        // Show a brief explanation to the user
        alert('Penjana PDF mengalami isu keserasian. Membuka dialog cetakan sistem sebagai alternatif.\n\nSila pilih "Simpan sebagai PDF" (Save as PDF) di bahagian Pilihan Pencetak untuk memuat turun.');

        // Restore screen view panels first so the UI doesn't look broken
        restorePanels(panels, originalDisplays);
        
        // Trigger system print
        window.print();
        
        // Restore button state
        btn.innerHTML = originalText;
        btn.disabled = false;
    }

    // Front-End PDF Client Exporter (html2pdf.js) with Native Print Fallback
    function exportToPDF() {
        const btn = document.getElementById('btnPdf');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Menjana PDF...';
        btn.disabled = true;

        const panels = document.querySelectorAll('.tab-panel');
        const originalDisplays = [];

        // For Ketua Kampung, temporarily make all panels visible to include them in the PDF
        if (isKetuaKampung) {
            panels.forEach(panel => {
                originalDisplays.push(panel.style.display);
                panel.style.display = 'block';
                panel.classList.remove('hidden');
            });
        }

        // Give the browser 350ms to reflow layouts, settle Chart.js sizes, and render hidden canvases
        setTimeout(() => {
            try {
                // If html2pdf library is not defined/loaded, fallback immediately
                if (typeof html2pdf === 'undefined') {
                    fallbackToNativePrint(btn, originalText, panels, originalDisplays, 'Library html2pdf.js is not loaded.');
                    return;
                }

                const element = document.getElementById('report-container');
                const opt = {
                    margin:       [0.4, 0.4, 0.4, 0.4],
                    filename:     'Laporan_MyKampung_Danan_' + new Date().toISOString().slice(0,10) + '.pdf',
                    image:        { type: 'jpeg', quality: 0.98 },
                    html2canvas:  { scale: 2, useCORS: true, logging: false },
                    jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
                };

                html2pdf().set(opt).from(element).save().then(() => {
                    restorePanels(panels, originalDisplays);
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }).catch(err => {
                    fallbackToNativePrint(btn, originalText, panels, originalDisplays, err);
                });
            } catch (err) {
                fallbackToNativePrint(btn, originalText, panels, originalDisplays, err);
            }
        }, 350);
    }

    // Markdown Parser Helper
    function formatMarkdown(text) {
        if (!text) return "";
        let html = text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;");

        // Headers
        html = html.replace(/^### (.*$)/gim, '<h4 class="text-sm font-bold text-slate-800 mt-4 mb-2">$1</h4>');
        html = html.replace(/^## (.*$)/gim, '<h3 class="text-base font-extrabold text-slate-800 mt-6 mb-3">$1</h3>');
        html = html.replace(/^# (.*$)/gim, '<h2 class="text-lg font-black text-slate-800 mt-8 mb-4 border-b pb-2">$1</h2>');

        // Bold text
        html = html.replace(/\*\*(.*?)\*\*/g, '<strong class="font-bold text-slate-900">$1</strong>');
        
        // Bullet list
        html = html.replace(/^\* (.*$)/gim, '<li class="ml-4 list-disc text-slate-600 mb-1">$1</li>');
        html = html.replace(/^- (.*$)/gim, '<li class="ml-4 list-disc text-slate-600 mb-1">$1</li>');

        // Paragraph line breaks
        html = html.split('\n').map(line => {
            if (line.trim().startsWith('<h') || line.trim().startsWith('<li') || line.trim().isEmpty) {
                return line;
            }
            return '<p class="mb-3 text-slate-600 leading-relaxed">' + line + '</p>';
        }).join('\n');

        return html;
    }

    // Initialize Chart.js Data Visualizations
    window.addEventListener('DOMContentLoaded', () => {
        
        // Chart: Age Distribution (Bar Chart)
        if (document.getElementById('chartAge')) {
            const ageLabels = [];
            const ageData = [];
            <% if (ageDist != null) {
                for (Map.Entry<String, Integer> entry : ageDist.entrySet()) { %>
                    ageLabels.push('<%= entry.getKey() %>');
                    ageData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartAge'), {
                type: 'bar',
                data: {
                    labels: ageLabels,
                    datasets: [{
                        label: 'Bilangan Penduduk',
                        data: ageData,
                        backgroundColor: 'rgba(124, 58, 237, 0.75)',
                        borderColor: '#7C3AED',
                        borderWidth: 1.5,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, ticks: { stepSize: 1 } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Chart: Income Distribution (Doughnut Chart)
        if (document.getElementById('chartIncome')) {
            const incomeLabels = [];
            const incomeData = [];
            <% if (incomeDist != null) {
                for (Map.Entry<String, Integer> entry : incomeDist.entrySet()) { %>
                    incomeLabels.push('<%= entry.getKey() %>');
                    incomeData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartIncome'), {
                type: 'doughnut',
                data: {
                    labels: incomeLabels,
                    datasets: [{
                        data: incomeData,
                        backgroundColor: [
                            '#EF4444', // Red (Miskin Tegar)
                            '#F59E0B', // Amber
                            '#3B82F6', // Blue
                            '#10B981', // Emerald
                            '#8B5CF6'  // Violet
                        ],
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 10 } } }
                    },
                    cutout: '60%'
                }
            });
        }

        // Chart: Bantuan Summary Score Distribution (Line Chart)
        if (document.getElementById('chartBantuanScore')) {
            const scoreLabels = [];
            const scoreData = [];
            <% if (banScore != null) {
                for (Map.Entry<String, Integer> entry : banScore.entrySet()) { %>
                    scoreLabels.push('<%= entry.getKey() %>');
                    scoreData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartBantuanScore'), {
                type: 'line',
                data: {
                    labels: scoreLabels,
                    datasets: [{
                        label: 'Frekuensi Permohon',
                        data: scoreData,
                        fill: true,
                        backgroundColor: 'rgba(79, 70, 229, 0.05)',
                        borderColor: '#4F46E5',
                        borderWidth: 2.5,
                        tension: 0.4,
                        pointRadius: 4,
                        pointBackgroundColor: '#4F46E5'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, ticks: { stepSize: 1 } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Chart: Bantuan Ratio (Pie Chart)
        if (document.getElementById('chartBantuanRatio')) {
            const ratioLabels = [];
            const ratioData = [];
            <% if (banRatio != null) {
                for (Map.Entry<String, Integer> entry : banRatio.entrySet()) { %>
                    ratioLabels.push('<%= entry.getKey() %>');
                    ratioData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartBantuanRatio'), {
                type: 'pie',
                data: {
                    labels: ratioLabels,
                    datasets: [{
                        data: ratioData,
                        backgroundColor: ['#6366F1', '#EC4899'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 10 } } }
                    }
                }
            });
        }

        // Chart: Aduan Category Distribution (Polar Area Chart)
        if (document.getElementById('chartAduanCategory')) {
            const catLabels = [];
            const catData = [];
            <% if (aduCat != null) {
                for (Map.Entry<String, Integer> entry : aduCat.entrySet()) { %>
                    catLabels.push('<%= entry.getKey() %>');
                    catData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartAduanCategory'), {
                type: 'polarArea',
                data: {
                    labels: catLabels,
                    datasets: [{
                        data: catData,
                        backgroundColor: [
                            'rgba(99, 102, 241, 0.7)',
                            'rgba(236, 72, 153, 0.7)',
                            'rgba(245, 158, 11, 0.7)',
                            'rgba(16, 185, 129, 0.7)',
                            'rgba(239, 68, 68, 0.7)'
                        ],
                        borderWidth: 1.5,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 9 } } }
                    }
                }
            });
        }

        // Chart: Aduan Priority Distribution (Bar Chart)
        if (document.getElementById('chartAduanPriority')) {
            const prioLabels = [];
            const prioData = [];
            <% if (aduPrio != null) {
                for (Map.Entry<String, Integer> entry : aduPrio.entrySet()) { %>
                    prioLabels.push('<%= entry.getKey() %>');
                    prioData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartAduanPriority'), {
                type: 'bar',
                data: {
                    labels: prioLabels,
                    datasets: [{
                        label: 'Jumlah Kes',
                        data: prioData,
                        backgroundColor: [
                            'rgba(16, 185, 129, 0.75)', // Green - Low
                            'rgba(59, 82, 246, 0.75)',  // Blue - Med
                            'rgba(245, 158, 11, 0.75)', // Amber - High
                            'rgba(239, 68, 68, 0.75)'   // Red - Crit
                        ],
                        borderColor: ['#10B981', '#3B82F6', '#F59E0B', '#EF4444'],
                        borderWidth: 1.5,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, ticks: { stepSize: 1 } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Chart: Fasiliti Usage Statistics (Bar Chart)
        if (document.getElementById('chartFasilitiUsage')) {
            const fasLabels = [];
            const fasData = [];
            <% if (fasUsage != null) {
                for (Map.Entry<String, Integer> entry : fasUsage.entrySet()) { %>
                    fasLabels.push('<%= entry.getKey() %>');
                    fasData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartFasilitiUsage'), {
                type: 'bar',
                data: {
                    labels: fasLabels,
                    datasets: [{
                        label: 'Bilangan Tempahan Selesai',
                        data: fasData,
                        backgroundColor: 'rgba(59, 130, 246, 0.75)',
                        borderColor: '#3B82F6',
                        borderWidth: 1.5,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, ticks: { stepSize: 1 } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Chart: Fasiliti Status Stats (Pie Chart)
        if (document.getElementById('chartFasilitiStatus')) {
            const statLabels = [];
            const statData = [];
            <% if (fasStatus != null) {
                for (Map.Entry<String, Integer> entry : fasStatus.entrySet()) { %>
                    statLabels.push('<%= entry.getKey() %>');
                    statData.push(<%= entry.getValue() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartFasilitiStatus'), {
                type: 'pie',
                data: {
                    labels: statLabels,
                    datasets: [{
                        data: statData,
                        backgroundColor: ['#10B981', '#F59E0B', '#EF4444', '#94A3B8'],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 10 } } }
                    }
                }
            });
        }

        // Chart: Sejarah Snapshot Bulanan (Multiple Line Chart - ONLY FOR Ketua Kampung)
        if (document.getElementById('chartSnapshot')) {
            const snapshotMonths = [];
            const snapshotPenduduk = [];
            const snapshotBantuan = [];
            const snapshotAduan = [];
            const snapshotFasiliti = [];

            <% if (snapshots != null) {
                String[] namaBulan = {"", "Jan", "Feb", "Mac", "Apr", "Mei", "Jun", "Jul", "Ogo", "Sep", "Okt", "Nov", "Dis"};
                for (LaporanSnapshot s : snapshots) { %>
                    snapshotMonths.push('<%= namaBulan[s.getBulan()] %> <%= s.getTahun() %>');
                    snapshotPenduduk.push(<%= s.getTotal_penduduk() %>);
                    snapshotBantuan.push(<%= s.getTotal_bantuan_dipohon() %>);
                    snapshotAduan.push(<%= s.getTotal_aduan_diterima() %>);
                    snapshotFasiliti.push(<%= s.getTotal_tempahan_fasiliti() %>);
            <%  }
            } %>

            new Chart(document.getElementById('chartSnapshot'), {
                type: 'line',
                data: {
                    labels: snapshotMonths,
                    datasets: [
                        {
                            label: 'Jumlah Penduduk',
                            data: snapshotPenduduk,
                            borderColor: '#8B5CF6',
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            tension: 0.3,
                            pointRadius: 3
                        },
                        {
                            label: 'Permohonan Bantuan',
                            data: snapshotBantuan,
                            borderColor: '#EC4899',
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            tension: 0.3,
                            pointRadius: 3
                        },
                        {
                            label: 'Aduan Masuk',
                            data: snapshotAduan,
                            borderColor: '#EF4444',
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            tension: 0.3,
                            pointRadius: 3
                        },
                        {
                            label: 'Tempahan Fasiliti',
                            data: snapshotFasiliti,
                            borderColor: '#3B82F6',
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            tension: 0.3,
                            pointRadius: 3
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom', labels: { boxWidth: 12, font: { size: 10 } } }
                    },
                    scales: {
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

    });
</script>

<%@ include file="/views/common/footer.jsp" %>
