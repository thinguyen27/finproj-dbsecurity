package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {

    @ModelAttribute("username")
    public String getUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return auth.getName();
        }
        return null;
    }

    @ModelAttribute("role")
    public String getRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            if (!auth.getAuthorities().isEmpty()) {
                // THÊM .toUpperCase() Ở ĐÂY ĐỂ ÉP CHỮ IN HOA:
                return auth.getAuthorities().iterator().next().getAuthority().toUpperCase();
            }
        }
        return null;
    }
}