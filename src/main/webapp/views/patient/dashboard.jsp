<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">

    <c:if test="${not empty messageSucces}">
        <div class="alert alert-success" style="background:#d4edda; color:#155724; padding:12px; border-radius:8px; margin-bottom:20px; border:1px solid #c3e6cb;">
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
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">📅</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${rdvAVenir}</div>
            <div style="font-size:13px; color:#666;">Rendez-vous à venir</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">✅</div>
            <div style="font-size:28px; font-weight:bold; color:#34a853;">${rdvPasses}</div>
            <div style="font-size:13px; color:#666;">Consultations effectuées</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">👨‍⚕️</div>
            <div style="font-size:28px; font-weight:bold; color:#1a73e8;">${nbMedecinsConsultes}</div>
            <div style="font-size:13px; color:#666;">Médecins consultés</div>
        </div>
        <div class="card" style="text-align:center; padding:20px;">
            <div style="font-size:32px; margin-bottom:8px;">⭐</div>
            <div style="font-size:28px; font-weight:bold; color:#fbbc04;">${tauxAssiduite}%</div>
            <div style="font-size:13px; color:#666;">Taux d'assiduité</div>
        </div>
    </div>

    <!-- Prochain rendez-vous (mis en avant) -->
    <div class="card" style="margin-bottom:25px; border-left:4px solid #1a73e8;">
        <h3 class="card-title" style="display:flex; align-items:center; gap:8px;">
            ⏰ Prochain rendez-vous
            <c:if test="${empty prochainRdv}">
                <span style="font-size:12px; font-weight:normal; color:#888; margin-left:10px;">Aucun RDV programmé</span>
            </c:if>
        </h3>

        <c:choose>
            <c:when test="${not empty prochainRdv}">
                <div style="background:#e8f0fe; border-radius:12px; padding:20px;">
                    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
                        <div>
                            <div style="font-size:18px; font-weight:bold; color:#1a73e8;">Dr. ${prochainRdv.medecin.nommed}</div>
                            <div style="margin-top:8px;">
                                <span class="badge badge-success">${prochainRdv.medecin.specialite}</span>
                                <span style="color:#666; font-size:13px; margin-left:10px;">📍 ${prochainRdv.medecin.lieu}</span>
                            </div>
                            <div style="margin-top:12px;">
                                <div style="font-size:15px; color:#333;">
                                    📅 ${prochainRdv.dateFormatee}
                                </div>
                                <div style="font-size:13px; color:#666; margin-top:4px;">
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
                    <p style="color:#666; margin-bottom:15px;">Vous n'avez aucun rendez-vous programmé</p>
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                        🔍 Trouver un médecin
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Deux colonnes : Derniers RDV + Actions rapides -->
    <div style="display:grid; grid-template-columns:repeat(2, 1fr); gap:20px;">

        <!-- Derniers rendez-vous passés -->
        <div class="card">
            <h3 class="card-title">📋 Dernières consultations</h3>
            <c:choose>
                <c:when test="${not empty derniersRdvs}">
                    <div style="display:flex; flex-direction:column; gap:12px;">
                        <c:forEach items="${derniersRdvs}" var="r">
                            <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid #f0f4f8;">
                                <div>
                                    <div style="font-weight:600;">Dr. ${r.medecin.nommed}</div>
                                    <div style="font-size:12px; color:#888;">${r.medecin.specialite}</div>
                                </div>
                                <div style="text-align:right;">
                                    <div style="font-size:13px; color:#666;">${r.dateFormatee}</div>
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

        <!-- Actions rapides & conseils -->
        <div style="display:flex; flex-direction:column; gap:20px;">

            <!-- Actions rapides -->
            <div class="card">
                <h3 class="card-title">⚡ Actions rapides</h3>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                    <a href="${pageContext.request.contextPath}/search"
                       style="background:#e8f0fe; padding:15px; border-radius:10px; text-decoration:none; text-align:center; transition:transform 0.2s;"
                       onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='none'">
                        <div style="font-size:24px; margin-bottom:5px;">🔍</div>
                        <div style="font-size:13px; font-weight:500; color:#1a73e8;">Nouveau RDV</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/rdv?action=liste"
                       style="background:#e6f4ea; padding:15px; border-radius:10px; text-decoration:none; text-align:center; transition:transform 0.2s;"
                       onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='none'">
                        <div style="font-size:24px; margin-bottom:5px;">📋</div>
                        <div style="font-size:13px; font-weight:500; color:#34a853;">Mes RDV</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.utilisateur.idpat}"
                       style="background:#fef7e0; padding:15px; border-radius:10px; text-decoration:none; text-align:center; transition:transform 0.2s;"
                       onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='none'">
                        <div style="font-size:24px; margin-bottom:5px;">👤</div>
                        <div style="font-size:13px; font-weight:500; color:#fbbc04;">Mon profil</div>
                    </a>
                    <a href="${pageContext.request.contextPath}/medecin?action=top5"
                       style="background:#fce8e6; padding:15px; border-radius:10px; text-decoration:none; text-align:center; transition:transform 0.2s;"
                       onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform='none'">
                        <div style="font-size:24px; margin-bottom:5px;">🏆</div>
                        <div style="font-size:13px; font-weight:500; color:#ea4335;">Top médecins</div>
                    </a>
                </div>
            </div>

            <!-- Conseil santé du jour -->
            <div class="card" style="background:linear-gradient(135deg, #e8f0fe, #d4e4fc);">
                <h3 class="card-title">💡 Conseil santé</h3>
                <div style="text-align:center; padding:10px;">
                    <div style="font-size:40px; margin-bottom:10px;">💙</div>
                    <div style="font-weight:600; margin-bottom:5px;">Prenez soin de vous</div>
                    <div style="font-size:13px; color:#555;">Une visite médicale régulière est la clé d'une bonne santé</div>
                </div>
            </div>

            <!-- Badges / Réalisations -->
            <div class="card">
                <h3 class="card-title">🏆 Mes réalisations</h3>
                <div style="display:flex; flex-wrap:wrap; gap:15px; justify-content:center;">
                    <div style="text-align:center; width:80px;">
                        <div style="width:55px; height:55px; background:${nbRdvTotal >= 1 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvTotal >= 1 ? 'white' : '#aaa'}; font-size:24px;">🏥</div>
                        <div style="font-size:11px; color:${nbRdvTotal >= 1 ? '#1a73e8' : '#aaa'};">Premier RDV</div>
                    </div>
                    <div style="text-align:center; width:80px;">
                        <div style="width:55px; height:55px; background:${nbRdvTotal >= 5 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvTotal >= 5 ? 'white' : '#aaa'}; font-size:24px;">⭐</div>
                        <div style="font-size:11px; color:${nbRdvTotal >= 5 ? '#1a73e8' : '#aaa'};">5 RDV</div>
                    </div>
                    <div style="text-align:center; width:80px;">
                        <div style="width:55px; height:55px; background:${nbRdvTotal >= 10 ? 'linear-gradient(135deg, #1a73e8, #0d47a1)' : '#e8f0fe'}; border-radius:50%; display:flex; align-items:center; justify-content:center; margin:0 auto 8px; color:${nbRdvTotal >= 10 ? 'white' : '#aaa'}; font-size:24px;">🎖️</div>
                        <div style="font-size:11px; color:${nbRdvTotal >= 10 ? '#1a73e8' : '#aaa'};">10 RDV</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>