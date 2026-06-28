package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.exception.DatabaseSecurityException;
import com.hcmute.sportms.repository.AuthRepository;
import com.hcmute.sportms.utils.JwtUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // Import Transactional

import java.util.Map;
import java.util.UUID; // Import sinh chuỗi ngẫu nhiên

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthRepository authRepository;
    private final JwtUtils jwtUtils; 
    
    // THÊM MỚI: Khai báo EmailService để Spring Boot tự động nhúng (Inject) vào
    private final EmailService emailService; 

    public LoginResponse authenticate(String username, String password) {
        Map<String, Object> result = authRepository.callLoginProcedure(username, password);

        String status = (String) result.get("p_status");
        String role = (String) result.get("p_role");
        String teamId = (String) result.get("p_team_id");

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
        // 1. Tạo mật khẩu ngẫu nhiên 8 ký tự (Đã sửa lại cú pháp chuẩn của Java)
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