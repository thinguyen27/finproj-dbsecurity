package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

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
}
