package com.rdv.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Listener JEE qui s'exécute au démarrage et à l'arrêt de l'application.
 *
 * Au démarrage  → initialise le pool de connexions HikariCP
 * À l'arrêt     → ferme proprement le pool
 */
@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppListener] Démarrage de l'application RDV Medical...");
        DBConnection.init();
        System.out.println("[AppListener] Application prête.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppListener] Arrêt de l'application...");
        DBConnection.close();
    }
}