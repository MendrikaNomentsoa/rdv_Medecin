package com.rdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.rdv.model.Medecin;
import com.rdv.model.Patient;
import com.rdv.model.Rdv;
import com.rdv.util.DBConnection;

/**
 * DAO pour la table RDV.
 * Toutes les requêtes SQL liées aux rendez-vous sont ici.
 */
public class RdvDAO {

    // ── CREATE ───────────────────────────────────────────────────────────────

    public boolean inserer(Rdv rdv) {
        String sql = "INSERT INTO rdv (idmed, idpat, date_rdv, statut) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rdv.getIdmed());
            ps.setString(2, rdv.getIdpat());
            ps.setTimestamp(3, Timestamp.valueOf(rdv.getDateRdv()));
            ps.setString(4, Rdv.STATUT_CONFIRME);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            // Si le créneau est déjà pris → violation de la contrainte UNIQUE
            if (e.getSQLState().equals("23505")) {
                System.err.println("[RdvDAO] Créneau déjà réservé !");
            } else {
                System.err.println("[RdvDAO] Erreur inserer : " + e.getMessage());
            }
            return false;
        }
    }

    // ── READ ─────────────────────────────────────────────────────────────────

    public List<Rdv> listerTous() {
        List<Rdv> liste = new ArrayList<>();
        String sql = "SELECT r.idrdv, r.idmed, r.idpat, r.date_rdv, r.statut, " +
                     "m.nommed, m.specialite, m.lieu, " +
                     "p.nom_pat, p.email " +
                     "FROM rdv r " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "ORDER BY r.date_rdv DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                liste.add(mapperAvecJointure(rs));
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur listerTous : " + e.getMessage());
        }
        return liste;
    }

    public Rdv trouverParId(String idrdv) {
        String sql = "SELECT r.idrdv, r.idmed, r.idpat, r.date_rdv, r.statut, " +
                     "m.nommed, m.specialite, m.lieu, " +
                     "p.nom_pat, p.email " +
                     "FROM rdv r " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "WHERE r.idrdv = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idrdv);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapperAvecJointure(rs);
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur trouverParId : " + e.getMessage());
        }
        return null;
    }

    // ── RDV D'UN PATIENT ─────────────────────────────────────────────────────

    public List<Rdv> listerParPatient(String idpat) {
        List<Rdv> liste = new ArrayList<>();
        String sql = "SELECT r.idrdv, r.idmed, r.idpat, r.date_rdv, r.statut, " +
                     "m.nommed, m.specialite, m.lieu, " +
                     "p.nom_pat, p.email " +
                     "FROM rdv r " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "WHERE r.idpat = ? " +
                     "ORDER BY r.date_rdv DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idpat);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) liste.add(mapperAvecJointure(rs));
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur listerParPatient : " + e.getMessage());
        }
        return liste;
    }

    // ── RDV D'UN MÉDECIN ─────────────────────────────────────────────────────

    public List<Rdv> listerParMedecin(String idmed) {
        List<Rdv> liste = new ArrayList<>();
        String sql = "SELECT r.idrdv, r.idmed, r.idpat, r.date_rdv, r.statut, " +
                     "m.nommed, m.specialite, m.lieu, " +
                     "p.nom_pat, p.email " +
                     "FROM rdv r " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "WHERE r.idmed = ? " +
                     "ORDER BY r.date_rdv DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) liste.add(mapperAvecJointure(rs));
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur listerParMedecin : " + e.getMessage());
        }
        return liste;
    }

    // ── CRÉNEAUX DÉJÀ PRIS D'UN MÉDECIN ──────────────────────────────────────

    public List<LocalDateTime> listerCreneauxPris(String idmed) {
        List<LocalDateTime> creneaux = new ArrayList<>();
        String sql = "SELECT date_rdv FROM rdv " +
                     "WHERE idmed = ? AND statut = 'CONFIRME' AND date_rdv >= NOW() " +
                     "ORDER BY date_rdv";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    creneaux.add(rs.getTimestamp("date_rdv").toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur listerCreneauxPris : " + e.getMessage());
        }
        return creneaux;
    }

    // ── VÉRIFIER SI UN CRÉNEAU EST LIBRE ─────────────────────────────────────

    public boolean estCreneauLibre(String idmed, LocalDateTime dateRdv) {
        String sql = "SELECT COUNT(*) FROM rdv " +
                     "WHERE idmed = ? AND date_rdv = ? AND statut = 'CONFIRME'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            ps.setTimestamp(2, Timestamp.valueOf(dateRdv));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0; // 0 = libre, >0 = déjà pris
                }
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur estCreneauLibre : " + e.getMessage());
        }
        return false;
    }

    // ── ANNULER UN RDV ────────────────────────────────────────────────────────

    public boolean annuler(String idrdv) {
        String sql = "UPDATE rdv SET statut = 'ANNULE' WHERE idrdv = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idrdv);
            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur annuler : " + e.getMessage());
            return false;
        }
    }

    // ── DELETE ───────────────────────────────────────────────────────────────

    public boolean supprimer(String idrdv) {
        String sql = "DELETE FROM rdv WHERE idrdv = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idrdv);
            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur supprimer : " + e.getMessage());
            return false;
        }
    }

    // ── MAPPER ───────────────────────────────────────────────────────────────

    /**
     * Convertit une ligne ResultSet en objet Rdv avec Medecin et Patient inclus.
     * Utilisé quand on fait une jointure SQL (JOIN medecin JOIN patient).
     */
    private Rdv mapperAvecJointure(ResultSet rs) throws SQLException {
        Rdv rdv = new Rdv();
        rdv.setIdrdv(rs.getString("idrdv"));
        rdv.setIdmed(rs.getString("idmed"));
        rdv.setIdpat(rs.getString("idpat"));
        rdv.setDateRdv(rs.getTimestamp("date_rdv").toLocalDateTime());
        rdv.setStatut(rs.getString("statut"));

        // Médecin inclus dans la jointure
        Medecin m = new Medecin();
        m.setIdmed(rs.getString("idmed"));
        m.setNommed(rs.getString("nommed"));
        m.setSpecialite(rs.getString("specialite"));
        m.setLieu(rs.getString("lieu"));
        rdv.setMedecin(m);

        // Patient inclus dans la jointure
        Patient p = new Patient();
        p.setIdpat(rs.getString("idpat"));
        p.setNomPat(rs.getString("nom_pat"));
        p.setEmail(rs.getString("email"));
        rdv.setPatient(p);

        return rdv;
    }

    // ── MODIFIER date d'un RDV ────────────────────────────────────────────────
    public boolean modifier(String idrdv, LocalDateTime nouvelleDate) {
        String sql = "UPDATE rdv SET date_rdv = ?, statut = 'CONFIRME' WHERE idrdv = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(nouvelleDate));
            ps.setString(2, idrdv);
            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) {
                System.err.println("[RdvDAO] Créneau déjà réservé !");
            } else {
                System.err.println("[RdvDAO] Erreur modifier : " + e.getMessage());
            }
            return false;
        }
    }

    // ── HEURES PRISES PAR DATE (avec exclusion du RDV en cours de modif) ─────
    public List<String> listerHeuresPrisesParDate(String idmed, String date, String idRdvExclu) {
        List<String> heures = new ArrayList<>();
        String sql = "SELECT TO_CHAR(date_rdv, 'HH24:MI') as heure " +
                     "FROM rdv " +
                     "WHERE idmed = ? " +
                     "AND DATE(date_rdv) = ? " +
                     "AND statut = 'CONFIRME' " +
                     (idRdvExclu != null ? "AND idrdv != ?" : "");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idmed);
            ps.setDate(2, java.sql.Date.valueOf(date));
            if (idRdvExclu != null) ps.setString(3, idRdvExclu);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    heures.add(rs.getString("heure"));
                }
            }

        } catch (SQLException e) {
            System.err.println("[RdvDAO] Erreur listerHeuresPrisesParDate : " + e.getMessage());
        }
        return heures;
    }

}

    