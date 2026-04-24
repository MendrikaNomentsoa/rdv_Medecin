<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/shared/header.jsp" %>

<div class="container">
    <!-- En-tête du calendrier -->
    <div class="card" style="margin-bottom:20px;">
        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:15px;">
            <h2 class="card-title" style="margin-bottom:0; border:none;">📅 Calendrier des rendez-vous</h2>
            <div style="display:flex; gap:10px;">
                <a href="${pageContext.request.contextPath}/calendar?year=${year}&month=${month-1}"
                   class="btn btn-secondary">◀ Mois précédent</a>
                <a href="${pageContext.request.contextPath}/calendar?year=<%= java.time.LocalDate.now().getYear() %>&month=<%= java.time.LocalDate.now().getMonthValue() %>"
                   class="btn btn-primary">📅 Aujourd'hui</a>
                <a href="${pageContext.request.contextPath}/calendar?year=${year}&month=${month+1}"
                   class="btn btn-secondary">Mois suivant ▶</a>
            </div>
        </div>
    </div>

    <!-- Statistiques du mois -->
    <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(180px,1fr)); gap:16px; margin-bottom:25px;">
        <div class="stat-card" style="text-align:center;">
            <div class="stat-icon">📋</div>
            <div class="stat-number">${stats.totalRdvs}</div>
            <div class="stat-label">Total rendez-vous</div>
        </div>
        <div class="stat-card" style="text-align:center;">
            <div class="stat-icon">✅</div>
            <div class="stat-number" style="color:#34a853;">${stats.totalConfirmes}</div>
            <div class="stat-label">Confirmés</div>
        </div>
        <div class="stat-card" style="text-align:center;">
            <div class="stat-icon">❌</div>
            <div class="stat-number" style="color:#ea4335;">${stats.totalAnnules}</div>
            <div class="stat-label">Annulés</div>
        </div>
        <div class="stat-card" style="text-align:center;">
            <div class="stat-icon">📊</div>
            <div class="stat-number">${stats.tauxOccupation}%</div>
            <div class="stat-label">Taux d'occupation</div>
        </div>
    </div>

    <!-- Calendrier -->
    <div class="card">
        <h3 class="card-title" style="text-align:center;">${monthName} ${year}</h3>

        <!-- Jours de la semaine -->
        <div style="display:grid; grid-template-columns:repeat(7, 1fr); gap:8px; margin-bottom:12px; text-align:center;">
            <div style="font-weight:bold; color:#ea4335; padding:10px;">Lundi</div>
            <div style="font-weight:bold; padding:10px;">Mardi</div>
            <div style="font-weight:bold; padding:10px;">Mercredi</div>
            <div style="font-weight:bold; padding:10px;">Jeudi</div>
            <div style="font-weight:bold; padding:10px;">Vendredi</div>
            <div style="font-weight:bold; padding:10px;">Samedi</div>
            <div style="font-weight:bold; color:#ea4335; padding:10px;">Dimanche</div>
        </div>

        <!-- Grille des jours -->
        <div style="display:grid; grid-template-columns:repeat(7, 1fr); gap:8px;">
            <c:forEach begin="0" end="${startOffset-1}" var="i">
                <div class="calendar-empty" style="background:var(--border-light); border-radius:12px; min-height:120px;"></div>
            </c:forEach>

            <c:forEach begin="1" end="${daysInMonth}" var="day">
                <c:set var="today" value="<%= java.time.LocalDate.now() %>" />
                <c:set var="isToday" value="${year == today.year && month == today.monthValue && day == today.dayOfMonth}" />

                <div class="calendar-day ${isToday ? 'today' : ''}"
                     data-day="${day}"
                     style="background:var(--bg-card); border-radius:12px; padding:10px; min-height:120px;
                            border:2px solid ${isToday ? '#1a73e8' : 'var(--border-color)'};
                            transition: all 0.2s ease; cursor:pointer;"
                     onclick="openDayModal(${year}, ${month}, ${day})">

                    <div style="font-weight:bold; font-size:16px; margin-bottom:8px; ${isToday ? 'color:#1a73e8;' : ''}">
                        ${day}
                    </div>

                    <div class="rdv-list" style="max-height:80px; overflow-y:auto;">
                        <c:set var="dayRdvs" value="${rdvsByDay[day]}" />
                        <c:if test="${not empty dayRdvs}">
                            <c:forEach items="${dayRdvs}" var="rdv">
                                <c:choose>
                                    <c:when test="${rdv.statut == 'CONFIRME'}">
                                        <div class="rdv-badge" style="font-size:11px; padding:3px 6px; border-radius:6px; margin-bottom:4px; background:#e6f4ea; color:#137333;">
                                            ⏰ ${rdv.heure} - ${rdv.nom}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="rdv-badge" style="font-size:11px; padding:3px 6px; border-radius:6px; margin-bottom:4px; background:#fce8e6; color:#c5221f;">
                                            ⏰ ${rdv.heure} - ${rdv.nom}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Légende -->
        <div style="margin-top:20px; padding-top:15px; border-top:1px solid var(--border-color); display:flex; gap:20px; flex-wrap:wrap; justify-content:center;">
            <div style="display:flex; align-items:center; gap:8px;">
                <div style="width:16px; height:16px; background:#e6f4ea; border-radius:4px;"></div>
                <span style="font-size:12px;">Rendez-vous confirmé</span>
            </div>
            <div style="display:flex; align-items:center; gap:8px;">
                <div style="width:16px; height:16px; background:#fce8e6; border-radius:4px;"></div>
                <span style="font-size:12px;">Rendez-vous annulé</span>
            </div>
            <div style="display:flex; align-items:center; gap:8px;">
                <div style="width:16px; height:16px; background:var(--bg-card); border:2px solid #1a73e8; border-radius:4px;"></div>
                <span style="font-size:12px;">Aujourd'hui</span>
            </div>
        </div>
    </div>
