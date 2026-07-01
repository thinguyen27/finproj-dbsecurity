package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.exception.DatabaseSecurityException;
import com.hcmute.sportms.repository.AuthRepository;
import com.hcmute.sportms.utils.JwtUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;
import java.util.UUID; // BỔ SUNG IMPORT NÀY ĐỂ TRÁNH LỖI

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final AuthRepository authRepository;
    private final JwtUtils jwtUtils; 
    private final EmailService emailService; 

    public LoginResponse authenticate(String username, String password) {
        Map<String, Object> result = authRepository.callLoginProcedure(username, password);
        
        System.out.println("========== RESULT ==========");
        result.forEach((k, v) -> System.out.println(k + " = " + v));
        System.out.println("HASH FROM JDBC = " + authRepository.hashTest(password));
        System.out.println("============================");
        
        log.info("Nội dung Map nhận được từ Oracle: {}", result.keySet());
        
        String status = (String) result.get("p_status"); 
        String role = (String) result.get("p_role");
        String teamId = (String) result.get("p_team_id");

        log.info("Kết quả từ DB: Status={}, Role={}, TeamId={}", status, role, teamId);
        
        return switch (status) {
            case "SUCCESS" -> {
                String token = jwtUtils.generateToken(username, role, teamId);
                yield new LoginResponse(token, role, teamId);
            }
            case "ACCOUNT_LOCKED" -> throw new DatabaseSecurityException("Tài khoản đang bị khóa.");
            case "DELETED" -> throw new DatabaseSecurityException("Tài khoản đã bị xóa khỏi hệ thống.");
            case "WRONG_PASSWORD" -> throw new DatabaseSecurityException("Sai tài khoản hoặc mật khẩu.");
            default -> throw new DatabaseSecurityException("Lỗi hệ thống: " + status);
        };
    }
    
    @Transactional
    public void resetPasswordAndSendEmail(String email) {
        // 1. Tạo mật khẩu ngẫu nhiên 8 ký tự
        String newPassword = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        
        // 2. Cập nhật xuống Oracle Database
        boolean isUpdated = authRepository.resetPasswordByEmail(email, newPassword);
        
        if (!isUpdated) {
            throw new RuntimeException("Email này chưa được đăng ký trong hệ thống!");
        }
        
        // 3. Gửi mail chứa mật khẩu mới
        emailService.sendNewPasswordEmail(email, newPassword);
    }
    
    @Transactional
    public void register(String username, String password, String fullName, String email, String phone) {
        try {
            authRepository.registerUser(username, password, fullName, email, phone);
        } catch (Exception e) {
            // Bắt lỗi khi Username hoặc Email đã bị trùng trong CSDL
            throw new RuntimeException("Tên đăng nhập hoặc Email đã tồn tại trong hệ thống!");
        }
    }

    @Transactional
    public void changePassword(String username, String oldPassword, String newPassword) {
        // 1. Kiểm tra mật khẩu cũ (Nếu sai, hàm authenticate sẽ tự động ném ra lỗi)
        this.authenticate(username, oldPassword); 
        
        // 2. Nếu mật khẩu cũ đúng, tiến hành cập nhật mật khẩu mới
        authRepository.updatePassword(username, newPassword);
    }
}