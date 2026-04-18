<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <div class="card">

        <h2 class="card-title">Créneaux disponibles</h2>

        <c:if test="${not empty medecin}">
            <div style="background:#e8f0fe; border-radius:10px; padding:16px;
                        margin-bottom:24px; display:flex;
                        justify-content:space-between; align-items:center;">
                <div>
                    <h3 style="color:#1a73e8; font-size:16px; margin-bottom:4px;">
                        Dr. ${medecin.nommed}
                    </h3>
                    <span class="badge badge-success">${medecin.specialite}</span>
                    <span style="color:#666; font-size:13px; margin-left:10px;">
                        ${medecin.lieu}
                    </span>
                    <p style="color:#555; font-size:13px; margin-top:6px;">
                        Taux : <strong>${medecin.tauxHoraire} Ar/h</strong>
                    </p>
                </div>
                <a href="${pageContext.request.contextPath}/search"
                   class="btn btn-secondary" style="font-size:13px;">
                    ← Retour
                </a>
            </div>
        </c:if>

        <div class="form-group" style="max-width:300px; margin-bottom:20px;">
            <label>Choisir une date</label>
            <input type="date" id="dateChoisie"
                   onchange="chargerCreneaux(this.value)"
                   style="width:100%; padding:10px 14px; border:1px solid #ddd;
                          border-radius:8px; font-size:14px;">
        </div>

        <div id="msgDate"
             style="text-align:center; padding:30px; background:#f0f4f8;
                    border-radius:10px; color:#888; font-size:14px;">
            Choisissez une date pour voir les créneaux disponibles
        </div>

        <div id="grilleCreneaux" style="display:none;">

            <h3 id="titreDateChoisie"
                style="font-size:15px; color:#555; margin-bottom:16px;"></h3>

            <div id="grilleBoutons"
                 style="display:grid; grid-template-columns:repeat(4, 1fr);
                        gap:12px; margin-bottom:20px;">
            </div>

            <div style="display:flex; gap:16px; margin-bottom:16px;
                        font-size:13px; color:#666; flex-wrap:wrap;">
                <span style="display:flex; align-items:center; gap:6px;">
                    <span style="width:14px;height:14px;background:#e6f4ea;
                                 border:2px solid #34a853;border-radius:3px;
                                 display:inline-block;"></span>
                    Disponible
                </span>
                <span style="display:flex; align-items:center; gap:6px;">
                    <span style="width:14px;height:14px;background:#fce8e6;
                                 border:2px solid #ea4335;border-radius:3px;
                                 display:inline-block;"></span>
                    Déjà réservé
                </span>
                <span style="display:flex; align-items:center; gap:6px;">
                    <span style="width:14px;height:14px;background:#f5f5f5;
                                 border:1px solid #ccc;border-radius:3px;
                                 display:inline-block;"></span>
                    Heure passée
                </span>
            </div>

        </div>
    </div>
</div>

<style>
.creneau {
    padding: 16px 10px;
    border-radius: 10px;
    text-align: center;
    transition: transform 0.15s;
    border-width: 2px;
    border-style: solid;
}
.creneau-dispo {
    background-color: #e6f4ea !important;
    border-color: #34a853 !important;
    color: #137333 !important;
    cursor: pointer;
}
.creneau-dispo:hover {
    transform: translateY(-3px);
}
.creneau-pris {
    background-color: #fce8e6 !important;
    border-color: #ea4335 !important;
    color: #c5221f !important;
    cursor: not-allowed;
}
.creneau-passe {
    background-color: #f5f5f5 !important;
    border-color: #ccc !important;
    color: #aaa !important;
    cursor: not-allowed;
    opacity: 0.6;
}
.creneau-heure {
    font-size: 18px;
    font-weight: 700;
}
.creneau-statut {
    font-size: 11px;
    margin-top: 4px;
    opacity: 0.85;
}
</style>

<script>
    const idmed       = '${medecin.idmed}';
    const contextPath = '${pageContext.request.contextPath}';
    const heures      = ['08:00','09:00','10:00','11:00','14:00','15:00','16:00','17:00'];

    const today = new Date().toISOString().split('T')[0];
    document.getElementById('dateChoisie').min   = today;
    document.getElementById('dateChoisie').value = today;

    chargerCreneaux(today);

    function chargerCreneaux(date) {
        if (!date) return;

        fetch(contextPath + '/rdv?action=heuresPrises&idmed=' + idmed + '&date=' + date)
            .then(r => r.json())
            .then(heuresPrises => {

                const maintenant    = new Date();
                const estAujourdHui = (date === today);

                // Compter disponibles
                let nbDispo = 0;
                heures.forEach(function(heure) {
                    var parts = heure.split(':');
                    var h = parseInt(parts[0]);
                    var m = parseInt(parts[1]);
                    var passee = estAujourdHui && (
                        h < maintenant.getHours() ||
                        (h === maintenant.getHours() && m <= maintenant.getMinutes())
                    );
                    if (!passee && !heuresPrises.includes(heure)) nbDispo++;
                });

                // Titre
                var dateObj      = new Date(date + 'T00:00:00');
                var options      = { weekday:'long', year:'numeric',
                                     month:'long', day:'numeric' };
                var dateFormatee = dateObj.toLocaleDateString('fr-FR', options);
                document.getElementById('titreDateChoisie').textContent =
                    'Créneaux du ' + dateFormatee
                    + ' — ' + nbDispo + ' disponible(s) sur ' + heures.length;

                // Générer les boutons
                var grille = document.getElementById('grilleBoutons');
                grille.innerHTML = '';

                heures.forEach(function(heure) {
                    var parts = heure.split(':');
                    var h = parseInt(parts[0]);
                    var m = parseInt(parts[1]);

                    var passee = estAujourdHui && (
                        h < maintenant.getHours() ||
                        (h === maintenant.getHours() && m <= maintenant.getMinutes())
                    );
                    var pris = heuresPrises.includes(heure);

                    var div = document.createElement('div');
                    div.className = 'creneau';

                    if (passee) {
                        div.classList.add('creneau-passe');
                    } else if (pris) {
                        div.classList.add('creneau-pris');
                    } else {
                        div.classList.add('creneau-dispo');
                        div.onclick = (function(h, d) {
                            return function() {
                                window.location.href = contextPath
                                    + '/rdv?action=form&idmed=' + idmed
                                    + '&date=' + d + '&heure=' + h;
                            };
                        })(heure, date);
                    }

                    div.innerHTML =
                        '<div class="creneau-heure">' + heure + '</div>' +
                        '<div class="creneau-statut">' +
                            (passee ? 'Passée' : pris ? 'Réservé' : 'Disponible') +
                        '</div>';

                    grille.appendChild(div);
                });

                document.getElementById('msgDate').style.display        = 'none';
                document.getElementById('grilleCreneaux').style.display = 'block';
            })
            .catch(function(err) { console.error('Erreur:', err); });
    }
</script>
</body>
</html>