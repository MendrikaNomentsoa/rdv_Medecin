<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - RDV Medical</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',Arial,sans-serif; background:linear-gradient(135deg,#1a73e8,#0d47a1); min-height:100vh; display:flex; align-items:center; justify-content:center; }
        .card { background:white; border-radius:16px; padding:40px; width:100%; max-width:420px; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        h1 { color:#1a73e8; font-size:26px; text-align:center; margin-bottom:4px; }
        .subtitle { color:#888; font-size:14px; text-align:center; margin-bottom:28px; }
        .role-tabs { display:flex; background:#f0f4f8; border-radius:10px; padding:4px; margin-bottom:24px; }
        .role-tab { flex:1; text-align:center; padding:9px; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; color:#666; border:none; background:none; transition:all 0.2s; }
        .role-tab.active { background:white; color:#1a73e8; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom:16px; }
        label { display:block; font-size:13px; font-weight:600; color:#555; margin-bottom:6px; }
        input { width:100%; padding:11px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; }
        input:focus { outline:none; border-color:#1a73e8; box-shadow:0 0 0 3px rgba(26,115,232,0.1); }
        .btn { width:100%; padding:12px; background:#1a73e8; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; }
        .btn:hover { background:#1557b0; }
        .alert-danger  { background:#fce8e6; color:#c5221f; border-left:4px solid #ea4335; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .alert-success { background:#e6f4ea; color:#137333; border-left:4px solid #34a853; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .footer { text-align:center; margin-top:20px; font-size:13px; color:#666; }
        .footer a { color:#1a73e8; text-decoration:none; font-weight:500; }
    </style>
</head>
<body>
<div class="card">
    <h1>RDV Medical</h1>
    <p class="subtitle">Connectez-vous à votre espace</p>

    <c:if test="${not empty erreur}">
        <div class="alert-danger">${erreur}</div>
    </c:if>
    <c:if test="${not empty succes}">
        <div class="alert-success">${succes}</div>
    </c:if>

    <div class="role-tabs">
        <button class="role-tab active" onclick="switchRole('patient')">Patient</button>
        <button class="role-tab"        onclick="switchRole('medecin')">Médecin</button>
    </div>

    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="login">
        <input type="hidden" name="role"   id="roleInput" value="patient">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="votre@email.com" required>
        </div>
        <div class="form-group">
            <label>Mot de passe</label>
            <input type="password" name="password" placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn">Se connecter</button>
    </form>

    <div class="footer">
        Pas encore de compte ?
        <a href="${pageContext.request.contextPath}/views/shared/register.jsp">S'inscrire</a>
    </div>
</div>
<script>
    const tabs = document.querySelectorAll('.role-tab');
    function switchRole(role) {
        document.getElementById('roleInput').value = role;
        tabs.forEach((t,i) => t.classList.toggle('active', (role==='patient'&&i===0)||(role==='medecin'&&i===1)));
    }
</script>
</body>
</html>
