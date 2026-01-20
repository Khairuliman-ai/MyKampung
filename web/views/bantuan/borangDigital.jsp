<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ms">
<head>
    <title>Borang Permohonan Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <style>
        /* Latar Belakang Skrin */
        body { 
            background: #e2e8f0; /* Kelabu cair profesional */
            color: #000; 
            font-family: 'Times New Roman', Times, serif; /* Font rasmi dokumen */
            padding-top: 80px; /* Ruang untuk toolbar */
        }

        /* Toolbar Kawalan (Ganti Petak Hitam Besar) */
        .control-bar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #cbd5e1;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            padding: 15px 0;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            font-family: sans-serif; /* UI guna font moden */
        }

        /* Kertas A4 */
        .a4-container {
            width: 210mm;
            min-height: 297mm;
            margin: 0 auto 50px auto;
            background: white;
            padding: 25mm;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            position: relative;
            border: 1px solid #e2e8f0;
        }

        /* Elemen Borang */
        .header-logo {
            border-bottom: 2px solid #000;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .section-header {
            background-color: #000;
            color: #fff;
            padding: 5px 10px;
            font-weight: bold;
            font-size: 1rem;
            text-transform: uppercase;
            margin-top: 25px;
            margin-bottom: 15px;
            -webkit-print-color-adjust: exact; /* Paksa print background hitam */
            print-color-adjust: exact;
        }

        .form-label-print {
            font-weight: bold;
            font-size: 0.95rem;
            margin-bottom: 2px;
            display: block;
            color: #000;
        }

        .form-line {
            border-bottom: 1px dotted #000; /* Garisan bintik nampak lebih kemas untuk tulis */
            padding: 5px 5px;
            min-height: 35px;
            margin-bottom: 15px;
            font-size: 1.1rem;
            font-family: 'Courier New', Courier, monospace; /* Font macam taip mesin */
            background-color: #f8fafc; /* Warna input cair di skrin */
        }

        /* Apabila Print */
        @media print {
            .no-print { display: none !important; }
            body { background: white; padding-top: 0; }
            .a4-container { 
                width: 100%; 
                margin: 0; 
                box-shadow: none; 
                border: none; 
                padding: 0;
            }
            .form-line {
                background-color: transparent !important;
                border-bottom: 1px solid #000; /* Garisan solid bila print */
            }
            /* Pastikan background tajuk hitam dicetak */
            .section-header {
                border: 1px solid #000;
            }
        }
    </style>
</head>
<body>

    <div class="control-bar no-print">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">
                    <i class="bi bi-file-earmark-text"></i>
                </div>
                <div>
                    <h6 class="m-0 fw-bold text-dark">Pratonton Borang</h6>
                    <small class="text-muted">Sila isi maklumat, kemudian muat turun.</small>
                </div>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/bantuan/komuniti" class="btn btn-light border me-2">Batal</a>
                <button onclick="cetakDanRedirect()" class="btn btn-primary shadow-sm px-4 fw-bold">
                    <i class="bi bi-download me-2"></i> Muat Turun PDF
                </button>
            </div>
        </div>
    </div>

    <div class="a4-container">
        
        <div class="header-logo text-center">
            <h5 class="fw-bold m-0">JAWATANKUASA KEMAJUAN DAN KESELAMATAN KAMPUNG (JKKK)</h5>
            <h3 class="fw-bold m-0">KAMPUNG DANAN</h3>
            <p class="small m-0">16800 Pasir Puteh, Kelantan Darul Naim</p>
            <hr class="my-3 border-dark opacity-100">
            <h2 class="fw-bold text-uppercase mt-4">BORANG PERMOHONAN BANTUAN</h2>
            <h5 class="text-uppercase text-decoration-underline"><%= request.getParameter("nama") != null ? request.getParameter("nama") : "BANTUAN AM" %></h5>
        </div>

        <div class="section-header">BAHAGIAN A: MAKLUMAT PEMOHON</div>
        
        <div class="row">
            <div class="col-12">
                <label class="form-label-print">Nama Penuh (Huruf Besar):</label>
                <div class="form-line" contenteditable="true"></div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-6">
                <label class="form-label-print">No. Kad Pengenalan:</label>
                <div class="form-line" contenteditable="true"></div>
            </div>
            <div class="col-6">
                <label class="form-label-print">No. Telefon:</label>
                <div class="form-line" contenteditable="true"></div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <label class="form-label-print">Alamat Kediaman Tetap:</label>
                <div class="form-line" contenteditable="true"></div>
                <div class="form-line" contenteditable="true"></div>
            </div>
        </div>

        <div class="section-header">BAHAGIAN B: BUTIRAN PERMOHONAN</div>
        
        <div class="mb-3">
            <label class="form-label-print">Tujuan Permohonan / Masalah Dihadapi:</label>
            <div class="form-line" contenteditable="true" style="min-height: 80px;"></div>
            <div class="form-line" contenteditable="true"></div>
        </div>

        <div class="mb-3">
            <label class="form-label-print">Anggaran Bantuan Diperlukan (RM / Bentuk Barang):</label>
            <div class="form-line" contenteditable="true"></div>
        </div>

        <div class="section-header">BAHAGIAN C: PENGAKUAN PEMOHON</div>
        <p class="text-justify fst-italic mb-4" style="font-size: 0.95rem;">
            "Saya dengan ini mengaku bahawa segala maklumat yang diberikan di atas adalah benar dan tepat. Saya faham bahawa pihak JKKK berhak menolak permohonan ini sekiranya didapati mana-mana maklumat adalah palsu atau tidak benar."
        </p>
        
        <div class="row mt-5 pt-4">
            <div class="col-6 text-center">
                <div style="border-bottom: 1px solid #000; height: 50px; width: 80%; margin: 0 auto 10px auto;"></div>
                <span class="fw-bold">Tandatangan Pemohon</span>
            </div>
            <div class="col-6 text-center">
                <div style="border-bottom: 1px solid #000; height: 50px; width: 80%; margin: 0 auto 10px auto;"></div>
                <span class="fw-bold">Tarikh</span>
            </div>
        </div>

        <div class="mt-5 pt-3 border-top border-dark border-2">
            <p class="fw-bold small m-0 text-uppercase">Untuk Kegunaan Pejabat JKKK Sahaja:</p>
            <div class="d-flex justify-content-between mt-2">
                <div class="border border-dark p-2" style="width: 150px; height: 80px;">
                    <small>Tarikh Terima:</small>
                </div>
                <div class="border border-dark p-2" style="width: 150px; height: 80px;">
                    <small>Cop Rasmi:</small>
                </div>
                <div class="border border-dark p-2" style="width: 150px; height: 80px;">
                    <small>Tandatangan:</small>
                </div>
            </div>
        </div>

        <div class="no-print mt-4 text-center text-muted small">
            * Sila simpan borang ini sebagai PDF dan muat naik semula di sistem MyKampung untuk pemprosesan.
        </div>
    </div>

    <script>
        function cetakDanRedirect() {
            // 1. Buka dialog print browser
            window.print();

            // 2. Lepas user tutup dialog, redirect ke SERVLET
            setTimeout(function() {
                if(confirm("Adakah anda sudah menyimpan borang ini sebagai PDF? Tekan OK untuk kembali ke halaman utama.")) {
                    window.location.href = "<%= request.getContextPath() %>/bantuan/komuniti";
                }
            }, 1000);
        }
    </script>
</body>
</html>