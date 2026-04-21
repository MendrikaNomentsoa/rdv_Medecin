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
    private static boolean initialized = false;

    // Constructeur privé : on ne peut pas instancier cette classe
    private DBConnection() {}

    /**
     * Initialise le pool de connexions au démarrage de l'application.
     * Lit la configuration depuis db.properties.
     */
    public static void init() {
        if (initialized) {
            System.out.println("[DBConnection] Pool déjà initialisé.");
            return;
        }

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

            // Paramètres supplémentaires pour PostgreSQL
            config.addDataSourceProperty("prepareThreshold", "0");
            config.addDataSourceProperty("preparedStatementCacheQueries", "0");
            config.addDataSourceProperty("preparedStatementCacheSizeMiB", "0");

            dataSource = new HikariDataSource(config);
            initialized = true;
            System.out.println("[DBConnection] Pool PostgreSQL initialisé avec succès.");
            System.out.println("[DBConnection] URL: " + props.getProperty("db.url"));

        } catch (IOException e) {
            throw new RuntimeException("Erreur lecture db.properties : " + e.getMessage(), e);
        }
    }

    /**
     * Retourne une connexion depuis le pool.
     * À utiliser dans un try-with-resources pour la refermer automatiquement.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null || !initialized) {
            System.err.println("[DBConnection] Pool non initialisé, tentative d'initialisation...");
            init();
        }

        if (dataSource == null) {
            throw new SQLException("Le pool de connexions n'a pas pu être initialisé.");
        }

        try {
            Connection conn = dataSource.getConnection();
            System.out.println("[DBConnection] Connexion PostgreSQL obtenue avec succès.");
            return conn;
        } catch (SQLException e) {
            System.err.println("[DBConnection] Erreur lors de l'obtention de la connexion : " + e.getMessage());
            throw e;
        }
    }

    /**
     * Ferme le pool proprement à l'arrêt de l'application.
     */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            initialized = false;
            System.out.println("[DBConnection] Pool PostgreSQL fermé.");
        }
    }

    /**
     * Vérifie si le pool est initialisé et fonctionnel
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("[DBConnection] Test de connexion échoué : " + e.getMessage());
            return false;
        }
    }
}