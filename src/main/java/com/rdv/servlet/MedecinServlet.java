package com.rdv.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import com.rdv.model.Medecin;
import com.rdv.model.Rdv;
import com.rdv.service.MedecinService;
import com.rdv.service.RdvService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/medecin")
public class MedecinServlet extends HttpServlet {

    private final MedecinService medecinService = new MedecinService();
    private final RdvService rdvService = new RdvService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            action = "dashboard";
        }

        System.out.println("=== MedecinServlet doGet - Action: " + action + " ===");

        switch (action) {
            case "dashboard":
                afficherDashboard(req, resp);
                break;
            case "liste":
                List<Medecin> liste = medecinService.listerTous();
                req.setAttribute("medecins", liste);
                req.setAttribute("specialites", medecinService.listerSpecialites());
                req.getRequestDispatcher("/views/medecin/list.jsp").forward(req, resp);
                break;
            case "form":
                req.setAttribute("specialites", medecinService.listerSpecialites());
                req.getRequestDispatcher("/views/medecin/form.jsp").forward(req, resp);
                break;
            case "edit":
                String idEdit = req.getParameter("id");
                Medecin medecin = medecinService.trouverParId(idEdit);
                if (medecin == null) {
                    resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
                    return;
                }
                req.setAttribute("medecin", medecin);
                req.setAttribute("specialites", medecinService.listerSpecialites());
                req.getRequestDispatcher("/views/medecin/form.jsp").forward(req, resp);
                break;
            case "supprimer":
                String idSupp = req.getParameter("id");
                medecinService.supprimer(idSupp);
                resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
                break;
            case "top5":
                List<Medecin> top5 = medecinService.top5PlusConsultes();
                req.setAttribute("top5", top5);
                req.getRequestDispatcher("/views/medecin/top5.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/medecin?action=dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("enregistrer".equals(action)) {
            String id = req.getParameter("idmed");

            if (id != null && !id.isEmpty()) {
                String erreur = medecinService.modifier(
                        id,
                        req.getParameter("nommed"),
                        req.getParameter("specialite"),
                        req.getParameter("taux_horaire"),
                        req.getParameter("lieu"),
                        req.getParameter("email")
                );
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    req.setAttribute("medecin", medecinService.trouverParId(id));
                    req.setAttribute("specialites", medecinService.listerSpecialites());
                    req.getRequestDispatcher("/views/medecin/form.jsp").forward(req, resp);
                    return;
                }

                HttpSession session = req.getSession(false);
                if (session != null) {
                    Medecin medecinMisAJour = medecinService.trouverParId(id);
                    if (medecinMisAJour != null) {
                        session.setAttribute("utilisateur", medecinMisAJour);
                        session.setAttribute("idUtilisateur", medecinMisAJour.getIdmed());
                    }
                }
            } else {
                String erreur = medecinService.inscrire(
                        req.getParameter("nommed"),
                        req.getParameter("specialite"),
                        req.getParameter("taux_horaire"),
                        req.getParameter("lieu"),
                        req.getParameter("email"),
                        req.getParameter("password")
                );
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    req.setAttribute("specialites", medecinService.listerSpecialites());
                    req.getRequestDispatcher("/views/medecin/form.jsp").forward(req, resp);
                    return;
                }
            }
        }

        HttpSession session = req.getSession(false);
        String role = (String) session.getAttribute("role");

        if ("medecin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/medecin?action=dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
        }
    }

    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("\n=== AFFICHAGE DASHBOARD MÉDECIN ===");

        HttpSession session = req.getSession(false);
        if (session == null) {
            System.out.println("❌ Session null - redirection login");
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        String idMedecin = (String) session.getAttribute("idUtilisateur");
        System.out.println("ID Médecin: " + idMedecin);

        if (idMedecin == null) {
            System.out.println("❌ ID Médecin null - redirection login");
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        // Récupérer les infos du médecin
        Medecin medecin = medecinService.trouverParId(idMedecin);
        int tauxHoraire = medecin != null ? medecin.getTauxHoraire() : 0;
        req.setAttribute("tauxHoraire", tauxHoraire);
        req.setAttribute("lieu", medecin != null ? medecin.getLieu() : "");

        // Récupérer tous les rendez-vous du médecin
        List<Rdv> rdvs = rdvService.listerParMedecin(idMedecin);
        System.out.println("Nombre de RDV trouvés: " + (rdvs != null ? rdvs.size() : 0));

        LocalDateTime now = LocalDateTime.now();

        // 1. Prochain rendez-vous (RDV futur le plus proche)
        Rdv prochainRdv = null;
        if (rdvs != null && !rdvs.isEmpty()) {
            prochainRdv = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(now) && !"ANNULE".equals(r.getStatut()))
                    .min(Comparator.comparing(Rdv::getDateRdv))
                    .orElse(null);
        }
        req.setAttribute("prochainRdv", prochainRdv);
        System.out.println("Prochain RDV: " + (prochainRdv != null ? prochainRdv.getDateFormatee() : "Aucun"));

        // 2. Statistiques
        long rdvPasses = 0;
        long rdvAVenir = 0;
        long rdvAujourdhui = 0;
        long rdvCetteSemaine = 0;
        long totalPatients = 0;
        long revenusMois = 0;

        if (rdvs != null) {
            rdvPasses = rdvs.stream()
                    .filter(r -> r.getDateRdv().isBefore(now) || "ANNULE".equals(r.getStatut()))
                    .count();
            rdvAVenir = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(now) && !"ANNULE".equals(r.getStatut()))
                    .count();
            rdvAujourdhui = rdvs.stream()
                    .filter(r -> r.getDateRdv().toLocalDate().equals(now.toLocalDate()) && !"ANNULE".equals(r.getStatut()))
                    .count();

            LocalDateTime debutSemaine = now.withHour(0).withMinute(0).withSecond(0)
                    .minusDays(now.getDayOfWeek().getValue() - 1);
            rdvCetteSemaine = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(debutSemaine) && !"ANNULE".equals(r.getStatut()))
                    .count();

            totalPatients = rdvs.stream()
                    .map(Rdv::getIdpat)
                    .filter(id -> id != null)
                    .distinct()
                    .count();

            if (tauxHoraire > 0) {
                LocalDateTime debutMois = now.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
                long nbRdvMois = rdvs.stream()
                        .filter(r -> r.getDateRdv().isAfter(debutMois) && !"ANNULE".equals(r.getStatut()))
                        .count();
                revenusMois = nbRdvMois * tauxHoraire;
            }
        }

        req.setAttribute("nbRdvPasses", rdvPasses);
        req.setAttribute("nbRdvAVenir", rdvAVenir);
        req.setAttribute("rdvAujourdhui", rdvAujourdhui);
        req.setAttribute("rdvCetteSemaine", rdvCetteSemaine);
        req.setAttribute("totalPatients", totalPatients);
        req.setAttribute("revenusMois", revenusMois);

        System.out.println("Statistiques - RDV passés: " + rdvPasses + ", RDV à venir: " + rdvAVenir);
        System.out.println("Statistiques - Aujourd'hui: " + rdvAujourdhui + ", Cette semaine: " + rdvCetteSemaine);
        System.out.println("Statistiques - Patients uniques: " + totalPatients + ", Revenus mois: " + revenusMois);

        // 3. Derniers patients consultés
        List<PatientInfo> derniersPatients = new ArrayList<>();
        if (rdvs != null) {
            System.out.println("\n=== CONSTRUCTION DERNIERS PATIENTS ===");
            rdvs.stream()
                    .filter(r -> r.getPatient() != null && r.getDateRdv().isBefore(now))
                    .sorted(Comparator.comparing(Rdv::getDateRdv).reversed())
                    .limit(5)
                    .forEach(r -> {
                        PatientInfo info = new PatientInfo();
                        info.setNomPat(r.getPatient().getNomPat());
                        info.setEmail(r.getPatient().getEmail());
                        info.setDateDernierRdv(r.getDateRdv().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
                        derniersPatients.add(info);
                        System.out.println("  Patient ajouté: " + info.getNomPat() + " - " + info.getDateDernierRdv());
                    });
        }
        req.setAttribute("derniersPatients", derniersPatients);
        System.out.println("Derniers patients trouvés: " + derniersPatients.size());

        // Vérifier que l'attribut est bien dans la requête
        System.out.println("Attribut 'derniersPatients' dans request: " + (req.getAttribute("derniersPatients") != null));
        System.out.println("=== FIN DASHBOARD ===\n");

        req.getRequestDispatcher("/views/medecin/dashboard.jsp").forward(req, resp);
    }

    // Classe interne pour les infos patient
    public static class PatientInfo {
        private String nomPat;
        private String email;
        private String dateDernierRdv;

        public String getNomPat() { return nomPat; }
        public void setNomPat(String nomPat) { this.nomPat = nomPat; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getDateDernierRdv() { return dateDernierRdv; }
        public void setDateDernierRdv(String dateDernierRdv) { this.dateDernierRdv = dateDernierRdv; }

        @Override
        public String toString() {
            return "PatientInfo{nomPat='" + nomPat + "', email='" + email + "', date='" + dateDernierRdv + "'}";
        }
    }
}