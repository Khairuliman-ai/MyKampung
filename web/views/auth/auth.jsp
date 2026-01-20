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

    <!-- ===== LOGIN ===== -->
    <div class="form-container sign-in-container">
        <form action="${pageContext.request.contextPath}/login" method="post">

            <div class="brand-logo">
                <i class="bi bi-houses-fill"></i>
            </div>

            <h4 class="fw-bold text-center">Log Masuk</h4>
            <p class="text-muted text-center small mb-4">Portal Pengurusan Kampung Danan</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-custom mb-3">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <input type="text" name="nomborKP" class="form-control" placeholder="Nombor Kad Pengenalan" required>
            <input type="password" name="kataLaluan" class="form-control" placeholder="Kata Laluan" required>

            <button type="submit" class="btn btn-primary w-100 mt-2">Log Masuk</button>
        </form>
    </div>

    <!-- ===== REGISTER ===== -->
    <div class="form-container sign-up-container">
        <form action="${pageContext.request.contextPath}/register" method="post">

            <h4 class="fw-bold text-center mb-3">Daftar Akaun</h4>

            <input type="text" name="nomborKP" class="form-control" placeholder="Nombor Kad Pengenalan" required>
            <input type="text" name="namaLengkap" class="form-control" placeholder="Nama Penuh" required>
            <textarea name="alamat" class="form-control" rows="2" placeholder="Alamat Kediaman" required></textarea>
            <input type="text" name="noTelefon" class="form-control" placeholder="No Telefon" required>
            <input type="password" name="kataLaluan" class="form-control" placeholder="Kata Laluan" required>

            <button type="submit" class="btn btn-success w-100 mt-2">Daftar</button>
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

</body>
</html>
