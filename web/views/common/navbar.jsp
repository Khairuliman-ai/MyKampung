<%@ page import="model.Pengguna" %>
<%@ page import="model.Pengguna" %>
<%
    // 1. Guna nama 'userNav' untuk elak ralat 'Duplicate local variable user'
    // Guna 'currentUser' supaya sepadan dengan LoginServlet anda
    Pengguna userNav = (Pengguna) session.getAttribute("currentUser");

    if (userNav == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/auth.jsp");
        return;
    }
    
    // 2. Guna getNama_peranan() kerana getJawatan() tiada dalam model baru
    String role = userNav.getNama_peranan();
    String biro = userNav.getNama_jawatan(); // Diambil dari table 'jawatan_ajk'
    
    // 3. Normalize Path & Query String
    String currentPath = request.getRequestURI().toLowerCase();
    String contextPath = request.getContextPath();
    String query = (request.getQueryString() != null) ? request.getQueryString().toLowerCase() : "";

    String constructionPage = contextPath + "/views/common/dalamPembangunan.jsp";
    boolean isConstruction = currentPath.contains("dalampembangunan");

    // 4. Style CSS
    String activeClass = "bg-[#6C5DD3] text-white shadow-md shadow-purple-200 group";
    String inactiveClass = "text-gray-500 hover:bg-gray-50 hover:text-[#6C5DD3] group";
%>

