<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h2 class="card-title" style="margin-bottom:0; border:none;">Liste des médecins</h2>
            <a href="${pageContext.request.contextPath}/medecin?action=form" class="btn btn-primary">
                + Nouveau médecin
            </a>
        </div>

        <%-- Filtre par spécialité --%>
        <form action="${pageContext.request.contextPath}/search" method="get"
              style="display:flex; gap:10px; margin-bottom:20px;">
            <select name="specialite" style="padding:9px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; flex:1;">
                <option value="">Toutes les spécialités</option>
                <c:forEach var="sp" items="${specialites}">
                    <option value="${sp}">${sp}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary">Filtrer</button>
        </form>

        <c:choose>
            <c:when test="${empty medecins}">
                <p style="text-align:center; color:#888; padding:40px;">Aucun médecin enregistré.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Spécialité</th>
                            <th>Taux horaire</th>
                            <th>Lieu</th>
                            <th>Email</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${medecins}">
                            <tr>
                                <td><strong>Dr. ${m.nommed}</strong></td>
                                <td>
                                    <span class="badge badge-success">${m.specialite}</span>
                                </td>
                                <td>${m.tauxHoraire} Ar</td>
                                <td>${m.lieu}</td>
                                <td>${m.email}</td>
                                <td style="text-align:center;">
                                    <a href="${pageContext.request.contextPath}/medecin?action=edit&id=${m.idmed}"
                                       class="btn btn-warning" style="padding:6px 12px; font-size:12px;">
                                        Modifier
                                    </a>
                                    <a href="${pageContext.request.contextPath}/medecin?action=supprimer&id=${m.idmed}"
                                       class="btn btn-danger" style="padding:6px 12px; font-size:12px;"
                                       onclick="return confirm('Supprimer ce médecin ?')">
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
