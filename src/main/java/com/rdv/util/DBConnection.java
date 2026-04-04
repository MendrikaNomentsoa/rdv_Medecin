package com.rdv.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

/**
 * Gestionnaire de connexion à PostgreSQL via HikariCP (pool de connexions).
 * Utilise le pattern Singleton : une seule instance du pool pour toute l'appli.
 */
public class DBConnection {

    private static HikariDataSource dataSource;

    // Constructeur privé : on ne peut pas instancier cette classe
    private DBConnection() {}

    /**
     * Initialise le pool de connexions au démarrage de l'application.
     * Lit la configuration depuis db.properties.
     */
    public static void init() {
        try {
            // Charger le fichier db.properties depuis le classpath
            Properties props = new Properties();
            InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("db.properties");

            if (input == null) {
                throw new RuntimeException("Fichier db.properties introuvable !");
            }
            props.load(input);

            // Configurer HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));

            // Paramètres du pool
            config.setMaximumPoolSize(
                Integer.parseInt(props.getProperty("db.pool.maximumPoolSize", "10")));
            config.setMinimumIdle(
                Integer.parseInt(props.getProperty("db.pool.minimumIdle", "2")));
            config.setConnectionTimeout(
                Long.parseLong(props.getProperty("db.pool.connectionTimeout", "30000")));
            config.setIdleTimeout(
                Long.parseLong(props.getProperty("db.pool.idleTimeout", "600000")));
            config.setMaxLifetime(
                Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000")));

            // Nom du pool (utile pour les logs)
            config.setPoolName("RdvMedicalPool");

            // Driver PostgreSQL
            config.setDriverClassName("org.postgresql.Driver");

            dataSource = new HikariDataSource(config);
            System.out.println("[DBConnection] Pool initialisé avec succès.");

        } catch (IOException e) {
            throw new RuntimeException("Erreur lecture db.properties : " + e.getMessage(), e);
        }
    }

    /**
     * Retourne une connexion depuis le pool.
     * À utiliser dans un try-with-resources pour la refermer automatiquement.
     *
     * Exemple d'utilisation :
     *   try (Connection conn = DBConnection.getConnection()) {
     *       // utiliser conn
     *   }
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("Le pool de connexions n'est pas initialisé. Appelez DBConnection.init() d'abord.");
        }
        return dataSource.getConnection();
    }

    /**
     * Ferme le pool proprement à l'arrêt de l'application.
     */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("[DBConnection] Pool fermé.");
        }
    }
}