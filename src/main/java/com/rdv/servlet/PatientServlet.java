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
import jakarta.servlet.http.HttpSession;

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
                req.getRequestDispatcher("/views/patient/list.jsp").forward(req, resp);
                break;

            case "dashboard":
                afficherDashboard(req, resp);
                break;

            case "form":
                req.getRequestDispatcher("/views/patient/form.jsp").forward(req, resp);
                break;

            case "edit":
                String idEdit = req.getParameter("id");
                if (idEdit == null || idEdit.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
                    return;
                }
                Patient patient = patientService.trouverParId(idEdit);
                if (patient == null) {
                    resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
                    return;
                }
                req.setAttribute("patient", patient);
                req.getRequestDispatcher("/views/patient/form.jsp").forward(req, resp);
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
            String nom = req.getParameter("nom_pat");
            String datenais = req.getParameter("datenais");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            HttpSession session = req.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("role") : null;

            if (id != null && !id.trim().isEmpty()) {
                // Modification
                String erreur = patientService.modifier(id, nom, datenais, email);

                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    Patient patientExistant = patientService.trouverParId(id);
                    req.setAttribute("patient", patientExistant);
                    req.getRequestDispatcher("/views/patient/form.jsp").forward(req, resp);
                    return;
                }

                Patient patientMisAJour = patientService.trouverParId(id);
                if (patientMisAJour != null && session != null) {
                    session.setAttribute("utilisateur", patientMisAJour);
                    session.setAttribute("idUtilisateur", patientMisAJour.getIdpat());
                    req.getSession().setAttribute("messageSucces", "Profil modifié avec succès !");
                }
            } else {
                // Création
                String erreur = patientService.inscrire(nom, datenais, email, password);
                if (erreur != null) {
                    req.setAttribute("erreur", erreur);
                    req.getRequestDispatcher("/views/patient/form.jsp").forward(req, resp);
                    return;
                }
            }

            if ("patient".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/patient?action=dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/patient?action=liste");
    }

    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        Patient patientSession = (Patient) session.getAttribute("utilisateur");
        Patient patientFresh = patientService.trouverParId(patientSession.getIdpat());
        if (patientFresh != null) {
            session.setAttribute("utilisateur", patientFresh);
        }

        String messageSucces = (String) session.getAttribute("messageSucces");
        if (messageSucces != null) {
            req.setAttribute("messageSucces", messageSucces);
            session.removeAttribute("messageSucces");
        }

        req.getRequestDispatcher("/views/patient/dashboard.jsp").forward(req, resp);
    }
}