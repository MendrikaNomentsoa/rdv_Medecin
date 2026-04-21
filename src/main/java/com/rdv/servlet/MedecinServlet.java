package com.rdv.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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

        switch (action) {

            case "dashboard":
                afficherDashboard(req, resp);
                break;

            case "liste":
                List<Medecin> liste = medecinService.listerTous();
                req.setAttribute("medecins", liste);
                req.setAttribute("specialites", medecinService.listerSpecialites());
                req.getRequestDispatcher("/views/medecin/list.jsp")
                        .forward(req, resp);
                break;

            case "form":
                req.setAttribute("specialites", medecinService.listerSpecialites());
                req.getRequestDispatcher("/views/medecin/form.jsp")
                        .forward(req, resp);
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
                req.getRequestDispatcher("/views/medecin/form.jsp")
                        .forward(req, resp);
                break;

            case "supprimer":
                String idSupp = req.getParameter("id");
                medecinService.supprimer(idSupp);
                resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
                break;

            case "top5":
                List<Medecin> top5 = medecinService.top5PlusConsultes();
                req.setAttribute("top5", top5);
                req.getRequestDispatcher("/views/medecin/top5.jsp")
                        .forward(req, resp);
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
                    req.getRequestDispatcher("/views/medecin/form.jsp")
                            .forward(req, resp);
                    return;
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
                    req.getRequestDispatcher("/views/medecin/form.jsp")
                            .forward(req, resp);
                    return;
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
    }

    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        String idMedecin = (String) session.getAttribute("idUtilisateur");

        if (idMedecin == null) {
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        // Récupérer tous les rendez-vous du médecin
        List<Rdv> rdvs = rdvService.listerParMedecin(idMedecin);
        LocalDateTime now = LocalDateTime.now();

        // DEBUG - Afficher dans la console
        System.out.println("=== DASHBOARD MEDECIN ===");
        System.out.println("Nombre total de RDV: " + (rdvs != null ? rdvs.size() : 0));

        // 1. Prochain rendez-vous
        Rdv prochainRdv = null;
        if (rdvs != null && !rdvs.isEmpty()) {
            prochainRdv = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(now) && !"ANNULE".equals(r.getStatut()))
                    .min(Comparator.comparing(Rdv::getDateRdv))
                    .orElse(null);
        }
        req.setAttribute("prochainRdv", prochainRdv);

        // 2. Statistiques de base
        long rdvPasses = 0;
        long rdvAVenir = 0;
        if (rdvs != null) {
            rdvPasses = rdvs.stream()
                    .filter(r -> r.getDateRdv().isBefore(now) || "ANNULE".equals(r.getStatut()))
                    .count();
            rdvAVenir = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(now) && !"ANNULE".equals(r.getStatut()))
                    .count();
        }
        req.setAttribute("nbRdvPasses", rdvPasses);
        req.setAttribute("nbRdvAVenir", rdvAVenir);
        System.out.println("RDV passés: " + rdvPasses + ", à venir: " + rdvAVenir);

        // 3. Nombre de patients uniques
        long totalPatients = 0;
        if (rdvs != null) {
            totalPatients = rdvs.stream()
                    .map(Rdv::getIdpat)
                    .distinct()
                    .count();
        }
        req.setAttribute("totalPatients", totalPatients);
        System.out.println("Total patients uniques: " + totalPatients);

        // 4. Taux horaire du médecin
        Medecin medecin = medecinService.trouverParId(idMedecin);
        int tauxHoraire = medecin != null ? medecin.getTauxHoraire() : 0;
        req.setAttribute("tauxHoraire", tauxHoraire);
        req.setAttribute("lieu", medecin != null ? medecin.getLieu() : "");

        // 5. RDV aujourd'hui
        long rdvAujourdhui = 0;
        if (rdvs != null) {
            rdvAujourdhui = rdvs.stream()
                    .filter(r -> r.getDateRdv().toLocalDate().equals(now.toLocalDate()) && !"ANNULE".equals(r.getStatut()))
                    .count();
        }
        req.setAttribute("rdvAujourdhui", rdvAujourdhui);
        System.out.println("RDV aujourd'hui: " + rdvAujourdhui);

        // 6. RDV cette semaine
        long rdvCetteSemaine = 0;
        if (rdvs != null) {
            // Début de la semaine (lundi)
            LocalDateTime debutSemaine = now.withHour(0).withMinute(0).withSecond(0).minusDays(now.getDayOfWeek().getValue() - 1);
            rdvCetteSemaine = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(debutSemaine) && !"ANNULE".equals(r.getStatut()))
                    .count();
        }
        req.setAttribute("rdvCetteSemaine", rdvCetteSemaine);
        System.out.println("RDV cette semaine: " + rdvCetteSemaine);

        // 7. Revenus du mois
        long revenusMois = 0;
        if (rdvs != null && tauxHoraire > 0) {
            LocalDateTime debutMois = now.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            long nbRdvMois = rdvs.stream()
                    .filter(r -> r.getDateRdv().isAfter(debutMois) && !"ANNULE".equals(r.getStatut()))
                    .count();
            revenusMois = nbRdvMois * tauxHoraire;
        }
        req.setAttribute("revenusMois", revenusMois);
        System.out.println("Revenus du mois: " + revenusMois + " Ar");

        // 8. Derniers patients consultés
        List<PatientInfo> derniersPatients = new ArrayList<>();
        if (rdvs != null) {
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
                    });
        }
        req.setAttribute("derniersPatients", derniersPatients);
        System.out.println("Derniers patients: " + derniersPatients.size());
        System.out.println("=========================");

        req.getRequestDispatcher("/views/medecin/dashboard.jsp").forward(req, resp);
    }

    private static class PatientInfo {
        private String nomPat;
        private String email;
        private String dateDernierRdv;

        public String getNomPat() { return nomPat; }
        public void setNomPat(String nomPat) { this.nomPat = nomPat; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getDateDernierRdv() { return dateDernierRdv; }
        public void setDateDernierRdv(String dateDernierRdv) { this.dateDernierRdv = dateDernierRdv; }
    }
}