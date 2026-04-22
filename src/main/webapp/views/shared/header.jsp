<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RDV Medical</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f0f4f8;
            color: #333;
            overflow-x: hidden;
        }

        /* ===== LAYOUT PRINCIPAL FLEXBOX ===== */
        .app-wrapper {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* ===== SIDEBAR (colonne de gauche) - CACHÉ PAR DÉFAUT ===== */
        .sidebar {
            width: 280px;
            background: white;
            box-shadow: 2px 0 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease-in-out;
            display: flex;
            flex-direction: column;
            position: relative;
            z-index: 100;
            flex-shrink: 0;
            overflow-x: hidden;
            margin-left: -280px;
        }

        /* Sidebar visible */
        .sidebar.visible {
            margin-left: 0;
        }

        .sidebar-header {
            padding: 25px 20px;
            background: linear-gradient(135deg, #1a73e8, #0d47a1);
            color: white;
            text-align: center;
        }

        .sidebar-header h3 {
            font-size: 18px;
        }

        .sidebar-header p {
            font-size: 11px;
            opacity: 0.85;
            margin-top: 5px;
        }

        .sidebar-nav {
            flex: 1;
            padding: 20px 0;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            transition: all 0.2s;
            border-left: 4px solid transparent;
            white-space: nowrap;
        }

        .sidebar-link:hover {
            background: #e8f0fe;
            border-left-color: #1a73e8;
        }

        .sidebar-icon {
            font-size: 22px;
            width: 30px;
            text-align: center;
            flex-shrink: 0;
        }

        .sidebar-text {
            font-size: 14px;
            font-weight: 500;
        }

        .sidebar-divider {
            height: 1px;
            background: #eef2f7;
            margin: 15px 20px;
        }

        /* ===== CONTENU PRINCIPAL (colonne de droite) ===== */
        .main-content {
            flex: 1;
            transition: margin-left 0.3s ease-in-out;
            background: #f0f4f8;
            min-height: 100vh;
            overflow-x: auto;
        }

        /* ===== HEADER DANS LE CONTENU ===== */
        .content-header {
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            color: white;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* Bouton HOME (menu toggle) dans le header */
        .menu-toggle-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            font-size: 28px;
            cursor: pointer;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .menu-toggle-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: scale(1.05);
        }

        .logo h1 {
            font-size: 24px;
            font-weight: 700;
        }

        .logo p {
            font-size: 12px;
            opacity: 0.85;
            margin-top: 4px;
        }

        .header-right {
            text-align: right;
        }

        .user-name {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .date-area {
            font-size: 12px;
            opacity: 0.85;
        }

        /* ===== CONTAINER ===== */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 25px 40px;
        }

        /* ===== CARTES ===== */
        .card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }
        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a73e8;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e8f0fe;
        }

        /* ===== BOUTONS ===== */
        .btn {
            display: inline-block;
            padding: 9px 18px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn:hover { opacity: 0.85; }
        .btn-primary { background: #1a73e8; color: white; }
        .btn-success { background: #34a853; color: white; }
        .btn-danger { background: #ea4335; color: white; }
        .btn-warning { background: #fbbc04; color: #333; }
        .btn-secondary { background: #6c757d; color: white; }

        /* ===== TABLEAUX ===== */
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        th {
            background: #e8f0fe;
            color: #1a73e8;
            padding: 12px 14px;
            text-align: left;
            font-weight: 600;
        }
        td {
            padding: 11px 14px;
            border-bottom: 1px solid #f0f4f8;
        }
        tr:hover td { background: #f8faff; }

        /* ===== FORMULAIRES ===== */
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
        }

        /* ===== ALERTES ===== */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        .alert-danger {
            background: #fce8e6;
            color: #c5221f;
            border-left: 4px solid #ea4335;
        }
        .alert-success {
            background: #e6f4ea;
            color: #137333;
            border-left: 4px solid #34a853;
        }

        /* ===== BADGES ===== */
        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success { background: #e6f4ea; color: #137333; }
        .badge-danger { background: #fce8e6; color: #c5221f; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
                margin-left: -280px;
            }
            .sidebar.visible {
                margin-left: 0;
            }
            .container {
                padding: 0 15px 30px;
            }
            .content-header {
                padding: 15px 20px;
            }
            .logo h1 {
                font-size: 18px;
            }
            .logo p {
                display: none;
            }
            .menu-toggle-btn {
                width: 42px;
                height: 42px;
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<div class="app-wrapper">

    <!-- SIDEBAR (colonne gauche) - CACHÉ PAR DÉFAUT -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>🏥 RDV Medical</h3>
            <p>Plateforme médicale</p>
        </div>

        <div class="sidebar-nav">
            <c:choose>
               <c:when test="${sessionScope.role == 'patient'}">
                   <a href="${pageContext.request.contextPath}/patient?action=dashboard" class="sidebar-link">
                       <span class="sidebar-icon">🏠</span>
                       <span class="sidebar-text">Dashboard</span>
                   </a>
                   <a href="${pageContext.request.contextPath}/search" class="sidebar-link">
                       <span class="sidebar-icon">🔍</span>
                       <span class="sidebar-text">Trouver un médecin</span>
                   </a>
                   <a href="${pageContext.request.contextPath}/rdv?action=liste" class="sidebar-link">
                       <span class="sidebar-icon">📋</span>
                       <span class="sidebar-text">Mes rendez-vous</span>
                   </a>
                   <a href="${pageContext.request.contextPath}/patient?action=top5" class="sidebar-link">
                       <span class="sidebar-icon">🏆</span>
                       <span class="sidebar-text">Top 5 médecins</span>
                   </a>
                   <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.idUtilisateur}" class="sidebar-link">
                       <span class="sidebar-icon">👤</span>
                       <span class="sidebar-text">Mon profil</span>
                   </a>
               </c:when>
                <c:when test="${sessionScope.role == 'medecin'}">
                    <a href="${pageContext.request.contextPath}/medecin?action=dashboard" class="sidebar-link">
                        <span class="sidebar-icon">🏠</span>
                        <span class="sidebar-text">Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/rdv?action=liste" class="sidebar-link">
                        <span class="sidebar-icon">📋</span>
                        <span class="sidebar-text">Mes rendez-vous</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=liste" class="sidebar-link">
                        <span class="sidebar-icon">👥</span>
                        <span class="sidebar-text">Mes patients</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=top5" class="sidebar-link">
                        <span class="sidebar-icon">🏆</span>
                        <span class="sidebar-text">Top 5 médecins</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${sessionScope.idUtilisateur}" class="sidebar-link">
                        <span class="sidebar-icon">⚙️</span>
                        <span class="sidebar-text">Mon profil</span>
                    </a>
                </c:when>
            </c:choose>

            <div class="sidebar-divider"></div>

            <a href="${pageContext.request.contextPath}/auth?action=logout" class="sidebar-link">
                <span class="sidebar-icon">🔓</span>
                <span class="sidebar-text">Déconnexion</span>
            </a>
        </div>
    </div>

    <!-- CONTENU PRINCIPAL (colonne droite) -->
    <div class="main-content" id="mainContent">

        <!-- Header dans le contenu avec le bouton HOME -->
        <div class="content-header">
            <div class="header-left">
                <button class="menu-toggle-btn" id="menuToggleBtn">☰</button>
                <div class="logo">
                    <h1>🏥 RDV Medical</h1>
                    <p>Plateforme de rendez-vous médicaux</p>
                </div>
            </div>
            <div class="header-right">
                <div class="user-name">
                    👋
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
                    <script>
                        const jours = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'];
                        const mois = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
                        const date = new Date();
                        document.write(jours[date.getDay()] + ' ' + date.getDate() + ' ' + mois[date.getMonth()] + ' ' + date.getFullYear());
                    </script>
                </div>
            </div>
        </div>

<script>
    // État du sidebar (visible ou caché)
    let sidebarVisible = false;
    const sidebar = document.getElementById('sidebar');
    const menuToggleBtn = document.getElementById('menuToggleBtn');

    // Fonction pour ouvrir/fermer le sidebar
    function toggleSidebar() {
        sidebarVisible = !sidebarVisible;
        if (sidebarVisible) {
            sidebar.classList.add('visible');
            localStorage.setItem('sidebarVisible', 'true');
        } else {
            sidebar.classList.remove('visible');
            localStorage.setItem('sidebarVisible', 'false');
        }
    }

    // Charger l'état sauvegardé au chargement
    const savedState = localStorage.getItem('sidebarVisible');
    if (savedState === 'true') {
        sidebarVisible = true;
        sidebar.classList.add('visible');
    } else {
        sidebarVisible = false;
        sidebar.classList.remove('visible');
    }

    // Événement du bouton HOME (menu toggle)
    if (menuToggleBtn) {
        menuToggleBtn.addEventListener('click', toggleSidebar);
    }

    // Sur mobile, quand on clique sur un lien, fermer le sidebar automatiquement
    document.querySelectorAll('.sidebar-link').forEach(link => {
        link.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                sidebar.classList.remove('visible');
                sidebarVisible = false;
                localStorage.setItem('sidebarVisible', 'false');
            }
        });
    });

    // Fermer le sidebar si on clique en dehors (optionnel, pour meilleure UX)
    document.addEventListener('click', function(event) {
        if (sidebarVisible && window.innerWidth <= 768) {
            if (!sidebar.contains(event.target) && event.target !== menuToggleBtn && !menuToggleBtn.contains(event.target)) {
                sidebar.classList.remove('visible');
                sidebarVisible = false;
                localStorage.setItem('sidebarVisible', 'false');
            }
        }
    });
</script>

</body>
</html>