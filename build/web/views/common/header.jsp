<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Papan Pemuka - Kampung Danan</title>
    <script src="https://cdn.tailwindcss.com"></script>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Plus Jakarta Sans"', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            purple: '#6C5DD3', /* Warna Utama seperti dalam gambar */
                            light: '#F7F7F9'
                        }
                    }
                }
            }
        }
    </script>

    <style>
        /* CSS Reset Minimal */
        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #F7F7F9; }
        
        /* Custom Scrollbar untuk nampak kemas */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #E2E8F0; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #CBD5E1; }
    </style>
</head>
<body class="bg-[#F7F7F9] text-gray-800">
    <div class="flex h-screen overflow-hidden">