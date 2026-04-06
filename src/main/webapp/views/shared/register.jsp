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
        .card { background:white; border-radius:16px; padding:40px; width:100%; max-width:480px; box-shadow:0 20px 60px rgba(0,0,0,0.2); }
        h1 { color:#1a73e8; font-size:24px; text-align:center; margin-bottom:4px; }
        .subtitle { color:#888; font-size:14px; text-align:center; margin-bottom:24px; }
        .role-tabs { display:flex; background:#f0f4f8; border-radius:10px; padding:4px; margin-bottom:20px; }
        .role-tab { flex:1; text-align:center; padding:9px; border-radius:8px; cursor:pointer; font-size:14px; font-weight:500; color:#666; border:none; background:none; transition:all 0.2s; }
        .role-tab.active { background:white; color:#1a73e8; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom:14px; }
        label { display:block; font-size:13px; font-weight:600; color:#555; margin-bottom:5px; }
        input, select { width:100%; padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; }
        input:focus, select:focus { outline:none; border-color:#1a73e8; box-shadow:0 0 0 3px rgba(26,115,232,0.1); }
        .row { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        .btn { width:100%; padding:12px; background:#1a73e8; color:white; border:none; border-radius:8px; font-size:15px; font-weight:600; cursor:pointer; margin-top:8px; }
        .btn:hover { background:#1557b0; }
        .alert-danger { background:#fce8e6; color:#c5221f; border-left:4px solid #ea4335; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:14px; }
        .footer { text-align:center; margin-top:18px; font-size:13px; color:#666; }
        .footer a { color:#1a73e8; text-decoration:none; font-weight:500; }
        .section-medecin { display:none; }
    </style>
</head>
<body>
<div class="card">
    <h1>Créer un compte</h1>
    <p class="subtitle">Rejoignez RDV Medical</p>

    <c:if test="${not empty erreur}">
        <div class="alert-danger">${erreur}</div>
    </c:if>

    <div class="role-tabs">
        <button class="role-tab active" onclick="switchRole('patient')">Patient</button>
        <button class="role-tab"        onclick="switchRole('medecin')">Médecin</button>
    </div>

    <form action="${pageContext.request.contextPath}/auth" method="post">
        <input type="hidden" name="action" value="register">
        <input type="hidden" name="role"   id="roleInput" value="patient">

        <%-- Champs communs --%>
        <div class="form-group" id="field-nom-pat">
            <label>Nom complet</label>
            <input type="text" name="nom_pat" placeholder="Ex: Rakoto Jean">
        </div>

        <div class="form-group section-medecin" id="field-nommed">
            <label>Nom du médecin</label>
            <input type="text" name="nommed" placeholder="Ex: Dr. Rasoa Marie">
        </div>

        <div class="form-group" id="field-datenais">
            <label>Date de naissance</label>
            <input type="date" name="datenais">
        </div>

        <%-- Champs médecin uniquement --%>
        <div class="section-medecin">
            <div class="row">
                <div class="form-group">
                    <label>Spécialité</label>
                    <input type="text" name="specialite" placeholder="Ex: Cardiologie">
                </div>
                <div class="form-group">
                    <label>Taux horaire (Ar)</label>
                    <input type="number" name="taux_horaire" placeholder="Ex: 80000">
                </div>
            </div>
            <div class="form-group">
                <label>Lieu / Cabinet</label>
                <input type="text" name="lieu" placeholder="Ex: Antananarivo">
            </div>
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="votre@email.com" required>
        </div>

        <div class="form-group">
            <label>Mot de passe</label>
            <input type="password" name="password" placeholder="Minimum 6 caractères" required>
        </div>

        <button type="submit" class="btn">Créer mon compte</button>
    </form>

    <div class="footer">
        Déjà un compte ?
        <a href="${pageContext.request.contextPath}/views/shared/login.jsp">Se connecter</a>
    </div>
</div>

<script>
    const tabs = document.querySelectorAll('.role-tab');
    function switchRole(role) {
        document.getElementById('roleInput').value = role;
        tabs.forEach((t,i) => t.classList.toggle('active', (role==='patient'&&i===0)||(role==='medecin'&&i===1)));

        const isMedecin = role === 'medecin';
        document.getElementById('field-nom-pat').style.display  = isMedecin ? 'none' : 'block';
        document.getElementById('field-nommed').style.display   = isMedecin ? 'block' : 'none';
        document.getElementById('field-datenais').style.display = isMedecin ? 'none' : 'block';
        document.querySelectorAll('.section-medecin').forEach(el => {
            el.style.display = isMedecin ? 'block' : 'none';
        });
    }
</script>
</body>
</html>
