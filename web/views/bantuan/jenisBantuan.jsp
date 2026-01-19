<%@ include file="/views/common/header.jsp" %>
<%@ include file="/views/common/navbar.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pusat Bantuan - MyKampung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .card-bantuan {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            border: none;
            border-radius: 15px;
        }
        .card-bantuan:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .icon-large { font-size: 3rem; margin-bottom: 15px; }
        .bg-komuniti { background-color: #28a745; color: white; } /* Hijau */
        .bg-rasmi { background-color: #007bff; color: white; }    /* Biru */
    </style>
</head>
<body>

    <nav class="navbar navbar-light bg-white shadow-sm mb-5">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="#">MyKampung</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Log Keluar</a>
        </div>
    </nav>

    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Apa yang boleh kami bantu?</h2>
            <p class="text-muted">Sila pilih kategori bantuan yang anda perlukan.</p>
        </div>

        <div class="row justify-content-center">
            
            <div class="col-md-5 col-lg-4 mb-4">
                <a href="${pageContext.request.contextPath}/bantuan/komuniti" class="text-decoration-none">
                    <div class="card card-bantuan h-100 shadow-sm">
                        <div class="card-body text-center p-5">
                            <div class="icon-large text-success">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <h4 class="card-title text-dark fw-bold">Bantuan Komuniti</h4>
                            <p class="card-text text-muted mt-3">
                                Gotong-royong, sumbangan jiran tetangga, aduan kerosakan fasiliti kampung, dan aktiviti sukarelawan.
                            </p>
                            <button class="btn btn-success mt-3 rounded-pill px-4">Pilih Komuniti</button>
                        </div>
                    </div>
                </a>
            </div>

            <div class="col-md-5 col-lg-4 mb-4">
                <a href="${pageContext.request.contextPath}/bantuan/rasmi" class="text-decoration-none">
                    <div class="card card-bantuan h-100 shadow-sm">
                        <div class="card-body text-center p-5">
                            <div class="icon-large text-primary">
                                <i class="bi bi-building-fill-check"></i>
                            </div>
                            <h4 class="card-title text-dark fw-bold">Bantuan Rasmi</h4>
                            <p class="card-text text-muted mt-3">
                                Permohonan bantuan JKM, pengesahan penghulu, surat sokongan, dan urusan rasmi kerajaan.
                            </p>
                            <a href="${pageContext.request.contextPath}/bantuan/rasmi" class="btn btn-primary mt-3 rounded-pill px-4"> Pilih Rasmi</a>
                        </div>
                    </div>
                </a>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>