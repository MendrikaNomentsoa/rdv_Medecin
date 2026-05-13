<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<!-- FontAwesome pour les icônes professionnelles -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
    :root {
        --primary: #0d6efd;
        --primary-dark: #0a58ca;
        --secondary: #6c757d;
        --success: #198754;
        --warning: #ffc107;
        --danger: #dc3545;
        --info: #0dcaf0;
        --dark: #212529;
        --light: #f8f9fa;
        --white: #ffffff;
        --gray-100: #f8f9fa;
        --gray-200: #e9ecef;
        --gray-300: #dee2e6;
        --gray-400: #ced4da;
        --gray-500: #adb5bd;
        --gray-600: #6c757d;
        --gray-700: #495057;
        --gray-800: #343a40;
        --gray-900: #212529;
        --shadow-sm: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        --shadow: 0 0.5rem 1rem rgba(0,0,0,0.08);
        --shadow-lg: 0 1rem 3rem rgba(0,0,0,0.1);
        --border-radius: 0.75rem;
        --border-radius-lg: 1rem;
        --transition: all 0.2s ease-in-out;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        background: linear-gradient(135deg, #f0f4f8 0%, #e2e8f0 100%);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    .container {
        max-width: 1400px;
        margin: 2rem auto;
        padding: 0 1.5rem;
    }

    /* Cartes modernes */
    .card {
        background: var(--white);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow);
        padding: 1.5rem;
        transition: var(--transition);
        border: 1px solid rgba(0,0,0,0.05);
    }

    .card:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg);
    }

    .card-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1.25rem;
        color: var(--gray-800);
        display: flex;
        align-items: center;
        gap: 0.5rem;
        border-left: 3px solid var(--primary);
        padding-left: 0.75rem;
    }

    .card-title i {
        color: var(--primary);
        font-size: 1.1rem;
    }

    /* Bannière de bienvenue */
    .welcome-banner {
        background: linear-gradient(135deg, #1e7e34 0%, #0d5c1e 100%);
        border-radius: var(--border-radius-lg);
        padding: 2rem;
        margin-bottom: 2rem;
        color: white;
        position: relative;
        overflow: hidden;
    }

    .welcome-banner::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 300px;
        height: 300px;
        background: rgba(255,255,255,0.05);
        border-radius: 50%;
        pointer-events: none;
    }

    .welcome-banner::after {
        content: '';
        position: absolute;
        bottom: -30%;
        left: -5%;
        width: 200px;
        height: 200px;
        background: rgba(255,255,255,0.03);
        border-radius: 50%;
        pointer-events: none;
    }

    .patient-info h2 {
        font-size: 1.75rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
    }

    .patient-stats {
        background: rgba(255,255,255,0.15);
        backdrop-filter: blur(10px);
        border-radius: var(--border-radius);
        padding: 1rem 1.5rem;
        text-align: center;
        min-width: 150px;
    }

    .patient-stats .stat-number {
        font-size: 2rem;
        font-weight: 700;
        line-height: 1;
    }

    /* Statistiques clés */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.25rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background: var(--white);
        border-radius: var(--border-radius);
        padding: 1.25rem;
        text-align: center;
        transition: var(--transition);
        border: 1px solid var(--gray-200);
        box-shadow: var(--shadow-sm);
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: var(--shadow);
        border-color: var(--primary);
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
        border-radius: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 0.75rem;
        color: white;
        font-size: 1.5rem;
    }

    .stat-number {
        font-size: 1.75rem;
        font-weight: 700;
        color: var(--gray-800);
        margin-bottom: 0.25rem;
    }

    .stat-label {
        font-size: 0.85rem;
        color: var(--gray-600);
        font-weight: 500;
    }

    /* Badges et alertes */
    .alert {
        padding: 1rem 1.25rem;
        border-radius: var(--border-radius);
        margin-bottom: 1.5rem;
        background: #d1e7dd;
        border-left: 4px solid var(--success);
        color: #0f5132;
    }

    .btn {
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        font-weight: 500;
        font-size: 0.875rem;
        transition: var(--transition);
        border: none;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 0.5rem;
        text-decoration: none;
    }

    .btn-primary {
        background: var(--primary);
        color: white;
    }

    .btn-primary:hover {
        background: var(--primary-dark);
        transform: translateY(-1px);
    }

    .btn-success {
        background: var(--success);
        color: white;
    }

    .btn-success:hover {
        background: #146c43;
        transform: translateY(-1px);
    }

    .btn-warning {
        background: var(--warning);
        color: #000;
    }

    .btn-danger {
        background: var(--danger);
        color: white;
    }

    .btn-secondary {
        background: var(--secondary);
        color: white;
    }

    .btn-sm {
        padding: 0.375rem 0.75rem;
        font-size: 0.75rem;
    }

    /* Prochain RDV */
    .next-appointment {
        background: linear-gradient(135deg, #f0f7ff 0%, #e8f0fe 100%);
        border-radius: var(--border-radius);
        padding: 1.25rem;
        border-left: 4px solid var(--primary);
    }

    .badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 2rem;
        font-size: 0.7rem;
        font-weight: 600;
    }

    .badge-success {
        background: #d1e7dd;
        color: #0f5132;
    }

    .badge-danger {
        background: #f8d7da;
        color: #842029;
    }

    /* Liste des consultations */
    .consultation-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.75rem 0;
        border-bottom: 1px solid var(--gray-200);
        transition: var(--transition);
    }

    .consultation-item:hover {
        background: var(--gray-100);
        padding-left: 0.5rem;
    }

    .consultation-doctor {
        font-weight: 600;
        color: var(--gray-800);
    }

    .consultation-specialty {
        font-size: 0.75rem;
        color: var(--gray-500);
    }

    .consultation-date {
        font-size: 0.75rem;
        color: var(--gray-600);
    }

    /* Actions rapides */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 0.75rem;
    }

    .quick-action-btn {
        text-align: center;
        padding: 0.75rem;
        border-radius: 0.5rem;
        background: var(--gray-100);
        color: var(--gray-700);
        text-decoration: none;
        transition: var(--transition);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        font-size: 0.85rem;
    }

    .quick-action-btn:hover {
        transform: translateY(-2px);
    }

    .quick-action-btn i {
        font-size: 1rem;
    }

    /* Grille responsive */
    .two-columns {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1.5rem;
    }

    @media (max-width: 768px) {
        .two-columns {
            grid-template-columns: 1fr;
        }
        .container {
            padding: 0 1rem;
            margin: 1rem auto;
        }
        .quick-actions {
            grid-template-columns: 1fr;
        }
    }

    /* Skeleton loader */
    .skeleton-container {
        animation: pulse 1.5s ease-in-out infinite;
    }

    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.6; }
    }

    .skeleton-card {
        background: var(--white);
        border-radius: var(--border-radius);
        padding: 1.5rem;
        margin-bottom: 1rem;
        box-shadow: var(--shadow-sm);
    }

    .skeleton-title {
        height: 24px;
        background: var(--gray-300);
        border-radius: 0.5rem;
        margin-bottom: 1rem;
    }

    .skeleton-text {
        height: 16px;
        background: var(--gray-300);
        border-radius: 0.25rem;
        margin-bottom: 0.75rem;
    }

    .skeleton-stat {
        height: 100px;
        background: var(--gray-300);
        border-radius: var(--border-radius);
    }
