<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>

<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-4 md:p-8 scroll-smooth h-full bg-[#F7F7F9]">

    <header class="text-center mb-10 max-w-2xl mx-auto">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">Pusat Bantuan</h2>
        <p class="text-gray-500">Sila pilih kategori bantuan yang anda perlukan. Kami sedia membantu memudahkan urusan anda.</p>
    </header>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
        
        <a href="<%= request.getContextPath() %>/bantuan/komuniti" class="group">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 h-full text-center transition-all duration-300 hover:shadow-xl hover:shadow-purple-100 hover:-translate-y-2 hover:border-[#6C5DD3] relative overflow-hidden">
                
                <div class="absolute inset-0 bg-gradient-to-br from-[#6C5DD3]/0 to-[#6C5DD3]/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>

                <div class="w-24 h-24 rounded-3xl bg-green-50 text-green-500 flex items-center justify-center mx-auto mb-6 text-4xl group-hover:bg-[#6C5DD3] group-hover:text-white transition-colors duration-300 shadow-sm">
                    <i class="fas fa-users"></i>
                </div>

                <h3 class="text-xl font-bold text-gray-800 mb-3 group-hover:text-[#6C5DD3] transition-colors">Bantuan Komuniti</h3>
                
                <p class="text-gray-500 text-sm mb-6 leading-relaxed">
                    Gotong-royong, sumbangan khairat kematian, bantuan bencana, dan aktiviti sukarelawan kampung.
                </p>

                <span class="inline-block px-6 py-2 rounded-full border border-gray-200 text-gray-600 font-bold text-xs uppercase tracking-wider group-hover:bg-[#6C5DD3] group-hover:text-white group-hover:border-[#6C5DD3] transition-all">
                    Pilih Komuniti
                </span>
            </div>
        </a>

        <a href="<%= request.getContextPath() %>/bantuan/rasmi" class="group">
            <div class="bg-white rounded-3xl p-8 shadow-sm border border-gray-100 h-full text-center transition-all duration-300 hover:shadow-xl hover:shadow-purple-100 hover:-translate-y-2 hover:border-[#6C5DD3] relative overflow-hidden">
                
                <div class="absolute inset-0 bg-gradient-to-br from-[#6C5DD3]/0 to-[#6C5DD3]/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>

                <div class="w-24 h-24 rounded-3xl bg-blue-50 text-blue-500 flex items-center justify-center mx-auto mb-6 text-4xl group-hover:bg-[#6C5DD3] group-hover:text-white transition-colors duration-300 shadow-sm">
                    <i class="fas fa-file-signature"></i>
                </div>

                <h3 class="text-xl font-bold text-gray-800 mb-3 group-hover:text-[#6C5DD3] transition-colors">Bantuan Rasmi</h3>
                
                <p class="text-gray-500 text-sm mb-6 leading-relaxed">
                    Permohonan bantuan JKM, surat sokongan penghulu, pengesahan dokumen, dan urusan kerajaan.
                </p>

                <span class="inline-block px-6 py-2 rounded-full border border-gray-200 text-gray-600 font-bold text-xs uppercase tracking-wider group-hover:bg-[#6C5DD3] group-hover:text-white group-hover:border-[#6C5DD3] transition-all">
                    Pilih Rasmi
                </span>
            </div>
        </a>

    </div>

    <div class="mt-12 text-center">
        <p class="text-sm text-gray-400">
            Ada masalah lain? <a href="#" class="text-[#6C5DD3] font-bold hover:underline">Hubungi Ketua Kampung</a> secara terus.
        </p>
    </div>

</div> 
<aside class="w-80 bg-white border-l border-gray-100 hidden xl:flex flex-col p-8 overflow-y-auto h-full">
    <div class="flex justify-between items-start mb-8">
        <h3 class="font-bold text-lg text-gray-800">Status Permohonan</h3>
    </div>

    <div class="text-center py-8">
        <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4 text-gray-400">
            <i class="fas fa-inbox text-xl"></i>
        </div>
        <p class="text-sm font-bold text-gray-800">Tiada Permohonan Aktif</p>
        <p class="text-xs text-gray-500 mt-1">Sejarah permohonan bantuan anda akan dipaparkan di sini.</p>
    </div>

    <div class="mt-auto bg-purple-50 rounded-2xl p-6 relative overflow-hidden">
        <div class="absolute -right-4 -top-4 w-16 h-16 bg-purple-200 rounded-full opacity-50"></div>
        <h4 class="font-bold text-[#6C5DD3] mb-2 relative z-10">Tahukah Anda?</h4>
        <p class="text-xs text-gray-600 leading-relaxed relative z-10">
            Permohonan bantuan JKM memerlukan pengesahan dari Penghulu Mukim sebelum dihantar ke pejabat daerah.
        </p>
    </div>
</aside>

<%@ include file="/views/common/footer.jsp" %>