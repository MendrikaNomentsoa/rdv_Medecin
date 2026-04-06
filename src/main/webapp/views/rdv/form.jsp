<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card" style="max-width:560px; margin:0 auto;">

        <h2 class="card-title">Prendre un rendez-vous</h2>

        <%-- Infos médecin --%>
        <c:if test="${not empty medecin}">
            <div style="background:#e8f0fe; border-radius:10px; padding:16px; margin-bottom:24px;">
                <h3 style="color:#1a73e8; font-size:16px; margin-bottom:6px;">
                    Dr. ${medecin.nommed}
                </h3>
                <span class="badge badge-success">${medecin.specialite}</span>
                <span style="color:#666; font-size:13px; margin-left:10px;">${medecin.lieu}</span>
                <p style="color:#555; font-size:13px; margin-top:8px;">
                    Taux : <strong>${medecin.tauxHoraire} Ar/h</strong>
                </p>
            </div>
        </c:if>

        <c:if test="${not empty erreur}">
            <div class="alert alert-danger">${erreur}</div>
        </c:if>

        <%-- Formulaire avec date et heure séparées --%>
        <div id="step1">

            <div class="form-group">
                <label>Date du rendez-vous</label>
                <input type="date" id="dateRdv"
                       style="width:100%; padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px;"
                       required>
            </div>

            <div class="form-group">
                <label>Heure du rendez-vous</label>
                <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-top:6px;">
                    <button type="button" class="heure-btn" data-heure="08:00"
                            onclick="selectHeure(this)">08h00</button>
                    <button type="button" class="heure-btn" data-heure="09:00"
                            onclick="selectHeure(this)">09h00</button>
                    <button type="button" class="heure-btn" data-heure="10:00"
                            onclick="selectHeure(this)">10h00</button>
                    <button type="button" class="heure-btn" data-heure="11:00"
                            onclick="selectHeure(this)">11h00</button>
                    <button type="button" class="heure-btn" data-heure="14:00"
                            onclick="selectHeure(this)">14h00</button>
                    <button type="button" class="heure-btn" data-heure="15:00"
                            onclick="selectHeure(this)">15h00</button>
                    <button type="button" class="heure-btn" data-heure="16:00"
                            onclick="selectHeure(this)">16h00</button>
                    <button type="button" class="heure-btn" data-heure="17:00"
                            onclick="selectHeure(this)">17h00</button>
                </div>
            </div>

            <div style="display:flex; gap:12px; margin-top:20px;">
                <button type="button" onclick="afficherConfirmation()"
                        class="btn btn-primary" style="flex:1;">
                    Suivant →
                </button>
                <a href="${pageContext.request.contextPath}/search"
                   class="btn btn-secondary" style="flex:1; text-align:center;">
                    Annuler
                </a>
            </div>
        </div>

        <%-- Écran de confirmation --%>
        <div id="step2" style="display:none;">

            <div style="background:#e6f4ea; border-radius:10px; padding:20px; margin-bottom:20px;">
                <h3 style="color:#137333; font-size:15px; margin-bottom:16px;">
                    Récapitulatif de votre rendez-vous
                </h3>

                <table style="width:100%; font-size:14px;">
                    <tr>
                        <td style="padding:8px 0; color:#555; width:40%;">Médecin</td>
                        <td style="padding:8px 0; font-weight:600;">
                            Dr. ${medecin.nommed}
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#555;">Spécialité</td>
                        <td style="padding:8px 0; font-weight:600;">
                            ${medecin.specialite}
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#555;">Lieu</td>
                        <td style="padding:8px 0; font-weight:600;">
                            ${medecin.lieu}
                        </td>
                    </tr>
                    <tr style="border-top:2px solid #34a853;">
                        <td style="padding:10px 0; color:#137333; font-weight:600;">Date</td>
                        <td style="padding:10px 0; color:#137333; font-weight:700; font-size:15px;"
                            id="confirmDate">—</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#137333; font-weight:600;">Heure</td>
                        <td style="padding:8px 0; color:#137333; font-weight:700; font-size:15px;"
                            id="confirmHeure">—</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#555;">Taux</td>
                        <td style="padding:8px 0; font-weight:600;">
                            ${medecin.tauxHoraire} Ar/h
                        </td>
                    </tr>
                </table>
            </div>

            <div style="background:#fef7e0; border-radius:8px; padding:12px;
                        margin-bottom:20px; font-size:13px; color:#b45309;">
                Un email de confirmation vous sera envoyé après validation.
            </div>

            <%-- Formulaire caché qui sera soumis --%>
            <form action="${pageContext.request.contextPath}/rdv" method="post">
                <input type="hidden" name="action"  value="prendre">
                <input type="hidden" name="idmed"   value="${medecin.idmed}">
                <input type="hidden" name="date_rdv" id="dateRdvFinal">

                <div style="display:flex; gap:12px;">
                    <button type="submit" class="btn btn-success" style="flex:1;">
                        Confirmer le rendez-vous
                    </button>
                    <button type="button" onclick="retourStep1()"
                            class="btn btn-secondary" style="flex:1;">
                        ← Modifier
                    </button>
                </div>
            </form>
        </div>

    </div>
</div>

<style>
    .heure-btn {
        padding: 10px;
        border: 2px solid #1a73e8;
        border-radius: 8px;
        background: white;
        color: #1a73e8;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
    }
    .heure-btn:hover {
        background: #e8f0fe;
    }
    .heure-btn.selected {
        background: #1a73e8;
        color: white;
    }
    .heure-btn.pris {
        background: #f5f5f5;
        border-color: #ddd;
        color: #aaa;
        cursor: not-allowed;
        text-decoration: line-through;
    }
</style>

<script>
    let heureSelectionnee = null;

    // Définir la date minimum = aujourd'hui
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateRdv').min = today;

    function selectHeure(btn) {
        if (btn.classList.contains('pris')) return;
        // Désélectionner tous
        document.querySelectorAll('.heure-btn').forEach(b => b.classList.remove('selected'));
        // Sélectionner celui cliqué
        btn.classList.add('selected');
        heureSelectionnee = btn.getAttribute('data-heure');
    }

    function afficherConfirmation() {
        const date = document.getElementById('dateRdv').value;

        if (!date) {
            alert('Veuillez choisir une date.');
            return;
        }
        if (!heureSelectionnee) {
            alert('Veuillez choisir une heure.');
            return;
        }

        // Formater la date pour affichage (ex: Jeudi 10 avril 2026)
        const dateObj = new Date(date + 'T00:00:00');
        const options = { weekday:'long', year:'numeric', month:'long', day:'numeric' };
        const dateFormatee = dateObj.toLocaleDateString('fr-FR', options);

        // Mettre à jour l'écran de confirmation
        document.getElementById('confirmDate').textContent  = dateFormatee;
        document.getElementById('confirmHeure').textContent = heureSelectionnee;

        // Construire le datetime pour le serveur (format: 2026-04-10T09:00)
        document.getElementById('dateRdvFinal').value = date + 'T' + heureSelectionnee;

        // Passer à l'étape 2
        document.getElementById('step1').style.display = 'none';
        document.getElementById('step2').style.display = 'block';
    }

    function retourStep1() {
        document.getElementById('step1').style.display = 'block';
        document.getElementById('step2').style.display = 'none';
    }
</script>

</body>
</html>