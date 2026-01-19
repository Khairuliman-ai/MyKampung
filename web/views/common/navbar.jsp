<%@ page import="model.Pengguna" %>
<%
    // Semakan session standard
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath());
        return;
    }
    
    Pengguna user = (Pengguna) session.getAttribute("user");
    String role = user.getJawatan(); // Penduduk, Ketua Kampung, JKKK
%>

<style>
    /* CSS Tambahan untuk Sidebar Collapsible */
    .sidebar {
        width: 250px;
        transition: all 0.3s ease;
        overflow: hidden;
        white-space: nowrap; /* Elak teks pecah baris bila sidebar kecil */
    }

    /* Keadaan bila sidebar disembunyikan (collapsed) */
    .sidebar.collapsed {
        width: 80px; /* Lebar cukup untuk ikon sahaja */
    }

    /* Sembunyikan teks tajuk brand bila collapsed */
    .sidebar.collapsed .brand-text {
        display: none;
    }
    
    /* Pusatkan logo bila collapsed */
    .sidebar.collapsed .sidebar-brand {
        justify-content: center;
        padding: 1rem 0;
    }

    /* Sembunyikan teks menu, tapi kekalkan ikon */
    .sidebar.collapsed .nav-link span {
        display: none;
    }
    
    .sidebar.collapsed .nav-link {
        text-align: center;
        padding: 15px 0; /* Padding lebih besar untuk center icon */
    }
    
    .sidebar.collapsed .nav-link i {
        margin-right: 0; /* Buang margin kanan ikon */
        font-size: 1.5rem; /* Besarkan sikit ikon */
    }

    /* Laraskan Main Content supaya ikut sidebar */
    .main-content {
        margin-left: 250px;
        transition: all 0.3s ease;
    }

    .main-content.expanded {
        margin-left: 80px; /* Ikut lebar sidebar.collapsed */
    }
    
    /* Toggle Button Style */
    #sidebarToggle {
        cursor: pointer;
        padding: 5px;
        margin-right: 15px;
        color: #1f2937;
    }
</style>

<div class="sidebar" id="sidebar">
    <div class="sidebar-brand d-flex align-items-center px-4 py-3">
        <div class="brand-logo me-2"><i class="bi bi-houses-fill fs-3"></i></div>
        <div class="brand-text">
            <h6 class="mb-0 fw-bold">Kampung Danan</h6>
            <small class="text-muted" style="font-size: 11px;">Portal Pengurusan</small>
        </div>
    </div>

    <nav class="nav flex-column mt-2">
        
        <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">
            <i class="bi bi-grid me-2"></i> <span>Papan Pemuka</span>
        </a>

        <% if ("Penduduk".equalsIgnoreCase(role)) { %>
            
            <a class="nav-link" href="<%= request.getContextPath() %>/views/profil/userProfile.jsp">
                <i class="bi bi-person me-2"></i> <span>Profil Saya</span>
            </a>
            <a class="nav-link" href="<%= request.getContextPath() %>/bantuan/list">
                <i class="bi bi-hand-index-thumb me-2"></i> <span>Mohon Bantuan</span>
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-exclamation-circle me-2"></i> <span>Buat Aduan</span>
            </a>

        <% } else if ("Ketua Kampung".equalsIgnoreCase(role)) { %>

            <a class="nav-link" href="#">
                <i class="bi bi-people-fill me-2"></i> <span>Urus Penduduk</span>
            </a>
            <a class="nav-link" href="<%= request.getContextPath() %>/bantuan/list">
                <i class="bi bi-check-circle me-2"></i> <span>Sokongan Bantuan</span>
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-building me-2"></i> <span>Urus Kemudahan</span>
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-megaphone-fill me-2"></i> <span>Urus Hebahan</span>
            </a>

        <% } else if ("JKKK".equalsIgnoreCase(role)) { %>

            <a class="nav-link" href="#">
                <i class="bi bi-people me-2"></i> <span>Senarai Penduduk</span>
            </a>
        
            <a href="<%= request.getContextPath() %>/bantuan/list" class="nav-link">
                <i class="bi bi-briefcase-fill me-2"></i> <span>Pengurusan Bantuan</span>
            </a>
        
            <a class="nav-link" href="#">
                <i class="bi bi-building me-2"></i> <span>Semak Kemudahan</span>
            </a>
             <a class="nav-link" href="#">
                <i class="bi bi-calendar-check me-2"></i> <span>Urus Tempahan</span>
            </a>

        <% } %>

        <hr class="mx-3 my-3 text-muted">
        
        <a class="nav-link" href="#">
            <i class="bi bi-gear me-2"></i> <span>Tetapan</span>
        </a>
        
        <a class="nav-link text-danger" href="<%= request.getContextPath() %>/logout">
            <i class="bi bi-box-arrow-right me-2"></i> <span>Log Keluar</span>
        </a>
    </nav>
</div>

<div class="main-content" id="mainContent">
    <div class="top-bar d-flex justify-content-between align-items-center p-3 bg-white shadow-sm mb-4">
        
        <div class="d-flex align-items-center">
            <i class="bi bi-list fs-3" id="sidebarToggle" title="Toggle Sidebar"></i>
            
            <div class="search-container ms-3">
                <i class="bi bi-search text-muted"></i>
                <input type="text" class="search-input border-0 ms-2" placeholder="Cari..." style="outline: none;">
            </div>
        </div>

        <div class="d-flex align-items-center">
            <div class="position-relative me-4">
                <i class="bi bi-bell fs-5 text-muted"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge border border-light rounded-circle bg-danger p-1">
                    <span class="visually-hidden">unread messages</span>
                </span>
            </div>
            <div class="text-end me-3 d-none d-sm-block">
                <div class="fw-bold small lh-1 text-dark"><%= (user.getNamaPertama() != null) ? user.getNamaPertama() : "Pengguna" %></div>
                <small class="text-muted" style="font-size: 11px;"><%= role %></small>
            </div>
            <div class="bg-success rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-sm" style="width: 40px; height: 40px; font-size: 14px;">
                <%= (user.getNamaPertama() != null) ? user.getNamaPertama().substring(0,1).toUpperCase() : "U" %>
            </div>
        </div>
    </div>
  

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const toggleBtn = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');

        // Check local storage untuk simpan state (supaya tak reset bila refresh)
        if (localStorage.getItem('sidebarState') === 'collapsed') {
            sidebar.classList.add('collapsed');
            mainContent.classList.add('expanded');
        }

        toggleBtn.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('expanded');
            
            // Simpan preference user
            if (sidebar.classList.contains('collapsed')) {
                localStorage.setItem('sidebarState', 'collapsed');
            } else {
                localStorage.setItem('sidebarState', 'expanded');
            }
        });
    });
</script>