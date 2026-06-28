package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.response.MatchDto;
import com.hcmute.sportms.service.MatchService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class WebUIController {

    // THÊM MỚI 1: Khai báo biến matchService
    private final MatchService matchService;

    // THÊM MỚI 2: Constructor để Spring Boot Inject (Tiêm) MatchService vào Controller
    public WebUIController(MatchService matchService) {
        this.matchService = matchService;
    }

    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    @GetMapping("/home")
    public String homePage(Model model) {
        // Bây giờ Java đã nhận diện được matchService
        List<MatchDto> matches = matchService.getAllMatches();
        model.addAttribute("matches", matches); 
        return "home";
    }
    
    @GetMapping("/match")
    public String matchPage(Model model) {
        List<MatchDto> matches = matchService.getAllMatches();
        model.addAttribute("matches", matches);
        return "match/match-list"; 
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