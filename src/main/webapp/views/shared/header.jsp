<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RDV Medical</title>
    <!-- FontAwesome pour les icônes modernes -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ===== VARIABLES CSS (thème clair par défaut) ===== */
        :root {
            --primary: #0d6efd;
            --primary-dark: #0a58ca;
            --primary-light: #e8f0fe;
            --secondary: #6c757d;
            --success: #198754;
            --success-light: #e6f4ea;
            --danger: #dc3545;
            --danger-light: #fce8e6;
            --warning: #ffc107;
            --warning-light: #fff3e0;
            
            --bg-primary: #f5f7fa;
            --bg-card: #ffffff;
            --bg-sidebar: #ffffff;
            --bg-header: #ffffff;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --border-color: #e2e8f0;
            --border-light: #f1f5f9;
            --shadow-color: rgba(0,0,0,0.04);
            --shadow-hover: rgba(0,0,0,0.08);
            --hover-bg: #f1f5f9;
            
            --sidebar-header-bg: linear-gradient(135deg, #0d6efd, #0a58ca);
            --skeleton-base: #e2e8f0;
            --skeleton-highlight: #f1f5f9;
            
            --border-radius-sm: 0.5rem;
            --border-radius: 0.75rem;
            --border-radius-lg: 1rem;
            --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
            --shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* ===== THÈME SOMBRE ===== */
        body.dark-mode {
            --bg-primary: #0f172a;
            --bg-card: #1e293b;
            --bg-sidebar: #0f172a;
            --bg-header: #1e293b;
            --text-primary: #f1f5f9;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --border-color: #334155;
            --border-light: #1e293b;
            --shadow-color: rgba(0,0,0,0.3);
            --shadow-hover: rgba(0,0,0,0.4);
            --hover-bg: #334155;
            
            --sidebar-header-bg: linear-gradient(135deg, #0d6efd, #0a58ca);
            --skeleton-base: #334155;
            --skeleton-highlight: #475569;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            overflow-x: hidden;
            transition: background 0.3s ease, color 0.3s ease;
        }

        /* ===== SKELETON LOADER ===== */
        .skeleton {
            background: linear-gradient(90deg, var(--skeleton-base) 25%, var(--skeleton-highlight) 50%, var(--skeleton-base) 75%);
            background-size: 200% 100%;
            animation: skeletonLoading 0.8s infinite ease-in-out;
            border-radius: 8px;
        }

        @keyframes skeletonLoading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        .skeleton-text {
            height: 16px;
            margin: 8px 0;
            border-radius: 4px;
        }

        .skeleton-title {
            height: 24px;
            width: 60%;
            border-radius: 6px;
        }

        .skeleton-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }

        .skeleton-card {
            padding: 20px;
            background: var(--bg-card);
            border-radius: 12px;
            margin-bottom: 20px;
        }

        .skeleton-stat {
            height: 80px;
            width: 100%;
            border-radius: 12px;
        }

        .content-loaded {
            display: block;
        }

        .skeleton-container {
            display: none;
        }

        body.loading .content-loaded {
            display: none;
        }

        body.loading .skeleton-container {
            display: block;
        }

        /* ===== LAYOUT PRINCIPAL ===== */
        .app-wrapper {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* ===== SIDEBAR MODERN ===== */
        .sidebar {
            width: 280px;
            background: var(--bg-sidebar);
            box-shadow: var(--shadow-lg);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 1000;
            overflow-y: auto;
            flex-shrink: 0;
            transform: translateX(-100%);
            border-right: 1px solid var(--border-color);
        }

        .sidebar::-webkit-scrollbar {
            width: 5px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: var(--border-color);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 5px;
        }

        .sidebar.visible {
            transform: translateX(0);
        }

        @media (min-width: 769px) {
            .sidebar {
                transform: translateX(0);
            }
        }

        .sidebar-header {
            padding: 28px 24px;
            background: var(--sidebar-header-bg);
            color: white;
            text-align: center;
            transition: var(--transition);
            flex-shrink: 0;
        }

        .sidebar-header h3 {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
            letter-spacing: -0.5px;
        }

        .sidebar-header h3 i {
            margin-right: 8px;
        }

        .sidebar-header p {
            font-size: 0.7rem;
            opacity: 0.85;
            margin-top: 5px;
        }

        .sidebar-nav {
            flex: 1;
            padding: 20px 12px;
            overflow-y: auto;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            margin-bottom: 4px;
            color: var(--text-primary);
            text-decoration: none;
            transition: var(--transition);
            border-radius: var(--border-radius);
            font-size: 0.9rem;
            font-weight: 500;
            position: relative;
        }

        .sidebar-link:hover {
            background: var(--hover-bg);
            color: var(--primary);
            transform: translateX(4px);
        }

        .sidebar-icon {
            font-size: 1.2rem;
            width: 24px;
            text-align: center;
            flex-shrink: 0;
            color: var(--primary);
        }

        .sidebar-text {
            font-size: 0.85rem;
            font-weight: 500;
        }

        .sidebar-divider {
            height: 1px;
            background: var(--border-color);
            margin: 16px 16px;
        }

        /* ===== CONTENU PRINCIPAL ===== */
        .main-content {
            flex: 1;
            min-height: 100vh;
            background: var(--bg-primary);
            transition: margin-left 0.3s ease-in-out;
            width: 100%;
        }

        @media (min-width: 769px) {
            .main-content {
                margin-left: 280px;
                width: calc(100% - 280px);
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card, .stat-card {
            animation: fadeInUp 0.3s ease-out forwards;
        }

        /* ===== HEADER MODERN ===== */
        .content-header {
            background: var(--bg-header);
            backdrop-filter: blur(10px);
            padding: 16px 32px;
            box-shadow: var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            position: sticky;
            top: 0;
            z-index: 99;
            border-bottom: 1px solid var(--border-color);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .menu-toggle-btn {
            background: var(--hover-bg);
            border: none;
            color: var(--primary);
            font-size: 1.3rem;
            cursor: pointer;
            width: 42px;
            height: 42px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        @media (min-width: 769px) {
            .menu-toggle-btn {
                display: none;
            }
        }

        .menu-toggle-btn:hover {
            background: var(--primary);
            color: white;
            transform: scale(1.05);
        }

        .dark-mode-toggle {
            background: var(--hover-bg);
            border: none;
            color: var(--primary);
            font-size: 1.2rem;
            cursor: pointer;
            width: 42px;
            height: 42px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .dark-mode-toggle:hover {
            background: var(--primary);
            color: white;
            transform: scale(1.05) rotate(15deg);
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .logo h1 {
            font-size: 1.35rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .logo h1 i {
            background: none;
            -webkit-background-clip: unset;
            background-clip: unset;
            color: var(--primary);
            margin-right: 8px;
        }

        .logo p {
            font-size: 0.7rem;
            color: var(--text-secondary);
            margin-top: 2px;
        }

        .header-right {
            text-align: right;
        }

        .user-name {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .user-name i {
            color: var(--primary);
            margin-right: 6px;
        }

        .date-area {
            font-size: 0.7rem;
            color: var(--text-secondary);
        }

        .date-area i {
            margin-right: 4px;
            font-size: 0.65rem;
        }

        /* ===== CONTAINER ===== */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 32px 50px;
        }

        /* ===== CARTES ===== */
        .card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 24px;
            box-shadow: var(--shadow);
            margin-bottom: 24px;
            transition: var(--transition);
            border: 1px solid var(--border-color);
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .card-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-title i {
            font-size: 1.1rem;
        }

        .stat-card {
            background: var(--bg-card);
            border-radius: var(--border-radius);
            padding: 24px;
            text-align: center;
            transition: var(--transition);
            cursor: pointer;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary);
        }

        .stat-card .stat-icon {
            font-size: 2.2rem;
            margin-bottom: 12px;
            transition: var(--transition);
        }

        .stat-card:hover .stat-icon {
            transform: scale(1.1);
        }

        .stat-card .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 4px;
        }

        .stat-card .stat-label {
            font-size: 0.8rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* ===== BOUTONS ===== */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 18px;
            border-radius: var(--border-radius-sm);
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn:hover {
            transform: translateY(-2px);
            filter: brightness(1.05);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-primary { background: var(--primary); color: white; }
        .btn-success { background: var(--success); color: white; }
        .btn-danger { background: var(--danger); color: white; }
        .btn-warning { background: var(--warning); color: #333; }
        .btn-secondary { background: var(--secondary); color: white; }

        /* ===== TABLEAUX ===== */
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.85rem;
        }
        th {
            background: var(--hover-bg);
            color: var(--primary);
            padding: 12px 14px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 11px 14px;
            border-bottom: 1px solid var(--border-light);
            transition: var(--transition);
        }
        tr:hover td {
            background: var(--hover-bg);
        }

        /* ===== FORMULAIRES ===== */
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius-sm);
            font-size: 0.85rem;
            background: var(--bg-card);
            color: var(--text-primary);
            transition: var(--transition);
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(13,110,253,0.1);
        }

        /* ===== ALERTES ===== */
        .alert {
            padding: 12px 16px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeInUp 0.3s ease-out;
        }
        .alert-danger {
            background: var(--danger-light);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }
        .alert-success {
            background: var(--success-light);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        /* ===== BADGES ===== */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .badge-success { background: var(--success-light); color: var(--success); }
        .badge-danger { background: var(--danger-light); color: var(--danger); }

        /* ===== TOP 5 MÉDECINS ===== */
        .top5-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 14px;
            border-radius: var(--border-radius);
            margin-bottom: 10px;
            transition: var(--transition);
            cursor: pointer;
            background: var(--bg-card);
            border: 1px solid var(--border-color);
        }

        .top5-card:hover {
            transform: translateX(6px);
            border-color: var(--primary);
            box-shadow: var(--shadow);
        }

        .medal {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            font-weight: 700;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        /* ===== LOADER ===== */
        .fullscreen-loader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--bg-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .fullscreen-loader.hidden {
            opacity: 0;
            visibility: hidden;
        }

        .loader-spinner {
            width: 45px;
            height: 45px;
            border: 3px solid var(--border-color);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 0.5s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Overlay mobile */
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            display: none;
        }

        .sidebar-overlay.visible {
            display: block;
        }

        @media (min-width: 769px) {
            .sidebar-overlay {
                display: none !important;
            }
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: var(--border-color);
            border-radius: 3px;
        }
        ::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 3px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px 16px 30px;
            }
            .content-header {
                padding: 12px 20px;
            }
            .logo h1 {
                font-size: 1rem;
            }
            .logo p {
                display: none;
            }
            .dark-mode-toggle, .menu-toggle-btn {
                width: 38px;
                height: 38px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>

<!-- Fullscreen Loader -->
<div class="fullscreen-loader" id="fullscreenLoader">
    <div class="loader-spinner"></div>
</div>

<!-- Overlay pour mobile -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="app-wrapper">

    <!-- SIDEBAR MODERN -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-hospital-user"></i> RDV Medical</h3>
            <p>Plateforme médicale</p>
        </div>

        <div class="sidebar-nav">
            <c:choose>
                <c:when test="${sessionScope.role == 'patient'}">
                    <a href="${pageContext.request.contextPath}/patient?action=dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
                        <span class="sidebar-text">Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/search" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-search"></i></span>
                        <span class="sidebar-text">Trouver un médecin</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/rdv?action=liste" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-calendar-alt"></i></span>
                        <span class="sidebar-text">Mes rendez-vous</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/calendar" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-calendar-week"></i></span>
                        <span class="sidebar-text">Calendrier</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=top5" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-trophy"></i></span>
                        <span class="sidebar-text">Top 5 médecins</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.idUtilisateur}" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-user-circle"></i></span>
                        <span class="sidebar-text">Mon profil</span>
                    </a>
                </c:when>
                
                <c:when test="${sessionScope.role == 'medecin'}">
                    <a href="${pageContext.request.contextPath}/medecin?action=dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
                        <span class="sidebar-text">Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/rdv?action=liste" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-calendar-alt"></i></span>
                        <span class="sidebar-text">Mes rendez-vous</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/calendar" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-calendar-week"></i></span>
                        <span class="sidebar-text">Calendrier</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=liste" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                        <span class="sidebar-text">Liste des patients</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=mesPatients" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-user-friends"></i></span>
                        <span class="sidebar-text">Mes patients</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=top5" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-trophy"></i></span>
                        <span class="sidebar-text">Top 5 médecins</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${sessionScope.idUtilisateur}" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fas fa-cog"></i></span>
                        <span class="sidebar-text">Mon profil</span>
                    </a>
                </c:when>
            </c:choose>

            <div class="sidebar-divider"></div>

            <a href="${pageContext.request.contextPath}/auth?action=logout" class="sidebar-link">
                <span class="sidebar-icon"><i class="fas fa-sign-out-alt"></i></span>
                <span class="sidebar-text">Déconnexion</span>
            </a>
        </div>
    </div>

    <!-- CONTENU PRINCIPAL -->
    <div class="main-content" id="mainContent">

        <!-- HEADER MODERN -->
        <div class="content-header">
            <div class="header-left">
                <button class="menu-toggle-btn" id="menuToggleBtn"><i class="fas fa-bars"></i></button>
                <div class="logo">
                    <h1><i class="fas fa-stethoscope"></i> RDV Medical</h1>
                    <p>Plateforme de rendez-vous médicaux</p>
                </div>
            </div>
            <div class="header-actions">
                <button class="dark-mode-toggle" id="darkModeToggleBtn" title="Thème sombre/clair"><i class="fas fa-moon"></i></button>
                <div class="header-right">
                    <div class="user-name">
                        <i class="fas fa-user-circle"></i>
                        <c:choose>
                            <c:when test="${sessionScope.role == 'patient'}">
                                ${sessionScope.utilisateur.nomPat}
                            </c:when>
                            <c:when test="${sessionScope.role == 'medecin'}">
                                Dr. ${sessionScope.utilisateur.nommed}
                            </c:when>
                            <c:otherwise>
                                Invité
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="date-area">
                        <i class="far fa-calendar-alt"></i>
                        <script>
                            const jours = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
                            const mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
                            const date = new Date();
                            document.write(jours[date.getDay()] + ' ' + date.getDate() + ' ' + mois[date.getMonth()] + ' ' + date.getFullYear());
                        </script>
                    </div>
                </div>
            </div>
        </div>

<script>
    // ===== FERMER LE LOADER =====
    (function() {
        const loader = document.getElementById('fullscreenLoader');
        if (loader) {
            setTimeout(function() {
                loader.classList.add('hidden');
            }, 300);
        }
    })();

    // ===== DARK MODE TOGGLE =====
    const darkModeToggle = document.getElementById('darkModeToggleBtn');
    const body = document.body;

    const savedTheme = localStorage.getItem('darkMode');
    if (savedTheme === 'enabled') {
        body.classList.add('dark-mode');
        if (darkModeToggle) darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
    } else {
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            body.classList.add('dark-mode');
            if (darkModeToggle) darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            localStorage.setItem('darkMode', 'enabled');
        }
    }

    function toggleDarkMode() {
        if (body.classList.contains('dark-mode')) {
            body.classList.remove('dark-mode');
            if (darkModeToggle) darkModeToggle.innerHTML = '<i class="fas fa-moon"></i>';
            localStorage.setItem('darkMode', 'disabled');
        } else {
            body.classList.add('dark-mode');
            if (darkModeToggle) darkModeToggle.innerHTML = '<i class="fas fa-sun"></i>';
            localStorage.setItem('darkMode', 'enabled');
        }
    }

    if (darkModeToggle) {
        darkModeToggle.addEventListener('click', toggleDarkMode);
    }

    // ===== SIDEBAR TOGGLE =====
    let sidebarVisible = false;
    const sidebar = document.getElementById('sidebar');
    const menuToggleBtn = document.getElementById('menuToggleBtn');
    const sidebarOverlay = document.getElementById('sidebarOverlay');

    if (window.innerWidth >= 769) {
        sidebarVisible = true;
        sidebar.classList.add('visible');
    } else {
        const savedSidebarState = localStorage.getItem('sidebarVisible');
        if (savedSidebarState === 'true') {
            sidebarVisible = true;
            sidebar.classList.add('visible');
        }
    }

    function toggleSidebar() {
        sidebarVisible = !sidebarVisible;
        if (sidebarVisible) {
            sidebar.classList.add('visible');
            if (sidebarOverlay) sidebarOverlay.classList.add('visible');
            localStorage.setItem('sidebarVisible', 'true');
        } else {
            sidebar.classList.remove('visible');
            if (sidebarOverlay) sidebarOverlay.classList.remove('visible');
            localStorage.setItem('sidebarVisible', 'false');
        }
    }

    if (menuToggleBtn) {
        menuToggleBtn.addEventListener('click', toggleSidebar);
    }

    if (sidebarOverlay) {
        sidebarOverlay.addEventListener('click', toggleSidebar);
    }

    window.addEventListener('resize', function() {
        if (window.innerWidth >= 769) {
            sidebar.classList.add('visible');
            if (sidebarOverlay) sidebarOverlay.classList.remove('visible');
            sidebarVisible = true;
        } else {
            if (!sidebarVisible) {
                sidebar.classList.remove('visible');
                if (sidebarOverlay) sidebarOverlay.classList.remove('visible');
            }
        }
    });

    document.querySelectorAll('.sidebar-link').forEach(link => {
        link.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                sidebar.classList.remove('visible');
                if (sidebarOverlay) sidebarOverlay.classList.remove('visible');
                sidebarVisible = false;
                localStorage.setItem('sidebarVisible', 'false');
            }
        });
    });
</script>

</body>
</html>