<%@ page import="model.Pengguna" %>
<%@ page import="java.util.List" %>
<%
    // 1. Semakan Session - Guna nama attribute yang sama dengan LoginServlet
    if (session == null || session.getAttribute("userSession") == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
    
    // Casting kepada model Pengguna
    model.Pengguna userSession = (model.Pengguna) session.getAttribute("userSession");
    
    // Ambil senarai peranan dari session (Sangat penting mengikut ERD Baru Many-to-Many)
    List<String> userRoles = (List<String>) session.getAttribute("userRoles");
    
    // Helper boolean untuk semak role dengan tepat
    boolean isPenduduk = userRoles != null && userRoles.contains("Penduduk");
    boolean isKetua = userRoles != null && userRoles.contains("Ketua Kampung");
    boolean isJKKK = userRoles != null && userRoles.contains("JKKK");
    
    // 2. Normalize Path untuk Highlight Menu Aktif
    String currentPath = request.getRequestURI();
    String contextPath = request.getContextPath();
    String query = request.getQueryString() != null ? request.getQueryString().toLowerCase() : "";
    String constructionPage = contextPath + "/views/common/dalamPembangunan.jsp";
    
    // 3. Style CSS (Kekal seperti asal)
    String activeClass = "bg-brand-purple text-white shadow-md shadow-purple-200 group";
    String inactiveClass = "text-gray-500 hover:bg-gray-50 hover:text-brand-purple group";
    
    boolean isConstruction = currentPath.contains("dalamPembangunan");
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

            <a href="<%= contextPath %>/dashboard" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("dashboard") || currentPath.contains("dpenduduk") || currentPath.contains("dketua") || currentPath.contains("djkkk")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-th-large <%= (currentPath.contains("dashboard") || currentPath.contains("dpenduduk") || currentPath.contains("dketua") || currentPath.contains("djkkk")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                </div>
                <span class="font-medium text-sm">Papan Pemuka</span>
            </a>

            <%-- LOGIK PENDUDUK --%>
            <% if (isPenduduk) { %>
                
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

                <a href="<%= constructionPage %>?menu=fasiliti" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=fasiliti")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-building <%= (isConstruction && query.contains("menu=fasiliti")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Fasiliti Kampung</span>
                </a>

                <a href="<%= constructionPage %>?menu=aduan" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=aduan")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-comment-dots <%= (isConstruction && query.contains("menu=aduan")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Aduan & Cadangan</span>
                </a>

                <a href="<%= constructionPage %>?menu=info" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=info")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-bullhorn <%= (isConstruction && query.contains("menu=info")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i></div>
                    <span class="font-medium text-sm">Info & Hebahan</span>
                </a>

            <%-- LOGIK KETUA KAMPUNG --%>
            <% } if (isKetua) { %>

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

                <a href="<%= constructionPage %>?menu=aduan_komuniti" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=aduan_komuniti")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center">
                        <i class="fas fa-exclamation-circle <%= (isConstruction && query.contains("menu=aduan_komuniti")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                    </div>
                    <span class="font-medium text-sm">Aduan Komuniti</span>
                </a>

                <a href="<%= constructionPage %>?menu=hebahan_urus" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=hebahan_urus")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center">
                        <i class="fas fa-bullhorn <%= (isConstruction && query.contains("menu=hebahan_urus")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                    </div>
                    <span class="font-medium text-sm">Urus Hebahan</span>
                </a>

            <%-- LOGIK JKKK --%>
            <% } if (isJKKK) { %>

                <a href="<%= contextPath %>/penduduk/urus" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
                   <%= (currentPath.contains("/penduduk/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center">
                        <i class="fas fa-user-cog <%= (currentPath.contains("/penduduk/") || (currentPath.contains("urus") && !currentPath.contains("bantuan"))) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                    </div>
                    <span class="font-medium text-sm">Pendaftaran & Data</span>
                </a>

                <a href="<%= contextPath %>/bantuan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
                   <%= currentPath.contains("/bantuan/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center">
                        <i class="fas fa-tasks <%= currentPath.contains("/bantuan/") ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                    </div>
                    <span class="font-medium text-sm">Semakan Bantuan</span>
                </a>

                <a href="<%= constructionPage %>?menu=tempahan" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= (isConstruction && query.contains("menu=tempahan")) ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center">
                        <i class="fas fa-calendar-check <%= (isConstruction && query.contains("menu=tempahan")) ? "text-white" : "text-gray-400 group-hover:text-brand-purple" %> transition"></i>
                    </div>
                    <span class="font-medium text-sm">Tempahan Fasiliti</span>
                </a>

            <% } %>
        </nav>
    </div>

    <%-- Footer Logout (Styling Kekal) --%>
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