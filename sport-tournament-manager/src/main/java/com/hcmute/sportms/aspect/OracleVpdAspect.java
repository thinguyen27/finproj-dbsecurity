package com.hcmute.sportms.aspect;

import io.jsonwebtoken.Claims;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Aspect
@Component
@RequiredArgsConstructor
@Slf4j
public class OracleVpdAspect {
    private final JdbcTemplate jdbcTemplate;
    
    // BỔ SUNG: Tiêm EntityManager để kiểm soát cơ chế Write-Behind của Hibernate
    private final EntityManager entityManager;

    @Around("@annotation(org.springframework.transaction.annotation.Transactional)")
    public Object manageVpdContext(ProceedingJoinPoint joinPoint) throws Throwable {
        boolean isContextSet = false;

        // 1. Lấy thông tin chứng nhận an ninh từ Spring Security
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        try {
            // 2. Nạp VPD CONTEXT nếu user đã đăng nhập hợp lệ
            if (auth != null && auth.isAuthenticated() && auth.getCredentials() instanceof Claims claims) {
                String currentUsername = auth.getName();
                String currentRole = claims.get("role", String.class);
                String currentTeamId = claims.get("teamId", String.class);

                String sqlInit = "CALL SEC_ADMIN.PKG_SPORT_CONTEXT.INITIALIZE_SESSION(?, ?, ?)";
                jdbcTemplate.update(sqlInit, currentUsername, currentRole, currentTeamId);
                isContextSet = true;
                log.debug("VPD Context INITIALIZED for User: {} - Role: {} - Team: {}", currentUsername, currentRole, currentTeamId);
            }

            // 3. THỰC THI LOGIC NGHIỆP VỤ (Hàm gọi xuống DB)
            Object result = joinPoint.proceed();

            // 3.5. BỔ SUNG: Ép Hibernate xả lệnh (Flush) toàn bộ các câu UPDATE/INSERT/DELETE xuống DB
            // Phải làm việc này khi Context của Database vẫn còn đang tồn tại
            if (isContextSet) {
                entityManager.flush();
            }

            return result;

        } finally {
            // 4. XÓA VPD CONTEXT (Luôn luôn chạy để tránh rò rỉ dữ liệu)
            if (isContextSet) {
                jdbcTemplate.update("CALL SEC_ADMIN.PKG_SPORT_CONTEXT.CLEAR_SESSION()");
                log.debug("VPD Context CLEARED.");
            }
        }
    }
}