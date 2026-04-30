<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - RDV Medical</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 24px 64px rgba(0, 0, 0, 0.22);
        }

        /* Logo */
        .logo-area {
            text-align: center;
            margin-bottom: 24px;
        }

        .logo-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background: #e8f0fe;
            border-radius: 16px;
            margin-bottom: 12px;
        }

        .logo-badge svg {
            width: 32px;
            height: 32px;
        }

        .app-title {
            color: #1a1a1a;
            font-size: 22px;
            font-weight: 700;
            margin: 0;
        }

        .app-subtitle {
            color: #888;
            font-size: 13px;
            margin: 4px 0 0;
        }

        /* Alerts */
        .alert {
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 18px;
        }

        .alert-danger {
            background: #fce8e6;
            color: #c5221f;
            border-left: 4px solid #ea4335;
        }

        .alert-success {
            background: #e6f4ea;
            color: #137333;
            border-left: 4px solid #34a853;
        }

        .attempts-warning {
            font-size: 12px;
            color: #ea4335;
            text-align: center;
            margin-bottom: 12px;
            padding: 8px;
            background: #fff8f7;
            border-radius: 8px;
        }

        /* Form */
        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
        }

        .form-group input {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            color: #1a1a1a;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fafafa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #1a73e8;
            background: white;
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.12);
        }

        .pw-wrap {
            position: relative;
        }

        .pw-wrap input {
            padding-right: 44px;
        }

        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 18px;
            color: #aaa;
            padding: 0;
            line-height: 1;
        }

        .toggle-password:hover { color: #1a73e8; }

        .forgot {
            text-align: right;
            margin-top: -10px;
            margin-bottom: 14px;
        }

        .forgot a {
            font-size: 12px;
            color: #888;
            text-decoration: none;
        }

        .forgot a:hover {
            color: #1a73e8;
            text-decoration: underline;
        }

        .remember-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 18px;
        }

        .remember-row input[type="checkbox"] {
            width: 15px;
            height: 15px;
            accent-color: #1a73e8;
            cursor: pointer;
        }

        .remember-row label {
            font-size: 13px;
            color: #555;
            cursor: pointer;
            margin: 0;
        }

        /* Quick login */
        .quick-login-section {
            margin-bottom: 18px;
            padding: 12px 14px;
            background: #f5f8ff;
            border-radius: 12px;
            border: 1px solid #e0eaff;
        }

        .quick-login-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 8px;
            display: block;
            font-weight: 500;
        }

        .email-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .email-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: white;
            border: 1px solid #d0dff8;
            border-radius: 20px;
            padding: 5px 10px;
            font-size: 12px;
            color: #1a73e8;
        }

        .email-pill span {
            cursor: pointer;
        }

        .email-pill span:hover { text-decoration: underline; }

        .remove-email-btn {
            background: none;
            border: none;
            color: #bbb;
            cursor: pointer;
            font-size: 14px;
            padding: 0;
            line-height: 1;
        }

        .remove-email-btn:hover { color: #ea4335; }

        /* Button */
        .btn {
            width: 100%;
            padding: 12px;
            background: #1a73e8;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
        }

        .btn:hover { background: #1557b0; }
        .btn:active { transform: scale(0.99); }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #888;
        }

        .footer a {
            color: #1a73e8;
            text-decoration: none;
            font-weight: 600;
        }

        .footer a:hover { text-decoration: underline; }

        /* Divider */
        .divider {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 20px 0;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e8e8e8;
        }

        .divider span {
            font-size: 12px;
            color: #bbb;
            white-space: nowrap;
        }
    </style>
</head>
<body>

<div class="card">
    <!-- Logo -->
    <div class="logo-area">
        <div class="logo-badge">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z" fill="#1a73e8"/>
                <path d="M10.5 7h3v2.5H16v3h-2.5V15h-3v-2.5H8v-3h2.5V7z" fill="white"/>
            </svg>
        </div>
        <h1 class="app-title">RDV Medical</h1>
        <p class="app-subtitle">Connectez-vous à votre espace</p>
    </div>

    <%-- Alertes serveur --%>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>
    <c:if test="${not empty succes}">
        <div class="alert alert-success">${succes}</div>
    </c:if>

    <%-- Tentatives restantes --%>
    <c:if test="${sessionScope.loginAttempts != null && sessionScope.loginAttempts < 3}">
        <div class="attempts-warning">
            ⚠️ Tentatives restantes : ${3 - sessionScope.loginAttempts}
        </div>
    </c:if>

    <%-- Connexion rapide --%>
    <div id="quickLoginContainer" class="quick-login-section" style="display:none;"></div>

    <%-- Formulaire unique --%>
    <form action="${pageContext.request.contextPath}/auth" method="post" id="loginForm">
        <input type="hidden" name="action" value="login">

        <div class="form-group">
            <label for="emailInput">Adresse email</label>
            <input type="email" name="email" id="emailInput"
                   placeholder="votre@email.com" required autocomplete="email">
        </div>

        <div class="form-group">
            <label for="passwordInput">Mot de passe</label>
            <div class="pw-wrap">
                <input type="password" name="password" id="passwordInput"
                       placeholder="••••••••" required autocomplete="current-password">
                <button type="button" class="toggle-password"
                        onclick="togglePassword()" title="Afficher / Masquer">👁️</button>
            </div>
        </div>

        <div class="forgot">
            <a href="${pageContext.request.contextPath}/views/shared/forgot-password.jsp">
                Mot de passe oublié ?
            </a>
        </div>

        <div class="remember-row">
            <input type="checkbox" name="remember" value="true" id="rememberMe">
            <label for="rememberMe">Se souvenir de moi</label>
        </div>

        <button type="submit" class="btn">Se connecter</button>
    </form>

    <div class="footer">
        Pas encore de compte ?
        <a href="${pageContext.request.contextPath}/views/shared/register.jsp">S'inscrire</a>
    </div>
</div>

<script>
    /* ── Toggle mot de passe ── */
    function togglePassword() {
        const input = document.getElementById('passwordInput');
        input.type = input.type === 'password' ? 'text' : 'password';
    }

    /* ── Connexion rapide (cookies) ── */
    function loadQuickLogin() {
        const container = document.getElementById('quickLoginContainer');
        if (!container) return;

        const allEmails = getStoredEmails();
        if (allEmails.length === 0) {
            container.style.display = 'none';
            return;
        }

        let html = '<span class="quick-login-label">Connexion rapide</span><div class="email-buttons">';
        allEmails.forEach(function(email) {
            const safe = escapeHtml(email);
            const safeJs = email.replace(/'/g, "\\'");
            html += '<div class="email-pill">'
                  + '<span onclick="fillEmail(\'' + safeJs + '\')">' + safe + '</span>'
                  + '<button type="button" class="remove-email-btn" '
                  + 'onclick="removeEmail(\'' + safeJs + '\')" title="Retirer">✕</button>'
                  + '</div>';
        });
        html += '</div>';
        container.innerHTML = html;
        container.style.display = 'block';
    }

    function getStoredEmails() {
        const raw = getCookie('last_emails') || '';
        return raw.split('|').filter(function(e) { return e.trim() !== ''; });
    }

    function getCookie(name) {
        const prefix = name + '=';
        const parts = document.cookie.split(';');
        for (let i = 0; i < parts.length; i++) {
            const c = parts[i].trim();
            if (c.startsWith(prefix)) return decodeURIComponent(c.substring(prefix.length));
        }
        return '';
    }

    function fillEmail(email) {
        document.getElementById('emailInput').value = email;
        document.getElementById('passwordInput').focus();
    }

    function removeEmail(email) {
        if (confirm('Retirer "' + email + '" de la liste de connexion rapide ?')) {
            window.location.href = '${pageContext.request.contextPath}/auth'
                + '?action=removeEmail&email=' + encodeURIComponent(email);
        }
    }

    function escapeHtml(text) {
        const d = document.createElement('div');
        d.textContent = text;
        return d.innerHTML;
    }

    document.addEventListener('DOMContentLoaded', loadQuickLogin);
</script>
</body>
</html>
