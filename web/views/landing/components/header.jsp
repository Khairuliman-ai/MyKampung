<nav class="navbar navbar-expand-lg sticky-top landing-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="#">
            <div class="logo-box me-2">
                <i class="bi bi-houses-fill"></i>
            </div>
            <span class="brand-text">My<span>Kampung</span></span>
        </a>
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#landingNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="landingNav">
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link px-3" href="#hero">Utama</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#features">Fasiliti</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#stats">Komuniti</a></li>
                <li class="nav-item"><a class="nav-link px-3" href="#footer">Hubungi</a></li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/views/auth/auth.jsp" class="btn btn-login px-4 py-2">
                    <i class="bi bi-box-arrow-in-right me-2"></i> Log Masuk
                </a>
                <a href="${pageContext.request.contextPath}/views/auth/auth.jsp#signup" class="btn btn-register px-4 py-2">
                    Daftar Penduduk
                </a>
            </div>
        </div>
    </div>
</nav>
