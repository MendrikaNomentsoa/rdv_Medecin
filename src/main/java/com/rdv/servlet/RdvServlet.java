package com.rdv.servlet;

import java.io.IOException;
import java.util.List;

import com.rdv.model.Rdv;
import com.rdv.service.MedecinService;
import com.rdv.service.RdvService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Gère les rendez-vous.
 * URL : /rdv
 *
 * GET  action=liste          → liste les RDV de l'utilisateur connecté
 * GET  action=form&idmed=..  → formulaire de prise de RDV
 * GET  action=horaires&idmed=.. → créneaux disponibles d'un médecin
 * GET  action=annuler&id=..  → annuler un RDV
 * POST action=prendre        → confirmer la prise de RDV
 */
@WebServlet("/rdv")
public class RdvServlet extends HttpServlet {

    private final RdvService     rdvService     = new RdvService();
    private final MedecinService medecinService = new MedecinService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "liste";

        // Récupérer l'utilisateur connecté depuis la session
        HttpSession session = req.getSession(false);
        String role          = (String) session.getAttribute("role");
        String idUtilisateur = (String) session.getAttribute("idUtilisateur");

        switch (action) {

            case "liste":
                List<Rdv> rdvs;
                if ("medecin".equals(role)) {
                    rdvs = rdvService.listerParMedecin(idUtilisateur);
                } else {
                    rdvs = rdvService.listerParPatient(idUtilisateur);
                }
                req.setAttribute("rdvs", rdvs);
                req.getRequestDispatcher("/views/rdv/list.jsp")
                   .forward(req, resp);
                break;

            case "form":
                String idmed = req.getParameter("idmed");
                req.setAttribute("medecin", medecinService.trouverParId(idmed));
                req.getRequestDispatcher("/views/rdv/form.jsp")
                   .forward(req, resp);
                break;

            case "horaires":
                String idmedH = req.getParameter("idmed");
                req.setAttribute("medecin", medecinService.trouverParId(idmedH));
                req.setAttribute("creneauxPris", rdvService.listerCreneauxPris(idmedH));
                req.getRequestDispatcher("/views/rdv/horaires.jsp")
                   .forward(req, resp);
                break;

            case "annuler":
                String idRdv  = req.getParameter("id");
                String erreur = rdvService.annulerRdv(idRdv);
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                }
                resp.sendRedirect(req.getContextPath() + "/rdv?action=liste");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/rdv?action=liste");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("prendre".equals(action)) {
            HttpSession session    = req.getSession(false);
            String idUtilisateur   = (String) session.getAttribute("idUtilisateur");

            String idmed    = req.getParameter("idmed");
            String dateRdv  = req.getParameter("date_rdv"); // format : 2026-04-10T09:00

            String erreur = rdvService.prendreRdv(idmed, idUtilisateur, dateRdv);

            if (erreur != null) {
                req.setAttribute("erreur", erreur);
                req.setAttribute("medecin", medecinService.trouverParId(idmed));
                req.getRequestDispatcher("/views/rdv/form.jsp")
                   .forward(req, resp);
                return;
            }

            req.setAttribute("succes", "Rendez-vous confirmé ! Un email vous a été envoyé.");
            resp.sendRedirect(req.getContextPath() + "/rdv?action=liste");
        }
    }
}