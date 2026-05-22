<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.util.List" %>
<%
    // 1. Dapatkan objek user dari session
    Pengguna user = (Pengguna) session.getAttribute("currentUser");

    // 2. SEKURITI: Redirect jika session tamat atau tidak sah
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }

    // 3. Ambil data dinamik yang disuntik oleh DashboardServlet
    List<PermohonanBantuan> pendingBantuan = (List<PermohonanBantuan>) request.getAttribute("pendingBantuanList");
    List<Pengguna> ajkList = (List<Pengguna>) request.getAttribute("ajkList");

    Integer pendingBantuanCount = (Integer) request.getAttribute("pendingBantuanCount");
    if (pendingBantuanCount == null) pendingBantuanCount = 0;

    Integer totalBantuanCount = (Integer) request.getAttribute("totalBantuanCount");
    if (totalBantuanCount == null) totalBantuanCount = 0;

    Long approvedBantuanCount = (Long) request.getAttribute("approvedBantuanCount");
    if (approvedBantuanCount == null) approvedBantuanCount = 0L;
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<!-- Google Fonts Outfit & Custom Glassmorphism Styles -->
<link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<style>
    body {
        font-family: 'Outfit', sans-serif;
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.4);
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.04);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .glass-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.08);
    }
    .custom-scrollbar::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #E2E8F0;
        border-radius: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #CBD5E1;
    }
