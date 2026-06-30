package com.hcmute.sportms.aspect;

import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Aspect
@Component
@RequiredArgsConstructor
@Slf4j
public class OracleVpdAspect {
    private final JdbcTemplate jdbcTemplate;

    @Around("@annotation(org.springframework.transaction.annotation.Transactional)")
    public Object manageVpdContext(ProceedingJoinPoint joinPoint) throws Throwable {
        boolean isContextSet = false;
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        try {
            // 1. Nạp VPD CONTEXT nếu user đã đăng nhập
            if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
                String currentUsername = auth.getName();
                
                // FIX LỖI 1: Lấy Role trực tiếp từ Authorities (Luôn đảm bảo IN HOA chuẩn xác)
                String currentRole = auth.getAuthorities().stream()
                        .findFirst()
                        .map(GrantedAuthority::getAuthority)
                        .orElse("");

                // 2. Lấy TeamId từ Claims JWT
                String currentTeamId = null;
                if (auth.getCredentials() instanceof Claims claims) {
                    currentTeamId = claims.get("teamId", String.class);
                }

                // 3. Gắn Context xuống Oracle
                String sqlInit = "CALL SEC_ADMIN.PKG_SPORT_CONTEXT.INITIALIZE_SESSION(?, ?, ?)";
                jdbcTemplate.update(sqlInit, currentUsername, currentRole, currentTeamId);
                isContextSet = true;
                log.debug("VPD INITIALIZED: User={} | Role={} | Team={}", currentUsername, currentRole, currentTeamId);
            }

            // 4. THỰC THI LOGIC NGHIỆP VỤ 
            return joinPoint.proceed();

        } finally {
            // 5. DỌN DẸP BẢO MẬT
            if (isContextSet) {
                jdbcTemplate.update("CALL SEC_ADMIN.PKG_SPORT_CONTEXT.CLEAR_SESSION()");
                log.debug("VPD Context CLEARED.");
            }
        }
    }
}