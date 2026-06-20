<!-- Modal Detail Hebahan (Shared Component) -->
<div id="modalDetailPreview" class="fixed inset-0 z-[60] hidden overflow-y-auto" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-900 bg-opacity-40 transition-opacity backdrop-blur-sm" onclick="closeDetailModal()"></div>
    <div class="flex min-h-screen items-center justify-center p-4">
        <div class="relative w-full max-w-4xl bg-white rounded-[3rem] shadow-2xl overflow-hidden transform transition-all duration-300">
            <!-- Header Image -->
            <div id="modalImageContainer" class="h-64 md:h-96 bg-gray-100 overflow-hidden relative text-left">
                <img id="modalImage" src="" class="w-full h-full object-cover">
                <div id="modalGradient" class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                <button onclick="closeDetailModal()" class="absolute top-6 right-6 w-12 h-12 bg-white/20 hover:bg-white/40 backdrop-blur-md text-white rounded-2xl flex items-center justify-center transition-all">
                    <i class="fas fa-times"></i>
                </button>
                <div class="absolute bottom-8 left-8 right-8 text-white">
                    <div id="modalBadge" class="inline-block px-4 py-1.5 rounded-full text-[10px] font-bold uppercase mb-4 backdrop-blur-md border border-white/20"></div>
                    <h2 id="modalTitlePreview" class="text-2xl md:text-4xl font-bold"></h2>
                </div>
            </div>

            <!-- Content Body -->
            <div class="p-8 md:p-12 text-left">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-12">
                    <div class="md:col-span-2">
                        <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Kandungan Hebahan</h3>
                        <div id="modalKandungan" class="text-gray-600 leading-relaxed space-y-4 whitespace-pre-wrap"></div>
                    </div>
                    <div class="space-y-8">
                        <div>
                            <h3 class="text-sm font-bold text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-100 pb-2">Maklumat Acara</h3>
                            <div class="space-y-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-purple-50 text-brand-purple flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Lokasi</p>
                                        <p id="modalLokasi" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-4">
                                    <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center flex-shrink-0">
                                        <i class="fas fa-clock"></i>
                                    </div>
                                    <div>
                                        <p class="text-[10px] font-bold text-gray-400 uppercase">Tarikh Acara</p>
                                        <p id="modalTarikhAcara" class="text-sm font-bold text-gray-700"></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="p-6 bg-gray-50 rounded-[2rem] border border-gray-100 text-center">
                            <p class="text-[10px] font-bold text-gray-400 uppercase mb-2">Hebahan Diterbitkan Pada</p>
                            <p id="modalTarikhHebahan" class="text-xs font-bold text-gray-600"></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
