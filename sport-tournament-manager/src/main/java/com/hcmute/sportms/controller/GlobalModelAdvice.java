package com.hcmute.sportms.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {

    // Tự động thêm biến "username" vào mọi giao diện Thymeleaf nếu đã đăng nhập
    @ModelAttribute("username")
    public String getUsername() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            return auth.getName();
        }
        return null;
    }

    // Tự động thêm biến "role" vào mọi giao diện Thymeleaf nếu đã đăng nhập
    @ModelAttribute("role")
    public String getRole() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            if (!auth.getAuthorities().isEmpty()) {
                // Trả về Role đầu tiên (VD: ROLE_BTC)
                return auth.getAuthorities().iterator().next().getAuthority();
            }
        }
        return null;
    }
}