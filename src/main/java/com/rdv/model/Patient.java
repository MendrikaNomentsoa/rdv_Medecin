package com.rdv.model;

import java.time.LocalDate;

/**
 * Modèle représentant un patient.
 * Correspond exactement à la table PATIENT en base de données.
 */
public class Patient {

    private String    idpat;
    private String    nomPat;
    private LocalDate datenais;
    private String    email;
    private String    motDePasse; // toujours hashé (bcrypt), jamais en clair

    // ── Constructeurs ────────────────────────────────────────────────────────

    public Patient() {}

    // Constructeur sans mot de passe (pour les affichages)
    public Patient(String idpat, String nomPat, LocalDate datenais, String email) {
        this.idpat     = idpat;
        this.nomPat    = nomPat;
        this.datenais  = datenais;
        this.email     = email;
    }

    // Constructeur complet (pour l'inscription)
    public Patient(String idpat, String nomPat, LocalDate datenais,
                   String email, String motDePasse) {
        this.idpat       = idpat;
        this.nomPat      = nomPat;
        this.datenais    = datenais;
        this.email       = email;
        this.motDePasse  = motDePasse;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public String getIdpat() {
        return idpat;
    }

    public void setIdpat(String idpat) {
        this.idpat = idpat;
    }

    public String getNomPat() {
        return nomPat;
    }

    public void setNomPat(String nomPat) {
        this.nomPat = nomPat;
    }

    public LocalDate getDatenais() {
        return datenais;
    }

    public void setDatenais(LocalDate datenais) {
        this.datenais = datenais;
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

    // ── toString (pour les logs, ne jamais afficher le mot de passe) ─────────

    @Override
    public String toString() {
        return "Patient{" +
                "idpat='"   + idpat   + '\'' +
                ", nomPat='" + nomPat  + '\'' +
                ", email='"  + email   + '\'' +
                '}';
    }
}