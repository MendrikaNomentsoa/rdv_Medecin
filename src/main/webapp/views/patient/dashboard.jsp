<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container" id="dashboardContent">
    <!-- SKELETON LOADER (disparaît rapidement) -->
    <div class="skeleton-container" id="skeletonDashboard">
        <div class="skeleton-card">
            <div class="skeleton-title" style="width: 40%; margin-bottom: 15px;"></div>
            <div class="skeleton-text" style="width: 60%;"></div>
            <div class="skeleton-text" style="width: 80%;"></div>
        </div>
        <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:25px;">
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
            <div class="skeleton-stat"></div>
        </div>
        <div class="skeleton-card">
            <div class="skeleton-title" style="width: 30%; margin-bottom: 15px;"></div>
            <div class="skeleton-text" style="width: 100%; height: 80px;"></div>
        </div>
    </div>

    <!-- CONTENU RÉEL -->
    <div class="content-loaded" id="realContent" style="display: none;">
        <c:if test="${not empty messageSucces}">
            <div class="alert alert-success">
                ✓ ${messageSucces}
            </div>
        </c:if>

        <!-- Bannière de bienvenue -->
        <div class="card" style="background:linear-gradient(135deg,#1a73e8,#0d47a1); color:white; padding:30px; margin-bottom:25px;">
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap;">
                <div>
                    <h2 style="font-size:26px; margin-bottom:8px;">
                        Bonjour, ${sessionScope.utilisateur.nomPat} ! 👋
                    </h2>
                    <p style="opacity:0.9; font-size:14px;">Bienvenue sur votre espace santé</p>
                    <p style="opacity:0.7; font-size:12px; margin-top:8px;">📧 ${sessionScope.utilisateur.email}</p>
                </div>
                <div style="text-align:center; background:rgba(255,255,255,0.15); padding:12px 20px; border-radius:12px;">
                    <div style="font-size:28px; font-weight:bold;">${nbRdvTotal}</div>
                    <div style="font-size:12px; opacity:0.85;">Rendez-vous total</div>
                </div>
            </div>
        </div>

        <!-- Statistiques clés -->
        <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:25px;">
            <div class="stat-card">
                <div class="stat-icon">📅</div>
                <div class="stat-number">${rdvAVenir}</div>
                <div class="stat-label">Rendez-vous à venir</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-number">${rdvPasses}</div>
                <div class="stat-label">Consultations effectuées</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">👨‍⚕️</div>
                <div class="stat-number">${nbMedecinsConsultes}</div>
                <div class="stat-label">Médecins consultés</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">⭐</div>
                <div class="stat-number">${tauxAssiduite}%</div>
                <div class="stat-label">Taux d'assiduité</div>
            </div>
        </div>

        <!-- Prochain rendez-vous -->
        <div class="card" style="margin-bottom:25px; border-left:4px solid #1a73e8;">
            <h3 class="card-title" style="display:flex; align-items:center; gap:8px;">
                ⏰ Prochain rendez-vous
                <c:if test="${empty prochainRdv}">
                    <span style="font-size:12px; font-weight:normal; color:var(--text-muted); margin-left:10px;">Aucun RDV programmé</span>
                </c:if>
            </h3>

            <c:choose>
                <c:when test="${not empty prochainRdv}">
                    <div style="background:var(--hover-bg); border-radius:12px; padding:20px;">
                        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
                            <div>
                                <div style="font-size:18px; font-weight:bold; color:#1a73e8;">Dr. ${prochainRdv.medecin.nommed}</div>
                                <div style="margin-top:8px;">
                                    <span class="badge badge-success">${prochainRdv.medecin.specialite}</span>
                                    <span style="color:var(--text-secondary); font-size:13px; margin-left:10px;">📍 ${prochainRdv.medecin.lieu}</span>
                                </div>
                                <div style="margin-top:12px;">
                                    <div style="font-size:15px; color:var(--text-primary);">
                                        📅 ${prochainRdv.dateFormatee}
                                    </div>
                                    <div style="font-size:13px; color:var(--text-secondary); margin-top:4px;">
                                        💰 Taux horaire: ${prochainRdv.medecin.tauxHoraire} Ar/h
                                    </div>
                                </div>
                            </div>
                            <div style="display:flex; gap:10px;">
                                <a href="${pageContext.request.contextPath}/rdv?action=edit&id=${prochainRdv.idrdv}"
                                   class="btn btn-warning" style="padding:8px 16px;">
                                    📝 Modifier
                                </a>
                                <a href="${pageContext.request.contextPath}/rdv?action=annuler&id=${prochainRdv.idrdv}"
                                   class="btn btn-danger" style="padding:8px 16px;"
                                   onclick="return confirm('Annuler ce rendez-vous ?')">
                                    ❌ Annuler
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding:40px;">
                        <div style="font-size:48px; margin-bottom:15px;">📭</div>
                        <p style="color:var(--text-secondary); margin-bottom:15px;">Vous n'avez aucun rendez-vous programmé</p>
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                            🔍 Trouver un médecin
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Deux colonnes -->
        <div style="display:grid; grid-template-columns:repeat(2, 1fr); gap:20px;">
            <div class="card">
                <h3 class="card-title">📋 Dernières consultations</h3>
                <c:choose>
                    <c:when test="${not empty derniersRdvs}">
                        <div style="display:flex; flex-direction:column; gap:12px;">
                            <c:forEach items="${derniersRdvs}" var="r">
                                <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid var(--border-light);">
                                    <div>
                                        <div style="font-weight:600;">Dr. ${r.medecin.nommed}</div>
                                        <div style="font-size:12px; color:var(--text-muted);">${r.medecin.specialite}</div>
                                    </div>
                                    <div style="text-align:right;">
                                        <div style="font-size:13px; color:var(--text-secondary);">${r.dateFormatee}</div>
                                        <c:choose>
                                            <c:when test="${r.statut == 'CONFIRME'}">
                                                <span class="badge badge-success" style="font-size:10px;">Confirmé</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-danger" style="font-size:10px;">Annulé</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div style="margin-top:15px; text-align:center;">
                            <a href="${pageContext.request.contextPath}/rdv?action=liste" class="btn btn-secondary" style="font-size:13px;">
                                Voir tous mes RDV →
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align:center; padding:30px;">
                            <div style="font-size:40px; margin-bottom:10px;">📭</div>
                            <p>Aucune consultation passée</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div style="display:flex; flex-direction:column; gap:20px;">
                <div class="card">
                    <h3 class="card-title">⚡ Actions rapides</h3>
                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                        <a href="${pageContext.request.contextPath}/search" class="btn btn-primary" style="text-align:center;">🔍 Nouveau RDV</a>
                        <a href="${pageContext.request.contextPath}/rdv?action=liste" class="btn btn-success" style="text-align:center;">📋 Mes RDV</a>
                        <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.utilisateur.idpat}" class="btn btn-warning" style="text-align:center;">👤 Mon profil</a>
                        <a href="${pageContext.request.contextPath}/patient?action=top5" class="btn btn-danger" style="text-align:center;">🏆 Top médecins</a>
                    </div>
                </div>
                <div class="card" style="background:linear-gradient(135deg, var(--hover-bg), var(--bg-card));">
                    <h3 class="card-title">💡 Conseil santé</h3>
                    <div style="text-align:center; padding:10px;">
                        <div style="font-size:40px; margin-bottom:10px;">💙</div>
                        <div style="font-weight:600; margin-bottom:5px;">Prenez soin de vous</div>
                        <div style="font-size:13px; color:var(--text-secondary);">Une visite médicale régulière est la clé d'une bonne santé</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Chargement ultra-rapide (100ms au lieu de 300ms)
    document.addEventListener('DOMContentLoaded', function() {
        const skeleton = document.getElementById('skeletonDashboard');
        const realContent = document.getElementById('realContent');

        skeleton.style.display = 'block';
        realContent.style.display = 'none';

        // Affichage après seulement 100ms pour un effet plus rapide
        setTimeout(function() {
            skeleton.style.display = 'none';
            realContent.style.display = 'block';
        }, 100);
    });
</script>

</body>
</html>