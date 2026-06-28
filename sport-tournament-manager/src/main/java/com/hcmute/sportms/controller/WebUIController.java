package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.response.MatchDto;
import com.hcmute.sportms.service.MatchService;
import com.hcmute.sportms.service.AuthService; // Import AuthService
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam; // Import request param
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // Import redirect attributes

import java.util.List;

@Controller
public class WebUIController {

    private final MatchService matchService;
    
    // THÊM MỚI: Khai báo biến AuthService
    private final AuthService authService;

    // SỬA CONSTRUCTOR: Tiêm (Inject) CẢ 2 service vào Controller
    public WebUIController(MatchService matchService, AuthService authService) {
        this.matchService = matchService;
        this.authService = authService;
    }

    @GetMapping("/")
    public String root() {
        return "redirect:/home";
    }

    @GetMapping("/home")
    public String homePage(Model model) {
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
    
    @PostMapping("/register")
    public String processRegister(@RequestParam("username") String username,
                                  @RequestParam("password") String password,
                                  @RequestParam("fullName") String fullName,
                                  @RequestParam("email") String email,
                                  @RequestParam(value = "phone", required = false) String phone,
                                  RedirectAttributes redirectAttributes) {
        try {
            authService.register(username, password, fullName, email, phone);
            redirectAttributes.addFlashAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        // Dù thành công hay thất bại, đều đưa về lại trang login để hiển thị thông báo
        return "redirect:/login"; 
    }

    @GetMapping("/audit-dashboard")
    public String auditDashboardPage() {
        return "audit/audit-dashboard"; 
    }
    
    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, 
                                        RedirectAttributes redirectAttributes) {
        try {
            authService.resetPasswordAndSendEmail(email);
            redirectAttributes.addFlashAttribute("success", "Mật khẩu mới đã được gửi vào email của bạn. Vui lòng kiểm tra hộp thư!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        
        return "redirect:/forgot-password"; 
    }
    
    @GetMapping("/reset-password")
    public String resetPasswordPage() {
        return "auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("username") String username,
                                       @RequestParam("tempPassword") String tempPassword,
                                       @RequestParam("newPassword") String newPassword,
                                       RedirectAttributes redirectAttributes) {
        try {
            authService.changePassword(username, tempPassword, newPassword);
            
            redirectAttributes.addFlashAttribute("success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            return "redirect:/login";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Sai Tên đăng nhập hoặc Mật khẩu tạm không đúng!");
            return "redirect:/reset-password";
        }
    }
}