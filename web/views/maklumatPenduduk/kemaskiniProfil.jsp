<%@ page import="model.Pengguna" %>
<%
    // 1. Dapatkan objek user dari session (Variabel 'user' biasanya sudah ada dari navbar.jsp)
    // Jika tiada, kita ambil semula untuk kepastian.
    Pengguna pDetail = (Pengguna) session.getAttribute("currentUser");

    if (pDetail == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="mb-8">
        <h2 class="text-2xl font-bold text-gray-800">Profil Saya</h2>
        <p class="text-gray-500 text-sm">Kemaskini maklumat peribadi dan status sosio-ekonomi.</p>
    </header>

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
        <% } %>
    <% } %>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <%-- Kad Kiri: Ringkasan --%>
        <div class="lg:col-span-1">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 text-center relative overflow-hidden">
                <div class="absolute top-0 left-0 w-full h-24 bg-gradient-to-r from-[#6C5DD3] to-[#8B7EF8] opacity-10"></div>
                
                <div class="relative inline-block mb-4 mt-4">
                    <div class="w-32 h-32 rounded-full p-1 border-4 border-[#6C5DD3] bg-white mx-auto flex items-center justify-center text-4xl font-bold text-[#6C5DD3] shadow-lg overflow-hidden">
                        <img src="https://ui-avatars.com/api/?name=<%= pDetail.getNama_penuh() %>&background=6C5DD3&color=fff&size=128" class="w-full h-full object-cover">
                    </div>
                    <div class="absolute bottom-2 right-2 w-6 h-6 bg-green-500 border-2 border-white rounded-full"></div>
                </div>

                <h3 class="text-xl font-bold text-gray-800"><%= pDetail.getNama_penuh() %></h3>
                <p class="text-sm text-gray-400 mb-4"><%= pDetail.getNombor_kp() %></p>
                
                <span class="bg-purple-50 text-[#6C5DD3] px-4 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider">
                    <%= pDetail.getNama_peranan() %>
                </span>
            </div>
        </div>

        <%-- Kolum Kanan: Borang Kemaskini --%>
        <div class="lg:col-span-2">
            <form action="<%= request.getContextPath() %>/profil/update" method="post">
                <div class="bg-white rounded-3xl p-6 md:p-8 shadow-sm border border-gray-100">
                    
                    <%-- Bahagian 1: Peribadi --%>
                    <div class="mb-8">
                        <h4 class="text-sm font-bold text-[#6C5DD3] uppercase tracking-wider mb-4 border-b border-gray-100 pb-2">
                            1. Maklumat Peribadi
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="md:col-span-2">
                                <label class="block text-xs font-bold text-gray-500 mb-2">Nama Penuh (Seperti MyKad)</label>
                                <input type="text" name="nama_penuh" value="<%= pDetail.getNama_penuh() %>" required    
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">No. Kad Pengenalan</label>
                                <input type="text" value="<%= pDetail.getNombor_kp() %>" readonly
                                       class="w-full px-4 py-3 rounded-xl bg-gray-100 border-none text-gray-400 text-sm cursor-not-allowed font-medium">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">No. Telefon</label>
                                <input type="text" name="nombor_telefon" value="<%= pDetail.getNombor_telefon() %>" required
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
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
                                <input type="text" name="nama_jalan" value="<%= pDetail.getNama_jalan() %>" required
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Poskod</label>
                                <input type="text" name="nombor_poskod" value="<%= (pDetail.getNombor_poskod() != null) ? pDetail.getNombor_poskod() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Bandar</label>
                                <input type="text" name="bandar" value="<%= (pDetail.getBandar() != null) ? pDetail.getBandar() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Negeri</label>
                                <select name="negeri" class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium">
                                    <option value="Terengganu" <%= "Terengganu".equals(pDetail.getNegeri()) ? "selected" : "" %>>Terengganu</option>
                                    <option value="Kelantan" <%= "Kelantan".equals(pDetail.getNegeri()) ? "selected" : "" %>>Kelantan</option>
                                    <option value="Pahang" <%= "Pahang".equals(pDetail.getNegeri()) ? "selected" : "" %>>Pahang</option>
                                </select>
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
                                    <option value="Bujang" <%= "Bujang".equals(pDetail.getStatus_keluarga()) ? "selected" : "" %>>Bujang</option>
                                    <option value="Berkahwin" <%= "Berkahwin".equals(pDetail.getStatus_keluarga()) ? "selected" : "" %>>Berkahwin</option>
                                    <option value="Ibu Tunggal" <%= "Ibu Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : "" %>>Ibu Tunggal</option>
                                    <option value="Bapa Tunggal" <%= "Bapa Tunggal".equals(pDetail.getStatus_keluarga()) ? "selected" : "" %>>Bapa Tunggal</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Pekerjaan</label>
                                <input type="text" name="pekerjaan" value="<%= (pDetail.getPekerjaan() != null) ? pDetail.getPekerjaan() : "" %>"
                                       class="w-full px-4 py-3 rounded-xl bg-gray-50 border-none focus:ring-2 focus:ring-[#6C5DD3] text-gray-800 text-sm font-medium transition-all">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 mb-2">Pendapatan (RM)</label>
                                <input type="number" step="0.01" name="pendapatan" value="<%= pDetail.getPendapatan() %>"
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
        <h3 class="font-bold text-lg text-gray-800">Status Profil</h3>
    </div>

    <div class="text-center mb-10">
        <div class="w-full bg-purple-50 rounded-2xl p-6">
            <p class="text-xs font-bold text-gray-400 uppercase mb-2">Kelengkapan Data</p>
            <%-- Logik Progress Bar Ringkas --%>
            <% 
                int progress = 0;
                if(pDetail.getPekerjaan() != null) progress += 33;
                if(pDetail.getPendapatan() != null) progress += 33;
                if(pDetail.getStatus_keluarga() != null) progress += 34;
            %>
            <div class="relative pt-1">
                <div class="overflow-hidden h-2 mb-4 text-xs flex rounded bg-purple-200">
                    <div style="width: <%= progress %>%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-[#6C5DD3]"></div>
                </div>
                <p class="text-2xl font-bold text-[#6C5DD3]"><%= progress %>%</p>
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

<%@ include file="/views/common/footer.jsp" %>