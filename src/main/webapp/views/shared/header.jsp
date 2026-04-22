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
        }

        /* ===== HEADER MODERNE PLUS GRAND ===== */
        .modern-header {
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            color: white;
            padding: 25px 40px;
            margin-bottom: 35px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .header-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .menu-toggle-btn {
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            font-size: 28px;
            cursor: pointer;
            width: 50px;
            height: 50px;
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
            font-size: 28px;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .logo p {
            font-size: 13px;
            opacity: 0.85;
            margin-top: 4px;
        }
        .header-right {
            text-align: right;
        }
        .user-name {
            font-size: 18px;
            font-weight: 500;
            margin-bottom: 6px;
        }
        .date-area {
            font-size: 13px;
            opacity: 0.85;
        }

        /* ===== MENU LATÉRAL ===== */
        .sidebar-menu {
            position: fixed;
            left: -300px;
            top: 0;
            width: 300px;
            height: 100%;
            background: white;
            box-shadow: 2px 0 20px rgba(0,0,0,0.1);
            transition: left 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
        }
        .sidebar-menu.open {
            left: 0;
        }
        .sidebar-header {
            padding: 30px 20px;
            background: linear-gradient(135deg, #1a73e8, #0d47a1);
            color: white;
            text-align: center;
        }
        .sidebar-header h3 {
            margin: 0;
            font-size: 22px;
        }
        .sidebar-header p {
            margin: 8px 0 0;
            font-size: 13px;
            opacity: 0.85;
        }
        .sidebar-nav {
            padding: 20px 0;
        }
        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 14px 25px;
            color: #333;
            text-decoration: none;
            transition: all 0.2s;
            border-left: 4px solid transparent;
            font-size: 15px;
        }
        .sidebar-link:hover {
            background: #e8f0fe;
            border-left-color: #1a73e8;
        }
        .sidebar-icon {
            font-size: 24px;
            width: 32px;
            text-align: center;
        }
        .sidebar-text {
            font-size: 15px;
        }
        .sidebar-divider {
            height: 1px;
            background: #eef2f7;
            margin: 15px 25px;
        }
        .close-sidebar {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .close-sidebar:hover {
            background: rgba(255,255,255,0.3);
        }

        /* ===== OVERLAY ===== */
        .menu-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
            display: none;
        }
        .menu-overlay.active {
            display: block;
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
        .btn:hover {
            opacity: 0.85;
        }
        .btn-primary {
            background: #1a73e8;
            color: white;
        }
        .btn-success {
            background: #34a853;
            color: white;
        }
        .btn-danger {
            background: #ea4335;
            color: white;
        }
        .btn-warning {
            background: #fbbc04;
            color: #333;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }

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
        tr:hover td {
            background: #f8faff;
        }

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
            transition: border-color 0.2s;
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
        .badge-success {
            background: #e6f4ea;
            color: #137333;
        }
        .badge-danger {
            background: #fce8e6;
            color: #c5221f;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .modern-header {
                padding: 18px 25px;
            }
            .logo h1 {
                font-size: 22px;
            }
            .menu-toggle-btn {
                width: 42px;
                height: 42px;
                font-size: 24px;
            }
            .user-name {
                font-size: 15px;
            }
            .container {
                padding: 0 15px 30px;
            }
            .sidebar-menu {
                width: 260px;
            }
        }
    </style>
</head>
<body>

<!-- Header moderne plus grand -->
<div class="modern-header">
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

<!-- Overlay -->
<div class="menu-overlay" id="menuOverlay"></div>

<!-- Menu latéral -->
<div class="sidebar-menu" id="sidebarMenu">
    <div class="sidebar-header">
        <button class="close-sidebar" id="closeSidebarBtn">✕</button>
        <h3>🏥 RDV Medical</h3>
        <p>Navigation rapide</p>
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

<script>
    const menuBtn = document.getElementById('menuToggleBtn');
    const sidebar = document.getElementById('sidebarMenu');
    const overlay = document.getElementById('menuOverlay');
    const closeBtn = document.getElementById('closeSidebarBtn');

    function openMenu() {
        sidebar.classList.add('open');
        overlay.classList.add('active');
    }

    function closeMenu() {
        sidebar.classList.remove('open');
        overlay.classList.remove('active');
    }

    if (menuBtn) menuBtn.addEventListener('click', openMenu);
    if (overlay) overlay.addEventListener('click', closeMenu);
    if (closeBtn) closeBtn.addEventListener('click', closeMenu);

    document.querySelectorAll('.sidebar-link').forEach(link => {
        link.addEventListener('click', closeMenu);
    });
</script>

</body>
</html>