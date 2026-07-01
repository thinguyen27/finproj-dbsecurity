package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import io.jsonwebtoken.Claims;

@ControllerAdvice
public class GlobalControllerAdvice {

    @ModelAttribute
    public void addUser(Model model) {

        Authentication auth =
                SecurityContextHolder.getContext().getAuthentication();
        System.out.println("AUTH = " + auth);
        if (auth != null &&
            auth.isAuthenticated() &&
            !"anonymousUser".equals(auth.getName())) {

            model.addAttribute("currentUser", auth.getName());

            String role = auth.getAuthorities()
                              .stream()
                              .findFirst()
                              .map(a -> a.getAuthority())
                              .orElse("");

            model.addAttribute("currentRole", role);
        }
    }
    @ModelAttribute("currentUser")
    public String getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) ? auth.getName() : null;
    }

    @ModelAttribute("currentRole")
    public String getCurrentRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            return auth.getAuthorities().stream().findFirst().map(GrantedAuthority::getAuthority).orElse(null);
        }
        return null;
    }

    // CUNG CẤP BIẾN currentTeamId CHO TẤT CẢ FILE HTML
    @ModelAttribute("currentTeamId")
    public String getCurrentTeamId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getCredentials() instanceof Claims claims) {
            return claims.get("teamId", String.class);
        }
        return null;
    }
}
