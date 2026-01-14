<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Log Masuk | Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { 
            background: linear-gradient(135deg, #f0f2f5 0%, #e2e8f0 100%); 
            font-family: 'Inter', sans-serif; 
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            border: none;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }

        .brand-logo { 
            background: #10b981; 
            color: white; 
            width: 50px;
            height: 50px;
            border-radius: 12px; 
            display: flex; 
            align-items: center; 
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 1.5rem;
        }

        .login-header h3 { font-weight: 700; color: #1e293b; margin-bottom: 5px; }
        .login-header p { color: #64748b; font-size: 0.9rem; margin-bottom: 30px; }

        .form-label { font-weight: 600; color: #475569; font-size: 0.85rem; }
        
        .form-control {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 12px 15px;
            transition: 0.3s;
        }
        
        .form-control:focus {
            background: #fff;
            border-color: #10b981;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }

        .btn-login {
            background: #10b981;
            color: white;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            margin-top: 10px;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: #059669;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
        }

        .register-link { font-size: 0.9rem; color: #64748b; margin-top: 25px; }
        .register-link a { color: #10b981; text-decoration: none; font-weight: 600; }
        .register-link a:hover { text-decoration: underline; }

        .alert-custom {
            border-radius: 10px;
            font-size: 0.85rem;
            padding: 12px;
            border: none;
        }
    </style>
</head>
<body>

    <div class="login-card shadow-lg">
        <div class="login-header text-center">
            <div class="brand-logo shadow-sm">
                <i class="bi bi-houses-fill"></i>
            </div>
            <h3>Log Masuk</h3>
            <p>Portal Pengurusan Kampung Danan</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-custom d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <div><%= request.getAttribute("error") %></div>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="nomborKP" class="form-label">Nombor Kad Pengenalan</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;">
                        <i class="bi bi-card-text text-muted"></i>
                    </span>
                    <input type="text" class="form-control border-start-0" id="nomborKP" name="nomborKP" 
                           placeholder="Contoh: 900101035544" required style="border-radius: 0 10px 10px 0;">
                </div>
            </div>
            
            <div class="mb-4">
                <label for="kataLaluan" class="form-label">Kata Laluan</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px;">
                        <i class="bi bi-lock text-muted"></i>
                    </span>
                    <input type="password" class="form-control border-start-0" id="kataLaluan" name="kataLaluan" 
                           placeholder="Masukkan kata laluan" required style="border-radius: 0 10px 10px 0;">
                </div>
            </div>

            <button type="submit" class="btn btn-login w-100">
                Log Masuk Sekarang <i class="bi bi-arrow-right-short ms-1"></i>
            </button>
        </form>

        <p class="text-center register-link">
            Belum mempunyai akaun? <a href="register.jsp">Daftar Sini</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>