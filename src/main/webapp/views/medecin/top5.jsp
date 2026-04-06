<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">
        <h2 class="card-title">Top 5 — Médecins les plus consultés</h2>

        <c:choose>
            <c:when test="${empty top5}">
                <p style="text-align:center; color:#888; padding:40px;">
                    Aucune donnée disponible pour le moment.
                </p>
            </c:when>
            <c:otherwise>
                <c:forEach var="m" items="${top5}" varStatus="status">
                    <div style="display:flex; align-items:center; gap:16px; padding:16px;
                                border-radius:10px; margin-bottom:12px;
                                background:${status.index == 0 ? '#fef7e0' : status.index == 1 ? '#f0f4f8' : 'white'};
                                border:1px solid ${status.index == 0 ? '#fbbc04' : '#e8f0fe'};">

                        <%-- Rang --%>
                        <div style="width:42px; height:42px; border-radius:50%;
                                    background:${status.index == 0 ? '#fbbc04' : status.index == 1 ? '#aaa' : '#cd7f32'};
                                    display:flex; align-items:center; justify-content:center;
                                    color:white; font-weight:700; font-size:18px; flex-shrink:0;">
                            ${status.index + 1}
                        </div>

                        <%-- Infos médecin --%>
                        <div style="flex:1;">
                            <h3 style="font-size:16px; color:#333; margin-bottom:2px;">
                                Dr. ${m.nommed}
                            </h3>
                            <span class="badge badge-success">${m.specialite}</span>
                            <span style="color:#888; font-size:13px; margin-left:8px;">${m.lieu}</span>
                        </div>

                        <%-- Bouton prendre RDV --%>
                        <a href="${pageContext.request.contextPath}/rdv?action=form&idmed=${m.idmed}"
                           class="btn btn-primary" style="font-size:13px; white-space:nowrap;">
                            Prendre RDV
                        </a>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
