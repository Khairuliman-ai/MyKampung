<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Papan Pemuka - Kampung Danan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { background-color: #f0f2f5; font-family: 'Inter', sans-serif; color: #334155; }
        .sidebar { width: 260px; height: 100vh; position: fixed; background: #ffffff; border-right: 1px solid #e2e8f0; padding: 24px 0; }
        .sidebar-brand { padding: 0 24px 32px; display: flex; align-items: center; gap: 12px; }
        .brand-logo { background: #10b981; color: white; padding: 8px; border-radius: 8px; display: flex; align-items: center; justify-content: center; }
        .nav-link { padding: 12px 24px; color: #64748b; display: flex; align-items: center; font-weight: 500; margin: 4px 16px; border-radius: 8px; transition: all 0.2s; }
        .nav-link i { margin-right: 14px; font-size: 1.2rem; }
        .nav-link:hover { background-color: #f1f5f9; color: #10b981; }
        .nav-link.active { background: #ecfdf5; color: #10b981; }
        .main-content { margin-left: 260px; min-height: 100vh; }
        .top-bar { background: #ffffff; padding: 16px 40px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 100; }
        .search-container { position: relative; width: 350px; }
        .search-container i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8; }
        .search-input { background: #f8fafc; border: 1px solid #e2e8f0; padding: 8px 15px 8px 40px; border-radius: 10px; width: 100%; outline: none; transition: 0.3s; }
        .search-input:focus { border-color: #10b981; box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }
        .stat-card { border: none; border-radius: 16px; padding: 24px; background: #ffffff; box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); }
        .icon-box { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 16px; }
        .bg-penduduk { background: #ecfdf5; color: #10b981; }
        .bg-acara { background: #eff6ff; color: #3b82f6; }
        .bg-kemudahan { background: #f5f3ff; color: #8b5cf6; }
        .bg-aduan { background: #fff7ed; color: #f97316; }
        .trend-up { color: #10b981; font-size: 0.85rem; font-weight: 600; }
        .trend-down { color: #ef4444; font-size: 0.85rem; font-weight: 600; }
        .card-title { color: #64748b; font-size: 0.9rem; font-weight: 500; margin-bottom: 4px; }
        .card-value { font-size: 1.75rem; font-weight: 700; color: #1e293b; }
        .badge-soft-success { background: #dcfce7; color: #15803d; }
        .badge-soft-warning { background: #fef9c3; color: #854d0e; }
        .section-card { background: #fff; border-radius: 16px; border: none; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
