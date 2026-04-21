<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription - RDV Medical</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI',Arial,sans-serif; background:linear-gradient(135deg,#1a73e8,#0d47a1); min-height:100vh; display:flex; align-items:center; justify-content:center; padding:20px; }
        .card { background:white; border-radius:16px; padding:40px; width:100%; max-width:500px; box-shadow:0 20px 60px rgba(0,0,0,0.2); transition: transform 0.3s ease; }
        .card:hover { transform: translateY(-5px); }
        .logo { text-align: center; margin-bottom: 20px; }
        .logo-icon { font-size: 48px; }
        h1 { color:#1a73e8; font-size:24px; text-align:center; margin-bottom:4px; }
        .subtitle { color:#888; font-size:14px; text-align:center; margin-bottom:24px; }
        .role-tabs { display:flex; background:#f0f4f8; border-radius:10px; padding:4px; margin-bottom:20px; }
        .role-tab { flex:1; text-align:center; padding:9px; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; color:#666; border:none; background:none; transition:all 0.2s; }
        .role-tab.active { background:white; color:#1a73e8; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom:14px; }
        label { display:block; font-size:13px; font-weight:600; color:#555; margin-bottom:5px; }
        .input-icon {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-icon span {
            position: absolute;
            left: 12px;
            font-size: 16px;
            color: #1a73e8;
        }
        .input-icon input, .input-icon select {
            width: 100%;
            padding: 10px 14px 10px 38px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .input-icon input:focus, .input-icon select:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
        }
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-container span:first-child {
            position: absolute;
            left: 12px;
            font-size: 16px;
            color: #1a73e8;
        }
        .password-container input {
            width: 100%;
            padding: 10px 14px 10px 38px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        .password-container input:focus {
            outline: none;
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
        }
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            font-size: 18px;
        }
        .toggle-password:hover { color: #1a73e8; }
        .row { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        .btn { width:100%; padding:12px; background:#1a73e8; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; transition: background 0.2s; }
        .btn:hover { background:#1557b0; }
        .alert-danger { background:#fce8e6; color:#c5221f; border-left:4px solid #ea4335; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:14px; }
        .footer { text-align:center; margin-top:18px; font-size:13px; color:#666; }
        .footer a { color:#1a73e8; text-decoration:none; font-weight:500; }
        .footer a:hover { text-decoration:underline; }
        .section-medecin { display:none; }
        .password-requirements {
            font-size: 11px;
            color: #666;
            margin-top: 5px;
        }
        .password-requirements.valid { color: #34a853; }
        .password-requirements.invalid { color: #ea4335; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <div class="logo-icon">🏥</div>
    </div>
    <h1>Créer un compte</h1>
    <p class="subtitle">Rejoignez RDV Medical</p>

    <c:if test="${not empty erreur}">
        <div class="alert-danger">${erreur}</div>
    </c:if>

    <div class="role-tabs">
        <button class="role-tab active" onclick="switchRole('patient')">👤 Patient</button>
        <button class="role-tab"        onclick="switchRole('medecin')">👨‍⚕️ Médecin</button>
    </div>

    <form action="${pageContext.request.contextPath}/auth" method="post" id="registerForm">
        <input type="hidden" name="action" value="register">
        <input type="hidden" name="role"   id="roleInput" value="patient">

        <%-- Champs patient --%>
        <div class="form-group" id="field-nom-pat">
            <label>👤 Nom complet</label>
            <div class="input-icon">
                <input type="text" name="nom_pat" placeholder="Ex: Rakoto Jean">
            </div>
        </div>

        <%-- Champs médecin --%>
        <div class="form-group section-medecin" id="field-nommed">
            <label>👨‍⚕️ Nom du médecin</label>
            <div class="input-icon">
                <input type="text" name="nommed" placeholder="Ex: Dr. Rasoa Marie">
            </div>
        </div>

        <div class="form-group" id="field-datenais">
            <label>🎂 Date de naissance</label>
            <div class="input-icon">
                <input type="date" name="datenais">
            </div>
        </div>

        <%-- Champs médecin uniquement --%>
        <div class="section-medecin">
            <div class="row">
                <div class="form-group">
                    <label>🔬 Spécialité</label>
                    <div class="input-icon">
                        <span>🔬</span>
                        <input type="text" name="specialite" placeholder="Ex: Cardiologie">
                    </div>
                </div>
                <div class="form-group">
                    <label>💰 Taux horaire (Ar)</label>
                    <div class="input-icon">
                        <input type="number" name="taux_horaire" placeholder="Ex: 80000">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label>📍 Lieu / Cabinet</label>
                <div class="input-icon">
                    <input type="text" name="lieu" placeholder="Ex: Antananarivo">
                </div>
            </div>
        </div>

        <div class="form-group">
            <label>📧 Email</label>
            <div class="input-icon">
                <input type="email" name="email" placeholder="votre@email.com" required>
            </div>
        </div>

        <div class="form-group">
            <label>🔒 Mot de passe</label>
            <div class="password-container">
                <input type="password" name="password" id="passwordInput" placeholder="Minimum 6 caractères" required>
                <span class="toggle-password" onclick="togglePassword()">👁️</span>
            </div>
            <div class="password-requirements" id="passwordReq">✓ Au moins 6 caractères</div>
        </div>

        <button type="submit" class="btn">Créer mon compte</button>
    </form>

    <div class="footer">
        Déjà un compte ?
        <a href="${pageContext.request.contextPath}/views/shared/login.jsp">🔐 Se connecter</a>
    </div>
</div>

<script>
    const tabs = document.querySelectorAll('.role-tab');

    function switchRole(role) {
        document.getElementById('roleInput').value = role;
        tabs.forEach((t, i) => {
            t.classList.toggle('active', (role === 'patient' && i === 0) || (role === 'medecin' && i === 1));
        });

        const isMedecin = role === 'medecin';
        document.getElementById('field-nom-pat').style.display = isMedecin ? 'none' : 'block';
        document.getElementById('field-nommed').style.display = isMedecin ? 'block' : 'none';
        document.getElementById('field-datenais').style.display = isMedecin ? 'none' : 'block';
        document.querySelectorAll('.section-medecin').forEach(el => {
            el.style.display = isMedecin ? 'block' : 'none';
        });
    }

    function togglePassword() {
        const input = document.getElementById('passwordInput');
        const type = input.type === 'password' ? 'text' : 'password';
        input.type = type;
    }

    // Validation du mot de passe en temps réel
    const passwordInput = document.getElementById('passwordInput');
    const passwordReq = document.getElementById('passwordReq');

    function validatePassword() {
        const value = passwordInput.value;
        const isValid = value.length >= 6;
        passwordReq.className = 'password-requirements ' + (isValid ? 'valid' : 'invalid');
        passwordReq.innerHTML = isValid ? '✓ Mot de passe valide' : '✗ Au moins 6 caractères';
        return isValid;
    }

    passwordInput.addEventListener('input', validatePassword);

    // Validation du formulaire avant soumission
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        if (!validatePassword()) {
            e.preventDefault();
            alert('Le mot de passe doit contenir au moins 6 caractères.');
        }
    });
</script>
</body>
</html>