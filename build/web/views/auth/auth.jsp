<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Log Masuk / Daftar | Kampung Danan</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
    padding: 20px 50px; /* Kurangkan padding atas bawah sedikit */
    display: flex;
    align-items: flex-start; /* TUKAR dari center ke flex-start */
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
    width: 50%; /* Pastikan lebar kekal 50% */
    overflow-y: auto; /* Membolehkan scroll */
    padding-top: 40px; /* Beri ruang sedikit di atas */
    padding-bottom: 40px; /* Beri ruang sedikit di bawah */
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
            position: absolute;
            top: 0;
            right: 0;
            width: 50%;
            height: 100%;
            background: url('<%= request.getContextPath() %>/assets/img/kampung.png') center/cover no-repeat;
            overflow: hidden;
            transition: transform 0.6s ease-in-out, border-radius 0.6s ease-in-out;
            z-index: 100;
            border-radius: 120px 0 0 120px;
        }

        .auth-container.sign-up-mode .overlay-container {
            transform: translateX(-100%);
            border-radius: 0 120px 120px 0;
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
    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">

        <div class="brand-logo mb-3 text-center">
            <i class="bi bi-houses-fill" style="font-size: 2rem; color: #6C5DD3;"></i>
        </div>

        <h4 class="fw-bold text-center">Log Masuk</h4>
        <p class="text-muted text-center small mb-4">Portal Pengurusan Kampung Danan</p>

        <%-- Notification Logic via Script at Bottom --%>
        <% if (request.getAttribute("error") != null) { %>
            <script>
                Swal.fire({
                    icon: 'error',
                    title: 'Ralat',
                    text: '<%= request.getAttribute("error") %>',
                    confirmButtonColor: '#6C5DD3'
                });
            </script>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <script>
                Swal.fire({
                    icon: 'success',
                    title: 'Berjaya',
                    text: '<%= request.getAttribute("success") %>',
                    confirmButtonColor: '#10b981'
                });
            </script>
        <% } %>
        <label class="form-label small fw-bold text-dark">Nombor Kad Pengenalan:</label>
        <input type="text" name="nombor_kp" class="form-control mb-3" 
               placeholder="Contoh: 900502-11-4032" 
               oninput="formatIC(this)" maxlength="14" required>

        <div class="mb-3">
            <label class="form-label small fw-bold text-dark">Kata Laluan:</label>
            <div class="position-relative">
                <input type="password" id="passwordField" name="kata_laluan" 
                       class="form-control pe-5" 
                       placeholder="Kata Laluan" required>
                <span class="position-absolute end-0 top-50 translate-middle-y me-3 cursor-pointer text-muted" 
                      onclick="togglePassword()" 
                      style="z-index: 10; cursor: pointer;">
                    <i id="toggleIcon" class="bi bi-eye"></i>
                </span>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 px-1">
          
            <a href="#" data-bs-toggle="modal" data-bs-target="#forgotPasswordModal" class="text-decoration-none small fw-bold" style="color: #6C5DD3;">Lupa Kata Laluan?</a>
        </div>

        <button type="submit" class="btn btn-primary w-100 mt-2" style="background-color: #6C5DD3; border: none;">
            Log Masuk
        </button>

        <div class="text-center mt-3 small">
            Belum ada akaun? <a href="#" id="linkSignUp" class="fw-bold" style="color: #6C5DD3; text-decoration: none;">Daftar Sekarang</a>
        </div>
    </form>
</div>

            <!-- ===== Register ===== -->
<div class="form-container sign-up-container">
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" enctype="multipart/form-data" class="py-3 px-4">

        <h4 class="fw-bold text-center mb-1">Daftar Penduduk</h4>
        <p class="text-muted text-center small mb-4">Sila isi butiran dengan lengkap untuk pengesahan AJK</p>

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

        <div class="mb-3 text-start">
            <label class="form-label small fw-bold text-dark">Alamat Emel:</label>
            <input type="email" name="email" class="form-control" placeholder="Contoh: ali@gmail.com" required>
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

        <div class="text-center mt-3 small">
            Sudah ada akaun? <a href="#" id="linkSignIn" class="fw-bold" style="color: #10b981; text-decoration: none;">Log Masuk</a>
        </div>
    </form>
</div>

    <!-- ===== OVERLAY ===== -->
    <div class="overlay-container"></div>

</div>

<!-- ===== MODAL LUPA KATA LALUAN (MULTI-STEP) ===== -->
<div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordModalLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 25px; border: none; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);">
            <div class="modal-header border-0 pb-0 px-4 pt-4">
                <h5 class="modal-title fw-bold" id="forgotPasswordModalLabel" style="color: #6C5DD3;">Set Semula Kata Laluan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="resetForgotModal()"></button>
            </div>
            
            <div class="modal-body p-4">
                <!-- Progress Bar -->
                <div class="d-flex justify-content-between mb-4 px-2">
                    <div id="dot1" class="step-dot active"></div>
                    <div id="dot2" class="step-dot"></div>
                    <div id="dot3" class="step-dot"></div>
                </div>

                <div id="forgot-alert" class="alert alert-danger d-none small py-2 rounded-3 mb-3"></div>

                <!-- STEP 1: Masukkan Emel & IC -->
                <div id="step-email" class="forgot-step">
                    <p class="text-muted small mb-4">Sila masukkan Nombor Kad Pengenalan dan Emel anda untuk pengesahan identiti.</p>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-dark">Nombor Kad Pengenalan:</label>
                        <input type="text" id="forgot-ic-input" class="form-control custom-input" placeholder="Contoh: 900502-11-4032" oninput="formatIC(this)" maxlength="14" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-dark">Alamat Emel:</label>
                        <input type="email" id="forgot-email-input" class="form-control custom-input" placeholder="nama@emel.com" required>
                    </div>
                    <button type="button" onclick="handleForgotEmail()" class="btn btn-primary w-100 py-3 mt-2 brand-btn">
                        Hantar Kod OTP <i class="fas fa-paper-plane ms-2"></i>
                    </button>
                </div>

                <!-- STEP 2: Sahkan OTP -->
                <div id="step-otp" class="forgot-step d-none">
                    <p class="text-muted small mb-4">Kod OTP telah dihantar ke emel anda. Sila masukkan kod tersebut untuk pengesahan.</p>
                    <div class="mb-3 text-center">
                        <label class="form-label small fw-bold text-dark d-block mb-3">Masukkan Kod OTP 6-Digit:</label>
                        <input type="text" id="forgot-otp-input" class="form-control text-center fw-bold" 
                               maxlength="6" placeholder="0 0 0 0 0 0" 
                               style="font-size: 24px; letter-spacing: 8px; border-radius: 15px; background: #f1f5f9; border: 2px solid #e2e8f0;">
                    </div>
                    <button type="button" onclick="handleVerifyOTP()" class="btn btn-primary w-100 py-3 mt-2 brand-btn">
                        Sahkan Kod <i class="fas fa-check-circle ms-2"></i>
                    </button>
                    
                    <div class="text-center mt-3">
                        <span class="text-muted small">Tidak terima kod?</span>
                        <button type="button" id="btn-resend" onclick="handleResendOTP()" class="btn btn-link p-0 ms-1 text-decoration-none small fw-bold" style="color: #6C5DD3;">Hantar Semula</button>
                        <span id="countdown-text" class="text-muted small d-none">(Tunggu <span id="timer">120</span>s)</span>
                    </div>

                    <button type="button" onclick="showStep(1)" class="btn btn-link w-100 mt-2 text-decoration-none text-muted small">Kembali ke Emel</button>
                </div>

                <!-- STEP 3: Kata Laluan Baru -->
                <div id="step-password" class="forgot-step d-none">
                    <p class="text-muted small mb-4">OTP disahkan! Sila tetapkan kata laluan baru anda sekarang.</p>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-dark">Kata Laluan Baru:</label>
                        <input type="password" id="forgot-new-pass" class="form-control custom-input" placeholder="Masukkan kata laluan baru" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-dark">Sahkan Kata Laluan:</label>
                        <input type="password" id="forgot-confirm-pass" class="form-control custom-input" placeholder="Taip semula kata laluan" required>
                    </div>
                    <button type="button" onclick="handleResetPassword()" class="btn btn-success w-100 py-3 mt-2 shadow-sm" style="border-radius: 15px; font-weight: 700; background: #10b981; border: none;">
                        Kemaskini Kata Laluan <i class="fas fa-shield-alt ms-2"></i>
                    </button>
                </div>
            </div>
            
            <div class="modal-footer border-0 pt-0 pb-4 px-4 justify-content-center">
                <p class="text-muted mb-0" style="font-size: 11px;">Perlukan bantuan? Hubungi pentadbir AJK Danan.</p>
            </div>
        </div>
    </div>
