package com.hcmute.sportms.service;

import com.hcmute.sportms.dto.response.LoginResponse;
import com.hcmute.sportms.exception.DatabaseSecurityException;
import com.hcmute.sportms.repository.AuthRepository;
import com.hcmute.sportms.utils.JwtUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthRepository authRepository;
    private final JwtUtils jwtUtils; 

    public LoginResponse authenticate(String username, String password) {
        Map<String, Object> result = authRepository.callLoginProcedure(username, password);

        // SỬA Ở ĐÂY: Đổi P_STATUS, P_ROLE, P_TEAM_ID thành chữ in thường
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
}