package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.exception.DatabaseSecurityException;
import com.hcmute.sportms.repository.AuthRepository;
import com.hcmute.sportms.utils.JwtUtils; // Thêm import
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthRepository authRepository;
    private final JwtUtils jwtUtils; // Inject JwtUtils

    public LoginResponse authenticate(String username, String password) {
        Map<String, Object> result = authRepository.callLoginProcedure(username, password);

        String status = (String) result.get("P_STATUS");
        String role = (String) result.get("P_ROLE");
        String teamId = (String) result.get("P_TEAM_ID");

        return switch (status) {
            case "SUCCESS" -> {
                // TẠO JWT TOKEN THỰC TẾ
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