
<%@ page import="model.Pengguna" %>
<%@ page import="model.Penduduk" %>
<%@ page import="dao.PendudukDAO" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%
    // --- LOGIK JAVA ---
    // Nota: Variable 'user' (objek Pengguna) sudah wujud dari navbar.jsp
    // Kita guna terus untuk dapatkan ID.

    Penduduk detail = (Penduduk) request.getAttribute("pendudukDetail");
    
    // 1. Fallback: Jika null, query DB guna ID dari session user
    if(detail == null && user != null) {
        PendudukDAO pDao = new PendudukDAO();
        try {
            detail = pDao.getByUserId(user.getIdPengguna());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 2. Fallback Terakhir: Jika masih null (user baru), buat objek kosong elak error JSP
    if(detail == null) {
        detail = new Penduduk();
        detail.setPekerjaan("-");
        detail.setStatusSemasa("Menetap");
        detail.setPendapatan(0);
    }
%>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Profil Saya</h2>
        <p class="text-gray-500 text-sm">Kemaskini maklumat peribadi dan status semasa.</p>
    </header>

    <% if (request.getParameter("status") != null) { %>
        <% if (request.getParameter("status").equals("success")) { %>
            <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-check-circle text-lg"></i>
                <div>
                    <span class="font-bold">Berjaya!</span> Maklumat anda telah dikemaskini.
                </div>
            </div>
        <% } else { %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 flex items-center gap-3 shadow-sm">
                <i class="fas fa-exclamation-circle text-lg"></i>
                <div>
                    <span class="font-bold">Ralat!</span> Berlaku masalah semasa mengemaskini.
                </div>
            </div>
        <% } %>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <div class="lg:col-span-1">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 text-center relative overflow-hidden">
                <div class="absolute top-0 left-0 w-full h-24 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] opacity-10"></div>
                
                <div class="relative inline-block mb-4 mt-4">
                    <div class="w-32 h-32 rounded-full p-1 border-4 border-[#6C5DD3] bg-white mx-auto flex items-center justify-center text-4xl font-bold text-[#6C5DD3] shadow-lg">
                        <%= (user.getNamaPertama() != null) ? user.getNamaPertama().substring(0,1).toUpperCase() : "U" %>
                    </div>
                    <div class="absolute bottom-2 right-2 w-6 h-6 bg-green-500 border-2 border-white rounded-full"></div>
                </div>

                <h3 class="text-xl font-bold text-gray-800"><%= user.getNamaLengkap() %></h3>
                <p class="text-sm text-gray-400 mb-4"><%= user.getNomborKP() %></p>
                
                <span class="bg-purple-50 text-[#6C5DD3] px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider">
                    Penduduk Sah
                </span>
            </div>
        </div>

        <div class="lg:col-span-2">
            <form action="<%= request.getContextPath() %>/profil/update" method="post">
                <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100">
                    
                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            1. Maklumat Peribadi
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Nama Pertama</label>
                                <input type="text" name="namaPertama" value="<%= user.getNamaPertama() %>" required
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm placeholder-gray-400 font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Nama Kedua / Bapa</label>
                                <input type="text" name="namaKedua" value="<%= (user.getNamaKedua() != null) ? user.getNamaKedua() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">No. Kad Pengenalan</label>
                                <input type="text" value="<%= user.getNomborKP() %>" readonly
                                       class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-400 text-sm cursor-not-allowed font-medium">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">No. Telefon</label>
                                <input type="text" name="nomborTelefon" value="<%= user.getNomborTelefon() %>" required
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-xs font-bold text-gray-500 mb-2">Kata Laluan Baru (Kosongkan jika tiada perubahan)</label>
                                <input type="password" name="kataLaluan" placeholder="Masukkan kata laluan baru..."
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                        </div>
                    </div>

                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            2. Alamat Tempat Tinggal
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="md:col-span-3">
                                <label class="block text-xs font-bold text-gray-500 mb-2">Nama Jalan / No. Rumah</label>
                                <input type="text" name="namaJalan" value="<%= user.getNamaJalan() %>" required
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Poskod</label>
                                <input type="text" name="nomborPoskod" value="<%= (user.getNomborPoskod() != null) ? user.getNomborPoskod() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Bandar</label>
                                <input type="text" name="bandar" value="<%= (user.getBandar() != null) ? user.getBandar() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Negeri</label>
                                <div class="relative">
                                    <select name="negeri" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium appearance-none">
                                        <option value="Kelantan" <%= "Kelantan".equals(user.getNegeri()) ? "selected" : "" %>>Kelantan</option>
                                        <option value="Terengganu" <%= "Terengganu".equals(user.getNegeri()) ? "selected" : "" %>>Terengganu</option>
                                        <option value="Pahang" <%= "Pahang".equals(user.getNegeri()) ? "selected" : "" %>>Pahang</option>
                                    </select>
                                    <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                                        <i class="fas fa-chevron-down text-xs"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            3. Maklumat Sosio-Ekonomi
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Status Kediaman</label>
                                <div class="relative">
                                    <select name="statusSemasa" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium appearance-none">
                                        <option value="Menetap" <%= "Menetap".equals(detail.getStatusSemasa()) ? "selected" : "" %>>Menetap</option>
                                        <option value="Menyewa" <%= "Menyewa".equals(detail.getStatusSemasa()) ? "selected" : "" %>>Menyewa</option>
                                        <option value="Tumpang" <%= "Tumpang".equals(detail.getStatusSemasa()) ? "selected" : "" %>>Menumpang</option>
                                    </select>
                                    <div class="absolute inset-y-0 right-0 flex items-center px-4 pointer-events-none text-gray-500">
                                        <i class="fas fa-chevron-down text-xs"></i>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Pekerjaan</label>
                                <input type="text" name="pekerjaan" value="<%= (detail.getPekerjaan() != null) ? detail.getPekerjaan() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Pendapatan (RM)</label>
                                <input type="number" name="pendapatan" value="<%= detail.getPendapatan() %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                        </div>
                    </div>

                    <div class="pt-4">
                        <button type="submit" class="w-full bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white font-bold py-3.5 rounded-xl shadow-lg shadow-purple-200 transition-all flex justify-center items-center gap-2">
                            <i class="fas fa-save"></i> Simpan Perubahan
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Status Akaun</h3>
    </div>

    <div class="text-center mb-10">
        <div class="w-full bg-purple-50 rounded-2xl p-6">
            <p class="text-xs font-bold text-gray-400 uppercase mb-2">Lengkap Profil</p>
            <div class="relative pt-1">
                <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-purple-200">
                    <div style="width: 80%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-[#6C5DD3]"></div>
                </div>
                <p class="text-2xl font-bold text-[#6C5DD3]">80%</p>
            </div>
            <p class="text-xs text-gray-500 mt-2">Lengkapkan maklumat sosio-ekonomi untuk memohon bantuan.</p>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4">Pautan Pantas</h3>
        <div class="space-y-3">
             <a href="#" class="flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 border border-transparent hover:border-gray-100 transition">
                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                    <i class="fas fa-key text-xs"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-bold text-gray-800">Tukar Password</p>
                </div>
                <i class="fas fa-chevron-right text-gray-300 text-xs"></i>
            </a>
            <a href="#" class="flex items-center gap-3 p-3 rounded-xl hover:bg-gray-50 border border-transparent hover:border-gray-100 transition">
                <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                    <i class="fas fa-file-contract text-xs"></i>
                </div>
                <div class="flex-1">
                    <p class="text-sm font-bold text-gray-800">Sejarah Aktiviti</p>
                </div>
                <i class="fas fa-chevron-right text-gray-300 text-xs"></i>
            </a>
        </div>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>