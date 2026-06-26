package com.hcmute.sportms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebUIController {

    // Khi vào trang chủ -> Tự động điều hướng đến trang Đăng nhập
    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    // Load giao diện trang Đăng nhập
    @GetMapping("/login")
    public String loginPage() {
        // Tương ứng với file src/main/resources/templates/auth/login.html
        return "auth/login"; 
    }

    // Load giao diện Dashboard Kiểm toán
    @GetMapping("/audit-dashboard")
    public String auditDashboardPage() {
        // Tương ứng với file src/main/resources/templates/audit/audit-dashboard.html
        return "audit/audit-dashboard"; 
    }
    
    // Tương tự, bạn có thể tạo thêm các @GetMapping khác cho match, team, user...
}