</div>

<!-- Modal pour afficher les détails du jour -->
<div id="dayModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000; align-items:center; justify-content:center;">
    <div class="modal-content" style="background:var(--bg-card); border-radius:16px; max-width:500px; width:90%; max-height:80%; overflow-y:auto; animation: fadeInUp 0.3s ease;">
        <div style="padding:20px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
                <h3 id="modalTitle" style="color:#1a73e8;"></h3>
                <button onclick="closeModal()" style="background:none; border:none; font-size:24px; cursor:pointer; color:var(--text-secondary);">&times;</button>
            </div>
            <div id="modalBody" style="max-height:400px; overflow-y:auto;">
                <!-- Contenu dynamique -->
            </div>
            <div style="margin-top:20px; text-align:center;">
                <button onclick="closeModal()" class="btn btn-secondary">Fermer</button>
            </div>
        </div>
    </div>
</div>

<style>
    .calendar-day {
        transition: all 0.2s ease;
    }

    .calendar-day:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 16px var(--shadow-hover);
        border-color: #1a73e8 !important;
    }

    .calendar-empty {
        transition: all 0.2s ease;
    }

    .rdv-badge {
        transition: all 0.2s ease;
        cursor: pointer;
    }

    .rdv-badge:hover {
        transform: translateX(3px);
        filter: brightness(0.95);
    }

    .today {
        background: linear-gradient(135deg, #e8f0fe, #d4e4fc) !important;
    }

    body.dark-mode .today {
        background: linear-gradient(135deg, #1a2744, #0f1a2e) !important;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .modal-content {
        animation: fadeInUp 0.3s ease;
    }

    /* Scrollbar personnalisée pour la liste des RDV */
    .rdv-list::-webkit-scrollbar {
        width: 4px;
    }

    .rdv-list::-webkit-scrollbar-track {
        background: var(--border-light);
        border-radius: 4px;
    }

    .rdv-list::-webkit-scrollbar-thumb {
        background: #1a73e8;
        border-radius: 4px;
    }
</style>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    let currentRdvsData = {};

    // Récupérer tous les rendez-vous du mois depuis le serveur (via l'attribut JSP)
    <c:forEach items="${rdvsByDay}" var="entry">
        currentRdvsData[${entry.key}] = [
            <c:forEach items="${entry.value}" var="rdv" varStatus="status">
                {
                    idrdv: '${rdv.idrdv}',
                    heure: '${rdv.heure}',
                    statut: '${rdv.statut}',
                    nom: '${rdv.nom}',
                    email: '${rdv.email}',
                    specialite: '${rdv.specialite}',
                    lieu: '${rdv.lieu}'
                }${not status.last ? ',' : ''}
            </c:forEach>
        ];
    </c:forEach>

    function openDayModal(year, month, day) {
        const modal = document.getElementById('dayModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalBody = document.getElementById('modalBody');

        const date = new Date(year, month - 1, day);
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        modalTitle.innerHTML = '📅 ' + date.toLocaleDateString('fr-FR', options);

        const rdvs = currentRdvsData[day] || [];

        if (rdvs.length === 0) {
            modalBody.innerHTML = `
                <div style="text-align:center; padding:40px;">
                    <div style="font-size:48px; margin-bottom:15px;">📭</div>
                    <p style="color:var(--text-secondary);">Aucun rendez-vous ce jour</p>
                </div>
            `;
        } else {
            let html = '<div style="display:flex; flex-direction:column; gap:12px;">';
            for (let i = 0; i < rdvs.length; i++) {
                const rdv = rdvs[i];
                const statusText = rdv.statut === 'CONFIRME' ? 'Confirmé' : 'Annulé';
                const statusColor = rdv.statut === 'CONFIRME' ? '#34a853' : '#ea4335';
                html += `
                    <div class="rdv-detail-card" style="background:var(--hover-bg); border-radius:12px; padding:15px; transition:all 0.2s ease;">
                        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
                            <div>
                                <div style="font-size:18px; font-weight:bold; color:#1a73e8;">⏰ ` + rdv.heure + `</div>
                                <div style="margin-top:8px;">
                                    <strong>👤 ` + rdv.nom + `</strong>
                                </div>`;
                if (rdv.email) {
                    html += `<div style="font-size:12px; color:var(--text-secondary); margin-top:4px;">📧 ` + rdv.email + `</div>`;
                }
                if (rdv.specialite) {
                    html += `<div style="font-size:12px; color:var(--text-secondary); margin-top:4px;">🏥 ` + rdv.specialite + `</div>`;
                }
                if (rdv.lieu) {
                    html += `<div style="font-size:12px; color:var(--text-secondary); margin-top:4px;">📍 ` + rdv.lieu + `</div>`;
                }
                html += `
                            </div>
                            <div>
                                <span class="badge" style="background:` + statusColor + `20; color:` + statusColor + `; padding:4px 10px; border-radius:20px; font-size:12px;">` + statusText + `</span>
                            </div>
                        </div>
                        <div style="margin-top:12px; display:flex; gap:8px;">
                            <a href="${contextPath}/rdv?action=edit&id=` + rdv.idrdv + `" class="btn btn-warning" style="padding:5px 12px; font-size:12px;">✏️ Modifier</a>
                            <a href="${contextPath}/rdv?action=annuler&id=` + rdv.idrdv + `" class="btn btn-danger" style="padding:5px 12px; font-size:12px;" onclick="return confirm('Annuler ce rendez-vous ?')">❌ Annuler</a>
                        </div>
                    </div>
                `;
            }
            html += '</div>';
            modalBody.innerHTML = html;
        }

        modal.style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('dayModal').style.display = 'none';
    }

    // Fermer le modal en cliquant en dehors
    window.onclick = function(event) {
        const modal = document.getElementById('dayModal');
        if (event.target === modal) {
            closeModal();
        }
    }
</script>

</body>
</html>