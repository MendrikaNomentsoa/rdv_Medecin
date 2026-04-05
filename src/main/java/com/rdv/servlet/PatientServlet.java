package com.rdv.servlet;

import java.io.IOException;
import java.util.List;

import com.rdv.model.Patient;
import com.rdv.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Gère les opérations CRUD sur les patients.
 * URL : /patient
 *
 * GET  action=liste      → liste tous les patients
 * GET  action=form       → formulaire ajout
 * GET  action=edit&id=.. → formulaire modification
 * GET  action=supprimer&id=.. → supprimer un patient
 * POST action=enregistrer → créer ou modifier un patient
 */
@WebServlet("/patient")
public class PatientServlet extends HttpServlet {

    private final PatientService patientService = new PatientService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "liste";

        switch (action) {

            case "liste":
                List<Patient> liste = patientService.listerTous();
                req.setAttribute("patients", liste);
                req.getRequestDispatcher("/views/patient/list.jsp")
                   .forward(req, resp);
                break;

            case "form":
                req.getRequestDispatcher("/views/patient/form.jsp")
                   .forward(req, resp);
                break;

            case "edit":
                String idEdit = req.getParameter("id");
                Patient patient = patientService.trouverParId(idEdit);
                if (patient == null) {
                    resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
                    return;
                }
                req.setAttribute("patient", patient);
                req.getRequestDispatcher("/views/patient/form.jsp")
                   .forward(req, resp);
                break;

            case "supprimer":
                String idSupp = req.getParameter("id");
                patientService.supprimer(idSupp);
                resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("enregistrer".equals(action)) {
            String id = req.getParameter("idpat");

            if (id != null && !id.isEmpty()) {
                // Modification
                String erreur = patientService.modifier(
                    id,
                    req.getParameter("nom_pat"),
                    req.getParameter("datenais"),
                    req.getParameter("email")
                );
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    req.setAttribute("patient", patientService.trouverParId(id));
                    req.getRequestDispatcher("/views/patient/form.jsp")
                       .forward(req, resp);
                    return;
                }
            } else {
                // Création
                String erreur = patientService.inscrire(
                    req.getParameter("nom_pat"),
                    req.getParameter("datenais"),
                    req.getParameter("email"),
                    req.getParameter("password")
                );
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    req.getRequestDispatcher("/views/patient/form.jsp")
                       .forward(req, resp);
                    return;
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
    }
}