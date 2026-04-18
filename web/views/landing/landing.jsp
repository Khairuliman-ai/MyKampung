<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ms">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyKampung – Sistem Pengurusan Kampung Danan</title>
    
    <!-- Meta Tags SEO -->
    <meta name="description" content="Platform digital untuk menguruskan aktiviti, fasiliti, bantuan dan maklumat penduduk kampung Danan.">
    <meta property="og:title" content="MyKampung – Sistem Pengurusan Kampung" />
    <meta property="og:description" content="Kemudahan pengurusan fasiliti, bantuan, dan pendaftaran penduduk dalam satu platform."> 
    <meta property="og:type" content="website" />

    <!-- CSS Dependencies -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/landing/assets/css/landing.css">
    
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

    <!-- Header / Navbar -->
    <jsp:include page="components/header.jsp" />

    <main>
        <!-- Hero Section -->
        <jsp:include page="components/hero.jsp" />

        <!-- Features Section -->
        <jsp:include page="components/features.jsp" />

        <!-- Stats Section -->
        <jsp:include page="components/stats.jsp" />
    </main>

    <!-- Footer -->
    <jsp:include page="components/footer.jsp" />

    <!-- JS Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/landing/assets/js/landing.js"></script>

</body>
</html>
