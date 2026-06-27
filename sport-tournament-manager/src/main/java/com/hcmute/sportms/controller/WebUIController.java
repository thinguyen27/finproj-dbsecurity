package com.hcmute.sportms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.ArrayList;

@Controller
public class WebUIController {

    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    // THÊM MỚI: Xử lý hiển thị trang chủ
    @GetMapping("/home")
    public String homePage(Model model) {
        // Tương lai: Gọi MatchService để lấy danh sách trận đấu
        // Tạm thời truyền danh sách rỗng để Thymeleaf không báo lỗi null
        model.addAttribute("matches", new ArrayList<>()); 
        return "home";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "auth/login"; 
    }

    @GetMapping("/audit-dashboard")
    public String auditDashboardPage() {
        return "audit/audit-dashboard"; 
    }
}