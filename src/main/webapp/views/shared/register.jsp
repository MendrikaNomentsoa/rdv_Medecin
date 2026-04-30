<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - RDV Medical</title>
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
            max-width: 480px;
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

        .logo-badge svg { width: 32px; height: 32px; }

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

        /* Step indicator */
        .step-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0;
            margin-bottom: 28px;
        }

        .step-dot {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #f0f0f0;
            color: #bbb;
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            position: relative;
            z-index: 1;
        }

        .step-dot.active {
            background: #1a73e8;
            color: white;
        }

        .step-dot.done {
            background: #34a853;
            color: white;
        }

        .step-line {
            flex: 1;
            max-width: 80px;
            height: 2px;
            background: #f0f0f0;
            transition: background 0.3s;
        }

        .step-line.done { background: #34a853; }

        .step-label {
            font-size: 11px;
            color: #bbb;
            text-align: center;
            margin-top: 4px;
        }

        .step-label.active { color: #1a73e8; font-weight: 600; }

        .steps-row {
            display: flex;
            align-items: flex-start;
            gap: 0;
            margin-bottom: 24px;
        }

        .step-col {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .step-col .step-line {
            width: 80px;
            margin-top: 15px;
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

        /* Steps */
        .reg-step { display: none; }
        .reg-step.active { display: block; }

        /* Role cards */
        .role-cards-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 24px;
        }

        .role-card {
            border: 2px solid #e8e8e8;
            border-radius: 16px;
            padding: 24px 16px 20px;
            cursor: pointer;
            text-align: center;
            transition: all 0.2s;
            background: #fafafa;
        }

        .role-card:hover {
            border-color: #a8c4f8;
            background: #f0f6ff;
            transform: translateY(-2px);
        }

        .role-card.selected {
            border-color: #1a73e8;
            background: #f0f6ff;
            box-shadow: 0 0 0 4px rgba(26, 115, 232, 0.12);
        }

        .role-card .role-icon {
            font-size: 40px;
            margin-bottom: 10px;
            display: block;
        }

        .role-card .role-name {
            font-size: 15px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }

        .role-card .role-desc {
            font-size: 11px;
            color: #888;
            line-height: 1.4;
        }

        .role-card.selected .role-name { color: #1a73e8; }

        .role-card .check-badge {
            display: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #1a73e8;
            color: white;
            font-size: 11px;
            font-weight: 700;
            align-items: center;
            justify-content: center;
            margin: 8px auto 0;
        }

        .role-card.selected .check-badge { display: flex; }

        /* Form elements */
        .form-group { margin-bottom: 14px; }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 13px;
            border: 1.5px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            color: #1a1a1a;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fafafa;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1a73e8;
            background: white;
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.12);
        }

        .row2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .pw-wrap { position: relative; }
        .pw-wrap input { padding-right: 44px; }

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

        /* Password strength */
        .pw-strength {
            height: 4px;
            border-radius: 2px;
            margin-top: 6px;
            background: #f0f0f0;
            overflow: hidden;
        }

        .pw-strength-bar {
            height: 100%;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
            width: 0%;
        }

        .pw-hint {
            font-size: 11px;
            margin-top: 4px;
            color: #aaa;
        }

        /* Section title */
        .section-title {
            font-size: 12px;
            font-weight: 700;
            color: #1a73e8;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin: 20px 0 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e8f0fe;
        }

        /* Buttons */
        .btn {
            padding: 11px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #1a73e8;
            color: white;
            border: none;
            width: 100%;
        }

        .btn-primary:hover { background: #1557b0; }
        .btn-primary:active { transform: scale(0.99); }
        .btn-primary:disabled { background: #b0c8f5; cursor: not-allowed; }

        .btn-secondary {
            background: white;
            color: #666;
            border: 1.5px solid #e0e0e0;
        }

        .btn-secondary:hover { background: #f5f5f5; border-color: #bbb; }

        .btn-row {
            display: flex;
            gap: 10px;
            margin-top: 6px;
        }

        .btn-row .btn-secondary { flex: 1; }
        .btn-row .btn-primary { flex: 2; }

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

        /* Step 1 button area */
        .step1-actions {
            margin-top: 4px;
        }

        .role-helper {
            font-size: 13px;
            color: #888;
            text-align: center;
            margin-bottom: 18px;
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
        <h1 class="app-title">Créer un compte</h1>
        <p class="app-subtitle">Rejoignez RDV Medical</p>
    </div>

    <!-- Step indicator -->
    <div class="steps-row">
        <div class="step-col">
            <div class="step-dot active" id="dot1">1</div>
            <div class="step-label active" id="lbl1">Type de compte</div>
        </div>
        <div class="step-line" id="line1"></div>
        <div class="step-col">
            <div class="step-dot" id="dot2">2</div>
            <div class="step-label" id="lbl2">Informations</div>
        </div>
    </div>

    <%-- Alertes serveur --%>
    <c:if test="${not empty erreur}">
        <div class="alert alert-danger">${erreur}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth" method="post" id="registerForm">
        <input type="hidden" name="action" value="register">
        <input type="hidden" name="role" id="roleInput" value="patient">

        <%-- ══════════════════════════════════════
             ÉTAPE 1 — Choix du rôle
        ═══════════════════════════════════════ --%>
        <div class="reg-step active" id="step1">

            <p class="role-helper">Quel type de compte souhaitez-vous créer ?</p>

            <div class="role-cards-row">

                <div class="role-card selected" id="card-patient" onclick="selectRole('patient')">
                    <span class="role-icon">👤</span>
                    <div class="role-name">Patient</div>
                    <div class="role-desc">Prenez et gérez vos rendez-vous médicaux</div>
                    <div class="check-badge">✓</div>
                </div>

                <div class="role-card" id="card-medecin" onclick="selectRole('medecin')">
                    <span class="role-icon">🩺</span>
                    <div class="role-name">Médecin</div>
                    <div class="role-desc">Gérez votre agenda et vos consultations</div>
                    <div class="check-badge">✓</div>
                </div>

            </div>

            <div class="step1-actions">
                <button type="button" class="btn btn-primary" onclick="goStep2()">Continuer</button>
            </div>

            <div class="footer">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/views/shared/login.jsp">Se connecter</a>
            </div>
        </div>

        <%-- ══════════════════════════════════════
             ÉTAPE 2 — Formulaire Patient
        ═══════════════════════════════════════ --%>
        <div class="reg-step" id="step2-patient">

            <div class="section-title">Informations personnelles</div>

            <div class="form-group">
                <label>Nom complet</label>
                <input type="text" name="nom_pat" placeholder="Ex : Rakoto Jean"
                       id="pat-nom" autocomplete="name">
            </div>

            <div class="form-group">
                <label>Date de naissance</label>
                <input type="date" name="datenais" id="pat-datenais">
            </div>

            <div class="section-title">Informations de connexion</div>

            <div class="form-group">
                <label>Adresse email</label>
                <input type="email" name="email" placeholder="votre@email.com"
                       id="pat-email" required autocomplete="email">
            </div>

            <div class="form-group">
                <label>Mot de passe</label>
                <div class="pw-wrap">
                    <input type="password" name="password" id="pat-pw"
                           placeholder="Minimum 6 caractères" required
                           autocomplete="new-password"
                           oninput="checkStrength(this)">
                    <button type="button" class="toggle-password"
                            onclick="togglePw('pat-pw')">👁️</button>
                </div>
                <div class="pw-strength"><div class="pw-strength-bar" id="pat-bar"></div></div>
                <div class="pw-hint" id="pat-hint">Au moins 6 caractères</div>
            </div>

            <div class="btn-row">
                <button type="button" class="btn btn-secondary" onclick="goStep1()">← Retour</button>
                <button type="submit" class="btn btn-primary" id="pat-submit"
                        onclick="return validateStep2('patient')">Créer mon compte</button>
            </div>

            <div class="footer">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/views/shared/login.jsp">Se connecter</a>
            </div>
        </div>

        <%-- ══════════════════════════════════════
             ÉTAPE 2 — Formulaire Médecin
        ═══════════════════════════════════════ --%>
        <div class="reg-step" id="step2-medecin">

            <div class="section-title">Informations professionnelles</div>

            <div class="form-group">
                <label>Nom du médecin</label>
                <input type="text" name="nommed" placeholder="Ex : Dr. Rasoa Marie"
                       id="med-nom" autocomplete="name">
            </div>

            <div class="row2">
                <div class="form-group">
                    <label>Spécialité</label>
                    <input type="text" name="specialite" placeholder="Ex : Cardiologie" id="med-spec">
                </div>
                <div class="form-group">
                    <label>Taux horaire (Ar)</label>
                    <input type="number" name="taux_horaire" placeholder="80 000" id="med-taux" min="0">
                </div>
            </div>

            <div class="form-group">
                <label>Cabinet / Lieu</label>
                <input type="text" name="lieu" placeholder="Ex : Antananarivo" id="med-lieu">
            </div>

            <div class="section-title">Informations de connexion</div>

            <div class="form-group">
                <label>Adresse email</label>
                <input type="email" name="email" placeholder="votre@email.com"
                       id="med-email" required autocomplete="email">
            </div>

            <div class="form-group">
                <label>Mot de passe</label>
                <div class="pw-wrap">
                    <input type="password" name="password" id="med-pw"
                           placeholder="Minimum 6 caractères" required
                           autocomplete="new-password"
                           oninput="checkStrength(this)">
                    <button type="button" class="toggle-password"
                            onclick="togglePw('med-pw')">👁️</button>
                </div>
                <div class="pw-strength"><div class="pw-strength-bar" id="med-bar"></div></div>
                <div class="pw-hint" id="med-hint">Au moins 6 caractères</div>
            </div>

            <div class="btn-row">
                <button type="button" class="btn btn-secondary" onclick="goStep1()">← Retour</button>
                <button type="submit" class="btn btn-primary" id="med-submit"
                        onclick="return validateStep2('medecin')">Créer mon compte</button>
            </div>

            <div class="footer">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/views/shared/login.jsp">Se connecter</a>
            </div>
        </div>

    </form>
</div>

<script>
    /* ── État ── */
    var currentRole = 'patient';

    /* ── Sélection du rôle ── */
    function selectRole(role) {
        currentRole = role;
        document.getElementById('roleInput').value = role;
        document.getElementById('card-patient').classList.toggle('selected', role === 'patient');
        document.getElementById('card-medecin').classList.toggle('selected', role === 'medecin');
    }

    /* ── Navigation étape 1 → 2 ── */
    function goStep2() {
        setStep(2);
    }

    /* ── Navigation étape 2 → 1 ── */
    function goStep1() {
        setStep(1);
    }

    /* ── Affichage des étapes ── */
    function setStep(step) {
        /* Masquer toutes les étapes */
        document.querySelectorAll('.reg-step').forEach(function(el) {
            el.classList.remove('active');
        });

        if (step === 1) {
            document.getElementById('step1').classList.add('active');
            /* Indicateur */
            setDot(1, 'active');
            setDot(2, '');
            setLine(1, '');
        } else {
            /* Afficher le bon formulaire selon le rôle */
            var formId = currentRole === 'medecin' ? 'step2-medecin' : 'step2-patient';
            document.getElementById(formId).classList.add('active');
            /* Indicateur */
            setDot(1, 'done');
            setDot(2, 'active');
            setLine(1, 'done');
        }
    }

    function setDot(n, state) {
        var dot = document.getElementById('dot' + n);
        var lbl = document.getElementById('lbl' + n);
        dot.classList.remove('active', 'done');
        lbl.classList.remove('active');
        if (state) {
            dot.classList.add(state);
            if (state === 'active') lbl.classList.add('active');
        }
    }

    function setLine(n, state) {
        var line = document.getElementById('line' + n);
        line.classList.remove('done');
        if (state) line.classList.add(state);
    }

    /* ── Toggle mot de passe ── */
    function togglePw(id) {
        var input = document.getElementById(id);
        input.type = input.type === 'password' ? 'text' : 'password';
    }

    /* ── Indicateur de force du mot de passe ── */
    function checkStrength(input) {
        var val = input.value;
        var barId  = input.id === 'pat-pw' ? 'pat-bar'  : 'med-bar';
        var hintId = input.id === 'pat-pw' ? 'pat-hint' : 'med-hint';
        var bar  = document.getElementById(barId);
        var hint = document.getElementById(hintId);

        var score = 0;
        if (val.length >= 6)  score++;
        if (val.length >= 10) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        var pct    = [0, 25, 50, 75, 100][Math.min(score, 4)];
        var colors = ['#ea4335', '#ea4335', '#fbbc04', '#34a853', '#1a73e8'];
        var labels = ['Trop court', 'Faible', 'Moyen', 'Bon', 'Excellent'];

        bar.style.width = pct + '%';
        bar.style.background = colors[Math.min(score, 4)];
        hint.textContent = val.length === 0 ? 'Au moins 6 caractères' : labels[Math.min(score, 4)];
        hint.style.color = val.length === 0 ? '#aaa' : colors[Math.min(score, 4)];
    }

    /* ── Validation avant soumission ── */
    function validateStep2(role) {
        var pwId    = role === 'medecin' ? 'med-pw'    : 'pat-pw';
        var emailId = role === 'medecin' ? 'med-email' : 'pat-email';
        var pw      = document.getElementById(pwId).value;
        var email   = document.getElementById(emailId).value;

        if (!email || email.indexOf('@') === -1) {
            alert('Veuillez saisir une adresse email valide.');
            document.getElementById(emailId).focus();
            return false;
        }

        if (pw.length < 6) {
            alert('Le mot de passe doit contenir au moins 6 caractères.');
            document.getElementById(pwId).focus();
            return false;
        }

        return true;
    }
</script>
</body>
</html>
