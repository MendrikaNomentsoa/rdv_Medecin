<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h2 class="card-title" style="margin-bottom:0; border:none;">Liste des patients</h2>
            <a href="${pageContext.request.contextPath}/patient?action=form" class="btn btn-primary">
                + Nouveau patient
            </a>
        </div>

        <c:if test="${not empty erreur}">
            <div class="alert alert-danger">${erreur}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty patients}">
                <p style="text-align:center; color:#888; padding:40px;">Aucun patient enregistré.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Date de naissance</th>
                            <th>Email</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${patients}">
                            <tr>
                                <td><strong>${p.nomPat}</strong></td>
                                <td>${p.datenais}</td>
                                <td>${p.email}</td>
                                <td style="text-align:center;">
                                    <a href="${pageContext.request.contextPath}/patient?action=edit&id=${p.idpat}"
                                       class="btn btn-warning" style="padding:6px 12px; font-size:12px;">
                                        Modifier
                                    </a>
                                    <a href="${pageContext.request.contextPath}/patient?action=supprimer&id=${p.idpat}"
                                       class="btn btn-danger" style="padding:6px 12px; font-size:12px;"
                                       onclick="return confirm('Supprimer ce patient ?')">
                                        Supprimer
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
