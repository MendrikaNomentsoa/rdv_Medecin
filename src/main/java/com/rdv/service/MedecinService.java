package com.rdv.service;

import java.util.List;

import com.rdv.dao.MedecinDAO;
import com.rdv.model.Medecin;
import com.rdv.util.PasswordUtil;

/**
 * Service pour la logique métier liée aux médecins.
 */
public class MedecinService {

    private final MedecinDAO medecinDAO = new MedecinDAO();

    // ── Inscription ───────────────────────────────────────────────────────────

    public String inscrire(String nom, String specialite, String tauxStr,
                           String lieu, String email, String motDePasse) {

        // Validation
        if (nom == null || nom.trim().isEmpty())
            return "Le nom est obligatoire.";
        if (specialite == null || specialite.trim().isEmpty())
            return "La spécialité est obligatoire.";
        if (lieu == null || lieu.trim().isEmpty())
            return "Le lieu est obligatoire.";
        if (email == null || !email.contains("@"))
            return "Email invalide.";
        if (motDePasse == null || motDePasse.length() < 6)
            return "Le mot de passe doit contenir au moins 6 caractères.";

        int taux;
        try {
            taux = Integer.parseInt(tauxStr);
            if (taux <= 0) return "Le taux horaire doit être positif.";
        } catch (NumberFormatException e) {
            return "Le taux horaire doit être un nombre entier.";
        }

        // Vérifier si l'email existe déjà
        if (medecinDAO.trouverParEmail(email) != null)
            return "Cet email est déjà utilisé.";

        Medecin medecin = new Medecin();
        medecin.setNommed(nom.trim());
        medecin.setSpecialite(specialite.trim());
        medecin.setTauxHoraire(taux);
        medecin.setLieu(lieu.trim());
        medecin.setEmail(email.trim().toLowerCase());
        medecin.setMotDePasse(PasswordUtil.hasher(motDePasse));

        boolean ok = medecinDAO.inserer(medecin);
        return ok ? null : "Erreur lors de l'inscription.";
    }

    // ── Connexion ─────────────────────────────────────────────────────────────

    public Medecin connecter(String email, String motDePasse) {
        if (email == null || motDePasse == null) return null;

        Medecin medecin = medecinDAO.trouverParEmail(email.trim().toLowerCase());
        if (medecin == null) return null;

        if (!PasswordUtil.verifier(motDePasse, medecin.getMotDePasse()))
            return null;

        medecin.setMotDePasse(null);
        return medecin;
    }

    // ── CRUD ─────────────────────────────────────────────────────────────────

    public List<Medecin> listerTous() {
        return medecinDAO.listerTous();
    }

    public Medecin trouverParId(String idmed) {
        return medecinDAO.trouverParId(idmed);
    }

    public List<Medecin> rechercherParNom(String motCle) {
        if (motCle == null || motCle.trim().isEmpty())
            return medecinDAO.listerTous();
        return medecinDAO.rechercherParNom(motCle.trim());
    }

    public List<Medecin> listerParSpecialite(String specialite) {
        return medecinDAO.listerParSpecialite(specialite);
    }

    public List<String> listerSpecialites() {
        return medecinDAO.listerSpecialites();
    }

    public List<Medecin> top5PlusConsultes() {
        return medecinDAO.top5PlusConsultes();
    }

    public String modifier(String idmed, String nom, String specialite,
                           String tauxStr, String lieu, String email) {
        if (nom == null || nom.trim().isEmpty())
            return "Le nom est obligatoire.";
        if (email == null || !email.contains("@"))
            return "Email invalide.";

        int taux;
        try {
            taux = Integer.parseInt(tauxStr);
        } catch (NumberFormatException e) {
            return "Le taux horaire doit être un nombre entier.";
        }

        Medecin medecin = new Medecin();
        medecin.setIdmed(idmed);
        medecin.setNommed(nom.trim());
        medecin.setSpecialite(specialite.trim());
        medecin.setTauxHoraire(taux);
        medecin.setLieu(lieu.trim());
        medecin.setEmail(email.trim().toLowerCase());

        boolean ok = medecinDAO.modifier(medecin);
        return ok ? null : "Erreur lors de la modification.";
    }

    public boolean supprimer(String idmed) {
        return medecinDAO.supprimer(idmed);
    }
}