<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">

    <%-- Bienvenue --%>
    <div class="card" style="background:linear-gradient(135deg,#0d47a1,#1a73e8); color:white; padding:30px;">
        <h2 style="font-size:22px; margin-bottom:8px;">
            Bonjour, Dr. ${sessionScope.utilisateur.nommed} !
        </h2>
        <p style="opacity:0.85; font-size:14px;">
            ${sessionScope.utilisateur.specialite} — ${sessionScope.utilisateur.lieu}
        </p>
    </div>

    <%-- Actions rapides --%>
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px,1fr)); gap:16px; margin-bottom:20px;">

        <a href="${pageContext.request.contextPath}/rdv?action=liste" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;"
                 onmouseover="this.style.transform='translateY(-3px)'"
                 onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">📅</div>
                <h3 style="color:#1a73e8; font-size:15px;">Mes rendez-vous</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Gérer mon agenda</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/patient?action=liste" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;"
                 onmouseover="this.style.transform='translateY(-3px)'"
                 onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">👥</div>
                <h3 style="color:#1a73e8; font-size:15px;">Mes patients</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Liste des patients</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/medecin?action=top5" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;"
                 onmouseover="this.style.transform='translateY(-3px)'"
                 onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">🏆</div>
                <h3 style="color:#1a73e8; font-size:15px;">Top 5 médecins</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Les plus consultés</p>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${sessionScope.utilisateur.idmed}" style="text-decoration:none;">
            <div class="card" style="text-align:center; padding:28px; cursor:pointer; transition:transform 0.2s;"
                 onmouseover="this.style.transform='translateY(-3px)'"
                 onmouseout="this.style.transform='none'">
                <div style="font-size:36px; margin-bottom:12px;">⚙️</div>
                <h3 style="color:#1a73e8; font-size:15px;">Mon profil</h3>
                <p style="color:#888; font-size:13px; margin-top:4px;">Modifier mes infos</p>
            </div>
        </a>

    </div>
</div>
</body>
</html>
