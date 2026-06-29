package com.hcmute.sportms.controller;

import com.hcmute.sportms.dto.request.LoginRequest;
import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.service.AuthService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;

    // ==========================================
    // 1. API ĐĂNG NHẬP & ĐĂNG XUẤT
    // ==========================================
    @PostMapping("/api/auth/login")
    @ResponseBody 
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.authenticate(request.getUsername(), request.getPassword()));
    }
    
    @GetMapping("/api/auth/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {

        SecurityContextHolder.clearContext();

        if (request.getSession(false) != null) {
            request.getSession(false).invalidate();
        }

        // SỬA CHÍNH XÁC CHỖ NÀY: Phải là jwt_token
        Cookie cookie = new Cookie("jwt_token", "");
        cookie.setPath("/");
        cookie.setMaxAge(0); // Bắt buộc Cookie hết hạn ngay lập tức
        response.addCookie(cookie);

        return "redirect:/login";
    }
    
    // ==========================================
    // 2. ĐĂNG KÝ TÀI KHOẢN
    // ==========================================
    @GetMapping("/register") 
    public String registerPage() {
        return "redirect:/login"; 
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
        return "redirect:/login"; 
    }

    // ==========================================
    // 3. QUÊN MẬT KHẨU (Gửi mail và dùng luôn)
    // ==========================================
    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, 
                                        RedirectAttributes redirectAttributes) {
        try {
            // Hàm này đã thay đổi mật khẩu trong Database và gửi mail
            authService.resetPasswordAndSendEmail(email);
            
            // Xong việc, đá thẳng về trang Đăng nhập và báo người dùng check mail
            redirectAttributes.addFlashAttribute("success", "Mật khẩu mới đã được gửi. Vui lòng kiểm tra hộp thư và đăng nhập lại!");
            return "redirect:/login"; 
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/forgot-password"; 
        }
    }

    // ==========================================
    // 4. ĐỔI MẬT KHẨU (Từ Dropdown Menu)
    // ==========================================
    @GetMapping("/change-password")
    public String changePasswordPage() {
        return "auth/change-password"; 
    }

    @PostMapping("/change-password")
    public String processChangePassword(@RequestParam("oldPassword") String oldPassword,
                                        @RequestParam("newPassword") String newPassword,
                                        RedirectAttributes redirectAttributes) {
        try {
            // Tự động lấy Username từ phiên đăng nhập hiện tại
            String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
            
            authService.changePassword(currentUsername, oldPassword, newPassword);
            redirectAttributes.addFlashAttribute("success", "Cập nhật mật khẩu mới thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu hiện tại không chính xác!");
        }
        return "redirect:/change-password";
    }
}