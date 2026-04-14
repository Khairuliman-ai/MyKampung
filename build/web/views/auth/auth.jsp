<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Log Masuk / Daftar | Kampung Danan</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            min-height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #f0f2f5, #e2e8f0);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* ===== CONTAINER ===== */
        .auth-container {
            background: #fff;
            width: 100%;
            max-width: 960px;
            min-height: 520px;              /* dynamic */
            border-radius: 20px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            display: flex;
        }

        /* ===== FORM SIDE ===== */
        .form-container {
            width: 50%;
            padding: 40px 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.6s ease, opacity 0.6s ease;
        }

        .form-container form {
            width: 100%;
            max-width: 360px;
        }

        .sign-in-container {
            z-index: 2;
        }

        .sign-up-container {
            position: absolute;
            left: 0;
            opacity: 0;
            z-index: 1;
            height: 100%;
            overflow-y: auto;               /* 🔑 dynamic scroll */
        }

        /* ===== ACTIVE MODE ===== */
        .auth-container.sign-up-mode .sign-in-container {
            transform: translateX(100%);
            opacity: 0;
        }

        .auth-container.sign-up-mode .sign-up-container {
            transform: translateX(100%);
            opacity: 1;
            z-index: 5;
        }

        /* ===== OVERLAY ===== */
        .overlay-container {
            width: 50%;
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            text-align: center;
            transition: transform 0.6s ease;
        }

        .auth-container.sign-up-mode .overlay-container {
            transform: translateX(-100%);
        }

        .overlay-content h4 {
            font-weight: 700;
        }

        .overlay-content p {
            font-size: 0.95rem;
            opacity: 0.9;
        }

        /* ===== INPUT ===== */
        .form-control {
            background: #f8fafc;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }

        textarea.form-control {
            resize: none;
        }

        .btn {
            border-radius: 10px;
            padding: 10px;
            font-weight: 600;
        }

        /* ===== BRAND ===== */
        .brand-logo {
            background: #10b981;
            width: 50px;
            height: 50px;
            border-radius: 12px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin: 0 auto 15px;
        }

        .alert-custom {
            font-size: 0.85rem;
            border-radius: 10px;
        }

        /* ===== SCROLL STYLE (CANTIK) ===== */
        .sign-up-container::-webkit-scrollbar {
            width: 6px;
        }
        .sign-up-container::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        /* ===== MOBILE ===== */
        @media (max-width: 768px) {
            .auth-container {
                flex-direction: column;
                min-height: auto;
            }

            .overlay-container {
                display: none;
            }

            .form-container,
            .sign-up-container {
                width: 100%;
                position: relative;
                transform: none !important;
                opacity: 1 !important;
            }
        }
    </style>
</head>

<body>

<div class="auth-container" id="authContainer">

    <script>
    function formatIC(input) {
    // 1. Buang semua karakter bukan nombor
    let val = input.value.replace(/\D/g, '');
    
    // 2. Potong jika lebih 12 digit (elak ralat)
    if (val.length > 12) {
        val = val.substring(0, 12);
    }

    // 3. Masukkan sempang mengikut posisi
    let formatted = "";
    if (val.length > 0) {
        // Bahagian Tarikh Lahir (6 digit pertama)
        formatted += val.substring(0, 6);
    }
    if (val.length > 6) {
        // Bahagian Kod Negeri (2 digit tengah)
        formatted += '-' + val.substring(6, 8);
    }
    if (val.length > 8) {
        // Bahagian Nombor Siri (4 digit terakhir)
        formatted += '-' + val.substring(8, 12);
    }

    input.value = formatted;
}
    </script>
    
    <!-- ===== LOGIN ===== -->
<div class="form-container sign-in-container">
    <form action="${pageContext.request.contextPath}/login" method="post">

        <div class="brand-logo mb-3 text-center">
            <i class="bi bi-houses-fill" style="font-size: 2rem; color: #6C5DD3;"></i>
        </div>

        <h4 class="fw-bold text-center">Log Masuk</h4>
        <p class="text-muted text-center small mb-4">Portal Pengurusan Kampung Danan</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom mb-3">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <label class="form-label small fw-bold text-dark">Nombor Kad Pengenalan:</label>
        <input type="text" name="nombor_kp" class="form-control mb-3" 
               placeholder="Contoh: 900502-11-4032" 
               oninput="formatIC(this)" maxlength="14" required>

        <div class="position-relative mb-3">
            <label class="form-label small fw-bold text-dark">Kata Laluan:</label>
            <input type="password" id="passwordField" name="kata_laluan" 
                   class="form-control pe-5" 
                   placeholder="Kata Laluan" required>
            <span class="position-absolute end-0 top-50 translate-middle-y me-3 cursor-pointer text-muted" 
                  onclick="togglePassword()" 
                  style="z-index: 10; cursor: pointer;">
                <i id="toggleIcon" class="bi bi-eye"></i>
            </span>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 px-1">
          
            <a href="#" class="text-decoration-none small fw-bold" style="color: #6C5DD3;">Lupa Kata Laluan?</a>
        </div>

        <button type="submit" class="btn btn-primary w-100 mt-2" style="background-color: #6C5DD3; border: none;">
            Log Masuk
        </button>
    </form>
</div>

            <!-- ===== Register ===== -->
<div class="form-container sign-up-container">
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" enctype="multipart/form-data" class="py-3 px-4">

        <h4 class="fw-bold text-center mb-1">Daftar Penduduk</h4>
        <p class="text-muted text-center small mb-4">Sila isi butiran dengan lengkap untuk pengesahan JKKK</p>

        <div class="mb-3 text-start">
            <label class="form-label small fw-bold text-dark">Nama Penuh (Seperti dalam MyKad):</label>
            <input type="text" name="nama_penuh" class="form-control" placeholder="Contoh: KHAIRUL BIN ABDULLAH" required>
        </div>

        <div class="mb-3 text-start">
            <label class="form-label small fw-bold text-dark">Nombor Kad Pengenalan:</label>
            <input type="text" name="nombor_kp" class="form-control" placeholder="Contoh: 010203030441" required>
            <div class="form-text" style="font-size: 10px;">Masukkan 12 digit tanpa tanda sempang (-)</div>
        </div>

        <div class="mb-3 text-start">
            <label class="form-label small fw-bold text-dark">Nombor Telefon:</label>
            <input type="text" name="nombor_telefon" class="form-control" placeholder="Contoh: 0123456789" required>
        </div>

        <div class="row g-2 text-start">
            <div class="col-12 mb-2">
                <label class="form-label small fw-bold text-dark">Alamat (No. Rumah & Nama Jalan):</label>
                <input type="text" name="nama_jalan" class="form-control" placeholder="Contoh: No 12, Jalan Melati" required>
            </div>
            
            <div class="col-6 mb-2">
                <label class="form-label small fw-bold text-muted">Daerah:</label>
                <input type="text" name="daerah" class="form-control bg-light" value="Selising" readonly required>
            </div>
            
            <div class="col-6 mb-2">
                <label class="form-label small fw-bold text-muted">Poskod:</label>
                <input type="text" name="nombor_poskod" class="form-control bg-light" value="16810" readonly required>
            </div>
            
            <div class="col-6 mb-2">
                <label class="form-label small fw-bold text-muted">Bandar:</label>
                <input type="text" name="bandar" class="form-control bg-light" value="Pasir Puteh" readonly required>
            </div>
            
            <div class="col-6 mb-2">
                <label class="form-label small fw-bold text-muted">Negeri:</label>
                <input type="text" name="negeri" class="form-control bg-light" value="Kelantan" readonly required>
            </div>
        </div>

        <div class="mt-2 mb-3 text-start">
            <label class="form-label small fw-bold text-danger">Muat Naik Lampiran Bukti (PDF Sahaja):</label>
            <input type="file" name="bukti_pdf" class="form-control form-control-sm" accept="application/pdf" required>
            <div class="form-text" style="font-size: 10px;">Sila sertakan salinan MyKad atau Bil Utiliti(alamat yang dipaparkan dalam bil air atau elektrik)untuk pengesahan alamat.</div>
        </div>
        
        <div class="mb-3 text-start">
            <label class="form-label small fw-bold text-dark">Cipta Kata Laluan:</label>
            <input type="password" name="kata_laluan" class="form-control" placeholder="Gunakan gabungan huruf dan nombor" required>
        </div>

        <button type="submit" class="btn btn-success w-100 mt-2 shadow-sm py-2" style="background:#10b981; border:none; font-weight: bold;">
            Hantar Pendaftaran <i class="fas fa-paper-plane ms-2"></i>
        </button>
    </form>
</div>

    <!-- ===== OVERLAY ===== -->
    <div class="overlay-container">
        <div class="overlay-content">
            <h4>Sudah ada akaun?</h4>
            <p>Log masuk untuk teruskan</p>
            <button class="btn btn-outline-light mt-2" id="signInBtn">Log Masuk</button>

            <hr class="my-4" style="opacity:0.3">

            <h4>Belum ada akaun?</h4>
            <p>Daftar sebagai penduduk Kampung Danan</p>
            <button class="btn btn-outline-light mt-2" id="signUpBtn">Daftar Akaun</button>
        </div>
    </div>

</div>

<script>
    const container = document.getElementById("authContainer");
    const signUpBtn = document.getElementById("signUpBtn");
    const signInBtn = document.getElementById("signInBtn");

    signUpBtn.addEventListener("click", () => {
        container.classList.add("sign-up-mode");
    });

    signInBtn.addEventListener("click", () => {
        container.classList.remove("sign-up-mode");
    });
</script>

<script>
function togglePassword() {
    const passwordField = document.getElementById('passwordField');
    const toggleIcon = document.getElementById('toggleIcon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        toggleIcon.classList.remove('bi-eye');
        toggleIcon.classList.add('bi-eye-slash');
    } else {
        passwordField.type = 'password';
        toggleIcon.classList.remove('bi-eye-slash');
        toggleIcon.classList.add('bi-eye');
    }
}
</script>

</body>
</html>
