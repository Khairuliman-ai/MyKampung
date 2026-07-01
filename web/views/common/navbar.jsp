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
    String forwardedUri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    String currentPath = (forwardedUri != null ? forwardedUri : request.getRequestURI()).toLowerCase();
    String contextPath = request.getContextPath();
    String query = (request.getQueryString() != null) ? request.getQueryString().toLowerCase() : "";
    String forwardedQuery = (String) request.getAttribute("javax.servlet.forward.query_string");
    if (forwardedQuery != null && !forwardedQuery.isEmpty()) {
        query = forwardedQuery.toLowerCase();
    }

    String constructionPage = contextPath + "/views/common/dalamPembangunan.jsp";
    boolean isConstruction = currentPath.contains("dalampembangunan");

    // 4. Style CSS (Menggunakan dynamic brand colors dari header.jsp)
    String activeClass = "bg-gradient-to-r from-[var(--brand-color)] to-[var(--brand-secondary)] text-white shadow-lg shadow-[var(--brand-shadow)] font-bold group transform hover:-translate-y-0.5";
    String inactiveClass = "text-gray-500 hover:bg-slate-50/50 hover:text-[var(--brand-color)] font-medium group transition-all duration-200";
%>

<style>
    /* Collapsible Sidebar Styles & Transitions */
    #mainSidebar {
        transition: width 0.35s cubic-bezier(0.4, 0, 0.2, 1), transform 0.35s cubic-bezier(0.4, 0, 0.2, 1), background-color 0.35s ease, backdrop-filter 0.35s ease !important;
    }
    
    #mainSidebar.collapsed {
        width: 5rem !important; /* 80px */
    }
    
    /* Text fade-out transitions inside sidebar */
    #mainSidebar .brand-text,
    #mainSidebar .nav-label,
    #mainSidebar .menu-section-header,
    #mainSidebar .other-section-header,
    #mainSidebar button span:not(.nav-label) {
        transition: opacity 0.15s ease, visibility 0.15s ease;
        opacity: 1;
        visibility: visible;
    }
    
    #mainSidebar.collapsed .brand-text,
    #mainSidebar.collapsed .nav-label,
    #mainSidebar.collapsed .menu-section-header,
    #mainSidebar.collapsed .other-section-header,
    #mainSidebar.collapsed button span {
        opacity: 0 !important;
        visibility: hidden !important;
        width: 0 !important;
        height: 0 !important;
        overflow: hidden !important;
        margin: 0 !important;
        padding: 0 !important;
        display: none !important;
    }
    
    /* Adjust padding when collapsed */
    #mainSidebar.collapsed .brand-padding {
        padding: 1.25rem !important;
    }
    #mainSidebar.collapsed .nav-padding {
        padding-left: 0.75rem !important;
        padding-right: 0.75rem !important;
    }
    #mainSidebar.collapsed .footer-padding {
        padding: 1.25rem 0.75rem !important;
    }
    
    /* Center nav items and buttons when collapsed */
    #mainSidebar.collapsed nav a {
        justify-content: center !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
        border-radius: 1.25rem !important;
        margin-left: auto !important;
        margin-right: auto !important;
        width: 3.25rem !important;
        height: 3.25rem !important;
    }
    
    #mainSidebar.collapsed nav a div.w-6 {
        width: auto !important;
        text-align: center !important;
    }
    
    #mainSidebar.collapsed nav a i {
        font-size: 1.25rem !important;
    }
    
    #mainSidebar.collapsed .pt-4.border-t {
        border-top: none !important;
        margin: 0 !important;
        padding-top: 0 !important;
    }
    
    #mainSidebar.collapsed button {
        justify-content: center !important;
        padding-left: 0 !important;
        padding-right: 0 !important;
        width: 3.25rem !important;
        height: 3.25rem !important;
        margin-left: auto !important;
        margin-right: auto !important;
    }

    #mainSidebar.collapsed button div.w-6 {
        width: auto !important;
    }
    
    /* Notification dropdown animation */
    #notifDropdown {
        animation: slideDown 0.2s ease;
    }
    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-8px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    /* Bell ring animation when new notification */
    @keyframes bellRing {
        0%, 100% { transform: rotate(0); }
        15% { transform: rotate(14deg); }
        30% { transform: rotate(-14deg); }
        45% { transform: rotate(10deg); }
        60% { transform: rotate(-8deg); }
        75% { transform: rotate(4deg); }
    }
    .bell-ringing {
        animation: bellRing 0.8s ease;
    }
