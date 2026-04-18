<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <h2 class="card-title" style="margin-bottom:0; border:none;">Mes rendez-vous</h2>
            <c:if test="${sessionScope.role == 'patient'}">
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                    + Prendre un RDV
                </a>
            </c:if>
        </div>

        <c:if test="${not empty erreur}">
            <div class="alert alert-danger">${erreur}</div>
        </c:if>
        <c:if test="${not empty succes}">
            <div class="alert alert-success">${succes}</div>
        </c:if>

        <c:choose>
            <c:when test="${empty rdvs}">
                <div style="text-align:center; padding:50px;">
                    <p style="color:#888; font-size:15px; margin-bottom:16px;">
                        Aucun rendez-vous pour le moment.
                    </p>
                    <c:if test="${sessionScope.role == 'patient'}">
                        <a href="${pageContext.request.contextPath}/search"
                           class="btn btn-primary">
                            Trouver un médecin
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <c:choose>
                                <c:when test="${sessionScope.role == 'medecin'}">
                                    <th>Patient</th>
                                    <th>Email patient</th>
                                </c:when>
                                <c:otherwise>
                                    <th>Médecin</th>
                                    <th>Spécialité</th>
                                </c:otherwise>
                            </c:choose>
                            <th>Date et heure</th>
                            <th>Lieu</th>
                            <th style="text-align:center;">Statut</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${rdvs}">
                            <tr>
                                <c:choose>
                                    <c:when test="${sessionScope.role == 'medecin'}">
                                        <td><strong>${r.patient.nomPat}</strong></td>
                                        <td>${r.patient.email}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td><strong>Dr. ${r.medecin.nommed}</strong></td>
                                        <td>
                                            <span class="badge badge-success">
                                                ${r.medecin.specialite}
                                            </span>
                                        </td>
                                    </c:otherwise>
                                </c:choose>
                                <td>${r.dateFormatee}</td>
                                <td>${r.medecin.lieu}</td>
                                <td style="text-align:center;">
                                    <c:choose>
                                        <c:when test="${r.statut == 'CONFIRME'}">
                                            <span class="badge badge-success">Confirmé</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Annulé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td style="text-align:center;">
                                    <c:choose>

                                        <%-- RDV CONFIRMÉ → Modifier + Annuler --%>
                                        <c:when test="${r.statut == 'CONFIRME'}">
                                            <a href="${pageContext.request.contextPath}/rdv?action=edit&id=${r.idrdv}"
                                               class="btn btn-warning"
                                               style="padding:6px 12px; font-size:12px;">
                                                Modifier
                                            </a>
                                            <a href="${pageContext.request.contextPath}/rdv?action=annuler&id=${r.idrdv}"
                                               class="btn btn-danger"
                                               style="padding:6px 12px; font-size:12px;"
                                               onclick="return confirm('Annuler ce rendez-vous ? Un email sera envoyé.')">
                                                Annuler
                                            </a>
                                        </c:when>

                                        <%-- RDV ANNULÉ → Supprimer uniquement --%>
                                        <c:when test="${r.statut == 'ANNULE'}">
                                            <a href="${pageContext.request.contextPath}/rdv?action=supprimer&id=${r.idrdv}"
                                               class="btn btn-secondary"
                                               style="padding:6px 12px; font-size:12px;"
                                               onclick="return confirm('Supprimer définitivement ce RDV ?')">
                                                Supprimer
                                            </a>
                                        </c:when>

                                    </c:choose>
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