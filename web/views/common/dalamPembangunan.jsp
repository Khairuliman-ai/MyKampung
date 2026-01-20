
<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<div class="flex-1 overflow-y-auto p-8 scroll-smooth h-full bg-[#F7F7F9] flex flex-col justify-center items-center text-center">

    <div class="bg-white p-10 rounded-3xl shadow-sm border border-gray-100 max-w-lg w-full relative overflow-hidden">
        
        <div class="absolute top-0 right-0 -mr-16 -mt-16 w-40 h-40 bg-purple-50 rounded-full blur-2xl"></div>
        <div class="absolute bottom-0 left-0 -ml-16 -mb-16 w-40 h-40 bg-blue-50 rounded-full blur-2xl"></div>

        <div class="relative z-10">
            <div class="w-24 h-24 bg-purple-50 rounded-full flex items-center justify-center mx-auto mb-6">
                <i class="fas fa-tools text-4xl text-[#6C5DD3]"></i>
            </div>

            <h2 class="text-2xl font-bold text-gray-800 mb-2">Sedang Dalam Pembangunan</h2>
            <p class="text-gray-500 mb-8 text-sm leading-relaxed">
                Halaman ini sedang disiapkan oleh pembangun sistem.<br>
                Sila kembali lagi nanti untuk fungsi penuh.
            </p>

            <a href="<%= request.getContextPath() %>/dashboard" class="inline-flex items-center justify-center px-6 py-3 bg-[#6C5DD3] hover:bg-[#5b4eb8] text-white font-bold rounded-xl transition shadow-md shadow-purple-200 gap-2">
                <i class="fas fa-arrow-left"></i> Kembali ke Utama
            </a>
        </div>
    </div>

</div>

<%@ include file="/views/common/footer.jsp" %>