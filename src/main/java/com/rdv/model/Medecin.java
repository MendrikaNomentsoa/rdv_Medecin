package com.rdv.model;

/**
 * Modèle représentant un médecin.
 * Correspond exactement à la table MEDECIN en base de données.
 */
public class Medecin {

    private String idmed;
    private String nommed;
    private String specialite;
    private int    tauxHoraire;
    private String lieu;
    private String email;
    private String motDePasse; // toujours hashé (bcrypt)

    // ── Constructeurs ────────────────────────────────────────────────────────

    public Medecin() {}

    // Constructeur sans mot de passe (pour les affichages et listes)
    public Medecin(String idmed, String nommed, String specialite,
                   int tauxHoraire, String lieu, String email) {
        this.idmed       = idmed;
        this.nommed      = nommed;
        this.specialite  = specialite;
        this.tauxHoraire = tauxHoraire;
        this.lieu        = lieu;
        this.email       = email;
    }

    // Constructeur complet (pour l'inscription)
    public Medecin(String idmed, String nommed, String specialite,
                   int tauxHoraire, String lieu, String email, String motDePasse) {
        this.idmed       = idmed;
        this.nommed      = nommed;
        this.specialite  = specialite;
        this.tauxHoraire = tauxHoraire;
        this.lieu        = lieu;
        this.email       = email;
        this.motDePasse  = motDePasse;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public String getIdmed() {
        return idmed;
    }

    public void setIdmed(String idmed) {
        this.idmed = idmed;
    }

    public String getNommed() {
        return nommed;
    }

    public void setNommed(String nommed) {
        this.nommed = nommed;
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public int getTauxHoraire() {
        return tauxHoraire;
    }

    public void setTauxHoraire(int tauxHoraire) {
        this.tauxHoraire = tauxHoraire;
    }

    public String getLieu() {
        return lieu;
    }

    public void setLieu(String lieu) {
        this.lieu = lieu;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    // ── toString ─────────────────────────────────────────────────────────────

    @Override
    public String toString() {
        return "Medecin{" +
                "idmed='"      + idmed      + '\'' +
                ", nommed='"   + nommed     + '\'' +
                ", specialite='" + specialite + '\'' +
                ", lieu='"     + lieu       + '\'' +
                '}';
    }
}