</style>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F8FAFC] custom-scrollbar">
    <div class="max-w-7xl mx-auto">

        <!-- Header Section -->
        <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
            <div>
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 border border-emerald-100 text-emerald-600 text-[10px] font-extrabold uppercase tracking-widest">
                    <i class="fas fa-hand-holding-heart"></i> Portal Kebajikan
                </span>
                <h1 class="text-3xl font-black text-slate-800 tracking-tight mt-2">Papan Pemuka Kebajikan & Sosial</h1>
                <p class="text-slate-500 text-sm mt-0.5">Penilaian awal dan sokongan permohonan bantuan kewangan atau bencana bagi penduduk kampung.</p>
            </div>
            
            <div class="relative w-full md:w-80 group">
                <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400 group-focus-within:text-emerald-600 transition-colors">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" 
                       class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border border-slate-200 focus:ring-4 focus:ring-emerald-100 focus:border-emerald-400 shadow-sm text-sm placeholder-gray-400 transition-all outline-none" 
                       placeholder="Cari permohonan bantuan...">
            </div>
        </header>

        <!-- Premium Hero Section -->
        <div class="relative bg-gradient-to-r from-[#064E3B] to-[#0D9488] rounded-[2.5rem] p-8 md:p-10 text-white mb-8 shadow-xl overflow-hidden group">
            <div class="relative z-10 max-w-xl">
                <span class="bg-white/20 text-[10px] font-extrabold px-3 py-1 rounded-full backdrop-blur-md text-emerald-300 uppercase tracking-widest border border-white/10">BIRO KEBAJIKAN & SOSIAL</span>
                <h1 class="text-3xl md:text-4xl font-black mt-4 mb-2 leading-tight">Selamat Datang, <%= user.getNama_penuh() %>!</h1>
                <p class="text-emerald-100 mb-6 text-sm leading-relaxed opacity-95">
                    Kebajikan penduduk adalah keutamaan kita. Pastikan setiap dokumen sokongan dinilai dengan integriti tinggi sebelum disalurkan kepada Ketua Kampung.
                </p>
                <div class="flex flex-wrap gap-3">
                    <a href="<%= request.getContextPath() %>/bantuan/list" class="bg-white text-emerald-900 px-6 py-3 rounded-xl font-bold text-xs hover:bg-slate-100 transition shadow-md flex items-center gap-2">
                        <i class="fas fa-list-ul"></i> Senarai Bantuan Dinilai
                    </a>
                </div>
            </div>
            <div class="absolute top-0 right-0 -mr-16 -mt-16 w-80 h-80 bg-white opacity-5 rounded-full blur-3xl group-hover:scale-110 transition-transform duration-700"></div>
            <div class="absolute bottom-0 right-20 w-48 h-48 bg-emerald-950 opacity-20 rounded-full blur-2xl"></div>
        </div>

        <!-- 3-Column Statistics Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-emerald-50 border border-emerald-100 text-emerald-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-archive"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Jumlah Rekod Bantuan</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= totalBantuanCount %> <span class="text-xs font-normal text-slate-400">kes</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-orange-50 border border-orange-100 text-orange-500 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-clock"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Semakan Biro Menunggu</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= pendingBantuanCount %> <span class="text-xs font-normal text-slate-400">kes</span></span>
                </div>
            </div>

            <div class="glass-card p-6 rounded-3xl flex items-center gap-4 relative overflow-hidden">
                <div class="w-12 h-12 rounded-2xl bg-teal-50 border border-teal-100 text-teal-600 flex items-center justify-center text-xl shadow-sm">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div>
                    <span class="text-[10px] text-slate-400 font-extrabold uppercase tracking-wider block">Bantuan Diluluskan</span>
                    <span class="text-2xl font-black text-slate-800 tracking-tight block mt-0.5"><%= approvedBantuanCount %> <span class="text-xs font-normal text-slate-400">kes</span></span>
                </div>
            </div>
        </div>

        <!-- Table: Pending Bantuan Applications -->
        <div class="glass-card rounded-[2.5rem] p-6 mb-8 overflow-hidden flex flex-col">
            <div class="flex justify-between items-center mb-6 pb-4 border-b border-slate-100/50">
                <div>
                    <h3 class="font-black text-lg text-slate-800">Permohonan Bantuan Baru Menunggu Penilaian</h3>
                    <p class="text-xs text-slate-400">Sila semak dokumen sokongan dan kemukakan ulasan kelayakan.</p>
                </div>
                <span class="px-2.5 py-1 rounded-full bg-orange-100 text-orange-600 text-[10px] font-extrabold uppercase"><%= pendingBantuanCount %> Baru</span>
            </div>

            <div class="overflow-x-auto custom-scrollbar">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="border-b border-slate-100 text-slate-400 text-[10px] font-extrabold uppercase tracking-wider">
                            <th class="pb-3 w-16">No.</th>
                            <th class="pb-3">Pemohon</th>
                            <th class="pb-3">Jenis Bantuan</th>
                            <th class="pb-3">Pendapatan Isu Rumah</th>
                            <th class="pb-3 text-center w-36">Tindakan</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100/50">
                        <% if (pendingBantuan != null && !pendingBantuan.isEmpty()) {
                            int count = 1;
                            for (PermohonanBantuan pb : pendingBantuan) { %>
                            <tr class="hover:bg-slate-50/50 transition-colors group">
                                <td class="py-4 text-xs font-bold text-slate-400"><%= count++ %></td>
                                <td class="py-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-9 h-9 rounded-xl bg-teal-50 border border-teal-100 text-teal-600 flex items-center justify-center text-xs font-black">
                                            <%= pb.getNama_penuh().substring(0,1).toUpperCase() %>
                                        </div>
                                        <div>
                                            <div class="text-sm font-bold text-slate-800"><%= pb.getNama_penuh() %></div>
                                            <div class="text-[10px] text-slate-400 font-bold mt-0.5"><i class="far fa-id-card"></i> <%= pb.getNombor_kp() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="py-4 text-xs font-bold text-slate-700">
                                    <%= pb.getNama_bantuan() %>
                                </td>
                                <td class="py-4 text-xs font-bold text-rose-600">
                                    <%= pb.getPendapatanFormatted() %>
                                </td>
                                <td class="py-4 text-center">
                                    <a href="<%= request.getContextPath() %>/bantuan/list" class="px-4 py-2 bg-slate-50 hover:bg-slate-800 hover:text-white text-slate-700 border border-slate-200 rounded-xl text-[10px] font-black uppercase tracking-wider transition-all">
                                        Semak
                                    </a>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="5" class="py-12 text-center text-slate-400 opacity-60">
                                    <i class="fas fa-heart-circle-check text-3xl mb-3 block"></i>
                                    <p class="text-xs font-bold italic">Tiada permohonan bantuan menunggu semakan biro.</p>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- Dynamic Aside Sidebar -->
<aside class="hidden xl:flex w-full xl:w-80 bg-white border-t xl:border-t-0 xl:border-l border-slate-100 flex-col p-8 flex-shrink-0 h-full overflow-y-auto custom-scrollbar shrink-0">
    
    <!-- Profile Card -->
    <div class="text-center mb-8 pb-8 border-b border-slate-100">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <% if (user.getFoto_profil() != null && !user.getFoto_profil().isEmpty() && !user.getFoto_profil().equals("default_avatar.png")) { %>
                <img src="<%= request.getContextPath() %>/file/profil/<%= user.getFoto_profil() %>" 
                     class="w-full h-full rounded-[2rem] object-cover border-4 border-white shadow-lg relative z-10">
            <% } else { %>
                <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=064E3B&color=fff&size=128" 
                     class="w-full h-full rounded-[2rem] object-cover border-4 border-white shadow-lg relative z-10">
            <% } %>
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-slate-800 tracking-tight"><%= user.getNama_penuh() %></h2>
        <p class="text-[10px] font-extrabold text-emerald-600 bg-emerald-50 border border-emerald-100 px-3.5 py-1 rounded-full inline-block mt-2 uppercase tracking-wider">
            <%= (user.getNama_jawatan() != null) ? user.getNama_jawatan() : "Biro Kebajikan" %>
        </p>
    </div>

    <!-- Active Jawatankuasa AJK Directory -->
    <div class="mb-8 flex-1">
        <h3 class="text-xs font-extrabold text-slate-400 uppercase tracking-widest mb-4 flex items-center gap-1.5"><i class="fas fa-users-cog text-slate-300"></i> Hubungan Jawatankuasa</h3>
        <div class="space-y-4">
            <% if (ajkList != null && !ajkList.isEmpty()) {
                for (Pengguna ajk : ajkList) { %>
                <div class="flex items-center justify-between p-3 rounded-2xl bg-slate-50 border border-slate-100 hover:border-slate-200 transition-all group">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-lg bg-white shadow-sm flex items-center justify-center text-slate-700 font-extrabold text-[11px] uppercase border border-slate-100 group-hover:bg-slate-800 group-hover:text-white transition-colors">
                            <%= ajk.getNama_penuh().substring(0, 1) %>
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-bold text-slate-800 truncate max-w-[120px]"><%= ajk.getNama_penuh() %></p>
                            <p class="text-[9px] text-slate-400 truncate max-w-[120px]"><%= ajk.getNama_jawatan() != null ? ajk.getNama_jawatan() : "AJK" %></p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1.5">
                        <a href="https://wa.me/6<%= ajk.getNombor_telefon() %>" target="_blank" 
                           class="w-7 h-7 rounded-lg bg-green-50 text-green-600 hover:bg-green-500 hover:text-white transition flex items-center justify-center text-xs shadow-sm border border-green-100"
                           title="Hubungi WhatsApp">
                            <i class="fab fa-whatsapp"></i>
                        </a>
                    </div>
                </div>
            <% } } else { %>
                <p class="text-[11px] text-slate-400 italic">Tiada maklumat AJK Kampung dijumpai.</p>
            <% } %>
        </div>
    </div>

    <!-- Management Advice Card -->
    <div class="mt-auto">
        <h4 class="text-[10px] font-extrabold text-slate-400 uppercase tracking-widest mb-3">Nota Pengurusan Kebajikan</h4>
        <div class="bg-gradient-to-br from-[#064E3B] to-[#047857] rounded-3xl p-5 border border-white/5 relative overflow-hidden group">
            <i class="fas fa-scroll absolute -right-2 -bottom-2 text-emerald-950 text-6xl opacity-40"></i>
            <p class="text-[11px] text-emerald-200 leading-relaxed relative z-10 font-medium">
                Peringatan: Pastikan pemohon berpendapatan rendah atau asnaf diberi keutamaan tinggi. Semak fail lampiran penyata pendapatan atau pengesahan jawatankuasa bagi membuktikan kelayakan.
            </p>
        </div>
        
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="w-full mt-6 bg-rose-50 text-rose-600 border border-rose-100 py-3.5 rounded-2xl text-xs font-black uppercase tracking-wider hover:bg-rose-600 hover:text-white hover:border-rose-600 transition-all flex items-center justify-center gap-2 shadow-sm">
            <i class="fas fa-sign-out-alt"></i> Log Keluar
        </a>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>
