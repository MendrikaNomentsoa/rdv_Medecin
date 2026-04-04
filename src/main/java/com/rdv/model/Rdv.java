package com.rdv.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Modèle représentant un rendez-vous médical.
 * Correspond à la table RDV en base de données.
 *
 * Contient aussi les objets Medecin et Patient complets
 * pour éviter de faire des jointures manuelles dans les JSP.
 */
public class Rdv {

    // Statuts possibles (correspond au CHECK en BDD)
    public static final String STATUT_CONFIRME = "CONFIRME";
    public static final String STATUT_ANNULE   = "ANNULE";

    private String        idrdv;
    private String        idmed;
    private String        idpat;
    private LocalDateTime dateRdv;
    private String        statut;

    // Objets complets pour les affichages (remplis par jointure SQL)
    private Medecin medecin;
    private Patient patient;

    // ── Constructeurs ────────────────────────────────────────────────────────

    public Rdv() {}

    // Constructeur minimal (pour créer un RDV)
    public Rdv(String idmed, String idpat, LocalDateTime dateRdv) {
        this.idmed   = idmed;
        this.idpat   = idpat;
        this.dateRdv = dateRdv;
        this.statut  = STATUT_CONFIRME;
    }

    // Constructeur complet (pour lire depuis la BDD)
    public Rdv(String idrdv, String idmed, String idpat,
               LocalDateTime dateRdv, String statut) {
        this.idrdv   = idrdv;
        this.idmed   = idmed;
        this.idpat   = idpat;
        this.dateRdv = dateRdv;
        this.statut  = statut;
    }

    // ── Méthodes utilitaires ─────────────────────────────────────────────────

    /**
     * Retourne la date formatée pour affichage dans les JSP.
     * Exemple : "Jeudi 10 avril 2026 à 09h00"
     */
    public String getDateFormatee() {
        if (dateRdv == null) return "";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("EEEE dd MMMM yyyy 'à' HH'h'mm",
                java.util.Locale.FRENCH);
        return dateRdv.format(fmt);
    }

    /**
     * Retourne vrai si le RDV est confirmé.
     */
    public boolean isConfirme() {
        return STATUT_CONFIRME.equals(this.statut);
    }

    /**
     * Retourne vrai si le RDV est annulé.
     */
    public boolean isAnnule() {
        return STATUT_ANNULE.equals(this.statut);
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public String getIdrdv() {
        return idrdv;
    }

    public void setIdrdv(String idrdv) {
        this.idrdv = idrdv;
    }

    public String getIdmed() {
        return idmed;
    }

    public void setIdmed(String idmed) {
        this.idmed = idmed;
    }

    public String getIdpat() {
        return idpat;
    }

    public void setIdpat(String idpat) {
        this.idpat = idpat;
    }

    public LocalDateTime getDateRdv() {
        return dateRdv;
    }

    public void setDateRdv(LocalDateTime dateRdv) {
        this.dateRdv = dateRdv;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Medecin getMedecin() {
        return medecin;
    }

    public void setMedecin(Medecin medecin) {
        this.medecin = medecin;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    // ── toString ─────────────────────────────────────────────────────────────

    @Override
    public String toString() {
        return "Rdv{" +
                "idrdv='"  + idrdv   + '\'' +
                ", idmed='" + idmed   + '\'' +
                ", idpat='" + idpat   + '\'' +
                ", date='"  + dateRdv + '\'' +
                ", statut='" + statut + '\'' +
                '}';
    }
}