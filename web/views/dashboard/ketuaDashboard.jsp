<%@ page import="model.Pengguna" %>
<%
    // Mendapatkan data user dari session yang telah set di LoginServlet
    Pengguna user = (Pengguna) session.getAttribute("currentUser");
    
    // Sekuriti tambahan: Jika akses terus tanpa login
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
%>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 p-4 md:p-8 scroll-smooth h-auto xl:h-full xl:overflow-y-auto bg-[#F7F7F9]">

    <header class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Papan Pemuka Ketua</h2>
            <p class="text-gray-500 text-sm">Selamat bertugas, <%= user.getNama_penuh() %>.</p>
        </div>
        
        <div class="relative w-full md:w-96">
            <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-gray-400">
                <i class="fas fa-search"></i>
            </span>
            <input type="text" 
                   class="w-full pl-11 pr-4 py-3 bg-white rounded-2xl border-none focus:ring-2 focus:ring-[#6C5DD3] shadow-sm text-sm placeholder-gray-400" 
                   placeholder="Cari pemohon atau fail...">
        </div>
    </header>

    <div class="relative bg-gradient-to-r from-[#2c3e50] to-[#4ca1af] rounded-3xl p-8 text-white mb-8 shadow-xl shadow-gray-300 overflow-hidden">
        <div class="relative z-10 max-w-lg">
            <span class="bg-white/20 text-xs font-bold px-3 py-1 rounded-full backdrop-blur-sm text-cyan-300"><%= user.getNama_peranan().toUpperCase() %></span>
            <h1 class="text-3xl font-bold mt-4 mb-2 leading-tight">Selamat Datang, <%= user.getNama_penuh() %>!</h1>
            <p class="text-gray-100 mb-6 text-sm opacity-90">
                Anda sedang melihat ringkasan tadbir urus bagi Mukim <%= user.getBandar() %>.
            </p>
            <div class="flex gap-3">
                <a href="<%= request.getContextPath() %>/bantuan/list" class="bg-white text-[#2c3e50] px-6 py-2.5 rounded-xl font-bold text-sm hover:bg-gray-100 transition shadow-md flex items-center gap-2">
                    <i class="fas fa-stamp"></i> Semak Permohonan
                </a>
            </div>
        </div>
        <div class="absolute top-0 right-0 -mr-10 -mt-10 w-64 h-64 bg-white opacity-5 rounded-full blur-3xl"></div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center text-orange-500 text-xl">
                <i class="fas fa-stamp"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Menunggu Sokongan</p>
                <h3 class="text-xl font-bold text-gray-800">3</h3>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50 flex items-center gap-4">
            <div class="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-500 text-xl">
                <i class="fas fa-users"></i>
            </div>
            <div>
                <p class="text-xs text-gray-400 font-bold uppercase">Alamat Berdaftar</p>
                <h3 class="text-sm font-bold text-gray-800"><%= user.getNama_jalan() %></h3>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden mb-8">
        <div class="p-6 border-b border-gray-50">
             <h3 class="font-bold text-xl text-gray-800">Senarai Permohonan Terbaru</h3>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Pemohon</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase">Jenis</th>
                        <th class="p-4 text-xs font-bold text-gray-400 uppercase text-center">Tindakan</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <tr class="hover:bg-gray-50/50 transition">
                        <td class="p-4 text-sm font-bold">Abu Bakar</td>
                        <td class="p-4 text-sm text-gray-500">Bantuan Bencana Alam</td>
                        <td class="p-4 text-center">
                            <button class="text-[#6C5DD3] text-xs font-bold px-3 py-1.5 rounded-lg border border-purple-200">Semak</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div> 

<aside class="w-full xl:w-80 bg-white border-t xl:border-t-0 xl:border-l border-gray-100 flex flex-col p-8 flex-shrink-0">
    
    <div class="flex justify-between items-start mb-10">
        <h3 class="font-bold text-lg text-gray-800">Profil Saya</h3>
        <button class="text-gray-400 hover:text-gray-600"><i class="fas fa-cog"></i></button>
    </div>

    <div class="text-center mb-10">
        <div class="relative w-24 h-24 mx-auto mb-4">
            <img src="https://ui-avatars.com/api/?name=<%= user.getNama_penuh() %>&background=2c3e50&color=fff&size=128" 
                 class="w-full h-full rounded-full object-cover border-4 border-white shadow-lg relative z-10">
            <div class="absolute bottom-1 right-1 w-6 h-6 bg-green-500 border-2 border-white rounded-full z-20"></div>
        </div>
        
        <h2 class="text-xl font-bold text-gray-800"><%= user.getNama_penuh() %></h2>
        <p class="text-xs font-bold text-gray-500 mt-1"><%= user.getNama_peranan() %></p>
        <p class="text-[10px] text-gray-400"><%= user.getNombor_kp() %></p>
    </div>

    <div class="mb-8">
        <h3 class="font-bold text-sm text-gray-800 mb-4">Maklumat Kediaman</h3>
        <div class="p-4 rounded-2xl bg-gray-50 border border-gray-100">
            <p class="text-xs text-gray-500 uppercase font-bold mb-1">Alamat</p>
            <p class="text-sm text-gray-800 font-medium"><%= user.getAlamatLengkap() %></p>
        </div>
    </div>

    <div>
        <h3 class="font-bold text-sm text-gray-800 mb-4">Pautan Pantas</h3>
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="w-full bg-red-50 text-red-600 py-3 rounded-xl text-sm font-bold hover:bg-red-100 transition flex items-center justify-center gap-2">
            <i class="fas fa-sign-out-alt"></i> Log Keluar
        </a>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>