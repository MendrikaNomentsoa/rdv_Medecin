/*package com.rdv.tests;

import java.util.List;

import com.rdv.dao.MedecinDAO;
import com.rdv.model.Medecin;
import com.rdv.util.DBConnection;

public class TestDAO {
    public static void main(String[] args) {

        // Initialiser le pool de connexions
        DBConnection.init();

        MedecinDAO dao = new MedecinDAO();

        // Tester listerTous()
        List<Medecin> liste = dao.listerTous();
        System.out.println("Nombre de médecins : " + liste.size());
        for (Medecin m : liste) {
            System.out.println(m.getNommed() + " - " + m.getSpecialite());
        }

        // Tester rechercherParNom()
        List<Medecin> recherche = dao.rechercherParNom("rakoto");
        System.out.println("Résultat recherche : " + recherche.size());

        // Fermer le pool
        DBConnection.close();
    }
}*/