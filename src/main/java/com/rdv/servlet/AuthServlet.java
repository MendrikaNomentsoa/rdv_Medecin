package com.rdv.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.rdv.model.Medecin;
import com.rdv.model.Patient;
import com.rdv.service.MedecinService;
import com.rdv.service.PatientService;
import com.rdv.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Gère la connexion et la déconnexion des patients et médecins.
 * URL : /auth
 * action=login           → connexion
 * action=logout          → déconnexion
 * action=register        → inscription
 * action=removeEmail     → supprimer un email de la liste des connexions rapides
 * action=forgot-password → demande réinitialisation mot de passe
 */
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private final PatientService patientService = new PatientService();
    private final MedecinService medecinService = new MedecinService();

    // Nombre maximum de tentatives de connexion
    private static final int MAX_ATTEMPTS = 3;
    // Temps de blocage en millisecondes (15 minutes)
    private static final long BLOCK_TIME = 15 * 60 * 1000;

    // ── GET ───────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                // Supprimer les tentatives de connexion de la session
                session.removeAttribute("loginAttempts");
                session.removeAttribute("blockedUntil");
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        if ("removeEmail".equals(action)) {
            String emailToRemove = req.getParameter("email");
            String role = req.getParameter("role");
            if (emailToRemove != null && !emailToRemove.isEmpty() && role != null) {
                removeEmailFromCookie(req, resp, emailToRemove, role);
            }
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
    }

    // ── POST ──────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("login".equals(action)) {
            traiterConnexion(req, resp);
        } else if ("register".equals(action)) {
            traiterInscription(req, resp);
        } else if ("forgot-password".equals(action)) {
            traiterForgotPassword(req, resp);
        } else if ("reset-password".equals(action)) {
            traiterResetPassword(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/views/shared/login.jsp");
        }
    }

    // ── Connexion avec compteur de tentatives ─────────────────────────────────
    private void traiterConnexion(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        String remember = req.getParameter("remember");

        HttpSession session = req.getSession();

        // Vérifier si le compte est bloqué
        Long blockedUntil = (Long) session.getAttribute("blockedUntil");
        if (blockedUntil != null && System.currentTimeMillis() < blockedUntil) {
            long remainingMinutes = (blockedUntil - System.currentTimeMillis()) / (60 * 1000);
            req.setAttribute("erreur", "Trop de tentatives. Réessayez dans " + (remainingMinutes + 1) + " minutes.");
            req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
            return;
        } else if (blockedUntil != null) {
            // Débloquer après le temps écoulé
            session.removeAttribute("loginAttempts");
            session.removeAttribute("blockedUntil");
        }

        boolean authentifie = false;

        if ("medecin".equals(role)) {
            Medecin medecin = medecinService.connecter(email, password);
            if (medecin != null) {
                authentifie = true;
                session.setAttribute("utilisateur", medecin);
                session.setAttribute("role", "medecin");
                session.setAttribute("idUtilisateur", medecin.getIdmed());

                // Sauvegarder l'email dans le cookie
                saveEmailToCookie(req, resp, email, role);
            }
        } else {
            Patient patient = patientService.connecter(email, password);
            if (patient != null) {
                authentifie = true;
                session.setAttribute("utilisateur", patient);
                session.setAttribute("role", "patient");
                session.setAttribute("idUtilisateur", patient.getIdpat());

                // Sauvegarder l'email dans le cookie
                saveEmailToCookie(req, resp, email, role);
            }
        }

        if (authentifie) {
            // Réinitialiser les tentatives après connexion réussie
            session.removeAttribute("loginAttempts");
            session.removeAttribute("blockedUntil");

            // "Se souvenir de moi" - prolonger la durée de session
            if ("true".equals(remember)) {
                session.setMaxInactiveInterval(60 * 60 * 24 * 7); // 7 jours
            } else {
                session.setMaxInactiveInterval(60 * 30); // 30 minutes
            }

            // Redirection selon le rôle
            if ("medecin".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/views/medecin/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/views/patient/dashboard.jsp");
            }
        } else {
            // Incrémenter le compteur de tentatives
            Integer attempts = (Integer) session.getAttribute("loginAttempts");
            if (attempts == null) {
                attempts = 1;
            } else {
                attempts++;
            }
            session.setAttribute("loginAttempts", attempts);

            int remainingAttempts = MAX_ATTEMPTS - attempts;

            if (attempts >= MAX_ATTEMPTS) {
                // Bloquer le compte
                long blockUntil = System.currentTimeMillis() + BLOCK_TIME;
                session.setAttribute("blockedUntil", blockUntil);
                req.setAttribute("erreur", "Trop de tentatives échouées. Compte bloqué pour 15 minutes.");
            } else {
                req.setAttribute("erreur", "Email ou mot de passe incorrect. Il vous reste " + remainingAttempts + " tentative(s).");
            }
            req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
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

    // ── Mot de passe oublié ───────────────────────────────────────────────────
    private void traiterForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String role = req.getParameter("role");

        if (email == null || email.isEmpty()) {
            req.setAttribute("erreur", "Veuillez entrer votre email.");
            req.getRequestDispatcher("/views/shared/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Générer un token unique
        String token = java.util.UUID.randomUUID().toString();

        // Sauvegarder le token en session (pour la validation)
        HttpSession session = req.getSession();
        session.setAttribute("reset_token_" + email, token);
        session.setAttribute("reset_role_" + email, role);
        session.setMaxInactiveInterval(60 * 30); // Token valable 30 minutes

        // Rediriger vers la page de réinitialisation
        req.setAttribute("email", email);
        req.setAttribute("role", role);
        req.setAttribute("token", token);
        req.getRequestDispatcher("/views/shared/reset-password.jsp").forward(req, resp);
    }

    // ── Réinitialisation du mot de passe ──────────────────────────────────────
    private void traiterResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String role = req.getParameter("role");
        String token = req.getParameter("token");
        String newPassword = req.getParameter("new_password");
        String confirmPassword = req.getParameter("confirm_password");

        HttpSession session = req.getSession();
        String savedToken = (String) session.getAttribute("reset_token_" + email);
        String savedRole = (String) session.getAttribute("reset_role_" + email);

        // Vérifier le token
        if (savedToken == null || !savedToken.equals(token)) {
            req.setAttribute("erreur", "Lien invalide ou expiré. Veuillez recommencer.");
            req.getRequestDispatcher("/views/shared/forgot-password.jsp").forward(req, resp);
            return;
        }

        // Vérifier les mots de passe
        if (newPassword == null || newPassword.length() < 6) {
            req.setAttribute("erreur", "Le mot de passe doit contenir au moins 6 caractères.");
            req.setAttribute("email", email);
            req.setAttribute("role", role);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/shared/reset-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("erreur", "Les mots de passe ne correspondent pas.");
            req.setAttribute("email", email);
            req.setAttribute("role", role);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/views/shared/reset-password.jsp").forward(req, resp);
            return;
        }

        // Mettre à jour le mot de passe
        String hashedPassword = PasswordUtil.hasher(newPassword);
        boolean updated = false;

        if ("medecin".equals(role)) {
            Medecin medecin = medecinService.trouverParEmail(email);
            if (medecin != null) {
                medecin.setMotDePasse(hashedPassword);
                updated = medecinService.modifierMotDePasse(medecin);
            }
        } else {
            Patient patient = patientService.trouverParEmail(email);
            if (patient != null) {
                patient.setMotDePasse(hashedPassword);
                updated = patientService.modifierMotDePasse(patient);
            }
        }

        if (updated) {
            // Nettoyer la session
            session.removeAttribute("reset_token_" + email);
            session.removeAttribute("reset_role_" + email);
            req.setAttribute("succes", "Mot de passe réinitialisé avec succès ! Connectez-vous.");
            req.getRequestDispatcher("/views/shared/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("erreur", "Email non trouvé. Veuillez vérifier votre adresse.");
            req.getRequestDispatcher("/views/shared/forgot-password.jsp").forward(req, resp);
        }
    }

    // ── Sauvegarder l'email dans un cookie ────────────────────────────────────
    private void saveEmailToCookie(HttpServletRequest req, HttpServletResponse resp, String newEmail, String role) {
        String cookieName = "last_emails_" + role;
        String existing = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (cookieName.equals(c.getName())) {
                    existing = c.getValue();
                    break;
                }
            }
        }

        List<String> emails = new ArrayList<>();
        if (existing != null && !existing.isEmpty()) {
            String[] parts = existing.split("\\|");
            for (String p : parts) {
                if (p != null && !p.isEmpty()) {
                    emails.add(p);
                }
            }
        }
        emails.removeIf(e -> e.equals(newEmail));
        emails.add(0, newEmail);

        if (emails.size() > 5) {
            emails = emails.subList(0, 5);
        }

        String newValue = String.join("|", emails);
        Cookie emailCookie = new Cookie(cookieName, newValue);
        emailCookie.setMaxAge(60 * 60 * 24 * 30);
        emailCookie.setPath("/");
        resp.addCookie(emailCookie);
    }

    // ── Supprimer un email du cookie ──────────────────────────────────────────
    private void removeEmailFromCookie(HttpServletRequest req, HttpServletResponse resp, String emailToRemove, String role) {
        String cookieName = "last_emails_" + role;
        String existing = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (cookieName.equals(c.getName())) {
                    existing = c.getValue();
                    break;
                }
            }
        }

        List<String> emails = new ArrayList<>();
        if (existing != null && !existing.isEmpty()) {
            String[] parts = existing.split("\\|");
            for (String p : parts) {
                if (p != null && !p.isEmpty() && !p.equals(emailToRemove)) {
                    emails.add(p);
                }
            }
        }

        String newValue = String.join("|", emails);
        Cookie emailCookie = new Cookie(cookieName, newValue);
        emailCookie.setMaxAge(60 * 60 * 24 * 30);
        emailCookie.setPath("/");
        resp.addCookie(emailCookie);
    }
}