package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.LoginResponse;

import com.hcmute.sportms.exception.DatabaseSecurityException;
import com.hcmute.sportms.repository.AuthRepository;
import com.hcmute.sportms.utils.JwtUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthRepository authRepository;
    private final JwtUtils jwtUtils; 

    public LoginResponse authenticate(String username, String password) {
        Map<String, Object> result = authRepository.callLoginProcedure(username, password);
        System.out.println("========== RESULT ==========");
        result.forEach((k, v) -> System.out.println(k + " = " + v));
        System.out.println("HASH FROM JDBC = " + authRepository.hashTest(password));
        System.out.println("============================");
        log.info("Nội dung Map nhận được từ Oracle: {}", result.keySet());
        // SỬA Ở ĐÂY: Đổi P_STATUS, P_ROLE, P_TEAM_ID thành chữ in thường
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
}