</div>

<style>
    .step-dot { width: 30%; height: 6px; background: #e2e8f0; border-radius: 10px; transition: all 0.3s ease; }
    .step-dot.active { background: #6C5DD3; box-shadow: 0 0 10px rgba(108, 93, 211, 0.3); }
    .custom-input { background: #f8fafc; border-radius: 15px; padding: 12px 18px; font-size: 0.9rem; border: 1px solid #e2e8f0; }
    .brand-btn { background-color: #6C5DD3; border: none; border-radius: 15px; font-weight: 700; transition: all 0.3s ease; }
    .brand-btn:hover { background-color: #5a4db8; transform: translateY(-2px); }
</style>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Variable Global untuk Reset
    let currentEmail = "";
    let currentOTP = "";

    function showStep(step) {
        document.querySelectorAll('.forgot-step').forEach(el => el.classList.add('d-none'));
        document.querySelectorAll('.step-dot').forEach(el => el.classList.remove('active'));
        
        document.getElementById('step-email').classList.add('d-none');
        document.getElementById('step-otp').classList.add('d-none');
        document.getElementById('step-password').classList.add('d-none');
        
        if(step === 1) {
            document.getElementById('step-email').classList.remove('d-none');
            document.getElementById('dot1').classList.add('active');
        } else if(step === 2) {
            document.getElementById('step-otp').classList.remove('d-none');
            document.getElementById('dot1').classList.add('active');
            document.getElementById('dot2').classList.add('active');
        } else if(step === 3) {
            document.getElementById('step-password').classList.remove('d-none');
            document.getElementById('dot1').classList.add('active');
            document.getElementById('dot2').classList.add('active');
            document.getElementById('dot3').classList.add('active');
        }
    }

    function resetForgotModal() {
        showStep(1);
        document.getElementById('forgot-alert').classList.add('d-none');
        document.getElementById('forgot-email-input').value = "";
        document.getElementById('forgot-otp-input').value = "";
        document.getElementById('forgot-new-pass').value = "";
        document.getElementById('forgot-confirm-pass').value = "";
    }

    async function handleForgotEmail() {
        const email = document.getElementById('forgot-email-input').value;
        const ic = document.getElementById('forgot-ic-input').value;
        const alertBox = document.getElementById('forgot-alert');
        
        if(!email || !ic) { alertBox.innerText = "Sila masukkan butiran lengkap."; alertBox.classList.remove('d-none'); return; }
        
        try {
            const formData = new URLSearchParams();
            formData.append('email', email);
            formData.append('nombor_kp', ic);
            
            const response = await fetch('${pageContext.request.contextPath}/ForgotPassServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            
            const result = await response.json();
            if(result.success) {
                currentEmail = email;
                alertBox.classList.add('d-none');
                showStep(2);
                startCountdown(); // Mula kiraan masa resend
            } else {
                alertBox.innerText = result.message;
                alertBox.classList.remove('d-none');
            }
        } catch (e) {
            alertBox.innerText = "Ralat sistem. Cuba lagi.";
            alertBox.classList.remove('d-none');
        }
    }

    async function handleVerifyOTP() {
        const otp = document.getElementById('forgot-otp-input').value;
        const alertBox = document.getElementById('forgot-alert');
        
        if(!otp) { alertBox.innerText = "Sila masukkan kod OTP."; alertBox.classList.remove('d-none'); return; }
        
        try {
            const formData = new URLSearchParams();
            formData.append('email', currentEmail);
            formData.append('otp', otp);
            
            const response = await fetch('${pageContext.request.contextPath}/VerifyOTPServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            
            const result = await response.json();
            if(result.success) {
                currentOTP = otp;
                alertBox.classList.add('d-none');
                showStep(3);
            } else {
                alertBox.innerText = result.message;
                alertBox.classList.remove('d-none');
            }
        } catch (e) {
            alertBox.innerText = "Ralat sistem. Cuba lagi.";
            alertBox.classList.remove('d-none');
        }
    }

    async function handleResetPassword() {
        const pass = document.getElementById('forgot-new-pass').value;
        const confirm = document.getElementById('forgot-confirm-pass').value;
        const alertBox = document.getElementById('forgot-alert');
        
        if(!pass || !confirm) { alertBox.innerText = "Sila lengkapkan semua medan."; alertBox.classList.remove('d-none'); return; }
        if(pass !== confirm) { alertBox.innerText = "Kata laluan tidak sepadan."; alertBox.classList.remove('d-none'); return; }
        
        try {
            const formData = new URLSearchParams();
            formData.append('email', currentEmail);
            formData.append('otp', currentOTP);
            formData.append('newPassword', pass);
            
            const response = await fetch('${pageContext.request.contextPath}/UpdatePasswordServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            
            const result = await response.json();
            if(result.success) {
                alert("Berjaya! Kata laluan anda telah dikemaskini. Sila log masuk semula.");
                window.location.reload();
            } else {
                alertBox.innerText = result.message;
                alertBox.classList.remove('d-none');
            }
        } catch (e) {
            alertBox.innerText = "Ralat sistem. Cuba lagi.";
            alertBox.classList.remove('d-none');
        }
    }

    // --- LOGIK RESEND OTP ---
    let resendTimer;
    function startCountdown() {
        const btn = document.getElementById('btn-resend');
        const text = document.getElementById('countdown-text');
        const timerDisplay = document.getElementById('timer');
        let timeLeft = 120; // 2 minit

        btn.classList.add('d-none');
        text.classList.remove('d-none');
        
        clearInterval(resendTimer);
        resendTimer = setInterval(() => {
            timeLeft--;
            timerDisplay.innerText = timeLeft;
            if(timeLeft <= 0) {
                clearInterval(resendTimer);
                btn.classList.remove('d-none');
                text.classList.add('d-none');
            }
        }, 1000);
    }

    async function handleResendOTP() {
        // Panggil semula handleForgotEmail untuk hantar OTP baru
        // Kita hantar IC dan Email yang tersimpan
        const ic = document.getElementById('forgot-ic-input').value;
        const alertBox = document.getElementById('forgot-alert');
        
        try {
            const formData = new URLSearchParams();
            formData.append('email', currentEmail);
            formData.append('nombor_kp', ic);
            
            const response = await fetch('${pageContext.request.contextPath}/ForgotPassServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            
            const result = await response.json();
            if(result.success) {
                alertBox.innerText = "Kod baru telah dihantar!";
                alertBox.classList.remove('d-none', 'alert-danger');
                alertBox.classList.add('alert-success');
                startCountdown();
            } else {
                alertBox.innerText = result.message;
                alertBox.classList.remove('d-none', 'alert-success');
                alertBox.classList.add('alert-danger');
            }
        } catch (e) {
            alertBox.innerText = "Ralat hantar semula.";
            alertBox.classList.remove('d-none');
        }
    }

    const container = document.getElementById("authContainer");
    
    // ===== SWEETALERT NOTIFICATIONS =====
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        
        // 1. Check for Errors (from forward or redirect)
        let errorMsg = '<%= request.getAttribute("error") != null ? request.getAttribute("error") : (request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "") %>';
        if (!errorMsg && urlParams.has('error')) {
            errorMsg = urlParams.get('error');
        }
        if (!errorMsg && urlParams.has('errorMessage')) {
            errorMsg = urlParams.get('errorMessage');
        }
        
        if (errorMsg && errorMsg !== "null") {
            Swal.fire({
                icon: 'error',
                title: 'Log Masuk Gagal',
                text: errorMsg,
                confirmButtonColor: '#6C5DD3',
                timer: 4000
            });
        }

        // 2. Check for Success (from forward or redirect)
        let successMsg = '<%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %>';
        if (!successMsg && urlParams.has('success')) {
            successMsg = urlParams.get('success');
        }
        
        if (successMsg && successMsg !== "null") {
            Swal.fire({
                icon: 'success',
                title: 'Berjaya!',
                text: successMsg,
                confirmButtonColor: '#10b981',
                timer: 6000
            });
        }
    });
    const linkSignUp = document.getElementById("linkSignUp");
    const linkSignIn = document.getElementById("linkSignIn");

    linkSignUp.addEventListener("click", (e) => {
        e.preventDefault();
        container.classList.add("sign-up-mode");
    });

    linkSignIn.addEventListener("click", (e) => {
        e.preventDefault();
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
