package com.rdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.rdv.model.Medecin;
import com.rdv.util.DBConnection;

/**
 * DAO pour la table MEDECIN.
 * Toutes les requêtes SQL liées aux médecins sont ici.
 */
public class MedecinDAO {

    // ── CREATE ───────────────────────────────────────────────────────────────

    public boolean inserer(Medecin medecin) {
        String sql = "INSERT INTO medecin (nommed, specialite, taux_horaire, lieu, email, mot_de_passe) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, medecin.getNommed());
            ps.setString(2, medecin.getSpecialite());
            ps.setInt(3,    medecin.getTauxHoraire());
            ps.setString(4, medecin.getLieu());
            ps.setString(5, medecin.getEmail());
            ps.setString(6, medecin.getMotDePasse()); // déjà hashé en bcrypt

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur inserer : " + e.getMessage());
            return false;
        }
    }

    // ── READ ─────────────────────────────────────────────────────────────────

    public List<Medecin> listerTous() {
        List<Medecin> liste = new ArrayList<>();
        String sql = "SELECT idmed, nommed, specialite, taux_horaire, lieu, email " +
                     "FROM medecin ORDER BY nommed";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                liste.add(mapper(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur listerTous : " + e.getMessage());
        }
        return liste;
    }

    public Medecin trouverParId(String idmed) {
        String sql = "SELECT idmed, nommed, specialite, taux_horaire, lieu, email " +
                     "FROM medecin WHERE idmed = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapper(rs);
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur trouverParId : " + e.getMessage());
        }
        return null;
    }

    public Medecin trouverParEmail(String email) {
        String sql = "SELECT idmed, nommed, specialite, taux_horaire, lieu, email, mot_de_passe " +
                     "FROM medecin WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Medecin m = mapper(rs);
                    m.setMotDePasse(rs.getString("mot_de_passe"));
                    return m;
                }
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur trouverParEmail : " + e.getMessage());
        }
        return null;
    }

    // ── RECHERCHE PAR NOM (LIKE %...%) ───────────────────────────────────────

    public List<Medecin> rechercherParNom(String motCle) {
        List<Medecin> liste = new ArrayList<>();
        String sql = "SELECT idmed, nommed, specialite, taux_horaire, lieu, email " +
                     "FROM medecin WHERE nommed ILIKE ? ORDER BY nommed";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + motCle + "%"); // LIKE %motCle%
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    liste.add(mapper(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur rechercherParNom : " + e.getMessage());
        }
        return liste;
    }

    // ── LISTE PAR SPÉCIALITÉ ─────────────────────────────────────────────────

    public List<Medecin> listerParSpecialite(String specialite) {
        List<Medecin> liste = new ArrayList<>();
        String sql = "SELECT idmed, nommed, specialite, taux_horaire, lieu, email " +
                     "FROM medecin WHERE specialite = ? ORDER BY nommed";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, specialite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    liste.add(mapper(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur listerParSpecialite : " + e.getMessage());
        }
        return liste;
    }

    // ── TOP 5 MÉDECINS LES PLUS CONSULTÉS ────────────────────────────────────

    public List<Medecin> top5PlusConsultes() {
        List<Medecin> liste = new ArrayList<>();
        String sql = "SELECT m.idmed, m.nommed, m.specialite, m.taux_horaire, m.lieu, m.email, " +
                     "COUNT(r.idrdv) AS nb_consultations " +
                     "FROM medecin m " +
                     "JOIN rdv r ON m.idmed = r.idmed " +
                     "WHERE r.statut = 'CONFIRME' " +
                     "GROUP BY m.idmed, m.nommed, m.specialite, m.taux_horaire, m.lieu, m.email " +
                     "ORDER BY nb_consultations DESC " +
                     "LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                liste.add(mapper(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur top5PlusConsultes : " + e.getMessage());
        }
        return liste;
    }

    // ── LISTE DES SPÉCIALITÉS DISTINCTES ─────────────────────────────────────

    public List<String> listerSpecialites() {
        List<String> liste = new ArrayList<>();
        String sql = "SELECT DISTINCT specialite FROM medecin ORDER BY specialite";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                liste.add(rs.getString("specialite"));
            }

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur listerSpecialites : " + e.getMessage());
        }
        return liste;
    }

    // ── UPDATE ───────────────────────────────────────────────────────────────

    public boolean modifier(Medecin medecin) {
        String sql = "UPDATE medecin SET nommed = ?, specialite = ?, taux_horaire = ?, " +
                     "lieu = ?, email = ? WHERE idmed = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, medecin.getNommed());
            ps.setString(2, medecin.getSpecialite());
            ps.setInt(3,    medecin.getTauxHoraire());
            ps.setString(4, medecin.getLieu());
            ps.setString(5, medecin.getEmail());
            ps.setString(6, medecin.getIdmed());

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur modifier : " + e.getMessage());
            return false;
        }
    }

    // ── DELETE ───────────────────────────────────────────────────────────────

    public boolean supprimer(String idmed) {
        String sql = "DELETE FROM medecin WHERE idmed = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[MedecinDAO] Erreur supprimer : " + e.getMessage());
            return false;
        }
    }

    // ── MAPPER ───────────────────────────────────────────────────────────────

    private Medecin mapper(ResultSet rs) throws SQLException {
        Medecin m = new Medecin();
        m.setIdmed(rs.getString("idmed"));
        m.setNommed(rs.getString("nommed"));
        m.setSpecialite(rs.getString("specialite"));
        m.setTauxHoraire(rs.getInt("taux_horaire"));
        m.setLieu(rs.getString("lieu"));
        m.setEmail(rs.getString("email"));
        return m;
    }
}