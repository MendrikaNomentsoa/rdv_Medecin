<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">

        <h2 class="card-title">Créneaux disponibles</h2>

        <%-- Infos médecin --%>
        <c:if test="${not empty medecin}">
            <div style="background:#e8f0fe; border-radius:10px; padding:16px; margin-bottom:24px; display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <h3 style="color:#1a73e8; font-size:16px; margin-bottom:4px;">
                        Dr. ${medecin.nommed}
                    </h3>
                    <span class="badge badge-success">${medecin.specialite}</span>
                    <span style="color:#666; font-size:13px; margin-left:10px;">${medecin.lieu}</span>
                </div>
                <a href="${pageContext.request.contextPath}/rdv?action=form&idmed=${medecin.idmed}"
                   class="btn btn-success">
                    Prendre RDV
                </a>
            </div>
        </c:if>

        <%-- Créneaux déjà pris --%>
        <h3 style="font-size:15px; color:#555; margin-bottom:14px;">
            Créneaux déjà réservés :
        </h3>

        <c:choose>
            <c:when test="${empty creneauxPris}">
                <div style="background:#e6f4ea; border-radius:8px; padding:14px; margin-bottom:20px; color:#137333; font-size:14px;">
                    Aucun créneau réservé — ce médecin est entièrement disponible !
                </div>
            </c:when>
            <c:otherwise>
                <div style="display:flex; flex-wrap:wrap; gap:10px; margin-bottom:24px;">
                    <c:forEach var="creneau" items="${creneauxPris}">
                        <span style="background:#fce8e6; color:#c5221f; padding:8px 14px;
                                     border-radius:8px; font-size:13px; font-weight:500;
                                     border:1px solid #f5c6c2;">
                            ${creneau}
                        </span>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- Horaires habituels --%>
        <h3 style="font-size:15px; color:#555; margin-bottom:14px;">
            Horaires de consultation habituels :
        </h3>
        <div style="display:grid; grid-template-columns:repeat(auto-fill, minmax(120px,1fr)); gap:10px; margin-bottom:24px;">
            <c:forEach var="heure" items="${['08:00','09:00','10:00','11:00','14:00','15:00','16:00','17:00']}">
                <div style="background:#e8f0fe; color:#1a73e8; padding:10px;
                            border-radius:8px; text-align:center; font-size:14px; font-weight:500;">
                    ${heure}
                </div>
            </c:forEach>
        </div>

        <div style="display:flex; gap:12px;">
            <a href="${pageContext.request.contextPath}/rdv?action=form&idmed=${medecin.idmed}"
               class="btn btn-success" style="flex:1; text-align:center;">
                Prendre un rendez-vous
            </a>
            <a href="${pageContext.request.contextPath}/search"
               class="btn btn-secondary" style="flex:1; text-align:center;">
                Retour à la recherche
            </a>
        </div>

    </div>
</div>
</body>
</html>
