package com.rdv.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filtre de sécurité — vérifie qu'un utilisateur est connecté.
 * S'applique à toutes les URLs sauf login et register.
 *
 * Si non connecté → redirige vers la page de connexion.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // Pages accessibles sans être connecté
    private static final String[] PAGES_PUBLIQUES = {
        "/views/shared/login.jsp",
        "/views/shared/register.jsp",
        "/auth",
        "/index.jsp",
        "/css/",
        "/js/"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Retirer le contextPath de l'URI pour comparer
        String chemin = uri.substring(contextPath.length());

        // Vérifier si c'est une page publique
        for (String pagePublique : PAGES_PUBLIQUES) {
            if (chemin.startsWith(pagePublique)) {
                chain.doFilter(request, response); // laisser passer
                return;
            }
        }

        // Vérifier si l'utilisateur est connecté
        HttpSession session = req.getSession(false);
        boolean connecte = (session != null && session.getAttribute("utilisateur") != null);

        if (connecte) {
            chain.doFilter(request, response); // laisser passer
        } else {
            // Rediriger vers la page de connexion
            resp.sendRedirect(contextPath + "/views/shared/login.jsp");
        }
    }
}