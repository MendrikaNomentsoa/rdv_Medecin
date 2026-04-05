package com.rdv.servlet;

import java.io.IOException;
import java.util.List;

import com.rdv.model.Medecin;
import com.rdv.service.MedecinService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Gère les opérations CRUD sur les médecins.
 * URL : /medecin
 *
 * GET  action=liste            → liste tous les médecins
 * GET  action=form             → formulaire ajout
 * GET  action=edit&id=..       → formulaire modification
 * GET  action=supprimer&id=..  → supprimer un médecin
 * GET  action=top5             → top 5 médecins les plus consultés
 * POST action=enregistrer      → créer ou modifier un médecin
 */
@WebServlet("/medecin")
public class MedecinServlet extends HttpServlet {

    private final MedecinService medecinService = new MedecinService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {

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
                resp.sendRedirect(req.getContextPath() + "/medecin?action=liste");
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
                // Modification
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
                // Création
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
}