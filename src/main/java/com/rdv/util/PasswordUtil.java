package com.rdv.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utilitaire pour le hashage des mots de passe avec BCrypt.
 * On ne stocke JAMAIS un mot de passe en clair en base de données.
 */
public class PasswordUtil {

    // Coût du hashage (plus c'est élevé, plus c'est sécurisé mais lent)
    private static final int COST = 12;

    // Hasher un mot de passe (à l'inscription)
    public static String hasher(String motDePasseClair) {
        return BCrypt.hashpw(motDePasseClair, BCrypt.gensalt(COST));
    }

    // Vérifier un mot de passe à la connexion
    public static boolean verifier(String motDePasseClair, String hash) {
        return BCrypt.checkpw(motDePasseClair, hash);
    }
}