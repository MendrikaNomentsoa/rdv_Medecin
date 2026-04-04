package com.rdv.service;

import java.time.LocalDate;
import java.util.List;

import com.rdv.dao.PatientDAO;
import com.rdv.model.Patient;
import com.rdv.util.PasswordUtil;

/**
 * Service pour la logique métier liée aux patients.
 * Fait le lien entre les Servlets et le PatientDAO.
 */
public class PatientService {

    private final PatientDAO patientDAO = new PatientDAO();

    // ── Inscription ───────────────────────────────────────────────────────────

    /**
     * Inscrit un nouveau patient.
     * Hash le mot de passe avant de l'enregistrer.
     * Retourne null si succès, ou un message d'erreur.
     */
    public String inscrire(String nom, String dateNaisStr,
                           String email, String motDePasse) {

        // Validation
        if (nom == null || nom.trim().isEmpty())
            return "Le nom est obligatoire.";
        if (email == null || !email.contains("@"))
            return "Email invalide.";
        if (motDePasse == null || motDePasse.length() < 6)
            return "Le mot de passe doit contenir au moins 6 caractères.";

        // Vérifier si l'email existe déjà
        if (patientDAO.trouverParEmail(email) != null)
            return "Cet email est déjà utilisé.";

        // Créer le patient
        Patient patient = new Patient();
        patient.setNomPat(nom.trim());
        patient.setDatenais(LocalDate.parse(dateNaisStr));
        patient.setEmail(email.trim().toLowerCase());
        patient.setMotDePasse(PasswordUtil.hasher(motDePasse)); // hashage bcrypt

        boolean ok = patientDAO.inserer(patient);
        return ok ? null : "Erreur lors de l'inscription. Veuillez réessayer.";
    }

    // ── Connexion ─────────────────────────────────────────────────────────────

    /**
     * Vérifie les identifiants d'un patient.
     * Retourne le patient si ok, null sinon.
     */
    public Patient connecter(String email, String motDePasse) {
        if (email == null || motDePasse == null) return null;

        Patient patient = patientDAO.trouverParEmail(email.trim().toLowerCase());
        if (patient == null) return null;

        // Vérifier le mot de passe avec bcrypt
        if (!PasswordUtil.verifier(motDePasse, patient.getMotDePasse()))
            return null;

        // Ne pas garder le hash en mémoire dans la session
        patient.setMotDePasse(null);
        return patient;
    }

    // ── CRUD ─────────────────────────────────────────────────────────────────

    public List<Patient> listerTous() {
        return patientDAO.listerTous();
    }

    public Patient trouverParId(String idpat) {
        return patientDAO.trouverParId(idpat);
    }

    public String modifier(String idpat, String nom,
                           String dateNaisStr, String email) {
        if (nom == null || nom.trim().isEmpty())
            return "Le nom est obligatoire.";
        if (email == null || !email.contains("@"))
            return "Email invalide.";

        Patient patient = new Patient();
        patient.setIdpat(idpat);
        patient.setNomPat(nom.trim());
        patient.setDatenais(LocalDate.parse(dateNaisStr));
        patient.setEmail(email.trim().toLowerCase());

        boolean ok = patientDAO.modifier(patient);
        return ok ? null : "Erreur lors de la modification.";
    }

    public boolean supprimer(String idpat) {
        return patientDAO.supprimer(idpat);
    }
}