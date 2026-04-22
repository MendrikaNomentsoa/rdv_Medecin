<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">

    <c:if test="${not empty messageSucces}">
        <div class="alert alert-success">
            ✓ ${messageSucces}
        </div>
    </c:if>

    <!-- Bannière de bienvenue -->
    <div class="card" style="background:linear-gradient(135deg,#0d47a1,#1a73e8); color:white; padding:30px; margin-bottom:25px;">
        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap;">
            <div>
                <h2 style="font-size:26px; margin-bottom:8px;">
                    Bonjour, Dr. ${sessionScope.utilisateur.nommed} ! 👨‍⚕️
                </h2>
                <p style="opacity:0.9; font-size:15px;">
                    ${sessionScope.utilisateur.specialite} — 📍 ${sessionScope.utilisateur.lieu}
                </p>
                <div style="display:flex; gap:20px; margin-top:15px; flex-wrap:wrap;">
                    <span>💰 Taux horaire : <strong>${tauxHoraire} Ar/h</strong></span>
                    <span>📧 ${sessionScope.utilisateur.email}</span>
                </div>
            </div>
            <div style="text-align:center; background:rgba(255,255,255,0.15); padding:12px 20px; border-radius:12px;">
                <div style="font-size:28px; font-weight:bold;">${totalPatients}</div>
                <div style="font-size:12px; opacity:0.85;">Patients uniques</div>
            </div>
        </div>
    </div>

    <!-- Statistiques clés avec cartes animées -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:25px;">
        <div class="stat-card">
            <div class="stat-icon">📅</div>
            <div class="stat-number">${rdvAujourdhui}</div>
            <div class="stat-label">RDV aujourd'hui</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📆</div>
            <div class="stat-number">${rdvCetteSemaine}</div>
            <div class="stat-label">RDV cette semaine</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">💰</div>
            <div class="stat-number">${revenusMois} Ar</div>
            <div class="stat-label">Revenus du mois</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-number">${totalPatients}</div>
            <div class="stat-label">Patients uniques</div>
        </div>
    </div>

    <!-- Deuxième ligne de statistiques -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px,1fr)); gap:16px; margin-bottom:25px;">
        <div class="card" style="text-align:center;">
            <div style="font-size:32px; margin-bottom:8px;">✅</div>
            <div style="font-size:24px; font-weight:bold; color:#34a853;">${nbRdvPasses}</div>
            <div style="font-size:13px; color:var(--text-secondary);">Consultations effectuées</div>
        </div>
        <div class="card" style="text-align:center;">
            <div style="font-size:32px; margin-bottom:8px;">⏳</div>
            <div style="font-size:24px; font-weight:bold; color:#fbbc04;">${nbRdvAVenir}</div>
            <div style="font-size:13px; color:var(--text-secondary);">RDV à venir</div>
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
                            <div style="font-size:18px; font-weight:bold; color:#1a73e8;">${prochainRdv.dateFormatee}</div>
                            <div style="font-size:16px; margin-top:8px;">👤 Patient : <strong>${prochainRdv.patient.nomPat}</strong></div>
                            <div style="font-size:14px; color:var(--text-secondary); margin-top:4px;">📧 ${prochainRdv.patient.email}</div>
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
                    <p style="color:var(--text-secondary); margin-bottom:15px;">Aucun rendez-vous programmé</p>
                    <p style="font-size:13px; color:var(--text-muted);">Les patients prendront rendez-vous avec vous via la plateforme</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Grille des autres infos -->
    <div style="display:grid; grid-template-columns:repeat(2, 1fr); gap:20px;">

        <!-- Derniers patients consultés -->
        <div class="card">
            <h3 class="card-title">👥 Derniers patients</h3>
            <c:choose>
                <c:when test="${not empty derniersPatients}">
                    <div style="display:flex; flex-direction:column; gap:12px;">
                        <c:forEach items="${derniersPatients}" var="p">
                            <div class="patient-item" style="display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid var(--border-light); transition:all 0.2s ease;">
                                <div>
                                    <div style="font-weight:600;">${p.nomPat}</div>
                                    <div style="font-size:12px; color:var(--text-muted);">${p.email}</div>
                                </div>
                                <div style="font-size:12px; color:#1a73e8; background:var(--hover-bg); padding:4px 10px; border-radius:20px;">${p.dateDernierRdv}</div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center; padding:30px;">
                        <div style="font-size:40px; margin-bottom:10px;">👥</div>
                        <p>Aucun patient pour le moment</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Badges / Réalisations -->
        <div class="card">
            <h3 class="card-title">🏆 Mes réalisations</h3>
            <div style="display:flex; flex-wrap:wrap; gap:15px; justify-content:center;">
                <div class="achievement" style="text-align:center; width:80px; transition:transform 0.3s ease; cursor:pointer;">
                    <div class="achievement-icon" style="width:55px; height:55px; background:${totalPatients >= 1 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : 'var(--border-light)'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${totalPatients >= 1 ? 'white' : 'var(--text-muted)'}; font-size:24px; transition:transform 0.3s ease;">🥇</div>
                    <div style="font-size:11px; color:${totalPatients >= 1 ? '#1a73e8' : 'var(--text-muted)'};">Premier patient</div>
                </div>
                <div class="achievement" style="text-align:center; width:80px; transition:transform 0.3s ease; cursor:pointer;">
                    <div class="achievement-icon" style="width:55px; height:55px; background:${nbRdvPasses >= 10 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : 'var(--border-light)'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvPasses >= 10 ? 'white' : 'var(--text-muted)'}; font-size:24px; transition:transform 0.3s ease;">🎖️</div>
                    <div style="font-size:11px; color:${nbRdvPasses >= 10 ? '#1a73e8' : 'var(--text-muted)'};">10 RDV</div>
                </div>
                <div class="achievement" style="text-align:center; width:80px; transition:transform 0.3s ease; cursor:pointer;">
                    <div class="achievement-icon" style="width:55px; height:55px; background:${nbRdvPasses >= 50 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : 'var(--border-light)'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvPasses >= 50 ? 'white' : 'var(--text-muted)'}; font-size:24px; transition:transform 0.3s ease;">🏅</div>
                    <div style="font-size:11px; color:${nbRdvPasses >= 50 ? '#1a73e8' : 'var(--text-muted)'};">50 RDV</div>
                </div>
                <div class="achievement" style="text-align:center; width:80px; transition:transform 0.3s ease; cursor:pointer;">
                    <div class="achievement-icon" style="width:55px; height:55px; background:${nbRdvPasses >= 100 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : 'var(--border-light)'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvPasses >= 100 ? 'white' : 'var(--text-muted)'}; font-size:24px; transition:transform 0.3s ease;">🏆</div>
                    <div style="font-size:11px; color:${nbRdvPasses >= 100 ? '#1a73e8' : 'var(--text-muted)'};">100 RDV</div>
                </div>
            </div>
        </div>

        <!-- Horaires de travail -->
        <div class="card">
            <h3 class="card-title">⏰ Horaires de travail</h3>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div class="schedule-item" style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid var(--border-light); transition:all 0.2s ease;">
                    <span>🕐 Matin</span>
                    <span><strong>08:00 - 12:00</strong></span>
                </div>
                <div class="schedule-item" style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid var(--border-light); transition:all 0.2s ease;">
                    <span>🕒 Après-midi</span>
                    <span><strong>14:00 - 17:00</strong></span>
                </div>
                <div class="schedule-item" style="display:flex; justify-content:space-between; padding:8px 0;">
                    <span>📅 Jours de consultation</span>
                    <span><strong>Lundi - Vendredi</strong></span>
                </div>
            </div>
            <div style="margin-top:15px; text-align:center;">
                <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${sessionScope.idUtilisateur}" class="btn btn-primary" style="font-size:13px;">
                    ✏️ Modifier mes informations
                </a>
            </div>
        </div>

        <!-- Conseil du jour -->
        <div class="card" style="background:linear-gradient(135deg, var(--hover-bg), var(--bg-card));">
            <h3 class="card-title">💡 Conseil du jour</h3>
            <div style="text-align:center; padding:15px;">
                <div style="font-size:48px; margin-bottom:10px; animation: pulse 2s infinite;">💙</div>
                <div style="font-weight:600; margin-bottom:5px;">Prenez soin de vous</div>
                <div style="font-size:13px; color:var(--text-secondary);">Un médecin en bonne santé soigne mieux ses patients</div>
            </div>
        </div>

    </div>

</div>

<style>
    /* Animations supplémentaires pour le dashboard médecin */
    .patient-item:hover {
        transform: translateX(5px);
        background: var(--hover-bg);
        padding-left: 15px;
        border-radius: 8px;
    }

    .schedule-item:hover {
        transform: translateX(5px);
        background: var(--hover-bg);
        padding-left: 15px;
        border-radius: 8px;
    }

    .achievement:hover {
        transform: translateY(-5px);
    }

    .achievement:hover .achievement-icon {
        transform: scale(1.1);
    }

    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.05); }
    }
</style>

<script>
    // Animation supplémentaire pour les réalisations
    document.querySelectorAll('.achievement').forEach(achievement => {
        achievement.addEventListener('click', function() {
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 200);
        });
    });
</script>

</body>
</html>