<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="model.PermohonanBantuan" %>
<%@ page import="java.util.List" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    // Ambil maklumat Ketua Kampung secara dinamik untuk rujukan WhatsApp
    String namaKetua = "Ketua Kampung";
    String telKetua = "";
    
    try (java.sql.Connection conn = util.DBUtil.getConnection();
         java.sql.PreparedStatement ps = conn.prepareStatement(
             "SELECT p.nama_penuh, p.nombor_telefon " +
             "FROM pengguna p " +
             "JOIN pengguna_peranan pp ON p.id_pengguna = pp.id_pengguna " +
             "JOIN peranan r ON pp.id_peranan = r.id_peranan " +
             "WHERE r.nama_peranan = 'Ketua Kampung' LIMIT 1"
         )) {
        try (java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                namaKetua = rs.getString("nama_penuh");
                telKetua = rs.getString("nombor_telefon");
            }
        }
    } catch (Exception e) {
        // Safe fallback
    }

    String waKetuaNumber = telKetua != null ? telKetua.replaceAll("\\D", "") : "";
    if (waKetuaNumber.startsWith("0")) {
        waKetuaNumber = "6" + waKetuaNumber;
    } else if (waKetuaNumber.startsWith("1") || waKetuaNumber.startsWith("11")) {
        waKetuaNumber = "60" + waKetuaNumber;
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">
    <!-- Elegant Header Section -->
    <header class="text-center mb-12 max-w-2xl mx-auto mt-4 animate-in fade-in slide-in-from-top-3 duration-500">
        <span class="text-xs font-black text-brand-purple uppercase tracking-[0.2em] block mb-2">Pilihan Khidmat Kebajikan</span>
        <h2 class="text-4xl font-extrabold text-slate-800 tracking-tight mb-3">Pusat Bantuan Rakyat</h2>
        <p class="text-slate-500 text-sm leading-relaxed font-medium">Sila pilih kategori bantuan yang anda perlukan. Kami sedia mempermudahkan permohonan kebajikan penduduk Kampung Danan.</p>
    </header>

    <!-- Interactive Grid Layout -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto animate-in fade-in slide-in-from-bottom-4 duration-500">
        
        <!-- Bantuan Komuniti Card -->
        <a href="<%= request.getContextPath() %>/bantuan/komuniti" class="group">
            <div class="bg-white/80 border border-slate-100 backdrop-blur-md rounded-[2.5rem] p-8 md:p-10 shadow-sm h-full text-center transition-all duration-300 hover:shadow-xl hover:shadow-brand-purple/10 hover:-translate-y-2 hover:border-brand-purple relative overflow-hidden flex flex-col justify-between">
                
                <!-- Glowing Aura Background -->
                <div class="absolute -right-16 -bottom-16 w-44 h-44 bg-emerald-500/5 rounded-full blur-2xl group-hover:scale-150 transition-all duration-500"></div>
                <div class="absolute inset-0 bg-gradient-to-br from-brand-purple/0 to-brand-purple/[0.02] opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>

                <div class="relative z-10">
                    <!-- Icon Wrapper -->
                    <div class="w-20 h-20 rounded-3xl bg-emerald-50 text-emerald-600 flex items-center justify-center mx-auto mb-6 text-3xl group-hover:bg-emerald-600 group-hover:text-white transition-all duration-500 shadow-md shadow-emerald-100 group-hover:shadow-emerald-200 group-hover:rotate-6">
                        <i class="fas fa-hand-holding-heart"></i>
                    </div>

                    <h3 class="text-xl font-extrabold text-slate-800 mb-3 group-hover:text-brand-purple transition-colors">Bantuan Komuniti</h3>
                    
                    <p class="text-slate-500 text-xs leading-relaxed mb-8 font-medium">
                        Sumbangan kebajikan tempatan termasuk khairat kematian, dana kecemasan bencana, dan pelbagai inisiatif gotong-royong kampung.
                    </p>
                </div>

                <div class="relative z-10">
                    <span class="inline-flex items-center gap-2 px-6 py-3 rounded-2xl border border-slate-200 text-slate-600 font-bold text-xs uppercase tracking-wider group-hover:bg-brand-purple group-hover:text-white group-hover:border-brand-purple transition-all duration-300 shadow-sm">
                        Pilih Komuniti <i class="fas fa-arrow-right text-[10px] group-hover:translate-x-1 transition-transform"></i>
                    </span>
                </div>
            </div>
        </a>

        <!-- Bantuan Rasmi Card -->
        <a href="<%= request.getContextPath() %>/bantuan/rasmi" class="group">
            <div class="bg-white/80 border border-slate-100 backdrop-blur-md rounded-[2.5rem] p-8 md:p-10 shadow-sm h-full text-center transition-all duration-300 hover:shadow-xl hover:shadow-brand-purple/10 hover:-translate-y-2 hover:border-brand-purple relative overflow-hidden flex flex-col justify-between">
                
                <!-- Glowing Aura Background -->
                <div class="absolute -right-16 -bottom-16 w-44 h-44 bg-indigo-500/5 rounded-full blur-2xl group-hover:scale-150 transition-all duration-500"></div>
                <div class="absolute inset-0 bg-gradient-to-br from-brand-purple/0 to-brand-purple/[0.02] opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>

                <div class="relative z-10">
                    <!-- Icon Wrapper -->
                    <div class="w-20 h-20 rounded-3xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-6 text-3xl group-hover:bg-indigo-600 group-hover:text-white transition-all duration-500 shadow-md shadow-indigo-100 group-hover:shadow-indigo-200 group-hover:rotate-6">
                        <i class="fas fa-file-signature"></i>
                    </div>

                    <h3 class="text-xl font-extrabold text-slate-800 mb-3 group-hover:text-brand-purple transition-colors">Bantuan Rasmi</h3>
                    
                    <p class="text-slate-500 text-xs leading-relaxed mb-8 font-medium">
                        Urusan rasmi kerajaan merangkumi permohonan kebajikan JKM, surat sokongan Ketua Kampung, pengesahan pendapatan, dan khidmat agensi luar.
                    </p>
                </div>

                <div class="relative z-10">
                    <span class="inline-flex items-center gap-2 px-6 py-3 rounded-2xl border border-slate-200 text-slate-600 font-bold text-xs uppercase tracking-wider group-hover:bg-brand-purple group-hover:text-white group-hover:border-brand-purple transition-all duration-300 shadow-sm">
                        Pilih Rasmi <i class="fas fa-arrow-right text-[10px] group-hover:translate-x-1 transition-transform"></i>
                    </span>
                </div>
            </div>
        </a>

    </div>

    <!-- Help & Contacts Section -->
    <div class="mt-16 text-center animate-in fade-in slide-in-from-bottom-2 duration-700">
        <p class="text-sm text-slate-400 font-medium">
            Ada kemusykilan lain? 
            <% if (!telKetua.isEmpty() && !waKetuaNumber.isEmpty()) { %>
                <a href="https://wa.me/<%= waKetuaNumber %>" target="_blank" class="text-brand-purple hover:text-brand-purpleHover font-bold hover:underline transition-all inline-flex items-center gap-2 mt-2 bg-white px-5 py-2.5 rounded-full border border-slate-100 shadow-sm hover:shadow-md ml-1.5 cursor-pointer">
                    <i class="fab fa-whatsapp text-emerald-500 text-base animate-bounce"></i> 
                    Hubungi <%= namaKetua %>
                </a>
            <% } else { %>
                <span class="text-brand-purple font-bold ml-1">Hubungi Ketua Kampung</span> secara terus.
            <% } %>
        </p>
    </div>

</div>

<!-- Right Side Glassmorphic Sidebar -->
<aside class="w-80 bg-white/80 border-l border-slate-100 backdrop-blur-md hidden xl:flex flex-col p-8 overflow-y-auto h-full shrink-0">
    <div class="mb-8">
        <h3 class="font-black text-lg text-slate-800 tracking-tight">Status Permohonan</h3>
        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mt-1">Urusan Kebajikan Aktif</p>
    </div>

    <!-- Active List -->
    <div class="flex flex-col gap-4 flex-1">
        <% 
            List<PermohonanBantuan> pList = (List<PermohonanBantuan>) request.getAttribute("permohonanList");
            int activeCount = 0;
            if (pList != null) {
                for (PermohonanBantuan pb : pList) {
                    String s = pb.getStatus();
                    if ("BARU".equalsIgnoreCase(s) || "DIKEMBALIKAN".equalsIgnoreCase(s) || "MENUNGGU_KETUA".equalsIgnoreCase(s)) {
                        activeCount++;
                        
                        // Set up dynamic visual steps
                        int progressPct = 33;
                        String progressColor = "bg-blue-500";
                        String statusMsg = "Dalam semakan Biro...";
                        String statusClass = "bg-blue-50 border-blue-100 text-blue-600";
                        String statusLabel = "PROSES";
                        
                        if ("DIKEMBALIKAN".equalsIgnoreCase(s)) {
                            progressPct = 50;
                            progressColor = "bg-amber-500";
                            statusMsg = "Perlukan kemaskini dokumen";
                            statusClass = "bg-amber-50 border-amber-100 text-amber-600";
                            statusLabel = "TINDAKAN";
                        } else if ("MENUNGGU_KETUA".equalsIgnoreCase(s)) {
                            progressPct = 75;
                            progressColor = "bg-purple-500";
                            statusMsg = "Menunggu kelulusan Ketua...";
                            statusClass = "bg-purple-50 border-purple-100 text-brand-purple";
                            statusLabel = "SEMAKAN";
                        }
        %>
            <div class="bg-white/60 border border-slate-100 rounded-3xl p-5 shadow-sm transition-all hover:border-brand-purple/30 hover:bg-white group relative overflow-hidden">
                <div class="flex justify-between items-start mb-3">
                    <span class="text-[10px] font-black text-slate-400 uppercase tracking-wider block max-w-[120px] truncate"><%= pb.getNama_bantuan() %></span>
                    <span class="text-[9px] px-2.5 py-0.5 rounded-md font-black tracking-wide border <%= statusClass %>">
                        <%= statusLabel %>
                    </span>
                </div>
                
                <h4 class="text-xs font-bold text-slate-700 mb-2">ID: #<%= pb.getId_permohonan() %></h4>
                
                <!-- Dynamic Progress Indicator -->
                <div class="space-y-1.5 mb-2.5">
                    <div class="w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
                        <div class="h-full rounded-full transition-all duration-500 <%= progressColor %>" style="width: <%= progressPct %>%;"></div>
                    </div>
                    <div class="flex items-center justify-between text-[9px] text-slate-400 font-bold">
                        <span>Peringkat Semakan</span>
                        <span><%= progressPct %>%</span>
                    </div>
                </div>

                <!-- Clock / Status footer -->
                <div class="flex items-center gap-1.5 text-[10px] text-slate-400 font-medium">
                    <i class="far fa-clock text-[9px] text-brand-purple"></i>
                    <span><%= statusMsg %></span>
                </div>
            </div>
        <% 
                    }
                }
            } 
            if (activeCount == 0) {
        %>
            <!-- Premium Empty State -->
            <div class="text-center py-12 px-4 bg-slate-50 border border-slate-100/50 rounded-3xl flex flex-col items-center justify-center my-auto">
                <div class="w-16 h-16 bg-white border border-slate-100 rounded-2xl flex items-center justify-center mb-4 text-slate-300 shadow-sm">
                    <i class="fas fa-inbox text-2xl"></i>
                </div>
                <h4 class="font-extrabold text-sm text-slate-800">Tiada Permohonan Aktif</h4>
                <p class="text-[11px] text-slate-400 mt-1 max-w-[180px] mx-auto leading-relaxed font-medium">Sejarah dan status kebajikan aktif anda akan dipaparkan di sini.</p>
            </div>
        <% } %>
    </div>

    <!-- Informational Tip Card -->
    <div class="mt-8 bg-brand-accent border border-brand-secondary/10 rounded-3xl p-6 relative overflow-hidden group hover:border-brand-secondary/20 transition-all duration-300 shrink-0">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-brand-purple/5 rounded-full opacity-50 group-hover:scale-110 transition-transform"></div>
        <h4 class="font-black text-brand-purple text-xs uppercase tracking-widest mb-2 relative z-10 flex items-center gap-1.5">
            <i class="fas fa-lightbulb"></i> Tahukah Anda?
        </h4>
        <p class="text-[11px] text-slate-500 leading-relaxed relative z-10 font-medium">
            Sebarang permohonan Bantuan JKM memerlukan maklumat pendapatan yang disahkan sahih berserta dokumen sokongan lengkap untuk semakan pejabat kebajikan daerah.
        </p>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>