<aside class="w-64 bg-white hidden md:flex flex-col border-r border-gray-100 flex-shrink-0 h-full justify-between">
    
    <div class="flex flex-col flex-1 overflow-hidden">
        <div class="p-8 flex items-center gap-3 flex-shrink-0">
            <div class="w-10 h-10 bg-brand-purple rounded-xl flex items-center justify-center text-white text-xl shadow-lg shadow-purple-200">
                <i class="fas fa-village"></i>
            </div>
            <div>
                <h1 class="font-bold text-lg tracking-tight text-gray-900 leading-tight">Kampung<br>Danan</h1>
            </div>
        </div>

        <nav class="flex-1 px-6 space-y-2 overflow-y-auto py-4 custom-scrollbar">
            
            <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-4 px-2">Menu Utama</p>

            <a href="<%= contextPath %>/DashboardServlet" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("dashboard") || currentPath.contains("dpenduduk") || currentPath.contains("dketua") || currentPath.contains("djkkk")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-th-large <%= (currentPath.contains("dashboard") || currentPath.contains("dpenduduk") || currentPath.contains("dketua") || currentPath.contains("dJKKK")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Papan Pemuka</span>
            </a>

            <% if ("Penduduk".equalsIgnoreCase(role)) { %>
                
                <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Profil Saya</span>
                </a>

                <a href="<%= contextPath %>/bantuan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("bantuan") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-hand-holding-heart <%= currentPath.contains("bantuan") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Mohon Bantuan</span>
                </a>

                <a href="<%= contextPath %>/fasiliti/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/fasiliti/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-building-circle-check <%= currentPath.contains("/fasiliti/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Fasiliti Kampung</span>
                </a>

                <a href="<%= contextPath %>/aduan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-comment-dots <%= currentPath.contains("/aduan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Aduan & Cadangan</span>
                </a>

                <a href="<%= contextPath %>/hebahan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Info & Hebahan</span>
                </a>

<% } else if ("Ketua Kampung".equalsIgnoreCase(role)) { %>

            <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Profil Saya</span>
                </a>

            <a href="<%= contextPath %>/ketua/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("/ketua/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-users <%= (currentPath.contains("/ketua/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Direktori Penduduk</span>
            </a>

            <a href="<%= contextPath %>/bantuan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= currentPath.contains("/bantuan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-clipboard-check <%= currentPath.contains("/bantuan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Sokongan Bantuan</span>
            </a>

            <a href="<%= contextPath %>/aduan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-exclamation-circle <%= currentPath.contains("/aduan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Aduan Komuniti</span>
            </a>

            <a href="<%= contextPath %>/hebahan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Urus Hebahan</span>
            </a>

            <a href="<%= constructionPage %>?menu=laporan" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=laporan")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-chart-pie <%= (isConstruction && query.contains("menu=laporan")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Laporan & Analitik</span>
            </a>

            <% } else if ("AJK Kampung".equalsIgnoreCase(role)) { %>

            <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Profil Saya</span>
                </a>
            
            <% if ("Setiausaha".equals(biro)) { %>
            <a href="<%= contextPath %>/penduduk/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("/penduduk/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-user-cog <%= (currentPath.contains("/penduduk/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Pendaftaran & Data</span>
            </a>
            <% } %>

            <% if ("Biro Kebajikan & Sosial".equals(biro)) { %>
            <a href="<%= contextPath %>/bantuan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= currentPath.contains("/bantuan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-tasks <%= currentPath.contains("/bantuan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Semakan Bantuan</span>
            </a>
            <% } %>

            <% if ("Biro Sukan & Riadah".equals(biro)) { %>
            <a href="<%= contextPath %>/fasiliti/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/fasiliti/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-calendar-check <%= currentPath.contains("/fasiliti/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Urus Fasiliti</span>
            </a>
            <% } %>

            <a href="<%= contextPath %>/aduan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-clipboard-list <%= currentPath.contains("/aduan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Aduan & Laporan</span>
            </a>

            <a href="<%= contextPath %>/hebahan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Hebahan Awam</span>
            </a>

            <% } %>
        </nav>
    </div>

    <div class="p-6 border-t border-gray-100 bg-white">
        <p class="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 px-2">Lain-lain</p>
        
        <a href="<%= constructionPage %>?menu=tetapan" 
           class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 mb-2
           <%= (isConstruction && query.contains("menu=tetapan")) ? activeClass : inactiveClass %>">
            <div class="w-6 text-center"><i class="fas fa-cog <%= (isConstruction && query.contains("menu=tetapan")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
            <span class="font-medium text-sm">Tetapan</span>
        </a>
        
        <button onclick="confirmLogout()" class="w-full flex items-center gap-3 px-4 py-3 text-red-400 hover:bg-red-50 hover:text-red-600 rounded-2xl transition group text-left">
            <div class="w-6 text-center"><i class="fas fa-sign-out-alt transition"></i></div>
            <span class="font-medium text-sm">Log Keluar</span>
        </button>
    </div>

</aside>

<main class="flex-1 flex overflow-hidden relative">
    <div class="absolute top-4 left-4 md:hidden z-50">
        <button class="p-2 bg-white rounded-lg shadow text-gray-600"><i class="fas fa-bars"></i></button>
    </div>

<div id="modalLogout" class="fixed inset-0 z-[999] hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeLogout()"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-sm">
            <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4 text-center">
                <div class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10 mx-auto mb-4">
                    <i class="fas fa-sign-out-alt text-red-600"></i>
                </div>
                <h3 class="text-lg font-bold text-gray-900 mb-2">Log Keluar?</h3>
                <p class="text-sm text-gray-500">Adakah anda pasti mahu log keluar dari sistem?</p>
            </div>
            <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2 justify-center pb-6">
                <a href="<%= contextPath %>/logout" class="inline-flex w-full justify-center rounded-xl bg-red-600 px-4 py-2.5 text-sm font-bold text-white shadow-sm hover:bg-red-500 sm:w-auto">Ya, Keluar</a>
                <button type="button" class="mt-3 inline-flex w-full justify-center rounded-xl bg-white px-4 py-2.5 text-sm font-bold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto" onclick="closeLogout()">Batal</button>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmLogout() {
        document.getElementById('modalLogout').classList.remove('hidden');
    }
    function closeLogout() {
        document.getElementById('modalLogout').classList.add('hidden');
    }
</script>