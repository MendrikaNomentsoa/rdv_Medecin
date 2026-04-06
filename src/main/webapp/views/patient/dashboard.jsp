<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">

    <%-- Message de bienvenue --%>
    <div class="card" style="background:linear-gradient(135deg,#1a73e8,#0d47a1); color:white; padding:30px;">
        <h2 style="font-size:22px; margin-bottom:8px;">
            Bonjour,
                <c:choose>
                    <c:when test="${sessionScope.role == 'patient'}">
                        ${sessionScope.utilisateur.nomPat}
                    </c:when>
                    <c:otherwise>
                        Dr. ${sessionScope.utilisateur.nommed}
                    </c:otherwise>
                </c:choose>
                !
        </h2>
        <p style="opacity:0.85; font-size:14px;">Bienvenue sur votre espace patient.</p>
    </div>

    <%-- Actions rapides --%>
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(220px,1fr)); gap:16px; margin-bottom:20px;">

        <a href="${pageContext.request.contextPath}/search" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">🔍</div>
                <h3 style="color:#1a73e8; font-size:15px;">Trouver un médecin</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Rechercher par nom ou spécialité</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/rdv?action=liste" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">📅</div>
                <h3 style="color:#1a73e8; font-size:15px;">Mes rendez-vous</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Voir et gérer mes RDV</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/patient?action=edit&id=${sessionScope.utilisateur.idpat}" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-3px)'" onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">👤</div>
                <h3 style="color:#1a73e8; font-size:15px;">Mon profil</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Modifier mes informations</p>
            </div>
        </a>

    </div>

</div>
</body>
</html>
