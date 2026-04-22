<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réinitialisation - RDV Medical</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',Arial,sans-serif; background:linear-gradient(135deg,#1a73e8,#0d47a1); min-height:100vh; display:flex; align-items:center; justify-content:center; }
        .card { background:white; border-radius:16px; padding:40px; width:100%; max-width:420px; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        h1 { color:#1a73e8; font-size:24px; text-align:center; margin-bottom:16px; }
        .subtitle { color:#666; font-size:14px; text-align:center; margin-bottom:24px; }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:13px; font-weight:600; color:#555; margin-bottom:6px; }
        .password-container { position: relative; }
        input { width:100%; padding:11px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; }
        input:focus { outline:none; border-color:#1a73e8; box-shadow:0 0 0 3px rgba(26,115,232,0.1); }
        .toggle-password { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #999; font-size: 18px; }
        .toggle-password:hover { color: #1a73e8; }
        .btn { width:100%; padding:12px; background:#1a73e8; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; }
        .btn:hover { background:#1557b0; }
        .alert-danger  { background:#fce8e6; color:#c5221f; border-left:4px solid #ea4335; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .alert-success { background:#e6f4ea; color:#137333; border-left:4px solid #34a853; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; }
        .footer { text-align:center; margin-top:20px; font-size:13px; }
        .footer a { color:#1a73e8; text-decoration:none; }
        .footer a:hover { text-decoration:underline; }
        .requirements { font-size: 11px; color: #666; margin-top: 5px; }
        .requirements.valid { color: #34a853; }
        .requirements.invalid { color: #ea4335; }
    </style>
</head>
<body>
<div class="card">
    <h1>🔐 Nouveau mot de passe</h1>
    <p class="subtitle">Créez un nouveau mot de passe pour votre compte</p>

    <c:if test="${not empty erreur}">
        <div class="alert-danger">${erreur}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth" method="post" id="resetForm">
        <input type="hidden" name="action" value="reset-password">
        <input type="hidden" name="email" value="${param.email != null ? param.email : email}">
        <input type="hidden" name="role" value="${param.role != null ? param.role : role}">
        <input type="hidden" name="token" value="${param.token != null ? param.token : token}">

        <div class="form-group">
            <label>🔒 Nouveau mot de passe</label>
            <div class="password-container">
                <input type="password" name="new_password" id="newPassword" placeholder="Minimum 6 caractères" required>
                <span class="toggle-password" onclick="togglePassword('newPassword')">👁️</span>
            </div>
            <div class="requirements" id="newPasswordReq">✓ Au moins 6 caractères</div>
        </div>

        <div class="form-group">
            <label>🔒 Confirmer le mot de passe</label>
            <div class="password-container">
                <input type="password" name="confirm_password" id="confirmPassword" placeholder="Retapez votre mot de passe" required>
                <span class="toggle-password" onclick="togglePassword('confirmPassword')">👁️</span>
            </div>
            <div class="requirements" id="confirmPasswordReq">✓ Les mots de passe doivent correspondre</div>
        </div>

        <button type="submit" class="btn">Réinitialiser</button>
    </form>

    <div class="footer">
        <a href="${pageContext.request.contextPath}/views/shared/login.jsp">← Retour à la connexion</a>
    </div>
</div>

<script>
    function togglePassword(fieldId) {
        const input = document.getElementById(fieldId);
        const type = input.type === 'password' ? 'text' : 'password';
        input.type = type;
    }

    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    const newPasswordReq = document.getElementById('newPasswordReq');
    const confirmPasswordReq = document.getElementById('confirmPasswordReq');

    function validateNewPassword() {
        const value = newPassword.value;
        const isValid = value.length >= 6;
        newPasswordReq.className = 'requirements ' + (isValid ? 'valid' : 'invalid');
        newPasswordReq.innerHTML = isValid ? '✓ Mot de passe valide' : '✗ Au moins 6 caractères';
        return isValid;
    }

    function validateConfirmPassword() {
        const isValid = newPassword.value === confirmPassword.value && confirmPassword.value.length > 0;
        confirmPasswordReq.className = 'requirements ' + (isValid ? 'valid' : 'invalid');
        confirmPasswordReq.innerHTML = isValid ? '✓ Les mots de passe correspondent' : '✗ Les mots de passe ne correspondent pas';
        return isValid;
    }

    newPassword.addEventListener('input', function() {
        validateNewPassword();
        validateConfirmPassword();
    });

    confirmPassword.addEventListener('input', validateConfirmPassword);

    document.getElementById('resetForm').addEventListener('submit', function(e) {
        if (!validateNewPassword() || !validateConfirmPassword()) {
            e.preventDefault();
            alert('Veuillez corriger les erreurs avant de continuer.');
        }
    });
</script>
</body>
</html>