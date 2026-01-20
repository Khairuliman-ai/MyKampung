<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Daftar Akaun | MyKampung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); height: 100vh; display: flex; align-items: center; justify-content: center; }
        .card-register { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); overflow: hidden; }
        .form-control { padding: 12px; border-radius: 10px; }
        .btn-register { padding: 12px; border-radius: 10px; font-weight: bold; width: 100%; background: #2563eb; color: white; border: none; }
        .btn-register:hover { background: #1d4ed8; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card card-register bg-white p-4">
                    <div class="text-center mb-4">
                        <h3 class="fw-bold text-primary">Daftar Penduduk</h3>
                        <p class="text-muted small">Sertai komuniti MyKampung hari ini.</p>
                    </div>

                    <form action="<%= request.getContextPath() %>/register" method="post">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-muted">Nombor Kad Pengenalan</label>
                            <input type="text" name="nomborKP" class="form-control" placeholder="Cth: 990101035555" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-muted">Nama Penuh</label>
                            <input type="text" name="namaLengkap" class="form-control" placeholder="Nama seperti dalam MyKad" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-muted">Alamat Kediaman (Dalam Kampung)</label>
                            <textarea name="alamat" class="form-control" rows="2" required></textarea>
                        </div>

                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold small text-muted">No. Telefon</label>
                                <input type="text" name="noTelefon" class="form-control" placeholder="012-3456789" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-bold small text-muted">Kata Laluan</label>
                                <input type="password" name="kataLaluan" class="form-control" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-register mt-2">Hantar Pendaftaran</button>
                    </form>

                    <div class="text-center mt-4 border-top pt-3">
                        <small class="text-muted">Sudah mempunyai akaun? <a href="login.jsp" class="text-primary fw-bold text-decoration-none">Log Masuk</a></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>