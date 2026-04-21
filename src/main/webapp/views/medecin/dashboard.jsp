<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">

    <!-- Bienvenue -->
    <div class="card" style="background:linear-gradient(135deg,#0d47a1,#1a73e8); color:white; padding:30px; margin-bottom:25px;">
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

    <!-- Statistiques clés -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(160px,1fr)); gap:16px; margin-bottom:25px;">
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">📅</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${rdvAujourdhui}</div>
            <div style="font-size:13px; color:#666;">RDV aujourd'hui</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">📆</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${rdvCetteSemaine}</div>
            <div style="font-size:13px; color:#666;">RDV cette semaine</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">💰</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${revenusMois} Ar</div>
            <div style="font-size:13px; color:#666;">Revenus du mois</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">👥</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${totalPatients}</div>
            <div style="font-size:13px; color:#666;">Patients uniques</div>
        </div>
    </div>

    <!-- Prochain rendez-vous -->
    <div class="card" style="margin-bottom:25px;">
        <h3 class="card-title">📅 Prochain rendez-vous</h3>
        <c:choose>
            <c:when test="${not empty prochainRdv}">
                <div style="background:#e8f0fe; border-radius:12px; padding:16px;">
                    <div style="font-size:18px; font-weight:bold; color:#1a73e8;">${prochainRdv.dateFormatee}</div>
                    <div style="font-size:16px; margin-top:8px;">👤 Patient : <strong>${prochainRdv.patient.nomPat}</strong></div>
                    <div style="font-size:14px; color:#666; margin-top:4px;">📧 ${prochainRdv.patient.email}</div>
                    <div style="margin-top:15px;">
                        <a href="${pageContext.request.contextPath}/rdv?action=edit&id=${prochainRdv.idrdv}" class="btn btn-warning" style="padding:6px 15px; font-size:13px;">📝 Modifier</a>
                        <a href="${pageContext.request.contextPath}/rdv?action=annuler&id=${prochainRdv.idrdv}" class="btn btn-danger" style="padding:6px 15px; font-size:13px; margin-left:10px;" onclick="return confirm('Annuler ce rendez-vous ?')">❌ Annuler</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div style="text-align:center; padding:30px;">
                    <div style="font-size:48px; margin-bottom:10px;">📭</div>
                    <p>Aucun rendez-vous programmé</p>
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
                            <div style="display:flex; justify-content:space-between; align-items:center; padding:8px 0; border-bottom:1px solid #f0f4f8;">
                                <div>
                                    <div style="font-weight:600;">${p.nomPat}</div>
                                    <div style="font-size:12px; color:#888;">${p.email}</div>
                                </div>
                                <div style="font-size:12px; color:#1a73e8;">${p.dateDernierRdv}</div>
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
                <div style="text-align:center; width:80px;">
                    <div style="width:55px; height:55px; background:${totalPatients >= 1 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${totalPatients >= 1 ? 'white' : '#aaa'}; font-size:24px;">🥇</div>
                    <div style="font-size:11px; color:${totalPatients >= 1 ? '#1a73e8' : '#aaa'};">Premier patient</div>
                </div>
                <div style="text-align:center; width:80px;">
                    <div style="width:55px; height:55px; background:${nbRdvPasses >= 10 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvPasses >= 10 ? 'white' : '#aaa'}; font-size:24px;">🎖️</div>
                    <div style="font-size:11px; color:${nbRdvPasses >= 10 ? '#1a73e8' : '#aaa'};">10 RDV</div>
                </div>
                <div style="text-align:center; width:80px;">
                    <div style="width:55px; height:55px; background:${nbRdvPasses >= 50 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvPasses >= 50 ? 'white' : '#aaa'}; font-size:24px;">🏅</div>
                    <div style="font-size:11px; color:${nbRdvPasses >= 50 ? '#1a73e8' : '#aaa'};">50 RDV</div>
                </div>
            </div>
        </div>

        <!-- Horaires de travail -->
        <div class="card">
            <h3 class="card-title">⏰ Horaires de travail</h3>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <div style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid #f0f4f8;">
                    <span>🕐 Matin</span>
                    <span><strong>08:00 - 12:00</strong></span>
                </div>
                <div style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid #f0f4f8;">
                    <span>🕒 Après-midi</span>
                    <span><strong>14:00 - 17:00</strong></span>
                </div>
                <div style="display:flex; justify-content:space-between; padding:8px 0;">
                    <span>📅 Jours de consultation</span>
                    <span><strong>Lundi - Vendredi</strong></span>
                </div>
            </div>
            <div style="margin-top:15px; text-align:center;">
                <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${sessionScope.idUtilisateur}" class="btn btn-primary" style="font-size:13px;">✏️ Modifier mes horaires</a>
            </div>
        </div>

        <!-- Conseil du jour -->
        <div class="card" style="background:linear-gradient(135deg, #e8f0fe, #d4e4fc);">
            <h3 class="card-title">💡 Conseil du jour</h3>
            <div style="text-align:center; padding:15px;">
                <div style="font-size:48px; margin-bottom:10px;">💙</div>
                <div style="font-weight:600; margin-bottom:5px;">Prenez soin de vous</div>
                <div style="font-size:13px; color:#666;">Un médecin en bonne santé soigne mieux ses patients</div>
            </div>
        </div>

    </div>

</div>
</body>
</html>