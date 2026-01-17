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

<div class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-logo"><i class="bi bi-houses-fill"></i></div>
        <div>
            <h6 class="mb-0 fw-bold">Kampung Danan</h6>
            <small class="text-muted" style="font-size: 11px;">Portal Pengurusan</small>
        </div>
    </div>

    <nav class="nav flex-column">
        
        <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">
            <i class="bi bi-grid"></i> Papan Pemuka
        </a>

        <% if ("Penduduk".equalsIgnoreCase(role)) { %>
            
            <a class="nav-link" href="<%= request.getContextPath() %>/views/profil/userProfile.jsp">
                <i class="bi bi-person"></i> Profil Saya
            </a>
            <a class="nav-link" href="<%= request.getContextPath() %>/bantuan/list">
                <i class="bi bi-hand-index-thumb"></i> Mohon Bantuan
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-exclamation-circle"></i> Buat Aduan
            </a>

        <% } else if ("Ketua Kampung".equalsIgnoreCase(role)) { %>

            <a class="nav-link" href="#">
                <i class="bi bi-people-fill"></i> Urus Penduduk
            </a>
            <a class="nav-link" href="<%= request.getContextPath() %>/bantuan/list">
                <i class="bi bi-check-circle"></i> Kelulusan Bantuan
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-building"></i> Urus Kemudahan
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-megaphone-fill"></i> Urus Hebahan
            </a>

        <% } else if ("JKKK".equalsIgnoreCase(role)) { %>

            <a class="nav-link" href="#">
                <i class="bi bi-people"></i> Senarai Penduduk
            </a>
            <a class="nav-link" href="#">
                <i class="bi bi-building"></i> Semak Kemudahan
            </a>
             <a class="nav-link" href="#">
                <i class="bi bi-calendar-check"></i> Urus Tempahan
            </a>

        <% } %>

        <hr class="mx-3 my-3 text-muted">
        
        <a class="nav-link" href="#">
            <i class="bi bi-gear"></i> Tetapan
        </a>
        
        <a class="nav-link text-danger" href="<%= request.getContextPath() %>/logout">
            <i class="bi bi-box-arrow-right"></i> Log Keluar
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="top-bar">
        <div class="search-container">
            <i class="bi bi-search"></i>
            <input type="text" class="search-input" placeholder="Cari...">
        </div>
        <div class="d-flex align-items-center">
            <div class="position-relative me-4">
                <i class="bi bi-bell fs-5"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge border border-light rounded-circle bg-danger p-1">
                    <span class="visually-hidden">unread messages</span>
                </span>
            </div>
            <div class="text-end me-3">
                <div class="fw-bold small lh-1"><%= (user.getNamaPertama() != null) ? user.getNamaPertama() : "Pengguna" %></div>
                <small class="text-muted" style="font-size: 11px;"><%= role %></small>
            </div>
            <div class="bg-success rounded-circle d-flex align-items-center justify-content-center text-white fw-bold" style="width: 40px; height: 40px; font-size: 14px;">
                <%= (user.getNamaPertama() != null) ? user.getNamaPertama().substring(0,1).toUpperCase() : "U" %>
            </div>
        </div>
    </div>
  