<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">
        <h2 class="card-title">Trouver un médecin</h2>

        <%-- Barre de recherche --%>
        <form action="${pageContext.request.contextPath}/search" method="get"
              style="display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap;">

            <input type="text" name="q"
                   value="${motCle}"
                   placeholder="Rechercher par nom..."
                   style="flex:2; min-width:200px; padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px;">

            <select name="specialite"
                    style="flex:1; min-width:160px; padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px;">
                <option value="">Toutes spécialités</option>
                <c:forEach var="sp" items="${specialites}">
                    <option value="${sp}" ${filtreSpecialite == sp ? 'selected' : ''}>${sp}</option>
                </c:forEach>
            </select>

            <button type="submit" class="btn btn-primary">Rechercher</button>
            <a href="${pageContext.request.contextPath}/search" class="btn btn-secondary">Réinitialiser</a>
        </form>

        <%-- Résultats --%>
        <c:choose>
            <c:when test="${empty resultats}">
                <p style="text-align:center; color:#888; padding:40px;">
                    Aucun médecin trouvé pour cette recherche.
                </p>
            </c:when>
            <c:otherwise>
                <p style="color:#666; font-size:13px; margin-bottom:16px;">
                    ${resultats.size()} médecin(s) trouvé(s)
                </p>
                <div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(280px,1fr)); gap:16px;">
                    <c:forEach var="m" items="${resultats}">
                        <div class="card" style="margin-bottom:0; border:1px solid #e8f0fe;">
                            <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                                <div>
                                    <h3 style="color:#1a73e8; font-size:16px; margin-bottom:4px;">
                                        Dr. ${m.nommed}
                                    </h3>
                                    <span class="badge badge-success">${m.specialite}</span>
                                </div>
                                <span style="color:#888; font-size:13px;">${m.lieu}</span>
                            </div>
                            <div style="margin-top:12px; padding-top:12px; border-top:1px solid #f0f4f8;">
                                <p style="font-size:13px; color:#555;">
                                    Taux : <strong>${m.tauxHoraire} Ar/h</strong>
                                </p>
                                <p style="font-size:13px; color:#555; margin-top:4px;">
                                    ${m.email}
                                </p>
                            </div>
                            <div style="margin-top:14px; display:flex; gap:8px;">
                                <a href="${pageContext.request.contextPath}/rdv?action=horaires&idmed=${m.idmed}"
                                   class="btn btn-primary" style="flex:1; text-align:center; font-size:13px;">
                                    Voir créneaux
                                </a>
                                <a href="${pageContext.request.contextPath}/rdv?action=form&idmed=${m.idmed}"
                                   class="btn btn-success" style="flex:1; text-align:center; font-size:13px;">
                                    Prendre RDV
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
