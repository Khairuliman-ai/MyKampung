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
                        Bantuan kebajikan dalaman yang diuruskan oleh jawatankuasa kampung menggunakan tabung komuniti setempat. Ini termasuk khairat kematian penduduk, bantuan kilat bencana alam (banjir/kebakaran), bantuan sara hidup kecemasan, serta dana aktiviti kemasyarakatan kampung.
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
                        Permohonan bantuan rasmi di peringkat kerajaan (JKM, MAIK, Zakat) atau swasta. Urusan merangkumi penyediaan surat sokongan pengesahan pendapatan daripada Ketua Kampung, permohonan skim sara hidup bulanan agensi luar, serta surat sokongan kebajikan sekolah anak-anak.
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
            Ada pertanyaan lain? 
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
        <h3 class="font-black text-lg text-slate-800 tracking-tight">Panduan & Syarat</h3>
        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-widest mt-1">Sila Sediakan Sebelum Memohon</p>
    </div>

    <!-- Interactive Step List -->
    <div class="flex flex-col gap-6 flex-1">
        <!-- Checklist Dokumen -->
        <div class="bg-indigo-50/50 border border-indigo-100 rounded-3xl p-5 shadow-sm transition-all hover:bg-indigo-50">
            <h4 class="text-xs font-black text-indigo-700 uppercase tracking-wider mb-3 flex items-center gap-1.5">
                <i class="fas fa-folder-open text-sm"></i> Dokumen Wajib
            </h4>
            <ul class="space-y-3.5 text-[11px] text-slate-600 font-medium">
                <li class="flex items-start gap-2">
                    <span class="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[8px] font-black shrink-0 mt-0.5"><i class="fas fa-check"></i></span>
                    <span>Salinan Kad Pengenalan (MyKad) pemohon & tanggungan.</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[8px] font-black shrink-0 mt-0.5"><i class="fas fa-check"></i></span>
                    <span>Penyata Gaji terkini atau Borang Pengesahan Pendapatan.</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-[8px] font-black shrink-0 mt-0.5"><i class="fas fa-check"></i></span>
                    <span>Borang yang ingin disahkan oleh Ketua Kampung.</span>
                </li>
            </ul>
        </div>

        <!-- Langkah-langkah Permohonan -->
        <div class="space-y-4">
            <h4 class="text-xs font-black text-slate-800 uppercase tracking-wider flex items-center gap-1.5">
                <i class="fas fa-tasks text-sm text-brand-purple"></i> Langkah Permohonan
            </h4>
            <div class="relative pl-6 space-y-5 before:absolute before:left-[7px] before:top-2 before:bottom-2 before:w-0.5 before:bg-slate-200">
                <!-- Step 1 -->
                <div class="relative">
                    <div class="absolute -left-8 top-0.5 w-4 h-4 rounded-full bg-brand-purple text-white flex items-center justify-center text-[9px] font-bold ring-4 ring-white">1</div>
                    <h5 class="text-xs font-bold text-slate-700">Pilih Kategori Bantuan</h5>
                    <p class="text-[10px] text-slate-400 leading-relaxed mt-0.5">Sama ada <strong>Bantuan Komuniti</strong> (Tabung Kampung) atau <strong>Bantuan Rasmi</strong> (Agensi Kerajaan/Swasta).</p>
                </div>
                <!-- Step 2 -->
                <div class="relative">
                    <div class="absolute -left-8 top-0.5 w-4 h-4 rounded-full bg-brand-purple text-white flex items-center justify-center text-[9px] font-bold ring-4 ring-white">2</div>
                    <h5 class="text-xs font-bold text-slate-700">Isi Borang & Muat Naik Dokumen</h5>
                    <p class="text-[10px] text-slate-400 leading-relaxed mt-0.5">Sediakan maklumat peribadi, maklumat sosio-ekonomi keluarga serta slip pengesahan pendapatan.</p>
                </div>
                <!-- Step 3 -->
                <div class="relative">
                    <div class="absolute -left-8 top-0.5 w-4 h-4 rounded-full bg-brand-purple text-white flex items-center justify-center text-[9px] font-bold ring-4 ring-white">3</div>
                    <h5 class="text-xs font-bold text-slate-700">Semakan Biro & Pengerusi</h5>
                    <p class="text-[10px] text-slate-400 leading-relaxed mt-0.5">AJK Biro akan menyemak kelayakan sosio-ekonomi sebelum disokong dan diluluskan oleh Ketua Kampung.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Informational Tip Card -->
    <div class="mt-8 bg-brand-accent border border-brand-secondary/10 rounded-3xl p-6 relative overflow-hidden group hover:border-brand-secondary/20 transition-all duration-300 shrink-0">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-brand-purple/5 rounded-full opacity-50 group-hover:scale-110 transition-transform"></div>
        <h4 class="font-black text-brand-purple text-xs uppercase tracking-widest mb-2 relative z-10 flex items-center gap-1.5">
            <i class="fas fa-handshake"></i> Sokongan Kami
            <span class="flex h-1.5 w-1.5 rounded-full bg-emerald-500 animate-ping"></span>
        </h4>
        <p class="text-[11px] text-slate-500 leading-relaxed relative z-10 font-medium">
            Permohonan yang diluluskan akan disalurkan terus ke akaun pemohon atau diserahkan secara tunai oleh wakil Biro Kebajikan Kampung Danan.
        </p>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>