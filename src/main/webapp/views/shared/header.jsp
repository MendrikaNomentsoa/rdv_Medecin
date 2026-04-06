<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RDV Medical</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f4f8; color: #333; }
        nav {
            background: #1a73e8; padding: 0 30px;
            display: flex; align-items: center; justify-content: space-between;
            height: 60px; box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .nav-brand { color: white; font-size: 20px; font-weight: 700; text-decoration: none; }
        .nav-links { display: flex; align-items: center; gap: 8px; list-style: none; }
        .nav-links a {
            color: rgba(255,255,255,0.9); text-decoration: none;
            padding: 8px 14px; border-radius: 6px; font-size: 14px; transition: background 0.2s;
        }
        .nav-links a:hover { background: rgba(255,255,255,0.2); color: white; }
        .nav-user { color: rgba(255,255,255,0.8); font-size: 13px; padding: 6px 12px; background: rgba(255,255,255,0.15); border-radius: 20px; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 20px; }
        .card { background: white; border-radius: 12px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .card-title { font-size: 20px; font-weight: 600; color: #1a73e8; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #e8f0fe; }
        .btn { display: inline-block; padding: 9px 18px; border-radius: 8px; font-size: 14px; font-weight: 500; text-decoration: none; border: none; cursor: pointer; transition: opacity 0.2s; }
        .btn:hover { opacity: 0.85; }
        .btn-primary  { background: #1a73e8; color: white; }
        .btn-success  { background: #34a853; color: white; }
        .btn-danger   { background: #ea4335; color: white; }
        .btn-warning  { background: #fbbc04; color: #333; }
        .btn-secondary{ background: #6c757d; color: white; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background: #e8f0fe; color: #1a73e8; padding: 12px 14px; text-align: left; font-weight: 600; }
        td { padding: 11px 14px; border-bottom: 1px solid #f0f4f8; }
        tr:hover td { background: #f8faff; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; transition: border-color 0.2s; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #1a73e8; box-shadow: 0 0 0 3px rgba(26,115,232,0.1); }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; }
        .alert-danger  { background: #fce8e6; color: #c5221f; border-left: 4px solid #ea4335; }
        .alert-success { background: #e6f4ea; color: #137333; border-left: 4px solid #34a853; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-success { background: #e6f4ea; color: #137333; }
        .badge-danger  { background: #fce8e6; color: #c5221f; }
    </style>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/" class="nav-brand">RDV Medical</a>
    <ul class="nav-links">
        <c:choose>
            <c:when test="${sessionScope.role == 'medecin'}">
                <li><a href="${pageContext.request.contextPath}/rdv?action=liste">Mes RDV</a></li>
                <li><a href="${pageContext.request.contextPath}/patient?action=liste">Patients</a></li>
                <li><a href="${pageContext.request.contextPath}/medecin?action=top5">Top 5</a></li>
            </c:when>
            <c:when test="${sessionScope.role == 'patient'}">
                <li><a href="${pageContext.request.contextPath}/rdv?action=liste">Mes RDV</a></li>
                <li><a href="${pageContext.request.contextPath}/search">Trouver un médecin</a></li>
            </c:when>
        </c:choose>
    </ul>
    <div style="display:flex; align-items:center; gap:12px;">
        <c:if test="${sessionScope.utilisateur != null}">
            <c:choose>
                <c:when test="${sessionScope.role == 'medecin'}">
                    <span class="nav-user">Dr. ${sessionScope.utilisateur.nommed}</span>
                </c:when>
                <c:otherwise>
                    <span class="nav-user">${sessionScope.utilisateur.nomPat}</span>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/auth?action=logout"
               style="color:white; font-size:13px; padding:7px 14px; background:rgba(255,255,255,0.2); border-radius:6px; text-decoration:none;">
                Déconnexion
            </a>
        </c:if>
    </div>
</nav>
