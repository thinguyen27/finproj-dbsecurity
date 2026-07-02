package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {

    // ĐÃ SỬA: Đổi từ "username" thành "currentUser"
    @ModelAttribute("currentUser")
    public String getUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return auth.getName();
        }
        return null;
    }

    // ĐÃ SỬA: Đổi từ "role" thành "currentRole"
    @ModelAttribute("currentRole")
    public String getRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            if (!auth.getAuthorities().isEmpty()) {
                // Ép chữ in hoa để đảm bảo đồng bộ khi so sánh trong Thymeleaf
                return auth.getAuthorities().iterator().next().getAuthority().toUpperCase();
            }
        }
        return null;
    }
}