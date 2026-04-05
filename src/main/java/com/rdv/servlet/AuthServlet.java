package com.rdv.servlet;

import java.io.IOException;

import com.rdv.model.Medecin;
import com.rdv.model.Patient;
import com.rdv.service.MedecinService;
import com.rdv.service.PatientService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Gère la connexion et la déconnexion des patients et médecins.
 * URL : /auth
 * action=login        → connexion
 * action=logout       → déconnexion
 * action=register     → inscription
 */
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private final PatientService patientService = new PatientService();
    private final MedecinService medecinService = new MedecinService();

    // ── GET → afficher le formulaire de connexion ─────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            // Déconnexion : on détruit la session
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        // Afficher la page de connexion
        resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
    }

    // ── POST → traiter connexion ou inscription ───────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("login".equals(action)) {
            traiterConnexion(req, resp);
        } else if ("register".equals(action)) {
            traiterInscription(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
        }
    }

    // ── Connexion ─────────────────────────────────────────────────────────────
    private void traiterConnexion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String role     = req.getParameter("role"); // "patient" ou "medecin"

        HttpSession session = req.getSession();

        if ("medecin".equals(role)) {
            Medecin medecin = medecinService.connecter(email, password);
            if (medecin != null) {
                session.setAttribute("utilisateur", medecin);
                session.setAttribute("role", "medecin");
                session.setAttribute("idUtilisateur", medecin.getIdmed());
                resp.sendRedirect(req.getContextPath() + "/views/medecin/dashboard.jsp");
            } else {
                req.setAttribute("erreur", "Email ou mot de passe incorrect.");
                req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
            }

        } else {
            Patient patient = patientService.connecter(email, password);
            if (patient != null) {
                session.setAttribute("utilisateur", patient);
                session.setAttribute("role", "patient");
                session.setAttribute("idUtilisateur", patient.getIdpat());
                resp.sendRedirect(req.getContextPath() + "/views/patient/dashboard.jsp");
            } else {
                req.setAttribute("erreur", "Email ou mot de passe incorrect.");
                req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
            }
        }
    }

    // ── Inscription ───────────────────────────────────────────────────────────
    private void traiterInscription(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String role = req.getParameter("role");

        if ("medecin".equals(role)) {
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
                req.getRequestDispatcher("/views/shared/register.jsp").forward(req, resp);
            } else {
                req.setAttribute("succes", "Inscription réussie ! Connectez-vous.");
                req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
            }

        } else {
            String erreur = patientService.inscrire(
                req.getParameter("nom_pat"),
                req.getParameter("datenais"),
                req.getParameter("email"),
                req.getParameter("password")
            );
            if (erreur != null) {
                req.setAttribute("erreur", erreur);
                req.getRequestDispatcher("/views/shared/register.jsp").forward(req, resp);
            } else {
                req.setAttribute("succes", "Inscription réussie ! Connectez-vous.");
                req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
            }
        }
    }
}