package com.hcmute.sportms.aspect;

import com.hcmute.sportms.utils.JwtUtils;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Aspect
@Component
@RequiredArgsConstructor
@Slf4j
public class OracleVpdAspect {
    private final JdbcTemplate jdbcTemplate;
    private final HttpServletRequest request; // Lấy thông tin request từ Frontend
    private final JwtUtils jwtUtils;          // Công cụ giải mã Token

    @Around("@annotation(org.springframework.transaction.annotation.Transactional)")
    public Object manageVpdContext(ProceedingJoinPoint joinPoint) throws Throwable {
        String currentUsername = null;
        String currentRole = null;
        String currentTeamId = null;
        boolean isContextSet = false;

        // 1. TRÍCH XUẤT VÀ GIẢI MÃ TOKEN TỪ HEADER
        String headerAuth = request.getHeader("Authorization");
        if (headerAuth != null && headerAuth.startsWith("Bearer ")) {
            String token = headerAuth.substring(7);
            try {
                Claims claims = jwtUtils.parseToken(token);
                currentUsername = claims.getSubject();
                currentRole = claims.get("role", String.class);
                currentTeamId = claims.get("teamId", String.class);
            } catch (Exception e) {
                log.warn("Invalid JWT Token: {}", e.getMessage());
                // Token hết hạn hoặc sai chữ ký, bỏ qua không set Context
            }
        }

        try {
            // 2. NẠP VPD CONTEXT XUỐNG DATABASE NẾU CÓ TOKEN HỢP LỆ
            if (currentUsername != null && currentRole != null) {
                String sqlInit = "CALL SEC_ADMIN.PKG_SPORT_CONTEXT.INITIALIZE_SESSION(?, ?, ?)";
                jdbcTemplate.update(sqlInit, currentUsername, currentRole, currentTeamId);
                isContextSet = true;
                log.debug("VPD Context INITIALIZED for User: {} - Role: {} - Team: {}", currentUsername, currentRole, currentTeamId);
            } else {
                log.debug("No valid auth context. Executing as system pool user.");
            }

            // 3. THỰC THI LOGIC NGHIỆP VỤ (Hàm chạy SQL vào các bảng)
            return joinPoint.proceed();

        } finally {
            // 4. DỌN DẸP VPD CONTEXT (BẮT BUỘC) ĐỂ TRẢ CONNECTION VỀ POOL AN TOÀN
            if (isContextSet) {
                jdbcTemplate.update("CALL SEC_ADMIN.PKG_SPORT_CONTEXT.CLEAR_SESSION()");
                log.debug("VPD Context CLEARED.");
            }
        }
    }
}