</style>

<div class="container" id="dashboardContent">
    <!-- SKELETON LOADER -->
    <div class="skeleton-container" id="skeletonDashboard">
        <div class="skeleton-card">
            <div class="skeleton-title" style="width: 40%;"></div>
            <div class="skeleton-text" style="width: 60%;"></div>
            <div class="skeleton-text" style="width: 80%;"></div>
        </div>
        <div class="stats-grid">
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
        </div>
        <div class="skeleton-card">
            <div class="skeleton-title" style="width: 30%;"></div>
            <div class="skeleton-text" style="width: 100%; height: 80px;"></div>
        </div>
    </div>

    <!-- CONTENU RÉEL -->
    <div class="content-loaded" id="realContent" style="display: none;">
        <c:if test="${not empty messageSucces}">
            <div class="alert">
                <i class="fas fa-check-circle"></i> ${messageSucces}
            </div>
        </c:if>

        <!-- Bannière de bienvenue patient -->
        <div class="welcome-banner">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <div class="patient-info">
                    <h2>
                        <i class="fas fa-user-circle"></i> Bonjour, ${sessionScope.utilisateur.nomPat}
                    </h2>
                    <div style="margin-top: 0.5rem;">
                        <span style="background: rgba(255,255,255,0.2); padding: 0.25rem 0.75rem; border-radius: 1rem; font-size: 0.8rem;">
                            <i class="fas fa-envelope"></i> ${sessionScope.utilisateur.email}
                        </span>
                    </div>
                    <p style="opacity: 0.9; font-size: 0.85rem; margin-top: 0.5rem;">
                        <i class="fas fa-heartbeat"></i> Bienvenue sur votre espace santé personnel
                    </p>
                </div>
                <div class="patient-stats">
                    <div class="stat-number">${nbRdvTotal}</div>
                    <div><i class="fas fa-calendar-alt"></i> Rendez-vous total</div>
                </div>
            </div>
        </div>

        <!-- Statistiques clés -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
                <div class="stat-number">${rdvAVenir}</div>
                <div class="stat-label">Rendez-vous à venir</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-check-double"></i></div>
                <div class="stat-number">${rdvPasses}</div>
                <div class="stat-label">Consultations effectuées</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-user-md"></i></div>
                <div class="stat-number">${nbMedecinsConsultes}</div>
                <div class="stat-label">Médecins consultés</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-chart-simple"></i></div>
                <div class="stat-number">${tauxAssiduite}%</div>
                <div class="stat-label">Taux d'assiduité</div>
            </div>
        </div>

        <!-- Prochain rendez-vous -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <h3 class="card-title">
                <i class="fas fa-clock"></i> Prochain rendez-vous
                <c:if test="${empty prochainRdv}">
                    <span style="font-size: 0.8rem; font-weight: normal; color: var(--gray-500); margin-left: 0.5rem;">Aucun RDV programmé</span>
                </c:if>
            </h3>

            <c:choose>
                <c:when test="${not empty prochainRdv}">
                    <div class="next-appointment">
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                            <div>
                                <div style="font-size: 1.1rem; font-weight: 600; color: var(--primary);">
                                    <i class="fas fa-stethoscope"></i> Dr. ${prochainRdv.medecin.nommed}
                                </div>
                                <div style="margin-top: 0.5rem;">
                                    <span class="badge badge-success">
                                        <i class="fas fa-graduation-cap"></i> ${prochainRdv.medecin.specialite}
                                    </span>
                                    <span style="color: var(--gray-600); font-size: 0.8rem; margin-left: 0.75rem;">
                                        <i class="fas fa-map-marker-alt"></i> ${prochainRdv.medecin.lieu}
                                    </span>
                                </div>
                                <div style="margin-top: 0.75rem;">
                                    <div style="font-size: 0.9rem; color: var(--gray-700);">
                                        <i class="far fa-calendar-alt"></i> ${prochainRdv.dateFormatee}
                                    </div>
                                    <div style="font-size: 0.8rem; color: var(--gray-500); margin-top: 0.25rem;">
                                        <i class="fas fa-money-bill-wave"></i> Taux horaire: ${prochainRdv.medecin.tauxHoraire} Ar/h
                                    </div>
                                </div>
                            </div>
                            <div style="display: flex; gap: 0.5rem;">
                                <a href="${pageContext.request.contextPath}/rdv?action=edit&id=${prochainRdv.idrdv}"
                                   class="btn btn-warning btn-sm">
                                    <i class="fas fa-edit"></i> Modifier
                                </a>
                                <a href="${pageContext.request.contextPath}/rdv?action=annuler&id=${prochainRdv.idrdv}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Annuler ce rendez-vous ?')">
                                    <i class="fas fa-times"></i> Annuler
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 2rem;">
                        <i class="fas fa-calendar-times" style="font-size: 3rem; color: var(--gray-400); margin-bottom: 1rem;"></i>
                        <p style="color: var(--gray-600); margin-bottom: 1rem;">Vous n'avez aucun rendez-vous programmé</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                            <i class="fas fa-search"></i> Trouver un médecin
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Deux colonnes -->
        <div class="two-columns">
            <!-- Dernières consultations -->
            <div class="card">
                <h3 class="card-title">
                    <i class="fas fa-history"></i> Dernières consultations
                </h3>
                <c:choose>
                    <c:when test="${not empty derniersRdvs}">
                        <div style="display: flex; flex-direction: column;">
                            <c:forEach items="${derniersRdvs}" var="r">
                                <div class="consultation-item">
                                    <div>
                                        <div class="consultation-doctor">
                                            <i class="fas fa-user-md"></i> Dr. ${r.medecin.nommed}
                                        </div>
                                        <div class="consultation-specialty">
                                            ${r.medecin.specialite}
                                        </div>
                                    </div>
                                    <div style="text-align: right;">
                                        <div class="consultation-date">
                                            <i class="far fa-calendar-check"></i> ${r.dateFormatee}
                                        </div>
                                        <c:choose>
                                            <c:when test="${r.statut == 'CONFIRME'}">
                                                <span class="badge badge-success" style="margin-top: 0.25rem;">
                                                    <i class="fas fa-check"></i> Confirmé
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger" style="margin-top: 0.25rem;">
                                                    <i class="fas fa-ban"></i> Annulé
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div style="margin-top: 1rem; text-align: center;">
                            <a href="${pageContext.request.contextPath}/rdv?action=liste" class="btn btn-secondary btn-sm">
                                <i class="fas fa-list"></i> Voir tous mes RDV →
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 2rem;">
                            <i class="fas fa-folder-open" style="font-size: 3rem; color: var(--gray-400); margin-bottom: 0.5rem;"></i>
                            <p>Aucune consultation passée</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Actions rapides et conseil santé -->
            <div style="display: flex; flex-direction: column; gap: 1.25rem;">
                <div class="card">
                    <h3 class="card-title">
                        <i class="fas fa-bolt"></i> Actions rapides
                    </h3>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/search" class="quick-action-btn" style="background: linear-gradient(135deg, #e3f2fd, #bbdef5); color: #0d47a1;">
                            <i class="fas fa-search"></i> Nouveau RDV
                        </a>
                        <a href="${pageContext.request.contextPath}/rdv?action=liste" class="quick-action-btn" style="background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #1b5e20;">
                            <i class="fas fa-calendar-alt"></i> Mes RDV
                        </a>
                        <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.utilisateur.idpat}" class="quick-action-btn" style="background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #e65100;">
                            <i class="fas fa-user-edit"></i> Mon profil
                        </a>
                        <a href="${pageContext.request.contextPath}/patient?action=top5" class="quick-action-btn" style="background: linear-gradient(135deg, #fce4ec, #f8bbd0); color: #880e4f;">
                            <i class="fas fa-trophy"></i> Top médecins
                        </a>
                    </div>
                </div>

                <div class="card" style="background: linear-gradient(135deg, #fef9e7, #fff4df);">
                    <h3 class="card-title" style="border-left-color: #f39c12;">
                        <i class="fas fa-lightbulb" style="color: #f39c12;"></i> Conseil santé
                    </h3>
                    <div style="text-align: center; padding: 0.5rem;">
                        <i class="fas fa-heartbeat" style="font-size: 3rem; color: #e74c3c; margin-bottom: 0.75rem;"></i>
                        <div style="font-weight: 600; margin-bottom: 0.5rem; color: var(--gray-800);">Prenez soin de vous</div>
                        <div style="font-size: 0.8rem; color: var(--gray-600);">Une visite médicale régulière est la clé d'une bonne santé</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const skeleton = document.getElementById('skeletonDashboard');
        const realContent = document.getElementById('realContent');

        if (skeleton && realContent) {
            skeleton.style.display = 'block';
            realContent.style.display = 'none';

            setTimeout(function() {
                skeleton.style.display = 'none';
                realContent.style.display = 'block';
            }, 100);
        }
    });
</script>

</body>
</html>