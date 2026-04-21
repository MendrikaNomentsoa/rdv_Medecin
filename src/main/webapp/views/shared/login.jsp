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
        .card { background:white; border-radius:16px; padding:40px; width:100%; max-width:420px; box-shadow:0 20px 60px rgba(0,0,0,0.2); transition: transform 0.3s ease; }
        .card:hover { transform: translateY(-5px); }
        .logo { text-align: center; margin-bottom: 20px; }
        .logo-icon { font-size: 48px; }
        h1 { color:#1a73e8; font-size:26px; text-align:center; margin-bottom:4px; }
        .subtitle { color:#888; font-size:14px; text-align:center; margin-bottom:28px; }
        .role-tabs { display:flex; background:#f0f4f8; border-radius:10px; padding:4px; margin-bottom:24px; }
        .role-tab { flex:1; text-align:center; padding:9px; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; color:#666; border:none; background:none; transition:all 0.2s; }
        .role-tab.active { background:white; color:#1a73e8; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom:16px; }
        label { display:block; font-size:13px; font-weight:600; color:#555; margin-bottom:6px; }
        .password-container { position: relative; }
        input { width:100%; padding:11px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; transition: all 0.2s; }
        input:focus { outline:none; border-color:#1a73e8; box-shadow:0 0 0 3px rgba(26,115,232,0.1); }
        .toggle-password { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #999; font-size: 18px; }
        .toggle-password:hover { color: #1a73e8; }
        .btn { width:100%; padding:12px; background:#1a73e8; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; transition: background 0.2s; }
        .btn:hover { background:#1557b0; }
        .alert-danger  { background:#fce8e6; color:#c5221f; border-left:4px solid #ea4335; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .alert-success { background:#e6f4ea; color:#137333; border-left:4px solid #34a853; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .footer { text-align:center; margin-top:20px; font-size:13px; color:#666; }
        .footer a { color:#1a73e8; text-decoration:none; font-weight:500; }
        .footer a:hover { text-decoration:underline; }
        .forgot-password { text-align: right; margin-top: -8px; margin-bottom: 16px; }
        .forgot-password a { font-size: 12px; color: #888; text-decoration: none; }
        .forgot-password a:hover { color: #1a73e8; text-decoration: underline; }
        .checkbox-group { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .checkbox-group label { font-size: 13px; font-weight: normal; display: flex; align-items: center; gap: 6px; margin: 0; cursor: pointer; }
        .quick-login-section { margin-bottom: 20px; padding: 12px; background: #f8faff; border-radius: 12px; }
        .quick-login-label { font-size: 12px; color: #666; margin-bottom: 8px; display: block; font-weight: 500; }
        .email-buttons { display: flex; flex-wrap: wrap; gap: 8px; }
        .email-btn {
            background: white;
            border: 1px solid #ddd;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            color: #1a73e8;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }
        .email-btn:hover { background: #e8f0fe; border-color: #1a73e8; }
        .remove-email-btn {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 14px;
            padding: 0 4px;
            border-radius: 50%;
        }
        .remove-email-btn:hover { color: #ea4335; }
        .attempts-warning {
            font-size: 11px;
            color: #ea4335;
            margin-top: 8px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <div class="logo-icon">🏥</div>
    </div>
    <h1>RDV Medical</h1>
    <p class="subtitle">Connectez-vous à votre espace</p>

    <c:if test="${not empty erreur}">
        <div class="alert-danger">${erreur}</div>
    </c:if>
    <c:if test="${not empty succes}">
        <div class="alert-success">${succes}</div>
    </c:if>

    <%-- Afficher les tentatives restantes --%>
    <c:if test="${sessionScope.loginAttempts != null && sessionScope.loginAttempts < 3}">
        <div class="attempts-warning">
            ⚠️ Tentatives restantes : ${3 - sessionScope.loginAttempts}
        </div>
    </c:if>

    <%-- Conteneur pour la connexion rapide --%>
    <div id="quickLoginContainer" class="quick-login-section" style="display: none;"></div>

    <div class="role-tabs">
        <button class="role-tab active" onclick="switchRole('patient')">👤 Patient</button>
        <button class="role-tab"        onclick="switchRole('medecin')">👨‍⚕️ Médecin</button>
    </div>

    <form action="${pageContext.request.contextPath}/auth" method="post" id="loginForm">
        <input type="hidden" name="action" value="login">
        <input type="hidden" name="role"   id="roleInput" value="patient">

        <div class="form-group">
            <label>📧 Email</label>
            <input type="email" name="email" id="emailInput" placeholder="votre@email.com" required>
        </div>

        <div class="form-group">
            <label>🔒 Mot de passe</label>
            <div class="password-container">
                <input type="password" name="password" id="passwordInput" placeholder="••••••••" required>
                <span class="toggle-password" onclick="togglePassword()">👁️</span>
            </div>
        </div>

        <div class="forgot-password">
            <a href="${pageContext.request.contextPath}/views/shared/forgot-password.jsp">Mot de passe oublié ?</a>
        </div>

        <div class="checkbox-group">
            <label>
                <input type="checkbox" name="remember" value="true"> 💡 Se souvenir de moi
            </label>
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
        tabs.forEach((t, i) => {
            t.classList.toggle('active', (role === 'patient' && i === 0) || (role === 'medecin' && i === 1));
        });
        loadQuickLoginEmails(role);
    }

    function loadQuickLoginEmails(role) {
        const container = document.getElementById('quickLoginContainer');
        if (!container) return;

        const cookieName = 'last_emails_' + role;
        const cookies = document.cookie.split(';');
        let lastEmails = '';
        for (let i = 0; i < cookies.length; i++) {
            let cookie = cookies[i].trim();
            if (cookie.startsWith(cookieName + '=')) {
                lastEmails = cookie.substring(cookieName.length + 1);
                break;
            }
        }

        if (lastEmails && lastEmails.split('|').length > 0) {
            const emails = lastEmails.split('|');
            let html = '<label class="quick-login-label">📋 Connexion rapide</label>';
            html += '<div class="email-buttons">';
            for (let i = 0; i < emails.length; i++) {
                if (emails[i]) {
                    html += '<div class="email-btn">';
                    html += '<span onclick="fillEmail(\'' + emails[i].replace(/'/g, "\\'") + '\')" style="cursor:pointer;">' + escapeHtml(emails[i]) + '</span>';
                    html += '<button type="button" class="remove-email-btn" onclick="removeEmail(\'' + emails[i].replace(/'/g, "\\'") + '\', \'' + role + '\')" title="Supprimer de la liste">✕</button>';
                    html += '</div>';
                }
            }
            html += '</div>';
            container.innerHTML = html;
            container.style.display = 'block';
        } else {
            container.innerHTML = '';
            container.style.display = 'none';
        }
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function fillEmail(email) {
        document.getElementById('emailInput').value = email;
        document.getElementById('passwordInput').focus();
    }

    function removeEmail(email, role) {
        if (confirm('Supprimer "' + email + '" de la liste de connexion rapide ?')) {
            window.location.href = '${pageContext.request.contextPath}/auth?action=removeEmail&email=' + encodeURIComponent(email) + '&role=' + role;
        }
    }

    function togglePassword() {
        const input = document.getElementById('passwordInput');
        const type = input.type === 'password' ? 'text' : 'password';
        input.type = type;
    }

    document.addEventListener('DOMContentLoaded', function() {
        loadQuickLoginEmails('patient');
    });
</script>
</body>
</html>