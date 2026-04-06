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

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final String[] PAGES_PUBLIQUES = {
        "/views/shared/login.jsp",
        "/views/shared/register.jsp",
        "/auth",
        "/index.jsp",
        "/css/",
        "/js/"
    };

    private static final String[] PAGES_MEDECIN = {
        "/patient",
        "/medecin",
        "/views/patient/list.jsp",
        "/views/medecin/list.jsp",
        "/views/medecin/form.jsp",
        "/views/medecin/top5.jsp"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String chemin = req.getRequestURI()
                           .substring(req.getContextPath().length());

        // 1. Pages publiques → laisser passer
        for (String page : PAGES_PUBLIQUES) {
            if (chemin.startsWith(page)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // 2. Non connecté → login
        HttpSession session = req.getSession(false);
        boolean connecte = (session != null
                         && session.getAttribute("utilisateur") != null);

        if (!connecte) {
            resp.sendRedirect(req.getContextPath()
                            + "/views/shared/login.jsp");
            return;
        }

        // 3. Page médecin → vérifier le rôle
String role = (String) session.getAttribute("role");
String idUtilisateur = (String) session.getAttribute("idUtilisateur");

for (String page : PAGES_MEDECIN) {
    if (chemin.startsWith(page)) {
        if (!"medecin".equals(role)) {

            // Exception : un patient peut modifier SON propre profil
            if (chemin.startsWith("/patient") 
                && "edit".equals(req.getParameter("action"))
                && idUtilisateur.equals(req.getParameter("id"))) {
                chain.doFilter(request, response);
                return;
            }

            // Sinon refusé
            resp.sendRedirect(req.getContextPath()
                            + "/views/patient/dashboard.jsp");
            return;
        }
    }

        }

        // 4. Ok → laisser passer
        chain.doFilter(request, response);
    }
}