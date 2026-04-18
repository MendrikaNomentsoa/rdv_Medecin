<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card" style="max-width:560px; margin:0 auto;">

        <h2 class="card-title">
            <c:choose>
                <c:when test="${not empty rdv}">Modifier le rendez-vous</c:when>
                <c:otherwise>Prendre un rendez-vous</c:otherwise>
            </c:choose>
        </h2>

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

        <div id="step1">

            <div class="form-group">
                <label>Choisir une date</label>
                <input type="date" id="dateRdv"
                       onchange="chargerHeuresDisponibles(this.value)"
                       style="width:100%; padding:10px 14px; border:1px solid #ddd;
                              border-radius:8px; font-size:14px;" required>
            </div>

            <div id="msgChoixDate"
                 style="text-align:center; padding:20px; background:#f0f4f8;
                        border-radius:8px; color:#888; font-size:14px; margin-bottom:16px;">
                Choisissez d'abord une date pour voir les créneaux disponibles
            </div>

            <div id="grilleHeures" style="display:none; margin-bottom:16px;">
                <label style="display:block; font-size:13px; font-weight:600;
                               color:#555; margin-bottom:8px;">
                    Choisir une heure
                </label>
                <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:10px;">
                    <button type="button" class="heure-btn" data-heure="08:00" onclick="selectHeure(this)">08h00</button>
                    <button type="button" class="heure-btn" data-heure="09:00" onclick="selectHeure(this)">09h00</button>
                    <button type="button" class="heure-btn" data-heure="10:00" onclick="selectHeure(this)">10h00</button>
                    <button type="button" class="heure-btn" data-heure="11:00" onclick="selectHeure(this)">11h00</button>
                    <button type="button" class="heure-btn" data-heure="14:00" onclick="selectHeure(this)">14h00</button>
                    <button type="button" class="heure-btn" data-heure="15:00" onclick="selectHeure(this)">15h00</button>
                    <button type="button" class="heure-btn" data-heure="16:00" onclick="selectHeure(this)">16h00</button>
                    <button type="button" class="heure-btn" data-heure="17:00" onclick="selectHeure(this)">17h00</button>
                </div>
                <div style="display:flex; gap:16px; margin-top:10px; font-size:12px; color:#666;">
                    <span style="display:flex; align-items:center; gap:5px;">
                        <span style="width:14px;height:14px;background:#1a73e8;
                                     border-radius:3px;display:inline-block;"></span>
                        Sélectionné
                    </span>
                    <span style="display:flex; align-items:center; gap:5px;">
                        <span style="width:14px;height:14px;background:#fce8e6;
                                     border:2px solid #ea4335;border-radius:3px;
                                     display:inline-block;"></span>
                        Déjà réservé
                    </span>
                    <span style="display:flex; align-items:center; gap:5px;">
                        <span style="width:14px;height:14px;background:#f5f5f5;
                                     border:1px solid #ccc;border-radius:3px;
                                     display:inline-block;"></span>
                        Heure passée
                    </span>
                    <span style="display:flex; align-items:center; gap:5px;">
                        <span style="width:14px;height:14px;background:white;
                                     border:2px solid #1a73e8;border-radius:3px;
                                     display:inline-block;"></span>
                        Disponible
                    </span>
                </div>
            </div>

            <div style="display:flex; gap:12px; margin-top:16px;">
                <button type="button" onclick="afficherConfirmation()"
                        class="btn btn-primary" style="flex:1;">
                    Suivant →
                </button>
                <a href="${pageContext.request.contextPath}/rdv?action=liste"
                   class="btn btn-secondary" style="flex:1; text-align:center;">
                    Annuler
                </a>
            </div>
        </div>

        <div id="step2" style="display:none;">
            <div style="background:#e6f4ea; border-radius:10px; padding:20px; margin-bottom:20px;">
                <h3 style="color:#137333; font-size:15px; margin-bottom:16px;">
                    Récapitulatif du rendez-vous
                </h3>
                <table style="width:100%; font-size:14px;">
                    <tr>
                        <td style="padding:8px 0; color:#555; width:40%;">Médecin</td>
                        <td style="padding:8px 0; font-weight:600;">Dr. ${medecin.nommed}</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#555;">Spécialité</td>
                        <td style="padding:8px 0; font-weight:600;">${medecin.specialite}</td>
                    </tr>
                    <tr>
                        <td style="padding:8px 0; color:#555;">Lieu</td>
                        <td style="padding:8px 0; font-weight:600;">${medecin.lieu}</td>
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
                        <td style="padding:8px 0; font-weight:600;">${medecin.tauxHoraire} Ar/h</td>
                    </tr>
                </table>
            </div>

            <div style="background:#fef7e0; border-radius:8px; padding:12px;
                        margin-bottom:20px; font-size:13px; color:#b45309;">
                Un email de confirmation vous sera envoyé après validation.
            </div>

            <form action="${pageContext.request.contextPath}/rdv" method="post">
                <input type="hidden" name="action"   value="prendre">
                <input type="hidden" name="idmed"    value="${medecin.idmed}">
                <input type="hidden" name="idrdv"    value="${rdv.idrdv}">
                <input type="hidden" name="date_rdv" id="dateRdvFinal">

                <div style="display:flex; gap:12px;">
                    <button type="submit" class="btn btn-success" style="flex:1;">
                        <c:choose>
                            <c:when test="${not empty rdv}">Confirmer la modification</c:when>
                            <c:otherwise>Confirmer le rendez-vous</c:otherwise>
                        </c:choose>
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
    .heure-btn:hover:not(.pris):not(.passe) { background: #e8f0fe; }

    /* Bug 1 corrigé : rouge pour les heures déjà réservées */
    .heure-btn.pris {
        background: #fce8e6;
        border-color: #ea4335;
        color: #c5221f;
        cursor: not-allowed;
        text-decoration: line-through;
    }

    /* Gris pour les heures passées */
    .heure-btn.passe {
        background: #f5f5f5;
        border-color: #ccc;
        color: #aaa;
        cursor: not-allowed;
        opacity: 0.6;
    }

    .heure-btn.selected {
        background: #1a73e8;
        color: white;
        border-color: #1a73e8;
    }
</style>

<script>
    const idmed       = '${medecin.idmed}';
    const idrdv       = '${rdv.idrdv}';
    const contextPath = '${pageContext.request.contextPath}';
    let heureSelectionnee = null;

    // Bug 2 corrigé : date minimum = aujourd'hui
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateRdv').min = today;

    // CAS 1 : Modification RDV existant
    <c:if test="${not empty rdv}">
        const dateActuelle  = '${rdv.dateRdv}'.substring(0, 10);
        const heureActuelle = '${rdv.dateRdv}'.substring(11, 16);
        document.getElementById('dateRdv').value = dateActuelle;
        chargerHeuresDisponibles(dateActuelle, heureActuelle);
    </c:if>

    // CAS 2 : Venant de horaires.jsp
    <c:if test="${empty rdv}">
        const datePreselect  = '${not empty datePreselect  ? datePreselect  : ""}';
        const heurePreselect = '${not empty heurePreselect ? heurePreselect : ""}';
        if (datePreselect !== '') {
            document.getElementById('dateRdv').value = datePreselect;
            chargerHeuresDisponibles(datePreselect, heurePreselect);
        }
    </c:if>

    function chargerHeuresDisponibles(date, heureAPreselectionner) {
        if (!date) return;

        heureSelectionnee = null;
        document.querySelectorAll('.heure-btn').forEach(b => {
            b.classList.remove('selected', 'pris', 'passe');
        });

        const url = contextPath + '/rdv?action=heuresPrises&idmed=' + idmed
                  + '&date=' + date
                  + (idrdv ? '&idrdv=' + idrdv : '');

        fetch(url)
            .then(r => r.json())
            .then(heuresPrises => {

                // Heure actuelle pour bloquer les heures passées du jour
                const maintenant   = new Date();
                const estAujourdHui = (date === today);

                document.querySelectorAll('.heure-btn').forEach(btn => {
                    const heure = btn.getAttribute('data-heure');
                    const [h, m] = heure.split(':').map(Number);

                    // Bug 2 : bloquer les heures passées si c'est aujourd'hui
                    const heurePassee = estAujourdHui &&
                        (h < maintenant.getHours() ||
                        (h === maintenant.getHours() && m <= maintenant.getMinutes()));

                    if (heurePassee) {
                        btn.classList.add('passe');
                        btn.title = 'Heure déjà passée';

                    } else if (heuresPrises.includes(heure)) {
                        // Bug 1 : rouge pour les heures réservées
                        btn.classList.add('pris');
                        btn.title = 'Créneau déjà réservé';

                    } else {
                        btn.classList.remove('pris', 'passe');
                        btn.title = 'Créneau disponible';

                        // Pré-sélectionner si demandé
                        if (heureAPreselectionner && heure === heureAPreselectionner) {
                            btn.classList.add('selected');
                            heureSelectionnee = heure;
                        }
                    }
                });

                document.getElementById('msgChoixDate').style.display = 'none';
                document.getElementById('grilleHeures').style.display = 'block';
            })
            .catch(err => console.error('Erreur:', err));
    }

    function selectHeure(btn) {
        if (btn.classList.contains('pris') ||
            btn.classList.contains('passe')) return;
        document.querySelectorAll('.heure-btn').forEach(b => b.classList.remove('selected'));
        btn.classList.add('selected');
        heureSelectionnee = btn.getAttribute('data-heure');
    }

    function afficherConfirmation() {
        const date = document.getElementById('dateRdv').value;
        if (!date)              { alert('Veuillez choisir une date.'); return; }
        if (!heureSelectionnee) { alert('Veuillez choisir une heure disponible.'); return; }

        const dateObj      = new Date(date + 'T00:00:00');
        const options      = { weekday:'long', year:'numeric',
                               month:'long', day:'numeric' };
        const dateFormatee = dateObj.toLocaleDateString('fr-FR', options);

        document.getElementById('confirmDate').textContent  = dateFormatee;
        document.getElementById('confirmHeure').textContent = heureSelectionnee;
        document.getElementById('dateRdvFinal').value       = date + 'T' + heureSelectionnee;

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