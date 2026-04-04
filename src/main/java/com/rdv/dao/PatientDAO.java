package com.rdv.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.rdv.model.Patient;
import com.rdv.util.DBConnection;

/**
 * DAO pour la table PATIENT.
 * Toutes les requêtes SQL liées aux patients sont ici.
 */
public class PatientDAO {

    // ── CREATE ───────────────────────────────────────────────────────────────

    public boolean inserer(Patient patient) {
        String sql = "INSERT INTO patient (nom_pat, datenais, email, mot_de_passe) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getNomPat());
            ps.setDate(2, Date.valueOf(patient.getDatenais()));
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getMotDePasse()); // déjà hashé en bcrypt

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur inserer : " + e.getMessage());
            return false;
        }
    }

    // ── READ ─────────────────────────────────────────────────────────────────

    public List<Patient> listerTous() {
        List<Patient> liste = new ArrayList<>();
        String sql = "SELECT idpat, nom_pat, datenais, email FROM patient ORDER BY nom_pat";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                liste.add(mapper(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur listerTous : " + e.getMessage());
        }
        return liste;
    }

    public Patient trouverParId(String idpat) {
        String sql = "SELECT idpat, nom_pat, datenais, email FROM patient WHERE idpat = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idpat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapper(rs);
            }

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur trouverParId : " + e.getMessage());
        }
        return null;
    }

    public Patient trouverParEmail(String email) {
        String sql = "SELECT idpat, nom_pat, datenais, email, mot_de_passe " +
                     "FROM patient WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient p = mapper(rs);
                    p.setMotDePasse(rs.getString("mot_de_passe"));
                    return p;
                }
            }

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur trouverParEmail : " + e.getMessage());
        }
        return null;
    }

    // ── UPDATE ───────────────────────────────────────────────────────────────

    public boolean modifier(Patient patient) {
        String sql = "UPDATE patient SET nom_pat = ?, datenais = ?, email = ? " +
                     "WHERE idpat = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getNomPat());
            ps.setDate(2, Date.valueOf(patient.getDatenais()));
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getIdpat());

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur modifier : " + e.getMessage());
            return false;
        }
    }

    // ── DELETE ───────────────────────────────────────────────────────────────

    public boolean supprimer(String idpat) {
        String sql = "DELETE FROM patient WHERE idpat = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idpat);
            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[PatientDAO] Erreur supprimer : " + e.getMessage());
            return false;
        }
    }

    // ── MAPPER ───────────────────────────────────────────────────────────────

    /**
     * Convertit une ligne du ResultSet en objet Patient.
     * Utilisé par toutes les méthodes de lecture.
     */
    private Patient mapper(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setIdpat(rs.getString("idpat"));
        p.setNomPat(rs.getString("nom_pat"));
        p.setDatenais(rs.getDate("datenais").toLocalDate());
        p.setEmail(rs.getString("email"));
        return p;
    }
}