</style>

<aside id="mainSidebar" class="w-64 bg-white/95 backdrop-blur-md fixed inset-y-0 left-0 z-[60] flex flex-col border-r border-slate-100 flex-shrink-0 h-full justify-between transition-all duration-300 transform -translate-x-full md:translate-x-0 md:relative md:inset-auto md:z-0 shadow-sm">
    <script>
        // Apply collapsed state immediately before rendering to prevent visual flickering
        if (localStorage.getItem('sidebarCollapsed') === 'true' && window.innerWidth >= 768) {
            document.getElementById('mainSidebar').classList.add('collapsed');
        }
    </script>

    <!-- Floating Collapse Toggle Button (Desktop Only) -->
    <button id="sidebarCollapseBtn" onclick="toggleSidebarCollapse()" class="hidden md:flex absolute top-8 -right-3 w-6.5 h-6.5 bg-white border border-slate-200 hover:border-slate-300 text-slate-400 hover:text-slate-600 rounded-full items-center justify-center shadow-sm z-50 transition-all duration-300 focus:outline-none cursor-pointer p-1">
        <i class="fas fa-chevron-left text-[9px] transition-transform duration-300" id="collapseIcon"></i>
    </button>

    <!-- Mobile Close Button -->
    <div class="p-4 md:hidden flex justify-end shrink-0">
        <button onclick="toggleSidebar()" class="text-slate-400 hover:text-slate-600"><i class="fas fa-times text-xl"></i></button>
    </div>
    
    <div class="flex flex-col flex-1 overflow-hidden">
        <!-- Logo Section -->
        <div class="brand-padding p-8 flex items-center gap-3.5 flex-shrink-0 relative">
            <div class="w-10 h-10 bg-gradient-to-br from-[var(--brand-color)] to-[var(--brand-secondary)] rounded-2xl flex items-center justify-center text-white text-lg shadow-md shadow-[var(--brand-shadow)] transform hover:scale-105 transition-transform duration-300">
                <i class="fas fa-house-chimney-window"></i>
            </div>
            <div class="brand-text">
                <h1 class="font-extrabold text-sm tracking-widest text-slate-800 uppercase leading-none">Kampung Danan</h1>
                <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest block mt-1.5">Portal Komuniti</span>
            </div>
        </div>

        <!-- Navigation Menu -->
        <nav class="nav-padding flex-1 px-6 space-y-2 overflow-y-auto py-4 custom-scrollbar">
            
            <p class="menu-section-header text-[10px] font-black text-slate-400 uppercase tracking-[0.15em] mb-4 px-3 opacity-80">Menu Utama</p>

            <a href="<%= contextPath %>/DashboardServlet" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("dashboard")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-th-large <%= (currentPath.contains("dashboard")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Papan Pemuka</span>
            </a>

            <% if ("Penduduk".equalsIgnoreCase(role)) { %>
                
                <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Profil Saya</span>
                </a>

                <a href="<%= contextPath %>/bantuan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("bantuan") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-hand-holding-heart <%= currentPath.contains("bantuan") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Mohon Bantuan</span>
                </a>

                <a href="<%= contextPath %>/fasiliti/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/fasiliti/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-building-circle-check <%= currentPath.contains("/fasiliti/") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Fasiliti Kampung</span>
                </a>

                <a href="<%= contextPath %>/aduan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-comment-dots <%= currentPath.contains("/aduan/") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Aduan & Cadangan</span>
                </a>

                <a href="<%= contextPath %>/hebahan/list" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Info & Hebahan</span>
                </a>

<% } else if ("Ketua Kampung".equalsIgnoreCase(role)) { %>

            <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Profil Saya</span>
                </a>

            <a href="<%= contextPath %>/ketua/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("/ketua/urus")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-users <%= (currentPath.contains("/ketua/urus")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Senarai Penduduk</span>
            </a>

            <a href="<%= contextPath %>/bantuan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= currentPath.contains("/bantuan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-clipboard-check <%= currentPath.contains("/bantuan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Sokongan Bantuan</span>
            </a>

            <a href="<%= contextPath %>/aduan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-exclamation-circle <%= currentPath.contains("/aduan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Aduan Komuniti</span>
            </a>

            <a href="<%= contextPath %>/hebahan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Urus Hebahan</span>
            </a>

            <a href="<%= contextPath %>/laporan/view" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/laporan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-chart-pie <%= currentPath.contains("/laporan/") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Laporan & Analitik</span>
            </a>

            <div class="pt-4 border-t border-slate-100 my-2">
                <p class="menu-section-header text-[10px] font-black text-slate-400 uppercase tracking-[0.15em] mb-2 px-3 opacity-80">Perkhidmatan Penduduk</p>
            </div>

            <a href="<%= contextPath %>/bantuan/mohon" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/bantuan/mohon") || currentPath.contains("/bantuan/rasmi") || currentPath.contains("/bantuan/komuniti") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-hand-holding-heart <%= currentPath.contains("/bantuan/mohon") || currentPath.contains("/bantuan/rasmi") || currentPath.contains("/bantuan/komuniti") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Mohon Bantuan</span>
            </a>

            <a href="<%= contextPath %>/fasiliti/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/fasiliti/list") || (currentPath.contains("/fasiliti/") && !currentPath.contains("/fasiliti/urus")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-building-circle-check <%= currentPath.contains("/fasiliti/list") || (currentPath.contains("/fasiliti/") && !currentPath.contains("/fasiliti/urus")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Fasiliti Kampung</span>
            </a>

            <a href="<%= contextPath %>/aduan/penduduk" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/penduduk") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-comment-dots <%= currentPath.contains("/aduan/penduduk") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Aduan & Cadangan</span>
            </a>

            <a href="<%= contextPath %>/hebahan/penduduk" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/penduduk") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/penduduk") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Info & Hebahan</span>
            </a>

            <% } else if ("AJK Kampung".equalsIgnoreCase(role)) { %>

            <a href="<%= contextPath %>/profil/view" 
                   class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("profil") ? activeClass : inactiveClass %>">
                    <div class="w-6 text-center"><i class="fas fa-user <%= currentPath.contains("profil") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
                    <span class="nav-label font-medium text-sm">Profil Saya</span>
                </a>
            
            <% if ("Setiausaha".equals(biro)) { %>
            <a href="<%= contextPath %>/penduduk/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= (currentPath.contains("/penduduk/urus")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-user-cog <%= (currentPath.contains("/penduduk/urus")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Pendaftaran & Data</span>
            </a>
            <% } %>

            <% if ("Biro Kebajikan & Sosial".equals(biro)) { %>
            <a href="<%= contextPath %>/bantuan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 
               <%= currentPath.contains("/bantuan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-tasks <%= currentPath.contains("/bantuan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Semakan Bantuan</span>
            </a>
            <% } %>

            <% if ("Biro Sukan & Riadah".equals(biro)) { %>
            <a href="<%= contextPath %>/fasiliti/urus" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/fasiliti/urus") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-calendar-check <%= currentPath.contains("/fasiliti/urus") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Urus Fasiliti</span>
            </a>
            <% } %>

            <% if (!"Setiausaha".equals(biro) && !"Biro Sukan & Riadah".equals(biro) && !"Biro Kebajikan & Sosial".equals(biro) && !"Biro Hebahan".equals(biro)) { %>
            <a href="<%= contextPath %>/aduan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-clipboard-list <%= currentPath.contains("/aduan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Aduan & Laporan</span>
            </a>
            <% } %>

            <% if (!"Setiausaha".equals(biro) && !"Biro Sukan & Riadah".equals(biro) && !"Biro Keselamatan".equals(biro) && !"Biro Kebajikan & Sosial".equals(biro)) { %>
            <a href="<%= contextPath %>/hebahan/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/list") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/list") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Hebahan Awam</span>
            </a>
            <% } %>

            <a href="<%= contextPath %>/laporan/view" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/laporan/") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-chart-line <%= currentPath.contains("/laporan/") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Laporan Biro</span>
            </a>

            <div class="pt-4 border-t border-slate-100 my-2">
                <p class="menu-section-header text-[10px] font-black text-slate-400 uppercase tracking-[0.15em] mb-2 px-3 opacity-80">Perkhidmatan Penduduk</p>
            </div>

            <a href="<%= contextPath %>/bantuan/mohon" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/bantuan/mohon") || currentPath.contains("/bantuan/rasmi") || currentPath.contains("/bantuan/komuniti") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-hand-holding-heart <%= currentPath.contains("/bantuan/mohon") || currentPath.contains("/bantuan/rasmi") || currentPath.contains("/bantuan/komuniti") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Mohon Bantuan</span>
            </a>

            <a href="<%= contextPath %>/fasiliti/list" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 <%= currentPath.contains("/fasiliti/list") || (currentPath.contains("/fasiliti/") && !currentPath.contains("/fasiliti/urus")) ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-building-circle-check <%= currentPath.contains("/fasiliti/list") || (currentPath.contains("/fasiliti/") && !currentPath.contains("/fasiliti/urus")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Fasiliti Kampung</span>
            </a>

            <a href="<%= contextPath %>/aduan/penduduk" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/aduan/penduduk") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-comment-dots <%= currentPath.contains("/aduan/penduduk") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Aduan & Cadangan</span>
            </a>

            <a href="<%= contextPath %>/hebahan/penduduk" 
               class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 group <%= currentPath.contains("/hebahan/penduduk") ? activeClass : inactiveClass %>">
                <div class="w-6 text-center">
                    <i class="fas fa-bullhorn <%= currentPath.contains("/hebahan/penduduk") ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i>
                </div>
                <span class="nav-label font-medium text-sm">Info & Hebahan</span>
            </a>

            <% } %>
        </nav>
    </div>

    <!-- Sidebar Footer -->
    <div class="footer-padding p-6 border-t border-slate-100/50 bg-white/50 relative shrink-0">
        <p class="other-section-header text-[10px] font-black text-slate-400 uppercase tracking-[0.15em] mb-3 px-3 opacity-80">Lain-lain</p>
        
        <a href="<%= constructionPage %>?menu=tetapan" 
           class="flex items-center gap-3 px-4 py-3 rounded-2xl transition-all duration-200 mb-2
           <%= (isConstruction && query.contains("menu=tetapan")) ? activeClass : inactiveClass %>">
            <div class="w-6 text-center"><i class="fas fa-cog <%= (isConstruction && query.contains("menu=tetapan")) ? "text-white" : "text-gray-400 group-hover:text-[var(--brand-color)]" %> transition"></i></div>
            <span class="nav-label font-medium text-sm">Tetapan</span>
        </a>
        
        <button onclick="confirmLogout()" class="w-full flex items-center gap-3 px-4 py-3 text-rose-500 hover:bg-rose-50 hover:text-rose-700 rounded-2xl transition group text-left font-bold focus:outline-none cursor-pointer">
            <div class="w-6 text-center"><i class="fas fa-sign-out-alt transition group-hover:translate-x-0.5"></i></div>
            <span class="nav-label font-bold text-sm">Log Keluar</span>
        </button>
    </div>

</aside>

<main class="flex-1 flex flex-col lg:flex-row overflow-y-auto lg:overflow-hidden relative bg-[#F7F7F9]">
    <!-- Mobile Sidebar Backdrop -->
    <div id="sidebarOverlay" class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[55] hidden md:hidden" onclick="toggleSidebar()"></div>

    <div class="absolute top-4 left-4 md:hidden z-50">
        <button onclick="toggleSidebar()" class="p-2 bg-white rounded-lg shadow text-gray-600 focus:outline-none"><i class="fas fa-bars"></i></button>
    </div>

    <!-- Notification Bell (All Roles) -->
    <div class="absolute top-4 right-4 z-50">
        <button id="notifBellBtn" onclick="toggleNotifDropdown()" 
                class="relative p-2.5 bg-white rounded-xl shadow-md hover:shadow-lg 
                       text-gray-500 hover:text-[var(--brand-color)] 
                       transition-all duration-300 focus:outline-none cursor-pointer">
            <i class="fas fa-bell text-lg" id="bellIcon"></i>
            <span id="notifBadge" 
                  class="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] 
                         font-bold rounded-full min-w-[18px] h-[18px] flex items-center 
                         justify-center px-1 hidden">
                0
            </span>
        </button>

        <!-- Dropdown Panel -->
        <div id="notifDropdown" 
             class="hidden absolute right-0 top-14 w-[380px] max-h-[480px] 
                    bg-white rounded-2xl shadow-2xl border border-slate-100 
                    overflow-hidden z-[999]">
            
            <!-- Header -->
            <div class="flex items-center justify-between px-5 py-4 
                        border-b border-slate-100 bg-gradient-to-r 
                        from-[var(--brand-color)] to-[var(--brand-secondary)]">
                <h3 class="font-bold text-white text-sm">
                    <i class="fas fa-bell mr-2"></i>Pemberitahuan
                </h3>
                <button onclick="tandaSemuaBaca()" 
                        class="text-xs text-white/80 hover:text-white 
                               font-medium cursor-pointer">
                    Tanda semua dibaca
                </button>
            </div>

            <!-- Notification List -->
            <div id="notifList" class="overflow-y-auto max-h-[380px] divide-y divide-slate-50">
                <div class="p-8 text-center text-sm text-gray-400">
                    <i class="fas fa-bell-slash text-2xl mb-2 block"></i>
                    Tiada Pemberitahuan
                </div>
            </div>
        </div>
    </div>

<!-- Logout Modal -->
<div id="modalLogout" class="fixed inset-0 z-[999] hidden" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity backdrop-blur-sm" onclick="closeLogout()"></div>
    <div class="flex min-h-full items-center justify-center p-4 text-center sm:p-0">
        <div class="relative transform overflow-hidden rounded-3xl bg-white text-left shadow-xl transition-all w-full sm:my-8 sm:max-w-sm">
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

    // Sidebar Mobile Toggle
    function toggleSidebar() {
        const sidebar = document.getElementById('mainSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        
        if (sidebar.classList.contains('-translate-x-full')) {
            sidebar.classList.remove('-translate-x-full');
            overlay.classList.remove('hidden');
        } else {
            sidebar.classList.add('-translate-x-full');
            overlay.classList.add('hidden');
        }
    }

    // Sidebar Desktop Collapsible Toggle
    function toggleSidebarCollapse() {
        const sidebar = document.getElementById('mainSidebar');
        const icon = document.getElementById('collapseIcon');
        const isCollapsed = sidebar.classList.toggle('collapsed');
        
        // Save choice in localStorage
        localStorage.setItem('sidebarCollapsed', isCollapsed);
        
        // Rotate Chevron Icon
        if (isCollapsed) {
            icon.style.transform = 'rotate(180deg)';
        } else {
            icon.style.transform = 'rotate(0deg)';
        }
    }

    // Sync icon rotation on load
    document.addEventListener("DOMContentLoaded", function() {
        const sidebar = document.getElementById('mainSidebar');
        const icon = document.getElementById('collapseIcon');
        if (sidebar && sidebar.classList.contains('collapsed') && icon) {
            icon.style.transform = 'rotate(180deg)';
        }
    });

    // === NOTIFICATION BELL FUNCTIONS ===
    const ctxPath = '<%= contextPath %>';
    let lastNotifCount = 0;
    let notifPollingInterval = null;

    function toggleNotifDropdown() {
        const dd = document.getElementById('notifDropdown');
        dd.classList.toggle('hidden');
        if (!dd.classList.contains('hidden')) {
            loadNotifikasi();
        }
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        const bell = document.getElementById('notifBellBtn');
        const dd = document.getElementById('notifDropdown');
        if (bell && dd && !bell.contains(e.target) && !dd.contains(e.target)) {
            dd.classList.add('hidden');
        }
    });

    // ====== AUTO-POLLING: Load count setiap 30 saat ======
    function loadNotifCount() {
        fetch(ctxPath + '/notifikasi/count')
            .then(r => r.json())
            .then(data => {
                const badge = document.getElementById('notifBadge');
                const bellIcon = document.getElementById('bellIcon');
                if (data.count > 0) {
                    badge.textContent = data.count > 99 ? '99+' : data.count;
                    badge.classList.remove('hidden');
                    // Animate bell if count increased
                    if (data.count > lastNotifCount && lastNotifCount >= 0) {
                        bellIcon.classList.add('bell-ringing');
                        setTimeout(() => bellIcon.classList.remove('bell-ringing'), 1000);
                    }
                } else {
                    badge.classList.add('hidden');
                }
                lastNotifCount = data.count;
            }).catch(err => console.error('Notif count error:', err));
    }

    function startNotifPolling() {
        loadNotifCount(); // Initial load
        notifPollingInterval = setInterval(loadNotifCount, 30000); // Every 30s
    }

    // Stop polling when tab is inactive (save resources)
    document.addEventListener('visibilitychange', function() {
        if (document.hidden) {
            if (notifPollingInterval) clearInterval(notifPollingInterval);
        } else {
            startNotifPolling();
        }
    });

    // Load notification list (for dropdown)
    function loadNotifikasi() {
        fetch(ctxPath + '/notifikasi/list')
            .then(r => r.json())
            .then(list => {
                const container = document.getElementById('notifList');
                if (list.length === 0) {
                    container.innerHTML = 
                        '<div class="p-8 text-center text-sm text-gray-400">' +
                        '<i class="fas fa-bell-slash text-2xl mb-2 block"></i>' +
                        'Tiada notifikasi</div>';
                    return;
                }
                container.innerHTML = list.map(function(n) {
                    return '<a href="' + (n.pautan ? ctxPath + n.pautan : '#') + '" ' +
                       'onclick="tandaBaca(' + n.id + ')" ' +
                       'class="flex gap-3 px-5 py-3.5 hover:bg-slate-50 transition ' +
                       'cursor-pointer ' + (!n.sudahBaca ? 'bg-blue-50/50' : '') + '">' +
                       '<div class="w-9 h-9 rounded-xl ' + getJenisBg(n.jenis) + ' ' +
                       'flex items-center justify-center flex-shrink-0 mt-0.5">' +
                       '<i class="' + getJenisIcon(n.jenis) + ' text-sm"></i></div>' +
                       '<div class="flex-1 min-w-0">' +
                       '<p class="text-sm font-semibold text-slate-800 truncate">' +
                       escapeHtml(n.tajuk) + '</p>' +
                       '<p class="text-xs text-slate-500 mt-0.5 line-clamp-2">' +
                       escapeHtml(n.mesej) + '</p>' +
                       '<p class="text-[10px] text-slate-400 mt-1">' +
                       formatTimeAgo(n.dibuat) + '</p></div>' +
                       (!n.sudahBaca ? '<div class="w-2 h-2 bg-blue-500 rounded-full mt-2 flex-shrink-0"></div>' : '') +
                       '</a>';
                }).join('');
            }).catch(err => console.error('Notif list error:', err));
    }

    function tandaBaca(id) {
        fetch(ctxPath + '/notifikasi/baca', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + id
        }).then(() => loadNotifCount());
    }

    function tandaSemuaBaca() {
        fetch(ctxPath + '/notifikasi/bacaSemua', { method: 'POST' })
            .then(() => { loadNotifCount(); loadNotifikasi(); });
    }

    // Helper functions
    function getJenisIcon(jenis) {
        var icons = {
            'ADUAN': 'fas fa-comment-dots', 'BANTUAN': 'fas fa-hand-holding-heart',
            'TEMPAHAN': 'fas fa-calendar-check', 'HEBAHAN': 'fas fa-bullhorn',
            'SISTEM': 'fas fa-cog'
        };
        return icons[jenis] || 'fas fa-bell';
    }

    function getJenisBg(jenis) {
        var bgs = {
            'ADUAN': 'bg-orange-100 text-orange-600', 'BANTUAN': 'bg-emerald-100 text-emerald-600',
            'TEMPAHAN': 'bg-blue-100 text-blue-600', 'HEBAHAN': 'bg-purple-100 text-purple-600',
            'SISTEM': 'bg-slate-100 text-slate-600'
        };
        return bgs[jenis] || 'bg-gray-100 text-gray-600';
    }

    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;')
                  .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function formatTimeAgo(dateStr) {
        var now = new Date();
        var date = new Date(dateStr);
        var diff = Math.floor((now - date) / 1000);
        if (diff < 60) return 'Baru sahaja';
        if (diff < 3600) return Math.floor(diff/60) + ' minit lalu';
        if (diff < 86400) return Math.floor(diff/3600) + ' jam lalu';
        if (diff < 604800) return Math.floor(diff/86400) + ' hari lalu';
        return date.toLocaleDateString('ms-MY');
    }

    // Auto-start polling on page load
    document.addEventListener('DOMContentLoaded', startNotifPolling);
</script>